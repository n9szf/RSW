// =====================================================================
//  MILWAUKEE ROAD - EDGERTON, WIS. PASSENGER DEPOT (1906-07)
//  HAND-BUILT - do not overwrite with the album generator.
//  Rib Side Works, 26 Nov 2026 - rev 4: details and colours from Tom's photos (IMG_8914-8924,
//  Sep 2026): flat beadboard soffit under the eaves, knee brackets with a long top arm,
//  pavilion with flat beadboard ceiling, round tan columns, gray-capped brick piers, curved
//  brackets at the eave.  rev 3: shape and openings from album sheet 58.  rev 1-2: NRHP + web photos.
//
//  SOURCES
//   - Album sheet 58, drawing A-7532, Chicago June 19 1906, J. A. Lindstrand architect:
//     track side elevation, pavilion end elevation, floor plan, half sections.  Private
//     reference (in copyright): Research Library / RSW / Stations / Standard depots /
//     Album of Depot Plans 1919.  Scale used: 11.75 px per ft on the 2560 px scan.
//   - NRHP nomination 98000283 (1997): materials, 1939 alterations (PRESENT = true).
//   - Tom's photos, Sep 2026 (Research Library / RSW / Stations / Wisconsin / Edgerton /
//     Photos (private)): soffits, brackets, pavilion, bay brickwork, colours.
//   - Wikipedia photos 13 and 14 (2008-10): track side and town side.
//
//  KNOWN (sheet 58)
//   - 128 ft overall: building 98 x 24 + pavilion 30 (posts 14'5" and 15'7" apart).
//     Rooms W to E: baggage 24'0", smoking 20'0" (21'10 x 20), office 14'0" with the
//     bay, general waiting 36'4" (36'4 x 21'10).  Coal room and boiler in the baggage room.
//   - ROOF: one 1/4-pitch hip over the whole 128 ft (rise 0.5 per ft), eave about 12.5 ft
//     above the ground, overhang about 8 ft, ridge about 22.5 ft; over the smoking room,
//     office and waiting room a 1/2-pitch (45 deg) hip rises out of it, ridge about 27.7 ft,
//     ridge from about 38 to 85 ft.  The half section shows the steep roof springing at the
//     wall and the 1/4-pitch skirt carried out to the eave.  "Stained shingle roof".
//   - Track side: baggage double door, 1 window in the baggage room, 1 in the smoking
//     room, smoking-room door, office bay (14 ft, 3 ft out, cut corners, diamond sash in
//     front and on both cut corners), waiting-room door, two pairs of windows.
//   - Town side: baggage door, coal-room window, 2 smoking-room windows, lavatory bay
//     (about 15 ft long, 5 ft out, under the eave - men's and women's toilets), two pairs
//     of waiting-room windows.  West end: one window.  East end: a pair.
//   - Chimneys: one beside the west hip of the steep roof (boiler flue, x 27), one on the
//     ridge over the office (x 54); tops about 32.8 ft.
//   - Pavilion: round wooden columns on concrete/brick piers about 5 ft high: one at the
//     building, a pair midway, three (L) at each outer corner.  Columns to about 10.4 ft.
//   - Floor about 1.2 ft above the platform; window sills (belt course) about 4.0 ft,
//     heads about 10.6 ft; doors with transoms, heads about 10.2 ft.
//  ESTIMATE: wall top 16 ft (hidden under the eave), bracket size, lavatory bay windows,
//   window and door sash detail, the semaphore (not on the sheet; NRHP says one stood on
//   the roof over the bay), 1907 colours (photo colours used).
//  ERA: PRESENT = false is 1907 as built (default); true = after the 1939 remodel (NRHP)
//   and the museum entrance (photos).
//  Data below: x = 0 at the WEST end; the model is mirrored at the end so the pavilion
//  is at x = 0 (see edgerton()).  y = 0 town (north) side, track (south) side +y, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
PRESENT = false;

