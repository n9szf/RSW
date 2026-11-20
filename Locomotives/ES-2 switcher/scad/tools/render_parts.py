import bpy, sys, math, json, bmesh, numpy as np
from mathutils import Vector
spec = json.load(open(sys.argv[sys.argv.index("--")+1])); OUTD = sys.argv[sys.argv.index("--")+2]
COL = {"black": ((0.03,0.03,0.028), 0.55, 0.05), "steel": ((0.16,0.15,0.14), 0.35, 0.85), "brass": ((0.6,0.42,0.18), 0.3, 1.0),
       "red": ((0.75,0.02,0.02), 0.35, 0.2), "zinc": ((0.55,0.56,0.58), 0.3, 0.9), "frame": ((0.08,0.08,0.075), 0.6, 0.05)}
def mat(k):
    if k in bpy.data.materials: return bpy.data.materials[k]
    m = bpy.data.materials.new(k); m.use_nodes = True; b = m.node_tree.nodes["Principled BSDF"]; c, r, me = COL[k]
    b.inputs["Base Color"].default_value = (*c, 1); b.inputs["Roughness"].default_value = r; b.inputs["Metallic"].default_value = me; return m
def load(f, k, off):
    d = open(f, "rb").read(); n = int(np.frombuffer(d[80:84], np.uint32)[0])
    rec = np.frombuffer(d[84:84+n*50], dtype=np.dtype([("n","<f4",3),("v","<f4",(3,3)),("a","<u2")]))
    u, inv = np.unique(np.round(rec["v"].reshape(-1,3), 4), axis=0, return_inverse=True)
    me = bpy.data.meshes.new(f); me.from_pydata((u + np.array(off)).tolist(), [], inv.reshape(-1,3).tolist()); me.materials.append(mat(k))
    o = bpy.data.objects.new(f, me); bpy.context.scene.collection.objects.link(o); return o
for job in spec:
    bpy.ops.wm.read_factory_settings(use_empty=True); sc = bpy.context.scene
    objs = [load(f, k, off) for f, k, off in job["parts"]]
    pts = np.vstack([np.array([v.co[:] for v in o.data.vertices]) for o in objs])
    lo, hi = Vector(pts.min(0)), Vector(pts.max(0)); c = (lo + hi) / 2; size = (hi - lo).length
    bpy.ops.mesh.primitive_plane_add(size=size * 30, location=(c.x, c.y, lo.z - 0.01)); bpy.context.object.data.materials.append(mat("zinc"))
    bpy.context.object.data.materials[0] = bpy.data.materials.new("floor"); fm = bpy.context.object.data.materials[0]; fm.use_nodes = True
    fm.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value = (0.6,0.6,0.62,1)
    w = bpy.data.worlds.new("w"); sc.world = w; w.use_nodes = True; bg = w.node_tree.nodes["Background"]; bg.inputs[0].default_value = (0.92,0.93,0.96,1); bg.inputs[1].default_value = 0.7
    for loc, e in (((1.2, -1.0, 1.4), 3.0), ((-1.2, 0.8, 0.9), 1.2), ((0.2, 1.4, -0.3 if job.get("under") else 0.5), 0.6)):
        l = bpy.data.lights.new("L", "AREA"); l.size = size * 1.5; l.energy = e * size * size * 2.2
        o = bpy.data.objects.new("L", l); sc.collection.objects.link(o); o.location = c + Vector(loc) * size * 1.3
        o.rotation_euler = (c - o.location).to_track_quat("-Z", "Y").to_euler()
    cam = bpy.data.objects.new("cam", bpy.data.cameras.new("cam")); sc.collection.objects.link(cam); sc.camera = cam; cam.data.lens = 70; cam.data.clip_start = 1
    sc.render.engine = "CYCLES"; sc.cycles.samples = 128; sc.cycles.use_denoising = False
    sc.render.resolution_x, sc.render.resolution_y = 1400, 900
    try: sc.view_settings.view_transform = "AgX"
    except Exception: pass
    for vname, az, el in job["views"]:
        a, e = math.radians(az), math.radians(el); d = size * job.get("dist", 1.9)
        cam.location = c + Vector((d*math.cos(e)*math.cos(a), d*math.cos(e)*math.sin(a), d*math.sin(e)))
        cam.rotation_euler = (c - cam.location).to_track_quat("-Z", "Y").to_euler()
        sc.render.filepath = f"{OUTD}/{job['name']}_{vname}.png"; bpy.ops.render.render(write_still=True)
