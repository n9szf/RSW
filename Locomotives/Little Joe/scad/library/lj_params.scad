// =====================================================================
//  lj_params.scad  -  Milwaukee Road "Little Joe" (EF-4 / EP-4) electric
//  Every setting for the model lives here.  Rib Side Works, Locomotives.
//
//  SOURCES (v2, 20 Oct 2026):
//   - DWG: Milwaukee Road diagram "Electric Freight Locomotive - Class EF-4,
//     2-D+D-2, 8 GE 750 motors, 3000 volt", 4 Aug 1950 (via pcmaf.org, found on
//     americandreamsonwheels.ch - Tom 10/20). Its figures are marked DWG; shapes
//     SCALED off the side view are marked SCALED (about +/- 4 in - small picture).
//   - Wikipedia "Little Joe (electric locomotive)": 88 ft 10 in long,
//     10 ft 7 in wide, 14 ft 5 in high, 2-D+D-2, GE 750 motors (8),
//     Milwaukee E20-E21 (EP-4) and E70-E79 (EF-4).
//   - American-Rails "Little Joes": 77 ft 10 in total wheelbase,
//     20 ft 7 in rigid (driving) wheelbase, 47 1/4 in drivers.
//   - MTH HO model (Trains review): matches Model Railroader Aug 1956 drawings.
//  Marks:  SRC = from a source above.  ESTIMATE = a guess until a drawing
//  or photo is checked (TDQ list).
//
//  PROTOTYPE sizes are in inches and go through p() to model mm.
//  MODEL construction sizes (walls, screws, fits) are real mm, per scale.
// =====================================================================

// ---------------- scale ----------------
// G 1:29 (45 mm track), O 1:48 (32 mm), HO 1:87.1 (16.5 mm).
SC = is_undef(SCALE_SEL) ? "G" : SCALE_SEL;
RG_SCALE = SC == "HO" ? "O" : SC;      // shared truck library knows G and O; HO uses bought wheels
include <../../../../Trucks/library/rsw_running_gear.scad>

// name, ratio, gauge, wall, frame plate, body screw [pilot, clear, head],
//   boss [size, height], pivot screw [clear, nut AF, name], truck screw [pilot, clear, head, name],
//   body section count, joint sleeve, frame lap, fit
SCALES = [
  ["G",  29,   45.0,  2.4, 5.0, [2.2, 2.8, 5.0], [8, 12], [3.4, 5.5, "M3"],   [1.6, 2.2, 4.0, "M2"],   4, 10, 20, 0.25],
  ["O",  48,   31.75, 1.8, 4.0, [1.6, 2.4, 4.0], [6,  9], [2.9, 5.0, "M2.5"], [1.6, 2.2, 4.0, "M2"],   3,  8, 14, 0.20],
  ["HO", 87.1, 16.5,  1.2, 3.0, [1.1, 1.6, 2.8], [4,  6], [2.4, 4.0, "M2"],   [1.1, 1.5, 2.8, "M1.4"], 2,  5, 10, 0.15]
];
S = [for (r = SCALES) if (r[0] == SC) r][0];
assert(!is_undef(S), str("SCALE_SEL must be G, O or HO - got ", SC));
RATIO = S[1]; GAUGE = S[2]; WALL = S[3]; FRAME_T = S[4];
BODY_SCREW = S[5]; BOSS = S[6]; PIVOT = S[7]; TRUCK_SCREW = S[8];
NSEC = S[9]; SLEEVE = S[10]; LAP = S[11]; FIT = S[12];
SCREW_BODY_NAME = SC == "G" ? "M2.5" : SC == "O" ? "M2" : "M1.4";

function p(i) = i * 25.4 / RATIO;      // prototype inches -> model mm
function ft(f, i = 0) = p(f * 12 + i);