// COLOURS from Tom's photos (Sep 2026) and Wikipedia photo 13
COL_BRICK = "#5B3A2E";   // dark brown vitrified brick
COL_STONE = "#B8AB94";   // concrete / cast-stone belt course, sills, base
COL_FOUND = "#B8AB94";
COL_TRIM  = "#9A968C";   // gray paint: beadboard soffits, brackets, fascia, pier caps
// columns: tan-brown #7E6247 (written straight into PAINTS - a new variable there is not seen)
COL_ROOF  = "#5A5C5E";   // dark gray asphalt now (2008 photo: light gray; 1907: stained shingles - ESTIMATE)
COL_SASH  = "#4C5664";   // slate blue-gray sash and doors
COL_DOOR  = "#4C5664";
COL_PLAT  = "#8A4A3A";   // brick platform
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT],
          ["chimney", COL_BRICK], ["sash", COL_SASH], ["columns", "#7E6247"]];
FLOOR = 1.2;

L = 98;  W = 24;  PL = 30;             // building length, depth, pavilion length (sheet)
EAVE = 12.5;  OV = 8;  R_LOW = 0.5;    // the 1/4-pitch roof over everything (sheet)
R_HIGH = 1.0;                          // the 1/2-pitch roof over the centre (sheet)
HX0 = 26;  HL = 71;                    // steep roof from x 26 to 97 (ridge 38-85 as drawn)
PLATE_HI = 15.7;                       // where the steep roof springs: ridge = 15.7 + 12 = 27.7
RIDGE_LO = EAVE + R_LOW * (W / 2 + OV);        // 22.5
RIDGE_HI = PLATE_HI + R_HIGH * W / 2;          // 27.7
SOFFIT = EAVE - 0.1;                           // flat beadboard soffit under the eaves (photos)
WALLTOP = SOFFIT;
function soffit(d) = SOFFIT;
SILL = 4.0;  WH = 6.6;                 // belt course = window sills; window height
DH = 7.7;                              // door leaf height (transom above, head about 10.2)
BX = 51.5;  BW = 14;  BD = 3;  BC = 3.5;   // office bay: centre, width, depth, corner cut (x run)
BAYTOP = soffit(BD);
LX0 = 43.2;  LL = 15.2;  LD = 5;       // lavatory bay (town side)

BLOCKS = [[0, L, 0, W, WALLTOP, R_LOW, 5, OV, 2],               // 0 the building (roofs drawn below)
          [LX0, LL, -LD, LD, soffit(LD), R_LOW, 5, 0, 2]];      // 1 lavatory bay, under the eave

// ---- openings: [x, side, w, h, sill, blk] ------------------------------------
PAIRS = [71.2, 76.8, 84.8, 90.3];      // waiting-room window pairs, both sides (sheet plan)
W1907 = concat(
    [[21.2, 1, 3.6, WH, SILL], [32.3, 1, 3.6, WH, SILL]],                          // track: baggage, smoking
    [for (x = PAIRS) [x, 1, 3.8, WH, SILL]],
    [[22.6, 0, 3, WH, SILL], [33.7, 0, 3.6, WH, SILL], [39.7, 0, 3.6, WH, SILL]],  // town: coal room, smoking
    [for (x = PAIRS) [x, 0, 3.8, WH, SILL]],
    [[47, 0, 2, 2.5, 7, 1], [54.5, 0, 2, 2.5, 7, 1]],                              // lavatory bay (ESTIMATE)
    [[11.8, 2, 3.5, 3, 8]],                                                        // west end (NRHP: high window)
    [[9.2, 3, 3.8, WH, SILL], [14.6, 3, 3.8, WH, SILL]]);                          // east end pair
W1939 = concat(
    [[21.2, 1, 3.6, WH, SILL], [32.3, 1, 3.6, WH, SILL]],
    [for (x = PAIRS) [x, 1, 3.8, WH, SILL]],
    [[22.6, 0, 3, 2.5, 8], [33.7, 0, 3, 2.5, 8], [39.7, 0, 3.6, WH, SILL]],        // two cut down to small high windows
    [for (x = PAIRS) [x, 0, 3.8, WH, SILL]],
    [[55, 0, 2, 2.5, 7, 1]],
    [[9.2, 3, 3.8, WH, SILL]]);
