// ==========================================================================
//  e7_params.scad  -  Milwaukee Road EMD E7A passenger diesel (class 20-EP)
//  Every setting for the model lives here.  Rib Side Works, Locomotives.
//
//  SOURCES (v1, 30 Oct 2026 - no drawings yet):
//   - Wikipedia "EMD E7": A1A-A1A, 36 in wheels, 71 ft long, 10 ft 6 1/2 in wide,
//     14 ft 11 in high; Milwaukee Road bought 10 A units, 16A,B - 20A,B.
//   - The Diesel Shop E7 data: 70 ft 0 in long, truck wheelbase 14 ft 1 in,
//     13 ft 11 in to top of the engine hood.  E8 / EA sheets (same family):
//     truck centres 43 ft 0 in, cab top 14 ft 7 in, cab width 10 ft 7 1/2 in,
//     front truck centre to pilot 6 ft 1 1/2 in (A end), 5 ft 1 1/2 in (rear).
//   - rrpicturearchives: MILW 19B, EMD c/n 3242, order E664, built 6/1946,
//     class 20-EP, traded to EMD 1968-69.
//   - Paint: Classic Trains photo of the Afternoon Hiawatha 13 Oct 1947 ("two
//     orange-and-gray E7 diesels"); Walthers models of 18A/18B (orange, black)
//     and 20A (yellow and gray, after 1955).
//  Marks:  SRC = from a source above.  ESTIMATE = a guess until a drawing or
//  photo is checked (TDQ list).
//
//  PROTOTYPE sizes are in inches and go through p() to model mm.
//  MODEL construction sizes (walls, screws, fits) are real mm, per scale.
// ==========================================================================

// ---------------- scale ----------------
SC = is_undef(SCALE_SEL) ? "G" : SCALE_SEL;

// name, ratio, gauge, wall, frame plate, body screw [pilot, clear, head], boss [size, height],
//   pivot screw [clear, name], body sections, sleeve, frame lap, fit,
//   truck [sideframe inner face from centre, sideframe thick, axle hole]
SCALES = [
  ["G",  29,   45.0,  2.4, 5.0, [2.2, 2.8, 5.0], [8, 12], [3.4, "M3"],   4, 10, 20, 0.25, [29.0, 3.0, 3.2]],
  ["O",  48,   31.75, 1.8, 4.0, [1.6, 2.4, 4.0], [6,  9], [2.9, "M2.5"], 2,  8, 14, 0.20, [20.0, 2.4, 2.4]],
  ["HO", 87.1, 16.5,  1.2, 2.0, [1.1, 1.6, 2.8], [4,  6], [2.4, "M2"],   1,  5, 10, 0.15, [11.4, 1.6, 1.6]]
];
S = [for (r = SCALES) if (r[0] == SC) r][0];
assert(!is_undef(S), str("SCALE_SEL must be G, O or HO - got ", SC));
RATIO = S[1]; GAUGE = S[2]; WALL = S[3]; FRAME_T = S[4];
BODY_SCREW = S[5]; BOSS = S[6]; PIVOT = S[7];
NSEC = S[8]; SLEEVE = S[9]; LAP = S[10]; FIT = S[11];
T_YI = S[12][0]; T_SF = S[12][1]; T_AXLE = S[12][2];
SCREW_BODY_NAME = SC == "G" ? "M2.5" : SC == "O" ? "M2" : "M1.4";

function p(i) = i * 25.4 / RATIO;      // prototype inches -> model mm
function ft(f, i = 0) = p(f * 12 + i);

// ---------------- which loco ----------------
// number, built, note.  All ten are E7A cab units, run as A-A pairs ("A" and "B" are both cab units).
LOCOS = [
  ["16A", "1946", "Afternoon Hiawatha pair with 16B (Wikipedia photo)"], ["16B", "1946", ""],
  ["17A", "1946", ""], ["17B", "1946", ""],
  ["18A", "1946", "Walthers model in orange / maroon / black"], ["18B", "1946", ""],
  ["19A", "1946", ""], ["19B", "6/1946", "EMD c/n 3242, order E664; photographed Chicago Union Station 1966"],
  ["20A", "1946", "Walthers model in UP yellow and gray"], ["20B", "1946", ""]
];
LOCO = is_undef(LOCO_SEL) ? "16A" : LOCO_SEL;
LOCO_ROW = [for (r = LOCOS) if (r[0] == LOCO) r][0];
assert(!is_undef(LOCO_ROW), str("LOCO_SEL must be 16A-20B - got ", LOCO));
ROAD_NO = LOCO; CLASS = "20-EP";

