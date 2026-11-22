# Everett Street depot 1886 - END ELEVATIONS. Rev B (orientation fixed 11/22).
# EAST END (emigrants' end, boiler room below) from MPL sheet 03 - blueprint drawing 5142 "East End Elevation", same blueprint series as the
#   basement plan (drawing 4914).  The ground falls ~9 ft to the east: basement exposed, first floor 13.5 ft above the ground there.
#   Sheet 03 readings are shifted -9.0 ft so the first floor sits at the common 4.5 ft datum (east ground = -9.0).
# WEST END (baggage end) from MPL sheet 02, drawn with the train shed.  Sheet 02 shows the tower on the right, i.e. as if seen from
#   the east - drawn here mirrored as a west view.  QUERY for Tom: sheet 02 may be an earlier east-end study.
# Coordinates: d = distance from the street (north) face, 0-60 ft; z from the street-sidewalk datum.  Scale fixed on the 60 ft depth (+-0.5 ft).
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Circle
OUT = []
def P(n, pts): OUT.append((n, pts))
def arc(xc, zc, r, a0=0, a1=180, n=24): return [(xc+r*math.cos(math.radians(a0+(a1-a0)*i/n)), zc+r*math.sin(math.radians(a0+(a1-a0)*i/n))) for i in range(n+1)]

