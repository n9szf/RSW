// =====================================================================
//  MILWAUKEE ROAD (C.M.&St.P.) - VIROQUA, WIS. PASSENGER DEPOT (1899)
//  Sparta - Viroqua branch (La Crosse Division). Branch torn up 1982.
//  Stands: 305 Railroad Ave, Viroqua - Wonderstate Coffee offices (was their roastery).
//  Rib Side Works, 26 Nov 2026, rev 3 (hand-built - do not regenerate). Rev 2 added the 1899 interior; rev 3 trims every opening inside and fixes the bay side windows.
//
//  SOURCES
//   - Album of Depot Plans 1919, Sheet 130 "24' x 64' Depot as built at Viroqua",
//     Chicago Nov 12 1899, J.U. Nettenstrom architect (private reference, in copyright).
//     Plan (rooms, openings, bay), front (track) elevation and one end elevation.
//   - Photos in RSW/reference/Station photos web/Viroqua (index.csv): 1909 track side,
//     1976 WHS survey (3), about 2014 end view (colours), 2025 Street View.
//  SHAPE: kept to the album plan (Tom's rule), so the turret and the gable windows are
//   modelled even though the turret seems gone and the gable windows were sided over by 2014.
//  COLOURS: about 2014 (Tom 26 Nov 2026) - yellow body, deep red trim and doors, black roof.
//  KNOWN (sheet): 24 x 64 ft; rooms men's 16'6" / office 12' / women's 16'6" / baggage 16'6";
//   track-side openings and the bay; hip roof with end gables (twin windows), ridge cresting,
//   octagonal turret over the bay, two chimneys on the ridge, long eave brackets, lap siding.
//  MEASURED off the sheet at about 13.4 px/ft (ESTIMATE +/- 0.5 ft): wall 12.2 ft to the soffit,
//   eaves 7.5 ft, roof about 0.7 rise per ft (ridge about 26 ft), turret walls 14-18.7 ft,
//   spire point about 33 ft, chimney tops about 31 ft, window sills 3.5 ft, heads about 10 ft.
//  ESTIMATE: town side openings (not drawn), the far (baggage) end, bracket spacing, cresting
//   pattern, turret size in plan, platform, name boards, sash and chimney colours.
//  INTERIOR (rev 2): rooms, partitions, inside doors, ticket windows and the toilet room from the
//   sheet plan. ESTIMATE: 9.5 ft ceilings, oak wainscot, plaster, beadboard ceiling colour, benches,
//   stoves (chimneys stand on the partitions), operator's table in the bay, ticket counters, desk,
//   safe, baggage scale, truck and trunks. No inside photo before the 2000s (coffee roastery).
//   -D SHOW_ROOF=false leaves off the roof, turret, ceiling and chimneys for a cut-away view.
//  x along the track from the BAGGAGE end (men's room at the x = 64 end, so seen from the track
//  the men's room and turret are on the left as on the sheet), y = 0 town side, +y track side, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
// Interior colours set before the include so the builder's PAINTS position can see them (ESTIMATE, see below)
COL_OAK   = "#8A5A2B";
COL_PLAST = "#D3C49C";
COL_CEIL  = "#B88C55";
COL_FLOOR = "#7A5434";
COL_METAL = "#262628";
include <../../../_common/rsw_depot.scad>

// Colours about 2014 (Wisconsin Bites photo). Plain "#hex" lines so make_glb.py can read them.
COL_BODY  = "#D6A030";   // golden yellow siding
COL_TRIM  = "#8C1F1B";   // deep red trim, brackets, fascia, corner boards
COL_SASH  = "#8C1F1B";   // window frames red (photo)
COL_ROOF  = "#2B2B2D";   // black shingles
COL_DOOR  = "#9A2420";   // red doors
COL_BRICK = "#B9A57C";   // buff chimney (photo)
COL_FOUND = "#9E9A92";   // concrete base
// Interior 1899 (all ESTIMATE - no inside photo before the 2000s): varnished oak wainscot,
// benches and counters, buff plaster walls, varnished beadboard ceiling, pine floor, black iron stoves.
COL_GLASS = "#3F5866";   // builder colours repeated so make_glb.py finds them in this file
COL_STUC  = "#D8CDB2";
COL_STONE = "#9A8F7E";
COL_PLAT  = "#8E8A84";
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT],
          ["chimney", COL_BRICK], ["sash", COL_SASH],
          ["oak", COL_OAK], ["plaster", COL_PLAST], ["ceiling", COL_CEIL], ["floor", COL_FLOOR], ["metal", COL_METAL]];
