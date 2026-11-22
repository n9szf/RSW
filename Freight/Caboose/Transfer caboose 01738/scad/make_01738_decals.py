#!/usr/bin/env python3
# Rib Side Works - MILW transfer caboose 01738 decal sheets, G 1:29, O 1:48 and HO 1:87.1  (Tom 11/21/2026)
# Writes MILW_01738_G_decals.pdf, _O_ and _HO_ next to this script. Needs: pip install reportlab
# Dark red lettering on clear decal paper. Every size and position comes from the raised lettering that
# MILW_transfer_caboose_01738.scad v3 drew (lettering() and stencils(); LETTERING = "raised" still shows it).
#   python make_01738_decals.py            all three scales
#   python make_01738_decals.py G          one scale (G, O or HO)
import glob, os, sys
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

def font(name, files, fallback):
    for f in files:
        for g in glob.glob(f):
            pdfmetrics.registerFont(TTFont(name, g)); return name
    return fallback
SERIF = font("SERIF", ["/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf", "C:/Windows/Fonts/times.ttf",
                       "/Library/Fonts/Times New Roman.ttf", "/System/Library/Fonts/Supplemental/Times New Roman.ttf"], "Times-Roman")
SANS = font("SANS", ["/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf", "C:/Windows/Fonts/arial.ttf",
                     "/Library/Fonts/Arial.ttf", "/System/Library/Fonts/Supplemental/Arial.ttf"], "Helvetica")

DARK_RED = (0x95 / 255, 0x30 / 255, 0x27 / 255)        # the 3D model's lettering colour
ROAD_NO = "01738"
SCALES = {"G": 29, "O": 48, "HO": 87.1}
HERE = os.path.dirname(os.path.abspath(__file__))

# (text, font, width in, cap height in, x in, z in) - from lettering() / stencils() in the scad (prototype inches)
SIDE = [("THE", SERIF, 29, 6, -63, 70), ("MILWAUKEE", SERIF, 99, 6, -47, 61), ("ROAD", SERIF, 38, 6, 26, 53),
        (ROAD_NO, SERIF, 34, 7, -17, 12)]
END = (ROAD_NO, SERIF, 16, 3.5)
SILL = [("BLT 8-57", SANS, 22, 2.5, -88), ("LT WT 45700", SANS, 30, 2.5, -12)]


