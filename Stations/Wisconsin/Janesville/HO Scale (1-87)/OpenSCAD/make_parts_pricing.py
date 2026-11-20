import csv, sys
sys.path.insert(0,'/home/claude/ho/scad')
from make_3mf import PALETTE
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter as L
rows=list(csv.DictReader(open('/home/claude/ho/3mf_out/manifest_all.csv')))
A='Arial'; B=Font(name=A,bold=True); N=Font(name=A); BL=Font(name=A,color='0000FF'); H=Font(name=A,bold=True,color='FFFFFF')
HF=PatternFill('solid',fgColor='3B4A2C'); YF=PatternFill('solid',fgColor='FFFF00'); T=Font(name=A,bold=True,size=14); I=Font(name=A,italic=True,color='555555')
wb=Workbook()
def hdr(ws,r,cols,widths=None):
    for i,c in enumerate(cols,1):
        x=ws.cell(r,i,c); x.font=H; x.fill=HF; x.alignment=Alignment(wrap_text=True,vertical='center')
    if widths:
        for i,w in enumerate(widths,1): ws.column_dimensions[L(i)].width=w
# ---------------- Prices
P=wb.active; P.title='Prices'
P['A1']='Janesville depot HO (1:87) - prices and assumptions'; P['A1'].font=T
P['A2']='Blue cells are yours to change - every other sheet recalculates. Yellow = guesses I could not confirm; please replace.'; P['A2'].font=I
hdr(P,4,['Filament (model colour)','Closest Bambu PETG HF colour','Price per 1 kg spool ($)','Grams (all parts)','(not used)','Spools to buy','Filament cost ($)','(not used)','(not used)','Note'],[26,26,14,16,16,12,14,14,16,60])
P.row_dimensions[4].height=48
keys=list(PALETTE)
notes={'BRICK':'Bambu "Red" is brighter than brick. A brick / terracotta PETG from another maker will look better - or paint.',
 'BRASS':'Tiny amount (ticket grilles, clock pendulum). Yellow is the nearest; brass paint is better.',
 'BROWN':'Furniture, pine wainscot, ties, wood floors. The clock case (dark cherry) needs paint or stain colour.',
 'GREEN':'Pullman green windows, doors, cornice, canopy frame.','SLATE':'Slate roofs, rails, dark herringbone tiles.',
 'GRAY':'Foundation, roof frames, splices, ballast.','WHITE':'Mortar lines, white tiles, fixtures, light bars.','CREAM':'Stone trim, wall liners, ceilings, partitions, sign letters.','BLACK':'Black tiles, train board, safe, range, electronics tray.'}
F0=5
for i,k in enumerate(keys):
    r=F0+i
    P.cell(r,1,PALETTE[k][0]).font=N; P.cell(r,2,PALETTE[k][2]).font=N
    c=P.cell(r,3,24.99); c.font=BL; c.fill=YF; c.number_format='$#,##0.00'
    P.cell(r,4,"=SUMIF('Parts P1S'!$G:$G,$A%d,'Parts P1S'!$L:$L)"%r)
    P.cell(r,5,'=D%d'%r)
    P.cell(r,6,'=ROUNDUP(D%d/1000,0)'%r); P.cell(r,7,'=F%d*C%d'%(r,r))
    P.cell(r,8,'=ROUNDUP(E%d/1000,0)'%r); P.cell(r,9,'=H%d*C%d'%(r,r))
    P.cell(r,10,notes[k]).font=N
    for c in (4,5): P.cell(r,c).number_format='#,##0'
    for c in (7,9): P.cell(r,c).number_format='$#,##0.00'
    for c in (4,5,6,7,8,9): P.cell(r,c).font=N
F1=F0+len(keys)-1; r=F1+1
P.cell(r,1,'Total').font=B
for c in (4,5,6,7,8,9):
    x=P.cell(r,c,'=SUM(%s%d:%s%d)'%(L(c),F0,L(c),F1)); x.font=B; x.number_format='$#,##0.00' if c in (7,9) else '#,##0'
