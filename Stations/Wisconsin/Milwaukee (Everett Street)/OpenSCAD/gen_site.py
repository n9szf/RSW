# Site for the Everett Street depot full-size model (TDQ-575 steps 4-5): train shed (as-built truss, MPL #28; extent from Sanborn 1894),
# connecting clerestory roof, tracks and low platforms, platform furniture, the POWER HOUSE (W. A. Holbrook, MPL #12/#16/#17) with its
# engine, dynamos and boilers, the east areaway, Everett / Third / Fourth Streets, Fourth Ward Park, and simple neighbouring blocks.
# Model axes: X from the depot's EAST face going WEST, Y from the street face going SOUTH, Z up from the Everett St sidewalk.  Feet.
import math
G = {}
def add(g, s): G.setdefault(g, []).append(s)
def r(v): return round(v, 3)
def box(g, x0, y0, z0, x1, y1, z1):
    x0, x1 = min(x0, x1), max(x0, x1); y0, y1 = min(y0, y1), max(y0, y1); z0, z1 = min(z0, z1), max(z0, z1)
    add(g, f"translate([{r(x0)},{r(y0)},{r(z0)}]) cube([{r(x1-x0)},{r(y1-y0)},{r(z1-z0)}]);")
def cyl(g, x, y, z, rad, h, r2=None, fn=16, axis="z"):
    rot = {"z": "", "x": "rotate([0,90,0]) ", "y": "rotate([-90,0,0]) "}[axis]
    rr = f"r1={r(rad)},r2={r(r2)}" if r2 is not None else f"r={r(rad)}"
    add(g, f"translate([{r(x)},{r(y)},{r(z)}]) {rot}cylinder({rr},h={r(h)},$fn={fn});")
def boxes_poly(g, B):
    """many disjoint boxes as ONE polyhedron (no CSG union needed at export)"""
    P, F = [], []
    for (x0, y0, z0, x1, y1, z1) in B:
        i = len(P)
        P += [(x0,y0,z0),(x1,y0,z0),(x1,y1,z0),(x0,y1,z0),(x0,y0,z1),(x1,y0,z1),(x1,y1,z1),(x0,y1,z1)]
        F += [[i,i+1,i+2,i+3],[i+4,i+7,i+6,i+5],[i,i+4,i+5,i+1],[i+1,i+5,i+6,i+2],[i+2,i+6,i+7,i+3],[i+3,i+7,i+4,i]]
    add(g, "polyhedron(points=[" + ",".join(f"[{r(a)},{r(b)},{r(c)}]" for a, b, c in P) + "], faces=[" + ",".join("[" + ",".join(map(str, f)) + "]" for f in F) + "]);")
def mem(g, p0, p1, w=0.5, d=None):
    d = d or w
    add(g, f"hull() {{ translate([{r(p0[0])},{r(p0[1])},{r(p0[2])}]) cube([{r(w)},{r(d)},{r(d)}],center=true); translate([{r(p1[0])},{r(p1[1])},{r(p1[2])}]) cube([{r(w)},{r(d)},{r(d)}],center=true); }}")
def slab(g, P, t=0.3):
    """thin plate through the 4 corner points P (list of xyz), thickness t downward"""
    pts = ",".join(f"[{r(p[0])},{r(p[1])},{r(p[2])}],[{r(p[0])},{r(p[1])},{r(p[2]-t)}]" for p in P)
    add(g, f"hull() for (p = [{pts}]) translate(p) cube(0.02, center=true);")
def pyz(g, pts, x0, x1):
    P = ",".join(f"[{r(a)},{r(b)}]" for a, b in pts)
    add(g, f"translate([{r(x0)},0,0]) rotate([90,0,90]) linear_extrude({r(x1-x0)}) polygon([{P}]);")
def pxz(g, pts, y0, y1):
    P = ",".join(f"[{r(a)},{r(b)}]" for a, b in pts)
    add(g, f"translate([0,{r(y1)},0]) rotate([90,0,0]) linear_extrude({r(y1-y0)}) polygon([{P}]);")

# ---------------- shed geometry ----------------
SX0, SX1 = -112.0, 437.0                 # shed length (Sanborn 1894: ~549 ft)
YN, YS = 89.75, 156.25                   # column rows (66'-6" span, MPL #28)
YM = (YN + YS) / 2; HALF = (YS - YN) / 2
EAVE_Z, RIDGE_Z, CAP_Z = 20.6, 38.0, 19.0
OVER = 13.5                              # overhang beyond the columns
YEN, YES = YN - OVER, YS + OVER
RAIL = 0.85                              # top of rail = platform top (low platforms)
TRACKS = [97.0, 113.0, 133.5, 149.0, 172.0]
PLATFORMS = [(60.0, 91.8), (102.2, 107.8), (118.2, 128.3), (138.7, 143.8)]
def roof_z(y):                            # top of the rafters
    if y <= YM: return EAVE_Z + (RIDGE_Z - EAVE_Z) * (y - YEN) / (YM - YEN)
    return EAVE_Z + (RIDGE_Z - EAVE_Z) * (YES - y) / (YES - YM)
def chord_z(y): return 22.0 + 7.8 * (1 - ((y - YM) / HALF) ** 2)
NB = 22; XS = [SX0 + i * (SX1 - SX0) / NB for i in range(NB + 1)]

