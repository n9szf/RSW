# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - TOWER PLANS from MPL sheet 05 (survey sheet J-1141, later than 1886 - steel beams under the clock floor).
# Three levels: A great-arch / balcony level, B belfry (arcade) level, C clock stage.  Plus the ladder section from the same sheet.
# Units feet.  x from the EAST outside face, y from the street face (north at the bottom, like the other plans).
# The sheet is drawn SOUTH-up with EAST on the left - same as these plans, no flip.  Written dimensions used where given; the rest scaled (+-0.3 ft).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
OUT = []; TXT = []
def P(n, pts): OUT.append((n, pts))
def box(n, x0, y0, x1, y1): P(n, [(x0,y0),(x1,y0),(x1,y1),(x0,y1),(x0,y0)])
XC, YC = 159.5, 11.75                       # tower centre (plans: tower 141'-8" to 177'-4", street band to 25 ft)
def F(e, s, W, H):                           # sheet reading: e = ft from interior EAST face, s = ft from interior SOUTH face
    return (XC - W/2 + e, YC + H/2 - s)          # east = x0 side (left), as drawn on the sheet
def win_ew(e0, e1, side, W, H, t, n="window"):     # window in a north/south wall
    x0, _ = F(e0, 0, W, H); x1, _ = F(e1, 0, W, H); y = YC + H/2 if side == "S" else YC - H/2
    d = t if side == "S" else -t; box(n, x1, y, x0, y + d); P("glass", [(x1, y+d/2),(x0, y+d/2)])
def win_ns(s0, s1, side, W, H, t, n="window"):     # window in an east/west wall
    _, y0 = F(0, s0, W, H); _, y1 = F(0, s1, W, H); x = XC - W/2 if side == "E" else XC + W/2
    d = -t if side == "E" else t; box(n, x, y1, x + d, y0); P("glass", [(x+d/2, y1),(x+d/2, y0)])

# ---------- A: great-arch / balcony level (written dims: 29'-4" x 20'-10" inside) ----------
W, H = 29 + 4/12, 20 + 10/12
ox, oy = 141.67, -1.5                     # outside faces (35'-8" x 26'-6")
box("outside face", ox, oy, 177.33, 25.0)
box("inside face", XC-W/2, YC-H/2, XC+W/2, YC+H/2)
# N & S walls: 7'-7" | 2'-1" pier | 10'-6" open arch | 2'-1" pier | 7'-7"   (arches open to the street arch and to the hall)
for y0, y1 in [(oy, YC-H/2), (YC+H/2, 25.0)]:
    for u0, u1 in [(-W/2+7+7/12, -5.25), (5.25, W/2-7-7/12)]: box("pier", XC+u0, y0, XC+u0+(u1-u0 if u1>u0 else 0)+0, y1) if False else None
for u in [-(5.25+25/12), 5.25]:
    box("pier", XC+u, YC-H/2-0.9, XC+u+25/12, YC-H/2); box("pier", XC+u, YC+H/2, XC+u+25/12, YC+H/2+0.9)
P("open arch (above)", [(XC-5.25, YC-H/2-0.45),(XC+5.25, YC-H/2-0.45)]); P("open arch (above)", [(XC-5.25, YC+H/2+0.45),(XC+5.25, YC+H/2+0.45)])
# E & W walls: 4'-4" | 2'-1" | 8'-0" opening | 2'-1" | 4'-4"
for x in [XC-W/2, XC+W/2]:
    d = -0.9 if x < XC else 0.9
    for v in [-(4+25/12), 4]: box("pier", x, YC+v, x+d, YC+v+25/12)
    P("opening", [(x+d/2, YC-4),(x+d/2, YC+4)])
TXT += [(XC+38, YC+3, "A  GREAT-ARCH / BALCONY LEVEL\nopen arches N (street) and S (hall)\ninside 29'-4\" x 20'-10\"", 7)]

