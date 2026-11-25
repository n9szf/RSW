# Everett Street 1886 -> one GLB (metres, Y-up), one object per material group.  blender -b -P make_everett_glb.py -- <stl dir> <movie.py> <out.glb>
import bpy, sys, os, glob, re
a = sys.argv[sys.argv.index("--") + 1:]; STL, MOV, OUT = a
src = open(MOV).read()
COL = {}
for m in re.finditer(r'"(r_\w+)": mat\("\w+", \(([\d.]+), ([\d.]+), ([\d.]+)\)(?:, ([\d.]+))?(?:, ([\d.]+))?', src):
    COL[m.group(1)] = (tuple(float(m.group(i)) for i in (2, 3, 4)), float(m.group(5) or 0.6), float(m.group(6) or 0))
bpy.ops.wm.read_factory_settings(use_empty=True)
FT = 0.3048
for f in sorted(glob.glob(os.path.join(STL, "*.stl"))):
    g = os.path.basename(f)[:-4]
    bpy.ops.wm.stl_import(filepath=f, global_scale=FT)
    o = bpy.context.selected_objects[0]; o.name = g.replace("r_", "")
    me = o.data; me.polygons.foreach_set("use_smooth", [False] * len(me.polygons))
    c, r, mt = COL.get(g, ((0.5, 0.5, 0.5), 0.6, 0))
    mat = bpy.data.materials.new(o.name); mat.use_nodes = True
    b = mat.node_tree.nodes["Principled BSDF"]; b.inputs["Base Color"].default_value = (*c, 1); b.inputs["Roughness"].default_value = r; b.inputs["Metallic"].default_value = mt
    if g == "r_glass": b.inputs["Alpha"].default_value = 0.35; mat.blend_method = "BLEND"
    if g in ("r_lamp",): b.inputs["Emission Color"].default_value = (*c, 1); b.inputs["Emission Strength"].default_value = 2
    me.materials.append(mat)
    bpy.context.view_layer.objects.active = o; bpy.ops.object.mode_set(mode="EDIT"); bpy.ops.mesh.select_all(action="SELECT")
    bpy.ops.mesh.remove_doubles(threshold=0.0005); bpy.ops.object.mode_set(mode="OBJECT")
    print(g, len(me.polygons), flush=True)
bpy.ops.export_scene.gltf(filepath=OUT, export_format="GLB", export_draco_mesh_compression_enable=True, export_draco_mesh_compression_level=7, export_apply=True)
print("wrote", OUT, os.path.getsize(OUT) // 1024, "KB")