def truss(x, end=False):
    g = "r_iron"
    for yc in (YN, YS):
        cyl(g, x, yc, 0, 1.1, 1.2, fn=12); cyl(g, x, yc, 1.2, 0.85, 0.8, 0.55, fn=12); cyl(g, x, yc, 2.0, 0.5, CAP_Z - 2.0, fn=12)
        cyl(g, x, yc, CAP_Z - 1.4, 0.55, 1.4, 1.1, fn=12)
        s = -1 if yc == YN else 1
        # curved knee braces to the rafter (outside) and to the bottom chord (inside)
        for side in (-1, 1):
            pts = []
            for k in range(6):
                a = math.radians(90 * k / 5)
                yy = yc + side * s * 6.0 * (1 - math.cos(a)); zz = 13.5 + (roof_z(yc + side * s * 6.0) - 0.6 - 13.5) * math.sin(a) if side == -1 else 13.5 + (chord_z(yc + s * -6.0 * 0) + 0.0 - 13.5) * math.sin(a)
                pts.append((x, yy, zz))
            for p0, p1 in zip(pts, pts[1:]): mem(g, p0, p1, 0.35)
        # spandrel: rosette disc in the outside bracket
        cyl("r_iron", x - 0.15, yc - s * 3.4, 17.3, 1.1, 0.3, fn=16, axis="x")
    # top chords (rafters) eave -> ridge
    for y0, y1 in ((YEN, YM), (YES, YM)): mem(g, (x, y0, roof_z(y0) - 0.45), (x, y1, RIDGE_Z - 0.45), 0.5, 0.8)
    # arched bottom chord
    ys = [YN + (YS - YN) * k / 12 for k in range(13)]
    for a, b in zip(ys, ys[1:]): mem(g, (x, a, chord_z(a)), (x, b, chord_z(b)), 0.45, 0.6)
    # webs: 8 panels, Warren pattern
    for k in range(8):
        a = YN + (YS - YN) * k / 8; b = YN + (YS - YN) * (k + 1) / 8
        if k % 2 == 0: mem(g, (x, a, chord_z(a)), (x, b, roof_z(b) - 0.8), 0.3)
        else:          mem(g, (x, a, roof_z(a) - 0.8), (x, b, chord_z(b)), 0.3)
        mem(g, (x, b, chord_z(b)), (x, b, roof_z(b) - 0.8), 0.25)
    mem(g, (x, YM, chord_z(YM)), (x, YM, 44.6 - 0.5), 0.4)
    # monitor posts
    for yy in (YM - 6.5, YM + 6.5): mem(g, (x, yy, roof_z(yy) - 0.3), (x, yy, 41.5), 0.35)
    # rafter tails into the column caps
    for yc, ye in ((YN, YEN), (YS, YES)): mem(g, (x, yc, CAP_Z), (x, yc, roof_z(yc) - 0.6), 0.45)

