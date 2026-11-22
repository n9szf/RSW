# Everett Street depot 1886 - FOUNDATION (PILING) PLAN.  Rev A.
# Source: drawing 4413 (MPL 16-1160-15) "C.M.&St.P.Ry.Co. Piling plan for C.M.&St.P. depot at Milwaukee, Wis., scale 1/8\" = 1'",
#   traced by the Valuation Office Jan 1918 "from original drawing made by E. Townsend Mix & Co."  Low-resolution scan, ~3.1 px/ft: +-1 ft.
# x from the EAST outside face, y from the street face (north) 0 to the track face 60 - the sheet has the same layout (street at the bottom).
# The footing walls land on the plan walls at 54.67 / 71.83 / 89.0 / 141.7-177.3 (tower) / 262.67 and the piers on the first-floor columns
#   (19.3, 36.7 / 199.7, 224.0, 243.3 / 281, 299.3) - this confirms the east/west orientation of the whole set.
import math, ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle
L, D = 319.0, 60.0
TW = 3.2                                   # footing course width under walls (two staggered pile rows)
WALLS = []                                 # (x0, y0, x1, y1) centre-lines of pile-supported footings
def run(x0, y0, x1, y1): WALLS.append((x0, y0, x1, y1))
for a in [(0,0,L,0),(L,0,L,D),(L,D,0,D),(0,D,0,0)]: run(*a)
for x in [55.0, 71.9, 89.3, 262.4]: run(x, 0, x, D)
# tower: U-shaped mat - heavy legs on the street half, a lighter tie near the track wall
TOWER = [(138.0,-2.8,147.7,31.0), (169.9,-2.8,179.5,31.0), (138.0,-2.8,179.5,4.5)]   # legs + street-side mat (projects 2'-10" beyond the wall)
run(142.8, 31.0, 142.8, 57.0); run(174.7, 31.0, 174.7, 57.0); run(142.8, 54.0, 174.7, 54.0)
PIERS = [(20.2,19.7),(37.7,19.7),(20.2,38.8),(37.7,38.8),              # emigrants' room (east)
         (115.8,19.7),(115.8,39.8),                                     # dining room
         (159.3,22.3),(159.3,39.8),                                     # grand hall
         (199.2,17.5),(223.1,17.5),(241.6,17.5),(199.2,30.8),(223.1,30.8),(241.6,30.8),(199.2,44.1),(223.1,44.1),(241.6,44.1),  # waiting rooms
         (279.9,22.8),(298.0,22.8),(279.9,40.9),(298.0,40.9)]           # baggage room (west)
PILASTERS = [(0,20.0),(0,38.5),(199.6,0),(223.1,0),(199.6,D),(L,22.8),(L,40.9),(262.4,22.0),(262.4,40.0),(96.0,D),(96.0,0)]
ABCD = [(262.4,0),(L,0),(L,D),(262.4,D)]   # part A-B-C-D (baggage end) has its own footing section on the sheet

doc = ezdxf.new("R2010", setup=True); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, c in [("FOOTINGS",1),("PILES",8),("PIERS",5),("TEXT",7)]: doc.layers.add(n, color=c)
def rect(x0,y0,x1,y1,layer): msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True, dxfattribs={"layer":layer})
fig, ax = plt.subplots(figsize=(17, 6.8))
def piles_along(x0,y0,x1,y1, sp=2.33):
    Ln = math.hypot(x1-x0, y1-y0); n = max(1, int(Ln/sp)); ux, uy = (x1-x0)/Ln, (y1-y0)/Ln
    for i in range(n+1):
        off = 0.7 if i % 2 else -0.7
        px, py = x0+ux*i*Ln/n - uy*off, y0+uy*i*Ln/n + ux*off
        msp.add_circle((px,py), 0.35, dxfattribs={"layer":"PILES"}); ax.add_patch(Circle((px,py),0.35,fc="none",ec="#555",lw=0.35))
for x0,y0,x1,y1 in WALLS:
    if x0 == x1: r = (x0-TW/2, min(y0,y1)-TW/2, x0+TW/2, max(y0,y1)+TW/2)
    else: r = (min(x0,x1)-TW/2, y0-TW/2, max(x0,x1)+TW/2, y0+TW/2)
    rect(*r,"FOOTINGS"); ax.add_patch(Rectangle((r[0],r[1]),r[2]-r[0],r[3]-r[1],fc="#e8d8d3",ec="#7a2318",lw=0.8))
    piles_along(x0,y0,x1,y1)
