import csv, sys
sys.path.insert(0,'/home/claude/scad')
from make_3mf import PALETTE
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter as L
rows=list(csv.DictReader(open('/home/claude/mf_manifest/manifest_all.csv')))
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
P['A1']='Janesville depot - prices and assumptions'; P['A1'].font=T
P['A2']='Blue cells are yours to change - every other sheet recalculates. Yellow = guesses I could not confirm; please replace.'; P['A2'].font=I
hdr(P,4,['Filament (model colour)','Closest Bambu PETG HF colour','Price per 1 kg spool ($)','Grams - all parts on Bambu P1S','Grams - all parts on Large Format','Spools to buy (P1S plan)','Filament cost (P1S plan) ($)','Spools to buy (Large Format plan)','Filament cost (Large Format plan) ($)','Note'],[26,26,14,16,16,12,14,14,16,60])
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
    P.cell(r,5,"=SUMIF('Parts Large Format'!$G:$G,$A%d,'Parts Large Format'!$L:$L)"%r)
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
ff={'Platform':0.35,'Track':0.5}
for g in groups:
    P.cell(r,1,g).font=N; c=P.cell(r,3,ff.get(g,1.0)); c.font=BL; c.number_format='0.00'
    if g in ff: c.fill=YF
    r+=1
G1=r-1; FILL="Prices!$A$%d:$C$%d"%(G0,G1)
P.cell(r+1,1,'Thin parts (walls, roofs, liners) print essentially solid = 1.00. The platform (6 mm+ thick brick slab) and track ballast are thick and get infill: 0.35 and 0.50 are my guesses for 15% infill with 3 walls. Bambu Studio shows the real grams after slicing - trust that over this sheet.').font=I
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
tp=parts('Parts P1S','Bambu P1S'); tg=parts('Parts Large Format','Large Format')
# ---------------- Hardware
Hs=wb.create_sheet('Hardware')
hdr(Hs,1,['Item','For','Qty','Unit price ($)','Total ($)','Note'],[44,30,7,13,12,80]); 
hw=[('3/4 in (18 mm) plywood, 4 x 8 ft sheet','Wood base',2,60,'Base is 3904 x 743 mm in two pieces (2404 + 1501). One sheet yields only the west piece, so two sheets - or have the store rip one sheet plus an offcut.'),
('K&S 9/32 in square brass tube, 36 in length','Canopy posts',4,12,'21 posts cut 150 mm long (138 mm showing + 12 mm into the base). 6 posts per 36 in length = 3.5 lengths; or eleven 12 in lengths (2 posts each). Check your shop has 9/32 SQUARE; for another size change TUBE in Canopy/canopy.scad.'),
('ESP32 dev board','Lighting controller',1,10,'Sits in the electronics tray in the express room.'),
('WS2812B LED strip, 5 V, 60 LED/m, 10 mm wide, 1 m','Lighting',1,10,'38 pixels needed (27 building + 10 canopy + 1 chimney); 1 m = 60, leaves spares.'),
('5 V 4 A DC power supply','Lighting',1,12,'Per the wiring plan.'),
('74AHCT125 level shifter','Lighting data',1,2,'One chip drives both data chains.'),
('330 ohm resistor','Lighting data',2,0.1,''),
('1000 uF 6.3 V+ capacitor','Lighting power',1,1,''),
('Inline fuse holder + 5 A fuse','Lighting power',1,5,''),
('18 AWG 2-conductor wire (m)','5 V bus under the layout',5,1.5,'Length is a guess - measure your layout.'),
('22 AWG 3-conductor wire (m)','Pixel to pixel inside the buildings',10,1,'Length is a guess.'),
('JST-SM 3-pin connector pairs','Roof / canopy / chimney plugs',6,1,''),
('Clear acetate or 0.5 mm PETG sheet','Window glazing',2,5,''),
('Thin CA glue','Assembly',2,7,''),
('Canopy glue / clear PVA','Glazing',1,7,''),
('3 mm rod (m)','Foundation pins',1,4,'Or use filament stubs.'),
('M8 / 5/16 in bolts, washers, nuts','Joining the base pieces / legs',4,1.5,'Optional - depends how you mount the base.'),
('1:29 figures (people)','Scenes',0,0,'Not chosen yet - free STLs or bought figures.')]
for i,(a,b,q,p,n) in enumerate(hw,2):
    Hs.cell(i,1,a).font=N; Hs.cell(i,2,b).font=N
    c=Hs.cell(i,3,q); c.font=BL; c=Hs.cell(i,4,p); c.font=BL; c.fill=YF; c.number_format='$#,##0.00'
    c=Hs.cell(i,5,'=C%d*D%d'%(i,i)); c.font=N; c.number_format='$#,##0.00'; Hs.cell(i,6,n).font=N
ht=len(hw)+2; Hs.cell(ht,1,'Total').font=B; c=Hs.cell(ht,5,'=SUM(E2:E%d)'%(ht-1)); c.font=B; c.number_format='$#,##0.00'
Hs.cell(ht+2,1,'All unit prices on this sheet are my rough estimates of typical US hobby prices, NOT quotes from a shop. Replace them with what you actually pay.').font=I
# ---------------- Summary
S=wb.create_sheet('Summary',0)
S['A1']='Janesville Milwaukee Road depot (1:29) - parts and cost summary'; S['A1'].font=T
S['A2']='Estimates only: weights come from STL volume x assumptions on the Prices sheet; nothing has been sliced or test-printed.'; S['A2'].font=I
hdr(S,4,['','All parts on Bambu P1S','All parts on Large Format'],[46,22,24])
data=[('Printable sections (3MF files)',len({x['file'] for x in rows if x['printer']=='Bambu P1S'}),len({x['file'] for x in rows if x['printer']=='Large Format'}),'0'),
('Bodies (coloured parts inside those files)',"=COUNTA('Parts P1S'!E2:E%d)"%(tp-1),"=COUNTA('Parts Large Format'!E2:E%d)"%(tg-1),'0'),
('Estimated filament incl. waste (kg)',"='Parts P1S'!L%d/1000"%tp,"='Parts Large Format'!L%d/1000"%tg,'0.0'),
('Filament used, at price per kg ($)',"='Parts P1S'!M%d"%tp,"='Parts Large Format'!M%d"%tg,'$#,##0'),
('Spools to buy (whole 1 kg spools per colour)','=Prices!F%d'%(F1+1),'=Prices!H%d'%(F1+1),'0'),
('Filament to buy ($)','=Prices!G%d'%(F1+1),'=Prices!I%d'%(F1+1),'$#,##0'),
('Hardware, base and electronics ($)','=Hardware!E%d'%ht,'=Hardware!E%d'%ht,'$#,##0'),
('TOTAL to buy ($)','=B10+B11','=C10+C11','$#,##0')]
for i,(a,b,c,f) in enumerate(data,5):
    S.cell(i,1,a).font=B if 'TOTAL' in a else N
    for j,v in ((2,b),(3,c)):
        x=S.cell(i,j,v); x.font=B if 'TOTAL' in a else N; x.number_format=f
S['A14']='You will most likely mix printers (big panels on the large printer, multi-colour and small parts on the P1S), so the real figure sits between the two columns.'; S['A14'].font=I
S['A15']='Sheets: Prices (your inputs) - Parts P1S / Parts Large Format (every body, its 3MF file, AMS slot and filament) - Hardware.'; S['A15'].font=I
wb.save('/home/claude/bom/Parts and Pricing - Janesville Depot.xlsx')