FLOOR = 1.5;
SHOW_ROOF = true;        // -D SHOW_ROOF=false for a cut-away view of the rooms
T = 0.5;                 // outside wall thickness (ft)
CEIL = 11;               // ceiling height above grade (ESTIMATE, 9.5 ft rooms)

L = 64;  W = 24;  PLATE = 12.2;  OV = 7.5;  RISE = 0.7;
RIDGE = PLATE + RISE * (W / 2 + OV);          // about 25.9 ft
HZ = PLATE + RISE * OV;                       // roof height at the wall line, about 17.5 ft

BLOCKS = [[0, L, 0, W, PLATE, RISE, 5, 0, 0]];   // walls, water table, corner boards; roof drawn below

// windows [x, side, w, h, sill]  sides: 0 town, 1 track, 2 baggage end (x=0), 3 men's end (x=64)
WS = 3.5;  WH = 6.6;  WW = 2.8;
WINS = [
  [59.7, 1, WW, WH, WS], [22, 1, WW, WH, WS],                                // track side (sheet)
  [59.7, 0, WW, WH, WS], [51.7, 0, WW, WH, WS], [41, 0, WW, WH, WS],         // town side (ESTIMATE)
  [29.9, 0, WW, WH, WS], [22, 0, WW, WH, WS], [12.5, 0, 2, 3, 6.5],         // ... small one = toilet
  [6.5, 3, WW, WH, WS], [17.5, 3, WW, WH, WS],                              // men's end (sheet)
  [6.5, 2, WW, WH, WS], [17.5, 2, WW, WH, WS]];                             // baggage end (ESTIMATE = same)
// doors [x, side, w, h, type]  type 0 passenger, 1 double baggage
DOORS = [
  [51.7, 1, 3, 7.5, 0], [29.9, 1, 3, 7.5, 0], [9.2, 1, 5.5, 8, 1],        // track side (sheet)
  [7, 0, 5.5, 8, 1]];                                                      // town baggage door (ESTIMATE)
BAY = [41, 11.5, 3.7];                        // centre, width at the wall, depth (sheet plan)
TUR = [41, W + 0.5, 10.5];                    // turret centre x, y and size across flats (ESTIMATE in plan)
CHIMS = [[46.8, W / 2, 31], [17.5, W / 2, 31]];           // on the partitions (sheet: on the ridge)

module face(x, side) on_face(BLOCKS[0], x, side) children();

// cut for an opening, drawn in a wall's face coordinates (local -z = into the building)
module win_cut(w, h, sill) translate([-ft(w / 2), ft(sill), -ft(1.5)]) cube([ft(w), ft(h), ft(2)]);
module door_cut(w, h) translate([-ft(w / 2), ft(FLOOR), -ft(1.5)]) cube([ft(w), ft(h + 1.3), ft(2)]);