// ---------------- paint (preview and Blender only) - ALL ESTIMATE until photos are checked (TDQ) ----------------
PAINT = is_undef(PAINT_SEL) ? "1956" : PAINT_SEL;   // default UP yellow (Tom 11/23)
//  "1946"  as delivered: orange and gray (1947 photo caption) - band layout ESTIMATE
//  "1950"  Hiawatha orange / maroon with black roof (about 1950-1955)
//  "1956"  Union Pacific Armour yellow, gray roof, red stripes (after 1955)
C_ORANGE = "#E2711D"; C_MAROON = "#5C1A16"; C_BLACK = "#1F1F1F"; C_GRAY = "#8E9194";   // same family as the Little Joe / ES-2
C_YELLOW = "#F2BE1A"; C_MIST = "#9A9C98"; C_RED = "#B3121C";
C_FRAME = "#202020"; C_TRUCK = "#1E1E1E"; C_GLASS = "#9FB4BF"; C_WHEEL = "#555555"; C_LENS = "#FFFFFF";
// colour bands bottom-up: [top of band (inches above rail), colour]; the last band runs to the roof
PAINT_BANDS =
  PAINT == "1946" ? [[62, C_GRAY],   [126, C_ORANGE], [999, C_GRAY]] :
  PAINT == "1956" ? [[58, C_MIST],   [60, C_RED], [155, C_YELLOW], [156.5, C_RED], [999, C_MIST]] :   // v3: upper stripe above the side screens
                    [[118, C_ORANGE], [150, C_MAROON], [999, C_BLACK]];
assert(PAINT == "1946" || PAINT == "1950" || PAINT == "1956", "PAINT_SEL must be 1946, 1950 or 1956");

// ---------------- prototype dimensions (inches) ----------------
BODY_L_IN   = 816;        // SRC Southern Ry E7 diagram (Tom 11/23): nose face to rear face; 71 ft 1 1/2 in over pulling faces
TRUCK_CTR_IN = 43 * 12;   // SRC (E8 / EA sheets) truck centres 43 ft 0 in
FRONT_TO_TRUCK_IN = 154;  // SRC diagram: 13 ft 0 in pilot face to front truck centre (rear 147); trucks are kept symmetric, so the model has 151 front / 151 rear
BODY_W_IN   = 123;        // SRC-ish: E8 cab width 10 ft 7 1/2 in over grabs; carbody 10 ft 3 in
ROOF_IN     = 13 * 12 + 11;  // SRC 13 ft 11 in to top of the carbody (engine room) roof
CAB_ROOF_IN = 14 * 12 + 7;   // E8 SRC, E7 ESTIMATE: cab roof 14 ft 7 in
ROOF_R_IN   = 6;          // diagram: flat side runs up to about 157 in, then a crowned roof (ROOF_EDGE_IN to ROOF_IN)
SKIRT_IN    = 40;         // ESTIMATE bottom of the side skirt above rail
DECK_IN     = 52;         // ESTIMATE top of the underframe (model frame plate) above rail

// Cab roof back to the engine room roof (v3, 23 Nov 2026, from the Southern Ry E7 diagram):
// the crowned cab roof of the nose piece runs back to CAB_BACK_IN[1], then a straight fairing
// slopes down to the engine room roof at CAB_BACK_IN[2].  The nose piece itself ends at d = 152.
CAB_BACK_IN  = [150, 160, 183];   // [loft starts (inside the nose piece), cab roof ends, engine roof starts]
ROOF_EDGE_IN = 160;               // engine room roof: height of the side top edge (crowned to ROOF_IN on the centre line)
REAR_ROUND_IN = 8;          // ESTIMATE rear-end corner rounding in plan