r+=2
P.cell(r,1,'Filament price: $24.99 per 1 kg spool is an ASSUMED placeholder - the Bambu store page would not show me a price today. Check us.store.bambulab.com/products/petg-hf and type the real price in column C.').font=I
r+=2; P.cell(r,1,'Weight assumptions').font=B; r+=1
P.cell(r,1,'PETG density (g/cm3)').font=N; c=P.cell(r,3,1.27); c.font=BL; DENS="Prices!$C$%d"%r; P.cell(r,10,'Typical PETG; Bambu PETG HF data sheet lists about 1.28.').font=N; r+=1
P.cell(r,1,'Waste allowance (purge, brims, failed prints)').font=N; c=P.cell(r,3,0.15); c.font=BL; c.fill=YF; c.number_format='0%'; WASTE="Prices!$C$%d"%r; P.cell(r,10,'My guess. Multi-colour parts purge on every colour change, so AMS prints waste more than this on small parts.').font=N; r+=2
P.cell(r,1,'Fill factor by group (printed plastic / solid volume of the STL)').font=B; r+=1
hdr(P,r,['Group','','Fill factor']); r+=1
groups=sorted({x['group'] for x in rows}); G0=r
ff={'Platform':0.5}
for g in groups:
    P.cell(r,1,g).font=N; c=P.cell(r,3,ff.get(g,1.0)); c.font=BL; c.number_format='0.00'
    if g in ff: c.fill=YF
    r+=1
G1=r-1; FILL="Prices!$A$%d:$C$%d"%(G0,G1)
P.cell(r+1,1,'Thin parts (walls, roofs, liners) print essentially solid = 1.00. The platform (4.4 mm thick brick slab) gets some infill: 0.50 is my guess for 15% infill with 3 walls. Bambu Studio shows the real grams after slicing - trust that over this sheet.').font=I
P.freeze_panes='A5'
# ---------------- Parts
def parts(title,printer):
    ws=wb.create_sheet(title)
    hdr(ws,1,['Group','3MF file','Part','Section','Body (part inside the 3MF)','AMS slot','Filament','Copies to print','Solid volume (cm3)','Fill factor','Grams each','Grams total','Filament cost ($)'],[13,44,30,8,36,7,16,8,11,8,10,10,11])
    ws.row_dimensions[1].height=36
    rr=[x for x in rows if x['printer']==printer]
    for i,x in enumerate(rr,2):
        v=[x['group'],x['file'],x['part'],int(x['section']),x['body'],int(x['slot']),x['colour'],int(x['qty']),float(x['volume_cm3'])]
        for c,val in enumerate(v,1): ws.cell(i,c,val).font=N
        ws.cell(i,10,'=VLOOKUP(A%d,%s,3,FALSE)'%(i,FILL)).font=N
        ws.cell(i,11,'=I%d*J%d*%s*(1+%s)'%(i,i,DENS,WASTE)).font=N
        ws.cell(i,12,'=K%d*H%d'%(i,i)).font=N
        ws.cell(i,13,'=L%d/1000*INDEX(Prices!$C$%d:$C$%d,MATCH(G%d,Prices!$A$%d:$A$%d,0))'%(i,F0,F1,i,F0,F1)).font=N
        ws.cell(i,11).number_format='#,##0.0'; ws.cell(i,12).number_format='#,##0.0'; ws.cell(i,13).number_format='$#,##0.00'; ws.cell(i,10).number_format='0.00'
    n=len(rr)+1; t=n+1
    ws.cell(t,1,'Total').font=B
    for c in (9,12,13):
        x=ws.cell(t,c,'=SUM(%s2:%s%d)'%(L(c),L(c),n)); x.font=B; x.number_format='$#,##0.00' if c==13 else '#,##0'
    ws.freeze_panes='C2'; ws.auto_filter.ref='A1:M%d'%n
    return t
