import sys, os, glob, textwrap, re
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
f = [p for p in glob.glob('/usr/share/fonts/**/DejaVuSansMono.ttf', recursive=True)]
b = [p for p in glob.glob('/usr/share/fonts/**/DejaVuSansMono-Bold.ttf', recursive=True)]
pdfmetrics.registerFont(TTFont('M', f[0])); pdfmetrics.registerFont(TTFont('MB', b[0]))
def conv(src, dst, title):
    lines = open(src, encoding='utf-8', errors='replace').read().replace('\t', '    ').split('\n')
    W, H = letter; fs = 7.6; lh = 10.2; cw = pdfmetrics.stringWidth('M', 'M', fs); mx = 40
    cols = int((W - 2 * mx) / cw)
    out = []
    for ln in lines:
        if len(ln) <= cols: out.append(ln); continue
        ind = len(ln) - len(ln.lstrip()); m = re.match(r'\s*([-*]|\d+\.)\s+', ln)
        hang = ' ' * (len(m.group(0)) if m else ind)
        out += textwrap.wrap(ln, cols, subsequent_indent=hang, break_long_words=True, replace_whitespace=False) or ['']
    c = canvas.Canvas(dst, pagesize=letter); c.setTitle(title); page = 0
    per = int((H - 90) / lh)
    for i in range(0, max(1, len(out)), per):
        page += 1; y = H - 46
        c.setFont('MB', 8); c.drawString(mx, H - 28, title); c.setFont('M', 7); c.drawRightString(W - mx, 24, 'page %d' % page)
        for ln in out[i:i + per]:
            head = ln.startswith('#') or (ln.isupper() and len(ln.strip()) > 3)
            c.setFont('MB' if head else 'M', fs); c.drawString(mx, y, ln); y -= lh
        c.showPage()
    c.save(); return page
T = "_transfer (safe to delete)/text originals (Claude's working copies)/"
jobs = [('Notes/Brass canopy posts - G scale.txt', 'Notes/Brass canopy posts - G scale.pdf'),
        ('3MF/READ ME - 3MF files.txt', '3MF/READ ME - 3MF files.pdf'),
        ('HO Scale (1-87)/Notes/READ ME - HO scale Janesville depot.txt', 'HO Scale (1-87)/Notes/READ ME - HO scale Janesville depot.pdf'),
        (T + 'To-Do - What Claude Needs From Tom', 'Notes/To-Do - What Claude Needs From Tom.pdf'),
        (T + 'Project Notes - Janesville Milwaukee Road Depot', 'Notes/Project Notes - Janesville Milwaukee Road Depot.pdf'),
        ('Reference/Dimension Sheet - 1902 Frost & Granger', 'Reference/Dimension Sheet - 1902 Frost & Granger.pdf')]
for s, d in jobs:
    if not os.path.exists(s): continue
    print(conv(s, d, os.path.basename(d)[:-4]), 'pages', d)
