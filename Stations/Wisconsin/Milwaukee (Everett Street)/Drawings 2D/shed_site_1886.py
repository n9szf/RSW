# Everett Street depot - TRAIN SHED and SITE.  Rev A.
# Sources (MPL, private): #27 "Plan of shed for depot at Milwaukee, Wis." (C.M.&St.P. Chief Engineer's Office, scale 1"=40'?), streets and tracks;
#   #28 "Cross section of train shed - as built" (scale 1/4"); #02 Mix's design end elevation with the arched, ornamented shed (not as built);
#   #70 conduit profile depot -> power house; #17 power house plan.
# Model coordinates: x from the depot's EAST face, growing WEST; y from the depot's street (north) face, growing SOUTH.  Feet.
# #27 is low resolution (~2 px/ft): +-3 ft.  Track positions under the shed are taken from the #02 elevation (design) - +-3 ft.
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Polygon
L, D = 319.0, 60.0
SH_X0, SH_X1 = -127.0, 434.0            # shed length ~561 ft (#27 notes 228' + 338')
COL_N, COL_S = 87.0, 153.5              # column rows (span 66'-6")
EAVE_N, EAVE_S = COL_N - 13.5, COL_S + 13.5
BAY = 25.0
TRACKS = [94.8, 112.4, 124.7, 141.4, 162.0]   # 5th track outside the south columns, under the eave
POWER = (-154.0, -103.0, -12.0, 39.0)    # power house (x0, x1, y0, y1): east of Third St, conduit ~103 ft
items = []
def ln(n, pts, **k): items.append((n, pts, k))
def rect(n, x0, y0, x1, y1, **k): ln(n, [(x0,y0),(x1,y0),(x1,y1),(x0,y1),(x0,y0)], **k)
# ---------- PLAN (north up, east on the RIGHT as on #27: draw u = -x) ----------
U = lambda x: -x
def R(n, x0, y0, x1, y1, **k): rect(n, U(x1), -y1, U(x0), -y0, **k)
R("depot", 0, 0, L, D, fill="#e8d8d3")
R("tower", 141.67, -1.5, 177.33, 25.0, fill="#c9a89f")
R("shed roof (outline)", SH_X0, EAVE_N, SH_X1, EAVE_S, ls="--")
for y in [(EAVE_N+EAVE_S)/2]: ln("ridge / monitor", [(U(SH_X0), -y), (U(SH_X1), -y)], ls="-.")
n = int((SH_X1 - SH_X0) / BAY)
for i in range(n + 1):
    x = SH_X0 + i * (SH_X1 - SH_X0) / n
    for y in (COL_N, COL_S): R("column", x-0.8, y-0.8, x+0.8, y+0.8, fill="#333")
for y in TRACKS: ln("track", [(U(SH_X1 + 60), -y), (U(SH_X0 - 60), -y)])
for x0, x1 in [(0, 55), (264, 319), (120, 200)]:
    ln("connecting canopy (V roofs, #27)", [(U(x0), -D), (U((x0+x1)/2), -(COL_N - 8)), (U(x1), -D)], ls=":")
# streets
for xa, xb, name in [(-32, -57, "THIRD STREET"), (352, 377, "FOURTH STREET")]:
    for x in (xa, xb): ln("street line", [(U(x), 40), (U(x), -235)], ls="--")
    items.append(("_text", [(U((xa+xb)/2), -200)], {"t": name, "rot": 90}))
