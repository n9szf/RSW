// =====================================================================
//  MILWAUKEE ROAD - WEST SALEM, WIS. PASSENGER STATION (1903)
//  HAND-BUILT (26 Nov 2026) - not written by the album generator; do not overwrite.
//  Source: Album of Depot Plans 1919, Sheet 62, drawing A-3845, Chicago Aug. 17 1903
//  (C.M.&St.P. Bridge and Building Dept.): track elevation, end elevation, floor plan,
//  section through the freight house.  Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  The depot is gone (north side of the tracks, east of Leonard St.); modelled as built, 1903.
//
//  KNOWN (from the sheet):
//   - 131'-8" x 24'-0" brick building.  Rooms west to east: women's waiting 21'-6",
//     office 16'-0" (13'6" x 19'0", canted bay on the track side), men's waiting 19'-10"
//     (21'6" x 19'4"), freight room 74'-4" (21'10" x 73'3", 7' x 8' scale).
//   - Passage along the town side behind the office with a seat alcove bumped out.
//   - Passenger end: brick with stone base and banded stone corners, steep hip roof
//     "shingled roof stained" with finials, bracketed frieze under wide eaves.
//   - Freight end: plain brick, lower hip roof (shingle), two paneled double freight
//     doors each side (about 67'6" and 101' from the west end), door in the east end.
//   - Three chimneys: west end wall, office, men's room / freight wall.  Stoves in all three rooms.
//   - Eaves about 7 ft out on the passenger end, 6 ft on the freight end (dashed roof line on the plan).
//  ESTIMATE (scaled or guessed - nothing written on the sheet):
//   - All heights: floor 1.5 ft, wall/frieze about 11.5 ft, eave edge 11.2 ft, ridge 26.7 ft
//     (passenger) and 21.5 ft (freight), scaled off the track elevation.  The bell-cast
//     kick over the eaves is drawn as a flatter second pitch.
//   - Town side windows and the alcove windows (plan only), east-end windows and door.
//   - Window and door sizes, sash pattern, frieze bracket spacing, stone quoin pattern.
//   - Platform (cinder/plank, 14 ft wide).
//   - COLOURS: no colour photo found.  Red-brown brick, buff stone, dark gray trim and sash,
//     dark stained shingles.
//  Shared builder ../../../_common/rsw_depot.scad (data: x along the track from the WEST end,
//  y = 0 town (north) side, track (south) side +y, feet; whole model mirrored in x at the end).  SCALE: 29 = G, 48 = O, 87 = HO.
//  NOT cut into print sections yet.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

// COLOURS - ESTIMATE (no photo; Tom 26 Nov 2026: brick colour)
COL_BRICK = "#8E4A36";   // red-brown pressed brick
COL_STONE = "#A99B80";   // buff stone base and quoins
COL_FOUND = "#A99B80";
COL_TRIM  = "#55585A";   // dark gray frieze, brackets, fascia
COL_SASH  = "#55585A";
COL_ROOF  = "#4A3F3A";   // stained shingles
PAINTS = [["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM], ["roof", COL_ROOF],
          ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT],
          ["chimney", "#7E4030"], ["sash", COL_SASH]];

FLOOR = 1.5;
L   = 131.67;            // overall length
W   = 24;                // width
XP  = 58.4;              // passenger end (21'6" + 16'0" + 19'10" + walls)
FRZ = 10.3;              // bottom of the bracketed frieze

// blocks: [x0, len, y0, wid, plate_h, rise, roof, overhang, siding]  roof 5 = drawn below
BLK = [[0,  XP,     0,    W,   13.2, 0, 5, 0, 2],     // 0 passenger end
       [XP, L - XP, 0,    W,   12.8, 0, 5, 0, 2],     // 1 freight room
       [21, 16.6,  -2.8,  2.8, 11.6, 0, 5, 0, 2]];    // 2 seat alcove (town side)

WIN = 3.0; WH = 6.5; SILL = FLOOR + 1.8;      // tall sash up to the frieze, as drawn
wins = [
    // track side (south): women's, men's
    [7.9, 1, WIN, WH, SILL], [18.0, 1, WIN, WH, SILL],
    [42.9, 1, WIN, WH, SILL], [52.9, 1, WIN, WH, SILL],
    // town side (north): women's, men's (plan), alcove (plan, high sills over the seat)
    [6.5, 0, WIN, WH, SILL], [12.0, 0, WIN, WH, SILL], [17.0, 0, WIN, WH, SILL],
    [42.0, 0, WIN, WH, SILL], [46.5, 0, WIN, WH, SILL], [51.0, 0, WIN, WH, SILL],
    [25.6, 0, 3.0, 3.5, FLOOR + 4.3, 2], [34.3, 0, 3.0, 3.5, FLOOR + 4.3, 2],
    // west end (women's room), either side of the chimney
    [5.5, 2, WIN, WH, SILL], [18.5, 2, WIN, WH, SILL],
    // east end of the freight room - ESTIMATE
    [4.5, 3, 2.6, 4, FLOOR + 3.5, 1], [19.5, 3, 2.6, 4, FLOOR + 3.5, 1]];
doors = [
    [13.1, 1, 3, 7, 0], [48.0, 1, 3, 7, 0],                       // waiting room doors, track side
    [67.5, 1, 5.5, 8.5, 1, 1], [101, 1, 5.5, 8.5, 1, 1],          // freight doors, track side
    [67.5, 0, 5.5, 8.5, 1, 1], [101, 0, 5.5, 8.5, 1, 1],          // freight doors, town side
    [12, 3, 5, 8.5, 1, 1]];                                       // east end
