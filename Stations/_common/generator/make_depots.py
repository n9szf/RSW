import sys, json, os, subprocess
sys.path.insert(0, '/tmp/gen'); from stations import S
ROOT = '/mnt/user-data/outputs/stations_lib/Stations'
def lit(v): return json.dumps(v).replace('null', 'undef')
COLS = json.load(open('/tmp/gen/colours.json'))
CUSTOM = {'Columbus'}   # hand-built files - do not overwrite
for key, d in S.items():
    if key in CUSTOM: continue
    if key in COLS:
        c = COLS[key]; d['coltxt'] = '// COLOURS measured from photos 24 Nov 2026: ' + c['note'] + '\n' + ''.join(f'{k} = "{v}";\n' for k, v in c['set'].items())
    b0=d['blocks'][0]; ridge=max(b[4]+b[5]*min(b[1],b[3])/2 for b in d['blocks'])
    d['chims']=[[c[0],c[1],max(c[2],ridge+3)] for c in d.get('chims',[])]
    folder = os.path.join(ROOT, d['folder']); os.makedirs(folder + '/OpenSCAD', exist_ok=True); os.makedirs(folder + '/Notes', exist_ok=True); os.makedirs(folder + '/Reference', exist_ok=True)
    fn = key + ('_House.scad' if 'freight' in key else '_Depot.scad')
    fn = fn.replace('Walworth_freight_House', 'Walworth_Freight_House')
    d['file'] = fn
    txt = f"""// =====================================================================
//  MILWAUKEE ROAD - {d['title'].upper()}
//  Source: {d['src']}.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): {d['known']}.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
{d.get('coltxt', '')}
depot(blocks = {lit(d['blocks'])},
      pavs   = {lit(d.get('pavs', []))},
      wins   = {lit(d.get('wins', []))},
      doors  = {lit(d.get('doors', []))},
      bays   = {lit(d.get('bays', []))},
      chims  = {lit(d.get('chims', []))},
      plat   = {lit(d.get('plat', 0))});
"""
    open(os.path.join(folder, 'OpenSCAD', fn), 'w').write(txt)
json.dump({k: {kk: v[kk] for kk in ('folder', 'file', 'title', 'src', 'known', 'miles')} for k, v in S.items()}, open('/tmp/gen/index.json', 'w'), indent=1)
print(len(S), 'stations')