ln("street line", [(U(-200), -8), (U(480), -8)], ls="--"); ln("street line", [(U(-200), 40), (U(480), 40)], ls="--")
items.append(("_text", [(U(160), 24)], {"t": "EVERETT STREET  -  park (Fourth Ward Park) beyond, north"}))
ln("street line", [(U(-200), -215), (U(480), -215)], ls="--"); items.append(("_text", [(U(160), -225)], {"t": "CLYBOURN STREET (south)"}))
R("power house", POWER[0], POWER[2], POWER[1], POWER[3], fill="#e8d8d3"); R("stack", -163.5, 27.75, -153.75, 38.75, fill="#c9a89f")   # SE corner (#17)
ln("conduit / tunnel (#70)", [(U(0), -2.6), (U(-103), -2.6)], ls="--")
for t, x, y in [("DEPOT  319' x 60'", 159.5, 40), ("POWER\nHOUSE", -128.5, 14), ("TRAIN SHED  about 561' x 66'-6\" between columns, ~93' over eaves", 154, 120),
                ("EAST ->", -190, 0), ("<- WEST", 470, 0)]:
    items.append(("_text", [(U(x), -y)], {"t": t}))

doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
fig = plt.figure(figsize=(17, 11)); ax = fig.add_axes([0.02, 0.38, 0.96, 0.57]); ax2 = fig.add_axes([0.06, 0.03, 0.55, 0.33]); ax3 = fig.add_axes([0.64, 0.05, 0.34, 0.3])
for n, pts, k in items:
    if n == "_text": ax.text(pts[0][0], pts[0][1], k["t"], ha="center", va="center", fontsize=7, rotation=k.get("rot", 0)); continue
    msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
    if k.get("fill"): ax.add_patch(Polygon(pts, closed=True, fc=k["fill"], ec="#7a2318", lw=0.8))
    else:
        xs, ys = zip(*pts); ax.plot(xs, ys, color="#555" if n == "track" else "#7a2318" if "shed" in n else "#888", lw=0.9 if n == "track" else 0.7, ls=k.get("ls", "-"))
ax.set_aspect("equal"); ax.set_xlim(-500, 210); ax.set_ylim(-240, 45); ax.axis("off")
ax.set_title("Milwaukee Union Depot (Everett St) - SITE PLAN, TRAIN SHED and POWER HOUSE (MPL #27, #28, #02, #17, #70; private reference) - Rev A", fontsize=10)

# ---------- CROSS SECTION of the shed, as built (#28), looking west; north (depot) on the RIGHT ----------
S = []
def s(n, pts): S.append((n, pts))
c0 = 0.0; span = COL_S - COL_N                   # local v: 0 = south column, span = north column
s("ground", [(-18, 0), (span + 40, 0)])
for v in (0, span):
    s("column", [(v-0.5, 0), (v-0.5, 19.0), (v+0.5, 19.0), (v+0.5, 0)])
    s("footing", [(v-2.0, 0), (v-2.0, -8.0), (v-3.0, -8.0), (v-3.0, -9.8), (v+3.0, -9.8), (v+3.0, -8.0), (v+2.0, -8.0), (v+2.0, 0)])
    s("bracket", [(v - 6.0 * (1 if v == 0 else -1), 20.6), (v, 14.5)]); s("bracket", [(v + 6.0 * (1 if v == 0 else -1), 22.0), (v, 14.5)])
mid = span / 2
s("rafter", [(-13.5, 20.6), (mid, 38.0), (span + 13.5, 20.6)])
s("bottom chord (arched)", [(0, 22.0)] + [(mid + (v - mid), 22.0 + 7.8 * (1 - ((v - mid) / mid) ** 2)) for v in [i * span / 20 for i in range(21)]] + [(span, 22.0)])
for i in range(1, 8):
    v = i * span / 8; top = 20.6 + (38.0 - 20.6) * (1 - abs(v - mid) / (mid + 13.5)); bot = 22.0 + 7.8 * (1 - ((v - mid) / mid) ** 2)
    s("web", [(v, bot), (v + (span / 16 if v < mid else -span / 16), top - 1.2)])
