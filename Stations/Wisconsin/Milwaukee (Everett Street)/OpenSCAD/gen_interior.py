# Interior for the Everett Street depot full-size model (TDQ-575 step 3).  Called by gen_everett_3d.py.
# Floors, ceilings, interior walls with doorways, the main staircase, the grand-hall well and balcony, 2nd-floor offices with
# frosted-glass doors lettered with the room names, 3rd-floor stair, tower stair / ladders / clock floor and clock machinery,
# simple 1886 furnishings and gas lamps.  Rooms from the 2D plans (sheets 07, 08, 09, 05); fittings are best guesses.
import math
from matplotlib.textpath import TextPath
from matplotlib.font_manager import FontProperties
F1, C1, F2, C2, F3 = 4.0, 21.9, 23.5, 38.3, 39.5          # floor tops / ceilings (main block)
CORR = (26.67, 37.17)                                      # 2nd-floor corridor (y from the street face)
G = {}                                                     # group -> list of scad lines
def add(g, s): G.setdefault(g, []).append(s)
def box(g, x0, y0, z0, x1, y1, z1):
    if x1 < x0: x0, x1 = x1, x0
    if y1 < y0: y0, y1 = y1, y0
    if z1 < z0: z0, z1 = z1, z0
    add(g, f"translate([{x0:.3f},{y0:.3f},{z0:.3f}]) cube([{x1-x0:.3f},{y1-y0:.3f},{z1-z0:.3f}]);")
def r(v): return round(v, 3)

# ---------------- walls with openings ----------------
WALLS = []   # (axis, pos, a0, a1, z0, z1, t, openings[(c, w, h, sill, arch)])
def wall(axis, pos, a0, a1, z0, z1, t=0.6, op=()):
    WALLS.append((axis, pos, a0, a1, z0, z1, t, list(op)))
def emit_walls():
    for axis, pos, a0, a1, z0, z1, t, op in WALLS:
        def B(ga, gb, z0_, z1_, tt): return (pos - tt/2, ga, z0_, pos + tt/2, gb, z1_) if axis == "x" else (ga, pos - tt/2, z0_, gb, pos + tt/2, z1_)
        cuts = []
        for c, w, h, sill, arch in op:
            zz = z0 + sill
            cuts.append(B(c - w/2, c + w/2, zz, zz + h, t + 1.0))
            if arch:
                rr = w / 2
                if axis == "x": cuts.append(("cylx", pos, c, zz + h, rr, t + 1.0))
                else:           cuts.append(("cyly", c, pos, zz + h, rr, t + 1.0))
        def cutlines():
            s = []
            for cb in cuts:
                if cb[0] == "cylx": s.append(f"translate([{r(cb[1]-cb[5]/2)},{r(cb[2])},{r(cb[3])}]) rotate([0,90,0]) cylinder(r={r(cb[4])},h={r(cb[5])});")
                elif cb[0] == "cyly": s.append(f"translate([{r(cb[1])},{r(cb[2]+cb[5]/2)},{r(cb[3])}]) rotate([90,0,0]) cylinder(r={r(cb[4])},h={r(cb[5])});")
                else:
                    x0, y0, zz0, x1, y1, zz1 = cb; s.append(f"translate([{r(x0)},{r(y0)},{r(zz0)}]) cube([{r(x1-x0)},{r(y1-y0)},{r(zz1-zz0)}]);")
            return " ".join(s)
        x0, y0, zz0, x1, y1, zz1 = B(a0, a1, z0, z1, t)
        add("r_plaster", f"difference() {{ translate([{r(x0)},{r(y0)},{r(zz0)}]) cube([{r(x1-x0)},{r(y1-y0)},{r(zz1-zz0)}]); {cutlines()} }}")
        hw = 3.2 if z0 < 10 else 3.0                                   # wainscot height
        x0, y0, zz0, x1, y1, zz1 = B(a0, a1, z0, z0 + hw, t + 0.16)
        add("r_wood", f"difference() {{ translate([{r(x0)},{r(y0)},{r(zz0)}]) cube([{r(x1-x0)},{r(y1-y0)},{r(zz1-zz0)}]); {cutlines()} }}")
        x0, y0, zz0, x1, y1, zz1 = B(a0, a1, z1 - 0.7, z1, t + 0.3)       # crown moulding
        add("r_wood", f"difference() {{ translate([{r(x0)},{r(y0)},{r(zz0)}]) cube([{r(x1-x0)},{r(y1-y0)},{r(zz1-zz0)}]); {cutlines()} }}")