// trim all the way round an opening: lining through the wall thickness (sash colour) and an oak
// casing on the inside face, with a stool and apron under windows (ESTIMATE profile, rev 3)
CAS = 0.45;                                    // inside casing width (ft)
module ring(w, h, z0, grow, inset) translate([0, ft(z0)]) difference() {
    translate([-ft(w / 2 + grow), -ft(grow)]) square([ft(w + 2 * grow), ft(h + 2 * grow)]);
    translate([-ft(w / 2 - inset), ft(inset)]) square([ft(w - 2 * inset), ft(h - 2 * inset)]);
}
module win_trim(w, h, sill) {
    paint("sash") translate([0, 0, -ft(T + 0.06)]) linear_extrude(ft(T + 0.06)) ring(w, h, sill, 0, 0.1);
    paint("oak") translate([0, 0, -ft(T + 0.16)]) linear_extrude(ft(0.1)) ring(w, h, sill, CAS, 0);
    paint("oak") {
        translate([-ft(w / 2 + CAS + 0.15), ft(sill - 0.12), -ft(T + 0.45)]) cube([ft(w + 2 * CAS + 0.3), ft(0.12), ft(0.4)]);   // stool
        translate([-ft(w / 2 + CAS), ft(sill - 0.12 - 0.5), -ft(T + 0.16)]) cube([ft(w + 2 * CAS), ft(0.5), ft(0.1)]);          // apron
    }
}
module door_trim(w, h) {
    hh = h + 1.3;                                                                    // door plus transom
    paint("sash") translate([0, 0, -ft(T + 0.06)]) linear_extrude(ft(T + 0.06)) difference() {
        ring(w, hh, FLOOR, 0, 0.1);
        translate([-ft(w), ft(FLOOR - 0.2)]) square([ft(2 * w), ft(0.3)]);           // no lining across the sill
    }
    paint("oak") translate([0, 0, -ft(T + 0.16)]) linear_extrude(ft(0.1)) difference() {
        ring(w, hh, FLOOR, CAS, 0);
        translate([-ft(w), ft(FLOOR - CAS - 0.1)]) square([ft(2 * w), ft(CAS + 0.1)]);
    }
}

// ---- operator's bay, hollow, a window on each face ----
BPTS = let (w = BAY[1], d = BAY[2]) [[-w / 2, 0], [w / 2, 0], [w / 2 - d * 0.7, d], [-w / 2 + d * 0.7, d]];
module bay_shape(grow = 0) offset(delta = ft(grow)) polygon([for (p = BPTS) [ft(p[0]), ft(p[1])]]);
module bay_faces() {                                   // children placed on the three bay faces
    x = BAY[0]; w = BAY[1]; d = BAY[2];
    fw = w - 2 * d * 0.7;  sw = sqrt(pow(d, 2) + pow(d * 0.7, 2));  ang = atan2(d, d * 0.7);
    translate([ft(x), ft(W + d - 0.1) + 0.01, 0]) rotate([90, 0, 180]) children(0);
    for (s = [-1, 1]) translate([ft(x + s * (w / 2 - d * 0.35)), ft(W - 0.1 + d / 2), 0])
        rotate([0, 0, -s * (90 - ang)]) translate([0, 0.02, 0]) rotate([90, 0, 180]) children(1);   // fixed 26 Nov: was turned the wrong way
}
BAY_FW = BAY[1] - 2 * BAY[2] * 0.7 - 2;
BAY_SW = min(sqrt(pow(BAY[2], 2) + pow(BAY[2] * 0.7, 2)) - 1.2, 2.4);
module op_bay() {
    x = BAY[0];
    paint("walls") difference() {
        translate([ft(x), ft(W - 0.1), ft(0.5)]) linear_extrude(ft(PLATE - 0.5)) bay_shape();
        translate([ft(x), ft(W - 0.1), ft(FLOOR)]) linear_extrude(ft(CEIL - FLOOR)) bay_shape(-T);
        fbox(x - BAY[1] / 2 + T, W - 1, FLOOR, BAY[1] - 2 * T, 1.2, CEIL - FLOOR);
        bay_faces() { win_cut(BAY_FW, WH, WS); win_cut(BAY_SW, WH, WS); }
    }
    paint("foundation") translate([ft(x), ft(W - 0.1), 0]) linear_extrude(ft(0.5)) bay_shape();
    paint("floor") translate([ft(x), ft(W - 0.1), ft(FLOOR - 0.2)]) linear_extrude(ft(0.2)) bay_shape(-T);
    if (SHOW_ROOF) paint("ceiling") translate([ft(x), ft(W - 0.1), ft(CEIL)]) linear_extrude(ft(0.2)) bay_shape(-T);
    paint("trim") translate([ft(x), ft(W - 0.1), ft(0.5)]) linear_extrude(ft(0.4)) difference() { bay_shape(0.15); bay_shape(-0.1); }
    bay_faces() { window(BAY_FW, WH, WS); window(BAY_SW, WH, WS); }
    bay_faces() { win_trim(BAY_FW, WH, WS); win_trim(BAY_SW, WH, WS); }
}