// ---------------- which loco ----------------
// number, class, steam generator (EP-4 B end has no controls or windshield), note
LOCOS = [
  ["E20", "EP-4", true,  "passenger, steam generator at the B end; reclassed EF-4 in 1956"],
  ["E21", "EP-4", true,  "passenger, steam generator at the B end; reclassed EF-4 in 1956"],
  ["E70", "EF-4", false, "freight; preserved at Deer Lodge, Montana (Olympian Hiawatha paint)"],
  ["E71", "EF-4", false, "freight"], ["E72", "EF-4", false, "freight"], ["E73", "EF-4", false, "freight"],
  ["E74", "EF-4", false, "freight"], ["E75", "EF-4", false, "freight"], ["E76", "EF-4", false, "freight"],
  ["E77", "EF-4", false, "freight"],
  ["E78", "EF-4", false, "freight; rebuilt 1966 with EMD cabs - modelled as built (TDQ)"],
  ["E79", "EF-4", false, "freight"]
];
LOCO = is_undef(LOCO_SEL) ? "E70" : LOCO_SEL;
LOCO_ROW = [for (r = LOCOS) if (r[0] == LOCO) r][0];
assert(!is_undef(LOCO_ROW), str("LOCO_SEL must be E20, E21 or E70-E79 - got ", LOCO));
ROAD_NO = LOCO; CLASS = LOCO_ROW[1]; STEAM_GEN = LOCO_ROW[2];

// ---------------- paint (preview and Blender only) ----------------
// ESTIMATE until checked against colour photos (TDQ).
C_ORANGE = "#E2711D";  C_MAROON = "#5C1A16";  C_BLACK = "#1F1F1F";   // same as the ES-2
PAINT = is_undef(PAINT_SEL) ? "OLYMPIAN" : PAINT_SEL;
// OLYMPIAN: orange lower, maroon upper band, black roof (ESTIMATE)
// FREIGHT (1960s-70s, Flickr colour photos of E72-E74 1972-73): orange body, BLACK upper band from about the
//   bottom of the louvres up over the nose top and cab, black roof
C_LOW  = C_ORANGE;
C_HIGH = PAINT == "FREIGHT" ? C_BLACK : C_MAROON;
C_ROOF = C_BLACK;
C_LETTER = PAINT == "FREIGHT" ? "#1F1F1F" : "#EDE3C2";
C_FRAME = "#202020"; C_TRUCK = "#1E1E1E"; C_GLASS = "#9FB4BF"; C_LENS = "#FFFFFF"; C_RAIL = "#F4F4F0";

// ---------------- prototype dimensions (inches) ----------------
LOA_IN     = 88 * 12 + 10;   // DWG length inside knuckles
BODY_L_IN  = 904;            // MPL carbody, nose tip to nose tip (75 ft 4 in; 81 in from each tip to the coupler face)
DECK_HL_IN = 522;            // SCALED the deck (frame) runs out to here each end, past the nose
BODY_W_IN  = 120;            // MPL 10 ft 0 in over the body (10 ft 7 in is over the handrails)
ROOF_IN    = 14 * 12 + 5;    // DWG height over cab (top of the cab roofs)
MID_ROOF_IN = 166;           // SCALED roof between the cabs, a little lower than the cabs
EAVE_IN    = 150;            // where the body and roof prints split (above the louvres and nose top)
ROOF_R_IN  = 22;             // ESTIMATE roof corner radius (side view only on the drawing)
DECK_IN    = 61;             // SCALED top of the deck / bottom of the carbody above rail
PAINT_LINE_IN = PAINT == "FREIGHT" ? 136 : 118;  // colour split height (FREIGHT from photos, OLYMPIAN ESTIMATE)
// v6 (24 Oct 2026): from the GE / Milwaukee Public Library drawings Tom uploaded (side elevation and end view,
// cab and nose plan, clearance diagram) - MPL. Scaled off the elevation at 2.34 px/in (guide axles 6-10 apart):
NOSE_L_IN    = 83;           // MPL nose length, windshield to tip
// v8 (24 Oct 2026, Tom's reference model 'Body.stl'): the nose is BLUNT - nearly full width, with corners rounded in plan
// over the last 32 in (a squarish curve, not an ellipse); the nose top drops from 149 in at the windshield to 143 in at the
// front and rounds over onto the sides and the front (big round at the tip, dying out toward the windshield);
// a round headlight hood stands out of the rounded top-front.
// v9 (24 Oct 2026, Tom: 'lets try FreeCAD'): the nose is lofted in FreeCAD (library/nose/lj_nose_freecad.py reads the
// numbers below) and imported as STL shells. FC_NOSE = false goes back to the OpenSCAD-only nose.
FC_NOSE = true;
// With FC_NOSE the nose is its OWN PRINT ('nose', two per loco): FreeCAD makes the finished shell (hood, corner boxes,
// headlight, nose-door groove, number boards, two screw bosses); the end body sections stop at the cab front with a sleeve
// the nose glues over, and the nose screws to the frame like the body.
NOSE_BOSS_D_IN = 44;         // nose screw bosses, inches back from the tip (one each side)
NOSE_PLAN_D_IN = 32;         // how far back from the tip the plan rounding reaches
NOSE_PLAN_N = 2.6;           // plan shape: 2 = ellipse, higher = squarer (reference model fits about 2.6)
NOSE_TOP_IN  = 149;          // nose top at the windshield
NOSE_TOP_FRONT_IN = 142;     // nose top at the front (it drops toward the front)
NOSE_TOP_BACK_IN = NOSE_TOP_IN;
NOSE_SHOULDER_R_IN = [26, 1]; // the nose top rounds over onto the sides and front: 26 in at the tip (reference model),
NOSE_SHOULDER_POW = 2.4;     //     dying out toward the windshield (MPL elevation crease: 9 in at 18 in back, 4 in at 37)
NOSE_LEAN_IN = 8;            // the nose front leans back 8 in (MPL 13 in, reference model about 5 in)
WS_D0_IN = 83; WS_D1_IN = 95;    // MPL windshield: 83 in back at the bottom to 95 in back at the cab roof
CAB_ROOF_END_IN = 172;       // the cab roof ends this far back, then steps down to MID_ROOF
NOSE_ROUND_IN = 1;           // small rounding of the edges in side view
// end platform ahead of each nose: railings (1950 and 1970s photos show railings, not a box - the drawing's
// 'box' is the railing seen side-on). Posts [d ahead of the nose, y from the centre], top rail height - ESTIMATE
RAIL_POSTS_IN = [[8, 59], [70, 59], [70, 22]];
RAIL_TOP_IN = 42; RAIL_MID_IN = 21;