// doors: [x, side, w, h, type, blk]  type 0 passenger, 1 double, 2 sliding
D1907 = [[13.6, 1, 5.5, DH, 1],          // baggage room, track side
         [12.9, 0, 5.5, DH, 1],          // baggage room, town side
         [40.2, 1, 3.5, DH, 0],          // smoking room
         [63.6, 1, 3.5, DH, 0]];         // general waiting room
D1939 = [[13.6, 1, 5.5, DH, 1],
         [12.9, 0, 7, 8.5, 2],           // town side wood slider
         [40.2, 1, 4, DH, 1],            // double door with transom (photo 13)
         [63.6, 1, 3, DH, 0],            // narrowed (NRHP)
         [14.6, 3, 3.5, DH, 0],          // east end: window became the waiting-room door (NRHP)
         [11.8, 2, 8, 8.5, 2],           // west end slider
         [49, 0, 3.2, 7.2, 0, 1]];       // museum entrance in the lavatory bay (photo 14)

// ---- walls, sills, base -------------------------------------------------------
module stone_courses() paint("stone") {
    for (b = [[0, L, 0, W], [LX0, LL, -LD, LD]]) {
        fbox(b[0] - 0.2, b[2] - 0.2, 0, b[1] + 0.4, b[3] + 0.4, 1.0);               // concrete base
        fbox(b[0] - 0.25, b[2] - 0.25, SILL - 0.45, b[1] + 0.5, b[3] + 0.5, 0.45);  // belt course = sills
    }
}
// rusticated brick pilasters at the corners and at the baggage/smoking partition (sheet)
PILS = [[0, 1.9], [25.8, 2.0], [96.1, 1.9]];
module pilasters() paint("brick") for (p = PILS) {
    for (y = [-0.25, W]) fbox(p[0], y, 0.5, p[1], 0.25, WALLTOP - 0.5);
    for (z = [SILL + 0.3 : 0.9 : WALLTOP - 1.5], y = [-0.33, W + 0.25]) fbox(p[0] - 0.08, y, z, p[1] + 0.16, 0.08, 0.45);
}
module end_pilasters() paint("brick") for (x = [-0.25, L], y = [0, W - 1.9]) fbox(x, y, 0.5, 0.25, 1.9, WALLTOP - 0.5);

// ---- office bay, track side, cut corners --------------------------------------------
BAYPTS = [[BX - BW / 2, W], [BX + BW / 2, W], [BX + BC, W + BD], [BX - BC, W + BD]];
module bay_shape(grow = 0) offset(delta = ft(grow)) polygon([for (p = [BAYPTS[0], BAYPTS[3], BAYPTS[2], BAYPTS[1]]) [ft(p[0]), ft(p[1])]]);
// place a child drawn on a wall face (x along, y up, z out) on the face p1 -> p2 (outside on the right)
module on_seg(p1, p2) {
    a = atan2(p2[1] - p1[1], p2[0] - p1[0]);
    translate([ft((p1[0] + p2[0]) / 2), ft((p1[1] + p2[1]) / 2), 0]) rotate([0, 0, a]) translate([0, -0.02, 0]) rotate([90, 0, 0]) children();
}
BAYFACES = [[BAYPTS[1], BAYPTS[2], 2.2], [BAYPTS[2], BAYPTS[3], 4.6], [BAYPTS[3], BAYPTS[0], 2.2]];   // right cut, front, left cut
module office_bay() {
    paint("brick") translate([0, 0, ft(0.5)]) linear_extrude(ft(BAYTOP - 0.5)) bay_shape();
    paint("stone") { linear_extrude(ft(1)) bay_shape(0.2);
                     translate([0, 0, ft(SILL - 0.45)]) linear_extrude(ft(0.45)) bay_shape(0.25); }
    for (f = BAYFACES) on_seg(f[0], f[1]) diamond_window(f[2], WH);
    // rusticated brick at the four corners of the bay
    paint("brick") intersection() {
        for (z = [SILL + 0.2 : 0.9 : BAYTOP - 1]) translate([0, 0, ft(z)]) linear_extrude(ft(0.45)) bay_shape(0.08);
        for (x = [BX - BW / 2, BX - BC, BX + BC, BX + BW / 2]) translate([ft(x - 0.8), ft(W - 1), 0]) cube([ft(1.6), ft(BD + 2), ft(WALLTOP)]);
    }
}
// window with a diamond-pane upper sash; drawn on a face (x along, y up, z out)
module diamond_window(w, h) {
    paint("glass") translate([-ft(w) / 2, ft(SILL), -ft(0.05)]) cube([ft(w), ft(h), ft(0.08)]);
    paint("sash") linear_extrude(ft(0.25)) translate([0, ft(SILL)]) {
        difference() { translate([-ft(w / 2 + 0.3), -ft(0.1)]) square([ft(w + 0.6), ft(h + 0.4)]);
                       translate([-ft(w / 2), 0]) square([ft(w), ft(h)]); }
        translate([-ft(w / 2), ft(h / 2 - 0.1)]) square([ft(w), ft(0.2)]);          // meeting rail
        intersection() {
            translate([-ft(w / 2), ft(h / 2)]) square([ft(w), ft(h / 2)]);
            for (k = [-3 : 3], a = [45, -45]) translate([ft(k * w / 2), ft(h * 0.75)]) rotate(a) square([ft(0.12), ft(12)], center = true);   // a few large diamonds (photos)
        }
    }
}

