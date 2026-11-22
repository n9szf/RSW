"""Milwaukee Road F7 4-6-4 No. 100 (1938) - 2D side profile, rev A.

Units: inches, full size. x = distance back from the front of the pilot
(coupler face), z = height above top of rail.
Source: ALCO elevation, Railway Mechanical Engineer Nov 1938 p. 446
(reference/Locomotives/F7 Hudson/F7_ALCO_elevation_and_sections_RME_1938-11_p446.png).

  EXACT   = dimension printed on the ALCO drawing or table
  TRACED  = measured off the scan (about +/- 3 in)
  GUESS   = not on the drawing yet (tender) - check against photos

Run:  python3 F7_side_profile.py   -> F7_side_profile_revA.pdf / .dxf / .png
      python3 F7_side_profile.py --overlay <scan.png>  -> overlay check picture
"""
import math, sys

REV = "B"

# ---- wheels (EXACT spacing: 92 3/4, 86, 74, 88, 88, 108, 64) --------------
WHEELS = []  # (x, dia, name)
x = 92.75
for step, dia, name in [(0, 36, "lead 1"), (86, 36, "lead 2"), (74, 84, "driver 1"),
                        (88, 84, "driver 2 (main)"), (88, 84, "driver 3"),
                        (108, 38, "trailing front"), (64, 44, "trailing rear")]:
    x += step
    WHEELS.append((x, dia, name))

ENGINE_LEN = 714.875          # EXACT 59'-6 7/8" over all
TOTAL_LEN = 1200.0            # EXACT 100'-0" over couplers (engine + tender)
MAX_H = 186.0                 # EXACT 15'-6"
STACK_H = 183.0               # EXACT 15'-3" top of stack (table)
BOILER_CL = 129.0             # EXACT 10'-9"
WIDTH = 126.5                 # EXACT 10'-6 1/2" over all
CYL_X, CYL_Z, CYL_DIA = 136.0, 51.0, 23.5   # TRACED position, EXACT bore

# ---- boiler (EXACT diameters; TRACED ends) --------------------------------
SMOKEBOX = (89.0, 230.0, 85.5)    # x front, x back, OD
BARREL = (230.0, 588.0, 94.0)     # to backhead (largest ring 94 OD)

# ---- shroud outline (TRACED), clockwise from nose top ---------------------
NOSE_RAKE_DEG = 16.0              # EXACT (article)
nose_top_z, nose_low_z = 165.0, 60.0
nose_low_x = 24.0
nose_top_x = nose_low_x + (nose_top_z - nose_low_z) * math.tan(math.radians(NOSE_RAKE_DEG))

def bez(p0, p1, p2, n=8):
    """Quadratic Bezier from p0 to p2 with control p1 (smooth corners)."""
    return [((1-t)**2*p0[0]+2*(1-t)*t*p1[0]+t*t*p2[0], (1-t)**2*p0[1]+2*(1-t)*t*p1[1]+t*t*p2[1])
            for t in [i/n for i in range(1, n+1)]]

# rev B: shaped from the ALCO elevation plus ALCO builder photo of No. 100 (railarchive.net)
STACK_X = 112.0
SHROUD = (
    [(nose_top_x + 26, 183.0)]
    + bez((nose_top_x + 26, 183.0), (nose_top_x + 2, 182.0), (nose_top_x, nose_top_z))   # rounded nose top
    + [(nose_low_x, nose_low_z)]                                                          # 16 deg rake
    + bez((nose_low_x, nose_low_z), (8.0, 20.0), (6.0, 5.0), 4)                           # pilot toe
    + [(36.0, 26.0), (70.0, 39.0), (130.0, 44.0), (198.0, 49.0)]                         # pilot skirt clears the lead wheels (photo)
    + bez((198.0, 49.0), (232.0, 84.0), (265.0, 84.0))                                    # sweeps up to running-board skirt
    + [(470.0, 84.0)]                                                                     # skirt edge over the drivers
    + bez((470.0, 84.0), (560.0, 82.0), (601.0, 52.0))                                    # curves down under the cab
    + [(716.0, 52.0), (716.0, 163.0), (628.0, 165.0)]                                     # cab rear, roof
    + bez((628.0, 165.0), (600.0, 166.0), (575.0, 178.0), 5)                              # fishtail onto the cab roof
    + [(330.0, 181.0), (150.0, 184.0), (STACK_X, MAX_H), (90.0, 184.0)]                    # cowling, stack cap highest
)
SKIRT_STRIPES = [((60.0, 470.0), z) for z in (100.0, 106.0)]   # maroon / orange band (paint guide, TDQ-592)
CAB = (601.0, 716.0, 52.0, 165.0)          # TRACED, 117" cab length EXACT
CAB_WINDOWS = [(612, 650, 112, 140), (660, 705, 108, 140)]   # TRACED