BAY   = [29.3, 1, 14.8, 3.9];                                     // office bay, track side (drawn below, kept under the eave)
chims = [[0.8, 12, 27.4], [23, 8, 30.4], [XP, 12, 27.4]];

// ---- two-pitch hip roof: flat kick over the eave, steep main pitch to the ridge ----
module hip2(x0, l, y0, w, ov, edge, knee, ridge, xr0, xr1, ovx0 = -1) {
    o0 = ovx0 < 0 ? ov : ovx0;                       // overhang at the x-min end
    paint("roof") {
        hull() { fbox(x0 - o0, y0 - ov, edge, l + o0 + ov, w + 2 * ov, 0.4); fbox(x0, y0, knee, l, w, 0.4); }
        hull() { fbox(x0, y0, knee, l, w, 0.4); fbox(xr0, y0 + w / 2 - 0.05, ridge, xr1 - xr0, 0.1, 0.4); }
    }
    paint("trim") fbox(x0 - o0, y0 - ov, edge - 0.5, l + o0 + ov, w + 2 * ov, 0.5);   // fascia
}
module finial(x, y, z) paint("trim") {
    translate([ft(x), ft(y), ft(z)]) { cylinder(r = ft(0.25), h = ft(1.6), $fn = 12);
        translate([0, 0, ft(1.9)]) sphere(r = ft(0.45), $fn = 16); }
}
// bracketed frieze along a wall run (x along the wall, side 0 town / 1 track) and stone work
module frieze_run(x0, x1, y, s) paint("trim") {
    fbox(x0, s ? y : y - 0.3, FRZ, x1 - x0, 0.3, 1.5);
    for (x = [x0 + 0.6 : 2.2 : x1 - 0.4]) fbox(x - 0.15, s ? y : y - 1.0, FRZ + 0.2, 0.3, 1.0, 1.3);
}
module frieze_end(y0, y1, x, s) paint("trim") {
    fbox(s ? x : x - 0.3, y0, FRZ, 0.3, y1 - y0, 1.5);
    for (y = [y0 + 0.6 : 2.2 : y1 - 0.4]) fbox(s ? x : x - 1.0, y - 0.15, FRZ + 0.2, 1.0, 0.3, 1.3);
}
module knee(x, y, ang, ov) paint("trim")             // big curved knee brace at the corners (end elevation)
    translate([ft(x), ft(y), ft(FRZ - 2.4)]) rotate([0, 0, ang]) rotate([90, 0, 0]) translate([0, 0, -ft(0.15)])
        linear_extrude(ft(0.3)) polygon([[0, 0], [0, ft(2.4)], [ft(ov * 0.7), ft(2.4)], [ft(0.4), ft(0.4)]]);
module quoins(sy) paint("stone")                        // banded stone at a west corner; sy -1 town, +1 track
    for (k = [0 : 7]) { long = k % 2 == 0 ? 1.6 : 1.0; z = SILL + k * 0.85;
        fbox(-0.15, sy < 0 ? -0.15 : W, z, long, 0.15, 0.7);             // on the long side
        fbox(-0.15, sy < 0 ? 0 : W - long, z, 0.15, long, 0.7); }       // on the west end

module west_salem() {
    depot(blocks = BLK, wins = wins, doors = doors, chims = chims,
          plat = [-8, L + 16, 14, 0.5]);
    bay(BLK[0], BAY[0], BAY[1], BAY[2], BAY[3], 11.6, 2);
    // roofs
    hip2(0, XP, 0, W, 7, 11.2, 13.2, 26.7, 12.9, XP - 12.9);
    hip2(50, L - 50, 0, W, 6, 11.2, 12.8, 21.5, 47, L - 12, 0);
    finial(12.9, 12, 26.9); finial(XP - 12.9, 12, 26.9); finial(L - 12, 12, 21.7);
    paint("trim") fbox(12.9, 11.85, 26.9, XP - 25.8, 0.3, 0.3);           // ridge cap
    // frieze and knee braces
    frieze_run(0, 21, 0, 0); frieze_run(37.6, L, 0, 0); frieze_run(21, 37.6, -2.8, 0);
    frieze_run(0, L, W, 1);
    frieze_end(0, W, 0, 0); frieze_end(0, W, L, 1);
    for (c = [[0, 0, 225], [0, W, 135], [L, 0, -45], [L, W, 45]]) knee(c[0], c[1], c[2], 6);
    // stone base on the passenger end (to the sills) and banded corners
    paint("stone") {
        fbox(-0.15, -0.15, 0.5, XP + 0.15, 0.15, SILL - 0.5);     // town side
        fbox(-0.15, W, 0.5, XP + 0.15, 0.15, SILL - 0.5);         // track side
        fbox(-0.15, 0, 0.5, 0.15, W, SILL - 0.5);                 // west end
        fbox(21, -2.95, 0.5, 16.6, 0.15, SILL - 0.5);             // alcove
        fbox(XP - 0.6, -0.3, 0.5, 1.2, 0.3, FRZ - 0.5);           // pier at the freight wall, both sides
        fbox(XP - 0.6, W, 0.5, 1.2, 0.3, FRZ - 0.5);
    }
    quoins(-1); quoins(1);
    // iron scroll stay on the west chimney (track elevation)
    paint("trim") fbox(0.8, 11.9, 22.5, 3.5, 0.2, 0.2);
}
// The data above run west to east (as the sheet is drawn).  Mirrored so the model has the
// right hand: seen from the track (+y), the passenger (west) end is on the LEFT, as on the sheet.
translate([ft(L), 0, 0]) mirror([1, 0, 0]) west_salem();