// running gear
DRIVER_IN  = 47.25;          // SRC driving wheel diameter
GUIDE_IN   = 36;             // ESTIMATE guide (pony) wheel diameter
RIGID_WB_IN = 20 * 12 + 7;   // DWG wheel base each driving truck
DRV_GAPS_IN = [86, 75, 86];  // DWG 7-2, 6-3 (read 6-3 1/2), 7-2 = 20-7
TOTAL_WB_IN = 77 * 12 + 10;  // DWG total wheel base
GUIDE_WB_IN = 82;            // DWG 6-10 guide truck wheelbase
GUIDE_TO_DRV_IN = 84;        // DWG 7-0 inner guide axle to outer driving axle
OUTER_DRV_IN = 50 * 12 + 2 + 11 / 16;   // DWG 50-2 11/16 outer driving axle to outer driving axle
COUPLER_IN = 34.5;           // AAR coupler centre height
BLIND_MIDDLE = true;         // middle two driving axles have no flanges (model practice, for curves)

// HO: bought wheelsets (pinpoint axles), nearest common sizes - TDQ
HO_DRIVER_IN = 42; HO_GUIDE_IN = 33; HO_AXLE_LEN = 25.4; HO_AXLE_D = 2.0;

// ---------------- derived model sizes ----------------
L_OA = p(LOA_IN); BL = p(BODY_L_IN); HL = BL / 2; BW = p(BODY_W_IN); HW = BW / 2; DECK_HL = p(DECK_HL_IN);
Z_DECK = p(DECK_IN); Z_EAVE = p(EAVE_IN); Z_ROOF = p(ROOF_IN); Z_MID_ROOF = p(MID_ROOF_IN);
ROOF_R = p(ROOF_R_IN); NOSE_L = p(NOSE_L_IN); NOSE_ROUND = p(NOSE_ROUND_IN);
Z_PAINT = p(PAINT_LINE_IN);
CPL_X = L_OA / 2; CPL_Z = p(COUPLER_IN);
Z_FRAME_BOT = Z_DECK - FRAME_T;