tp=parts('Parts P1S','Bambu P1S'); tg=tp
# ---------------- Hardware
Hs=wb.create_sheet('Hardware')
hdr(Hs,1,['Item','For','Qty','Unit price ($)','Total ($)','Note'],[44,30,7,13,12,80]); 
hw=[('1 x 12 pine board (3/4 x 11-1/4 in actual), 5 ft','Wood base',1,20,'Base is 1325 x 271 mm (52.2 x 10.7 in), one piece. Or cut it from any 3/4 in plywood offcut.'),
('K&S 3/32 in square brass tube, 12 in length','Canopy posts',5,3,'21 posts cut 54 mm long (46 mm showing + 8 mm into the base). 5 posts per 12 in length = 4.2 lengths. Check your shop has 3/32 SQUARE; if you use round or another size change TUBE in Canopy/canopy.scad.'),
('ESP32 dev board','Lighting controller',1,10,'Goes under the layout in HO (no room in the express room).'),
('WS2812B LED strip, 5 V, 60 LED/m, 10 mm wide, 1 m','Lighting',1,10,'37 pixels (27 building + 10 canopy); 1 m = 60, leaves spares.'),
('5 V 4 A DC power supply','Lighting',1,12,'Per the wiring plan.'),
('74AHCT125 level shifter','Lighting data',1,2,''),
('330 ohm resistor','Lighting data',2,0.1,''),
('1000 uF 6.3 V+ capacitor','Lighting power',1,1,''),
('Inline fuse holder + 5 A fuse','Lighting power',1,5,''),
('22 AWG 2-conductor wire (m)','5 V bus under the layout',3,1,'Length is a guess.'),
('30 AWG wire-wrap wire, 3 colours (m each)','Pixel to pixel inside the buildings',5,0.5,'Thin wire - the wall chases are only 2.4 x 1.3 mm in HO.'),
('Clear acetate sheet (0.25 mm)','Window glazing',1,5,''),
('Thin CA glue','Assembly',1,7,''),
('Canopy glue / clear PVA','Glazing',1,7,''),
('HO flex track, 3 ft sections','Track in front of the platform',2,8,'Not printed in HO. Optional.'),
('1:87 figures (people)','Scenes',0,0,'Not chosen yet.')]
for i,(a,b,q,p,n) in enumerate(hw,2):
    Hs.cell(i,1,a).font=N; Hs.cell(i,2,b).font=N
    c=Hs.cell(i,3,q); c.font=BL; c=Hs.cell(i,4,p); c.font=BL; c.fill=YF; c.number_format='$#,##0.00'
    c=Hs.cell(i,5,'=C%d*D%d'%(i,i)); c.font=N; c.number_format='$#,##0.00'; Hs.cell(i,6,n).font=N
ht=len(hw)+2; Hs.cell(ht,1,'Total').font=B; c=Hs.cell(ht,5,'=SUM(E2:E%d)'%(ht-1)); c.font=B; c.number_format='$#,##0.00'
Hs.cell(ht+2,1,'All unit prices on this sheet are my rough estimates of typical US hobby prices, NOT quotes from a shop. Replace them with what you actually pay.').font=I
# ---------------- Summary
S=wb.create_sheet('Summary',0)
S['A1']='Janesville Milwaukee Road depot HO (1:87) - parts and cost summary'; S['A1'].font=T
S['A2']='Estimates only: weights come from STL volume x assumptions on the Prices sheet; nothing has been sliced or test-printed.'; S['A2'].font=I
hdr(S,4,['','All parts on Bambu P1S',''],[46,22,4])
data=[('Printable sections (3MF files)',len({x['file'] for x in rows if x['printer']=='Bambu P1S'}),0,'0'),
('Bodies (coloured parts inside those files)',"=COUNTA('Parts P1S'!E2:E%d)"%(tp-1),0,'0'),
('Estimated filament incl. waste (kg)',"='Parts P1S'!L%d/1000"%tp,0,'0.0'),
('Filament used, at price per kg ($)',"='Parts P1S'!M%d"%tp,0,'$#,##0'),
('Spools to buy (whole 1 kg spools per colour)','=Prices!F%d'%(F1+1),'=Prices!H%d'%(F1+1),'0'),
('Filament to buy ($)','=Prices!G%d'%(F1+1),'=Prices!I%d'%(F1+1),'$#,##0'),
('Hardware, base and electronics ($)','=Hardware!E%d'%ht,'=Hardware!E%d'%ht,'$#,##0'),
('TOTAL to buy ($)','=B10+B11','=C10+C11','$#,##0')]
for i,(a,b,c,f) in enumerate(data,5):
    S.cell(i,1,a).font=B if 'TOTAL' in a else N
    for j,v in ((2,b),):
        x=S.cell(i,j,v); x.font=B if 'TOTAL' in a else N; x.number_format=f
S['A14']='Everything fits the Bambu P1S; no large-format parts are needed in HO.'; S['A14'].font=I
S['A15']='Sheets: Prices (your inputs) - Parts P1S (every body, its 3MF file, AMS slot and filament) - Hardware.'; S['A15'].font=I
wb.save('/home/claude/ho/Parts and Pricing - Janesville Depot HO.xlsx')