s("king post", [(mid, 29.8), (mid, 38.0)])
s("monitor", [(mid - 6.5, 36.0), (mid - 6.5, 41.5), (mid, 44.6), (mid + 6.5, 41.5), (mid + 6.5, 36.0)])
for t in TRACKS:
    v = COL_S - t
    s("rail", [(v - 2.35, 0.3), (v + 2.35, 0.3)]); s("car (1880s coach, ~10' wide x 14' high)", [(v - 5, 1.5), (v - 5, 12.5), (v - 3.5, 14.0), (v + 3.5, 14.0), (v + 5, 12.5), (v + 5, 1.5), (v - 5, 1.5)])
s("depot track wall (60' from street)", [(span + (COL_N - D), 0), (span + (COL_N - D), 39.5)])
for n, pts in S:
    xs, ys = zip(*pts)
    ax2.plot(xs, ys, color="#bbb" if "car" in n else "#7a2318" if n in ("column","footing","depot track wall (60' from street)") else "#334", lw=0.6 if n in ("web","rail") else 1.0)
for z, t in [(44.6, "monitor top 44.6'"), (38.0, "ridge 38.0'"), (20.6, "eaves 20.6'"), (19.0, "column cap 19'"), (0, "top of rail / platform"), (-9.8, "footing -9.8' (piles below)")]:
    ax2.plot([span + 32, span + 36], [z, z], color="#999", lw=0.5); ax2.text(span + 37, z, t, fontsize=6.3, va="center")
ax2.text(mid, -15, "CROSS SECTION OF TRAIN SHED - as built (MPL #28), looking west.  66'-6\" between columns, 93' over the eaves.\n"
         "Depot track wall on the right.  Cars drawn as 1880s coaches for scale; tracks from the #02 elevation (+-3 ft).", ha="center", fontsize=6.5, va="top")
ax2.set_aspect("equal"); ax2.set_xlim(-20, span + 60); ax2.set_ylim(-22, 48); ax2.axis("off")

# ---------- CONDUIT PROFILE depot -> power house (#70), datum = depot first floor 4.5 ----------
off = 4.5 - 20.0   # passenger-room floor is 20.0 ft above the #70 datum
prof = [("floor in passenger room", [(-30, 20.0), (-6, 20.0)]), ("floor in emigrant room", [(-6, 21.24), (0, 21.24)]),
        ("depot engine room floor", [(-30, 9.0), (0, 9.0)]), ("depot wall", [(0, 7.0), (0, 23.0)]), ("coal room floor", [(0, 8.0), (40, 8.0)]),
        ("wall", [(40, 7.0), (40, 15.0)]), ("conduit invert", [(40, 8.0), (143, 8.0)]), ("conduit crown", [(40, 14.2), (143, 14.2)]),
        ("power house wall", [(143, 7.0), (143, 20.0)]), ("power house engine room floor", [(143, 15.0), (170, 15.0)])]
for n, pts in prof:
    xs, ys = zip(*pts); ys = [y + off for y in ys]
    ax3.plot(xs, ys, color="#7a2318" if "wall" in n else "#334", lw=1.0)
for x, y, t in [(-18, 21.2, "passenger floor 4.5"), (-15, 10.2, "depot engine room -6.5"), (20, 9.2, "coal room -7.5"), (92, 11.1, "CONDUIT ~6' high, ~103' long"),
                (156, 16.2, "power house floor -0.5")]:
    ax3.text(x, y + off, t, fontsize=6, ha="center")
ax3.text(70, -14, "CONDUIT PROFILE (MPL #70), depot east end -> power house.  Levels from the written heights above the #70 datum,\n"
         "shifted so the passenger floor = 4.5.  Conflicts with the -9.0 basement assumed on the sections - to review.", ha="center", fontsize=6, va="top")
ax3.set_xlim(-35, 175); ax3.set_ylim(-20, 12); ax3.axis("off")

doc.saveas("Everett_site_and_shed.dxf"); plt.savefig("Everett_site_and_shed.pdf"); plt.savefig("Everett_site_and_shed.png", dpi=170); print("ok")
