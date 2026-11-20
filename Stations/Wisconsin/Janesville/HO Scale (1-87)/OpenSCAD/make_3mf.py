#!/usr/bin/env python3
"""Janesville depot (HO 1:87) - turn the print STLs into 3MF files with filaments assigned.

  python3 make_3mf.py <STL folder> <3MF output folder> [group ...] [--manifest-only]

One 3MF per printable section.  Bodies that print together (brick + mortar + stone,
liner + pine boards, floor + dark tiles ...) are parts of ONE object, each part
given its own filament slot (1, 2, 3 ...).  The slot colours are in the part names
and in "3MF filament slots.csv".
"""
import sys, os, re, glob, struct, zipfile, csv, json
import numpy as np

# key: (label, model colour, suggested Bambu PETG HF colour)
PALETTE = {
    "BRICK": ("Brick red",      "#8E3B2C", "Red"),
    "WHITE": ("White",          "#F2EFE6", "White"),
    "CREAM": ("Cream / buff",   "#EFE6CC", "Cream"),
    "GREEN": ("Pullman green",  "#3B4A2C", "Forest Green"),
    "SLATE": ("Slate gray",     "#4B5560", "Dark Gray"),
    "GRAY":  ("Light gray",     "#9A9A9A", "Gray"),
    "BROWN": ("Wood brown",     "#8A5A30", "Peanut Brown"),
    "BLACK": ("Black",          "#151515", "Black"),
    "BRASS": ("Brass",          "#B8923A", "Yellow"),
}
SUFFIX = ["_mortar", "_stone", "_dark", "_pine", "_letters", "_white", "_face", "_black", "_brass"]
HERRING = ("waiting", "passage", "vestibule", "smoking")
WOODFL = ("baggage", "express", "ticket", "trainorder")
QTY = {"Furniture_ticket_clock": 2, "Furniture_bench_double": 6, "Furniture_bench_single": 2,
       "Furniture_radiator": 6, "Furniture_table": 2, "Furniture_sink": 2, "Furniture_toilet": 2,
       "Furniture_mirror": 2, "Furniture_chair": 8, "Furniture_baggage_truck": 2}


def base_of(name):
    if name.startswith("Track_"):
        return "Track"
    for s in SUFFIX:
        if name.endswith(s):
            return name[:-len(s)]
    return name


def colour_of(name):
    b = base_of(name)
    if name.endswith("_mortar") or name.endswith("_white"): return "WHITE"
    if name.endswith("_stone") or name.endswith("_letters") or name.endswith("_face"): return "CREAM"
    if name.endswith("_pine"): return "BROWN"
    if name.endswith("_black"): return "BLACK"
    if name.endswith("_brass"): return "BRASS"
    if name.endswith("_dark"):
        return "SLATE" if b.split("_")[1] in HERRING else "BLACK"
    if name == "Track_ballast": return "GRAY"
    if name == "Track_ties": return "BROWN"
    if name == "Track_rails": return "SLATE"
    if b.startswith("Floor_"):
        r = b.split("_")[1]
        return "BRICK" if r in HERRING else "BROWN" if r in WOODFL else "WHITE"
    if b.startswith(("Foundation", "RoofFrame", "Splices", "Canopy_footings", "People")): return "GRAY"
    if b.startswith(("Wall_", "Gable", "Dormer_cheek", "Dormer_face", "Porch_cheek", "Chimney", "Platform")): return "BRICK"
    if b.startswith(("Window_", "Cornice", "Dormer_", "Sign_")): return "GREEN"
    if b.startswith(("Roof_", "RoofTrim", "Canopy_roof")): return "SLATE"
    if b.startswith("Canopy_"): return "GREEN"
    if b.startswith(("Light_", "Furniture_sink", "Furniture_toilet", "Furniture_kitchen_sink")): return "WHITE"
    if b.startswith(("Ceiling", "Liner_", "Interior_")): return "CREAM"
    if b.startswith(("Electronics", "Furniture_safe", "Furniture_range", "Furniture_bulletin", "Furniture_scale")): return "BLACK"
    if b.startswith("Furniture_radiator"): return "SLATE"
    if b.startswith("Furniture_mirror"): return "GRAY"
    if b.startswith("Furniture_ticket_grilles"): return "BRASS"
    return "BROWN"


