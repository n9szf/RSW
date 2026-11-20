// =====================================================================
//  es2_params.scad  -  Milwaukee Road class ES-2 electric switcher
//  Every setting for the model lives here.
//
//  SOURCE: GE general arrangement, C.M.& St.P. 10050 as built 1916
//  (reference / Locomotives / ES-2 switcher / MILW_ES-2_drawing.jpg).
//  The drawing scales at 5.49 px per inch (checked against 41 ft 5 in
//  over couplers, 22 ft 4 in truck centres, 8 ft wheelbase, 4 ft 8 1/2 in
//  gauge and 10 ft 1 1/2 in width - all agree within 1%).
//  Dimensions printed on the drawing are marked DWG. Values scaled off it
//  are marked SCALED (about +/- 2 in). Guesses are marked ESTIMATE.
//
//  PROTOTYPE sizes are in inches and go through p() to model mm.
//  MODEL construction sizes (walls, fits, magnets) are real mm.
// =====================================================================

// ---------------- smoothness (Tom 10/20: $fn = 100) ----------------
// Circles and curves use FN segments (set FN_SEL in the Main or a part file). Rivets, wire holes and
// other tiny round things keep their own low counts so a render stays quick.
FN  = is_undef(FN_SEL) ? 100 : FN_SEL;
$fn = FN;

// ---------------- scale ----------------
// G only (Tom 10/13): 1:29 on 45 mm track.
ES2_SCALE = is_undef(SCALE_SEL) ? "G" : SCALE_SEL;   // Tom 10/20: pull-down - G (1:29) or O (1:48); the shared running gear has only these two
RG_SCALE  = ES2_SCALE;
include <../../../../Trucks/library/rsw_running_gear.scad>

function p(i) = rg_in(i);                 // prototype inches -> model mm

// ---------------- which loco (Tom 10/13: a selector for E80 - E83, orange paint) ----------------
// Set LOCO_SEL in the Main file or a part file before the include (the Customizer shows a list).
// Each row: number, built, headlight ("short" pedestal or "tower"), side tank, where it comes from.
// The four differed in small details; only what a photo shows is set per loco.
LOCOS = [
    ["E80", 1916, "short", true, "ex 10050. No photo of E80 yet - set like E81 / E83 (ESTIMATE)"],
    ["E81", 1916, "short", true, "ex 10051. E81 photo (y8v841uc2cb61.jpg): short headlight stand with number board, side tank"],
    ["E82", 1919, "tower", true, "ex 10052. E82 colour photo: tall headlight tower with number board, side tank"],
    ["E83", 1919, "short", true, "ex 10053. Tom's HO model (Mashima drive): short headlight stands, side tank, one window each cab side"]
];
LOCO   = is_undef(LOCO_SEL) ? "E83" : LOCO_SEL;
LOCO_ROW = [for (r = LOCOS) if (r[0] == LOCO) r][0];
assert(!is_undef(LOCO_ROW), str("LOCO_SEL must be E80, E81, E82 or E83 - got ", LOCO));
ROAD_NO  = LOCO;
HL_STYLE = LOCO_ROW[2];
HAS_TANK = LOCO_ROW[3];
ERA      = "later";
// Paint (preview only, Tom 10/20 pull-down): "ALL_BLACK"; "ORANGE_BLACK" = Milwaukee orange below,
// black above (Tom's HO E83); "ORANGE_MAROON" = maroon below, orange above (the E82 colour photo);
// "NO_PAINT" = everything printed shown in plain grey filament, no lettering.
PAINT    = is_undef(PAINT_SEL) ? "ORANGE_BLACK" : PAINT_SEL;
PAINT_LINE = 46;             // orange / black line above the deck, inches (HO model, about level with the hood end tops)
SHOW_LETTERING = true;       // preview only - nothing is lettered on the printed parts

// ---------------- overall (prototype inches) ----------------
OVER_COUPLERS = 41*12 + 5;    // DWG 41 ft 5 in
TRUCK_C       = 22*12 + 4;    // DWG 22 ft 4 in truck centres
WB            = 8*12;         // DWG 8 ft truck wheelbase
WHEEL_D       = 40;           // DWG 40 in wheels
COUPLER_CL    = 34.5;         // DWG 34 1/2 in rail to coupler centre