# ---------------- lettering (polygons, no font needed at export time) ----------------
FP = FontProperties(family="DejaVu Serif", weight="bold")
def text_rings(lines, size, max_w=None):
    if max_w:
        wmax = max(TextPath((0, 0), ln, size=size, prop=FP).get_extents().width for ln in lines)
        if wmax > max_w: size *= max_w / wmax
    rings = []; n = len(lines)
    for i, ln in enumerate(lines):
        tp = TextPath((0, 0), ln, size=size, prop=FP)
        ext = tp.get_extents(); dx = -(ext.x0 + ext.x1) / 2; dy = (n - 1 - i) * size * 1.35 - (n - 1) * size * 0.675
        for poly in tp.to_polygons():
            if len(poly) >= 3: rings.append([(p[0] + dx, p[1] + dy) for p in poly])
    return rings
def lettering(rings, xc, zc, ypos, face, thick=0.03):
    """face '+y' : readable by a viewer looking toward +y (letters run +x); '-y' : viewer looking toward -y (letters run -x)."""
    pts, paths = [], []
    for rg in rings:
        idx = []
        for u, v in rg:
            x = xc + u if face == "+y" else xc - u
            idx.append(len(pts)); pts.append((r(x), r(zc + v)))
        paths.append(idx)
    P = ",".join(f"[{a},{b}]" for a, b in pts); Q = ",".join("[" + ",".join(map(str, p)) + "]" for p in paths)
    y0 = ypos if face == "-y" else ypos - thick
    add("r_gilt", f"translate([0,{r(y0 + thick)},0]) rotate([90,0,0]) linear_extrude({thick}) polygon(points=[{P}], paths=[{Q}]);")

def office_door(xc, wy, corridor_side, name_lines, number=None):
    """Closed panelled door with a frosted upper light, lettered on the corridor side; wall plane at y = wy (2nd floor)."""
    w, h = 3.3, 7.6
    s = 1 if corridor_side == "+y" else -1          # corridor is on the +y side of the wall if s = 1
    face = wy + s * 0.32
    # frame and leaf
    box("r_wood", xc - w/2 - 0.35, wy - 0.4, F2, xc - w/2, wy + 0.4, F2 + h + 0.3)
    box("r_wood", xc + w/2, wy - 0.4, F2, xc + w/2 + 0.35, wy + 0.4, F2 + h + 0.3)
    box("r_wood", xc - w/2 - 0.35, wy - 0.4, F2 + h, xc + w/2 + 0.35, wy + 0.4, F2 + h + 0.35)
    box("r_wood", xc - w/2, wy - 0.12, F2, xc + w/2, wy + 0.12, F2 + 3.4)                       # lower panels
    box("r_wood", xc - w/2, wy - 0.12, F2 + 6.9, xc + w/2, wy + 0.12, F2 + h)                     # top rail
    for xx in (xc - w/2, xc + w/2 - 0.35): box("r_wood", xx, wy - 0.12, F2 + 3.4, xx + 0.35, wy + 0.12, F2 + 6.9)
    box("r_frosted", xc - w/2 + 0.35, wy - 0.05, F2 + 3.4, xc + w/2 - 0.35, wy + 0.05, F2 + 6.9)
    box("r_frosted", xc - w/2, wy - 0.05, F2 + h + 0.35, xc + w/2, wy + 0.05, F2 + h + 1.9)      # transom
    box("r_metal", xc + s * 0 + (w/2 - 0.45), wy + s * 0.12, F2 + 3.2, xc + w/2 - 0.3, wy + s * 0.3, F2 + 3.45)   # knob plate
    if name_lines:
        size = 0.30 if max(len(t) for t in name_lines) <= 14 else 0.22
        lettering(text_rings(name_lines, size, 2.3), xc, F2 + 5.6, wy + s * 0.06, "-y" if s == 1 else "+y")
    if number:
        lettering(text_rings([number], 0.32), xc, F2 + h + 1.0, wy + s * 0.06, "-y" if s == 1 else "+y")

