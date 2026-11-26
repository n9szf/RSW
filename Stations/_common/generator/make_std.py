import sys, json, os
sys.path.insert(0, '/tmp/gen'); from std import D
ROOT = '/mnt/user-data/outputs/stations_lib/Stations'
def lit(v): return json.dumps(v).replace('null', 'undef')
out = []
for n, d in D.items():
    ridge = max(b[4] + b[5] * min(b[1], b[3]) / 2 for b in d['blocks'])
    d['chims'] = [[c[0], c[1], max(c[2], ridge + 3)] for c in d['chims']]
    f = os.path.join(ROOT, d['folder']); os.makedirs(f + '/OpenSCAD', exist_ok=True); os.makedirs(f + '/Notes', exist_ok=True)
    fn = f"Standard_{n}_Depot.scad"
    t = f"""// =====================================================================
//  MILWAUKEE ROAD - {d['title'].upper()}
//  Album of Depot Plans (1919), sheet {n}{' (and sheet 15, the plans)' if n == '14' else ''}. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): {d['known']}.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = {lit(d['blocks'])},
      pavs   = {lit(d['pavs'])},
      wins   = {lit(d['wins'])},
      doors  = {lit(d['doors'])},
      bays   = {lit(d['bays'])},
      chims  = {lit(d['chims'])},
      plat   = {lit(d['plat'])});
"""
    open(os.path.join(f, 'OpenSCAD', fn), 'w').write(t)
    open(os.path.join(f, 'README.md'), 'w').write(f"""# {d['title']}

Milwaukee Road standard depot plan from the 1919 Album of Depot Plans, sheet {n}{' (elevation; the plans are on sheet 15)' if n == '14' else ''}.
Drawing (private, in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.

## From the sheet
{d['known']}.

## Files
- OpenSCAD / {fn}: FIRST SHAPE MODEL with the shared depot builder (Stations / _common / rsw_depot.scad), coloured for make_glb.py. SCALE 29 G, 48 O, 87 HO.
- Notes / Standard_{n}_Depot_review.png
- Blender / GLB / stations / Standard_{n}_Depot.glb

Estimates: heights (the album copies are small), window spacing, colours. A standard plan, so one model can stand in for any of the towns listed above.
""")
    out.append(os.path.join(f, 'OpenSCAD', fn))
f15 = os.path.join(ROOT, 'Standard depots/Sheet 15 - 24x60 depot with living rooms, plans'); os.makedirs(f15, exist_ok=True)
open(f15 + '/README.md', 'w').write("# Sheet 15 - 24 x 60 ft depot with living rooms, plans\n\nThe floor plans for sheet 14. The model is in Standard depots / Sheet 14 - 24x60 depot with living rooms, elevation.\n")
print('\n'.join(out))