def shed():
    for x in XS: truss(x)
    # eave girders (lattice) along each column row, purlins, ridge, monitor
    for yc in (YN, YS):
        box("r_iron", SX0, yc - 0.3, CAP_Z - 0.2, SX1, yc + 0.3, CAP_Z + 0.3); box("r_iron", SX0, yc - 0.3, CAP_Z - 2.6, SX1, yc + 0.3, CAP_Z - 2.2)
        for i in range(int((SX1 - SX0) / 4)):
            xa = SX0 + 4 * i; mem("r_iron", (xa, yc, CAP_Z - 2.4), (xa + 4, yc, CAP_Z), 0.12)
        cyl("r_iron", SX0, yc, roof_z(YEN if yc == YN else YES) - 0.2, 0.35, SX1 - SX0, fn=8, axis="x")
    for side in (-1, 1):
        for f in (0.0, 0.2, 0.4, 0.6, 0.8, 0.97):
            y = YM + side * (6.5 + (YM - YEN - 6.5) * (1 - f)) if side == -1 else YM + 6.5 + (YES - YM - 6.5) * f
            y = YEN + (YM - 6.5 - YEN) * f if side == -1 else YES - (YES - YM - 6.5) * f
            box("r_iron", SX0, y - 0.25, roof_z(y) - 1.0, SX1, y + 0.25, roof_z(y) - 0.35)
    # roof boards and skylights, bay by bay (glass on alternate bays, middle band of each slope)
    for i in range(NB):
        x0, x1 = XS[i] - 0.05, XS[i + 1] + 0.05
        for side in (-1, 1):
            ye = YEN - 1.0 if side == -1 else YES + 1.0
            ym = YM - 6.5 if side == -1 else YM + 6.5
            def P(fa, fb):
                ya = ye + (ym - ye) * fa; yb = ye + (ym - ye) * fb
                za = roof_z(min(max(ya, YEN), YES)) - (0.75 if (ya < YEN or ya > YES) else 0); zb = roof_z(yb)
                if fa == 0: za = EAVE_Z - 0.75
                return [(x0, ya, za), (x1, ya, za), (x1, yb, zb), (x0, yb, zb)]
            if i % 2 == 1:
                slab("r_shedroof", P(0.0, 0.38)); slab("r_glass", P(0.38, 0.62), 0.12); slab("r_shedroof", P(0.62, 1.0))
                for k in range(1, 6):   # glazing bars
                    xx = x0 + (x1 - x0) * k / 6; ya = ye + (ym - ye) * 0.38; yb = ye + (ym - ye) * 0.62
                    mem("r_iron", (xx, ya, roof_z(ya) + 0.05), (xx, yb, roof_z(yb) + 0.05), 0.12)
            else:
                slab("r_shedroof", P(0.0, 1.0))
        # monitor: louvred sides and its own roof
        for yy in (YM - 6.5, YM + 6.5):
            for k in range(int((x1 - x0) / 1.0)):
                xx = x0 + k * 1.0
                add("r_wood", f"translate([{r(xx)},{r(yy - 0.05)},{r(roof_z(yy))}]) rotate([0,0,0]) cube([0.7,0.1,{r(41.5 - roof_z(yy))}]);")
        slab("r_shedroof", [(x0, YM - 7.8, 41.0), (x1, YM - 7.8, 41.0), (x1, YM, 44.6), (x0, YM, 44.6)])
        slab("r_shedroof", [(x0, YM + 7.8, 41.0), (x1, YM + 7.8, 41.0), (x1, YM, 44.6), (x0, YM, 44.6)])
    # closed (boarded) gable ends above the truss, both ends, and the facia
    for xg, x2 in ((SX0 - 0.35, SX0 - 0.05), (SX1 + 0.05, SX1 + 0.35)):
        top = [(YEN, EAVE_Z), (YM - 6.5, roof_z(YM - 6.5)), (YM - 6.5, 41.0), (YM, 44.6), (YM + 6.5, 41.0), (YM + 6.5, roof_z(YM + 6.5)), (YES, EAVE_Z)]
        bot = [(YS, EAVE_Z)] + [(y, chord_z(y)) for y in [YS - (YS - YN) * k / 16 for k in range(17)]] + [(YN, EAVE_Z)]
        pyz("r_wood", top + bot, xg, x2)
        for y0, y1 in ((YEN, YM), (YM, YES)):
            mem("r_iron", (xg - 0.2, y0, roof_z(y0) + 0.1), (xg - 0.2, y1, roof_z(y1) + 0.1), 0.3, 1.0)
        add("r_wood", f"translate([{r(xg - 0.1)},{r(YM - 4)},{r(34.5)}]) cube([0.2,8,1.6]);")
    # gutters and downpipes
    for ye in (YEN, YES):
        box("r_iron", SX0, ye - 0.5, EAVE_Z - 1.4, SX1, ye + 0.5, EAVE_Z - 0.8)
    for x in XS[::2]:
        for yc in (YN, YS): cyl("r_iron", x + 0.9, yc, 0, 0.22, CAP_Z, fn=8)
    # pendant lamps under the shed over the platforms; lattice light towers at the west end (as in the 1930s photos)
    for x in XS[:-1]:
        xm = x + (XS[1] - XS[0]) / 2
        for yy in (YN + 6, YM - 0.5, YS - 6):
            cyl("r_iron", xm, yy, chord_z(yy) - 6, 0.05, 6, fn=6); add("r_lamp", f"translate([{r(xm)},{r(yy)},{r(chord_z(yy) - 6.4)}]) sphere(r=0.7,$fn=12);")
            cyl("r_iron", xm, yy, chord_z(yy) - 6.1, 1.2, 0.25, 0.4, fn=12)
    for yy in (YN - 14, YS + 14):
        xt = SX1 + 12
        for dx in (-2.5, 2.5):
            for dy in (-2.5, 2.5): mem("r_iron", (xt + dx, yy + dy, 0), (xt + dx * 0.5, yy + dy * 0.5, 42), 0.3)
        for z in range(0, 42, 4):
            for (ax, ay), (bx, by) in [((-1, -1), (1, -1)), ((1, -1), (1, 1)), ((1, 1), (-1, 1)), ((-1, 1), (-1, -1))]:
                s0 = 2.5 * (1 - z / 84); s1 = 2.5 * (1 - (z + 4) / 84)
                mem("r_iron", (xt + ax * s0, yy + ay * s0, z), (xt + bx * s1, yy + by * s1, z + 4), 0.12)
        box("r_iron", xt - 3, yy - 3, 42, xt + 3, yy + 3, 42.6)
        for k in range(4): add("r_lamp", f"translate([{r(xt - 1.8 + 1.2 * k)},{r(yy - 3.1)},43.4]) sphere(r=0.5,$fn=10);")

def strip():
    """connecting roof between the depot's track wall and the shed, with a glazed clerestory (1935 photos, Sanborn)"""
    for x0, x1 in [(0.0, 140.0), (140.0, 319.0)]:
        slab("r_shedroof", [(x0, 60.4, 22.4), (x1, 60.4, 22.4), (x1, YEN + 0.5, EAVE_Z + 0.1), (x0, YEN + 0.5, EAVE_Z + 0.1)])
        box("r_wood", x0, 64.5, 21.7, x1, 64.8, 25.3); box("r_wood", x0, 71.2, 21.0, x1, 71.5, 25.3)
        box("r_glass", x0, 64.6, 22.3, x1, 64.7, 24.9); box("r_glass", x0, 71.3, 21.6, x1, 71.4, 24.9)
        for k in range(int((x1 - x0) / 3)):
            xx = x0 + 3 * k; box("r_wood", xx, 64.4, 21.7, xx + 0.3, 64.9, 25.3); box("r_wood", xx, 71.1, 21.0, xx + 0.3, 71.6, 25.3)
        slab("r_shedroof", [(x0, 64.0, 25.6), (x1, 64.0, 25.6), (x1, 68.0, 27.0), (x0, 68.0, 27.0)], 0.25)
        slab("r_shedroof", [(x0, 72.0, 25.6), (x1, 72.0, 25.6), (x1, 68.0, 27.0), (x0, 68.0, 27.0)], 0.25)
    for x in range(0, 320, 25):
        mem("r_iron", (x, 60.6, 18.0), (x, 66.0, 21.8), 0.3); mem("r_iron", (x, YEN, 0), (x, YEN, EAVE_Z), 0.45)

