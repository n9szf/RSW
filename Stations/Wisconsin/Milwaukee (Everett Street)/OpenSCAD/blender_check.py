# Low-res Cycles check renders of the per-colour STLs (feet).  blender -b -P blender_check.py -- <stl dir> <out dir> <samples> <w> <h> view...
import bpy, sys, os, math
a = sys.argv[sys.argv.index("--") + 1:]
STL, OUT, S, W, H = a[0], a[1], int(a[2]), int(a[3]), int(a[4]); VIEWS = a[5:]
os.makedirs(OUT, exist_ok=True); FT = 0.3048
bpy.ops.wm.read_factory_settings(use_empty=True); sc = bpy.context.scene
def mat(name, col, rough=0.6, metal=0.0, emit=0.0, trans=0.0, alpha=1.0):
    m = bpy.data.materials.new(name); m.use_nodes = True; b = m.node_tree.nodes["Principled BSDF"]
    b.inputs["Base Color"].default_value = (*col, 1); b.inputs["Roughness"].default_value = rough; b.inputs["Metallic"].default_value = metal
    if trans: b.inputs["Transmission Weight"].default_value = trans
    if emit: b.inputs["Emission Color"].default_value = (*col, 1); b.inputs["Emission Strength"].default_value = emit
    return m
M = {"r_brick": mat("brick", (0.36, 0.09, 0.06), 0.85), "r_stone": mat("stone", (0.62, 0.5, 0.34), 0.75), "r_plaster": mat("plaster", (0.66, 0.55, 0.38), 0.8),
     "r_wood": mat("wood", (0.13, 0.06, 0.025), 0.35), "r_metal": mat("metal", (0.05, 0.05, 0.05), 0.4, 0.6), "r_stained": mat("stained", (0.85, 0.45, 0.12), 0.2, 0, 3.0),
     "r_glass": mat("glass", (0.75, 0.82, 0.85), 0.05, 0, 0, 1.0), "r_floor": mat("floor", (0.42, 0.33, 0.24), 0.3), "r_roof": mat("slate", (0.1, 0.11, 0.13), 0.7),
     "r_ground": mat("ground", (0.25, 0.25, 0.23), 0.9), "r_lamp": mat("lamp", (1.0, 0.85, 0.6), 0.3, 0, 25.0),
     "r_frosted": mat("frosted", (0.85, 0.88, 0.88), 0.55, 0, 0.4, 0.8), "r_gilt": mat("gilt", (0.83, 0.62, 0.2), 0.25, 1.0), "r_dial": mat("dial", (0.95, 0.93, 0.86), 0.5, 0, 0.6, 0.5),
     "r_iron": mat("iron", (0.07, 0.08, 0.08), 0.5, 0.3), "r_shedroof": mat("tarroof", (0.035, 0.035, 0.04), 0.8), "r_ballast": mat("ballast", (0.2, 0.19, 0.17), 0.95),
     "r_tie": mat("tie", (0.09, 0.065, 0.045), 0.9), "r_rail": mat("rail", (0.25, 0.22, 0.2), 0.35, 0.9), "r_platform": mat("platform", (0.3, 0.24, 0.17), 0.8),
     "r_white": mat("white", (0.85, 0.85, 0.82), 0.6), "r_trunk": mat("trunk", (0.25, 0.13, 0.05), 0.5), "r_tin": mat("tin", (0.7, 0.7, 0.68), 0.25, 1.0),
     "r_concrete": mat("concrete", (0.45, 0.44, 0.4), 0.9), "r_dynamo": mat("dynamo", (0.05, 0.12, 0.06), 0.3, 0.2), "r_belt": mat("belt", (0.1, 0.05, 0.02), 0.6),
     "r_coal": mat("coal", (0.015, 0.015, 0.015), 0.6), "r_paving": mat("paving", (0.2, 0.19, 0.17), 0.85), "r_sidewalk": mat("sidewalk", (0.45, 0.42, 0.37), 0.85),
     "r_grass": mat("grass", (0.08, 0.17, 0.04), 0.9), "r_gravel": mat("gravel", (0.5, 0.45, 0.35), 0.9), "r_water": mat("water", (0.1, 0.18, 0.25), 0.05, 0, 0, 0.6),
     "r_bark": mat("bark", (0.12, 0.08, 0.05), 0.9), "r_tree": mat("leaves", (0.07, 0.16, 0.04), 0.8), "r_brick2": mat("brick2", (0.3, 0.12, 0.08), 0.85),
     "r_cream": mat("creambrick", (0.6, 0.5, 0.33), 0.85)}
for f in sorted(os.listdir(STL)):
    g = f[:-4]
    if not f.endswith(".stl") or g not in M: continue
    bpy.ops.wm.stl_import(filepath=os.path.join(STL, f), global_scale=FT)
    o = bpy.context.selected_objects[0]; o.name = g; o.data.materials.clear(); o.data.materials.append(M[g])
w = bpy.data.worlds.new("sky"); sc.world = w; w.use_nodes = True; bg = w.node_tree.nodes["Background"]
bg.inputs["Color"].default_value = (0.55, 0.65, 0.8, 1); bg.inputs["Strength"].default_value = 0.6
sun = bpy.data.objects.new("sun", bpy.data.lights.new("sun", "SUN")); sc.collection.objects.link(sun)
sun.data.energy = 3.0; sun.rotation_euler = (math.radians(55), 0, math.radians(200))
sc.render.engine = "CYCLES"; sc.cycles.device = "CPU"; sc.cycles.samples = S; sc.cycles.use_denoising = False; sc.cycles.max_bounces = 4
sc.render.resolution_x, sc.render.resolution_y = W, H; sc.view_settings.view_transform = "AgX"
cam = bpy.data.objects.new("cam", bpy.data.cameras.new("cam")); sc.collection.objects.link(cam); sc.camera = cam
cam.data.lens = 18; cam.data.clip_start = 0.05
for v in VIEWS:
    name, ex, ey, ez, tx, ty, tz = v.split(","); ex, ey, ez, tx, ty, tz = map(float, (ex, ey, ez, tx, ty, tz))
    from mathutils import Vector
    cam.location = Vector((ex, ey, ez)) * FT
    d = Vector((tx - ex, ty - ey, tz - ez)); cam.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()
    sc.render.filepath = os.path.join(OUT, name + ".png"); bpy.ops.render.render(write_still=True); print("done", name, flush=True)