# ---------- B: belfry level (inside 25'-7 1/2" E-W; arcade windows 2'-11\" x 5'-10\", sills 27 1/2\" above floor) ----------
DX = 0; DY = 34                            # drawn above plan A (offset only for the sheet)
def shift(pts, dy): return [(x, y+dy) for x, y in pts]
B0 = len(OUT)
WB, HB, TB = 25 + 7.5/12, 20.5, 1.15
box("outside face", XC-28.0/2, YC-22.8/2, XC+28.0/2, YC+22.8/2)
box("inside face", XC-WB/2, YC-HB/2, XC+WB/2, YC+HB/2)
for e0, e1 in [(3.2,5.9),(7.3,10.0),(11.4,14.2),(15.6,18.4),(19.8,22.5)]:
    win_ew(e0, e1, "S", WB, HB, TB); win_ew(e0, e1, "N", WB, HB, TB)
for s0, s1 in [(2.4,5.1),(6.6,9.3),(10.8,13.6),(15.1,17.8)]:
    win_ns(s0, s1, "E", WB, HB, TB); win_ns(s0, s1, "W", WB, HB, TB)
x0, y0 = F(24.9, 11.6, WB, HB); x1, y1 = F(22.7, 5.9, WB, HB); box("trap door", x0, y0, x1, y1)
for i in range(15):
    x = XC - WB/2 + 3.0 + i*1.333; P("joists 2x12 @ 16\"", [(x, YC-3.5),(x, YC+3.5)])
TXT += [(XC+38, YC+DY, "B  BELFRY (ARCADE) LEVEL\n5 windows N & S, 4 E & W, 2'-11\" x 5'-10\"\ntrap door 2'-0\" x 5'-6\"", 7)]
OUT[B0:] = [(n, shift(p, DY)) for n, p in OUT[B0:]]

# ---------- C: clock stage (framing 9x10 posts; corner turrets with windows 26\" x 6'-8\") ----------
DY2 = 64
C0 = len(OUT)
WC, HC, TC = 25.7, 20.4, 1.3
box("inside face (9x10 tower framing)", XC-WC/2, YC-HC/2, XC+WC/2, YC+HC/2)
# outside: square with octagonal corner turrets, overall 32'-2" x 27'-7"
ow, oh, r = 32.2/2, 27.6/2, 4.4
for sx in (-1, 1):
    for sy in (-1, 1):
        cx, cy = XC + sx*(ow - r), YC + sy*(oh - r)
        oct_ = [(cx + r*math.cos(math.radians(22.5+45*k)), cy + r*math.sin(math.radians(22.5+45*k))) for k in range(9)]
        P("turret", oct_); P("turret", [(cx + (r-1.1)*math.cos(math.radians(22.5+45*k)), cy + (r-1.1)*math.sin(math.radians(22.5+45*k))) for k in range(9)])
        P("turret window", [(cx + sx*r*0.95, cy - 1.0),(cx + sx*r*0.95, cy + 1.0)]); P("turret window", [(cx - 1.0, cy + sy*r*0.95),(cx + 1.0, cy + sy*r*0.95)])
P("outside face", [(XC-ow+2*r*0.9, YC-HC/2-TC),(XC+ow-2*r*0.9, YC-HC/2-TC)]); P("outside face", [(XC-ow+2*r*0.9, YC+HC/2+TC),(XC+ow-2*r*0.9, YC+HC/2+TC)])
P("outside face", [(XC-WC/2-TC, YC-oh+2*r*0.9),(XC-WC/2-TC, YC+oh-2*r*0.9)]); P("outside face", [(XC+WC/2+TC, YC-oh+2*r*0.9),(XC+WC/2+TC, YC+oh-2*r*0.9)])
for e0, e1 in [(6.35,9.35),(11.3,14.4),(16.2,19.2)]:
    win_ew(e0, e1, "S", WC, HC, TC); win_ew(e0, e1, "N", WC, HC, TC)       # 28" x 5'-10", 6" above floor
for s0, s1 in [(6.3,9.2),(11.1,14.1)]:
    win_ns(s0, s1, "E", WC, HC, TC); win_ns(s0, s1, "W", WC, HC, TC)       # 40" x 5'-10"
