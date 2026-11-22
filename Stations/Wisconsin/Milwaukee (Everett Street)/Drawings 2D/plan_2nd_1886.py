# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - Second Story Plan (MPL sheet 08), clean 2D drawing. Rev A.
# Units: feet. x from the EAST outside face, y from the street outside face (sheet top = track side).
# Main cross walls carry up from the first floor (Rev B); the rest scaled from sheet 08 (+-1 ft).
import ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle

L, D, T = 319.0, 60.0, 2.0
def ys(v): return D - v            # sheet 08 is read from the track face
CORR = (22.83, 33.33)              # hotel corridor / office corridor: 22'-10" + 10'-6" (sheet 08)
WALLS = [54.67, 71.83, 144.0, 175.0, 262.67]            # carried up from the first floor
PART = []
def wall(x0,v0,x1,v1):
    c=lambda v: min(max(v,T),D-T)
    PART.append((x0,ys(c(v0)),x1,ys(c(v1))))
# corridor walls (both sides), from the west room to the east room
wall(54.67,CORR[0],262.67,CORR[0]); wall(54.67,CORR[1],144,CORR[1]); wall(175,CORR[1],262.67,CORR[1])
# west end: bath rooms in the big west room; servants' bath / W.C. / closets strip
wall(37,0,37,20); wall(37,20,54.67,20)
wall(62.9,0,62.9,CORR[0]); wall(54.67,10,62.9,10); wall(54.67,15,62.9,15)
# hotel rooms, track side
for x in [82.0, 88.8, 102.9, 115.8, 129.5]: wall(x,0,x,CORR[0])
# hotel rooms / restaurant keeper, street side
for x in [82.0, 89.9, 102.9, 115.8]: wall(x,CORR[1],x,60)
wall(129.5,CORR[1],129.5,45); wall(115.8,45,143.5,45)            # closets + private bath of the restaurant keeper
# hall level: balcony round the well (track half), conductors' & trainmen's room (street half)
WELL = (148.2, 8.3, 170.2, 22.3)                                    # x0, v0, x1, v1 (sheet 08)
wall(144,CORR[1],175,CORR[1])
# east offices, track side
for x in [194.0, 211.0, 223.6, 251.7]: wall(x,0,x,CORR[0])
wall(175.9,20.5,194,20.5)                                            # stair well edge
# east offices, street side
for x in [187.5, 199.8, 223.6]: wall(x,CORR[1],x,60)
wall(243.4,CORR[1],243.4,48)
COLS = [(25,ys(18.5)),(37,ys(18.5)),(18.5,ys(41.5)),(37,ys(41.5)),
        (281,ys(19.5)),(299.3,ys(19.5)),(281,ys(39.2)),(299.3,ys(39.2))]   # wood columns in the end rooms
SKY = [(18.5,ys(36.5),33.5,ys(23.5)), (276,ys(37.5),292,ys(24.5))]           # 13 x 16 in clear (sheet 08)
STAIRS = [(82,ys(0),88.8,ys(16)), (84.5,ys(33.3),88.8,ys(43)), (49,ys(37),54,ys(54)),
          (175.9,ys(0),194,ys(20.5)), (263,ys(47),274,ys(58))]
ELEV = (263,ys(40),269,ys(47))
ROOMS = [(22,46,"EAST ROOM\n(skylight)"),(45.8,52,"BATH\nROOMS"),(58.8,52,"SERV.\nBATH\nW.C."),
         (67.4,48,"HELP"),(76.9,48,"HELP"),(85.4,48,"STAIR"),(95.8,48,"HOTEL"),(109.3,48,"HOTEL"),(122.6,48,"HOTEL"),(136.3,48,"HOTEL"),
         (100,32,"HOTEL CORRIDOR  10'-6\""),(63,14,"HOTEL"),(77,14,"HOTEL"),(96.4,14,"HOTEL"),(109.3,14,"HOTEL"),(129.6,10,"RESTAURANT\nKEEPER"),
         (159.5,55,"BALCONY"),(159.5,44,"OPEN TO\nGRAND HALL"),(159.5,13,"CONDUCTORS'\nAND TRAINMEN"),
         (185,50,"STAIR"),(202.5,48,"COND'RS\n& TRAINMEN"),(217.3,48,"TIME\nCARD\nROOM"),(237.6,48,"PRAIRIE DU CHIEN\nDIV. SUPT.\n(pencil, later)"),
         (257.2,48,"MEN'S\nTOILET\nUR / W.C."),(220,32,"CORRIDOR"),(187,13,"PULLMAN\nGEN'L BAGG.\nAGT."),(211.7,13,"NORTHERN DIV.\nSUPT. OFFICE"),
         (243,10,"LA CROSSE DIV.\nSUPT. OFFICE"),(291,46,"WEST ROOM\n(skylight)"),(266,19,"ELEV.")]

