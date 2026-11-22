# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - Street (north) elevation, MPL sheet 00.
# Rev A: outline and heights.  Rev B: windows, arches, doors, tower openings, all scaled from sheet 00 against a feet grid (+-0.5 ft).
# x from the EAST outside face (ft); z from the Everett Street sidewalk (ft).
# Scale checked on the sheet: tower 35'-8" wide and centred at 159'-6", as on the plans.
# Heights scaled from sheet 00 (+-1 ft); no heights are written on the sheet.
import ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle, Circle

L = 319.0
FLOOR1, BELT, EAVE_END, EAVE_MAIN, RIDGE = 4.5, 25.0, 24.7, 45.0, 60.0
TOWER = (141.67, 177.33)
OUT = []   # (name, polyline points)
def P(name, pts): OUT.append((name, pts))
# end blocks (emigrants W, baggage E): eave 24.7, hipped roof to 46
for x0, x1 in [(0, 54.67), (262.67, L)]:
    P("end block wall", [(x0,0),(x1,0),(x1,EAVE_END),(x0,EAVE_END),(x0,0)])
    P("end block roof", [(x0-1,EAVE_END),(x0+12,46),(x1-12,46),(x1+1,EAVE_END)])
# main block: eave 45, ridge 60
P("main block wall", [(54.67,0),(262.67,0),(262.67,EAVE_MAIN),(54.67,EAVE_MAIN),(54.67,0)])
P("main roof", [(54.67,EAVE_MAIN),(62,RIDGE),(255,RIDGE),(262.67,EAVE_MAIN)])
P("belt course", [(0,BELT),(L,BELT)])
P("first floor", [(0,FLOOR1),(L,FLOOR1)])
# big stepped gables on the main block (W centred 76.0 w 38, E centred 246.3 w 34), peak 70.2
for c, w in [(76.0, 38.0), (246.3, 34.0)]:                        # Rev B: centres and widths re-read from sheet 00
    P("main gable", [(c-w/2,EAVE_MAIN),(c-3.5,64),(c-3.5,66),(c-2,66),(c-2,68.5),(c-0.8,68.5),(c-0.8,70.2),(c+0.8,70.2),(c+0.8,68.5),(c+2,68.5),(c+2,66),(c+3.5,66),(c+3.5,64),(c+w/2,EAVE_MAIN)])
# end-block gables and spires (W spire at 20.3, E at 298.5): half-timbered gable to 52, lantern 55-61, spire tip 75, vane 88
for c, s in [(20.3, 1), (298.5, -1)]:
    P("spire gable", [(c-9,36),(c,52),(c+9,36)])
    P("spire", [(c-2,55),(c-2,61),(c,74.7),(c+2,61),(c+2,55)])
    P("vane", [(c,74.7),(c,88)])
    g = c + s * 9.3                                                 # stepped entrance gable, peak 42.8
    P("entrance gable", [(g-11,EAVE_END),(g-3,40),(g-3,41.5),(g-1,41.5),(g-1,42.8),(g+1,42.8),(g+1,41.5),(g+3,41.5),(g+3,40),(g+11,EAVE_END)])
# dormers: main block peaks 58 (base 42), end blocks peaks 38.4 (base 24.7)
for c in [106.0, 131.9, 187.0, 217.4]: P("dormer", [(c-4.5,42),(c-4.5,52),(c,58),(c+4.5,52),(c+4.5,42)])
for c in [9.8, 48.2, 272.3, 308.2]:   P("dormer", [(c-4,24.7),(c-4,33),(c,38.4),(c+4,33),(c+4,24.7)])
# chimneys
for c in [57.0, 118.9, 201.9, 228.6, 263.8]: P("chimney", [(c-1.6,RIDGE-6),(c-1.6,74.9),(c+1.6,74.9),(c+1.6,RIDGE-6)])
for c in [0.9, 318.0]: P("chimney", [(c-1.3,EAVE_END),(c-1.3,47.2),(c+1.3,47.2),(c+1.3,EAVE_END)])
# tower
t0, t1 = TOWER; tc = (t0+t1)/2
P("tower shaft", [(t0,0),(t0,118.5),(t1,118.5),(t1,0)])
for x in [t0, t1-7]: P("corner turret", [(x,100.5),(x,119),(x+3.5,144.5),(x+7,119),(x+7,100.5)])
P("tower roof (pyramid)", [(t0+6,118.5),(tc-4.5,162.5),(tc+4.5,162.5),(t1-6,118.5)])
P("clock gable", [(tc-10,118.5),(tc-10,124),(tc,137),(tc+10,124),(tc+10,118.5)])
P("finial / cresting", [(tc-3,162.5),(tc-3,176),(tc+3,176),(tc+3,162.5)])
P("vane", [(tc,176),(tc,185)])
for z in [86.8, 100.5]: P("tower cornice", [(t0-1,z),(t1+1,z)])
P("balcony", [(tc-7.5,61.2),(tc-7.5,67.5),(tc+7.5,67.5),(tc+7.5,61.2),(tc-7.5,61.2)])
CLOCK = (tc, 117.5, 5.5)