def tracks():
    X0, X1 = -360.0, 700.0
    TIES = []
    box("r_ballast", X0, 88.0, -1.2, X1, 185.0, 0.0)
    for yc in TRACKS:
        box("r_ballast", X0, yc - 6.0, 0.0, X1, yc + 6.0, 0.15)
        TIES.extend([(X0 + 1.75 * k, yc - 4.25, 0.15, X0 + 1.75 * k + 0.6, yc + 4.25, 0.5) for k in range(int((X1 - X0) / 1.75))])
        for s in (-1, 1):
            yr = yc + s * 2.354
            box("r_rail", X0, yr - 0.24, 0.5, X1, yr + 0.24, 0.58); box("r_rail", X0, yr - 0.07, 0.58, X1, yr + 0.07, 0.75); box("r_rail", X0, yr - 0.13, 0.75, X1, yr + 0.13, RAIL)
    boxes_poly("r_tie", TIES)
    # platforms: planked islands with stone edges, the main concourse along the depot paved in brick
    box("r_platform", -112, 60.0, -1.0, 437, 91.8, RAIL)
    for y0, y1 in PLATFORMS[1:]:
        box("r_platform", -112, y0, -1.0, 437, y1, RAIL)
        box("r_stone", -112, y0, RAIL - 0.02, 437, y0 + 0.9, RAIL + 0.05); box("r_stone", -112, y1 - 0.9, RAIL - 0.02, 437, y1, RAIL + 0.05)
    box("r_stone", -112, 91.0, RAIL - 0.02, 437, 91.8, RAIL + 0.05)
    # buffer stops? (through station) - no.  Track numbers on posts at the west end
    for i, yc in enumerate(TRACKS[:4]):
        box("r_iron", 440, yc + 5.2, RAIL, 440.3, yc + 5.5, 9); box("r_white", 439.8, yc + 4.3, 7.5, 440.5, yc + 6.4, 9.3)

