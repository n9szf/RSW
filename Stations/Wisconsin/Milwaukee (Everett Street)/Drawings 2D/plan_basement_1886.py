# Everett Street depot 1886 - BASEMENT PLAN.  Rev B (boiler-room columns moved onto the piling-plan piers).
# Source: blueprint drawing 4914 "C.M.&St.P. New Depot Milwaukee - Basement Plan, scale 1/8" (MPL 16-1160-4, scan #26), same series as
#   sheet 03.  Read off a low-resolution scan (~3.3 px/ft): positions +-1 ft.  Later uses from survey J-1140 (1930s-50s, scan #25) noted in grey.
# x from the EAST outside face (boiler / emigrants' end) westward to 319'-0"; y from the street (north) face 0 to the track face 60.
# The ground falls to the east: the boiler room and coal room open near grade at the east end (see sheet 03).
import ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
L, D, T = 319.0, 60.0, 1.6
W = []; AREAS = []; COLS = []; STAIRS = []; MISC = []
def w(x0, y0, x1, y1): W.append((x0, y0, x1, y1))
# outer walls
for a in [(0,0,L,0),(L,0,L,D),(L,D,0,D),(0,D,0,0)]: w(*a)
# --- east end: ash pit (outside), coal room, engine & boiler room ---
w(-13.5,25.6,-13.5,48.8); w(-13.5,25.6,0,25.6); w(-13.5,48.8,0,48.8)          # ash pit, projecting east
w(16.1,0,16.1,D)                                                            # coal room / boiler room wall
w(16.1,19.4,33.4,19.4); w(33.4,19.4,33.4,15.1); w(33.4,15.1,54.8,15.1); w(54.8,15.1,54.8,19.4); w(54.8,19.4,67.0,19.4)
w(33.4,0,33.4,15.1); w(54.8,0,54.8,15.1)                                    # engineers' / servants' rooms under the boiler room
w(67.0,0,67.0,D)
MISC.append(("chimney stack base", 65.5,53.0,71.5,60.0))                    # base of the tall stack (sheet 01/03)
STAIRS += [(16.6,1.5,20.8,19.0), (63.0,1.5,66.6,15.0)]
COLS += [(20.2,38.8),(37.7,38.8),(20.2,19.7),(37.7,19.7)]      # Rev B: on the piers of drawing 4413 (blueprint read 34/51 was wrong)
# --- service rooms: ice / closets, store rooms, stair ---
w(73.5,34.0,73.5,D); w(73.5,34.0,84.7,34.0); w(84.7,34.0,84.7,D); w(73.5,41.0,80.0,41.0); w(73.5,47.0,80.0,47.0)
w(84.7,37.0,100.0,37.0); w(100.0,0,100.0,D)
STAIRS += [(96.0,5.5,99.6,20.4)]
w(67.0,31.0,100.0,31.0)
# --- laundry and kitchen ---
w(101.0,31.7,152.6,31.7); w(126.5,31.7,126.5,D)                             # mangling room | wash room
COLS += [(114.5,39.2),(126.7,39.2),(139.6,39.2),(114.5,20.0),(139.6,20.0)]
w(126.5,0,126.5,25.8); w(126.5,25.8,152.6,25.8)                             # bake room
MISC.append(("bake oven", 127.2,15.0,139.6,25.8))
w(152.6,0,152.6,D)
# --- under the tower / hall ---
MISC.append(("clothes dryer", 154.5,38.1,169.2,52.5))
w(152.6,31.2,183.0,31.2); w(183.0,31.2,183.0,D)
w(152.6,24.7,184.6,24.7); w(184.6,0,184.6,24.7)
COLS += [(169.0,19.0)]
# --- smoking room, barber shop ---
STAIRS += [(190.0,45.0,197.0,57.4)]
w(201.0,46.5,201.0,D)
w(184.6,24.2,229.0,24.2); w(229.0,0,229.0,24.2)
STAIRS += [(226.0,1.2,229.0,16.7)]
COLS += [(195.0,43.0),(207.5,43.0),(195.0,29.6),(207.5,29.6),(228.6,41.2),(228.6,27.9),(247.2,43.2),(247.2,29.6),(247.2,16.2)]
# --- west end: large cement-floor rooms under the baggage room ---
w(265.3,13.0,265.3,D)
COLS += [(265.3,14.6),(283.5,40.9),(300.8,40.9),(283.5,22.4),(300.8,22.4)]
MISC.append(("baggage elevator pit", 272.0,13.5,277.0,23.1))
STAIRS += [(270.0,1.2,279.4,6.0)]
# --- areaways (light wells) and coal vault ---
AREAS += [(20.0,D,276.0,D+4.6), (91.0,D+4.6,121.4,87.0)]                  # track-side area; kitchen coal vault beyond it
AREAS += [(18.6,-4.0,67.0,0), (70.0,-4.0,98.0,0), (101.0,-4.5,135.0,0), (230.0,-5.0,264.7,0), (266.0,-4.0,282.0,0), (302.0,-4.0,318.0,0)]
ROOMS = [(-6.8,37,"ASH\nPIT"),(8,37,"COAL"),(41,38,"ENGINE &\nBOILER ROOM\ncement floor"),(25,8,"ENGINEERS'\nROOM"),(44,8,"SERVANTS'?\n(illegible)"),
         (79,50,"ICE /\nCLOSETS"),(92,48,"STORE\nROOM"),(83,16,"STORE ROOM"),(113,46,"MANGLING\nROOM"),(139,46,"WASH\nROOM"),
         (113,14,"KITCHEN"),(139,8,"BAKE ROOM"),(162,45,"CLOTHES\nDRYER"),(168,28,"cement floor"),(205,36,"SMOKING ROOM\nwood floor"),
         (207,12,"BARBER SHOP\ntile floor"),(247,52,"cement floor"),(292,32,"cement floor"),(106,76,"KITCHEN\nCOAL"),(150,62.3,"AREA")]