// ---- outside walls, hollow, with the openings cut ----
module walls() {
    paint("walls") difference() {
        fbox(0, 0, 0.5, L, W, PLATE - 0.5);
        fbox(T, T, FLOOR - 0.2, L - 2 * T, W - 2 * T, PLATE);
        for (o = WINS) face(o[0], o[1]) win_cut(o[2], o[3], o[4]);
        for (o = DOORS) face(o[0], o[1]) door_cut(o[2], o[3]);
        fbox(BAY[0] - BAY[1] / 2 + 0.6, W - 1, FLOOR, BAY[1] - 1.2, 2, CEIL - FLOOR - 1);   // into the bay
    }
    paint("foundation") fbox(0, 0, 0, L, W, 0.5);
    paint("floor") fbox(T, T, FLOOR - 0.2, L - 2 * T, W - 2 * T, 0.2);
    paint("foundation") fbox(T, T, 0.5, L - 2 * T, W - 2 * T, FLOOR - 0.7);
    if (SHOW_ROOF) paint("ceiling") fbox(T, T, CEIL, L - 2 * T, W - 2 * T, 0.2);
    // outside trim rings (belt at the wainscot line, water table, corner boards, frieze)
    paint("trim") {
        for (z = [[FLOOR + WAIN - 0.2, 0.35], [0.5, 0.4], [PLATE - 1.1, 0.35]]) difference() {
            fbox(-0.15, -0.15, z[0], L + 0.3, W + 0.3, z[1]);
            fbox(0.01, 0.01, z[0] - 0.1, L - 0.02, W - 0.02, z[1] + 0.2);
            for (o = DOORS) face(o[0], o[1]) door_cut(o[2] + 0.7, o[3]);
            fbox(BAY[0] - BAY[1] / 2, W - 0.5, 0, BAY[1], 1, PLATE);
        }
        for (x = [-0.25, L - 0.15], y = [-0.25, W - 0.15]) fbox(x, y, 0.5, 0.4, 0.4, PLATE - 0.5);
    }
}

