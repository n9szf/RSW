# Everett Street depot - POWER HOUSE (built after 1886 - the 1886 depot had its own engine & boiler room in the basement, east end).
# Sources (MPL, private): #17 first-floor + foundation plans, #12 west & east elevations, #16 section A-B, #14 chimney;
#   all "C.M.&St.P.Ry. Power House at Union Depot, Milwaukee - W. A. Holbrook, Archt."  #70 conduit/"sewer" to the station.
#   #61 is an earlier PROPOSED engine house (Plan No. 2, Dept. B&B, "west elevation facing depot") - reference only.
# Local units feet: x from the WEST face eastward, y from the NORTH (street-line) face southward; z from the engine-room floor (= grade).
# Plan dims are written on #17 (50'-9" square block, 60'-6 1/2" over the chimney); elevations scaled to them (11.0 px/ft, +-0.5 ft).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle, Polygon
W, D, T = 50.75, 50.75, 1.08                      # block 50'-9" x 50'-9", walls 13"
CH = (50.75, 39.75, 60.54, 50.75)                 # chimney base 9'-9 1/2" x 11'-0" at the SE corner
def arc(xc, zc, r, a0=0, a1=180, n=24): return [(xc+r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc+r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]
SHEETS = {}
# =========================== PLAN ===========================
P = []
def p(n, pts, **k): P.append((n, pts, k))
def rect(n, x0, y0, x1, y1, **k): p(n, [(x0,y0),(x1,y0),(x1,y1),(x0,y1),(x0,y0)], **k)
def wall(x0, y0, x1, y1): rect("wall", x0, y0, x1, y1, fill="#c9a89f")
wall(0,0,W,T); wall(0,D-T,W,D); wall(0,0,T,D); wall(W-T,0,W,D)
wall(20.33,T,21.42,D-T)                                   # engine room | boiler room
wall(21.42,11.08,W-T,12.16)                               # coal room / ash pit | boiler room
wall(41.42,T,42.5,11.08)                                  # coal room | ash pit
wall(CH[0],CH[1],CH[2],CH[3]); rect("flue 48\" sq, iron ladder", 53.6,43.25,57.6,47.25, fill="white")
for x0, x1 in [(4.7,9.1),(13.8,18.1),(40.2,44.6),(26.1,30.5)]: rect("window", x0, D-T, x1, D, fill="white")      # south
for x0, x1 in [(4.7,9.1),(13.8,18.1),(43.9,48.2)]: rect("window", x0, 0, x1, T, fill="white")                     # north
for x0, x1 in [(22.1,27.9),(32.3,38.1)]: rect("iron coal doors", x0, -0.6, x1, T, fill="#999")
for y0, y1 in [(4.5,8.6),(26.8,31.3),(37.8,42.1)]: rect("window", 0, y0, T, y1, fill="white")                     # west
rect("door to tunnel", 0, 12.7, T, 19.0, fill="white")
rect("big door (arched)", W-T, 12.4, W, 22.9, fill="white")
for y0, y1 in [(25.7,30.3),(31.4,35.6)]: rect("window", W-T, y0, W, y1, fill="white")
rect("ash door", W-T, 4.0, W, 8.1, fill="white")
for x0, y0, x1, y1 in [(25.0,19.6,33.6,28.9),(38.2,19.6,46.8,28.9)]: rect("boiler setting (brick, 6'-6\" high)", x0, y0, x1, y1)
for x0, x1, c in [(26.7,31.4,29.0),(40.0,44.6,42.3)]:
    rect("boiler", x0, 28.9, x1, 44.1); p("boiler", arc(c, 32.0, 1.4, 0, 360)); p("boiler", arc(c, 42.0, 1.4, 0, 360))
p("tank (round, ~8 ft dia.)", arc(35.9, 36.7, 4.0, 0, 360))
for y in [17.4, 33.3]: p("iron truss above", [(21.4,y),(W-T,y)], ls="--")
p("tunnel (to the depot, west)", [(-12,13.4),(23.5,13.4)], ls="--"); p("tunnel (to the depot, west)", [(-12,15.8),(23.5,15.8)], ls="--")
TXT = [(10.7,26,"ENGINE ROOM\n19'-3\" wide"),(31.4,6.1,"COAL ROOM\n20'-0\" x 10'-0\""),(45.9,6.1,"ASH\nPIT"),(36,15,"BOILER ROOM"),(55.6,41.5,"STACK"),
       (-6,17.5,"tunnel\nto depot"),(25,-4,"NORTH - street line"),(25,55,"SOUTH")]
# foundation plan (right): 51'-3" square, footing 8'-10" below floor, chimney footing 12'-0" sq inside a stepped base ~18 ft sq
FO = 75.0
def fr(x0,y0,x1,y1,**k): rect("foundation", x0+FO, y0, x1+FO, y1, **k)
fr(-0.25,-0.25,51.0,51.0); fr(1.2,1.2,49.55,49.55); fr(20.0,1.2,21.75,49.55,fill="#c9a89f")
for k in range(4): fr(CH[0]-1.5-k*1.0+1.5, CH[1]-1.5-k*1.0, CH[2]+k*1.0+1.0, CH[3]+k*1.0+1.0)
fr(51.75,41.0,60.0,49.5)
p("tunnel", [(FO-0.25,13.4),(FO+21.0,13.4),(FO+21.0,15.8),(FO-0.25,15.8)], ls="--")
TXT += [(FO+25,-4,"FOUNDATION PLAN  51'-3\" sq; footings 8'-10\" below the floor"),(FO+56,54,"chimney footing\n12'-0\" sq, stepped")]
SHEETS["plan"] = (P, TXT, "POWER HOUSE - FIRST-FLOOR PLAN and FOUNDATION PLAN (MPL #17, W. A. Holbrook, Archt.)", (-16, 140, -8, 62))

# =========================== ELEVATIONS + SECTION ===========================
E = []
def e(n, pts, **k): E.append((n, pts, k))
def erect(n, x0, z0, x1, z1, **k): e(n, [(x0,z0),(x1,z0),(x1,z1),(x0,z1),(x0,z0)], **k)
def ewin(x0, x1, z0=5.0, z1=17.0, tr=13.5):
    erect("window", x0, z0, x1, z1); e("sash", [(x0,tr),(x1,tr)]); e("sash", [((x0+x1)/2,z0),((x0+x1)/2,tr)])
    e("lintel", [(x0-0.6,z1+0.5),(x1+0.6,z1+0.5)])
def stack(c, base_w=11.0, ped=26.3, z_vis=0.0):
    if z_vis < ped: erect("chimney", c-base_w/2, z_vis, c+base_w/2, ped)
    e("chimney", [(c-5.0,max(ped,z_vis)),(c-5.0,84.3),(c+5.0,84.3),(c+5.0,max(ped,z_vis))])
    erect("chimney cap", c-5.8, 84.3, c+5.8, 102.4); e("chimney cap", [(c-5.8,96),(c+5.8,96)])
    for k in (-1,0,1): e("flute", [(c+k*1.2,ped+8),(c+k*1.2,82)])
def roof(x0, x1, lant, gable_c, eave=20.0):
    erect("wall", x0, 0, x1, eave); e("cornice", [(x0-0.6,eave),(x1+0.6,eave)]); e("cornice", [(x0,eave-1.0),(x1,eave-1.0)])
    e("roof", [(x0+0.3,eave),(x0+4.0,36.3),(x1-4.0,36.3),(x1-0.3,eave)]); e("cresting", [(x0+4.0,37.0),(x1-4.0,37.0)])
    for x in (x0, x1): erect("corner pier", x-0.5, eave, x+0.5, 38.0)
    e("gable", [(gable_c-7.5,eave),(gable_c-7.5,23.5),(gable_c-6,23.5),(gable_c-6,26),(gable_c-4,26),(gable_c,32.6),(gable_c+4,26),(gable_c+6,26),(gable_c+6,23.5),(gable_c+7.5,23.5),(gable_c+7.5,eave)])
    e("roundel 42\"", arc(gable_c, 26.3, 1.75, 0, 360)); e("roundel 42\"", arc(gable_c, 26.3, 2.4, 0, 360))
    e("lantern", [(lant-2.5,36.3),(lant-2.5,43.1),(lant+2.5,43.1),(lant+2.5,36.3)]); erect("louvre", lant-1.2, 38.5, lant+1.2, 41.5)
    e("spire", [(lant-2.6,43.1),(lant,59.0),(lant+2.6,43.1)]); e("vane", [(lant,59.0),(lant,68.4)])
    e("ground", [(x0-4,0),(x1+4,0)])
# West elevation (seen from the west: north on the LEFT): u = y
OW = 0.0
roof(OW+0, OW+W, OW+24.3, OW+24.3)
for y0, y1 in [(4.5,8.6),(26.8,31.3),(37.8,42.1)]: ewin(OW+y0, OW+y1)
erect("door", OW+12.7, 0, OW+19.0, 10.4); e("door leaf", [(OW+15.85,0),(OW+15.85,10.4)]); ewin(OW+12.7, OW+19.0, 10.9, 16.8, 13.8)
stack(OW+45.25, 11.0, 26.3, z_vis=36.3)   # behind the roof
# East elevation (seen from the east: north on the RIGHT): u = OE + (D - y), chimney base at the left
OE = 72.0
roof(OE+0, OE+W, OE+(D-25.8), OE+(D-17.65), eave=22.7)
stack(OE+5.5, 11.0, 26.3)
c = OE+(D-17.65); erect("big door", c-5.25, 0, c+5.25, 17.0); e("arch", [(xx, zz) for xx, zz in arc(c, 17.0, 5.25)]); e("door leaf", [(c,0),(c,14.5)]); e("door leaf", [(c-5.25,14.5),(c+5.25,14.5)])
for y0, y1 in [(25.7,30.3),(31.4,35.6)]: ewin(OE+(D-y1), OE+(D-y0), 5.0, 18.0, 14.5)
erect("ash door", OE+(D-8.1), 0, OE+(D-4.0), 5.0)
# Section A-B (looking north): engine room (west) low roof with flat top; boiler room pyramid roof + lantern
OS = 144.0
e("floor", [(OS-2,0),(OS+W+2,0)]); e("section wall", [(OS,-8.8),(OS,20.4)]); e("section wall", [(OS+W,-8.8),(OS+W,20.4)]); e("section wall", [(OS+20.9,-8.8),(OS+20.9,31.0)])
for x in (OS, OS+W, OS+20.9): erect("footing", x-1.2, -10.0, x+1.2, -8.8)
e("roof (engine room)", [(OS-0.5,20.4),(OS+8.0,31.0),(OS+20.9,31.0)]); e("cresting", [(OS+8.0,31.6),(OS+20.9,31.6)])
erect("4x4 post", OS+10.3, 20.4, OS+10.6, 31.0); e("2x12 trussed beam", [(OS,20.4),(OS+20.9,20.4)])
e("roof (boiler room)", [(OS+20.9,20.4),(OS+35.9,34.4),(OS+W+0.5,20.4)])
e("roof truss (R.R. iron, 5'-0\" c.)", [(OS+23.0,22.4),(OS+35.9,27.5),(OS+48.8,22.4)]); e("roof truss (R.R. iron, 5'-0\" c.)", [(OS+35.9,27.5),(OS+35.9,34.4)])
e("roof truss (R.R. iron, 5'-0\" c.)", [(OS+29.0,28.8),(OS+35.9,27.5),(OS+42.8,28.8)])
e("lantern", [(OS+33.4,34.4),(OS+33.4,43.1),(OS+38.4,43.1),(OS+38.4,34.4)]); e("spire", [(OS+33.3,43.1),(OS+35.9,59.0),(OS+38.5,43.1)])
erect("boiler setting (brick)", OS+25.0, 0, OS+46.8, 6.5); e("R.R. iron", [(OS+20.9,9.0),(OS+W,9.0)])
for x0, x1 in [(4.5,8.6),(13.8,18.1)]: ewin(OS+x0, OS+x1, 5.5, 17.0, 13.0)
for x0, x1 in [(26.1,30.5),(33.0,37.4),(40.2,44.6)]: erect("window (beyond)", OS+x0, 13.5, OS+x1, 17.5)
e("grade", [(OS+W,-0.3),(OS+W+4,-0.3)])
ETXT = [(OW+W/2,-6,"WEST ELEVATION (faces the depot)\nN left - S right"),(OE+W/2+5,-6,"EAST ELEVATION\nS left - N right"),(OS+W/2,-6,"SECTION A-B looking north\nengine room | boiler room")]
LV = [("chimney top", 102.4), ("vane", 68.4), ("spire tip", 59.0), ("roof top / cresting", 36.3), ("gable peak", 32.6), ("cornice (east 22.7)", 20.0), ("floor = grade", 0.0), ("footings", -8.8)]
SHEETS["elev"] = (E, ETXT, "POWER HOUSE - WEST & EAST ELEVATIONS and SECTION A-B (MPL #12, #16, W. A. Holbrook, Archt.)", (-6, 222, -14, 108), LV)

for key, val in SHEETS.items():
    items, txt, title, lim = val[:4]
    doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
    flip = (key == "plan")
    fig, ax = plt.subplots(figsize=(17, 11) if key == "elev" else (17, 9.5))
    for n, pts, k in items:
        pp = [(x, -y) for x, y in pts] if flip else pts
        msp.add_lwpolyline(pp, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
        if k.get("fill"): ax.add_patch(Polygon(pp, closed=True, fc=k["fill"], ec="#7a2318", lw=0.8))
        else:
            xs, ys = zip(*pp)
            ax.plot(xs, ys, color=("#334" if "roof" in n or "spire" in n else "#888" if "truss" in n or "tunnel" in n or "beyond" in n else "#222" if n in ("window","sash","lintel","door","door leaf","louvre","flute","boiler","ash door","big door","arch") else "#7a2318"),
                    lw=(0.4 if n in ("sash","flute","door leaf") else 0.9), ls=k.get("ls","-"))
    for x, y, t in txt: ax.text(x, -y if flip else y, t, ha="center", va="center", fontsize=7)
    if key == "elev":
        last = 1e9
        for t, z in sorted(val[4], key=lambda v: -v[1]):
            zt = min(z, last - 3.4); last = zt
            ax.plot([200, 204, 206], [z, z, zt], color="#999", lw=0.5); ax.text(207, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
    ax.set_title("Milwaukee Union Depot (Everett St) - " + title + " - Rev A", fontsize=10)
    note = ("Built after 1886 (the 1886 depot heated itself from its basement boiler room); a conduit runs west to the depot basement (MPL #70, about 100 ft).\n"
            "Plan dimensions as written on #17; elevations and section scaled to them (+-0.5 ft).  Heights on #16 differ by up to ~3 ft from #12 - #12 used.  Rev A 11/22/2026")
    x0, x1, y0, y1 = lim
    ax.text(x0, (y0 - 4) if not flip else -(y1 + 3), note, fontsize=6.5, va="top")
    ax.set_aspect("equal"); ax.set_xlim(x0, x1)
    if flip: ax.set_ylim(-(y1 + 12), -y0)
    else: ax.set_ylim(y0 - 12, y1)
    ax.axis("off"); plt.tight_layout()
    fn = "Everett_powerhouse_plan" if key == "plan" else "Everett_powerhouse_elevations"
    doc.saveas(fn + ".dxf"); plt.savefig(fn + ".pdf"); plt.savefig(fn + ".png", dpi=170); plt.close(fig)
print("ok")
