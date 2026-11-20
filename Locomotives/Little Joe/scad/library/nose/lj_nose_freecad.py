"""lj_nose_freecad.py - Milwaukee Road Little Joe: the NOSE, built in FreeCAD (Rib Side Works).

OpenSCAD builds everything else; it cannot make smooth blended curves, so the nose (from the windshield forward) is lofted
here and exported as STL shells that scad/library/lj_body.scad imports for the two end sections.

Every size comes from lj_params.scad (read by this script) - change a number there, then run this again.

For each scale (G, O, HO) it writes, next to this script:
    lj_nose_<S>.stl          the finished NOSE PRINT (two per loco): shell, headlight hood, corner boxes, headlight,
                             nose-door groove, number boards, two screw bosses; cut square at the cab front
    lj_nose_values.scad      where the headlight hood is (for the preview lens)
The +x nose, in loco coordinates (model mm, rail top z = 0, loco centre x = 0); OpenSCAD places and mirrors it.
OpenSCAD only imports it - no cutting or merging - so it works in OpenSCAD 2021 too.

Run with FreeCAD's command-line program (no window):
    Windows: "C:\\Program Files\\FreeCAD 1.0\\bin\\FreeCADCmd.exe" lj_nose_freecad.py      (Shops: Processed / Make Little Joe nose.bat)
    Linux:   freecadcmd lj_nose_freecad.py
Options after the script name: G O HO (default all three).
"""
import os, re, sys, math

# FreeCADCmd does not always set __file__: find this script in the command line instead
_me = [a for a in sys.argv if a.lower().endswith("lj_nose_freecad.py")]
HERE = os.path.dirname(os.path.abspath(_me[0] if _me else globals().get("__file__", "lj_nose_freecad.py")))
PARAMS = os.path.join(HERE, "..", "lj_params.scad")

import FreeCAD, Part, Mesh, MeshPart
from FreeCAD import Vector as V

# ------------------------------------------------------------------ read lj_params.scad
txt = open(PARAMS, encoding="utf-8").read()
def num(name):
    m = re.search(r"^\s*" + name + r"\s*=\s*([-0-9.+*/ ()]+);", txt, re.M)
    if not m: sys.exit("lj_params.scad has no number for " + name)
    return float(eval(m.group(1)))
def vec(name):
    m = re.search(r"^\s*" + name + r"\s*=\s*\[([^\]]*)\]", txt, re.M)
    if not m: sys.exit("lj_params.scad has no list for " + name)
    return [float(eval(v)) for v in m.group(1).split(",")]
# the scale rows: ["G", 29, 45.0, wall, ...]
SCALES = {}
for m in re.finditer(r'^\s*(\["(G|O|HO)",.*\])\s*,?\s*$', txt, re.M):
    row = eval(m.group(1))         # ["G", 29, 45.0, wall, frame, [pilot, clear, head], [boss, boss h], ..., fit]
    SCALES[row[0]] = dict(ratio=float(row[1]), wall=float(row[3]), screw=row[5], boss=row[6], fit=float(row[12]))

BODY_L, BODY_W, DECK = num("BODY_L_IN"), num("BODY_W_IN"), num("DECK_IN")
NOSE_L, PLAN_D, PLAN_N = num("NOSE_L_IN"), num("NOSE_PLAN_D_IN"), num("NOSE_PLAN_N")
TOP, TOP_FRONT = num("NOSE_TOP_IN"), num("NOSE_TOP_FRONT_IN")
R_TIP, R_CAB = vec("NOSE_SHOULDER_R_IN"); R_POW = num("NOSE_SHOULDER_POW")
LEAN = num("NOSE_LEAN_IN")
HL_Z = num("HEADLIGHT_Z_IN"); HOOD = vec("HL_HOOD_IN")          # [diameter, length, stands out]
CBOX = vec("CLASS_BOX_IN")                                      # [width, height, stands out, y from centre, bottom]
BOSS_D = num("NOSE_BOSS_D_IN")
DOOR = vec("NOSE_DOOR_IN")                                      # [width, height, sill]
PANEL = vec("NOSE_PANEL")                                       # number board [d from, d to, z from, z to]

