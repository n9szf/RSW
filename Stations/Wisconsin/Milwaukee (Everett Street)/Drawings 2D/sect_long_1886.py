# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - LONGITUDINAL SECTION looking south (toward the tracks), MPL sheet 04 ("Longitudinal Section"). Rev A.
# x from the EAST outside face (ft); z: first floor set to the street-elevation datum (sidewalk 0, floor ~4.5).
# Scale fixed on the sheet from the end walls (0 / 319) and checked on the walls at 54.67, 71.83, 89.0, 141.67-177.33, 199.67, 262.67 (+-1 ft).
# Heights scaled from sheet 04 (+-1 ft; the tower runs ~2-3 ft higher than on sheet 00 - see notes).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
L = 319.0
OUT = []; FILL = []
def P(n, pts): OUT.append((n, pts))
def box(n, x0, x1, z0, z1): P(n, [(x0,z0),(x1,z0),(x1,z1),(x0,z1),(x0,z0)])
def cut(x0, x1, z0, z1): FILL.append([(x0,z0),(x1,z0),(x1,z1),(x0,z1)]); box("wall cut", x0, x1, z0, z1)
def arc(xc, zc, r, a0=0, a1=180, n=24): return [(xc+r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc+r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]
def win(x0, x1, z0, z1, mull=0, rail=True, n="window"):
    box(n, x0, x1, z0, z1)
    if rail: P("sash", [(x0,(z0+z1)/2),(x1,(z0+z1)/2)])
    for i in range(1, mull+1): x = x0+(x1-x0)*i/(mull+1); P("sash", [(x,z0),(x,z1)])
def door(x0, x1, z0, z1, leaves=1, transom=None):
    box("door", x0, x1, z0, z1)
    if transom: P("door leaf", [(x0,transom),(x1,transom)])
    for i in range(1, leaves): x = x0+(x1-x0)*i/leaves; P("door leaf", [(x,z0),(x,transom or z1)])
def screen(x0, x1, z0=4.0, z1=20.0, bays=4, wains=8.4):           # glazed wood partition with panelled wainscot
    box("screen", x0, x1, z0, z1); P("screen", [(x0,wains),(x1,wains)]); P("screen", [(x0,15.5),(x1,15.5)])
    for i in range(1, bays): x = x0+(x1-x0)*i/bays; P("screen", [(x,z0),(x,z1)])
def column(x, z0, z1): box("column", x-0.35, x+0.35, z0, z1)

# --- floors (top of floor), ceilings, roof profile -------------------------------------------
W1, M1, E1 = 4.8, 4.0, 2.4          # first floor: emigrants' block, main block, baggage block (as drawn)
F2, F3 = 23.5, 39.5                  # second floor, third floor (main block)
for x0, x1, z in [(0,53,W1),(54.67,262.1,M1),(263.6,317.6,E1)]: P("floor", [(x0,z),(x1,z)]); P("floor", [(x0,z-1.0),(x1,z-1.0)])
for x0, x1 in [(1.5,53),(54.67,142),(175.9,262.1),(263.6,317.6)]: P("floor", [(x0,F2),(x1,F2)]); P("floor", [(x0,F2-1.6),(x1,F2-1.6)])
for x0, x1 in [(54.67,97),(115.2,142),(175.9,262.1)]: P("floor", [(x0,F3),(x1,F3)]); P("floor", [(x0,F3-1.2),(x1,F3-1.2)])
for x0, x1 in [(1.5,53),(263.6,317.6)]: P("ceiling", [(x0,38.3),(x1,38.3)])
# roof: west end block (gable peak 52.8 at x 17), main block flat top 61, east end block (peak 54.3 at x 299.3)
P("roof", [(-0.5,27.6),(17.0,52.8),(20.5,47.5),(52.5,46.5),(52.5,61.2),(269.6,61.2),(269.6,47.4),(295.0,47.4),(299.3,54.3),(319.6,27.6)])
P("roof", [(54.67,60.0),(262.1,60.0)])
for c, z in [(70.5,61.2),(244.5,61.2)]: P("roof vent gable", [(c-3.5,z),(c,z+4.8),(c+3.5,z)])
for c, zb in [(17.0,52.8),(299.3,54.3)]: P("spire", [(c-2.4,zb-1.5),(c-2,59),(c-2.6,61),(c-1.5,66),(c,75),(c+1.5,66),(c+2.6,61),(c+2,59),(c+2.4,zb-1.5)])
P("chimney", [(-2.9,4.5),(-2.9,48.6),(0.7,48.6),(0.7,27)])
# --- walls cut by the section, columns, basement piers ----------------------------------------
cut(0, 1.5, -9, 27.6); cut(317.6, 319.0, -9, 27.6)
cut(52.5, 54.67, -9, 61.2); cut(262.1, 263.6, -9, 61.2)
for x0, x1, z0, z1 in [(70.6,71.83,F2-1.6,38.3),(89.0,90.2,F2-1.6,38.3),(115.2,116.0,F3,60),(199.2,200.0,F3,60),(223.4,224.3,F3,60),(242.6,243.5,F3,60)]:
    cut(x0, x1, z0, z1)
for x0, x1 in [(141.67,143.4),(174.1,177.33)]: cut(x0, x1, -10, 51)                # tower walls (broken off at 51)
for x in [17.6, 35.2]: column(x, W1, F2-1.6); column(x, F2, 38.3)
column(5.9, F2, 38.3)
for x in [281.0, 299.4]: column(x, E1, 20.5); column(x, F2, 38.3)
column(311.5, F2, 38.3)
for x in [70.9, 89.6, 115.5, 199.6, 224.0, 243.3]: column(x, M1, F2-1.6)
for x in [70.9, 89.6, 115.5, 142.5, 175.5, 199.6, 224.0, 243.3, 262.8, 281.0, 299.4]:  # basement piers and footings
    box("pier", x-0.9, x+0.9, -8.6, M1-1.0 if x < 262 else E1-1.0); box("footing", x-2.2, x+2.2, -10.3, -8.6)
for x in [8.5, 27.5, 45.0]: P("pier", [(x,-2.5),(x,W1-1)])
P("basement floor", [(1.5,-9.0),(317.6,-9.0)])
P("grade (assumed)", [(-6,0),(L+3,0)])

# --- west end block (emigrants' room): far (track) wall seen from inside ----------------------
for x0, x1 in [(3.7,7.6),(9.2,13.3),(14.5,17.3),(35.8,39.4),(40.0,43.6),(45.4,49.6)]:
    win(x0, x1, 7.8, 14.4); win(x0, x1, 15.8, 19.5, rail=False, n="transom")
for x0, x1 in [(22.6,26.2),(27.3,30.9)]: win(x0, x1, 15.8, 19.5, rail=False, n="transom")
door(22.3, 31.0, W1, 15.5, leaves=2)
win(6.7, 10.6, 24.9, 33.3); win(42.4, 47.2, 24.9, 33.3)
box("window", 22.9, 29.8, 24.9, 30.0); P("sash", [(26.35,24.9),(26.35,30.0)]); P("arch", arc(26.35, 30.0, 3.45, 0, 180))
P("arch", [(22.9,30.0),(22.9,34.2),(29.8,34.2),(29.8,30.0)])

# --- main block, west part: 2nd-floor corridor doors, glazed screens, stair to the 3rd floor -----
for x0, x1 in [(57.3,60.8),(62.3,65.7),(71.3,74.7),(82.7,86.0),(89.1,92.6),(111.3,114.7),(124.8,128.2),(138.9,142.2)]:
    door(x0, x1, F2, 33.6, transom=30.9)
screen(71.4, 88.4, bays=6); door(81.5, 86.9, M1, 11.3, leaves=2)
screen(90.2, 115.0, bays=8); door(90.0, 93.2, M1, 10.8)
screen(118.0, 141.0, bays=4)
P("stair", [(94.7,F2),(114.0,F3)]); P("stair", [(96.5,F2),(115.2,F3-0.6)])
P("stair rail", [(95.2,F2+3),(114.5,F3+3)])
P("stair rail", [(97.0,F3+2.8),(115.2,F3+2.8)]); P("stair rail", [(97.0,F3),(97.0,F3+3.4)])

# --- grand hall in the tower: street arcade, balcony, upper windows, tower stages ---------------
tc = 159.5
for x0, x1 in [(147.0,153.6),(155.3,163.0),(164.4,171.0)]:
    xc, r = (x0+x1)/2, (x1-x0)/2
    P("arch", [(x0,M1),(x0,13.8)] + arc(xc, 13.8, r, 180, 0) + [(x1,13.8),(x1,M1)])
    P("arch", arc(xc, 13.8, r+1.3))
win(155.7, 162.9, 6.5, 12.0, mull=1, rail=False)
for x0, x1 in [(145.5,151.5),(152.7,158.4),(159.6,165.0),(166.9,172.6)]: win(x0, x1, F2+0.5, 35.7); P("sash", [(x0,33.8),(x1,33.8)])
box("balcony rail", 147.0, 171.0, F2, 27.8)
for x0, x1 in [(151.2,155.1),(156.9,161.1),(162.1,166.0)]: win(x0, x1, 42.6, 50.1)
P("break line", [(141,51.5)] + [(141+i*0.9, 51.5+0.6*math.sin(i)) for i in range(41)])
P("break line", [(141,54.5)] + [(141+i*0.9, 54.5+0.6*math.sin(i)) for i in range(41)])
for x0, x1 in [(143.7,145.2),(174.4,175.9)]: cut(x0, x1, 55, 120.4)
for z in [65.4, 89.8, 104.8, 120.4]: P("tower floor", [(145.2,z),(174.4,z)]); P("tower floor", [(145.2,z-1),(174.4,z-1)])
for x0, x1 in [(149.6,152.2),(153.8,156.4),(157.9,160.5),(162.1,164.7),(166.2,168.8)]:
    r = (x1-x0)/2; P("window", [(x0,92.4),(x0,96.5)] + arc((x0+x1)/2, 96.5, r, 180, 0) + [(x1,92.4),(x0,92.4)])
for x0, x1 in [(155.1,156.7),(158.0,159.8),(161.6,163.2)]: win(x0, x1, 108.0, 114.2)
P("spiral stair", [(158.5+3.6*math.cos(t/6), 65.4 + t*(89.8-65.4)/(6*2*math.pi*3)) for t in range(0, int(6*2*math.pi*3)+1)])
box("spiral stair", 158.2, 158.8, 65.4, 89.8)
for x0, x1 in [(140.0,144.2),(173.3,177.4)]: P("turret", [(x0,104.8),(x0,121),((x0+x1)/2,137.5),(x1,121),(x1,104.8)]); box("turret cap", (x0+x1)/2-0.7, (x0+x1)/2+0.7, 137.5, 140)
P("tower roof", [(139.5,120.4),(155.1,168.7),(162.4,168.7),(178.0,120.4)])
for x in [154.6, 162.9]: P("roof framing", [(x,106),(x,168.7)])
for z, w in [(150.0,4.0),(136.0,8.5),(127.0,11.5)]: P("roof framing", [(tc-0.5-w,z),(tc-0.5+w,z)])
P("roof framing", [(154.6,136),(162.9,150)]); P("roof framing", [(162.9,136),(154.6,150)])
P("roof framing", [(154.6,120.4),(162.9,136)]); P("roof framing", [(162.9,120.4),(154.6,136)])

# --- main block, east part --------------------------------------------------------------------
box("balcony rail", 181.5, 188.4, F2, 27.5)
for x0, x1 in [(189.4,192.9),(207.4,211.0),(211.1,214.7),(235.1,238.5)]: door(x0, x1, F2, 33.6, transom=30.9)
for x0, x1 in [(244.7,251.3),(252.7,259.4)]: win(x0, x1, 25.2, 35.1); P("sash", [(x0,33.0),(x1,33.0)])
screen(176.0, 199.2, bays=6); door(191.8, 193.9, M1, 11.5)
screen(200.0, 223.4, bays=6); screen(224.6, 243.0, bays=5); screen(244.0, 262.0, bays=2)

# --- east end block (baggage room, floor near grade): doors with windows over, attic windows -------
for x0, x1 in [(270.0,274.5),(287.7,293.7),(306.3,312.6)]:
    door(x0, x1, E1, 12.3, leaves=2); win(x0, x1, 13.5, 19.8, mull=1, rail=False)
for x0, x1 in [(278.7,282.9),(297.9,302.1)]: win(x0, x1, 13.5, 19.8, mull=1, rail=False)
win(268.7, 274.1, 25.2, 33.5); win(308.4, 313.2, 25.2, 33.6)
box("window", 287.1, 294.6, 25.2, 30.8); P("sash", [(290.85,25.2),(290.85,30.8)]); P("arch", arc(290.85, 30.8, 3.75, 0, 180))
P("arch", [(287.1,30.8),(287.1,35.3),(294.6,35.3),(294.6,30.8)])

LEVELS = [("tower roof peak", 168.7), ("turret caps", 140), ("tower roof base", 120.4), ("clock-stage floor", 104.8), ("belfry floor", 89.8),
          ("tower floor (iron stair starts)", 65.4), ("main roof top", 61.2), ("west (baggage) end gable peak", 54.3), ("east (emigrants') end gable peak", 52.8),
          ("end-block roof tops", 47.4), ("3rd floor (main block)", F3), ("end-block 2nd-floor ceiling", 38.3), ("2nd floor", F2),
          ("1st floor: emigrants' block", W1), ("1st floor: main block", M1), ("1st floor: baggage room", E1), ("grade (assumed)", 0), ("basement floor / footings", -9.0)]
OPEN = {"window","sash","transom","arch","door","door leaf","screen","stair","stair rail","balcony rail","spiral stair","column","roof framing","turret cap"}

doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in OUT: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
doc.saveas("Everett_1886_longitudinal_section.dxf")

fig, ax = plt.subplots(figsize=(17, 10.5))
for pts in FILL: ax.add_patch(Polygon(pts, closed=True, fc="#c9a89f", ec="none"))
for n, pts in OUT:
    xs, zs = zip(*pts)
    ax.plot(xs, zs, color=("#334" if "roof" in n else "#777" if n in ("grade (assumed)","break line") else "#222" if n in OPEN else "#7a2318"),
            lw=(0.4 if n in ("sash","door leaf","screen","roof framing","spiral stair","stair rail") else 0.75 if n in OPEN else 1.2),
            ls="--" if n == "grade (assumed)" else "-")
last = 1e9
for t, z in sorted(LEVELS, key=lambda v: -v[1]):
    zt = min(z, last - 3.2); last = zt
    ax.plot([L+2, L+9, L+12], [z, z, zt], color="#999", lw=0.5); ax.text(L+13, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
for x, t in [(0,"0"),(54.67,"54'-8\""),(71.83,"71'-10\""),(89.0,"89'-0\""),(141.67,"141'-8\""),(177.33,"177'-4\""),(199.67,"199'-8\""),(224.0,"224'-0\""),(243.33,"243'-4\""),(262.67,"262'-8\""),(281.0,"281'"),(299.33,"299'-4\""),(L,"319'-0\"")]:
    ax.plot([x,x],[-12,-15],color="k",lw=0.6); ax.text(x,-17.5,t,ha="center",fontsize=6)
for x, z, t in [(26,10,"EMIGRANTS'\nROOM"),(80,12,"waiting\nrooms"),(159.5,21.0,"GRAND HALL"),(168.5,77,"iron\nstair"),(230,12,"waiting rooms"),(290,8.5,"BAGGAGE\nROOM"),(26,36,"2nd floor"),(150,-5,"basement"),(232,50,"3rd floor (attic)"),(80,50,"3rd floor (attic)")]:
    ax.text(x, z, t, ha="center", va="center", fontsize=6.5, color="#555", style="italic")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - LONGITUDINAL SECTION looking south (toward the tracks), from MPL sheet 04 (private reference) - Rev A", fontsize=10)
ax.text(0,-23,"Scaled from sheet 04 (+-1 ft); no dimensions are written on it.  Wall cuts shaded.  Floors drawn where the sheet puts them: baggage room near grade, main block ~4 ft, emigrants' block ~4.8 ft.  Grade line assumed.  Rev A 11/22/2026", fontsize=6.5)
ax.set_aspect("equal"); ax.set_xlim(-8, L+80); ax.set_ylim(-26, 178); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_longitudinal_section.pdf"); plt.savefig("Everett_1886_longitudinal_section.png", dpi=200); print("ok")