LATER = [(41,-11,"J-1140 (later): generator room, compressor plant, station master's room"),(160,-11,"J-1140: conductors' room, 77 lockers / track 5&6 store"),
         (285,-11,"J-1140: storage, supt. telegraph storage")]

doc = ezdxf.new("R2010", setup=True); doc.units = ezdxf.units.FT; msp = doc.modelspace()
for n, c in [("WALLS",1),("AREAS",8),("COLUMNS",5),("STAIRS",4),("EQUIP",6),("TEXT",7)]: doc.layers.add(n, color=c)
def rect(x0,y0,x1,y1,layer): msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True, dxfattribs={"layer":layer})
for x0,y0,x1,y1 in W: msp.add_line((x0,y0),(x1,y1),dxfattribs={"layer":"WALLS"})
for a in AREAS: rect(*a,"AREAS")
for x,y in COLS: rect(x-0.6,y-0.6,x+0.6,y+0.6,"COLUMNS")
for s in STAIRS: rect(*s,"STAIRS")
for n,*r in MISC: rect(*r,"EQUIP")
for x,y,t in ROOMS: msp.add_mtext(t.replace("\n","\\P"),dxfattribs={"layer":"TEXT","char_height":1.0}).set_location((x,y),attachment_point=5)
doc.saveas("Everett_1886_basement_plan.dxf")

fig, ax = plt.subplots(figsize=(17, 6.8))
for x0,y0,x1,y1 in W:
    outer = (x0,y0,x1,y1) in [(0,0,L,0),(L,0,L,D),(L,D,0,D),(0,D,0,0)]
    ax.plot([x0,x1],[y0,y1],color="#7a2318",lw=3.2 if outer else 1.6,solid_capstyle="butt")
for x0,y0,x1,y1 in AREAS: ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="#888",lw=0.7,ls="--"))
for x,y in COLS: ax.add_patch(Rectangle((x-0.6,y-0.6),1.2,1.2,fc="#333",ec="none"))
for x0,y0,x1,y1 in STAIRS:
    ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=False,ec="#2a4d8f",lw=0.7))
    long_y = (y1-y0) > (x1-x0); n = int(max(y1-y0, x1-x0)/1.0)
    for i in range(1, n):
        if long_y: yy = y0+i*(y1-y0)/n; ax.plot([x0,x1],[yy,yy],color="#2a4d8f",lw=0.3)
        else: xx = x0+i*(x1-x0)/n; ax.plot([xx,xx],[y0,y1],color="#2a4d8f",lw=0.3)
for n,x0,y0,x1,y1 in MISC: ax.add_patch(Rectangle((x0,y0),x1-x0,y1-y0,fill=n.startswith("chimney"),fc="#c9a89f",ec="#222",lw=0.9,hatch="///" if "oven" in n else None))
for x,y,t in ROOMS: ax.text(x,y,t,ha="center",va="center",fontsize=6.3)
for x,y,t in LATER: ax.text(x,y,t,ha="center",va="center",fontsize=5.8,color="#888",style="italic")
ax.text(68,57,"stack",fontsize=5.5,ha="center"); ax.text(274.5,18.3,"elev.\npit",fontsize=5.3,ha="center",va="center")
for x, t in [(0,"0 EAST"),(16.1,"16'"),(67,"67'"),(100,"100'"),(152.6,"152'-7\""),(184.6,"184'-7\""),(229,"229'"),(265.3,"265'-4\""),(L,"319'-0\" WEST")]:
    ax.plot([x,x],[-14,-16],color="k",lw=0.6); ax.text(x,-18.5,t,ha="center",fontsize=6.3)
ax.text(-15,D+3,"TRACK SIDE (south)",fontsize=8); ax.text(-15,-7.5,"STREET SIDE (north) - Everett Street",fontsize=8)
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - BASEMENT PLAN, from blueprint drawing 4914 (MPL, private reference) - Rev B",fontsize=10)
ax.text(-15,-23,"Read off a low-resolution scan, +-1 ft.  Floor about 9 ft below the street (-9.0 on the sections); at grade at the east end.  Grey italics: later uses from survey J-1140.  Rev A 11/22/2026",fontsize=6.5)
ax.set_aspect("equal"); ax.set_xlim(-18,L+4); ax.set_ylim(-26,90); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_basement_plan.pdf"); plt.savefig("Everett_1886_basement_plan.png",dpi=170); print("ok")