// ---- brick detail (photo 13) ----------------------------------------------------------
QD = 0.08;                                   // how far the detail stands out (ft)
module jamb_quoins(w, z0, z1) paint("brick") {
    n = floor((z1 - z0) / 0.9);
    for (i = [0 : n - 1], sd = [-1, 1]) let (len = i % 2 ? 1.1 : 0.7)
        translate([sd > 0 ? ft(w / 2 + 0.3) : -ft(w / 2 + 0.3 + len), ft(z0 + i * 0.9), 0]) cube([ft(len), ft(0.8), ft(QD)]);
    translate([-ft(w / 2 + 0.6), ft(z1 + 0.15), 0]) cube([ft(w + 1.2), ft(0.8), ft(QD)]);     // soldier course
}
module opening_details(B, list, isdoor) for (o = list) if (o[1] <= 1 && o[5] == undef)
    on_face(B, o[0], o[1]) let (z0 = isdoor ? FLOOR : o[4], z1 = isdoor ? FLOOR + o[3] + (o[4] == 2 ? 0 : 1.3) : o[4] + o[3])
        if (!(isdoor && o[4] == 2)) jamb_quoins(o[2], z0, z1);
// stone steps at the passenger doors (sheet elevation)
module steps(list) paint("stone") for (d = list) if (d[1] == 1 && d[4] != 2 && d[0] > 30) {
    fbox(d[0] - d[2] / 2 - 1, W, 0, d[2] + 2, 1.7, 0.6);
    fbox(d[0] - d[2] / 2 - 0.7, W, 0.6, d[2] + 1.4, 0.85, 0.6);
}

// ---- roofs --------------------------------------------------------------------------
// the 1/4-pitch hip over the whole 128 ft with a flat beadboard soffit under its eaves
// (photos); the 1/2-pitch hip rises out of it.
module roofs() {
    paint("roof") {
        roof_solid(-OV, L + PL + 2 * OV, -OV, W + 2 * OV, EAVE, R_LOW, 0);
        roof_solid(HX0, HL, 0, W, PLATE_HI, R_HIGH, 0);
    }
    paint("trim") {
        fbox(-OV, -OV, SOFFIT, L + PL + 2 * OV, W + 2 * OV, 0.1);                          // soffit
        difference() {                                                                   // fascia
            fbox(-OV, -OV, EAVE - 0.6, L + PL + 2 * OV, W + 2 * OV, 0.7);
            fbox(-OV + 0.25, -OV + 0.25, EAVE - 0.7, L + PL + 2 * OV - 0.5, W + 2 * OV - 0.5, 0.9);
        }
    }
}
module gutter() paint("foundation") {
    E0 = EAVE - 0.2;  X0 = -OV - 0.15;  X1 = L + PL + OV + 0.15;  Y0 = -OV - 0.15;  Y1 = W + OV + 0.15;
    for (y = [Y0, Y1]) translate([ft(X0), ft(y), ft(E0)]) rotate([0, 90, 0]) cylinder(r = ft(0.25), h = ft(X1 - X0), $fn = 12);
    for (x = [X0, X1]) translate([ft(x), ft(Y0), ft(E0)]) rotate([-90, 0, 0]) cylinder(r = ft(0.25), h = ft(Y1 - Y0), $fn = 12);
}