# ---- tender (GUESS until photos are measured) -----------------------------
TENDER_FRONT = ENGINE_LEN + 2.0
TENDER_BACK = TOTAL_LEN
TENDER_TOP = 156.0       # photo: just below cab roof
TENDER_BOTTOM = 36.0     # photo: side sheet skirts down over the trucks
TENDER_TRUCKS = [820.0, 1104.75]   # truck centres; last axle at 89'-10" from lead axle
TENDER_WB = 66.0                   # axle spacing in each six-wheel truck (GUESS)
TENDER_WHEEL = 38.0                # EXACT (article)


def lines():
    """Return list of (layer, polyline points, closed)."""
    out = [("RAIL", [(-12, 0), (TOTAL_LEN + 12, 0)], False)]
    out.append(("SHROUD", SHROUD, True))
    x0, x1, z0, z1 = CAB
    out.append(("CAB", [(x0, z0), (x1, z0), (x1, z1), (x0, z1)], True))
    for a, b, c, d in CAB_WINDOWS:
        out.append(("CAB", [(a, c), (b, c), (b, d), (a, d)], True))
    for xf, xb, od in (SMOKEBOX, BARREL):
        r = od / 2
        out.append(("BOILER", [(xf, BOILER_CL - r), (xb, BOILER_CL - r), (xb, BOILER_CL + r), (xf, BOILER_CL + r)], True))
    tf, tb, tt, tz = TENDER_FRONT, TENDER_BACK, TENDER_TOP, TENDER_BOTTOM
    out.append(("TENDER", [(tf, tz), (tb - 6, tz)] + bez((tb - 6, tz), (tb, tz), (tb, tz + 10), 3)
                + [(tb, tt - 24)] + bez((tb, tt - 24), (tb, tt), (tb - 30, tt), 6)
                + [(tf + 14, tt), (tf, tt - 8)], True))
    for (xa, xb), z in SKIRT_STRIPES:
        out.append(("STRIPE", [(xa, z), (xb, z)], False))
    return out


def circles():
    c = [("WHEELS", (x, d / 2), d / 2) for x, d, _ in WHEELS]
    for tc in TENDER_TRUCKS:
        for k in (-1, 0, 1):
            c.append(("TENDER", (tc + k * TENDER_WB, TENDER_WHEEL / 2), TENDER_WHEEL / 2))
    c.append(("CYLINDER", (CYL_X, CYL_Z), CYL_DIA / 2))
    return c