x0, y0 = F(9.6+(25.7-9.6-9.67)/2+9.67, 16.3, WC, HC)
box("clock machinery house", XC-9.67/2, YC-12.33/2, XC+9.67/2, YC+12.33/2)
P("clock house window", [(XC-1.5, YC-12.33/2),(XC+1.5, YC-12.33/2)]); P("clock house window", [(XC+9.67/2, YC-1.5),(XC+9.67/2, YC+1.5)])
x0, y0 = F(24.9, 11.2, WC, HC); x1, y1 = F(23.1, 5.9, WC, HC); box("trap door", x0, y0, x1, y1)
for v in [-HC/2+0.4, HC/2-0.4]:
    for u in [-WC/2+0.4, -4.1, 4.1, WC/2-0.4]: box("post 9x10", XC+u-0.4, YC+v-0.4, XC+u+0.4, YC+v+0.4)
TXT += [(XC+38, YC+DY2, "C  CLOCK STAGE\nclock machinery house 9'-8\" x 12'-4\" x 9'-6\" high\nwindows: N & S 28\" x 5'-10\", E & W 40\" x 5'-10\", turrets 26\" x 6'-8\"", 7)]
OUT[C0:] = [(n, shift(p, DY2)) for n, p in OUT[C0:]]

# ---------- ladder section (sheet 05, right side) ----------
SX = 205.0
def S(n, pts): P(n, [(SX + a, b + 42) for a, b in pts])
for _z, _t in [(0, "belfry stage floor"), (22.0, "(22'-0\")"), (37.0, "clock floor (15'-0\")")]:
    pass
S("floor", [(0,0),(26,0)]); S("floor", [(0,22),(26,22)]); S("floor", [(0,22.9),(26,22.9)]); S("floor", [(0,37),(26,37)]); S("floor", [(0,37.9),(26,37.9)])
S("ladder", [(12,0),(19.5,22)]); S("ladder", [(13.2,0),(20.7,22)]); S("ladder", [(13,22.9),(19.5,37)]); S("ladder", [(14.2,22.9),(20.7,37)])
S("I-beam 15\" (later)", [(10.9,37),(10.9,35.8)]); S("I-beam 15\" (later)", [(14.7,37),(14.7,35.8)])
TXT += [(SX+13, 86.5, "LADDER SECTION (sheet 05)\n22'-0\" then 15'-0\" to the clock floor\nrails 3x12, treads 2x12 x 2'-0\"", 7),
        (SX+30, 53, "22'-0\"", 7), (SX+30, 71.5, "15'-0\"", 7)]

doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in OUT: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
doc.saveas("Everett_1886_tower_plans.dxf")
fig, ax = plt.subplots(figsize=(11, 17))
for n, pts in OUT:
    xs, ys = zip(*pts)
    ax.plot(xs, ys, color=("#7a2318" if n in ("outside face","inside face","pier","turret","inside face (9x10 tower framing)") else "#888" if "joist" in n or "arch" in n or n=="opening" else "#222"),
            lw=(1.3 if n in ("outside face","inside face","pier","turret") else 0.4 if "joist" in n or n=="glass" else 0.8), ls="--" if ("arch" in n or "joist" in n or n=="opening") else "-")
for x, y, t, fs in TXT: ax.text(x, y, t, ha="center", va="center", fontsize=fs)
ax.text(XC, -5, "STREET (north)", ha="center", fontsize=7); ax.text(XC, 98, "TRACK (south)", ha="center", fontsize=7)
ax.text(137, YC, "E", fontsize=8); ax.text(179, YC, "W", fontsize=8)
ax.set_title("Milwaukee Union Depot (Everett St) - TOWER PLANS from MPL sheet 05 (survey J-1141, private reference) - Rev A", fontsize=10)
ax.text(135, -10, "Same scale; x from the EAST face (141'-8\" to 177'-4\" is the tower), y from the street face.  Sheet 05 is a later survey (steel beams under the clock floor);\n"
        "1886 arrangement assumed the same.  Written dims used where given, the rest scaled +-0.3 ft.  Rev A 11/22/2026", fontsize=6.5, va="top")
ax.set_aspect("equal"); ax.set_xlim(132, 245); ax.set_ylim(-14, 100); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_tower_plans.pdf"); plt.savefig("Everett_1886_tower_plans.png", dpi=170); print("ok")