// windshield: two panes on the sloped face
WS_Y_IN = [6, 34];          // ESTIMATE inner and outer edge, from the centre line
WS_D_IN = [4, 25];          // v2 ESTIMATE: pane from / to, inches back from the windshield base line (e7_nose.scad)
// ---- side layout: SRC Southern Ry E7 diagram (southern.railfan.net, Tom 11/23), checked against
//      Tom's KIRI scan (same window positions both sides).  All [v from, v to, z from, z to] in inches:
//      v back from the nose face, z above rail.  Same layout on both sides (scan agrees).
CAB_WIN   = [[83, 120, 133, 153]];          // cab side window (front corners rounded to follow the windshield)
CAB_WIN_R = [9, 3];                         // corner radius front, back
CAB_DOOR  = [123, 155, 91, 154];            // crew door behind the cab (outline groove)
DOOR_WIN  = [130, 150, 132, 152];           // window in the crew door
STEP_WELL = [126, 152, 91];                 // steps under the crew door: v from, v to, top (down to the skirt)
SIDE_WIN  = [[336, 361, 98, 124], [363, 386, 98, 124],     // engine room windows, squared with round corners
             [581, 605, 98, 124], [606, 629, 98, 124],
             [714, 738, 95, 122]];                         // steam generator room window
WIN_R     = 3.5;                            // window corner radius
ENG_DOOR  = [482, 513, 66, 123];            // engine room side door (outline groove)
// screened air intakes high on the sides (diamond mesh in a pocket)
SCREENS   = [[158, 181, 113, 153],          // tall intake just behind the crew door
             [192, 256, 129, 153], [437, 492, 126, 153], [672, 726, 124, 151]];
SCREEN_PITCH = 4;                           // mesh pitch (inches, prototype - coarser than real so it prints)
// headlight in the nose
HEADLIGHT = [118, 14, 4];   // v2 ESTIMATE [height, diameter, stands out] - on the face below the roll-over
NOSE_DOOR = [24, 52, 54];   // ESTIMATE [width, height, sill] door in the nose front (outline only)

// passenger pilot (v3, Southern Ry E7 diagram): levels [height, front (in ahead of the nose face, at the
// centre line), half width, setback of the outer corner behind the front]; anticlimber band on top
PILOT_LEVELS = [[45, 5.0, 57, 9], [34, 9.0, 54, 8], [18, 14.7, 50, 7], [15, 15.8, 49, 6.6]];
PILOT_PLOW   = [[15, 15.8, 35, 3], [5.5, 19, 28, 2]];   // centre plow below the outer ledge
PILOT_BACK   = 25;              // back edge of the pilot below the skirt (in behind the nose face)
ANTICLIMBER  = [46, 55, 4.7, 21];   // [bottom, top, stands out from the nose, wraps back to]

// running gear
WHEEL_IN = 36;              // SRC
TRUCK_WB_IN = 14 * 12 + 1;  // SRC
HO_WHEEL_IN = 33;           // HO uses bought wheelsets - nearest common size (TDQ)
COUPLER_IN = 34.5;          // AAR coupler centre height

// ---------------- derived model sizes ----------------
BL = p(BODY_L_IN); HL = BL / 2; XF = HL; XR = -HL;
HW = p(BODY_W_IN) / 2;
Z_SKIRT = p(SKIRT_IN); Z_DECK = p(DECK_IN); Z_ROOF = p(ROOF_IN); Z_CAB = p(CAB_ROOF_IN);
Z_FRAME_BOT = Z_DECK - FRAME_T;
TRK_X = p(TRUCK_CTR_IN) / 2;
TRK_FRONT_X = XF - p(FRONT_TO_TRUCK_IN);
WHEEL_D = SC == "HO" ? p(HO_WHEEL_IN) : p(WHEEL_IN);
AX_SP = p(TRUCK_WB_IN) / 2;
CPL_Z = p(COUPLER_IN);
// the trucks sit symmetric about the loco centre at +/- TRK_X; the front overhang check is in e7_report()

// body sections (prints) and frame pieces (joints staggered half a section)
SEC_L = BL / NSEC;
function sec_x0(k) = XR + (k - 1) * SEC_L;               // k = 1..NSEC, section 1 at the rear
FRAME_SPLITS = [for (k = [1:NSEC]) sec_x0(k) + SEC_L / 2];
NFRAME = NSEC + 1;
FRAME_X0 = XR + WALL + FIT; FRAME_X1 = XF - p(60);       // frame stops inside the nose
FRAME_HW = HW - WALL - FIT;
// body screw bosses: x positions (both sides), kept in the full-width body
BOSS_X = [for (k = [1:NSEC], f = [0.25, 0.75]) let (x = sec_x0(k) + f * SEC_L)
          if (x > XR + 10 && x < XF - p(175) && abs(x - TRK_X) > p(100) && abs(x + TRK_X) > p(100)) x];