// ---- the rooms (Sheet 130 plan; x from the baggage end) ----
// baggage 0.5-17.3 | women's 17.7-34.2 | office 34.6-46.6 (+ bay) | men's 47.0-63.5
PART = [17.5, 34.4, 46.8];                    // partition centres
TOIL = [9.7, 6.4];                            // toilet room in the baggage room's town corner: x from 9.7, y to 6.4
module partitions() {
    PT = 0.4;
    module wall_x(x) difference() {                          // full-width partition at x, with its doors and windows
        fbox(x - PT / 2, T, FLOOR, PT, W - 2 * T, CEIL - FLOOR);
        children();
    }
    paint("plaster") {
        wall_x(PART[0]) fbox(PART[0] - 1, 1.6, FLOOR, 2, 3, 7);                          // toilet door from the women's room
        wall_x(PART[1]) fbox(PART[1] - 1, 13.5, FLOOR + 3.6, 2, 3, 2.4);                 // ticket window, women's side
        wall_x(PART[2]) { fbox(PART[2] - 1, 4.5, FLOOR, 2, 3, 7);                        // door office - men's (sheet)
                          fbox(PART[2] - 1, 13.5, FLOOR + 3.6, 2, 3, 2.4); }             // ticket window, men's side
        difference() { fbox(TOIL[0], T, FLOOR, 0.3, TOIL[1] - T, CEIL - FLOOR); }       // toilet room walls
        fbox(TOIL[0], TOIL[1], FLOOR, PART[0] - TOIL[0], 0.3, CEIL - FLOOR);
    }
    // oak wainscot on every room wall (both faces of the partitions, inside of the outside walls)
    paint("oak") {
        for (i = [0 : 2]) let (x = PART[i]) difference() { fbox(x - 0.25, T, FLOOR, 0.5, W - 2 * T, WAIN - 0.3);
                                       if (i == 0) fbox(x - 1, 1.6, FLOOR, 2, 3, 7);
                                       if (i == 2) fbox(x - 1, 4.5, FLOOR, 2, 3, 7); }
        difference() {
            fbox(T, T, FLOOR, L - 2 * T, W - 2 * T, WAIN - 0.3);
            fbox(T + 0.06, T + 0.06, FLOOR - 0.1, L - 2 * T - 0.12, W - 2 * T - 0.12, WAIN);
            for (o = DOORS) face(o[0], o[1]) door_cut(o[2], o[3]);
            fbox(BAY[0] - BAY[1] / 2 + 0.6, W - 1, FLOOR, BAY[1] - 1.2, 2, CEIL);
        }
        for (x = PART) fbox(x - 0.3, T, FLOOR + WAIN - 0.35, 0.6, W - 2 * T, 0.12);      // cap rail on the partitions
    }
    // plaster lining above the wainscot, inside the outside walls
    paint("plaster") difference() {
        fbox(T, T, FLOOR + WAIN - 0.3, L - 2 * T, W - 2 * T, CEIL - FLOOR - WAIN + 0.3);
        fbox(T + 0.05, T + 0.05, FLOOR, L - 2 * T - 0.1, W - 2 * T - 0.1, CEIL);
        for (o = WINS) face(o[0], o[1]) win_cut(o[2], o[3], o[4]);
        for (o = DOORS) face(o[0], o[1]) door_cut(o[2], o[3]);
        fbox(BAY[0] - BAY[1] / 2 + 0.6, W - 1, FLOOR, BAY[1] - 1.2, 2, CEIL);
    }
    paint("oak") for (x = PART) fbox(x - 1.2, 13.3, FLOOR + 3.4, 2.4, 3.4, 0.2);        // ticket window shelves
}