DRV_D = SC == "HO" ? p(HO_DRIVER_IN) : p(DRIVER_IN);
GDE_D = SC == "HO" ? p(HO_GUIDE_IN)  : p(GUIDE_IN);
DRV_AX = [for (x = [-RIGID_WB_IN / 2, -RIGID_WB_IN / 2 + DRV_GAPS_IN[0], RIGID_WB_IN / 2 - DRV_GAPS_IN[2], RIGID_WB_IN / 2]) p(x)];
DRV_X = p(OUTER_DRV_IN / 2 - RIGID_WB_IN / 2);                 // driving truck centre from loco centre
GDE_X = p(OUTER_DRV_IN / 2 + GUIDE_TO_DRV_IN + GUIDE_WB_IN / 2); // guide truck centre
GDE_SP = p(GUIDE_WB_IN);
AX_SP = p(DRV_GAPS_IN[1]);                                     // (shortest driving gap)

// wheel / sideframe standards: G and O from the shared library, HO here
T_YI   = SC == "HO" ? HO_AXLE_LEN / 2 - 1.3 : rg_yi;           // sideframe inner face from track centre
T_SF   = SC == "HO" ? 1.6 : rg_sf_t;                           // sideframe thickness
T_AXLE = SC == "HO" ? HO_AXLE_D : rg_axle_d;
T_HT   = SC == "G" ? 6 : SC == "O" ? 4.5 : 2.5;                // truck spine / bolster thickness

// body sections (prints) and frame pieces (joints staggered half a section)
SEC_L = BL / NSEC;
function sec_x0(k) = -HL + (k - 1) * SEC_L;                    // k = 1..NSEC
FRAME_SPLITS = [for (k = [1:NSEC]) sec_x0(k) + SEC_L / 2];     // a frame joint under the middle of every body section
NFRAME = NSEC + 1;

// ---------------- side details (d = inches back from the nose front; both sides, both ends) - SCALED from the DWG ----------------
CAB_WINS = [[108, 15], [133, 20], [158, 22]];   // three cab side windows: [centre d, width]
CAB_WIN_SILL_IN = 140; CAB_WIN_H_IN = 18;   // MPL
NOSE_PANEL = [32, 63, 108, 119];   // MPL number board
CLASS_BOX_IN = [22, 12, 4, 46, 104];  // raised box on each front corner (GE end view, reference model): width, height, stands out, y from centre, bottom               // the small panel on the nose side: d from, d to, z from, z to
CAB_DOOR_D_IN = 186; CAB_DOOR_W_IN = 28; CAB_DOOR_H_IN = 78;   // door just behind the cab
// louvre band along the upper body between the cabs (x from loco centre)
LOUVRE_X_IN = 222; LOUVRE_PANELS = 5; LOUVRE_Z_IN = [127, 146];
// windshield: two panes on the raked face of each cab (none at the B end of an EP-4)
WS_Y_IN = 29; WS_W_IN = 50;   // MPL end view: two big windshields, about 50 in wide each
// v10 (Tom 10/24): the windshield top and bottom edges curve down toward the outer side, following the roof/nose
// crown seen from the front, with rounded corners (like Tom's Body.stl reference)
WS_TOP_GAP_IN = 3;           // top edge this far below the roof line (at least one wall)
WS_BOT_IN     = 157.5;       // bottom edge height at the inner (centre) end; nose top 149, roof print starts at 150
WS_SAG        = 0.6;         // bottom edge drops this fraction of the roof's drop, so it runs parallel-ish to the top
WS_CORNER_R_IN = 3;          // corner rounding
HEADLIGHT_Z_IN = 137;        // MPL headlight hood: a 17 in round hood standing out of the rounded top-front of the nose
HL_HOOD_IN = [18, 16, 7];    //     (the upright 'brow' on the GE elevation; reference model and photos); [diameter, length, how far it stands out]
NOSE_DOOR_IN = [22, 54, 64];  // ESTIMATE door in the middle of the nose front: width, height, sill above rail (E79 head-on photo)
// roof
PAN_X_IN = 194;              // SCALED pantograph centres from loco centre
HATCH_X_IN = [0]; HATCH_L_IN = 190; HATCH_W_IN = 60;   // SCALED long raised hatch between the pantographs

// lettering (preview / Blender; decals on the real model)
HERALD_D_IN = 230; HERALD_Z_IN = 104; HERALD_IN = 22;   // herald on the side behind the cab door (1973 photo) - placement ESTIMATE
