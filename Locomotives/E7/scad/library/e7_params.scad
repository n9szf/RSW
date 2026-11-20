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
PAINT = is_undef(PAINT_SEL) ? "1950" : PAINT_SEL;
//  "1946"  as delivered: orange and gray (1947 photo caption) - band layout ESTIMATE
//  "1950"  Hiawatha orange / maroon with black roof (about 1950-1955)
//  "1956"  Union Pacific Armour yellow, gray roof, red stripes (after 1955)
C_ORANGE = "#E2711D"; C_MAROON = "#5C1A16"; C_BLACK = "#1F1F1F"; C_GRAY = "#8E9194";   // same family as the Little Joe / ES-2
C_YELLOW = "#F2BE1A"; C_MIST = "#9A9C98"; C_RED = "#B3121C";
C_FRAME = "#202020"; C_TRUCK = "#1E1E1E"; C_GLASS = "#9FB4BF"; C_WHEEL = "#555555"; C_LENS = "#FFFFFF";
// colour bands bottom-up: [top of band (inches above rail), colour]; the last band runs to the roof
PAINT_BANDS =
  PAINT == "1946" ? [[62, C_GRAY],   [126, C_ORANGE], [999, C_GRAY]] :
  PAINT == "1956" ? [[58, C_MIST],   [60, C_RED], [144, C_YELLOW], [146, C_RED], [999, C_MIST]] :
                    [[118, C_ORANGE], [150, C_MAROON], [999, C_BLACK]];
assert(PAINT == "1946" || PAINT == "1950" || PAINT == "1956", "PAINT_SEL must be 1946, 1950 or 1956");

// ---------------- prototype dimensions (inches) ----------------
BODY_L_IN   = 800;        // ESTIMATE carbody, nose tip to rear face (70 ft 0 in over the pilot and rear end, less couplers)
TRUCK_CTR_IN = 43 * 12;   // SRC (E8 / EA sheets) truck centres 43 ft 0 in
FRONT_TO_TRUCK_IN = 142;  // ESTIMATE nose tip to front truck centre (pilot 6 ft 1 1/2 in ahead of the lead axle)
BODY_W_IN   = 123;        // SRC-ish: E8 cab width 10 ft 7 1/2 in over grabs; carbody 10 ft 3 in
ROOF_IN     = 13 * 12 + 11;  // SRC 13 ft 11 in to top of the carbody (engine room) roof
CAB_ROOF_IN = 14 * 12 + 7;   // E8 SRC, E7 ESTIMATE: cab roof 14 ft 7 in
ROOF_R_IN   = 24;         // ESTIMATE roof corner radius
SKIRT_IN    = 40;         // ESTIMATE bottom of the side skirt above rail
DECK_IN     = 52;         // ESTIMATE top of the underframe (model frame plate) above rail

// Nose ("bulldog"): stations measured back from the nose tip:
//   [d back, half width, top height, top corner radius]  - ALL ESTIMATE, to be checked against a drawing (TDQ)
NOSE = [
  [0,   34,  80, 18],
  [5,   44,  98, 22],
  [16,  52, 110, 26],
  [34,  57, 119, 26],
  [58,  60.5, 125, 24],
  [84,  61.5, 129, 22],     // windshield bottom
  [112, 61.5, 175, 28],     // windshield top / cab roof front
  [150, 61.5, 175, 28],     // cab roof back
  [166, 61.5, ROOF_IN, ROOF_R_IN]
];
REAR_ROUND_IN = 8;          // ESTIMATE rear-end corner rounding in plan

// windshield: two panes on the sloped face
WS_Y_IN = [6, 34];          // ESTIMATE inner and outer edge, from the centre line
WS_D_IN = [86, 110];        // along the slope (d back from the tip)
// cab side window and door
CAB_WIN = [[118, 146, 136, 160]];   // ESTIMATE [d from, d to, z from, z to]
CAB_DOOR = [152, 176, 64, 150];     // ESTIMATE crew door behind the cab
// portholes along each side: d back from the nose tip, centre height, diameter - ESTIMATE
PORTHOLES = [[214, 120, 22], [560, 120, 22]];
// louvre / filter grille band along the upper body - ESTIMATE
GRILLE_D_IN = [250, 720]; GRILLE_Z_IN = [132, 156]; GRILLE_N = 9;
// headlight in the nose
HEADLIGHT = [96, 14, 4];    // ESTIMATE [height, diameter, stands out]
NOSE_DOOR = [24, 52, 54];   // ESTIMATE [width, height, sill] door in the nose front (outline only)

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