// ---- brackets: knee brackets under the flat soffit (photos IMG_8919-8921) -------------------
// drawn in x-z: x outward from the wall, z down from the soffit: a wall leg, a long top arm
// running past the curved brace, scroll-cut ends (as small steps)
module bracket(out, bh, s = 0) {
    rotate([90, 0, 0]) linear_extrude(ft(0.45), center = true) {
        translate([0, -ft(bh)]) square([ft(0.5), ft(bh)]);                          // leg
        translate([0, -ft(0.5)]) square([ft(out + 0.9), ft(0.5)]);                  // top arm
        translate([ft(out + 0.5), -ft(0.75)]) square([ft(0.4), ft(0.3)]);           // arm end drop
        translate([ft(0.25), -ft(bh + 0.25)]) square([ft(0.25), ft(0.3)]);          // leg end drop
        translate([ft(out), -ft(bh)]) intersection() {                              // curved brace
            difference() { scale([out, bh]) circle(ft(1), $fn = 48); scale([out - 0.4, bh - 0.4]) circle(ft(1), $fn = 48); }
            translate([-ft(out), 0]) square([ft(out), ft(bh)]);
        }
    }
}
BR_TRACK = [9.5, 17.5, 26.8, 36.2, 44, 59, 67.5, 74, 81, 87.5, 94.5];   // on the piers between openings
BR_TOWN  = [4.5, 18, 26.8, 36.7, 42.5, 59.2, 67.5, 74, 81, 87.5, 94.5];
module brackets() paint("trim") {
    for (x = BR_TOWN)  translate([ft(x), 0, ft(SOFFIT)]) rotate([0, 0, 180]) bracket(3.6, 3.6);
    for (x = BR_TRACK) translate([ft(x), ft(W), ft(SOFFIT)]) bracket(3.6, 3.6);
    for (y = [3.5, 8, 16, 20.5]) translate([0, ft(y), ft(SOFFIT)]) rotate([0, 0, 90]) bracket(3.6, 3.6);   // west end
}

// ---- pavilion (sheet + photos IMG_8914-8917) ---------------------------------------------
// round tapered tan columns with moulded base and cap, on brick piers with a concrete base
// block and a gray-painted moulded cap; beams on the post lines; flat beadboard ceiling;
// big curved brackets from the beams out to the eave.
PIER = 5.1;  CTOP = 10.4;  BEAM0 = 10.7;  CEIL = 11.7;
module column(x, y) {
    paint("columns") {
        translate([ft(x), ft(y), ft(PIER + 0.55)]) cylinder(r1 = ft(0.55), r2 = ft(0.45), h = ft(CTOP - PIER - 0.55), $fn = 24);
        translate([ft(x), ft(y), ft(PIER + 0.3)]) cylinder(r = ft(0.7), h = ft(0.3), $fn = 24);     // base moulding
        translate([ft(x), ft(y), ft(CTOP)]) cylinder(r1 = ft(0.5), r2 = ft(0.7), h = ft(0.15), $fn = 24);
        fbox(x - 0.75, y - 0.75, CTOP + 0.15, 1.5, 1.5, BEAM0 - CTOP - 0.15);                        // cap
    }
}
// a pier carrying a group of columns: cols = list of [dx, dy] from the pier centre
module pier_group(x, y, px, py, cols) {
    paint("stone") fbox(x - px / 2 - 0.15, y - py / 2 - 0.15, 0, px + 0.3, py + 0.3, 1.3);       // concrete base
    paint("brick") fbox(x - px / 2, y - py / 2, 1.3, px, py, PIER - 2.0);
    paint("trim") hull() { fbox(x - px / 2, y - py / 2, PIER - 0.7, px, py, 0.1);                 // moulded cap
                           fbox(x - px / 2 - 0.3, y - py / 2 - 0.3, PIER - 0.1, px + 0.6, py + 0.6, 0.1); }
    paint("trim") fbox(x - px / 2 - 0.3, y - py / 2 - 0.3, PIER, px + 0.6, py + 0.6, 0.3);
    for (c = cols) column(x + c[0], y + c[1]);
}
PXS = [L + 0.5, L + 12.6, L + 26.2];                      // single, pair, corner three (14'5" and 15'7" spacing)
module portico() {
    for (y = [0.4, W - 0.4]) let (sy = y < W / 2 ? -1 : 1) {
        pier_group(PXS[0], y, 1.8, 1.8, [[0, 0]]);
        pier_group(PXS[1], y, 3.6, 2.0, [[-0.85, 0], [0.85, 0]]);
        pier_group(PXS[2], y - sy * 0.85, 3.6, 3.6, [[-0.85, sy * 0.85], [0.85, sy * 0.85], [0.85, -sy * 0.85]]);
    }
    paint("trim") {
        for (y = [-0.3, W - 0.5]) fbox(L, y, BEAM0, PL - 2.4, 0.8, SOFFIT - BEAM0);                  // beams up to the soffit
        fbox(L + PL - 2.6, -0.3, BEAM0, 0.8, W + 0.6, SOFFIT - BEAM0);
        fbox(L, 0.5, CEIL, PL - 2.6, W - 1, 0.1);                                                    // beadboard ceiling
        for (k = [0 : 2], y = [0, W]) translate([ft(PXS[k]), ft(y), ft(SOFFIT)]) rotate([0, 0, y < W / 2 ? 180 : 0]) bracket(OV - 0.8, 1.6);
        for (yy = [W / 2 - 6, W / 2 + 6]) translate([ft(L + PL - 2.2), ft(yy), ft(SOFFIT)]) bracket(OV - 0.8, 1.6);
    }
}

