"""make_3mf.py - build Bambu Studio 3MF files (one per print) from colour-split STLs.
Filament slots: 1 maroon, 2 orange, 3 black, 4 white. Bed: H2D 350 x 320, plate centred."""
import sys, os, zipfile, io
import numpy as np, trimesh

STL = sys.argv[1]; OUT = sys.argv[2]
SLOT = {"maroon": 1, "orange": 2, "black": 3, "white": 4}
COLOUR = {"maroon": "#9D2235", "orange": "#FF6A13", "black": "#000000", "white": "#FFFFFF"}
BED = (350.0, 320.0)

# objects per print: (object name, [(part name, colour), ...])
PRINTS = {
    "ES2_03_hood_1": [("Hood 1", ["maroon", "orange"]), ("Hood 1 black parts (headlight tower, bell)", ["black"]),
                      ("Hood 1 white parts (lens, 8 railing posts)", ["white"])],
    "ES2_04_hood_2": [("Hood 2", ["maroon", "orange"]), ("Hood 2 black parts (headlight tower, pole mast)", ["black"]),
                      ("Hood 2 white parts (lens, 8 railing posts)", ["white"])],
    "ES2_05_cab":    [("Cab", ["maroon", "orange"]), ("Roof and slider", ["black"])],
}
SRC = {"ES2_03_hood_1": "hood_1", "ES2_04_hood_2": "hood_2", "ES2_05_cab": "cab"}

def mesh_xml(m):
    v = "".join('<vertex x="%.4f" y="%.4f" z="%.4f"/>' % tuple(p) for p in m.vertices)
    t = "".join('<triangle v1="%d" v2="%d" v3="%d"/>' % tuple(f) for f in m.faces)
    return "<mesh><vertices>%s</vertices><triangles>%s</triangles></mesh>" % (v, t)

def build(name):
    objs = [(on, [(c, trimesh.load(os.path.join(STL, f"{SRC[name]}_{c}.stl"))) for c in cols]) for on, cols in PRINTS[name]]
    allv = np.vstack([m.vertices for _, parts in objs for _, m in parts])
    lo, hi = allv.min(0), allv.max(0)
    size = hi - lo
    assert size[0] <= BED[0] - 10 and size[1] <= BED[1] - 10, f"{name} does not fit: {size}"
    shift = np.array([BED[0] / 2 - (lo[0] + hi[0]) / 2, BED[1] / 2 - (lo[1] + hi[1]) / 2, -lo[2]])
    res, items, cfg, oid = [], [], [], 0
    for on, parts in objs:
        ids = []
        for c, m in parts:
            oid += 1; ids.append((oid, c))
            res.append('<object id="%d" type="model">%s</object>' % (oid, mesh_xml(m)))
        oid += 1; comp = oid
        res.append('<object id="%d" type="model"><components>%s</components></object>' %
                   (comp, "".join('<component objectid="%d"/>' % i for i, _ in ids)))
        items.append('<item objectid="%d" transform="1 0 0 0 1 0 0 0 1 %.3f %.3f %.3f" printable="1"/>' % (comp, *shift))
        part_cfg = "".join('<part id="%d" subtype="normal_part"><metadata key="name" value="%s"/><metadata key="extruder" value="%d"/></part>'
                           % (i, c, SLOT[c]) for i, c in ids)
        cfg.append('<object id="%d"><metadata key="name" value="%s"/><metadata key="extruder" value="%d"/>%s</object>'
                   % (comp, on, SLOT[ids[0][1]], part_cfg))
    model = ('<?xml version="1.0" encoding="UTF-8"?>\n<model unit="millimeter" xml:lang="en-US" '
             'xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">'
             '<metadata name="Title">%s (ES-2 E82, maroon scheme)</metadata><metadata name="Designer">Rib Side Works</metadata>'
             '<metadata name="Application">BambuStudio-01.10.00.00</metadata>'
             '<resources>%s</resources><build>%s</build></model>') % (name, "".join(res), "".join(items))
    config = '<?xml version="1.0" encoding="UTF-8"?>\n<config>%s</config>' % "".join(cfg)
    ct = ('<?xml version="1.0" encoding="UTF-8"?>\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
          '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
          '<Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>'
          '<Default Extension="config" ContentType="text/xml"/></Types>')
    rels = ('<?xml version="1.0" encoding="UTF-8"?>\n<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Target="/3D/3dmodel.model" Id="rel-1" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>')
    path = os.path.join(OUT, f"{name}_E82_maroon.3mf")
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", ct); z.writestr("_rels/.rels", rels)
        z.writestr("3D/3dmodel.model", model); z.writestr("Metadata/model_settings.config", config)
    print(name, "size %.0f x %.0f x %.0f mm" % tuple(size), "->", path)

for n in PRINTS: build(n)