def platform_furniture():
    # benches, baggage wagons with trunks, milk cans, a train bulletin board, lamp posts on the islands
    def bench(x, y):
        box("r_wood", x, y - 0.9, RAIL + 1.4, x + 8, y + 0.9, RAIL + 1.6); box("r_wood", x, y - 0.12, RAIL + 1.6, x + 8, y + 0.12, RAIL + 3.6)
        for xx in (x, x + 3.85, x + 7.7): box("r_iron", xx, y - 1.0, RAIL, xx + 0.3, y + 1.0, RAIL + 2.4)
    for x in range(10, 300, 40): bench(x, 63.5)
    for x in range(-90, 420, 60): bench(x, 123.2)
    def wagon(x, y, load=True):
        box("r_wood", x, y - 2.0, RAIL + 1.9, x + 10, y + 2.0, RAIL + 2.3)
        for xx in (x + 1.6, x + 8.4):
            for yy in (y - 2.2, y + 2.0): cyl("r_iron", xx, yy, RAIL + 1.2, 1.15, 0.25, fn=16, axis="y")
        mem("r_iron", (x - 0.2, y, RAIL + 2.2), (x - 4.5, y, RAIL + 3.3), 0.15)
        if load:
            for k, (dx, dy, w, d, h) in enumerate([(0.5, -1.7, 3.0, 2.0, 2.0), (3.8, -1.6, 2.6, 1.8, 1.6), (6.6, -1.8, 3.0, 2.0, 2.4), (0.8, 0.4, 2.2, 1.6, 1.4), (4.0, 0.3, 4.0, 1.4, 1.0)]):
                box("r_trunk" if k % 2 == 0 else "r_wood", x + dx, y + dy, RAIL + 2.3, x + dx + w, y + dy + d, RAIL + 2.3 + h)
    for x, y, l in [(25, 82, True), (60, 84, False), (205, 83, True), (232, 85, True), (275, 82, True), (300, 84, False), (-60, 125, True), (340, 104, True)]: wagon(x, y, l)
    for k in range(12):
        x = 284 + (k % 6) * 1.4; y = 70 + (k // 6) * 1.4
        cyl("r_tin", x, y, RAIL, 0.6, 2.2, 0.55, fn=14); cyl("r_tin", x, y, RAIL + 2.2, 0.35, 0.5, fn=12)
    box("r_wood", 168, 60.5, 3.0, 182, 61.0, 12.0); box("r_white", 168.6, 61.0, 3.6, 181.4, 61.1, 11.4)
    for y0, y1 in PLATFORMS[1:]:
        for x in range(-100, 437, 50):
            yy = (y0 + y1) / 2; cyl("r_iron", x, yy, RAIL, 0.35, 0.8, 0.2, fn=10); cyl("r_iron", x, yy, RAIL + 0.8, 0.12, 8.5, fn=8)
            box("r_glass", x - 0.6, yy - 0.6, RAIL + 9.3, x + 0.6, yy + 0.6, RAIL + 10.6); add("r_lamp", f"translate([{x},{r(yy)},{r(RAIL + 9.95)}]) sphere(r=0.45,$fn=10);")
            cyl("r_iron", x, yy, RAIL + 10.6, 0.9, 0.6, 0.05, fn=4)

# ---------------- power house (Holbrook; local u from its WEST face going east, v from its NORTH face going south) ----------------
PX, PY = -88.0, 24.0
def PU(u): return PX - u
def pbox(g, u0, v0, z0, u1, v1, z1): box(g, PU(u0), PY + v0, z0, PU(u1), PY + v1, z1)
def powerhouse():
    W = 50.75; T = 1.08; EAVE = 21.0
    cuts = []
    def cut(u0, v0, z0, u1, v1, z1): cuts.append((PU(u0), PY + v0, z0, PU(u1), PY + v1, z1))
    wins = []
    def win(face, a0, a1, z0=5.0, z1=17.0):
        if face == "W": cut(-1, a0, z0, T + 0.5, a1, z1); wins.append(("W", a0, a1, z0, z1))
        if face == "E": cut(W - T - 0.5, a0, z0, W + 1, a1, z1); wins.append(("E", a0, a1, z0, z1))
        if face == "N": cut(a0, -1, z0, a1, T + 0.5, z1); wins.append(("N", a0, a1, z0, z1))
        if face == "S": cut(a0, W - T - 0.5, z0, a1, W + 1, z1); wins.append(("S", a0, a1, z0, z1))
    for a, b in [(4.5, 8.6), (26.8, 31.3), (37.8, 42.1)]: win("W", a, b)
    cut(-1, 12.7, 0, T + 0.5, 19.0, 10.4); win("W", 12.7, 19.0, 10.9, 16.8)
    for a, b in [(4.7, 9.1), (13.8, 18.1), (43.9, 48.2)]: win("N", a, b)
    for a, b in [(22.1, 27.9), (32.3, 38.1)]: cut(a, -1, 0, b, T + 0.5, 7.0)
    for a, b in [(4.7, 9.1), (13.8, 18.1), (26.1, 30.5), (40.2, 44.6)]: win("S", a, b)
    cut(W - T - 0.5, 12.4, 0, W + 1, 22.9, 17.0); cut(W - T - 0.5, 4.0, 0, W + 1, 8.1, 5.0)
    for a, b in [(25.7, 30.3), (31.4, 35.6)]: win("E", a, b, 5.0, 18.0)
    C = " ".join(f"translate([{r(min(c[0],c[3]))},{r(min(c[1],c[4]))},{r(c[2])}]) cube([{r(abs(c[3]-c[0]))},{r(abs(c[4]-c[1]))},{r(c[5]-c[2])}]);" for c in cuts)
    arch = f"translate([{r(PU(W) - 1)},{r(PY + 17.65)},17.0]) rotate([0,90,0]) cylinder(r=5.25,h={r(T + 2)},$fn=32);"
    shell = (f"translate([{r(PU(W))},{PY},-2]) cube([{W},{W},{EAVE + 2}]);"
             f" translate([{r(PU(W) + T)},{PY + T},0]) cube([{r(W - 2*T)},{r(W - 2*T)},{EAVE + 1}]);")
    add("r_brick", f"difference() {{ translate([{r(PU(W))},{PY},-2]) cube([{W},{W},{EAVE + 2}]); translate([{r(PU(W) + T)},{PY + T},0]) cube([{r(W - 2*T)},{r(W - 2*T)},{EAVE + 1}]); {C} {arch} }}")
    # interior walls: engine room | boiler room, coal room | ash pit | boiler room
    pbox("r_brick", 20.33, T, 0, 21.42, W - T, EAVE); add("r_brick", f"translate([{r(PU(21.42))},{PY + 30},0]) cube([{r(1.09)},5,8]);")
    pbox("r_brick", 21.42, 11.08, 0, W - T, 12.16, 14.0); pbox("r_brick", 41.42, T, 0, 42.5, 11.08, 14.0)
    # stone trim: water table, sill band, cornice with brackets
    pbox("r_stone", -0.3, -0.3, -0.3, W + 0.3, W + 0.3, 1.2)
    pbox("r_stone", -0.4, -0.4, EAVE - 1.2, W + 0.4, W + 0.4, EAVE)
    for k in range(0, 50, 3):
        for (u0, v0, u1, v1) in [(k, -0.7, k + 0.6, 0), (k, W, k + 0.6, W + 0.7), (-0.7, k, 0, k + 0.6), (W, k, W + 0.7, k + 0.6)]:
            pbox("r_stone", u0, v0, EAVE - 2.2, u1, v1, EAVE - 1.2)
    for face, a0, a1, z0, z1 in wins:
        if face in "WE":
            u = 0.45 if face == "W" else W - 0.45
            box("r_glass", PU(u) - 0.05, PY + a0, z0, PU(u) + 0.05, PY + a1, z1); box("r_stone", PU(u) - 0.8, PY + a0 - 0.6, z1 + 0.2, PU(u) + 0.2, PY + a1 + 0.6, z1 + 1.0)
            box("r_wood", PU(u) - 0.1, PY + a0, (z0 + z1) / 2 + 1.5, PU(u) + 0.1, PY + a1, (z0 + z1) / 2 + 1.9)
        else:
            v = 0.45 if face == "N" else W - 0.45
            box("r_glass", PU(a0), PY + v - 0.05, z0, PU(a1), PY + v + 0.05, z1); box("r_stone", PU(a0) + 0.6, PY + v - 0.8 if face == "N" else PY + v - 0.2, z1 + 0.2, PU(a1) - 0.6, PY + v + 0.2 if face == "N" else PY + v + 0.8, z1 + 1.0)
            box("r_wood", PU(a0), PY + v - 0.1, (z0 + z1) / 2 + 1.5, PU(a1), PY + v + 0.1, (z0 + z1) / 2 + 1.9)
    pbox("r_wood", 0.3, 12.7, 0, 0.6, 19.0, 10.4); pbox("r_wood", W - 0.6, 12.4, 0, W - 0.3, 22.9, 16.5)
    for a, b in [(22.1, 27.9), (32.3, 38.1)]: pbox("r_iron", a, 0.2, 0, b, 0.5, 7.0)
    # roof: hipped to a cresting-topped flat at 36.3, stepped gables W and E with 42" roundels, lantern, spire, vane
    p = lambda u, v, z: [r(PU(u)), r(PY + v), r(z)]
    pts = [p(-0.8, -0.8, EAVE), p(W + 0.8, -0.8, EAVE), p(-0.8, W + 0.8, EAVE), p(W + 0.8, W + 0.8, EAVE),
           p(10, 10, 36.3), p(W - 10, 10, 36.3), p(10, W - 10, 36.3), p(W - 10, W - 10, 36.3)]
    add("r_roof", "hull() for (q = [" + ",".join(map(str, pts)) + "]) translate(q) cube(0.05, center=true);")
    for u0 in (10, ):
        for k in range(int((W - 20) / 1.2) + 1):
            for v in (10, W - 10): pbox("r_iron", u0 + 1.2 * k, v - 0.08, 36.3, u0 + 1.2 * k + 0.12, v + 0.08, 37.5)
    pbox("r_iron", 10, 9.9, 37.4, W - 10, 10.1, 37.6); pbox("r_iron", 10, W - 10.1, 37.4, W - 10, W - 9.9, 37.6)
    for face, c in (("W", 24.3), ("E", W - 17.65)):
        u0, u1 = (-0.6, 2.0) if face == "W" else (W - 2.0, W + 0.6)
        gp = [(c - 7.5, EAVE), (c + 7.5, EAVE), (c + 7.5, 23.5), (c + 6, 23.5), (c + 6, 26), (c + 4, 26), (c, 32.6), (c - 4, 26), (c - 6, 26), (c - 6, 23.5), (c - 7.5, 23.5)]
        pyz("r_brick", [(PY + a, b) for a, b in gp], min(PU(u0), PU(u1)), max(PU(u0), PU(u1)))
        ue = PU(u0) + (0.15 if face == "W" else -0.15)
        cyl("r_stone", ue, PY + c, 26.3, 2.4, 0.4, fn=24, axis="x"); cyl("r_glass", ue - 0.1, PY + c, 26.3, 1.75, 0.6, fn=24, axis="x")
        add("r_roof", "hull() for (q = [" + ",".join(map(str, [p(u0 if face == "W" else u1, c - 7.5, EAVE), p(u0 if face == "W" else u1, c + 7.5, EAVE), p(u0 if face == "W" else u1, c, 32.2),
                                                             p(12 if face == "W" else W - 12, c - 7.5, EAVE), p(12 if face == "W" else W - 12, c + 7.5, EAVE), p(12 if face == "W" else W - 12, c, 32.2)])) + "]) translate(q) cube(0.05, center=true);")
    lu, lv = 35.9, 24.3
    pbox("r_wood", lu - 2.5, lv - 2.5, 36.3, lu + 2.5, lv + 2.5, 43.1)
    for k in range(5):
        for (a0, b0, a1, b1) in [(lu - 2.6, lv - 1.5, lu - 2.4, lv + 1.5), (lu + 2.4, lv - 1.5, lu + 2.6, lv + 1.5), (lu - 1.5, lv - 2.6, lu + 1.5, lv - 2.4), (lu - 1.5, lv + 2.4, lu + 1.5, lv + 2.6)]:
            pbox("r_metal", a0, b0, 38.4 + 0.6 * k, a1, b1, 38.7 + 0.6 * k)
    add("r_roof", f"translate([{r(PU(lu))},{PY + lv},43.1]) rotate([0,0,45]) cylinder(r1=3.7,r2=0.1,h=15.9,$fn=4);")
    cyl("r_iron", PU(lu), PY + lv, 59.0, 0.1, 9.4, fn=6); box("r_iron", PU(lu) - 1.5, PY + lv - 0.05, 66.0, PU(lu) + 1.2, PY + lv + 0.05, 66.8)
    for u in (0, W):
        for v in (0, W): pbox("r_stone", u - 0.5, v - 0.5, EAVE, u + 0.5, v + 0.5, 38.0)
    # chimney at the SE corner: 9'-9 1/2" x 11'-0" base, fluted shaft, corbelled cap, 102 ft (Sanborn: 110 ft)
    cu, cv = 55.65, 45.25
    pbox("r_brick", 50.75, 39.75, -1, 60.54, 50.75, 26.3); pbox("r_stone", 50.4, 39.4, 26.3, 60.9, 51.1, 27.3)
    add("r_brick", f"difference() {{ translate([{r(PU(cu) - 5)},{r(PY + cv - 5)},27.3]) cube([10,10,57]); translate([{r(PU(cu) - 2)},{r(PY + cv - 2)},27]) cube([4,4,80]); }}")
    for side in range(4):
        for k in (-1, 0, 1):
            ox, oy = [(k * 1.2, -5.05), (k * 1.2, 5.05), (-5.05, k * 1.2), (5.05, k * 1.2)][side]
            box("r_stone", PU(cu) + ox - 0.15, PY + cv + oy - 0.15, 35.3, PU(cu) + ox + 0.15, PY + cv + oy + 0.15, 82.3)
    add("r_brick", f"difference() {{ translate([{r(PU(cu) - 5.8)},{r(PY + cv - 5.8)},84.3]) cube([11.6,11.6,18.1]); translate([{r(PU(cu) - 2)},{r(PY + cv - 2)},84]) cube([4,4,30]); }}")
    for z in (84.3, 96.0, 101.4): box("r_stone", PU(cu) - 6.2, PY + cv - 6.2, z, PU(cu) + 6.2, PY + cv + 6.2, z + 1.0)
    for side in range(4):
        for k in range(4):
            a = -4.2 + 2.8 * k
            if side < 2: box("r_iron", PU(cu) + a - 0.9, PY + cv + (5.85 if side else -5.95), 88.0, PU(cu) + a + 0.9, PY + cv + (5.95 if side else -5.85), 94.0)
            else: box("r_iron", PU(cu) + (5.85 if side == 3 else -5.95), PY + cv + a - 0.9, 88.0, PU(cu) + (5.95 if side == 3 else -5.85), PY + cv + a + 0.9, 94.0)
    # ---- inside: concrete floor, two boilers in brick settings, steam drum, feed tank, engine, flywheel, dynamos, belts, coal ----
    pbox("r_concrete", T, T, -0.3, W - T, W - T, 0.0)
    for u0, u1 in [(25.0, 33.6), (38.2, 46.8)]:
        pbox("r_brick", u0, 19.6, 0, u1, 44.1, 6.5); pbox("r_iron", u0 + 0.6, 19.4, 0.8, u1 - 0.6, 19.7, 5.6)
        for k in range(2): pbox("r_metal", u0 + 1.4 + k * 3.4, 19.3, 1.5, u0 + 3.6 + k * 3.4, 19.5, 3.4)
        uc = (u0 + u1) / 2; cyl("r_iron", PU(uc), PY + 20.4, 7.8, 2.6, 22.0, fn=24, axis="y")
        cyl("r_iron", PU(uc), PY + 34.0, 10.0, 0.45, 12.0, fn=10); cyl("r_iron", PU(uc), PY + 21.5, 10.0, 0.35, 8.0, fn=10)
        mem("r_iron", (PU(uc), PY + 34.0, 22.0), (PU(uc), PY + 30.0, 23.5), 0.6)
    mem("r_iron", (PU(29.3), PY + 30.0, 23.5), (PU(23.0), PY + 30.0, 23.5), 0.7); mem("r_iron", (PU(42.5), PY + 30.0, 23.5), (PU(29.3), PY + 30.0, 23.5), 0.7)
    cyl("r_iron", PU(35.9), PY + 36.7, 0, 4.0, 8.0, fn=28)
    mem("r_iron", (PU(23.0), PY + 30.0, 23.5), (PU(12.0), PY + 30.0, 14.0), 0.6)
    pbox("r_concrete", 3.0, 22.0, 0, 17.0, 44.0, 2.2)
    cyl("r_iron", PU(10.0), PY + 26.0, 4.6, 1.7, 9.0, fn=20, axis="x")          # cylinder of a horizontal engine
    cyl("r_iron", PU(10.0), PY + 33.0, 2.2, 0.3, 9.0, fn=10, axis="y"); cyl("r_iron", PU(10.0), PY + 33.0, 2.2, 0.6, 1.0, fn=10, axis="y")
    cyl("r_iron", PU(9.0), PY + 33.5, 5.5, 5.2, 0.9, fn=48, axis="x"); cyl("r_metal", PU(9.0) - 0.05, PY + 33.5, 5.5, 4.6, 1.0, fn=48, axis="x")
    for k in range(6):
        a = math.radians(60 * k); mem("r_iron", (PU(9.45), PY + 33.5, 5.5), (PU(9.45), PY + 33.5 + 4.6 * math.cos(a), 5.5 + 4.6 * math.sin(a)), 0.4)
    mem("r_metal", (PU(10.0), PY + 28.5, 4.6), (PU(10.0), PY + 33.5, 6.5), 0.4)
    for v in (8.0, 15.0):
        pbox("r_concrete", 5.0, v - 2.5, 0, 15.0, v + 2.5, 1.2); cyl("r_dynamo", PU(10.0), PY + v, 4.0, 2.4, 4.0, fn=28, axis="x")
        box("r_dynamo", PU(10.0) - 0.3, PY + v - 2.0, 1.2, PU(10.0) + 0.3 - 4.0, PY + v + 2.0, 2.4)
        cyl("r_metal", PU(14.6), PY + v, 4.0, 0.9, 0.8, fn=20, axis="x")
        for dz in (-0.9, 0.9): mem("r_belt", (PU(14.9), PY + v, 4.0 + dz), (PU(9.45), PY + 33.5, 5.5 + dz * 5.5), 0.1, 0.9)
    pbox("r_wood", 1.5, 2.0, 0, 3.5, 12.0, 7.0)                                     # switchboard (marble on wood in 1890; EST)
    pbox("r_stone", 1.4, 2.2, 1.0, 1.6, 11.8, 6.6)
    for k in range(5): cyl("r_metal", PU(1.35), PY + 3.2 + 2.0 * k, 5.4, 0.45, 0.2, fn=16, axis="x")
    add("r_coal", f"hull() {{ translate([{r(PU(41.0))},{PY + 1.5},0]) cube([{r(-1 * 0 + 18.0)},9.0,0.2]); translate([{r(PU(35.0))},{PY + 4},5.0]) cube([6,3,0.2]); }}")
    for u in (7.0, 30.0, 44.0):
        for v in (12.0, 38.0): add("r_lamp", f"translate([{r(PU(u))},{PY + v},16.0]) sphere(r=0.5,$fn=12);"); cyl("r_iron", PU(u), PY + v, 16.3, 0.05, EAVE - 16.3, fn=6)
    for v in (17.4, 33.3): pbox("r_iron", 21.4, v - 0.35, EAVE - 1.2, W - T, v + 0.35, EAVE - 0.2)

# ---------------- streets, park, areaway, neighbours ----------------
def town():
    # ground (yard level 0) with the east areaway down to the basement (-9), retaining walls and steps
    add("r_ground", "difference() { translate([-420,-420,-14]) cube([1240,760,14]); translate([-30,-2,-15]) cube([30,64,15]); translate([0,0,-15]) cube([319,60,15.2]); translate([141.67,-1.5,-15]) cube([35.66,2,15.2]); translate([-139.6,23.2,-15]) cube([62.4,52.4,15.2]); }")
    box("r_ground", -30, -2, -14, 0, 62, -9.0)
    for a in [(-31.5, -3.5, -9, 0, -2, 1.0), (-31.5, -3.5, -9, -30, 62, 1.0), (-31.5, 62, -9, 0, 63.5, 1.0)]: box("r_stone", *a)
    for k in range(12): box("r_stone", -29.5, 63.5 - k * 0.0 - 0.0 + 0, -9 + 0.75 * k, -26.0, 62 - k * 0.0, -8.25 + 0.75 * k) if False else None
    for k in range(12): box("r_stone", -30 + 0.0, 52 - 0.9 * k, -9.0 + 0.75 * k - 0.75, -26.0, 61.9 - 0.9 * k, -9.0 + 0.75 * k)
    # Everett St (45 ft) with sidewalks and curbs; Third and Fourth Streets north of Everett
    box("r_paving", -420, -53, 0.0, 820, -8, 0.06)
    box("r_sidewalk", -420, -8, 0.0, 820, -1.6, 0.4); box("r_sidewalk", -420, -60, 0.0, 820, -53, 0.4)
    for x0, x1 in [(-80, -47), (322, 386)]:
        box("r_paving", x0, -420, 0.0, x1, -60, 0.06)
    # Fourth Ward Park: lawn, crossing paths, fence, trees, fountain
    PX0, PX1, PY0, PY1 = -47, 322, -260, -60
    add("r_grass", f"difference() {{ translate([{PX0},{PY0},0]) cube([{PX1-PX0},{PY1-PY0},0.15]); "
                   f"hull() {{ translate([{PX0},{PY0},-1]) cylinder(r=4,h=2,$fn=8); translate([{PX1},{PY1},-1]) cylinder(r=4,h=2,$fn=8); }} "
                   f"hull() {{ translate([{PX1},{PY0},-1]) cylinder(r=4,h=2,$fn=8); translate([{PX0},{PY1},-1]) cylinder(r=4,h=2,$fn=8); }} "
                   f"translate([{(PX0+PX1)/2},{(PY0+PY1)/2},-1]) cylinder(r=22,h=2,$fn=32); }}")
    box("r_gravel", PX0, PY0, -0.05, PX1, PY1, 0.05)
    cx, cy = (PX0 + PX1) / 2, (PY0 + PY1) / 2
    cyl("r_stone", cx, cy, 0, 12, 1.6, fn=40); cyl("r_water", cx, cy, 0.5, 11.2, 1.2, fn=40); cyl("r_stone", cx, cy, 0, 1.4, 6, 0.8, fn=16); cyl("r_stone", cx, cy, 6, 3.5, 0.6, fn=24)
    for x in range(PX0, PX1 + 1, 6):
        for y in (PY1 - 0.5,): box("r_iron", x, y - 0.06, 0, x + 0.12, y + 0.06, 3.5)
    box("r_iron", PX0, PY1 - 0.6, 3.2, PX1, PY1 - 0.4, 3.4); box("r_iron", PX0, PY1 - 0.6, 1.0, PX1, PY1 - 0.4, 1.2)
    import random; rnd = random.Random(1886)
    for i in range(46):
        x = rnd.uniform(PX0 + 8, PX1 - 8); y = rnd.uniform(PY0 + 8, PY1 - 8)
        if abs(x - cx) < 26 and abs(y - cy) < 26: continue
        h = rnd.uniform(26, 44); cyl("r_bark", x, y, 0, 0.9, h * 0.5, 0.5, fn=8)
        for k in range(3):
            add("r_tree", f"translate([{r(x + rnd.uniform(-3, 3))},{r(y + rnd.uniform(-3, 3))},{r(h * 0.55 + k * 5)}]) scale([1,1,0.8]) sphere(r={r(rnd.uniform(7, 11) - k * 1.5)},$fn=14);")
    # gas street lamps along Everett St
    for x in range(-200, 640, 60):
        for y in (-4.5, -56.5):
            cyl("r_iron", x, y, 0.4, 0.4, 1.0, 0.2, fn=10); cyl("r_iron", x, y, 1.4, 0.12, 8.0, fn=8)
            box("r_glass", x - 0.7, y - 0.7, 9.4, x + 0.7, y + 0.7, 11.0); add("r_lamp", f"translate([{x},{y},10.2]) sphere(r=0.45,$fn=10);")
            cyl("r_iron", x, y, 11.0, 1.0, 0.8, 0.05, fn=4)
    # neighbouring blocks (simple masses with window grids, 2 - 5 stories) to frame the views
    def building(x0, y0, x1, y1, h, color="r_brick2"):
        box(color, x0, y0, 0, x1, y1, h); box("r_stone", x0 - 0.6, y0 - 0.6, h - 1.4, x1 + 0.6, y1 + 0.6, h)
        floors = max(1, int(h // 13))
        for f in range(floors):
            z0 = 3.0 + f * 13
            for (a0, a1, fixed, ax) in [(x0, x1, y0, "x"), (x0, x1, y1, "x"), (y0, y1, x0, "y"), (y0, y1, x1, "y")]:
                n = int((a1 - a0) / 9)
                for k in range(n):
                    a = a0 + 2.5 + k * (a1 - a0 - 5) / max(n, 1)
                    if ax == "x": box("r_glass", a, fixed - 0.1, z0 + 2, a + 3.5, fixed + 0.1, z0 + 9)
                    else: box("r_glass", fixed - 0.1, a, z0 + 2, fixed + 0.1, a + 3.5, z0 + 9)
    building(388, 0, 707, 54, 34)                                            # American Express Co. (Sanborn 1894)
    box("r_wood", 319.5, 63, 0, 389, 84, 14.0); box("r_shedroof", 318, 61.5, 14.0, 390.5, 85.5, 14.6)   # truck shed
    for (x0, y0, x1, y1, h) in [(-95, -70, -150, -120, 40), (-150, -70, -230, -150, 52), (-95, -130, -150, -200, 30), (-95, 20, -40, 0, 0),
                                (395, -70, 470, -130, 46), (470, -70, 560, -110, 64), (395, -140, 480, -220, 38), (480, -120, 600, -230, 28),
                                (-60, -275, 60, -330, 58), (60, -275, 190, -330, 44), (190, -275, 330, -330, 70), (-200, 200, -40, 260, 30),
                                (40, 240, 200, 300, 36), (200, 240, 380, 300, 42), (420, 120, 560, 190, 30)]:
        if h: building(x0, y0, x1, y1, h, "r_brick2" if h % 4 else "r_cream")
    # Clybourn St
    box("r_paving", -420, 215, 0.0, 820, 255, 0.06)

def build():
    shed(); strip(); tracks(); platform_furniture(); powerhouse(); town()
    return G