// ---- chimneys (corbelled tops, sheet) -------------------------------------------------
module chimney(x, y, top) paint("chimney") {
    fbox(x - 1.3, y - 1.3, 4, 2.6, 2.6, top - 4);
    if (top > RIDGE_HI + 2) {
        fbox(x - 1.55, y - 1.55, top - 1.6, 3.1, 3.1, 0.35);
        fbox(x - 1.45, y - 1.45, top - 0.9, 2.9, 2.9, 0.9);
    }
}

// ---- semaphore (train-order) signal on the roof over the office bay, 1907 (NRHP; ESTIMATE) ----
module signal_tower() {
    z0 = RIDGE_HI - 10;                       // the steep roof 2 ft inside the track wall
    paint("trim") fbox(BX - 0.35, W - 2.35, z0 - 1, 0.7, 0.7, RIDGE_HI + 9 - z0);
    paint("doors") for (s = [-1, 1]) translate([ft(BX + s * 0.35), ft(W - 2), ft(RIDGE_HI + 6.5)])
        rotate([0, s > 0 ? -60 : 240, 0]) cube([ft(4.5), ft(0.12), ft(0.7)]);
}
module platform_curb() paint("stone") fbox(-8, W + 12, 0, L + PL + 14, 1.2, 0.9);

// ---- the depot -------------------------------------------------------------------
// Built with x = 0 at the WEST end, then mirrored: with the town side at y = 0 and the
// track side +y, the pavilion (east end) must sit at low x to read right from the track.
// Final model: x = 0 at the east end of the pavilion, building x = 30-128.
module edgerton() {
    WINS = PRESENT ? W1939 : W1907;  DOORS = PRESENT ? D1939 : D1907;
    depot(blocks = BLOCKS, wins = WINS, doors = DOORS, plat = [-8, L + PL + 14, 13, 0.6]);
    stone_courses();
    pilasters();
    end_pilasters();
    office_bay();
    opening_details(BLOCKS[0], WINS, false);
    opening_details(BLOCKS[0], DOORS, true);
    steps(DOORS);
    roofs();
    gutter();
    brackets();
    portico();
    chimney(26.9, 12, 32.8);                                  // boiler flue, west of the steep roof
    chimney(54.4, 12, PRESENT ? RIDGE_HI + 1.3 : 32.4);       // on the ridge over the office (cut down by 2008)
    platform_curb();
    if (!PRESENT) signal_tower();
}
translate([ft(L + PL), 0, 0]) mirror([1, 0, 0]) edgerton();
