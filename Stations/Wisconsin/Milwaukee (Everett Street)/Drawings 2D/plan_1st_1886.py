# ORIENTATION FIX 11/22: x=0 is the EAST face (emigrants' end, boiler below); x grows WESTWARD to the baggage end (319 ft).
# Everett Street depot 1886 - First Story Plan (MPL sheet 07), clean 2D drawing. Rev B.
# Units: feet. x from the EAST outside face, y from the street (sidewalk) outside face.
# Rev B: interior walls and columns placed from the written dimensions on sheet 07.
import ezdxf, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle

L, D, T = 319.0, 60.0, 2.0
def fi(a, b=0): return a + b / 12
def ys(v): return D - v                     # sheet dims are measured from the track face
CHAIN = [(17,6),(20,8),(15,6),(36,4),(4,1),(19,9),(5,0),(19,9),(3,1),(35,8),(2,1),(18,0),(4,6),(18,0),(3,1),(40,8),(16,0),(22,0),(17,4)]
TICKS = [0.0]
for a, b in CHAIN: TICKS.append(TICKS[-1] + fi(a, b))
TOWER = (TICKS[9], TICKS[10])

# Interior row along the building, W to E, as written (outside face -> wall / column centres):
#  19'-4 col | 17'-4 col | 18'-0 wall | 17'-2 wall | [service strip, no dim: 17'-2 by closure] |
#  27'-4 col | 27'-8 wall | 31'-0 GRAND HALL wall | 24'-8 col | 24'-4 col | 19'-4 col | 19'-4 wall |
#  18'-4 col | 18'-4 col | 19'-8 outside face.   East half run from the east face; closes on 319'-0".
ROW_W = [(19,4,"c"),(17,4,"c"),(18,0,"w"),(17,2,"w"),(17,2,"w*"),(27,4,"c"),(27,8,"w"),(31,0,"w")]
ROW_E = [(19,8,"c"),(18,4,"c"),(18,4,"w"),(19,4,"c"),(19,4,"c"),(24,4,"c"),(24,8,"w")]   # from east face, going west
XS, KIND, LAB = [0.0], [], []
for a, b, k in ROW_W: XS.append(XS[-1] + fi(a, b)); KIND.append(k); LAB.append(f"{a}'-{b}\"")
xe = [L]
for a, b, k in ROW_E: xe.append(xe[-1] - fi(a, b))
assert abs(xe[-1] - XS[-1]) < 0.01, (xe[-1], XS[-1])   # the two runs meet at the hall's east wall
EAST = list(reversed(xe[:-1]))                            # 199.67 ... 319
X_HALL_E = XS[-1]
W_EMIG, W_DM, W_SVC, X_DINC, W_DIN_E = XS[3], XS[4], XS[5], XS[6], XS[7]
X_COL1, X_COL2, X_COL3, W_BAG = EAST[0], EAST[1], EAST[2], EAST[3]
X_BC1, X_BC2 = EAST[4], EAST[5]

WALLS = [W_EMIG, W_DM, W_SVC, W_DIN_E, X_HALL_E]                  # full-depth cross walls
PART = [  # (x0, y0, x1, y1), y from the street face
  (W_EMIG, ys(20), W_DM, ys(20)), (W_EMIG, ys(49.5), W_DM, ys(49.5)),     # depot master / passage / bath rooms
  (W_DM, ys(14), W_SVC, ys(14)), (W_DM, ys(40), W_SVC, ys(40)), (80, ys(40), 80, ys(58)),   # pantry / carving / china / private entrance
  (W_SVC, ys(20), 141, ys(20)),                                          # lunch-room screen (low, glazed)
  (X_HALL_E, ys(20.5), 194, ys(20.5)),                                   # stair & news
  (194, ys(30), W_BAG - 5, ys(30)),                                      # gentlemen's / ladies'
  (W_BAG, ys(2), W_BAG, ys(26)), (W_BAG, ys(35), W_BAG, ys(58)),         # waiting rooms / baggage (opening between)
  (252, ys(35.3), W_BAG, ys(35.3)), (252, ys(35.3), 252, ys(58)),        # ladies' toilet
  (W_BAG, ys(20.5), 274.3, ys(20.5)), (274.3, ys(20.5), 274.3, ys(37.3)), (W_BAG, ys(37.3), 274.3, ys(37.3))]  # selecting baggage