def read_stl(path):
    size = os.path.getsize(path)
    with open(path, "rb") as f:
        f.seek(80)
        h = f.read(4)
        n = struct.unpack("<I", h)[0] if len(h) == 4 else 0
        if size == 84 + 50 * n:
            d = np.frombuffer(f.read(n * 50), dtype=np.dtype([("n", "<3f4"), ("v", "<9f4"), ("a", "<u2")]), count=n)
            return d["v"].reshape(-1, 3, 3).astype(np.float64)
    txt = open(path, errors="ignore").read()                # ASCII STL
    v = np.array([float(x) for m in re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", txt) for x in m])
    return v.reshape(-1, 3, 3)


def volume_cm3(tri):
    return abs(float(np.einsum("ij,ij->i", tri[:, 0], np.cross(tri[:, 1], tri[:, 2])).sum()) / 6.0) / 1000.0


def mesh_xml(tri, shift):
    pts = np.round(tri.reshape(-1, 3) + shift, 4)
    v, inv = np.unique(pts, axis=0, return_inverse=True)
    t = inv.reshape(-1, 3)
    t = t[(t[:, 0] != t[:, 1]) & (t[:, 1] != t[:, 2]) & (t[:, 0] != t[:, 2])]
    vs = "".join(['<vertex x="%g" y="%g" z="%g"/>\n' % tuple(r) for r in v.tolist()])
    ts = "".join(['<triangle v1="%d" v2="%d" v3="%d"/>\n' % tuple(r) for r in t.tolist()])
    return "<mesh>\n<vertices>\n" + vs + "</vertices>\n<triangles>\n" + ts + "</triangles>\n</mesh>\n"


CT = ('<?xml version="1.0" encoding="UTF-8"?>\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
      ' <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n'
      ' <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>\n'
      ' <Default Extension="config" ContentType="text/xml"/>\n</Types>\n')
RELS = ('<?xml version="1.0" encoding="UTF-8"?>\n<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        ' <Relationship Target="/3D/3dmodel.model" Id="rel-1" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n</Relationships>\n')


def write_3mf(out, title, bodies, bed):
    """bodies: [(name, colour key, triangles)], slot = position + 1."""
    allp = np.concatenate([b[2].reshape(-1, 3) for b in bodies])
    mn, mx = allp.min(0), allp.max(0)
    shift = np.array([bed[0] / 2 - (mn[0] + mx[0]) / 2, bed[1] / 2 - (mn[1] + mx[1]) / 2, -mn[2]])
    n = len(bodies)
    m = ['<?xml version="1.0" encoding="UTF-8"?>\n<model unit="millimeter" xml:lang="en-US" '
         'xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021">\n'
         ' <metadata name="Application">BambuStudio-01.09.00.00</metadata>\n <metadata name="BambuStudio:3mfVersion">1</metadata>\n'
         ' <metadata name="Title">%s</metadata>\n <resources>\n  <basematerials id="100">\n' % title]
    for name, key, _ in bodies:
        m.append('   <base name="%s" displaycolor="%sFF"/>\n' % (PALETTE[key][0], PALETTE[key][1]))
    m.append("  </basematerials>\n")
    for i, (name, key, tri) in enumerate(bodies):
        m.append('  <object id="%d" name="%s" type="model" pid="100" pindex="%d">\n' % (i + 1, name, i))
        m.append(mesh_xml(tri, shift))
        m.append("  </object>\n")
    m.append('  <object id="%d" name="%s" type="model">\n   <components>\n' % (n + 1, title))
    for i in range(n):
        m.append('    <component objectid="%d"/>\n' % (i + 1))
    m.append('   </components>\n  </object>\n </resources>\n <build>\n  <item objectid="%d" printable="1"/>\n </build>\n</model>\n' % (n + 1))
    c = ['<?xml version="1.0" encoding="UTF-8"?>\n<config>\n <object id="%d">\n  <metadata key="name" value="%s"/>\n'
         '  <metadata key="extruder" value="1"/>\n' % (n + 1, title)]
    for i, (name, key, _) in enumerate(bodies):
        c.append('  <part id="%d" subtype="normal_part">\n   <metadata key="name" value="%s [slot %d - %s]"/>\n'
                 '   <metadata key="matrix" value="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"/>\n   <metadata key="extruder" value="%d"/>\n  </part>\n'
                 % (i + 1, name, i + 1, PALETTE[key][0], i + 1))
    c.append(" </object>\n</config>\n")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
        z.writestr("[Content_Types].xml", CT)
        z.writestr("_rels/.rels", RELS)
        z.writestr("3D/3dmodel.model", "".join(m))
        z.writestr("Metadata/model_settings.config", "".join(c))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    manifest_only = "--manifest-only" in sys.argv
    src, dst, groups = args[0], args[1], args[2:]
    here = os.path.dirname(os.path.abspath(__file__))
    rows = []
    for pdir, tag, bed in (("Bambu P1S", "P1S", (256, 256)), ("Large Format", "GIGA", (780, 780))):
        if groups and groups[0] in ("P1S", "GIGA") and groups[0] != tag:
            continue
        gsel = [g for g in groups if g not in ("P1S", "GIGA")]
        lst = os.path.join(here, "parts_%s.txt" % tag)
        if not os.path.exists(lst):
            continue                                        # HO: Bambu P1S only
        valid = {}
        for line in open(lst):
            p = line.strip().split("|")
            if len(p) == 3:
                valid[p[1]] = int(p[2])
        sets = {}
        for f in sorted(glob.glob(os.path.join(src, pdir, "*", "*.stl"))):
            mm = re.match(r"(.+)_%s_part(\d+)\.stl$" % tag, os.path.basename(f))
            if not mm:
                continue
            name, sec = mm.group(1), int(mm.group(2))
            if not name.startswith("People_") and (name not in valid or sec > valid[name]):
                continue                                    # a left-over from an older version
            grp = os.path.basename(os.path.dirname(f))
            if gsel and grp not in gsel:
                continue
            sets.setdefault((grp, base_of(name), sec), []).append((name, f))
        for (grp, base, sec), items in sorted(sets.items()):
            items.sort(key=lambda it: (it[0] != base, it[0] != "Track_ballast", it[0]))
            bodies = [(nm, colour_of(nm), read_stl(f)) for nm, f in items]
            bodies = [b for b in bodies if len(b[2])]
            fn = "%s_%s_part%02d.3mf" % (base, tag, sec)
            if not manifest_only:
                write_3mf(os.path.join(dst, pdir, grp, fn), "%s part %02d" % (base, sec), bodies, bed)
            for i, (nm, key, tri) in enumerate(bodies):
                rows.append([pdir, grp, fn, base, sec, nm, i + 1, key, PALETTE[key][0], PALETTE[key][2],
                             round(volume_cm3(tri), 2), QTY.get(base, 1)])
            print(fn, len(bodies), flush=True)
    os.makedirs(dst, exist_ok=True)
    tagname = "_".join(groups) if groups else "all"
    with open(os.path.join(dst, "manifest_%s.csv" % tagname), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["printer", "group", "file", "part", "section", "body", "slot", "key", "colour", "bambu_petg_hf", "volume_cm3", "qty"])
        w.writerows(rows)


if __name__ == "__main__":
    main()
