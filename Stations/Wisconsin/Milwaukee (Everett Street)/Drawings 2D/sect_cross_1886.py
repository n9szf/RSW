# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - CROSS SECTION through the grand hall and tower at x = 159'-6", looking EAST.  Rev A.
# Built from the plans (sheets 07, 08, 09), the longitudinal section (sheet 04), the elevations (00, 01) and the tower survey (05).
# y = distance from the street face (0) to the track face (60); z from the street sidewalk.  Street on the LEFT.
# No transverse section survives among the scans: roof slopes, basement and the hall ceiling are ESTIMATES (dashed / marked EST).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
OUT = []; FILL = []
def P(n, pts): OUT.append((n, pts))
def box(n, a, b, z0, z1): P(n, [(a,z0),(b,z0),(b,z1),(a,z1),(a,z0)])
def cut(a, b, z0, z1): FILL.append([(a,z0),(b,z0),(b,z1),(a,z1)]); box("wall cut", a, b, z0, z1)
def arc(c, zc, r, a0=0, a1=180, n=24): return [(c+r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc+r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]
M1, F2, F3 = 4.0, 23.5, 39.5
T0, T1 = -1.5, 25.0                                   # tower: street face projects 1'-6"; back (hall) wall at 25 ft
# --- walls cut ---
cut(T0, 1.4, -9.0, 4.0); cut(T0, 1.4, 22.0, 120.4)                     # tower street wall (arcade opening 4-22 at the cut)
cut(23.6, T1, 61.2, 120.4)                                               # tower back wall above the main roof
for z0, z1 in [(-9.0, 4.0)]: cut(23.6, T1, z0, z1)
cut(58.5, 60.0, -9.0, 39.5)                                              # track wall
# --- floors ---
P("floor", [(1.4,M1),(58.5,M1)]); P("floor", [(1.4,M1-1),(58.5,M1-1)])
P("floor", [(1.4,F2),(T1,F2)]); P("floor", [(1.4,F2-1.6),(T1,F2-1.6)])                 # conductors' & trainmen's room floor (street half)
P("floor", [(39.0,F2),(58.5,F2)]); P("floor", [(39.0,F2-1.6),(58.5,F2-1.6)])           # 2nd floor behind the balcony
P("floor", [(1.4,F3),(58.5,F3)]); P("floor", [(1.4,F3-1.2),(58.5,F3-1.2)])             # 3rd floor (hall room / attic)
box("balcony rail", T1, 39.0, F2, F2+3.6)
P("balcony edge", [(T1,F2),(T1,F2-1.6)]); P("balcony edge", [(39.0,F2),(39.0,F2-1.6)])
P("opening over hall (about 22 x 14 ft, sheet 08)", [(T1,F2+0.2),(39.0,F2+0.2)])
for y in [T1, 39.0]: box("column", y-0.35, y+0.35, M1, F2-1.6)
for z in [65.4, 89.8, 104.8]: P("tower floor", [(1.4,z),(23.6,z)]); P("tower floor", [(1.4,z-1),(23.6,z-1)])
P("basement floor", [(T0,-9.0),(60,-9.0)])
for y in [12.0, 25.0, 39.0, 50.0]: box("pier", y-0.9, y+0.9, -8.6, M1-1); box("footing", y-2.2, y+2.2, -10.3, -8.6)
# --- roof (EST profile: street eave 45, flat top 61.2, track eave 39.5) ---
P("roof", [(-1.0,45.0),(9.0,61.2),(51.0,61.2),(61.0,39.5)])
P("roof", [(1.4,45.0),(10.0,60.0),(50.5,60.0),(58.5,41.5)])
for y in [17.0, 33.0, 45.0]: P("roof truss (EST)", [(y,F3),(y,60.0)])
P("roof truss (EST)", [(17.0,F3+6),(45.0,F3+6)])
# --- street face: triple entrance arcade, steps, vestibule doors ---
for z in [0.9, 1.8, 2.7, 3.7]: P("steps (beyond)", [(-6.0+0.9*(4-z/0.93),z),(T0,z)])
P("arch (cut)", [(T0,4.0),(T0,15.0)] + [(T0 + 2.9*(1-math.cos(math.radians(a))), 15.0+5.5*math.sin(math.radians(a))) for a in range(0,91,10)])
box("vestibule doors (beyond)", 6.0, 6.4, M1, 13.0)
box("street windows 2nd floor (beyond)", T0+0.2, 1.2, 25.0, 34.6); box("street windows 3rd floor (beyond)", T0+0.2, 1.2, 41.6, 48.7)
# --- tower above: great arch at the street face, belfry arcade, clock stage, roof ---
box("great arch opening (beyond)", T0+0.2, 1.2, 61.2, 84.5); box("balcony (beyond)", -2.5, T0, 61.2, 67.5)
for i in range(4): box("belfry window (beyond)", 4.0+i*4.6, 6.6+i*4.6, 92.4, 98.2)
box("clock (beyond)", 7.0, 18.0, 112.0, 123.0)
box("clock machinery house", 6.0, 18.3, 104.8, 114.3)
P("tower roof", [(T0-2.0,120.4),(9.0,168.7),(14.5,168.7),(T1+2.0,120.4)])
for x0, x1 in [(T0-1.0,T0+3.0),(T1-3.0,T1+1.0)]: P("turret", [(x0,104.8),(x0,121),((x0+x1)/2,137.5),(x1,121),(x1,104.8)])
P("ladder", [(12.0,65.4),(19.5,87.4)]); P("ladder", [(12.0,89.8),(17.5,104.8)])
# --- hall: track wall openings, ceiling ---
box("track doors", 58.6, 59.9, M1, 13.5); box("transom", 58.6, 59.9, 14.3, 17.9)
box("track windows 2nd floor", 58.6, 59.9, 25.0, 34.4)
P("hall ceiling (EST)", [(T1,37.2),(39.0,37.2)])
box("ticket office (beyond, EST height)", 34.0, 47.0, M1, 14.0)
LEVELS = [("tower roof peak (sheet 04)", 168.7), ("tower roof base", 120.4), ("clock floor", 104.8), ("belfry floor", 89.8),
          ("tower floor", 65.4), ("main roof top", 61.2), ("street eave", 45.0), ("3rd floor", F3), ("track eave", 39.5),
          ("2nd floor / balcony", F2), ("1st floor (main block)", M1), ("sidewalk", 0.0), ("basement floor", -9.0)]
OPEN = {"balcony rail","column","steps (beyond)","vestibule doors (beyond)","track doors","transom","ladder","clock machinery house","ticket office (beyond, EST height)"}
doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in OUT: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
doc.saveas("Everett_1886_cross_section.dxf")
fig, ax = plt.subplots(figsize=(11, 17))
for pts in FILL: ax.add_patch(Polygon(pts, closed=True, fc="#c9a89f", ec="none"))
for n, pts in OUT:
    xs, zs = zip(*pts)
    est = "EST" in n or "beyond" in n
    ax.plot(xs, zs, color=("#334" if "roof" in n else "#999" if est else "#222" if n in OPEN else "#7a2318"),
            lw=(0.5 if est or n in OPEN else 1.2), ls="--" if "EST" in n else "-")
for y, z, t in [(12,12,"VESTIBULE /\nGRAND HALL"),(42,10,"GRAND HALL\n(track half)"),(12,30,"CONDUCTORS' &\nTRAINMEN'S ROOM"),(32,30,"open to\nhall"),
                (48,30,"2nd floor"),(28,50,"3rd floor (attic)"),(12,76,"tower"),(30,-5,"basement (EST)")]:
    ax.text(y, z, t, ha="center", va="center", fontsize=6.5, color="#555", style="italic")
last = 1e9
for t, z in sorted(LEVELS, key=lambda v: -v[1]):
    zt = min(z, last - 3.4); last = zt
    ax.plot([64, 68, 70], [z, z, zt], color="#999", lw=0.5); ax.text(71, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
for y, t in [(0,"0 street face"),(25,"25'"),(39,"39'"),(60,"60' track face")]:
    ax.plot([y,y],[-12,-15],color="k",lw=0.6); ax.text(y,-17.5,t,ha="center",fontsize=6)
ax.text(-6,-21,"STREET (north)",fontsize=7); ax.text(60,-21,"TRACK (south)",fontsize=7,ha="right")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - CROSS SECTION at the tower centre (x 159'-6\"), looking east - Rev A", fontsize=9)
ax.text(-6,-25,"Compiled from sheets 04, 05, 07-09, 00 and 01 - no transverse section in the scans.  Dashed = estimate; grey = beyond the cut.\n"
        "Tower heights from sheet 04 (the street elevation, sheet 00, has the pyramid top at 162.5).  Rev A 11/22/2026", fontsize=6.5, va="top")
ax.set_aspect("equal"); ax.set_xlim(-10, 110); ax.set_ylim(-30, 175); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_cross_section.pdf"); plt.savefig("Everett_1886_cross_section.png", dpi=170); print("ok")