TICKET = (179.5, ys(39), 194.3, ys(23.5))
COLS = [(XS[1], ys(20.33)), (XS[2], ys(20.33)), (XS[1], ys(39.67)), (XS[2], ys(39.67)),           # emigrants
        (X_DINC, ys(39.17)),                                                                     # dining
        (X_COL1, ys(16.33)), (X_COL2, ys(16.33)), (X_COL3, ys(16.33)),                          # gentlemen's
        (X_COL1, ys(43.5)), (X_COL2, ys(43.5)), (X_COL3, ys(43.5)),                             # ladies'
        (X_BC1, ys(20.33)), (X_BC2, ys(20.33)), (X_BC1, ys(39.67)), (X_BC2, ys(39.67))]          # baggage
ROOMS = [(27,30,"EMIGRANTS'\nWAITING ROOM\n(tile floor)"),(63,50,"DEPOT\nMASTER"),(63,25,"PASSAGE"),(63,5,"BATH\nROOMS"),
         (80.5,53,"PANTRY\nFRUIT"),(80.5,33,"CARVING"),(76,10,"CHINA"),(85,10,"PRIV.\nENTR."),
         (115,50,"LUNCH ROOM\n(counter)"),(116.5,22,"DINING ROOM"),(159.5,30,"GRAND HALL\n(open above)"),
         (159.5,56,"OPEN\nVESTIBULE"),(159.5,4,"MAIN\nVESTIBULE"),(185,50,"STAIR\nNEWS & CIGARS"),(187,23,"TICKETS"),
         (225,48,"GENTLEMEN'S WAITING ROOM"),(225,10,"LADIES' WAITING ROOM"),(257.5,12,"LADIES'\nTOILET"),
         (268.7,31,"SELECT.\nBAGG."),(298,30,"BAGGAGE")]
DEPTH = {"emigrants / baggage": ["20'-4\"","19'-4\"","20'-4\""], "dining": ["20'-0\"","19'-2\"","20'-10\""],
         "waiting rooms": ["16'-4\"","13'-8\"","13'-6\"","16'-6\""]}