// ---------------- frame / deck ----------------
FRAME_L   = 460;              // SCALED end sill to end sill (38 ft 4 in)
FRAME_W   = 120;              // SCALED, matches the cab width in the end view
DECK_TOP  = 57.25;            // DWG 4 ft 9 1/4 in rail to deck top
SILL_D    = 14;               // SCALED side sill depth below the deck top
END_SILL_D = 16;              // SCALED end sill depth
END_SILL_T = 10;              // ESTIMATE end sill thickness (along the loco)
RES_L     = 98;               // SCALED box (reservoirs / weights) under the frame between trucks
RES_W     = 72;               // ESTIMATE
RES_D     = 13;               // SCALED

// ---------------- hoods ----------------
CAB_L     = 109;              // SCALED cab length along the loco (9 ft 1 in)
CAB_W     = 118;              // SCALED cab width (10 ft 1 1/2 in over the roof)
HOOD_L    = 161;              // MPL sheet 03 (Auxiliary Cab No. 1 End, T1613867): 13 ft 5 1/16 in, cab face to hood end; was 163 scaled
HOOD_W    = 75;               // SCALED from the end view (6 ft 3 in)
HOOD_H_CAB = 81.5;            // SCALED hood top above the deck at the cab
HOOD_H_END = 59.5;            // SCALED hood top above the deck at the end (before rounding)
HOOD_R_END = 10;              // SCALED rounded edge, end to top
HOOD_R_PLAN = 6;              // ESTIMATE rounded vertical corners at the hood end

// ---------------- cab ----------------
CAB_EAVE  = 99;               // SCALED deck to eave (rail to eave 13 ft)
ROOF_L    = 122;              // SCALED roof length (overhangs the cab ends)
ROOF_W    = 122;              // DWG 10 ft 1 1/2 in over the roof
ROOF_RISE = 15;               // SCALED eave to crown (DWG 14 ft 3 1/4 in rail to roof)
ROOF_EDGE = 2.5;              // ESTIMATE roof edge thickness
// Later cab sides (HO model): ONE window each side, sill 52 in, 36 x 32 in.
//   drawing side (-y): 2 x 2 panes, centre 4 in toward hood 2; far side (+y): 2 panes side by side, centre 13 in toward hood 1.
CAB_WIN   = [[-1, 31.4, 32, 52, 4, 2], [1, 31.4, 32, 52, -13, 1]];   // side, width, height, sill, centre x, rows
                                 // width: MPL sheet 11 (Windows, P1653760) side sash 2 ft 7 3/8 in (was 36 from the HO model)
SIDE_WIN  = [31.4, 32, 52, 0];     // (glazing in the preview)

// ---------------- pantograph: BOUGHT (Tom 10/13) ----------------
// The roof carries four insulator posts with 1.6 mm holes; set the spacing to
// the bought pantograph's base holes when it arrives (TDQ-304).
PAN_BASE_L = 92;              // MPL sheet 08 (Roof Plan, T1616202): insulator spacing along the loco (was 90 scaled)
PAN_BASE_W = 63;              // MPL sheet 08: insulator spacing across (was 47 - misread from the outline end view)
PAN_MODEL_L = 0;              // > 0: the bought pantograph's hole spacing in MODEL mm, overrides PAN_BASE_L
PAN_MODEL_W = 0;
PAN_HOLE    = 1.6;

// ---------------- later details (E80-E83, from the E81 / E82 photos - ESTIMATES) ----------------
HL_TOWER_H   = HL_STYLE == "tower" ? 30 : 8;   // headlight stand: tall tower (E82 photo) or short pedestal (E81 photo, HO E83)
HL_TOWER_IN  = 19.5;          // MPL sheet 06 (Location of Apparatus, elevation): J-25 headlight centre 19 1/2 in from the hood end (was 14)
BELL_X       = 45;            // MPL sheet 06: bell on hood 1, about 45 in from the cab face (scaled)
SAND_CAP_IN  = 20;            // MPL sheets 03 / 04: sandboxes inside each hood end, filled through two caps on the hood top (position scaled)
ARRESTER     = [18, 21, 12, -3, 1];   // MPL sheet 08: lightning arrester on the roof - length, width, height (in), centre x off the roof middle, side
NUMBER_BOARD = [30, 3, 9];    // number boards on the cab roof SIDES, facing out (HO model), length x depth x height
TANK         = [44, 14, 40, 6];   // side tank on hood 2, one side: length from the cab, depth out from the hood, height, top radius
TANK_SIDE    = -1;            // the drawing's side (-y), where the drawing had the recessed panel (Tom's HO model)

