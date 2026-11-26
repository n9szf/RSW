import sys, json, os
sys.path.insert(0, '/tmp/gen'); from stations import S; from leads import L
ROOT = '/mnt/user-data/outputs/stations_lib/Stations'
for key, d in S.items():
    f = os.path.join(ROOT, d['folder']); fn = [x for x in os.listdir(f + '/OpenSCAD')][0]; n = fn[:-5]
    leads = L.get(key, [])
    t = f"""# {d['title']}

Milwaukee Road (C.M.&St.P.) depot. Folder made 24 Nov 2026.
Source drawing: {d['src']}. Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
{'About ' + str(d['miles']) + ' miles from Madison.' if d['miles'] else 'Location to confirm.'}

## From the drawing
{d['known']}.

## Files
- OpenSCAD / {fn}: FIRST SHAPE MODEL. Built with the shared depot builder (Stations / _common / rsw_depot.scad), in colour via PAINTS so make_glb.py makes a coloured .glb. SCALE 29 = G, 48 = O, 87 = HO. Not cut into print sections yet.
- Notes / {n}_review.png: track side and town side.
- Blender / GLB / stations / {n}.glb: the 3D file, made by 'Make station GLBs.bat'.
- Reference: photos (links below - Claude cannot download them; save any you want into this folder).

## Estimates in the model
Wall and ridge heights where not written on the sheet, window count and spacing, door panels, colours (Milwaukee Road depot colours still to confirm).

## Photo leads
""" + ("\n".join("- " + x for x in leads) if leads else "- None found yet. Try the Wisconsin Historical Society image search (wisconsinhistory.org, search the town name + depot), rrpicturearchives.net and railpictures.net, and the MRHA.") + "\n"
    open(os.path.join(f, 'README.md'), 'w').write(t)
print('ok')
