#!/usr/bin/env python3
# Rib Side Works - X5000 dynamometer car decal sheet, G scale 1:29.
# Writes X5000_G_decals.pdf next to this script. Needs: pip install reportlab
# Sizes match X5000_dyno_G.scad (letterboard 9 in band, 6 in letters, heralds 30 x 20 in).
import os, glob
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

def font(name, files):
    for f in files:
        for g in glob.glob(f):
            pdfmetrics.registerFont(TTFont(name, g)); return name
    return "Times-Bold" if name == "SERIF" else "Helvetica-Bold"
SERIF = font("SERIF", ["/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf",
                       "C:/Windows/Fonts/timesbd.ttf", "/Library/Fonts/Times New Roman Bold.ttf"])
SANS  = font("SANS",  ["/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
                       "C:/Windows/Fonts/arialbd.ttf", "/Library/Fonts/Arial Bold.ttf"])

SCALE = 29
def inch(i): return i * 25.4 / SCALE * mm          # prototype inches -> PDF points
ORANGE = (0.90, 0.42, 0.08); RED = (0.78, 0.10, 0.10)
CAP = 0.662                                        # cap height / font size

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "X5000_G_decals.pdf")
c = canvas.Canvas(out, pagesize=letter)
W, H = letter
c.setFont("Helvetica-Bold", 12)
c.drawString(15*mm, H-15*mm, "Milwaukee Road X5000 dynamometer car - G scale 1:29 decals (print at 100%, no scaling)")
c.setFont("Helvetica", 8)
c.drawString(15*mm, H-20*mm, "Rib Side Works 10/30/26. Black strips and heralds: white decal paper. DYNAMOMETER: clear decal paper.")
c.setLineWidth(0.5); c.line(15*mm, H-25*mm, 65*mm, H-25*mm); c.drawString(67*mm, H-26*mm, "check: this bar must measure 50 mm")

def label(y, text):
    c.setFillColorRGB(0, 0, 0); c.setFont("Helvetica", 7); c.drawString(15*mm, y, text)

def strip(x, y, text, cap_in, band_in=9, pad_in=6):
    fs = inch(cap_in) / CAP
    w = pdfmetrics.stringWidth(text, SERIF, fs) + 2*inch(pad_in); h = inch(band_in)
    c.setFillColorRGB(0, 0, 0); c.rect(x, y, w, h, stroke=0, fill=1)
    c.setFillColorRGB(*ORANGE); c.setFont(SERIF, fs); c.drawString(x + inch(pad_in), y + (h - inch(cap_in))/2, text)
    return w

y = H - 40*mm
label(y + inch(9) + 2*mm, "Letterboard, one per side (orange on black, 6 in letters)")
for i in range(2): strip(15*mm, y - i*12*mm, "THE MILWAUKEE ROAD", 6)

y -= 36*mm
label(y + inch(9) + 2*mm, "Car number: letterboard ends (4) and car ends above the door (2, 5 in letters)")
x = 15*mm
for i in range(4): x += strip(x, y, "X5000", 6) + 4*mm
x = 15*mm
for i in range(2): x += strip(x, y - 11*mm, "X5000", 5, band_in=8) + 4*mm

y -= 42*mm
hw, hh = inch(30), inch(20)
label(y + hh + 3*mm, "Box heralds, 2 per side - set them at about 18 degrees, as in the photos")
for i in range(4):
    c.saveState(); c.translate(15*mm + i*(hw + 6*mm) + hw/2, y + hh/2)
    c.setFillColorRGB(*RED); c.rect(-hw/2, -hh/2, hw, hh, stroke=0, fill=1)
    c.setStrokeColorRGB(1, 1, 1); c.setLineWidth(inch(1)); o = inch(2)
    c.rect(-hw/2 + o, -hh/2 + o, hw - 2*o, hh - 2*o, stroke=1, fill=0)
    c.setFillColorRGB(1, 1, 1)
    for txt, fr, dy in [("THE", 0.30, 0.27), ("MILWAUKEE", 0.78, 0), ("ROAD", 0.42, -0.27)]:
        fs = 10 * fr * hw / pdfmetrics.stringWidth(txt, SANS, 10)
        c.setFont(SANS, fs); c.drawCentredString(0, dy*hh - fs*0.36, txt)
    c.restoreState()

y -= 26*mm
label(y + inch(6) + 2*mm, "Class lettering, one per side (black on clear, 4 in letters), low mid-side about 36 ft from the A end")
c.setFillColorRGB(0, 0, 0)
for i in range(2):
    c.setFont(SERIF, inch(4)/CAP); c.drawString(15*mm + i*70*mm, y, "DYNAMOMETER")

y -= 16*mm
for i, l in enumerate([
    "Placement (model v4): letterboard text centred on the car; X5000 about 5 ft from each end; heralds 3.6 ft from the A end (ahead of",
    "the bay) and 4.5 ft from the B end, centre 5 ft 3 in above the rail; DYNAMOMETER 30 ft back, 5 ft above the rail. A end = instrument end.",
    "Paint the body Milwaukee Road orange; roof, letterboard band and ends black. Layout from photos of X5000 at Shoreham (1980s)",
    "and IRM (2014). The fonts are stand-ins for the railroad's Roman lettering."]):
    label(y - i*4*mm, l)
c.showPage(); c.save()
print("wrote", out)
