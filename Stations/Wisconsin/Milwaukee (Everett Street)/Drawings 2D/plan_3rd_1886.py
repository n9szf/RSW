# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - Third Story Plan (MPL sheet 09), clean 2D drawing. Rev A.
# Units: feet. x from the EAST outside face, y from the street outside face (sheet top = track side).
# Sheet notes "THIRD STORY NOT FINISHED AT PRESENT" (east half). Scaled from sheet 09, +-1 ft.
import ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle, Polygon

L, D, T = 319.0, 60.0, 1.5
def ys(v): return D - v
X3 = (54.67, 262.67)              # third story runs between the end blocks' inner walls (= first-floor walls)
TOWER = (141.5, 174.2)            # tower walls at this level
TROOM = (143.4, 172.7, 39.0, 60)  # enclosed tower room (x0, x1, v0, v1), street side
PART = []
def wall(x0,v0,x1,v1):
    c=lambda v: min(max(v,T),D-T); PART.append((x0,ys(c(v0)),x1,ys(c(v1))))
wall(TOWER[0],0,TOWER[0],60); wall(TOWER[1],0,TOWER[1],23.5); wall(TOWER[1],32,TOWER[1],60)   # west side: ARCH opening
wall(TROOM[0],TROOM[2],TROOM[1],TROOM[2]); wall(TROOM[0],TROOM[2],TROOM[0],60); wall(TROOM[1],TROOM[2],TROOM[1],60)
wall(88.8,0,88.8,23.8); wall(88.8,33.3,88.8,60)           # east half: stair hall wall line
wall(54.67,12,62,12)                                       # small rooms by the east end-block wall (EST)
STAIRS = [(81.2,ys(2),88.8,ys(13)), (100,ys(23.4),115.2,ys(29.1)), (175,ys(1),193.7,ys(12.7))]
ELEV = (261.7,ys(40.5),268.2,ys(47.4))
SKY = [(203,ys(39),217.2,ys(21.5))]
GIRDERS = [71.4, 107.5, 222.1, 241.5]                      # truss / girder lines (dashed on the sheet)
ROOMS = [(98,35,"THIRD STORY - NOT FINISHED AT PRESENT\n(attic under the roof, dormers both sides)"),
         (98,16,"servants' rooms (pencil)"),(85,52,"STAIR"),(158,40,"HALL ROOM\n(glass doors E, arch W)"),
         (158,10,"TOWER"),(218,30,"STATIONERY DEPARTMENT"),(184,52,"STAIR"),(256,40,"SLOP\nSINK"),(265,17,"ELEV.")]

doc = ezdxf.new("R2010", setup=True); doc.units = ezdxf.units.FT
msp = doc.modelspace()
for n, c in [("WALLS",1),("PARTITIONS",3),("ROOF",8),("TEXT",7),("STAIRS",4)]: doc.layers.add(n, color=c)
def rect(x0,y0,x1,y1,layer): msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True, dxfattribs={"layer":layer})
rect(X3[0],0,X3[1],D,"WALLS"); rect(X3[0]+T,T,X3[1]-T,D-T,"WALLS")
rect(0,0,X3[0],D,"ROOF"); rect(X3[1],0,L,D,"ROOF")
for x0,y0,x1,y1 in PART: msp.add_line((x0,y0),(x1,y1),dxfattribs={"layer":"PARTITIONS"})
for s in STAIRS+[ELEV]: rect(*s,"STAIRS")
for x,y,t in ROOMS: msp.add_mtext(t.replace("\n","\\P"),dxfattribs={"layer":"TEXT","char_height":1.0}).set_location((x,y),attachment_point=5)
doc.saveas("Everett_1886_third_floor_plan.dxf")

fig, ax = plt.subplots(figsize=(17, 6.6))
# end-block roofs (hips, lantern) as seen from above
for x0,x1,lx in [(0,X3[0],17),(X3[1],L,302)]:
    ax.add_patch(Rectangle((x0,0),x1-x0,D,fill=True,fc="#e8e4dc",ec="#888",lw=0.8))
    ax.add_patch(Polygon([(lx-4,30),(lx,34),(lx+4,30),(lx,26)],fill=False,ec="#666",lw=0.8))
    ax.text((x0+x1)/2,4,"ROOF (end block)",ha="center",fontsize=6,color="#666")
ax.add_patch(Rectangle((X3[0],0),X3[1]-X3[0],D,fill=False,lw=2.2,ec="#7a2318"))
ax.add_patch(Rectangle((X3[0]+T,T),X3[1]-X3[0]-2*T,D-2*T,fill=False,lw=1,ec="#7a2318"))
for x0,y0,x1,y1 in PART: ax.plot([x0,x1],[y0,y1],color="#b08a55",lw=2)
for g in GIRDERS: ax.plot([g,g],[T,D-T],color="#999",ls="--",lw=0.7)
for x0,y0,x1,y1 in SKY: ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="k",ls="--",lw=0.8))
for x0,y0,x1,y1 in STAIRS:
    ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="#555",lw=0.8))
ax.add_patch(Rectangle(ELEV[:2],ELEV[2]-ELEV[0],ELEV[3]-ELEV[1],fill=False,ec="k",hatch="xx",lw=0.6))
ax.add_patch(Circle((158,9),3,fill=False,ec="k",ls="--",lw=0.8)); ax.text(158,4,"clock/bell shaft above (EST)",ha="center",fontsize=5)
for x,y,t in ROOMS: ax.text(x,y,t,ha="center",va="center",fontsize=6.3,weight="bold",color="#1a2b5c")
ax.text(0,D+3,"TRACK SIDE",fontsize=8); ax.text(0,-5,"STREET SIDE - Everett Street",fontsize=8)
ax.text(L,-5,"Third story: 54'-8\" to 262'-8\" (between the end blocks).  Partitions scaled from sheet 09, +-1 ft.  Dormers drawn on the elevations.  Rev A 11/22/2026",fontsize=5.8,ha="right")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - THIRD STORY PLAN, redrawn from MPL sheet 09 (private reference) - Rev A",fontsize=10)
ax.set_aspect("equal"); ax.set_xlim(-6,L+4); ax.set_ylim(-8,D+6); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_third_floor_plan.pdf"); plt.savefig("Everett_1886_third_floor_plan.png",dpi=120); print("ok")
