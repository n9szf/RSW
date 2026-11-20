import numpy as np, json, os, struct, sys, collections
sys.path.insert(0, '/home/claude/scad')
import make_3mf as M

def clip(tris, z, above):
    """keep the part above (or below) z; returns (triangles, cut segments)"""
    s = 1.0 if above else -1.0
    out = []; segs = []
    d = (tris[:, :, 2] - z) * s
    for t, dd in zip(tris, d):
        inside = dd >= 0
        n = inside.sum()
        if n == 3: out.append(t); continue
        if n == 0: continue
        poly = []; cut = []
        for i in range(3):
            a, b = t[i], t[(i + 1) % 3]; da, db = dd[i], dd[(i + 1) % 3]
            if da >= 0: poly.append(a)
            if (da >= 0) != (db >= 0):
                p = a + (b - a) * (da / (da - db)); p[2] = z; poly.append(p); cut.append(p)
        for i in range(1, len(poly) - 1): out.append(np.array([poly[0], poly[i], poly[i + 1]]))
        if len(cut) == 2: segs.append((cut[0][:2], cut[1][:2]))
    return (np.array(out) if out else np.zeros((0, 3, 3))), segs

def loops(segs):
    key = lambda p: (round(float(p[0]), 5), round(float(p[1]), 5))
    adj = collections.defaultdict(list); pts = {}
    for a, b in segs:
        ka, kb = key(a), key(b)
        if ka == kb: continue
        adj[ka].append(kb); adj[kb].append(ka); pts[ka] = a; pts[kb] = b
    used = set(); res = []
    for start in list(adj):
        if start in used or len(adj[start]) != 2: continue
        lp = [start]; used.add(start); prev = None; cur = start; ok = True
        while True:
            nx = [k for k in adj[cur] if k != prev]
            if len(adj[cur]) != 2 or not nx: ok = False; break
            n = nx[0]
            if n == start: break
            if n in used: ok = False; break
            lp.append(n); used.add(n); prev, cur = cur, n
        if ok and len(lp) >= 3: res.append(np.array(lp))
    return res

def area(p): return 0.5 * float(np.sum(p[:, 0] * np.roll(p[:, 1], -1) - np.roll(p[:, 0], -1) * p[:, 1]))

def ear(p):
    """ear clipping of a simple CCW polygon -> index triples"""
    idx = list(range(len(p))); tr = []; guard = 0
    def cross(o, a, b): return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
    while len(idx) > 3 and guard < 5000:
        guard += 1; done = False
        for i in range(len(idx)):
            a, b, c = idx[i - 1], idx[i], idx[(i + 1) % len(idx)]
            if cross(p[a], p[b], p[c]) <= 1e-14: continue
            if any(cross(p[a], p[b], p[k]) >= 0 and cross(p[b], p[c], p[k]) >= 0 and cross(p[c], p[a], p[k]) >= 0 for k in idx if k not in (a, b, c)): continue
            tr.append((a, b, c)); idx.pop(i); done = True; break
        if not done: idx.pop(0)
    if len(idx) == 3: tr.append(tuple(idx))
    return tr

def cap(segs, z, up):
    out = []
    for lp in loops(segs):
        p = lp if area(lp) > 0 else lp[::-1]
        for a, b, c in ear(p):
            t = [[p[a][0], p[a][1], z], [p[b][0], p[b][1], z], [p[c][0], p[c][1], z]]
            out.append(t if up else t[::-1])
    return np.array(out) if out else np.zeros((0, 3, 3))

def band(tris, z0, z1):
    t = tris
    if z0 is not None:
        t, s = clip(t, z0, True); t = np.concatenate([t, cap(s, z0, False)])
    if z1 is not None:
        t, s = clip(t, z1, False); t = np.concatenate([t, cap(s, z1, True)])
    return t

def wstl(path, tris):
    d = np.zeros(len(tris), dtype=np.dtype([('n', '<3f4'), ('v', '<9f4'), ('a', '<u2')])); d['v'] = tris.reshape(-1, 9)
    with open(path, 'wb') as o: o.write(b'people'.ljust(80)); o.write(struct.pack('<I', len(tris))); o.write(d.tobytes())

SKIN = [("Skin light", "#F1C9A5"), ("Skin fair", "#E0AC84"), ("Skin tan", "#C68D5E"), ("Skin brown", "#9A6340"), ("Skin dark brown", "#6B4226"), ("Skin deep", "#4A2C1A")]
TOP = [("White shirt", "#ECE8DC"), ("Navy coat", "#1F2A44"), ("Brown jacket", "#6B4A2E"), ("Gray suit", "#6E6E72"), ("Burgundy", "#6E1F2B"), ("Forest green", "#2F4A34"),
       ("Tan coat", "#B79A6B"), ("Blue work shirt", "#4E6C8C"), ("Black coat", "#1C1C1E"), ("Mustard", "#B58A2A"), ("Cream blouse", "#E6D9B8"), ("Rust", "#9A4B2A")]
BOT = [("Charcoal", "#33343A"), ("Dark brown", "#4A3526"), ("Navy", "#232B45"), ("Gray", "#77777A"), ("Black", "#18181A"), ("Khaki", "#9C8A62"), ("Olive", "#4F5536")]
SHOE = [("Black shoes", "#111111"), ("Brown shoes", "#3E2716")]
info = json.load(open('info.json'))
names = ['skin', 'top', 'bottom', 'shoes']
table = []
for i, a in enumerate(info):
    f, short, k = a[0], a[1], a[2]
    tris = np.fromfile('src/' + f, dtype=np.dtype([('n', '<3f4'), ('v', '<9f4'), ('a', '<u2')]), offset=84)['v'].reshape(-1, 3, 3).astype(np.float64) * k
    tris[:, :, 2] -= tris[:, :, 2].min(); H = tris[:, :, 2].max()
    child = 'children' in short
    head = min(0.27, 0.24 * H) if not child else 0.24 * H
    shoe = 0.07 if not child else 0.045
    waist = (0.68 if 'sitting' in short else 0.56 * H); waist = min(waist, H - head - 0.15)
    zs = [(H - head, None), (waist, H - head), (shoe, waist), (None, shoe)]
    cols = [SKIN[(i * 5 + 1) % len(SKIN)], TOP[(i * 7 + 3) % len(TOP)], BOT[(i * 3 + 2) % len(BOT)], SHOE[i % 2]]
    bodies = []
    for nm, (z0, z1), c in zip(names, zs, cols):
        b = band(tris, z0, z1); bodies.append((nm, c, b))
        for root in ('/home/claude/scad', '/home/claude/ho/scad'):
            os.makedirs(root + '/People/bands', exist_ok=True); wstl('%s/People/bands/%s_%s.stl' % (root, short, nm), b)
    table.append((short, [c for _, c, _ in bodies]))
    # G scale 4-colour 3MF
    for nm, c, b in bodies: M.PALETTE['P_' + c[0]] = (c[0], c[1], c[0])
    xy = tris.reshape(-1, 3)
    out = '/home/claude/people/3mf/People_%s_P1S_part01.3mf' % short
    M.write_3mf(out, 'People_%s' % short, [('People_%s_%s' % (short, nm), 'P_' + c[0], b * 1000 / 29) for nm, c, b in bodies if len(b)], (256, 256))
json.dump(table, open('colours.json', 'w'))
print(len(table))