def end_view(east=True, off=0.0):
    """Seen from outside: from the east (facing west) north (d=0) is on the RIGHT; from the west, north is on the LEFT."""
    U = (lambda d: off + 60 - d) if east else (lambda d: off + d)
    def p(n, pts): P(n, [(U(d), z) for d, z in pts])
    def box(n, d0, d1, z0, z1): p(n, [(d0,z0),(d1,z0),(d1,z1),(d0,z1),(d0,z0)])
    def win(d0, d1, z0, z1, mull=1, rail=True, n="window"):
        box(n, d0, d1, z0, z1)
        if rail: p("sash", [(d0,(z0+z1)/2),(d1,(z0+z1)/2)])
        for i in range(1, mull+1): d = d0+(d1-d0)*i/(mull+1); p("sash", [(d,z0),(d,z1)])
    # tower (north band, d -1.5..25) behind; shaft, great arch, belfry, clock stage, turrets, pyramid (sheets 00/01)
    t0, t1, tc = -1.5, 25.0, 11.75
    p("tower shaft", [(t0,45),(t0,118.5),(t1,118.5),(t1,45)])
    for z in [87.5, 100.0]: p("tower cornice", [(t0-1,z),(t1+1,z)])
    p("arch", [(tc+12.5, 66)] + arc(tc, 68.7, 12.5) + [(tc-12.5, 66)]); p("arch", arc(tc, 68.7, 9.5))
    p("window", [(tc-5,66),(tc-5,70)] + arc(tc, 70, 5.0, 180, 0) + [(tc+5,66)])
    for i in range(4):
        d0 = tc - 8 + i*4.2; p("window", [(d0,89.7),(d0,95.0)] + arc(d0+1.3, 95.0, 1.3, 180, 0) + [(d0+2.6,89.7),(d0,89.7)])
    win(tc-2.6, tc+2.6, 103.5, 109.0)
    p("arch", arc(tc, 115.0, 5.6)); p("clock ring", arc(tc, 115.0, 3.2, 0, 360, 48))
    for x0 in [t0-1.0, t1-6.0]:
        p("corner turret", [(x0,100),(x0,121),(x0+3.5,146),(x0+7,121),(x0+7,100)]); p("vane", [(x0+3.5,146),(x0+3.5,152)])
        win(x0+2.4, x0+4.6, 105.3, 111.2, mull=0, rail=False)
    p("clock gable", [(tc-7,118.5),(tc-7,126),(tc-3.5,129),(tc+3.5,129),(tc+7,126),(tc+7,118.5)])
    p("tower roof (pyramid)", [(t0+5,121),(tc-5.4,160.7),(tc+5.4,160.7),(t1-5,121)])
    box("cresting", tc-5.4, tc+5.4, 160.7, 170.0); p("vane", [(tc,170),(tc,180)])
    # main block behind: steep roof face to the 61 ft top, cresting
    p("main roof", [(0.9,45),(0.9,61),(59.1,61),(59.1,45)]); p("cresting", [(0.9,61.6),(59.1,61.6)])
    # chimney behind the end gables
    box("chimney", 27.0, 34.1, 45.0, 73.5)
    if not east:
        # ---- WEST END (baggage), sheet 02 ----
        p("end block wall", [(0,0),(0,23.4),(60,23.4),(60,0),(0,0)])
        p("plinth", [(-0.6,0),(-0.6,3.0),(60.6,3.0),(60.6,0)])
        p("cornice", [(-0.8,20.0),(60.8,20.0)]); p("cornice", [(-0.8,23.4),(60.8,23.4)])
        p("end block roof", [(1.5,28.3),(15.2,44.6),(44.8,44.6),(58.5,28.3)]); p("end block roof", [(1.5,28.3),(19.7,28.3)]); p("end block roof", [(41.2,28.3),(58.5,28.3)])
        p("pavilion", [(19.7,23.4),(19.7,29.2),(21.5,29.2),(21.5,31.0),(23.5,31.0),(26.5,35.5),(26.5,37.5),(34.5,37.5),(34.5,35.5),(37.5,31.0),(39.5,31.0),(39.5,29.2),(41.2,29.2),(41.2,23.4)])
        win(27.1, 30.1, 23.7, 29.4, mull=0); win(31.5, 34.5, 23.7, 29.4, mull=0)
        p("arch", arc(30.8, 29.4, 3.7)); p("arch", arc(30.8, 29.4, 5.2))
        for c, (w0, w1) in [(25.1,(23.5,26.6)),(35.7,(34.3,37.5))]:
            p("gable", [(c-9.0,45.0),(c,57.7),(c+9.0,45.0)]); win(w0, w1, 46.3, 51.9, mull=0)
            p("half-timber", [(c-5.5,45.0),(c-5.5,48.5)]); p("half-timber", [(c+5.5,45.0),(c+5.5,48.5)])
        for d in [15.8, 45.4]: p("finial", [(d,44.6),(d,50.0)])
        for d0, d1 in [(7.2,15.0),(26.3,34.4),(46.1,54.2)]:
            p("door", [(d0,4.1),(d0,10.6),(d1,10.6),(d1,4.1)]); p("door leaf", [((d0+d1)/2,4.1),((d0+d1)/2,10.6)])
            p("sill", [(d0-0.8,11.0),(d1+0.8,11.0)])
        for d0, d1 in [(7.5,10.4),(11.9,15.0),(46.4,49.3),(50.8,53.9)]: win(d0, d1, 12.3, 18.0, mull=0)
        for z0, z1 in [(12.6,15.4),(15.9,18.7)]: win(26.6, 34.1, z0, z1, mull=1, rail=False)
    else:
        # ---- EAST END (emigrants' room over the boiler room), sheet 03, shifted -9 ft ----
        S = -9.0
        def q(n, pts): p(n, [(d, z+S) for d, z in pts])
        def qwin(d0, d1, z0, z1, mull=1, rail=True, n="window"): win(d0, d1, z0+S, z1+S, mull, rail, n)
        q("end block wall", [(0,0),(0,33.0),(60,33.0),(60,0),(0,0)])
        q("water table", [(-0.4,13.5),(60.4,13.5)]); q("water table", [(-0.4,12.6),(60.4,12.6)])
        q("cornice", [(-0.6,32.0),(60.6,32.0)]); q("cornice", [(-0.8,33.6),(60.8,33.6)])
        q("pavilion", [(19.1,13.5),(19.1,38.0),(18.5,38.0),(18.5,39.0),(22.0,39.0),(26.5,46.0),(34.0,46.0),(38.5,39.0),(42.0,39.0),(42.0,38.0),(40.8,38.0),(40.8,13.5)])
        for d0, d1 in [(5.2,9.2),(10.8,14.8),(25.1,29.2),(30.3,34.4),(44.9,49.0),(50.4,54.4)]: qwin(d0, d1, 5.4, 9.9)
        for d0, d1 in [(4.4,15.4),(24.2,35.6),(44.4,55.0)]: q("hood", [(d0,11.3),(d1,11.3)])
        for d0, d1 in [(5.8,9.9),(10.8,14.8),(45.1,49.4),(50.3,54.4)]:
            qwin(d0, d1, 18.0, 24.7); qwin(d0, d1, 25.6, 28.7, mull=0, rail=False, n="transom")
            q("lintel", [(d0-1.0,30.6),(d1+1.0,30.6)])
        qwin(24.5, 35.7, 15.8, 24.7, mull=1); qwin(24.5, 35.7, 25.4, 28.6, mull=1, rail=False, n="transom")
        q("window", [(24.5,28.6),(24.5,29.8),(35.7,29.8),(35.7,28.6)]); q("panel", [(24.5,14.4),(35.7,14.4)])
        for d0, d1 in [(26.0,29.2),(30.9,34.2)]: qwin(d0, d1, 32.4, 37.2, mull=0)
        p("arch", [(dd, z+S) for dd, z in arc(30.0, 39.0, 3.6)]); p("arch", [(dd, z+S) for dd, z in arc(30.0, 39.0, 5.0)])
        q("end block roof", [(0.6,36.9),(15.2,53.6),(44.8,53.6),(59.4,36.9)]); q("end block roof", [(0.6,36.9),(18.5,36.9)]); q("end block roof", [(42.0,36.9),(59.4,36.9)])
        for c, d0, d1 in [(10.4,9.0,12.0),(49.6,47.6,51.7)]:
            qwin(d0, d1, 35.2, 43.0, mull=0); q("dormer", [(c-3.0,35.0),(c-3.0,44.4),(c,48.4),(c+3.0,44.4),(c+3.0,35.0)])
        q("chimney", [(27.0,46.0),(27.0,66.0),(34.0,66.0),(34.0,46.0)])
        for c, (w0, w1) in [(25.1,(23.5,26.6)),(35.7,(34.3,37.5))]:
            p("gable", [(c-9.0,45.0),(c,57.7),(c+9.0,45.0)]); win(w0, w1, 46.3, 51.9, mull=0)
        box("tall stack (behind, at the track wall)", 54.0, 59.5, 33.0, 92.7)
        p("grade (east, about 9 ft below the street)", [(-4, S), (64, S)])