// ---- furniture (ESTIMATE: typical small Milwaukee Road depot of the 1890s) ----
module bench(x0, y0, len, dir) paint("oak") {           // wall bench, back against the wall; dir 0 along x, 1 along y
    if (dir == 0) { fbox(x0, y0, FLOOR + 1.4, len, 1.5, 0.15); fbox(x0, y0 + (y0 < W / 2 ? 0 : 1.35), FLOOR + 1.4, len, 0.15, 1.1);
                    for (x = [x0 + 0.3 : 3 : x0 + len]) fbox(x, y0 + 0.2, FLOOR, 0.15, 1.1, 1.4); }
    else          { fbox(x0, y0, FLOOR + 1.4, 1.5, len, 0.15); fbox(x0 + (x0 < L / 2 ? 0 : 1.35), y0, FLOOR + 1.4, 0.15, len, 1.1);
                    for (y = [y0 + 0.3 : 3 : y0 + len]) fbox(x0 + 0.2, y, FLOOR, 1.1, 0.15, 1.4); }
}
module stove(x, y, chim_x) {                             // round iron stove with its pipe to the chimney at ceiling
    paint("metal") translate([ft(x), ft(y), ft(FLOOR)]) {
        cylinder(r = ft(1), h = ft(0.6), $fn = 24);
        translate([0, 0, ft(0.6)]) cylinder(r1 = ft(1), r2 = ft(0.85), h = ft(2.4), $fn = 24);
        translate([0, 0, ft(3)]) cylinder(r1 = ft(0.95), r2 = ft(0.3), h = ft(0.6), $fn = 24);
        cylinder(r = ft(0.25), h = ft(7), $fn = 12);
    }
    paint("metal") hull() { translate([ft(x), ft(y), ft(FLOOR + 7)]) sphere(r = ft(0.25), $fn = 12);
                            translate([ft(chim_x), ft(W / 2), ft(FLOOR + 8.5)]) sphere(r = ft(0.25), $fn = 12); }
    paint("foundation") fbox(x - 1.6, y - 1.6, FLOOR, 3.2, 3.2, 0.06);                  // stove board
}
module furniture() {
    // men's waiting room 47.0-63.5
    bench(48, T + 0.1, 9.5, 0);  bench(63.5 - 1.6, 8, 12, 1);  bench(54.7, W - T - 1.6, 6, 0);
    stove(51, 12, PART[2] - 0.6);
    // women's waiting room 17.7-34.2
    bench(18.2, T + 0.1, 12, 0);  bench(18.2, W - T - 1.6, 9.5, 0);
    stove(22, 12, PART[0] + 0.6);
    // office 34.6-46.6: telegraph table in the bay, ticket counter at the two windows, safe, desk
    paint("oak") { fbox(BAY[0] - 4, W - 0.4, FLOOR + 2.4, 8, 2.2, 0.15);                // operator's table across the bay
                   for (x = [BAY[0] - 3.7, BAY[0] + 3.5]) fbox(x, W - 0.2, FLOOR, 0.2, 1.8, 2.4);
                   fbox(35, 12.8, FLOOR, 1.8, 4.4, 3.4);  fbox(44.6, 12.8, FLOOR, 1.8, 4.4, 3.4);   // ticket counters
                   fbox(38, T + 0.2, FLOOR, 5, 2.4, 2.5); }                               // agent's desk
    paint("metal") { fbox(44.2, T + 0.2, FLOOR, 2, 2, 3);                              // safe
                     translate([ft(BAY[0] + 1.5), ft(W + 0.6), ft(FLOOR + 2.55)]) cube([ft(0.6), ft(0.4), ft(0.4)]); }   // telegraph key and sounder
    paint("oak") translate([ft(BAY[0]), ft(W - 1.4), ft(FLOOR)]) { cylinder(r = ft(0.7), h = ft(1.6), $fn = 16);   // operator's chair
                                                                     translate([-ft(0.7), ft(-0.75), 0]) cube([ft(1.4), ft(0.15), ft(3)]); }
    // baggage room 0.5-17.3: platform scale, two-wheel truck, trunks
    paint("metal") fbox(12, 10, FLOOR, 4, 3, 0.25);
    paint("metal") fbox(15.4, 10.2, FLOOR, 0.3, 0.3, 4);
    paint("oak") { fbox(2, 14, FLOOR, 3, 2, 1.8); fbox(2.2, 16.3, FLOOR, 2.6, 1.8, 1.4); fbox(5.5, 15, FLOOR, 2, 1.3, 1.2); }
    paint("metal") { fbox(9, 20, FLOOR + 0.3, 0.15, 1.5, 4.5); fbox(10.3, 20, FLOOR + 0.3, 0.15, 1.5, 4.5);
                     translate([ft(9.75), ft(20), ft(FLOOR + 0.6)]) rotate([0, 90, 0]) cylinder(r = ft(0.6), h = ft(1.9), center = true, $fn = 16); }
    // toilet room: closet and basin (sheet)
    paint("plaster") { fbox(15.5, T + 0.2, FLOOR, 1.4, 2, 1.5); fbox(10.2, T + 0.2, FLOOR + 2.4, 1.6, 1.2, 0.4); }
}

// chimneys from the ceiling up (stoves pipe into them)
module chimneys() for (c = CHIMS) paint("chimney") {
    fbox(c[0] - 0.8, c[1] - 0.8, CEIL - 1.5, 1.6, 1.6, c[2] - CEIL + 1.5);
    fbox(c[0] - 1, c[1] - 1, c[2] - 0.5, 2, 2, 0.5);
}