doc = ezdxf.new("R2010", setup=True); doc.units = ezdxf.units.FT
msp = doc.modelspace()
for n, c in [("WALLS",1),("PARTITIONS",3),("COLUMNS",5),("TEXT",7),("STAIRS",4),("DIMS",2)]: doc.layers.add(n, color=c)
def rect(x0,y0,x1,y1,layer): msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True, dxfattribs={"layer":layer})
rect(0,0,L,D,"WALLS"); rect(T,T,L-T,D-T,"WALLS")
for x in WALLS: rect(x-0.75,T,x+0.75,D-T,"WALLS")
for x0,y0,x1,y1 in PART: msp.add_line((x0,y0),(x1,y1),dxfattribs={"layer":"PARTITIONS"})
rect(WELL[0],ys(WELL[3]),WELL[2],ys(WELL[1]),"PARTITIONS")
for s in STAIRS+[ELEV]: rect(*s,"STAIRS")
for x,y in COLS: msp.add_circle((x,y),0.45,dxfattribs={"layer":"COLUMNS"})
for x,y,t in ROOMS: msp.add_mtext(t.replace("\n","\\P"),dxfattribs={"layer":"TEXT","char_height":1.0}).set_location((x,y),attachment_point=5)
msp.add_linear_dim(base=(-6,0),p1=(0,ys(0)),p2=(0,ys(CORR[0])),angle=90,dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
msp.add_linear_dim(base=(-6,0),p1=(0,ys(CORR[0])),p2=(0,ys(CORR[1])),angle=90,dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
msp.add_linear_dim(base=(-6,0),p1=(0,ys(CORR[1])),p2=(0,0),angle=90,dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
doc.saveas("Everett_1886_second_floor_plan.dxf")

fig, ax = plt.subplots(figsize=(17, 6.8))
ax.add_patch(Rectangle((0,0),L,D,fill=False,lw=2.2,ec="#7a2318")); ax.add_patch(Rectangle((T,T),L-2*T,D-2*T,fill=False,lw=1,ec="#7a2318"))
for x in WALLS: ax.add_patch(Rectangle((x-0.75,T),1.5,D-2*T,color="#7a2318"))
for x0,y0,x1,y1 in PART: ax.plot([x0,x1],[y0,y1],color="#b08a55",lw=2)
ax.add_patch(Rectangle((WELL[0],ys(WELL[3])),WELL[2]-WELL[0],WELL[3]-WELL[1],fill=False,ec="k",lw=1.6))
ax.text(159.5,ys(WELL[3])-1.2,"rail",ha="center",fontsize=5.5)
for x0,y0,x1,y1 in SKY: ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="k",ls="--",lw=0.8)); ax.plot([x0,x1],[y0,y1],"k--",lw=0.5); ax.plot([x0,x1],[y1,y0],"k--",lw=0.5)
for x0,y0,x1,y1 in STAIRS:
    ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="#555",lw=0.8))
    n=int(abs(y1-y0)/1.0)
    for i in range(1,n): ax.plot([x0,x1],[y0+i*(y1-y0)/n]*2,color="#999",lw=0.4)
ax.add_patch(Rectangle(ELEV[:2],ELEV[2]-ELEV[0],ELEV[3]-ELEV[1],fill=False,ec="k",hatch="xx",lw=0.6))
for x,y in COLS: ax.add_patch(Circle((x,y),0.45,fill=False,ec="k"))
for x,y,t in ROOMS: ax.text(x,y,t,ha="center",va="center",fontsize=6,weight="bold",color="#1a2b5c")
for a,b,t in [(0,CORR[0],"22'-10\""),(CORR[0],CORR[1],"10'-6\""),(CORR[1],60,"26'-8\"")]:
    ax.plot([-5,-5],[ys(a),ys(b)],color="k",lw=0.6); ax.plot([-6.5,-3.5],[ys(a)]*2,color="k",lw=0.6)
    ax.text(-6,(ys(a)+ys(b))/2,t,rotation=90,va="center",ha="right",fontsize=7)
ax.text(0,D+3,"TRACK SIDE",fontsize=8); ax.text(0,-5,"STREET SIDE - Everett Street",fontsize=8)
ax.text(L,-5,"Dark red: main walls carried up from the first floor (Rev B).  Tan: scaled from sheet 08, +-1 ft.  Written on the sheet: corridor 10'-6\", rooms 22'-10\" / 26'-8\", skylights 13 x 16 in clear.  Rev A 11/22/2026",fontsize=5.8,ha="right")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - SECOND STORY PLAN, redrawn from MPL sheet 08 (private reference) - Rev A",fontsize=10)
ax.set_aspect("equal"); ax.set_xlim(-12,L+4); ax.set_ylim(-8,D+6); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_second_floor_plan.pdf"); plt.savefig("Everett_1886_second_floor_plan.png",dpi=120); print("ok")