// ---------------- trucks: PRINTED, UNPOWERED (Tom 10/13: "non power, best looking") ----------------
// GE equalized bar-frame motor truck, 8 ft wheelbase, 40 in wheels, drawn from the GE drawing and
// Tom's HO E83. Wheels, brass axles and F683 bearings from the shared RSW running gear, as on the cars.
// (The USA Trains R22-12 motor block idea of v2 is dropped.)
PIVOT_DROP  = 6;              // truck bolster top this far below the deck underside (mm)
// From MPL sheet 10, Truck Assembly, C.M.& St.P. Motive Power Dept. 18524-A (Aug 1916):
TK_FRAME_C  = 78;             // DWG 6 ft 6 in between truck frame centres (frames well outside the wheels)
TK_SPRING_C = 50;             // DWG 4 ft 2 in spring centres (equalizer springs)
TK_END_OUT  = 25.5;           // SCALED frame end beyond each axle
TK_BOX      = [18, 19];       // SCALED journal box length x height (6 x 12 in journals)
TK_BRAKE    = [10, 12];       // DWG Westinghouse 10 x 12 in Type B brake cylinder, one per truck, at the centre
// ---------------- printed coupler (Tom 10/13) ----------------
// A printed dummy knuckle, body-mounted on the end-sill pad (TDQ-194: a dummy to test
// the height before choosing a working coupler). Centre height from the drawing.
COUPLER_Z   = 34.5;           // DWG rail to coupler centre (30.2 mm in G = the passenger cars' height)

// ---------------- v6 detail (Tom 10/17: "as much detail as possible, focus G scale") ----------------
// Where nothing shows it, GE steeplecab practice of 1910-1920 is used, marked GE PRACTICE.
// Doors: every hood side door is hinged (three butt hinges, latch handle). The doors can be shown
// OPEN in the preview and the Blender pictures; the PRINT always has them closed.
DOOR_OPEN   = is_undef(DOOR_OPEN_SEL) ? 0 : DOOR_OPEN_SEL;     // degrees, 0 = closed (try 75)
DOORS_SHOWN = is_undef(DOORS_SEL) ? "ALL" : DOORS_SEL;          // which doors open: ALL, HOOD_1, HOOD_2, TANK_SIDE, FAR_SIDE
// Frame (Tom 10/17): side sills are channels, flanges out (the C shows); GE PRACTICE 15 in channel.
SILL_FLANGE  = 3.4;           // ESTIMATE channel flange width, inches (15 in channel: 3.4 in)
SILL_FLANGE_T = 1.2;          // model mm, flange thickness (thicker than scale so it prints)
POLE_POCKET  = [8, 2.5, 4.5]; // GE PRACTICE pole-pushing pocket on each frame corner: boss size, proud, socket dia (in)
// Diamond plate walkways (Tom 10/17), a separate thin print glued on the deck round each hood
WALK_T       = 0.9;           // mm plate
WALK_LUG     = [3.2, 0.9, 0.3, 2.2];   // mm lug length, width, height, pitch (about 1 1/4 in pattern)
// Railings (Tom 10/17): 1 mm brass wire, painted white; the print has posts with holes the wire threads through
RAIL_WIRE    = 1.0;           // mm wire
RAIL_HOLE    = 1.25;          // mm hole for it
RAIL_H       = 5;             // in, rail above the hood top
RAIL_IN      = 3.5;           // in, rail in from the hood side
RAIL_POST_PITCH = 36;         // in, post spacing along the hood
// Rivets (Tom 10/17: grey for now)
RIVET_D      = 0.9;           // mm head (7/8 in rivet is 0.77 mm - a little over so it prints)
RIVET_H      = 0.4;           // mm
RIVET_PITCH  = 4;             // in, along seams
C_RIVET      = PAINT == "NO_PAINT" ? "#B8B8B4" : "#8A8A8A";
C_RAIL       = PAINT == "NO_PAINT" ? "#B5A642" : "#F4F4F0";   // bare brass wire when unpainted
C_LENS       = "#FFFFFF";
// Pantograph (Tom 10/17: shown, not printed - it is bought). 0 = locked down, 1 = up to the wire.
PAN_RAISE    = is_undef(PAN_RAISE_SEL) ? 0.25 : PAN_RAISE_SEL;
// Ladders on the hood ends (Tom 10/17; HO E83 has one on each hood end, to one side)
LADDER       = [16, 12, 4, 3]; // in: width, rung pitch, rungs, standoff
LADDER_Y     = 20;            // in, ladder centre off the loco centre line (HO model: toward the +y side)