// ---- main roof: steep hip, ridge cresting, gables on both ends ----
GWID = 12.7;                                  // end gable width (sheet end elevation)
GRISE = (RIDGE - HZ) / (GWID / 2);
module hip_roof() {
    paint("roof") hull() {
        fbox(-OV, -OV, PLATE, L + 2 * OV, W + 2 * OV, 0.5);
        fbox(W / 2, W / 2 - 0.05, RIDGE, L - W, 0.1, 0.5);
    }
    paint("trim") fbox(-OV, -OV, PLATE - 0.6, L + 2 * OV, W + 2 * OV, 0.6);           // fascia
    paint("trim") difference() {                                                      // soffit board
        fbox(-OV + 0.2, -OV + 0.2, PLATE - 0.15, L + 2 * OV - 0.4, W + 2 * OV - 0.4, 0.15);
        fbox(0, 0, PLATE - 0.5, L, W, 1);
    }
    for (e = [0, 1]) end_gable(e);
    paint("roof") fbox(0, W / 2 - 0.4, RIDGE + 0.3, L, 0.8, 0.35);                   // ridge cap
    paint("trim") {                                                                   // cresting (ESTIMATE pattern)
        fbox(0, W / 2 - 0.08, RIDGE + 0.65, L, 0.16, 0.12);
        fbox(0, W / 2 - 0.08, RIDGE + 1.25, L, 0.16, 0.1);
        for (x = [0.5 : 1 : L - 0.4]) fbox(x, W / 2 - 0.06, RIDGE + 0.65, 0.12, 0.12, 0.85);
        for (x = [0, L - 0.4]) fbox(x, W / 2 - 0.2, RIDGE + 0.65, 0.4, 0.4, 1.6);       // end scrolls / finials
    }
}
module end_gable(e) {
    gx = e ? L : 0;  dirn = e ? -1 : 1;  deep = 13;  rk = 0.8;
    paint("roof") for (s = [-1, 1]) hull() {
        fbox(e ? gx - deep : gx - rk, W / 2 + s * (GWID / 2 + 0.6) - (s > 0 ? 0.1 : 0), HZ - 0.6 * GRISE, deep + rk, 0.1, 0.4);
        fbox(e ? gx - deep : gx - rk, W / 2 - 0.05, RIDGE, deep + rk, 0.1, 0.4);
    }
    paint("walls") hull() {                                                           // gable body
        fbox(e ? gx - deep : gx, W / 2 - GWID / 2, HZ - 0.5, deep, GWID, 0.1);
        fbox(e ? gx - deep : gx, W / 2 - 0.05, RIDGE - 0.3, deep, 0.1, 0.1);
    }
    paint("trim") for (s = [-1, 1]) hull() {                                          // rake boards
        fbox(e ? gx : gx - rk - 0.1, W / 2 + s * (GWID / 2 + 0.6) - 0.15, HZ - 0.6 * GRISE - 0.5, 0.3, 0.3, 0.5);
        fbox(e ? gx : gx - rk - 0.1, W / 2 - 0.15, RIDGE - 0.2, 0.3, 0.3, 0.5);
    }
    // twin gable windows (sheet); sided over by 2014 but kept to the plan
    for (dy = [-1.15, 1.15]) translate([e ? ft(gx) + 0.01 : ft(gx) - 0.01, ft(W / 2 + dy), 0]) rotate([90, 0, e ? 90 : -90]) window(1.6, 1.8, 18.2);
}