def sheet(key):
    ratio = SCALES[key]
    def P(i): return i * 25.4 / ratio * mm                 # prototype inches -> PDF points
    def M(i): return i * 25.4 / ratio                      # prototype inches -> model mm
    out = os.path.join(HERE, f"MILW_01738_{key}_decals.pdf")
    c = canvas.Canvas(out, pagesize=letter); W, H = letter

    def word(x, y, text, fnt, w_in, cap_in):
        """text drawn to exactly w_in wide and cap_in tall (as resize() did in the scad); x, y = lower left"""
        fs = 100.0
        cap = (pdfmetrics.getAscent(fnt) / 1000 * fs) * 0.92 if fnt not in ("Times-Roman", "Helvetica") else fs * 0.66
        wid = pdfmetrics.stringWidth(text, fnt, fs)
        c.saveState(); c.translate(x, y); c.scale(P(w_in) / wid, P(cap_in) / cap)
        c.setFillColorRGB(*DARK_RED); c.setFont(fnt, fs); c.drawString(0, 0, text); c.restoreState()
        return P(w_in)

    def label(x, y, text, size=7):
        c.setFillColorRGB(0, 0, 0); c.setFont("Helvetica", size); c.drawString(x, y, text)

    page = [1]
    def room(y, h):
        """y if a block h tall still fits on this page, else a new page and the y to start at"""
        if y - h >= 15 * mm: return y
        c.showPage(); page[0] += 1
        c.setFont("Helvetica-Bold", 10); c.setFillColorRGB(0, 0, 0)
        c.drawString(15 * mm, H - 15 * mm, f"Transfer caboose {ROAD_NO} - {key} scale decals, page {page[0]} (print at 100%)")
        return H - 25 * mm

    c.setFont("Helvetica-Bold", 12); c.setFillColorRGB(0, 0, 0)
    c.drawString(15 * mm, H - 15 * mm, f"Milwaukee Road transfer caboose {ROAD_NO} - {key} scale 1:{ratio:g} decals (print at 100%, no scaling)")
    label(15 * mm, H - 20 * mm, "Rib Side Works 11/21/26. Dark red lettering - print on CLEAR decal paper. Spares included: cut out what you need.", 8)
    c.setLineWidth(0.5); c.line(15 * mm, H - 25 * mm, 65 * mm, H - 25 * mm)
    label(67 * mm, H - 26 * mm, "check: this bar must measure 50 mm", 8)

    # --- cab sides: the full stepped group, laid out as it sits on the side, 2 sides + 1 spare
    y0 = H - 38 * mm
    span = P(63 + 64) + 8 * mm; tall = P(70 + 6)
    label(15 * mm, y0, "Cab sides - one group per side (+1 spare). Laid out exactly as it goes on the cab: THE / MILWAUKEE / ROAD stepped, number below.")
    x = 15 * mm; y = y0 - 4 * mm - tall
    per_row = max(1, int((W - 30 * mm) // span))
    for n in range(3):
        if n and n % per_row == 0: x = 15 * mm; y -= tall + 8 * mm
        if x == 15 * mm:
            y2 = room(y + tall, tall + 4 * mm) - tall
            if y2 != y: y = y2
        ox = x + P(63)                                     # cab centre line
        for t, f, w, h, px, pz in SIDE:
            word(ox + P(px), y + P(pz), t, f, w, h)
        x += span
    # --- separate words, for anyone who prefers to place them one at a time
    y -= 10 * mm
    y = room(y, P(7) * 4 + 20 * mm)
    label(15 * mm, y + 2 * mm, "Or as single pieces (2 sets): THE, MILWAUKEE, ROAD, and the cab-side number")
    y -= P(7) + 4 * mm; x = 15 * mm
    for n in range(2):
        for t, f, w, h, _, _ in SIDE:
            if x + P(w) > W - 15 * mm: x = 15 * mm; y -= P(7) + 5 * mm; y = room(y, 0)
            x += word(x, y, t, f, w, h) + 5 * mm
    # --- ends and sill stencils
    y -= 12 * mm
    y = room(y, P(4) * 3 + 20 * mm)
    label(15 * mm, y + 2 * mm, "Cab ends: small number above each end door (2 + 2 spares).   Side sills: BLT 8-57 and LT WT 45700 (2 sides + spares)")
    y -= P(4) + 4 * mm; x = 15 * mm
    for n in range(4):
        x += word(x, y, *END) + 5 * mm
    x += 6 * mm
    for n in range(3):
        for t, f, w, h, _ in SILL:
            if x + P(w) > W - 15 * mm: x = 15 * mm; y -= P(4) + 5 * mm
            x += word(x, y, t, f, w, h) + 4 * mm
    # --- placement, in model mm for this scale
    y -= 14 * mm
    y = room(y, 32 * mm)
    lines = [
        "PLACEMENT (measured from the cab centre line along the side, and up from the top of the deck):",
        f"  THE: left end {M(63):.1f} mm left of centre, bottom {M(70):.1f} mm up.   MILWAUKEE: left end {M(47):.1f} mm left, bottom {M(61):.1f} mm up.",
        f"  ROAD: left end {M(26):.1f} mm right of centre, bottom {M(53):.1f} mm up.   Number {ROAD_NO}: left end {M(17):.1f} mm left, bottom {M(12):.1f} mm up.",
        f"  End doors: number centred {M(16):.1f} mm off the car centre line, bottom just above the door top. Letters read normally on both sides.",
        f"  Sill stencils: on the deck side sill, bottom {M(9):.1f} mm below the deck top; BLT 8-57 starts {M(88):.1f} mm left of car centre, LT WT {M(12):.1f} mm left.",
        "Paint first (cab Milwaukee Road orange, deck, roof and brake gear black), gloss coat, decals, then a flat or satin coat.",
        "Lettering layout from the Walthers HO model of 01731 and Tom's ETRM photos of 01738; fonts are stand-ins for the railroad's.",
    ]
    for i, l in enumerate(lines):
        label(15 * mm, y - i * 4 * mm, l)
    c.showPage(); c.save()
    return out


if __name__ == "__main__":
    keys = [a.upper() for a in sys.argv[1:] if a.upper() in SCALES] or list(SCALES)
    for k in keys:
        print("wrote", sheet(k))
