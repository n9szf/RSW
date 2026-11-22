# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - TRACK-SIDE (SOUTH) ELEVATION, MPL sheet 01 ("South Side Elevation"). Rev A.
# Drawn as seen from the tracks: west (baggage) end on the LEFT.  Model x is measured from the EAST outside face.
# Sheet 01 is dimensioned: overall chain 320'-0" (56'-10", 38'-8", 48'-6", 6", 15'-6", 15'-6", 6", 54'-6", 17'-2", 17'-2", 55'-2");
# readings taken on the mirrored sheet in its own feet (w, from the east end) and scaled by 319/320 to the 319'-0" plans.
# Heights: first floor set to 4.5 ft as on the other drawings; scaled from the sheet (+-0.5 ft).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Circle
L = 319.0; K = L / 320.0
OUT = []
def X(w): return w * K
def P(n, pts): OUT.append((n, [(X(w), z) for w, z in pts]))
def box(n, x0, x1, z0, z1): P(n, [(x0,z0),(x1,z0),(x1,z1),(x0,z1),(x0,z0)])
def arc(xc, zc, r, a0=0, a1=180, n=24): return [(xc+r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc+r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]
def win(x0, x1, z0, z1, mull=0, rail=True, n="window"):
    box(n, x0, x1, z0, z1)
    if rail: P("sash", [(x0,(z0+z1)/2),(x1,(z0+z1)/2)])
    for i in range(1, mull+1): x = x0+(x1-x0)*i/(mull+1); P("sash", [(x,z0),(x,z1)])
def door(x0, x1, z0, z1):
    P("door", [(x0,z0),(x0,z1),(x1,z1),(x1,z0)]); P("door leaf", [((x0+x1)/2,z0),((x0+x1)/2,z1)])
def fan(xc, zs, r): P("arch", arc(xc, zs, r)); P("arch", arc(xc, zs, r+1.3)); P("arch", [(xc-r,zs),(xc+r,zs)])
def stepped(c, half, z0, peak):
    P("gable", [(c-half,z0),(c-3.5,peak-6),(c-3.5,peak-4.2),(c-2,peak-4.2),(c-2,peak-1.8),(c-0.8,peak-1.8),(c-0.8,peak),(c+0.8,peak),(c+0.8,peak-1.8),(c+2,peak-1.8),(c+2,peak-4.2),(c+3.5,peak-4.2),(c+3.5,peak-6),(c+half,z0)])
def dormer(c, half, z0, zs, peak): P("dormer", [(c-half,z0),(c-half,zs),(c,peak),(c+half,zs),(c+half,z0)])
def spire_gable(c, z0, peak, zb):
    P("spire gable", [(c-8.5,z0),(c,peak),(c+8.5,z0)])
    P("spire", [(c-1.6,zb),(c-1.6,60),(c,81),(c+1.6,60),(c+1.6,zb)]); P("vane", [(c,81),(c,85)])
    box("louvre", c-1.2, c+1.2, 55, 59.5)

# ---------------- outline ----------------
EAVE_END, EAVE_MAIN, RIDGE, ROOF_END = 23.5, 39.5, 58.1, 45.0
box("end block wall", 0, 55.2, 0, EAVE_END); box("end block wall", 263.0, 320, 0, EAVE_END)
P("end block roof", [(-1,EAVE_END),(12,ROOF_END),(55.2,ROOF_END)]); P("end block roof", [(263,ROOF_END),(308,ROOF_END),(321,EAVE_END)])
box("main block wall", 55.2, 263.0, 0, EAVE_MAIN)
P("main roof", [(55.2,EAVE_MAIN),(62,RIDGE),(256,RIDGE),(263,EAVE_MAIN)])
P("cornice", [(0,19.5),(55.2,19.5)]); P("cornice", [(263,19.5),(320,19.5)]); P("cornice", [(55.2,36.7),(263,36.7)])
P("first floor", [(0,4.5),(320,4.5)])
P("platform (approx.)", [(-6,-1.0),(326,-1.0)])
# chimneys: tall boiler stack at the east end-block junction (92.7 ft), roof stacks 74.5, end stacks 45.7
box("chimney", 51.4, 57.7, 0, 92.7); box("chimney", 196.0, 202.4, 0, 74.5)
for x0, x1 in [(113.8,119.6),(259.0,265.6)]: box("chimney", x0, x1, EAVE_MAIN, 74.5)
for x0, x1 in [(-1.1,2.4),(317.2,320.9)]: box("chimney", x0, x1, EAVE_END - 1, 45.7)

# ---------------- west end block (emigrants) ----------------
for x0, x1 in [(5.9,9.9),(11.5,15.4),(16.9,20.9),(36.6,40.5),(41.8,45.7),(47.2,51.3)]:
    win(x0, x1, 6.0, 12.5); win(x0, x1, 13.4, 17.1, rail=False, n="transom")
door(24.9, 32.5, 3.7, 13.2)
for x0, x1 in [(24.9,28.6),(28.8,32.5)]: win(x0, x1, 13.4, 17.1, rail=False, n="transom")
for z in [0.9, 1.8, 2.7, 3.7]: P("steps", [(23.0,z),(34.4,z)])
for c, x0, x1 in [(10.15,8.2,12.1),(46.7,44.9,48.5)]: win(x0, x1, 23.5, 30.7); dormer(c, 3.2, EAVE_END, 32.0, 37.5)
stepped(28.7, 11.0, EAVE_END, 41.3)
for x0, x1 in [(25.1,28.6),(28.8,32.5)]: win(x0, x1, 23.5, 27.4)
fan(28.8, 27.4, 3.7)
spire_gable(18.5, 40.0, 49.8, 51.0); win(17.2, 19.7, 41.3, 45.7, mull=1, rail=False)

# ---------------- main block, west part ----------------
door(58.0, 63.4, 3.0, 12.5); win(58.0, 63.4, 14.3, 17.9, rail=False, n="transom")
for z in [1.0, 2.0, 3.0]: P("steps", [(57.0,z),(64.4,z)])
for x0, x1 in [(65.4,69.6),(74.5,79.1),(94.9,99.9),(101.8,106.9),(108.7,113.5),(120.6,125.5),(127.1,131.7),(133.4,138.3)]:
    win(x0, x1, 5.7, 12.5); win(x0, x1, 14.3, 17.9, rail=False, n="transom")
for x0, x1 in [(58.0,62.2),(65.6,70.2),(74.6,79.3),(81.9,85.8)]: win(x0, x1, 23.3, 32.4); win(x0, x1, 32.4, 35.0, rail=False, n="transom")
for x0, x1 in [(94.1,102.3),(104.9,113.8),(118.7,127.2),(129.7,138.3)]: win(x0, x1, 23.3, 32.4, mull=1); win(x0, x1, 32.4, 35.0, mull=1, rail=False, n="transom")
for x0, x1 in [(57.7,61.5),(82.3,86.0)]: win(x0, x1, 41.0, 44.0, rail=False)
stepped(71.5, 15.5, 46.0, 67.5); P("gable", [(56.0,46.0),(87.0,46.0)])
for x0, x1 in [(64.5,69.0),(69.6,74.2),(75.0,79.6)]: win(x0, x1, 40.1, 48.1)
P("hood", [(63.5,50.5),(80.5,50.5)]); fan(71.5, 58.0, 3.0)
for c, w1, w2 in [(101.75,(97.8,101.2),(102.3,105.7)),(132.6,(128.9,132.0),(133.2,136.3))]:
    win(*w1, 40.2, 46.8); win(*w2, 40.2, 46.8); dormer(c, 5.0, EAVE_MAIN, 48.5, 55.7)

# ---------------- tower (same design as the street face; cf. sheet 00) ----------------
tc = 160.0; t0, t1 = 142.0, 178.0
P("tower shaft", [(t0,RIDGE),(t0,118.5),(t1,118.5),(t1,RIDGE)])   # tower stands in the street band - seen above the roof only
for x0, x1, xc in [(146.0,155.3,150.65),(155.6,164.7,160.15),(164.6,173.9,169.25)]:
    r = (x1-x0)/2; P("arch", arc(xc, 11.4, r)); P("arch", arc(xc, 11.4, r-1.4))
for x0, x1 in [(148.8,154.8),(165.1,171.7)]: door(x0, x1, 4.5, 11.4)
win(157.6, 162.7, 6.5, 11.0, mull=1, rail=False)
for x0, x1 in [(147.1,152.2),(154.0,159.0),(161.7,166.6),(168.6,173.7)]: win(x0, x1, 23.3, 32.4); win(x0, x1, 32.4, 35.0, rail=False, n="transom")
stepped(tc, 10.5, 47.0, 59.8)
for x0, x1 in [(153.2,157.5),(158.0,162.3),(162.8,167.0)]: win(x0, x1, 40.2, 46.8)
P("hood", [(152.5,49.0),(167.5,49.0)]); fan(tc, 52.5, 2.6)
for z in [87.5, 100.0]: P("tower cornice", [(t0-1,z),(t1+1,z)])
P("arch", arc(tc, 68.7, 15.6)); P("arch", arc(tc, 68.7, 12.4))
P("window", [(tc-6,60.0),(tc-6,71.0)] + arc(tc, 71.0, 6.0, 180, 0) + [(tc+6,60.0)])
box("balcony", tc-7.5, tc+7.5, 60.0, 66.0)
for x0, x1 in [(150.2,152.9),(154.4,156.9),(158.4,160.9),(162.4,164.9),(166.7,169.2)]:
    r = (x1-x0)/2; P("window", [(x0,89.7),(x0,95.0)] + arc((x0+x1)/2, 95.0, r, 180, 0) + [(x1,89.7),(x0,89.7)])
for x0, x1 in [(154.0,157.0),(158.5,161.5),(163.0,166.0)]: win(x0, x1, 105.3, 110.1)
P("arch", arc(tc, 117.7, 8.6)); P("clock ring", arc(tc, 117.7, 3.4, 0, 360, 48))
P("clock gable", [(tc-10,118.5),(tc-10,126),(tc-5,130),(tc+5,130),(tc+10,126),(tc+10,118.5)]); box("clock gable", tc-2, tc+2, 130, 137)
for x0 in [t0-1.5, t1-6.5]:
    P("corner turret", [(x0,100.0),(x0,119),(x0+4,144),(x0+8,119),(x0+8,100.0)]); P("vane", [(x0+4,144),(x0+4,150)])
    win(x0+2.9, x0+5.1, 105.3, 111.2); fan(x0+4, 112.2, 1.6)
P("tower roof (pyramid)", [(t0+6,130.0),(tc-6.4,160.7),(tc+6.4,160.7),(t1-6,130.0)])
box("cresting", tc-6.4, tc+6.4, 160.7, 170.0); P("vane", [(tc,170),(tc,180)])
CLOCK = (X(tc), 117.7, 5.4)

# ---------------- main block, east part ----------------
for (x0, x1), (z0, z1) in zip([(177.0,181.9),(183.0,187.9),(188.4,193.3)], [(14.8,25.1),(9.9,21.2),(6.8,18.8)]): win(x0, x1, z0, z1)   # stair windows
box("grille", 177.6, 193.0, 4.7, 8.6)
for x0, x1 in [(177.6,181.9),(183.3,187.3),(189.0,193.0)]: win(x0, x1, 27.3, 34.4, rail=False)
for x0, x1 in [(203.3,208.4),(208.9,213.8),(214.9,219.7),(227.0,233.8),(235.2,242.0),(245.7,252.5),(253.7,260.5)]:
    win(x0, x1, 5.0, 12.5); win(x0, x1, 13.7, 18.0, rail=False, n="transom")
for x0, x1 in [(202.4,211.2),(214.3,222.4)]: win(x0, x1, 23.3, 32.4, mull=1); win(x0, x1, 32.4, 35.0, mull=1, rail=False, n="transom")
for x0, x1 in [(227.0,233.8),(235.2,242.0),(245.7,252.5),(253.7,260.5)]: win(x0, x1, 23.3, 32.4); win(x0, x1, 32.4, 35.0, rail=False, n="transom")
for c, w1, w2 in [(187.6,(183.9,187.0),(188.2,191.3)),(213.7,(209.8,212.9),(214.0,217.5))]:
    win(*w1, 40.2, 46.8); win(*w2, 40.2, 46.8); dormer(c, 5.0, EAVE_MAIN, 48.5, 55.9)
stepped(243.5, 17.5, 46.0, 68.5); P("gable", [(225.2,46.0),(261.0,46.0)])
for x0, x1 in [(236.6,240.3),(241.7,245.4),(247.1,250.8)]: win(x0, x1, 40.2, 48.1)
P("hood", [(235.5,50.5),(252.0,50.5)]); fan(243.5, 59.0, 3.0)

# ---------------- east end block (baggage, floor near the platform) ----------------
for x0, x1 in [(268.8,274.7),(287.1,293.9),(305.8,312.4)]: door(x0, x1, 0.6, 10.3); win(x0, x1, 12.2, 17.8, mull=1, rail=False, n="transom")
for x0, x1 in [(278.8,283.4),(297.9,301.9)]: win(x0, x1, 5.3, 10.0); win(x0, x1, 12.2, 17.8, rail=False, n="transom")
for c, x0, x1 in [(272.2,270.2,274.2),(310.1,308.1,312.1)]: win(x0, x1, 24.5, 31.3); dormer(c, 3.2, EAVE_END, 32.5, 38.4)
stepped(291.6, 11.0, EAVE_END, 41.5)
for x0, x1 in [(286.8,289.9),(290.8,294.7)]: win(x0, x1, 23.5, 27.3)
fan(290.8, 28.5, 3.9)
spire_gable(299.9, 39.5, 52.3, 53.5); win(298.4, 301.3, 41.4, 46.3, mull=1, rail=False)

LEVELS = [("vane, tower", 180), ("cresting top", 170), ("pyramid top", 160.7), ("corner turret tips", 144), ("clock centre", 117.7),
          ("belfry sill", 89.7), ("great arch crown", 84.3), ("tall stack (east)", 92.7), ("end spires: tip / vane", 81), ("chimney tops", 74.5),
          ("main gable peaks", 68.5), ("tower porch gable", 59.8), ("main roof top", RIDGE), ("dormer peaks (main)", 55.7), ("end-block roof tops", ROOF_END),
          ("main eave", EAVE_MAIN), ("end-block eave", EAVE_END), ("first floor", 4.5), ("baggage door sills", 0.6), ("platform (approx.)", -1.0)]
OPEN = {"window","sash","transom","arch","door","door leaf","grille","steps","louvre","clock ring","hood","balcony","cresting"}

# mirror for the view (east on the left)
VIEW = [(n, [(L - x, z) for x, z in pts]) for n, pts in OUT]
doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in VIEW: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
msp.add_circle((L - CLOCK[0], CLOCK[1]), CLOCK[2], dxfattribs={"layer":"CLOCK"})
doc.saveas("Everett_1886_track_elevation.dxf")

fig, ax = plt.subplots(figsize=(17, 10.5))
for n, pts in VIEW:
    xs, zs = zip(*pts)
    ax.plot(xs, zs, color=("#334" if "roof" in n else "#777" if "platform" in n else "#222" if n in OPEN else "#7a2318"),
            lw=(0.6 if n in ("cornice","first floor") else 0.45 if n in ("sash","door leaf","steps","louvre","clock ring","hood") else 0.8 if n in OPEN else 1.3),
            ls="--" if n in ("first floor","platform (approx.)") else "-")
ax.add_patch(Circle((L - CLOCK[0], CLOCK[1]), CLOCK[2], fill=False, ec="#7a2318", lw=1.2))
last = 1e9
for t, z in sorted(LEVELS, key=lambda v: -v[1]):
    zt = min(z, last - 3.2); last = zt
    ax.plot([L+2, L+9, L+12], [z, z, zt], color="#999", lw=0.5); ax.text(L+13, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
for x, t in [(0,"0"),(55.0,"55'-0\""),(141.67,"141'-8\""),(177.33,"177'-4\""),(262.67,"262'-8\""),(L,"319'-0\"")]:
    ax.plot([L-x,L-x],[-4,-8],color="k",lw=0.6); ax.text(L-x,-10,t,ha="center",fontsize=6.5)
ax.text(2, -14, "WEST (baggage) end", fontsize=7); ax.text(L-2, -14, "EAST (emigrants') end", fontsize=7, ha="right")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - TRACK-SIDE (SOUTH) ELEVATION, from MPL sheet 01 (private reference) - Rev A", fontsize=10)
ax.text(0,-19,"Seen from the tracks, west end on the left; dimensions measured from the east face.  Sheet 01 chain totals 320'-0\" - scaled to the 319'-0\" plans.  Heights scaled (+-0.5 ft), first floor at 4.5 ft.  Carved ornament not drawn.  Rev A 11/22/2026", fontsize=6.5)
ax.set_aspect("equal"); ax.set_xlim(-8, L+80); ax.set_ylim(-22, 186); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_track_elevation.pdf"); plt.savefig("Everett_1886_track_elevation.png", dpi=200); print("ok")