end_view(east=True, off=0.0)
end_view(east=False, off=85.0)
LEVELS = [("tower vane (sheets 00/01)", 180), ("pyramid top", 160.7), ("turret tips", 146), ("clock centre (east face)", 115),
          ("main roof top / cresting", 61), ("end gable peaks", 57.7), ("end-block roof top", 44.6), ("pavilion gable top", 37.5),
          ("hip eave (west)", 28.3), ("end-block cornice", 23.4), ("first floor (datum)", 4.5), ("baggage door sills (west)", 4.1), ("street sidewalk / west grade", 0), ("east grade (sheet 03)", -9.0)]
OPEN = {"window","sash","transom","arch","door","door leaf","clock ring","sill","half-timber","finial","cresting"}

doc = ezdxf.new("R2010"); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, pts in OUT: msp.add_lwpolyline(pts, dxfattribs={"layer": "".join(ch if ch.isalnum() else "_" for ch in n.split(" (")[0]).upper()})
doc.saveas("Everett_1886_end_elevations.dxf")
fig, ax = plt.subplots(figsize=(11, 17))
for n, pts in OUT:
    xs, zs = zip(*pts)
    ax.plot(xs, zs, color=("#334" if "roof" in n else "#222" if n in OPEN else "#7a2318"),
            lw=(0.4 if n in ("sash","door leaf","clock ring","half-timber","sill") else 0.8 if n in OPEN else 1.2))
ax.plot([79, 152], [0, 0], color="k", lw=1.4)
for off, t, l, r in [(0, "EAST END - emigrants' end (sheet 03)", "S - track", "N - street"), (85, "WEST END - baggage end (sheet 02, mirrored)", "N - street", "S - track")]:
    ax.text(off+30, -16, t, ha="center", fontsize=9, weight="bold"); ax.text(off, -12, l, fontsize=6.5); ax.text(off+60, -12, r, fontsize=6.5, ha="right")
last = 1e9
for t, z in sorted(LEVELS, key=lambda v: -v[1]):
    zt = min(z, last - 3.4); last = zt
    ax.plot([148, 152, 154], [z, z, zt], color="#999", lw=0.5); ax.text(155, zt, f"{z:6.1f}'  {t}", va="center", fontsize=6.5, family="monospace")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - END ELEVATIONS - Rev B", fontsize=10)
ax.text(-5, -21, "East end from MPL sheet 03 (blueprint 5142): ground ~9 ft below the street, basement windows exposed.  West end from sheet 02 (drawn on the sheet as if\n"
        "seen from the east - mirrored here; may be an early study).  Tower above the roofs follows sheets 00/01.  Rev B 11/22/2026 orientation fixed", fontsize=6.5, va="top")
ax.set_aspect("equal"); ax.set_xlim(-8, 205); ax.set_ylim(-28, 186); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_end_elevations.pdf"); plt.savefig("Everett_1886_end_elevations.png", dpi=170); print("ok")