// ---- turret over the bay: octagon walls, flared eave, tall spire ----
function oct(af) = af / 2 / cos(22.5);
module turret() {
    x = TUR[0]; y = TUR[1]; af = TUR[2];  zb = 13;  zt = 18.7;  apex = 33.2;
    translate([ft(x), ft(y), 0]) {
        paint("walls") translate([0, 0, ft(zb)]) rotate(22.5) cylinder(r = ft(oct(af)), h = ft(zt - zb), $fn = 8);
        paint("trim")  translate([0, 0, ft(zt - 0.5)]) rotate(22.5) cylinder(r = ft(oct(af + 0.4)), h = ft(0.5), $fn = 8);
        paint("roof") hull() {                                                        // flared eave
            translate([0, 0, ft(zt + 0.6)]) rotate(22.5) cylinder(r = ft(oct(af + 5)), h = ft(0.3), $fn = 8);
            translate([0, 0, ft(zt + 1.8)]) rotate(22.5) cylinder(r = ft(oct(af + 0.8)), h = ft(0.3), $fn = 8);
        }
        paint("trim") translate([0, 0, ft(zt + 0.3)]) rotate(22.5) cylinder(r = ft(oct(af + 5)), h = ft(0.35), $fn = 8);
        paint("roof") translate([0, 0, ft(zt + 1.8)]) rotate(22.5) cylinder(r1 = ft(oct(af + 0.8)), r2 = ft(0.1), h = ft(apex - zt - 1.8), $fn = 8);
        paint("trim") { translate([0, 0, ft(apex - 0.5)]) cylinder(r = ft(0.15), h = ft(2.3), $fn = 12);
                        translate([0, 0, ft(apex + 0.8)]) sphere(r = ft(0.35), $fn = 16); }
        // windows on the three track-facing faces (sheet front elevation shows three)
        for (a = [-45, 0, 45]) rotate(a) translate([0, ft(af / 2) + 0.01, 0]) rotate([90, 0, 180]) window(1.9, 2.3, 15.9);
    }
}

// ---- long eave brackets (knee braces) ----
module bracket(o) paint("trim") linear_extrude(ft(0.35), center = true)        // drawn outward in +x, top at z=0
    polygon([[0, 0], [ft(o - 0.6), 0], [ft(o - 0.6), -ft(0.5)], [ft(0.6), -ft(0.5)], [ft(0.6), -ft(3.6)], [0, -ft(3.8)]]);
module brace(o) paint("trim") hull() {
    translate([ft(0.3), 0, -ft(3.4)]) cube([ft(0.3), ft(0.3), ft(0.3)], center = true);
    translate([ft(o * 0.7), 0, -ft(0.45)]) cube([ft(0.3), ft(0.3), ft(0.3)], center = true);
}
module brackets() {
    zb = PLATE - 0.15;
    BX = [0.4, 15, 26, 34.6, 47.4, 54.7, 63.6];                    // sheet front elevation, ESTIMATE on the town side
    for (x = BX, s = [0, 1]) translate([ft(x), s ? ft(W) : 0, ft(zb)]) rotate([0, 0, s ? 90 : -90]) { rotate([90, 0, 0]) bracket(OV); brace(OV); }
    for (y = [0.4, W / 2, W - 0.4], e = [0, 1]) translate([e ? ft(L) : 0, ft(y), ft(zb)]) rotate([0, 0, e ? 0 : 180]) { rotate([90, 0, 0]) bracket(OV); brace(OV); }
}

// ---- name boards on both ends (ESTIMATE) ----
module boards() for (e = [0, 1]) face(W / 2, e ? 3 : 2) {
    paint("trim") translate([-ft(4.8), ft(10.4), 0]) cube([ft(9.6), ft(1.3), ft(0.2)]);
    paint("doors") translate([-ft(4.5), ft(10.55), ft(0.2)]) cube([ft(9), ft(1), ft(0.05)]);
    paint("walls") translate([0, ft(10.7), ft(0.25)]) linear_extrude(ft(0.06))
        text("VIROQUA", size = ft(0.75), font = "Liberation Sans:style=Bold", halign = "center");
}

// ---- the depot ----
walls();
for (o = WINS)  face(o[0], o[1]) window(o[2], o[3], o[4]);
for (o = DOORS) face(o[0], o[1]) door(o[2], o[3], o[4]);
for (o = WINS)  face(o[0], o[1]) win_trim(o[2], o[3], o[4]);
for (o = DOORS) face(o[0], o[1]) door_trim(o[2], o[3]);
paint("platform") fbox(-12, W, 0, L + 24, 14, 0.6);
op_bay();
partitions();
furniture();
if (SHOW_ROOF) chimneys();
brackets();
boards();
if (SHOW_ROOF) { hip_roof(); turret(); }