# =====================================================================================================
def build():
    # ---------- floor slabs (wood top, plaster underside) ----------
    def slab(x0, y0, x1, y1, ztop, holes=()):
        hs = " ".join(f"translate([{r(h[0])},{r(h[1])},{r(ztop-3)}]) cube([{r(h[2]-h[0])},{r(h[3]-h[1])},6]);" for h in holes)
        add("r_floor", f"difference() {{ translate([{r(x0)},{r(y0)},{r(ztop-0.2)}]) cube([{r(x1-x0)},{r(y1-y0)},0.2]); {hs} }}")
        add("r_plaster", f"difference() {{ translate([{r(x0)},{r(y0)},{r(ztop-1.6)}]) cube([{r(x1-x0)},{r(y1-y0)},1.4]); {hs} }}")
    WELL = (148.2, 37.7, 170.2, 51.7)
    STAIR_HOLE = (176.5, 40.5, 193.5, 58.2)
    STAIR3_HOLE = (100.0, 31.2, 115.6, 36.4)
    slab(1.5, 1.5, 53.2, 58.5, 4.8); slab(56.2, 1.6, 261.2, 58.4, F1); slab(264.2, 1.5, 317.5, 58.5, 2.4)
    slab(1.5, 1.5, 53.2, 58.5, F2); slab(264.2, 1.5, 317.5, 58.5, F2)
    slab(56.2, 1.6, 261.2, 58.4, F2, [WELL, STAIR_HOLE])
    slab(56.2, 1.6, 261.2, 58.4, F3, [STAIR3_HOLE, (146.0, 2.0, 153.6, 21.0)])
    TV = (144.87, 1.7, 174.13, 21.8)
    for z, hole in [(65.4, (146.0, 2.0, 153.6, 21.0)), (89.8, (165.4, 3.6, 168.8, 12.0)), (104.8, (149.3, 3.6, 152.7, 10.0))]:
        slab(*TV, z, [hole])
    # grand hall: plaster ceiling at C2 with a stained-glass lay-light over the well
    add("r_plaster", f"difference() {{ translate([144.6,25.0,{C2}]) cube([30.2,33.4,0.4]); translate([150,40,{C2-1}]) cube([18.4,10,3]); }}")
    box("r_stained", 150, 40, C2 + 0.1, 168.4, 50, C2 + 0.25)
    for xx in [150 + i * 18.4 / 4 for i in range(5)]: box("r_wood", xx - 0.15, 40, C2 - 0.3, xx + 0.15, 50, C2 + 0.3)
    for yy in [40, 45, 50]: box("r_wood", 150, yy - 0.15, C2 - 0.3, 168.4, yy + 0.15, C2 + 0.3)

    # ---------- first floor walls (sheet 07) ----------
    Z = (F1, C1)
    wall("x", 54.67, 1.5, 58.5, 4.8, C1, 1.4, [(25, 4, 9, 0, True)])
    wall("x", 71.83, 1.6, 58.4, *Z, 1.2, [(30, 4, 9, 0, True), (52, 3.5, 8.5, 0, False)])
    wall("x", 89.0, 1.6, 58.4, *Z, 1.2, [(30, 6, 10, 0, True), (51, 4, 9, 0, False), (10, 4, 9, 0, False)])
    wall("x", 144.0, 1.6, 58.4, *Z, 1.4, [(13, 6, 10, 0, True), (35, 10, 12, 0, True), (50, 6, 10, 0, True)])
    wall("x", 175.0, 1.6, 58.4, *Z, 1.4, [(13, 6, 10, 0, True), (31, 8, 12, 0, True), (47, 5, 10, 0, True)])
    wall("x", 262.67, 1.6, 58.4, 2.4, C1, 1.4, [(29.5, 9, 12, 1.6, False)])
    wall("y", 40.0, 54.67, 71.83, *Z, 0.5, [(63, 3, 7.5, 0, False)])               # depot master
    wall("y", 10.5, 54.67, 71.83, *Z, 0.5, [(63, 3, 7.5, 0, False)])               # bath rooms
    wall("y", 46.0, 71.83, 89.0, *Z, 0.5, [(80, 3, 7.5, 0, False)])                # pantry
    wall("y", 20.0, 71.83, 89.0, *Z, 0.5, [(76, 3, 7.5, 0, False)])                # carving / china
    wall("x", 80.0, 1.6, 20.0, *Z, 0.5, [(10, 3, 7.5, 0, False)])
    wall("y", 39.5, 175.7, 194.0, *Z, 0.5, [(179.0, 5.5, 10, 0, False), (190.5, 4, 9, 0, False)])   # stair & news room
    wall("x", 252.0, 1.6, 24.7, *Z, 0.5, [(20, 3, 7.5, 0, False)])                  # ladies' toilet
    wall("y", 24.7, 252.0, 262.0, *Z, 0.5)
    # glazed screens: lunch room / dining, gentlemen's / ladies' (wood wainscot, glass above, doorways)
    def screen(axis, pos, a0, a1, doors):
        wall(axis, pos, a0, a1, F1, F1 + 4.4, 0.5, [(c, w, 4.4, 0, False) for c, w in doors])
        for c, w in doors: pass
        segs = []; a = a0
        for c, w in sorted(doors): segs.append((a, c - w/2)); a = c + w/2
        segs.append((a, a1))
        for s0, s1 in segs:
            if s1 - s0 < 0.5: continue
            if axis == "y":
                box("r_glass", s0, pos - 0.05, F1 + 4.4, s1, pos + 0.05, F1 + 14.0)
                n = max(1, int((s1 - s0) / 4.0))
                for i in range(n + 1): xx = s0 + i * (s1 - s0) / n; box("r_wood", xx - 0.2, pos - 0.25, F1 + 4.4, xx + 0.2, pos + 0.25, F1 + 14.0)
                box("r_wood", s0, pos - 0.3, F1 + 14.0, s1, pos + 0.3, F1 + 14.6)
        for c, w in doors:
            if axis == "y": box("r_wood", c - w/2, pos - 0.3, F1 + 10.0, c + w/2, pos + 0.3, F1 + 14.6)
    screen("y", 40.0, 89.6, 143.3, [(100, 5), (128, 5)])
    screen("y", 30.0, 194.3, 261.9, [(205, 6), (233, 6)])
    # ticket office: counter box with grilles toward both waiting rooms and the hall
    box("r_wood", 179.5, 21.0, F1, 194.3, 21.6, F1 + 4.0); box("r_wood", 179.5, 36.0, F1, 194.3, 36.6, F1 + 4.0)
    box("r_wood", 193.7, 21.0, F1, 194.3, 36.6, F1 + 4.0); box("r_wood", 179.5, 21.0, F1, 180.1, 36.6, F1 + 4.0)
    for y0, y1, xs in [(21.0, 21.6, (179.5, 194.3)), (36.0, 36.6, (179.5, 194.3))]:
        for xx in [xs[0] + 0.3 + 0.45 * i for i in range(int((xs[1] - xs[0]) / 0.45))]: box("r_metal", xx, y0 + 0.2, F1 + 4.0, xx + 0.06, y0 + 0.3, F1 + 7.5)
        box("r_wood", xs[0], y0, F1 + 7.5, xs[1], y1, F1 + 12.0); box("r_wood", xs[0], y0 - 0.4, F1 + 3.8, xs[1], y1 + 0.4, F1 + 4.1)
    for xx, y0, y1 in [(193.7, 21.0, 36.6), (179.5, 21.0, 36.6)]:
        for yy in [y0 + 0.3 + 0.45 * i for i in range(int((y1 - y0) / 0.45))]: box("r_metal", xx + 0.25, yy, F1 + 4.0, xx + 0.35, yy + 0.06, F1 + 7.5)
        box("r_wood", xx, y0, F1 + 7.5, xx + 0.6, y1, F1 + 12.0)
    lettering(text_rings(["TICKETS"], 0.9), 186.9, F1 + 9.6, 36.62, "-y"); lettering(text_rings(["TICKETS"], 0.9), 186.9, F1 + 9.6, 20.98, "+y")
    # tower south wall (vestibule -> grand hall): three arched openings are cut in gen_everett_3d (tower_inner_cuts)
    # ---------- main staircase (stair & news room), U-plan, 2 x 13 risers ----------
    rise1 = (13.75 - F1) / 13; tread = 14.0 / 13
    for i in range(13):
        z = F1 + rise1 * (i + 1); y0 = 40.5 + tread * i
        box("r_wood", 176.6, y0, z - rise1, 181.0, y0 + tread + 0.1, z)
    box("r_wood", 176.6, 54.5, F1, 193.4, 58.2, 13.75)                              # landing
    rise2 = (F2 - 13.75) / 13
    for i in range(13):
        z = 13.75 + rise2 * (i + 1); y1 = 54.5 - tread * i
        box("r_wood", 189.0, y1 - tread - 0.1, z - rise2, 193.4, y1, z)
    # stringers, handrails and balusters
    def rail(x, ya, za, yb, zb, g="r_wood"):
        add(g, f"hull() {{ translate([{r(x)},{r(ya)},{r(za)}]) sphere(0.12,$fn=8); translate([{r(x)},{r(yb)},{r(zb)}]) sphere(0.12,$fn=8); }}")
    for xr, ya, za, yb, zb in [(181.1, 40.5, F1 + 3.2, 54.5, 13.75 + 3.2), (188.9, 54.5, 13.75 + 3.2, 40.5, F2 + 3.2)]:
        rail(xr, ya, za, yb, zb)
        n = 22
        for i in range(n + 1):
            t = i / n; yy = ya + (yb - ya) * t; zz = za + (zb - za) * t
            box("r_metal", xr - 0.05, yy - 0.05, zz - 3.2, xr + 0.05, yy + 0.05, zz)
    for xx, yy, zz in [(181.1, 40.5, F1), (188.9, 40.5, F2 - (F2 - 13.75)), (181.1, 54.5, 13.75), (188.9, 54.5, 13.75)]:
        box("r_wood", xx - 0.3, yy - 0.3, zz, xx + 0.3, yy + 0.3, zz + 4.2)
    box("r_wood", 188.6, 40.2, F1, 189.2, 40.8, F2 + 4.0)                          # tall newel at the top of flight B
    # 2nd-floor balustrade round the stair hole and the hall well
    def balus(x0, y0, x1, y1, z):
        rail(x0, y0, z + 3.3, x1 if x1 != x0 else x0, y1, z + 3.3) if False else None
        add("r_wood", f"hull() {{ translate([{r(x0)},{r(y0)},{r(z+3.3)}]) sphere(0.14,$fn=8); translate([{r(x1)},{r(y1)},{r(z+3.3)}]) sphere(0.14,$fn=8); }}")
        L = math.hypot(x1 - x0, y1 - y0); n = max(2, int(L / 0.45))
        for i in range(n + 1):
            xx = x0 + (x1 - x0) * i / n; yy = y0 + (y1 - y0) * i / n
            box("r_metal", xx - 0.04, yy - 0.04, z, xx + 0.04, yy + 0.04, z + 3.3)
    balus(176.5, 40.5, 188.8, 40.5, F2); balus(176.5, 40.5, 176.5, 58.2, F2)
    balus(WELL[0], WELL[1], WELL[2], WELL[1], F2); balus(WELL[0], WELL[3], WELL[2], WELL[3], F2)
    balus(WELL[0], WELL[1], WELL[0], WELL[3], F2); balus(WELL[2], WELL[1], WELL[2], WELL[3], F2)
    for x in (WELL[0], WELL[2]):
        for y in (WELL[1], WELL[3]): box("r_wood", x - 0.3, y - 0.3, F2, x + 0.3, y + 0.3, F2 + 4.0)

    # ---------- second floor (sheet 08): corridor, offices, hotel rooms ----------
    Z2 = (F2, C2)
    # cross walls carried up
    wall("x", 54.67, 1.5, 58.5, F2, 36.0, 1.4, [(30.5, 3.5, 8, 0, False)])
    wall("x", 71.83, 1.6, 26.67, *Z2, 0.8); wall("x", 71.83, 37.17, 58.4, *Z2, 0.8)
    wall("x", 144.0, 1.6, 26.67, *Z2, 1.4); wall("x", 144.0, 37.17, 58.4, *Z2, 1.4)
    wall("x", 175.0, 1.6, 26.67, *Z2, 1.4); wall("x", 175.0, 37.17, 40.3, *Z2, 1.4)
    wall("x", 262.67, 1.5, 58.5, F2, 36.0, 1.4, [(31.9, 3.5, 8, 0, False)])
    # corridor walls with office / room doors (doors are drawn separately, the walls get the openings)
    ROOMS_S = [(54.67, 71.83, ["No. 1"], None), (71.83, 82.0, ["No. 2"], None), (82.0, 89.9, ["LINEN"], None), (89.9, 102.9, ["No. 3"], None),
               (102.9, 115.8, ["No. 4"], None), (115.8, 144.0, ["RESTAURANT", "KEEPER", "PRIVATE"], None),
               (175.0, 187.5, ["PULLMAN", "AGENT"], None), (187.5, 199.8, ["GENERAL", "BAGGAGE", "AGENT"], None),
               (199.8, 223.6, ["SUPERINTENDENT", "NORTHERN", "DIVISION"], None), (223.6, 262.67, ["SUPERINTENDENT", "LA CROSSE", "DIVISION"], None)]
    ROOMS_T = [(62.9, 71.83, ["HELP"], None), (71.83, 82.0, ["HELP"], None), (88.8, 102.9, ["No. 5"], None), (102.9, 115.8, ["No. 6"], None),
               (115.8, 129.5, ["No. 7"], None), (129.5, 144.0, ["No. 8"], None),
               (194.0, 211.0, ["CONDUCTORS'", "ROOM"], None), (211.0, 223.6, ["TIME CARD", "ROOM"], None),
               (223.6, 251.7, ["SUPERINTENDENT", "PRAIRIE DU CHIEN", "DIVISION"], None), (251.7, 262.67, ["GENTLEMEN"], None)]
    def corridor_wall(wy, rooms, x0, x1, side, skip=()):
        ops = []
        for a, b, name, _ in rooms:
            c = (a + b) / 2 if b - a < 16 else b - 5.0
            ops.append((c, 3.3, 9.6, 0, False))
            office_door(c, wy, side, name)
        segs = [(x0, 144.0), (175.0, x1)] if not skip else [(x0, x1)]
        for s0, s1 in segs:
            wall("y", wy, s0, s1, *Z2, 0.6, [o for o in ops if s0 < o[0] < s1])
    corridor_wall(CORR[0], ROOMS_S, 54.67, 262.67, "+y")
    corridor_wall(CORR[1], [rm for rm in ROOMS_T], 54.67, 262.67, "-y")
    # trainmen's room in the tower (street half of the hall) - door in the tower's south wall
    office_door(159.5, 23.4, "+y", ["TRAINMEN'S", "ROOM"])
    # partitions between rooms
    for x in [82.0, 89.9, 102.9, 115.8, 187.5, 199.8, 223.6]: wall("x", x, 1.6, CORR[0], *Z2, 0.5)
    wall("x", 129.5, 15.0, CORR[0], *Z2, 0.5); wall("y", 15.0, 115.8, 143.4, *Z2, 0.5, [(122, 3, 7.5, 0, False)]); wall("x", 243.4, 12.0, CORR[0], *Z2, 0.5, [(20, 3, 7.5, 0, False)])
    for x in [62.9, 82.0, 88.8, 102.9, 115.8, 129.5, 194.0, 211.0, 223.6, 251.7]: wall("x", x, CORR[1], 58.4, *Z2, 0.5)
    # end rooms (skylights): east room x 1.5-54.67 and west room 262.67-317.5 open under the hipped roofs
    for (x0, y0, x1, y1) in [(18.5, 23.5, 33.5, 36.5), (276, 22.5, 292, 35.5)]:
        box("r_glass", x0, y0, 44.6, x1, y1, 44.8)

    # ---------- third floor stair (corridor, x 100-115.2) and tower stairs / ladders ----------
    n3 = 16; r3 = (F3 - F2) / n3; t3 = 15.2 / n3
    for i in range(n3): box("r_wood", 100.0 + t3 * i, 31.4, F2 + r3 * i, 100.0 + t3 * (i + 1) + 0.1, 36.2, F2 + r3 * (i + 1))
    for yy in (31.3, 36.3): rail(100.0, yy, F2 + 3.2, 115.2, F3 + 3.2)
    # tower: 3rd floor (39.5) -> tower floor (65.4): two flights in the tower's east half
    nT = 17; rT = (65.4 - F3) / (2 * nT); tT = 18.0 / nT
    for i in range(nT): box("r_wood", 146.0, 2.5 + tT * i, F3 + rT * i, 149.4, 2.5 + tT * (i + 1) + 0.1, F3 + rT * (i + 1))
    box("r_wood", 146.0, 20.5, F3, 153.6, 21.5, F3 + rT * nT)
    for i in range(nT): box("r_wood", 150.2, 20.5 - tT * (i + 1) - 0.1, F3 + rT * (nT + i), 153.6, 20.5 - tT * i, F3 + rT * (nT + i + 1))
    for xr in (149.6, 150.0): pass
    rail(149.7, 2.5, F3 + 3.2, 20.5, F3 + rT * nT + 3.2); rail(153.7, 20.5, F3 + rT * nT + 3.2, 2.5, 65.4 + 3.2)
    # ladders (sheet 05): 65.4 -> 89.8 and 89.8 -> 104.8, rails 3x12, treads 2x12 x 2'-0"
    def ladder(x0, ya, za, yb, zb, w=2.0):
        for xx in (x0, x0 + w):
            add("r_wood", f"hull() {{ translate([{r(xx)},{r(ya)},{r(za)}]) cube([0.25,0.9,0.25]); translate([{r(xx)},{r(yb)},{r(zb)}]) cube([0.25,0.9,0.25]); }}")
        n = int((zb - za) / 0.85)
        for i in range(1, n):
            t = i / n; box("r_wood", x0, ya + (yb - ya) * t, za + (zb - za) * t, x0 + w + 0.25, ya + (yb - ya) * t + 0.9, za + (zb - za) * t + 0.16)
    ladder(166.0, 12.0, 65.4, 4.0, 89.8 + 0.2); ladder(150.0, 10.0, 89.8, 4.0, 104.8 + 0.2)
    for z in (65.4, 89.8, 104.8): pass
    # clock floor: machinery house 9'-8" x 12'-4" x 9'-6" high, windows, drive rods to the four dials
    hx0, hy0, hx1, hy1 = 154.67, 5.6, 164.33, 17.9
    add("r_wood", f"difference() {{ translate([{hx0},{hy0},104.8]) cube([{r(hx1-hx0)},{r(hy1-hy0)},9.5]); translate([{hx0+0.25},{hy0+0.25},104.6]) cube([{r(hx1-hx0-0.5)},{r(hy1-hy0-0.5)},9.6]); "
             f"translate([{hx0-1},10.0,108.4]) cube([{r(hx1-hx0+2)},4,3]); translate([157.9,{hy0-1},108.4]) cube([3.2,{r(hy1-hy0+2)},3]); translate([162,{hy0-1},104.8]) cube([2.2,1.5,7]); }}")
    box("r_frosted", hx0 - 0.05, 10.0, 108.4, hx0 + 0.3, 14.0, 111.4); box("r_frosted", hx1 - 0.3, 10.0, 108.4, hx1 + 0.05, 14.0, 111.4)
    box("r_wood", hx0 - 0.3, hy0 - 0.3, 114.3, hx1 + 0.3, hy1 + 0.3, 114.6)
    box("r_metal", 158.0, 10.5, 105.0, 161.0, 13.0, 109.5)                                        # movement
    for tgt in [(159.5, 1.75, 117.5), (159.5, 21.75, 117.5), (144.9, 11.75, 115.0), (174.1, 11.75, 115.0)]:
        add("r_metal", f"hull() {{ translate([159.5,11.75,114.6]) sphere(0.12,$fn=8); translate([{tgt[0]},{tgt[1]},{tgt[2]}]) sphere(0.12,$fn=8); }}")
    # pendulum box
    box("r_wood", 158.3, 16.9, 95.0, 160.7, 17.9, 104.8)

    # ---------- columns (iron, first floor; wood, end rooms upstairs) ----------
    COLS1 = [(19.33, 39.67), (36.67, 39.67), (19.33, 20.33), (36.67, 20.33), (116.33, 20.83), (199.67, 43.67), (224.0, 43.67), (243.33, 43.67),
             (199.67, 16.5), (224.0, 16.5), (243.33, 16.5), (280.67, 39.67), (299.0, 39.67), (280.67, 20.33), (299.0, 20.33)]
    for x, y in COLS1:
        zb = 4.8 if x < 54 else 2.4 if x > 262 else F1
        add("r_metal", f"translate([{x},{y},{zb}]) {{ cylinder(r1=0.9,r2=0.6,h=1.6,$fn=16); cylinder(r=0.42,h={r(C1-zb)},$fn=16); translate([0,0,{r(C1-zb-2.4)}]) cylinder(r1=0.45,r2=1.2,h=2.4,$fn=16); }}")
    for x, y in [(25, 41.5), (37, 41.5), (18.5, 18.5), (37, 18.5), (281, 40.5), (299.3, 40.5), (281, 20.8), (299.3, 20.8)]:
        box("r_wood", x - 0.4, y - 0.4, F2, x + 0.4, y + 0.4, 40.0)

    # ---------- furniture ----------
    def bench(x0, y, ln, z, back=True):
        box("r_wood", x0, y - 0.9, z + 1.4, x0 + ln, y + 0.9, z + 1.6)
        if back: box("r_wood", x0, y - 0.12, z + 1.6, x0 + ln, y + 0.12, z + 3.6)
        for xx in (x0, x0 + ln / 2 - 0.15, x0 + ln - 0.3): box("r_metal", xx, y - 1.0, z, xx + 0.3, y + 1.0, z + 2.4)
    for y in (8, 14, 46, 52):
        for x in (6, 30): bench(x, y, 14, 4.8)
    for y in (34, 40, 46, 52):
        for x in (202, 214, 228, 246): bench(x, y, 9, F1)
    for y in (6, 12, 20, 26):
        for x in (202, 214, 228): bench(x, y, 9, F1)
    for x, y in [(147.5, 30), (162.5, 30), (147.5, 56), (162.5, 56)]: bench(x, y, 9, F1, back=False)
    # dining tables and chairs
    for x in (95, 107, 119, 131):
        for y in (8, 18, 30):
            add("r_wood", f"translate([{x},{y},{F1}]) {{ cylinder(r=0.25,h=2.4,$fn=8); translate([0,0,2.4]) cylinder(r=2.2,h=0.15,$fn=24); }}")
            add("r_plaster", f"translate([{x},{y},{F1+2.55}]) cylinder(r=2.25,h=0.04,$fn=24);")
            for a in (0, 90, 180, 270):
                cx = x + 3.0 * math.cos(math.radians(a)); cy = y + 3.0 * math.sin(math.radians(a))
                box("r_wood", cx - 0.7, cy - 0.7, F1 + 1.4, cx + 0.7, cy + 0.7, F1 + 1.55)
                box("r_wood", cx - 0.6, cy - 0.6, F1, cx - 0.5, cy - 0.5, F1 + 1.4); box("r_wood", cx + 0.5, cy + 0.5, F1, cx + 0.6, cy + 0.6, F1 + 1.4)
    # lunch counter and stools, back bar
    box("r_wood", 94.0, 45.0, F1, 138.0, 47.0, F1 + 3.4); box("r_stone", 93.8, 44.8, F1 + 3.4, 138.2, 47.2, F1 + 3.55)
    box("r_wood", 94.0, 56.4, F1, 138.0, 58.3, F1 + 7.5)
    for x in [95.5 + 2.5 * i for i in range(17)]:
        add("r_metal", f"translate([{r(x)},43.6,{F1}]) {{ cylinder(r=0.12,h=2.4,$fn=8); translate([0,0,2.4]) cylinder(r=0.6,h=0.2,$fn=16); }}")
    # news & cigars counter under flight B
    box("r_wood", 189.2, 44.0, F1, 193.4, 52.0, F1 + 3.6); box("r_glass", 189.2, 44.0, F1 + 3.6, 193.4, 52.0, F1 + 5.2)
    # offices: desks, chairs, letter files; superintendents get a large table
    for a, b, name, _ in ROOMS_S[6:] + ROOMS_T[6:9]:
        street = a in [r_[0] for r_ in ROOMS_S]
        cx = (a + b) / 2; cy = 10.0 if street else 50.0
        box("r_wood", cx - 2.5, cy - 1.4, F2, cx + 2.5, cy + 1.4, F2 + 2.6); box("r_wood", cx - 2.5, cy + 1.2 * (1 if street else -1) - 0.2, F2 + 2.6, cx + 2.5, cy + 1.4 * (1 if street else -1), F2 + 4.4)
        box("r_wood", cx - 0.7, cy - (2.8 if street else -2.8) - 0.7, F2 + 1.5, cx + 0.7, cy - (2.8 if street else -2.8) + 0.7, F2 + 1.65)
        fy = 2.0 if street else 57.6
        box("r_wood", a + 1.0, fy - 0.5 if not street else fy, F2, a + 4.0, fy + 1.0 if street else fy + 0.5, F2 + 6.5)
        if "SUPERINTENDENT" in name:
            box("r_wood", cx - 5, cy + (5 if street else -5) - 2, F2 + 2.4, cx + 5, cy + (5 if street else -5) + 2, F2 + 2.6)
            for xx in (cx - 4.7, cx + 4.5):
                for yy in (cy + (5 if street else -5) - 1.8, cy + (5 if street else -5) + 1.6): box("r_wood", xx, yy, F2, xx + 0.2, yy + 0.2, F2 + 2.4)
    # hotel rooms: bed, wash stand
    for a, b, name, _ in ROOMS_S[:5] + ROOMS_T[2:6]:
        street = (a, b) in [(rr[0], rr[1]) for rr in ROOMS_S]
        cx = (a + b) / 2; y0 = 2.0 if street else 51.0
        box("r_wood", cx - 2.4, y0, F2, cx + 2.4, y0 + 6.6, F2 + 2.2); box("r_plaster", cx - 2.2, y0 + 0.2, F2 + 2.2, cx + 2.2, y0 + 6.4, F2 + 2.6)
        box("r_wood", cx - 2.4, (y0 if street else y0 + 6.3), F2, cx + 2.4, (y0 + 0.3 if street else y0 + 6.6), F2 + 4.8)
    # ---------- gas lamps (pendants + globes) ----------
    LAMPS = [(x, y, C1) for x in (10, 27, 44) for y in (15, 45)] + [(x, y, C1) for x in (100, 116, 132) for y in (10, 30, 50)] + \
            [(x, y, C1) for x in (205, 222, 240, 256) for y in (12, 22, 38, 50)] + [(x, y, C1) for x in (278, 296, 312) for y in (15, 45)] + \
            [(x, y, C1) for x in (63, 80) for y in (30,)] + [(x, 32.0, C2) for x in range(60, 262, 12) if not 142 < x < 178] + \
            [((a + b) / 2, 12.0, C2) for a, b, n, _ in ROOMS_S] + [((a + b) / 2, 48.0, C2) for a, b, n, _ in ROOMS_T]
    for x, y, c in LAMPS:
        add("r_metal", f"translate([{r(x)},{r(y)},{r(c-4.0)}]) cylinder(r=0.05,h=4.0,$fn=6);")
        add("r_lamp", f"translate([{r(x)},{r(y)},{r(c-4.3)}]) sphere(r=0.55,$fn=14);")
    # grand-hall chandelier hanging from the lay-light, 12 globes
    add("r_metal", f"translate([159.5,45,{C1-2}]) cylinder(r=0.08,h={r(C2-C1+2)},$fn=6);")
    add("r_metal", f"translate([159.5,45,{C1-2}]) rotate_extrude($fn=32) translate([3.5,0]) circle(0.1,$fn=6);")
    for i in range(12):
        a = math.radians(30 * i); add("r_lamp", f"translate([{r(159.5 + 3.5 * math.cos(a))},{r(45 + 3.5 * math.sin(a))},{r(C1-1.6)}]) sphere(r=0.5,$fn=12);")
    add("r_lamp", "translate([159.5,11.75,113.0]) sphere(r=0.4,$fn=12);")        # lantern on the clock floor

    emit_walls()
    return G