// ---------------- v8 assembly (Tom 10/18, after printing the base) ----------------
// Frame halves joined by three 2 mm brass rods, 100 mm long (50 mm in each half).
JOIN_ROD     = [2.0, 100, 2.2];   // rod dia, rod length, hole dia (mm)
// Hoods and cab screwed down to the deck as on the passenger cars: M2.5 self-tapping screws
// up through the deck into bosses (same sizes as mr_config.scad FLOOR_*).
BODY_BOSS    = 8.0;           // boss width, mm
BODY_BOSS_H  = 12.0;          // boss height, mm (45 degree top so it prints)
BODY_PILOT   = 2.2;           // pilot hole, M2.5 self-tapping
BODY_CLEAR_D = 2.9;           // clearance hole in the deck
BODY_HEAD_D  = 5.2;           // counterbore for the head, from under the deck (1.6 mm of deck left)
// Cab to hood: one M2.5 screw each side, from inside the cab through the cab end wall into a boss in the hood
CAB_HOOD_Z   = 9;             // mm above the deck
CAB_ARCH_IN  = 7;             // the cab's opening into the hood is this much narrower each side, to leave wall for the screws
// Steps (stirrups) printed separately (Tom 10/18: the printed ones broke easily); 1 mm wire pins into the side sills
STEP_PIN     = 1.25;          // hole for a 1 mm brass pin

// ---------------- model construction (mm) ----------------
HOOD_WALL   = ES2_SCALE == "G" ? 2.0 : 1.6;
CAB_WALL    = ES2_SCALE == "G" ? 2.4 : 1.8;
DECK_T      = ES2_SCALE == "G" ? 4.0 : 3.0;     // deck plate thickness
SILL_T      = ES2_SCALE == "G" ? 3.0 : 2.2;     // side sill plate thickness
BULKHEADS   = 3;                                // inside each hood, so the hood top never bridges more than ~36 mm
PANEL_PROUD = 0.5;                              // raised door panels
ENGRAVE     = 0.6;                              // louvres, recessed panels
MAGNET      = [6.3, 3.2];                       // 6 x 3 mm disc magnets, cab to roof (4 + 4)
PIN_D       = 3.2;                              // 3 mm brass / filament pins joining the frame halves
PIVOT_TAP   = 2.8;                              // (v7 and before: M3 self-tapping pivot screw - replaced by the shoulder bolt)
// Truck pivot (Tom 10/18): a shoulder bolt dropped down through the frame, through the truck bolster,
// held by a nylon lock nut under the truck. ISO 7379: 4 mm shoulder, M3 thread, socket head 7 x 3 mm.
PIVOT_BOLT  = [4.0, 16, 7.0, 3.0];               // shoulder dia, shoulder length, head dia, head height (mm)
PIVOT_FIT   = [4.15, 4.3, 7.6];                  // hole in the frame (snug), hole in the truck bolster (turns), head counterbore
PIVOT_PLAY  = 0.3;                               // the shoulder ends this far below the truck bolster: the nut clamps the shoulder, not the truck
PIVOT_NUT   = [5.5, 4.0];                        // M3 nylon lock nut (DIN 985), across flats, height
PIVOT_GAP   = 0.3;                              // truck bolster to frame bolster
COUPLER_PAD = [16, 14];                         // pad under each end sill for the coupler
COUPLER_SCREW = 2.0;                            // M2 self-tapping

// ---------------- derived (model mm) ----------------
deck_z   = p(DECK_TOP);
deck_bot = deck_z - DECK_T;
pivot_z  = deck_bot - PIVOT_DROP;                 // truck bolster top
frame_hx = p(FRAME_L) / 2;
frame_hw = p(FRAME_W) / 2;
cab_hx   = p(CAB_L) / 2;
cab_hw   = p(CAB_W) / 2;
hood_l   = p(HOOD_L);
hood_w   = p(HOOD_W);
truck_x  = p(TRUCK_C) / 2;
wheel_d  = p(WHEEL_D);                            // DWG 40 in
axle_z   = wheel_d / 2;
eave_z   = p(CAB_EAVE);                           // above the deck

// paint (preview only)
C_ORANGE = "#E2711D";
C_MAROON = "#5C1A16";
C_RAW    = "#B8B8B4";                              // unpainted grey filament
NOPAINT  = PAINT == "NO_PAINT";
C_BLACK  = NOPAINT ? C_RAW : "#1F1F1F";
C_WALK   = NOPAINT ? C_RAW : "#2A2A2A";
C_WIRE   = NOPAINT ? "#B5A642" : "#2E2E2E";        // black-painted brass wire / rod
C_PANTO  = "#4A4A4A";                              // bought pantograph
C_INSIDE = NOPAINT ? C_RAW : "#3A3A3A";
C_STEEL  = "#9A9A9A";
C_GLASS  = [0.6, 0.8, 0.9, 0.35];