# ---------- DXF ----------
doc = ezdxf.new("R2010", setup=True); doc.units = ezdxf.units.FT
msp = doc.modelspace()
for n, c in [("WALLS",1),("PARTITIONS",3),("COLUMNS",5),("TEXT",7),("DIMS",2)]: doc.layers.add(n, color=c)
def rect(x0,y0,x1,y1,layer): msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True, dxfattribs={"layer":layer})
rect(0,0,L,D,"WALLS"); rect(T,T,L-T,D-T,"WALLS")
for x in WALLS: rect(x-0.75,T,x+0.75,D-T,"WALLS")
for x0,y0,x1,y1 in PART: msp.add_line((x0,y0),(x1,y1),dxfattribs={"layer":"PARTITIONS"})
rect(*TICKET,"PARTITIONS")
for x,y in COLS: msp.add_circle((x,y),1.0,dxfattribs={"layer":"COLUMNS"})
for x,y,t in ROOMS: msp.add_mtext(t.replace("\n","\\P"),dxfattribs={"layer":"TEXT","char_height":1.2}).set_location((x,y),attachment_point=5)
for a,b in zip(TICKS[:-1],TICKS[1:]):
    msp.add_linear_dim(base=(0,-8),p1=(a,0),p2=(b,0),dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
row = XS + EAST
for a,b in zip(row[:-1],row[1:]):
    msp.add_linear_dim(base=(0,D+6),p1=(a,D),p2=(b,D),dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
msp.add_linear_dim(base=(0,-16),p1=(0,0),p2=(L,0),dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
msp.add_linear_dim(base=(-8,0),p1=(0,0),p2=(0,D),angle=90,dimstyle="EZDXF",dxfattribs={"layer":"DIMS"}).render()
doc.saveas("Everett_1886_first_floor_plan.dxf")

# ---------- PDF ----------
fig, ax = plt.subplots(figsize=(17, 7.2))
ax.add_patch(Rectangle((0,0),L,D,fill=False,lw=2.2,ec="#7a2318"))
ax.add_patch(Rectangle((T,T),L-2*T,D-2*T,fill=False,lw=1.0,ec="#7a2318"))
ax.add_patch(Rectangle((TOWER[0],-3),TOWER[1]-TOWER[0],3,fill=False,lw=1.6,ec="#7a2318",hatch="//"))
for x in WALLS: ax.add_patch(Rectangle((x-0.75,T),1.5,D-2*T,color="#7a2318"))
for x0,y0,x1,y1 in PART:
    low = (y0 == y1 == ys(20) and x0 == W_SVC)
    ax.plot([x0,x1],[y0,y1],color="#b08a55",lw=1.2 if low else 2.2,ls="--" if low else "-")
ax.add_patch(Rectangle(TICKET[:2],TICKET[2]-TICKET[0],TICKET[3]-TICKET[1],fill=False,ec="#b08a55",lw=2.2))
ax.add_patch(Rectangle((148.5,8),22,23,fill=False,ec="k",ls=":",lw=1)); ax.text(159.5,9,"well to 2nd floor (EST)",ha="center",fontsize=6)
for x,y in COLS: ax.add_patch(Circle((x,y),1.0,fill=False,ec="k",lw=1.2))
for x,y,t in ROOMS: ax.text(x,y,t,ha="center",va="center",fontsize=6.8,weight="bold",color="#1a2b5c")
# street chain (as written)
for a in TICKS: ax.plot([a,a],[-4,-9.5],color="k",lw=0.6)
ax.plot([0,L],[-8,-8],color="k",lw=0.6)
for (a,b),(fa,fb) in zip(zip(TICKS[:-1],TICKS[1:]),CHAIN):
    ax.text((a+b)/2,-7.4,f"{fa}'-{fb}\"",ha="center",fontsize=6,rotation=0 if b-a>9 else 90,va="bottom")
ax.plot([0,L],[-15,-15],color="k",lw=0.6); ax.text(L/2,-14.4,"319'-0\"",ha="center",fontsize=8,weight="bold")
# interior row (as written; the 17'-2" marked * is by closure)
labs = LAB + [f"{a}'-{b}\"" for a,b,k in reversed(ROW_E)]
for x in row: ax.plot([x,x],[D+2,D+7.5],color="k",lw=0.6)
ax.plot([0,L],[D+6,D+6],color="k",lw=0.6)
for (a,b),t in zip(zip(row[:-1],row[1:]),labs):
    ax.text((a+b)/2,D+6.5,t+("*" if t=="17'-2\"" and a>70 else ""),ha="center",fontsize=6,va="bottom")
ax.plot([-6,-6],[0,D],color="k",lw=0.6); ax.text(-7,D/2,"60'-0\"",rotation=90,va="center",ha="right",fontsize=8,weight="bold")
# depth dims at the emigrants' room
y=0
for t in reversed(DEPTH["emigrants / baggage"]):
    pass
ax.text(0,D+11,"TRACK SIDE (train shed)",fontsize=8); ax.text(0,-21,"STREET SIDE - Everett Street sidewalk",fontsize=8)
ax.text(L,D+11,"Depths on sheet 07 (track face -> street face): emigrants & baggage 20'-4 / 19'-4 / 20'-4;  dining 20'-0 / 19'-2 / 20'-10;  waiting rooms 16'-4 / 13'-8 / 13'-6 / 16'-6",fontsize=6,ha="right")
ax.text(L,-21,"Dark red and black: from sheet 07 dimensions.  Tan: partitions scaled from the sheet.  * by closure.  Rev B 11/22/2026",fontsize=6,ha="right")
ax.set_title("Milwaukee Union Depot (Everett St), 1886 - FIRST STORY PLAN, redrawn from MPL sheet 07 (private reference) - Rev B",fontsize=10)
ax.set_aspect("equal"); ax.set_xlim(-12,L+4); ax.set_ylim(-24,D+14); ax.axis("off")
plt.tight_layout(); plt.savefig("Everett_1886_first_floor_plan.pdf"); plt.savefig("Everett_1886_first_floor_plan.png",dpi=120)
print("walls", [round(x,2) for x in WALLS], "east", [round(x,2) for x in EAST], "hall centre", round((W_DIN_E+X_HALL_E)/2,2), "tower centre", round(sum(TOWER)/2,2))