# ------------------------------------------------------------------ the nose, in prototype inches
def half_width(d):            # plan: full width, corners rounded over the last PLAN_D (squarish curve)
    if d >= PLAN_D: return BODY_W / 2
    u = (PLAN_D - d) / PLAN_D
    return BODY_W / 2 * max(0.0, 1 - u ** PLAN_N) ** (1 / PLAN_N)
def top_at(d):                # the nose top drops toward the front, then rounds over the front (side view)
    zt = TOP_FRONT + (TOP - TOP_FRONT) * min(1.0, d / NOSE_L)
    if d < R_TIP: zt = zt - R_TIP + math.sqrt(max(0.0, R_TIP ** 2 - (R_TIP - d) ** 2))
    return zt
def round_at(d):              # the round from the top onto the sides: big at the tip, dying out at the windshield
    return R_CAB + (R_TIP - R_CAB) * (1 - min(1.0, d / NOSE_L)) ** R_POW

D_STATIONS = [NOSE_L + 8, NOSE_L, 70, 58, 47, 38, 30, 23, 17, 12, 8, 5, 3, 1.6, 0.8, 0.25]   # inches back from the tip

def build(S):
    sc = SCALES[S]; k = 25.4 / sc["ratio"]; p = lambda i: i * k
    HL = p(BODY_L / 2); zd = p(DECK); zb = zd - p(8)                 # sections reach 8 in below the deck
    Hz = p(TOP + 8) - zd; L = p(LEAN)

    def make_body(off):       # the nose, moved in by off (mm) all round - lofted the same way (OCC offsets of this fail)
        wires = []
        for d in D_STATIONS:
            x = HL - p(d) - off
            w = max(p(half_width(d)) - off, p(0.6))
            zt = p(top_at(d)) - off
            r = max(0.4, min(p(round_at(d)) - off, w - p(1), (zt - zb) * 0.9))     # never a tiny arc or a tiny top line (they crack the mesh)
            P = lambda y, z: V(x, y, z)
            c = r * (1 - math.sqrt(0.5))
            e = [Part.LineSegment(P(-w, zb), P(w, zb)), Part.LineSegment(P(w, zb), P(w, zt - r)),
                 Part.Arc(P(w, zt - r), P(w - c, zt - c), P(w - r, zt))]
            if w - r > 1e-3: e.append(Part.LineSegment(P(w - r, zt), P(-(w - r), zt)))
            e += [Part.Arc(P(-(w - r), zt), P(-(w - c), zt - c), P(-w, zt - r)), Part.LineSegment(P(-w, zt - r), P(-w, zb))]
            wires.append(Part.Wire([Part.Edge(g) for g in e]))
        body = Part.makeLoft(wires, True, False)                      # solid, smooth
        m = FreeCAD.Matrix(); m.A13 = -L / Hz; m.A14 = L * zd / Hz    # the front leans back: shear x by height (nose_lean())
        body = body.transformGeometry(m)
        print(f"  {S}: nose moved in {off:.2f} mm - valid {body.isValid()}, volume {body.Volume:.0f} mm3")
        return body

    body = make_body(0.0)

    def front_x(y, z):        # where the nose surface is, looking back along x at (y, z)
        probe = Part.Edge(Part.LineSegment(V(HL + p(60), y, z), V(HL - p(NOSE_L), y, z)))
        cut = body.common(probe)
        return max(v.Point.x for v in cut.Vertexes) if cut.Vertexes else None

    extras = []
    # headlight hood: a round hood standing out of the rounded top-front, no taller than just over the nose top
    zh = p(HL_Z); xf = front_x(0, zh) + p(HOOD[2])
    hood = Part.makeCylinder(p(HOOD[0]) / 2, p(HOOD[1]), V(xf, 0, zh), V(-1, 0, 0))
    hood = hood.common(Part.makeBox(p(200), p(200), p(TOP_FRONT + 2), V(HL - p(150), -p(100), 0)))
    extras.append(hood)
    # raised boxes on the front corners, facing forward
    bw, bh, bo, by, bz = [p(v) for v in CBOX]
    for sy in (-1, 1):
        yi = sy * (by - bw / 2); xb = front_x(yi, bz + bh / 2) + bo
        box = Part.makeBox(p(24), bw, bh, V(xb - p(24), sy * by - bw / 2, bz))
        f = max(0.4, p(1.5))
        lens = Part.makeBox(p(2), bw - 2 * f, bh - 2 * f, V(xb - max(0.4, p(1)), sy * by - bw / 2 + f, bz + f))
        extras.append(box.cut(lens))
    outer = body
    for x in extras: outer = outer.fuse(x)
    lamp = Part.makeCylinder(p(12) / 2, p(4) + 1, V(xf + 1, 0, zh), V(-1, 0, 0))
    outer = outer.cut(lamp).removeSplitter()

    wall = sc["wall"]; dep = wall * 0.45
    inner = make_body(wall); skin = outer.cut(make_body(dep))          # skin: the outer dep of the surface
    shell = outer.cut(inner)
    # nose door: an outline groove in the middle of the front
    dw, dh, dz = p(DOOR[0]), p(DOOR[1]), p(DOOR[2]); g = max(0.35, p(0.75))
    ring = Part.makeBox(p(30), dw, dh, V(HL - p(25), -dw / 2, dz)).cut(Part.makeBox(p(32), dw - 2 * g, dh - 2 * g, V(HL - p(26), -dw / 2 + g, dz + g)))
    shell = shell.cut(ring.common(skin))
    # number boards: recessed panels on the nose sides
    for sy in (-1, 1):
        pb = Part.makeBox(p(PANEL[1] - PANEL[0]), p(BODY_W / 2) + 1, p(PANEL[3] - PANEL[2]),
                          V(HL - p(PANEL[1]), 0 if sy > 0 else -p(BODY_W / 2) - 1, p(PANEL[2])))
        shell = shell.cut(pb.common(skin))
    # screw bosses inside each side wall (self-tapping screws up through the frame, as the body)
    b, bh = sc["boss"]; pilot = sc["screw"][0]
    for sy in (-1, 1):
        yb = sy * (p(BODY_W / 2) - wall - b / 2 + 0.01)
        boss = Part.makeBox(b, b + 0.6, bh, V(HL - p(BOSS_D) - b / 2, yb - b / 2 - (0 if sy > 0 else 0.6), zd))
        boss = boss.common(make_body(wall * 0.5)).cut(Part.makeCylinder(pilot / 2, bh + 1, V(HL - p(BOSS_D), yb, zd - 0.5)))
        shell = shell.fuse(boss)
    # the joint with the body: cut square at the cab front, and flat at the deck
    xj = HL - p(NOSE_L)
    shell = shell.common(Part.makeBox(p(200), p(200), p(200), V(xj, -p(100), zd))).removeSplitter()
    print(f"  {S}: nose print valid {shell.isValid()}, volume {shell.Volume:.0f} mm3")
    mesh = MeshPart.meshFromShape(Shape=shell, MaxLength=max(p(2.5), 0.5))   # Mefisto: even triangles, none of zero area
    mesh.removeDuplicatedPoints(); mesh.removeDuplicatedFacets(); mesh.harmonizeNormals()
    if not mesh.isSolid(): print(f"  WARNING {S}: nose mesh is not closed - tell Claude")
    fn = os.path.join(HERE, f"lj_nose_{S}.stl"); mesh.write(fn)
    print(f"  {S}: {mesh.CountFacets} facets -> {os.path.basename(fn)}")
    print(f"  {S}: headlight hood front at x = {xf:.2f} mm (loco centre 0), tip at {HL:.2f} mm")
    return xf

args = [a for a in sys.argv[1:] if a in SCALES]
todo = args or ["G", "O", "HO"]
print("Little Joe nose (FreeCAD", ".".join(FreeCAD.Version()[:3]) + "):", ", ".join(todo))
VALS = os.path.join(HERE, "lj_nose_values.scad")
hood = {}
if os.path.exists(VALS):                      # keep the scales not rebuilt this time
    for m in re.finditer(r'\["(G|O|HO)",\s*([-0-9.]+)\]', open(VALS).read()): hood[m.group(1)] = float(m.group(2))
for S in todo:
    hood[S] = build(S)
with open(VALS, "w") as f:
    f.write("// written by lj_nose_freecad.py - where the headlight hood front is (model mm, +x nose), per scale\n")
    f.write("FC_HOOD_X = [" + ", ".join(f'["{S}", {hood[S]:.3f}]' for S in ("G", "O", "HO") if S in hood) + "];\n")
print("done")