# ---------------- Rev B: openings (x0, x1, z0, z1) read from sheet 00 ----------------
import math
def arc(xc, zc, r, a0=0, a1=180, n=24):
    return [(xc + r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc + r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]
def box(name, x0, x1, z0, z1): P(name, [(x0,z0),(x1,z0),(x1,z1),(x0,z1),(x0,z0)])
def win(x0, x1, z0, z1, mull=0, rail=True, name="window"):
    box(name, x0, x1, z0, z1)
    if rail: P("sash", [(x0,(z0+z1)/2),(x1,(z0+z1)/2)])
    for i in range(1, mull+1): x = x0+(x1-x0)*i/(mull+1); P("sash", [(x,z0),(x,z1)])
def pair(x0, x1, z0, z1): win(x0, x1, z0, z1, mull=1)
def seg_window(x0, x1, z0, zs, zc, lights):          # segmental-arched first-floor window, spring zs, crown zc
    w = (x1-x0)/2; h = zc-zs; r = (w*w+h*h)/(2*h); xc = (x0+x1)/2; a = math.degrees(math.asin(w/r))
    P("window", [(x0,zs),(x0,z0),(x1,z0),(x1,zs)] + arc(xc, zc-r, r, 90-a, 90+a)[::1])
    P("arch", arc(xc, zc-r, r+1.6, 90-a-4, 90+a+4))
    for lx0, lx1 in lights[1:]: P("sash", [(lx0-0.5,z0),(lx0-0.5,zs+0.8)])
    P("sash", [(x0,zs-1.6),(x1,zs-1.6)])
def fan(xc, zs, r):                                   # semicircular lunette with outer ring
    P("arch", arc(xc, zs, r)); P("arch", arc(xc, zs, r+1.4)); P("arch", [(xc-r,zs),(xc+r,zs)])
def door(x0, x1, z0, z1, transom):
    P("door", [(x0,z0),(x0,z1),(x1,z1),(x1,z0)]); P("door leaf", [((x0+x1)/2,z0),((x0+x1)/2,transom)]); P("door leaf", [(x0,transom),(x1,transom)])

# West end block (emigrants)
for x0, x1 in [(5,9),(10.4,14.4),(43.7,47.4),(49,53)]: win(x0, x1, 12.6, 18.2)
for x0, x1 in [(5.2,14.6),(43.7,53.3)]: box("grille", x0, x1, 4.9, 9.0)
door(25.3, 33.6, 1.0, 19.7, 13.5)
for x0, x1 in [(25.7,29),(29.8,33.2)]: win(x0, x1, 24.4, 28.9)
fan(29.45, 29.6, 3.6)
for x0, x1 in [(20.5,22.7),(36.5,38.8),(281.7,283.9),(296.6,298.7)]: box("panel", x0, x1, 25.5, 27.5)
for x0, x1 in [(8,11.7),(46.4,50),(270.3,274.4),(306.4,310)]: win(x0, x1, 24.6, 32.4)
for x0, x1 in [(18.7,21.7),(297.4,300.3)]: win(x0, x1, 41, 46, mull=1)

# Main block, west gable bay (4 bays) and east gable bay (door in the first bay)
WB = [(59.7,66.5),(68,74.5),(78,84.5),(86,92.5)]
EB = [(232,237.6),(239.2,244.7),(247.8,253.7),(255.3,260.8)]
for i, (x0, x1) in enumerate(WB + EB):
    if (x0, x1) == EB[0]: door(x0, x1, 5.2, 14.4, 14.4)
    else: win(x0, x1, 6.3, 14.0)
    win(x0, x1, 14.9, 19.1, rail=False, name="transom")
    win(x0, x1, 24.8, 34.6); win(x0, x1, 32.3, 34.6, rail=False, name="transom")
    fan((x0+x1)/2, 36.2, (x1-x0)/2 - 0.6)
for x0, x1 in [(69.2,72.7),(74.4,78),(79.5,83.1)]: win(x0, x1, 44.5, 52.5)
for x0, x1 in [(239.4,242.9),(244.7,248.4),(249.9,253.6)]: win(x0, x1, 45.1, 53.5)
P("hood", [(68.5,53.3),(83.8,53.3)]); P("hood", [(238.7,54.3),(254.3,54.3)])

# Main block between the gables and the tower: arched first-floor windows, paired 2nd-floor windows, dormers
seg_window(100.5, 116.3, 6.4, 15.2, 19.4, [(100.5,105),(106,111),(111.8,116.3)])
seg_window(122.2, 138.8, 6.4, 15.2, 19.4, [(122.2,126.9),(128.1,132.9),(134,138.8)])
seg_window(180.5, 199.5, 6.4, 15.2, 19.4, [(180.7,186.3),(187.4,192.8),(193.7,199.3)])
seg_window(205.3, 223.7, 6.4, 15.2, 19.4, [(205.3,210.7),(212.1,217.2),(218.7,223.7)])
for x0, x1 in [(99.3,107.6),(108.9,117.2),(121.3,129.6),(131.1,139.4),(179.8,188.4),(190.8,199.9),(204.4,213.6),(215.4,224.6)]:
    pair(x0, x1, 25.0, 34.5)
for x0, x1 in [(102.6,105.6),(107,110),(128.4,131.4),(132.7,135.8),(183.1,186.3),(187.5,190.8),(213.7,217),(218,221.1)]:
    win(x0, x1, 41.3, 48)

# Tower: triple entrance arcade over steps, 2nd/3rd floor pairs, "18 86" tympana, great arch, belfry, clock stage
for z in [0.9, 1.8, 2.7, 3.7]: P("steps", [(145.5,z),(173.5,z)])
for x0, x1 in [(149.4,154.7),(164.3,169.6)]: door(x0, x1, 3.7, 13.0, 9.5)
box("window", 156.4, 162.6, 5.5, 12.0)
for xc, r in [(150.8,5.5),(168.2,5.5),(159.5,4.2)]:                   # outer rings; spring 15, crowns 20.5 / 19.2
    P("arch", arc(xc, 15.0, r)); P("arch", arc(xc, 15.0, r-1.5))
for z0, z1 in [(25.0,34.6),(41.6,48.7)]:
    for x0, x1 in [(150,158.6),(160.4,169)]: pair(x0, x1, z0, z1)
for x0, x1 in [(150,158.6),(160.4,169)]: box("louvre", x0, x1, 37, 41)
for xc in [154.3, 164.7]: P("arch", arc(xc, 50.5, 4.6) + [(xc-4.6,50.5)]); P("arch", arc(xc, 50.5, 5.6))
P("arch", arc(tc, 69.5, 15.0)); P("arch", arc(tc, 69.5, 12.0))
P("window", [(tc-6,61.2),(tc-6,71.5)] + arc(tc, 71.5, 6.0, 180, 0) + [(tc+6,61.2)])
for x0, x1 in [(149.8,152.5),(154,156.5),(158,160.5),(162,164.5),(166.3,168.8)]:
    r = (x1-x0)/2; P("window", [(x0,88),(x0,94.2)] + arc((x0+x1)/2, 94.2, r, 180, 0) + [(x1,88),(x0,88)])
for x0, x1 in [(153.5,156.5),(157.6,160.3),(161.7,164.4)]: win(x0, x1, 105.1, 110.2)
for x0, x1 in [(143.4,145.6),(172.4,174.6)]: win(x0, x1, 105.1, 111.2); fan((x0+x1)/2, 112.2, 1.6)
P("arch", arc(tc, 117.5, 8.8)); P("clock ring", arc(tc, 117.5, 3.4, 0, 360, 48))

# East end block (baggage): paired windows with square transoms, entrance and gable windows
for x0, x1 in [(267.4,271.3),(273,276.8),(303.4,307.6),(308.7,312.8)]:
    win(x0, x1, 7.6, 14.4); win(x0, x1, 15.3, 18.8, rail=False, name="transom")
door(286.6, 293.7, 4.7, 20.1, 14.0)
for z in [1.2, 2.4, 3.6]: P("steps", [(284.5,z),(295.8,z)])
for x0, x1 in [(286.6,289.8),(290.9,294)]: win(x0, x1, 25.0, 29.6)
fan(290.3, 30.0, 3.6)

LEVELS = [("vane, tower", 185), ("cresting / finial deck", 176), ("pyramid top", 162.5), ("corner turret tips", 144.5),
          ("clock gable peak (the '140 ft tower')", 137), ("clock centre (dia ~11 ft)", 117.5), ("top of tower shaft / turret eaves", 118.5),
          ("belfry arcade sill", 88), ("great arch crown", 84.5), ("great arch springing", 69.5), ("balcony floor", 61.2), ("'18 86' tympana", 50.7), ("chimney tops", 74.9),
          ("main gable peaks", 70.2), ("main ridge", 60), ("main eave", 45), ("end-block spires: tip / vane", 74.7),
          ("belt course", 25), ("end-block eave", 24.7), ("tower entrance arch crowns", 20.6), ("first-floor window heads", 19.2), ("first floor (EST)", 4.5), ("sidewalk", 0)]

OPEN = {"window","sash","transom","arch","door","door leaf","grille","panel","steps","louvre","clock ring","hood"}
doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in OUT: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
msp.add_circle(CLOCK[:2], CLOCK[2], dxfattribs={"layer":"CLOCK"})
doc.saveas("Everett_1886_street_elevation.dxf")

fig, ax = plt.subplots(figsize=(17, 10.5))
for n, pts in OUT:
    xs, zs = zip(*pts)
    ax.plot(xs, zs, color=("#334" if "roof" in n else "#7a2318" if n not in OPEN else "#222"), lw=(0.6 if n in ("belt course","first floor") else 0.45 if n in ("sash","door leaf","steps","louvre","clock ring","hood") else 0.8 if n in OPEN else 1.3), ls="-" if n != "first floor" else "--")
ax.add_patch(Circle(CLOCK[:2], CLOCK[2], fill=False, ec="#7a2318", lw=1.2))
ax.plot([-5, L+5], [0, 0], color="k", lw=1.5); 
last = 1e9
for t, z in sorted(LEVELS, key=lambda v: -v[1]):
    zt = min(z, last - 3.2); last = zt
    ax.plot([L+2, L+9, L+12], [z, z, zt], color="#999", lw=0.5); ax.text(L+13, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
for x, t in [(0,"0"),(54.67,"54'-8\""),(TOWER[0],"141'-8\""),(TOWER[1],"177'-4\""),(262.67,"262'-8\""),(L,"319'-0\"")]:
    ax.plot([x,x],[-2,-6],color="k",lw=0.6); ax.text(x,-8,t,ha="center",fontsize=6.5)
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - STREET (NORTH) ELEVATION, from MPL sheet 00 (private reference) - Rev B", fontsize=10)
ax.text(0,-13,"Heights scaled from sheet 00 (+-1 ft) - none are written on the sheet.  Horizontal positions from the plans and sheet 00.  Rev A 11/22/2026 outline and heights.  Rev B 11/22/2026 windows, arches, doors and tower openings scaled from sheet 00 (+-0.5 ft); carved ornament not drawn.", fontsize=6.5)
ax.set_aspect("equal"); ax.set_xlim(-8, L+80); ax.set_ylim(-16, 192); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_street_elevation.pdf"); plt.savefig("Everett_1886_street_elevation.png", dpi=200); print("ok")