for x0,y0,x1,y1 in TOWER:
    rect(x0,y0,x1,y1,"FOOTINGS"); ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fc="#e8d8d3",ec="#7a2318",lw=0.9))
    for i in range(int((x1-x0)/2.2)+1):
        for j in range(int((y1-y0)/2.2)+1):
            px, py = x0+0.8+i*2.2, y0+0.8+j*2.2
            if px < x1-0.4 and py < y1-0.4: msp.add_circle((px,py),0.35,dxfattribs={"layer":"PILES"}); ax.add_patch(Circle((px,py),0.35,fc="none",ec="#555",lw=0.35))
for x,y in PIERS:
    rect(x-2.4,y-2.4,x+2.4,y+2.4,"PIERS"); ax.add_patch(Rectangle((x-2.4,y-2.4),4.8,4.8,fc="#e8d8d3",ec="#7a2318",lw=0.8))
    ax.add_patch(Rectangle((x-1.1,y-1.1),2.2,2.2,fc="none",ec="#222",lw=0.8))
    for dx in (-1.7,0,1.7):
        for dy in (-1.7,0,1.7):
            if dx or dy: ax.add_patch(Circle((x+dx,y+dy),0.35,fc="none",ec="#555",lw=0.35)); msp.add_circle((x+dx,y+dy),0.35,dxfattribs={"layer":"PILES"})
for x,y in PILASTERS:
    ax.add_patch(Rectangle((x-2.6,y-2.6),5.2,5.2,fc="#e8d8d3",ec="#7a2318",lw=0.8)); rect(x-2.6,y-2.6,x+2.6,y+2.6,"FOOTINGS")
xs, ys = zip(*(ABCD+[ABCD[0]])); ax.plot(xs, ys, color="#2a4d8f", lw=0.8, ls="--")
for (x,y),t in zip(ABCD,"ABCD"): ax.text(x+(1.5 if x>263 else -2.5),y+(-3.5 if y==0 else 2),t,fontsize=8,color="#2a4d8f",weight="bold")
for x,y,t in [(28,29,"emigrants' room\n(over boiler room)"),(63.5,30,""),(116,30,"dining room"),(159.5,13,"TOWER\nfooting"),(221,24,"waiting rooms"),(290,32,"baggage room"),
              (290,-10,"part A-B-C-D: separate footing section on the sheet")]:
    if t: ax.text(x,y,t,ha="center",va="center",fontsize=6.5,color="#555",style="italic")
for x, t in [(0,"0 EAST"),(55,"55'"),(71.9,"71'-11\""),(89.3,"89'-4\""),(141.7,"141'-8\""),(177.3,"177'-4\""),(199.2,"199'"),(223.1,"223'"),(241.6,"241'-7\""),(262.4,"262'-5\""),(L,"319'-0\" WEST")]:
    ax.plot([x,x],[-14,-16],color="k",lw=0.6); ax.text(x,-18.5,t,ha="center",fontsize=6)
ax.text(-8,D+4,"TRACK SIDE (south)",fontsize=8); ax.text(-8,-7,"STREET SIDE (north)",fontsize=8)
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - FOUNDATION / PILING PLAN, from drawing 4413 (traced 1918 from Mix's original; MPL, private) - Rev A",fontsize=10)
ax.text(-8,-23,"Wood piles under every wall (two staggered rows, about 2'-4\" c.c. as noted) and 9-pile clusters under each pier; total noted on the sheet about 1,096 piles (as read).\n"
        "Piles drawn schematically - counts and spacing not exact.  Positions +-1 ft from a low-resolution scan.  Rev A 11/22/2026",fontsize=6.5,va="top")
ax.set_aspect("equal"); ax.set_xlim(-10,L+6); ax.set_ylim(-28,68); ax.axis("off")
doc.saveas("Everett_1886_foundation_plan.dxf")
plt.tight_layout(); plt.savefig("Everett_1886_foundation_plan.pdf"); plt.savefig("Everett_1886_foundation_plan.png",dpi=170); print("ok")