def ftin(v):
    f = int(v // 12); i = v - f * 12
    return f"{f}'-{i:.2f}\"".replace(".00\"", "\"").replace(".50\"", " 1/2\"").replace(".25\"", " 1/4\"").replace(".75\"", " 3/4\"").replace(".88\"", " 7/8\"")


def draw(ax, overlay=False):
    col = {"RAIL": "k", "SHROUD": "tab:blue", "CAB": "tab:blue", "BOILER": "0.6",
           "TENDER": "tab:orange", "WHEELS": "k", "CYLINDER": "0.4", "STRIPE": "tab:red"}
    import matplotlib.patches as mp
    for layer, pts, closed in lines():
        xs = [-p[0] for p in pts] + ([-pts[0][0]] if closed else [])
        zs = [p[1] for p in pts] + ([pts[0][1]] if closed else [])
        ls = "--" if layer in ("BOILER", "TENDER") else (":" if layer == "STRIPE" else "-")
        ax.plot(xs, zs, ls, color=("r" if overlay else col[layer]), lw=1.2)
    for layer, (cx, cz), r in circles():
        ax.add_patch(mp.Circle((-cx, cz), r, fill=False, ls="--" if layer == "TENDER" else "-",
                               color=("r" if overlay else col[layer]), lw=1.0))


def dims(ax):
    y = -30
    prev = 0.0
    for x, d, name in WHEELS:
        ax.annotate("", xy=(-prev, y), xytext=(-x, y), arrowprops=dict(arrowstyle="<->", lw=0.6))
        ax.text(-(prev + x) / 2, y - 9, f"{x - prev:g}\"", ha="center", fontsize=6)
        ax.text(-x, -14, f"{d}\" dia", ha="center", fontsize=5)
        prev = x
    ax.annotate("", xy=(0, -55), xytext=(-ENGINE_LEN, -55), arrowprops=dict(arrowstyle="<->", lw=0.6))
    ax.text(-ENGINE_LEN / 2, -66, "Engine 59'-6 7/8\" over all (ALCO)", ha="center", fontsize=7)
    ax.annotate("", xy=(0, -80), xytext=(-TOTAL_LEN, -80), arrowprops=dict(arrowstyle="<->", lw=0.6))
    ax.text(-TOTAL_LEN / 2, -91, "100'-0\" over couplers, engine + tender", ha="center", fontsize=7)
    ax.annotate("", xy=(25, 0), xytext=(25, MAX_H), arrowprops=dict(arrowstyle="<->", lw=0.6))
    ax.text(30, MAX_H / 2, "15'-6\" max", rotation=90, va="center", fontsize=7)
    ax.annotate("", xy=(45, 0), xytext=(45, BOILER_CL), arrowprops=dict(arrowstyle="<->", lw=0.6))
    ax.text(50, BOILER_CL / 2, "10'-9\" boiler CL", rotation=90, va="center", fontsize=7)
    ax.plot([-SMOKEBOX[0] + 10, -BARREL[1] - 10], [BOILER_CL] * 2, "-.", color="0.5", lw=0.5)


def main():
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    if "--overlay" in sys.argv:
        overlay_check(sys.argv[sys.argv.index("--overlay") + 1]); return
    fig, ax = plt.subplots(figsize=(17, 11))
    draw(ax); dims(ax)
    ax.set_aspect("equal"); ax.axis("off")
    ax.set_xlim(-TOTAL_LEN - 30, 70); ax.set_ylim(-110, 230)
    ax.set_title(f"Milwaukee Road class F7 4-6-4 No. 100 (1938) - side profile, rev {REV}   "
                 "(full size, inches; pilot to the right)", fontsize=11)
    ax.text(-TOTAL_LEN - 25, 215,
            "Blue = shroud and cab, rev B: ALCO elevation (RME Nov 1938 p.446) + ALCO builder photo of No. 100, about +/-3 in.  Red dotted = skirt stripe band.  "
            "Black = wheels, ALCO dimensions.  Grey dashed = boiler (ALCO).\n"
            "Orange dashed = tender: height from the builder photo, length from the 100'-0\" total; trucks still a guess.  "
            "Width over all 10'-6 1/2\", cab 126\" wide, cylinder centres 91\".", fontsize=7, va="top")
    fig.savefig(f"F7_side_profile_rev{REV}.pdf", bbox_inches="tight")
    fig.savefig(f"F7_side_profile_rev{REV}.png", dpi=110, bbox_inches="tight")
    write_dxf()


def write_dxf():
    import ezdxf
    doc = ezdxf.new(); msp = doc.modelspace()
    for layer, pts, closed in lines():
        if layer not in doc.layers: doc.layers.add(layer)
        msp.add_lwpolyline([(-p[0], p[1]) for p in pts], close=closed, dxfattribs={"layer": layer})
    for layer, (cx, cz), r in circles():
        if layer not in doc.layers: doc.layers.add(layer)
        msp.add_circle((-cx, cz), r, dxfattribs={"layer": layer})
    doc.units = ezdxf.units.IN
    doc.saveas(f"F7_side_profile_rev{REV}.dxf")


def overlay_check(scan):
    """Draw the profile in red over the ALCO scan (engine only) to check the tracing."""
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from PIL import Image
    im = Image.open(scan).convert("L")
    # scan calibration (full-res sheet): pilot front X=3330, rail Y=1175, 3.925 px/in
    PX, RY, S = 3330.0, 1175.0, 3.925
    x0, x1 = int(PX - 760 * S), int(PX + 60 * S)
    y0, y1 = int(RY - 200 * S), int(RY + 20 * S)
    crop = im.crop((x0, y0, x1, y1))
    fig, ax = plt.subplots(figsize=(17, 6))
    ax.imshow(crop, cmap="gray", extent=(-(PX - x0) / S, (x1 - PX) / S, (RY - y1) / S, (RY - y0) / S))
    draw(ax, overlay=True)
    ax.set_xlim(-(PX - x0) / S, (x1 - PX) / S); ax.set_ylim((RY - y1) / S, (RY - y0) / S)
    ax.set_title(f"F7 rev {REV} profile (red) over the ALCO elevation - check fit")
    fig.savefig(f"F7_side_profile_rev{REV}_overlay.png", dpi=110, bbox_inches="tight")


if __name__ == "__main__":
    main()
