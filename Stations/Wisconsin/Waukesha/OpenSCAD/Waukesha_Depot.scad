// =====================================================================
//  MILWAUKEE ROAD - WAUKESHA, WIS. PASSENGER DEPOT (as altered 1906)
//  Source: Album sheet 143, drawing A-7509, Chicago May 24 1906 (J. U. Nettenstrom,
//  architect; C. F. Loweth, engr.) - floor plan only, 1/8" = 1'-0".  Private reference
//  (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Photos (web, see reference / Station photos web / Waukesha / index.csv):
//   01 WHS survey c.1979 (west end + town side), 02 WHS IM123287 24 May 1952 (east end,
//   pavilion), 03 O'Brien 1922 (pavilion at the edge of the freight-house view).
//  Rib Side Works, 26 Nov 2026.  HAND-BUILT rev 2 (rev 1 outside + best-guess 1906 interior).
//  Not cut into print sections.
//
//  KNOWN (sheet): plan about 86 x 26 ft (scaled off the sheet against its written
//   "about 18 1/2 or 19 ft" smoking room and "about 13'-6"" office); rooms W to E: baggage
//   ~15 ft, smoking room + toilets ~19 ft, general waiting ~38 ft with a 3-sided bay on
//   the track side, office + telegraph ~14 ft; brick platform on the track side;
//   "Pavilion" off the east end.  Door and window positions as altered in 1906.
//  KNOWN (photos): brick, one storey, gable roof along the track with wide eaves on
//   diagonal brackets, brackets under the gable rakes, round louvered vent in each gable,
//   segmental-arch heads on windows and doors, one tall opening in the west end, two
//   windows and a WAUKESHA name board on the east end, brick chimneys at the ridge,
//   open timber pavilion with hip roof and knee-braced posts.
//  INTERIOR (rev 2): rooms, partitions, inside doors, toilets, ticket window, counter,
//   telegraph table and flues from the sheet; finishes and fittings ESTIMATE, styled on
//   WHS photo "Railroad Employees at Waukesha" (1915, W013ISJ: beadboard walls and ceiling,
//   plank floor, big ornate base-burner stove on a long stovepipe, desks, wall clock) - which
//   office that photo shows is not certain.
//  ESTIMATE: every height (floor 1.5, wall plate 13, roof about 6.6/12, ridge ~20 ft),
//   overhangs, bracket spacing, window and door sizes, the bay roof, pavilion size and
//   posts, colours (B&W photos only: cream Waukesha brick assumed), sash, name-board style.
//  Data: x = 0 at the WEST (baggage) end, x along the track; y = 0 town side, track side
//  +y; feet.  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
INTERIOR = true;        // best-guess 1906 rooms and fittings
CUTAWAY = false;        // true: leave off the roof and ceilings to look inside

// COLOURS - ESTIMATE (black-and-white photos only).  Light brick in all three photos:
// taken as Waukesha cream brick (the C&NW depot and Hartland depot nearby are cream brick).
COL_BRICK = "#D3C49E";   // cream brick, slightly weathered
COL_FOUND = "#A8A398";   // limestone base
COL_TRIM  = "#55585A";   // dark gray: brackets, fascia, barge boards (Milwaukee Road standard)
COL_SASH  = "#3B3D3B";   // dark sash (1952 photo)
COL_DOOR  = "#4A2E1C";
COL_ROOF  = "#4E4A46";   // dark shingles (1952, 1979)
COL_PLAT  = "#8A4A3A";   // brick platform (sheet)
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT],
          ["chimney", COL_BRICK], ["sash", COL_SASH], ["arches", "#C2B28C"],
          ["sign_board", "#ECEAE2"], ["sign_letters", "#1E1E1E"],
          // interior (best guess, 1906)
          ["wainscot", "#8A5A32"], ["floor", "#A88456"], ["ceiling", "#9C7446"], ["oak", "#7E5230"],
          ["iron", "#2B2B2B"], ["brass", "#B8923A"], ["tile", "#ECEBE4"], ["board", "#161616"], ["plaster", "#E4D8BC"]];

L = 86;  W = 26;                 // plan (scaled off the sheet)
PLATE = 13;  RISE = 0.55;        // ESTIMATE
OV = 3;  RK = 2.5;               // eave and rake overhang, ESTIMATE
EAVE = PLATE - OV * RISE;
RIDGE = PLATE + RISE * W / 2;    // ~20.2 ft
WS = 3.3;  WH = 6.5;  WW = 3.2;  // typical window: sill, height, width (ESTIMATE)
DH = 8;                          // door height (ESTIMATE)
AR = 0.75;                       // segmental arch rise

MAIN = [0, L, 0, W, PLATE, RISE, 5, OV, 2];          // roof drawn below (kind 5)

// windows [x, side, w, h, sill]  side 0 town, 1 track, 2 west end, 3 east end
WINS = [[21, 1, WW, WH, WS], [28, 1, WW, WH, WS], [43, 1, WW, WH, WS], [81, 1, WW, WH, WS],
        [21.8, 0, WW, WH, WS], [31.7, 0, WW, WH, WS], [58, 0, WW, WH, WS], [79.3, 0, WW, WH, WS],
        [13.2, 2, 3.5, 7.5, 2.6],                                  // west end: one tall opening
        [7.2, 3, WW, WH, WS], [20, 3, WW, WH, WS]];                // east (office) end: two
// doors [x, side, w, h, type]
DOORS = [[7.8, 1, 6, DH, 1], [34, 1, 3.5, DH, 0], [67.8, 1, 3.5, DH, 0],
         [3.6, 0, 5, DH, 1], [69.5, 0, 3.5, DH, 0]];
BAY = [58, 1, 16, 4.6];          // general waiting room bay, track side (sheet)
CHIMS = [[14.1, 13.2, RIDGE + 3.5], [72.5, 17.8, RIDGE + 3.5]];   // baggage/smoking flue, office 12x12 flue
PAV = [L + 6, 30, 8, 18, 12, 0.5, 0, 2, 3, 2];   // pavilion: free-standing east of the depot (1952 photo), size and gap ESTIMATE

// chimneys: inside, the flues stand in the partitions (FLUES below), so the stacks start at the ceiling
module chimneys(z0) paint("chimney") for (c = CHIMS) { fbox(c[0] - 0.8, c[1] - 0.8, z0, 1.6, 1.6, c[2] - z0); fbox(c[0] - 1, c[1] - 1, c[2] - 0.5, 2, 2, 0.5); }
module shell() {
    depot(blocks = [MAIN], wins = WINS, doors = DOORS, plat = [-10, 140, 14, 0.4]);
    gable_ends(0, L, 0, W, PLATE, RISE, 1, 2);
    if (!CUTAWAY) { main_roof(); bay_roof(); chimneys(INTERIOR ? RCEIL : 4); }
    for (s = [0, 1]) eave_brackets(s);
    for (e = [0, 1]) { rake_brackets(e); oculus(e); }
    for (o = WINS)  on_face(MAIN, o[0], o[1]) arch_head(o[2], o[4] + o[3] + 0.5);
    for (o = DOORS) on_face(MAIN, o[0], o[1]) arch_head(o[2], FLOOR + o[3] + (o[4] == 2 ? 0 : 1.4));
    bay_walls();
    name_board();
    pavilion(PAV);
    pavilion_braces();
}
module waukesha() {
    if (INTERIOR) {
        difference() { shell(); color(COL_BRICK) { room_voids(); all_cuts(); } }
        interior();
    } else shell();
}

// ---- track-side bay of the general waiting room (sheet: 3 sides, a window in each) ----
BX = BAY[0];  BW = BAY[2];  BD = BAY[3];  BTOP = PLATE - 1.6;
BAYPTS = [[BX - BW / 2, W], [BX - BW / 2 + BD * 0.7, W + BD], [BX + BW / 2 - BD * 0.7, W + BD], [BX + BW / 2, W]];
BAYFACES = [[BAYPTS[0], BAYPTS[1], 3], [BAYPTS[1], BAYPTS[2], 6], [BAYPTS[2], BAYPTS[3], 3]];   // [p1, p2, window width]
module bay_shape(grow = 0) offset(delta = ft(grow)) polygon([for (p = BAYPTS) [ft(p[0]), ft(p[1])]]);
module on_seg(p1, p2) {                      // child drawn in the x-z plane, z out of the bay
    a = atan2(p2[1] - p1[1], p2[0] - p1[0]);
    translate([ft((p1[0] + p2[0]) / 2), ft((p1[1] + p2[1]) / 2), 0]) rotate([0, 0, a]) rotate([90, 0, 180]) children();
}
module bay_walls() {
    paint("brick") translate([0, 0, ft(0.5)]) linear_extrude(ft(BTOP - 0.5)) bay_shape();
    paint("foundation") linear_extrude(ft(0.5)) bay_shape();
    for (f = BAYFACES) on_seg(f[0], f[1]) { window(f[2], WH, WS); arch_head(f[2], WS + WH + 0.5); }
}

// ---- gable roof with rake overhang, fascia and barge boards ------------------
module main_roof() {
    paint("roof") roof_solid(-RK, L + 2 * RK, -OV, W + 2 * OV, EAVE, RISE, 1);
    paint("trim") {
        for (y = [-OV, W + OV - 0.2]) fbox(-RK, y, EAVE - 0.6, L + 2 * RK, 0.2, 0.6);        // fascia
        for (x = [-RK, L + RK - 0.2], s = [0, 1]) hull() {                                 // barge boards
            fbox(x, s ? W + OV - 0.2 : -OV, EAVE - 0.6, 0.2, 0.2, 0.7);
            fbox(x, W / 2 - 0.1, RIDGE - 0.6, 0.2, 0.2, 0.7);
        }
    }
}
// diagonal brackets under the long eaves (photos: about one per bay)
module eave_brackets(s) {
    yb = s ? W : 0;
    paint("trim") for (x = [3 : 6 : L - 2])
        if (!(s == 1 && abs(x - BAY[0]) < BAY[2] / 2 + 0.5))
            translate([ft(x), ft(yb), ft(PLATE - 3)]) rotate([0, 0, s ? 0 : 180]) rotate([90, 0, 90])
                linear_extrude(ft(0.35)) polygon([[0, 0], [0, ft(3)], [ft(OV * 0.8), ft(3 - OV * 0.8 * RISE)],
                                                   [ft(OV * 0.8 - 0.35), ft(3 - OV * 0.8 * RISE)], [0, ft(0.45)]]);
}
// brackets under the rakes on both gable ends (1979 photo: four per end)
module rake_brackets(e) {
    xw = e ? L : 0;
    paint("trim") for (y = [3, 8.5, 17.5, 23]) {
        ztop = PLATE + RISE * (W / 2 - abs(y - W / 2)) - 0.4;
        translate([ft(xw), ft(y + 0.17), ft(ztop - 2.6)]) mirror([e ? 0 : 1, 0, 0]) rotate([90, 0, 0])
            linear_extrude(ft(0.35)) polygon([[0, 0], [0, ft(2.6)], [ft(RK * 0.8), ft(2.6)], [0, ft(0.45)]]);
    }
}
// round louvered vent high in each gable
module oculus(e) {
    zc = PLATE + 3.3;  r = 1.3;
    translate([e ? ft(L) + 0.01 : -0.01, ft(W / 2), ft(zc)]) rotate([0, 90, 0]) mirror([0, 0, e ? 0 : 1]) {
        paint("arches") difference() { cylinder(r = ft(r + 0.45), h = ft(0.15), $fn = 48); translate([0, 0, -1]) cylinder(r = ft(r), h = 4, $fn = 48); }
        paint("trim") difference() { cylinder(r = ft(r), h = ft(0.08), $fn = 48); translate([0, 0, -1]) cylinder(r = ft(r - 0.2), h = 4, $fn = 48); }
        paint("trim") intersection() { cylinder(r = ft(r), h = ft(0.1), $fn = 48);
            for (k = [-4 : 4]) translate([ft(k * 0.3) - ft(0.06), -ft(r), 0]) cube([ft(0.12), ft(2 * r), ft(0.1)]); }   // louvres (vertical in this frame = horizontal on the wall)
        paint("glass") cylinder(r = ft(r - 0.1), h = ft(0.02), $fn = 48);
    }
}
// segmental brick arch over an opening whose square head is at z = top (feet), drawn on a wall face
module arch_head(w, top) {
    c = w + 0.7;  R = (c * c / 4 + AR * AR) / (2 * AR);
    translate([0, ft(top), 0]) {
        paint("arches") linear_extrude(ft(0.14)) difference() {
            intersection() { translate([0, -ft(R - AR) - ft(0)]) circle(r = ft(R + 0.9), $fn = 120); translate([-ft(c), 0]) square([ft(2 * c), ft(AR + 1.4)]); }
            intersection() { translate([0, -ft(R - AR)]) circle(r = ft(R), $fn = 120); translate([-ft(c), -1]) square([ft(2 * c), ft(AR + 1)]); }
        }
        paint("glass") linear_extrude(ft(0.06)) intersection() {            // fan light / glass to the arch
            translate([0, -ft(R - AR)]) circle(r = ft(R), $fn = 120); translate([-ft(w / 2), 0]) square([ft(w), ft(AR)]); }
    }
}
// small hip roof over the bay (the bay runs out past the eave line) - ESTIMATE
module bay_roof() roof(BX - BW / 2, BW, W, BD, BTOP, 0.5, 0, 0.6);
// WAUKESHA name board on the east end, above the windows (1952 photo); style ESTIMATE
module name_board() {
    bw = 9;  bh = 1.3;  z0 = WS + WH + AR + 0.9;
    translate([ft(L) + 0.02, ft(W / 2), ft(z0)]) rotate([90, 0, 90]) {
        paint("sign_board") translate([-ft(bw / 2), 0, 0]) cube([ft(bw), ft(bh), ft(0.15)]);
        paint("trim") difference() { translate([-ft(bw / 2 + 0.1), -ft(0.1), 0]) cube([ft(bw + 0.2), ft(bh + 0.2), ft(0.12)]);
                                     translate([-ft(bw / 2 - 0.05), ft(0.05), -1]) cube([ft(bw - 0.1), ft(bh - 0.1), 4]); }
        paint("sign_letters") translate([0, ft(bh / 2), ft(0.15)]) linear_extrude(ft(0.04))
            text("WAUKESHA", size = ft(0.8), font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}
// knee braces on the pavilion posts (1922 photo: curved; drawn straight here)
module pavilion_braces() {
    x0 = PAV[0]; l = PAV[1]; y0 = PAV[2]; w = PAV[3]; pl = PAV[4]; nx = PAV[8]; ny = PAV[9];
    paint("trim") for (i = [0 : nx - 1], j = [0 : ny - 1], d = [-1, 1]) {
        px = x0 + 0.8 + i * (l - 1.6) / max(nx - 1, 1);  py = y0 + 0.8 + j * (w - 1.6) / max(ny - 1, 1);
        hull() { fbox(px - 0.15, py - 0.15, pl - 3.2, 0.3, 0.3, 0.3); fbox(px + d * 2.2 - 0.15, py - 0.15, pl - 1.2, 0.3, 0.3, 0.3); }
    }
}

// =====================================================================
//  INTERIOR - best guess for 1906 (ESTIMATE throughout except the room plan)
//  Room plan from sheet 143 as altered in 1906 (dotted partitions removed, "close up" door
//  closed): baggage room; smoking room with men's and women's toilets on its town side;
//  general waiting room with the track bay; office with the 1906 "new counter", the
//  telegraph table in the NE corner, ticket window and drawer in the partition; flues in
//  the baggage / smoking partition and the office partition ("12 x 12 flue").
//  Fittings styled on the 1915 WHS office photo: varnished beadboard walls and ceilings,
//  plank floors, coal base-burner stoves on long pipes to the flues, wall clock.
// =====================================================================
TW = 1.1;                         // outside brick wall (sheet: about 13 in.)
PW = 0.5;                         // partitions
RCEIL = FLOOR + 11.3;             // ceiling 12.8 ft above grade, under the 13 ft wall plate (ESTIMATE)
XB = 14.85;  XS = 33.9;  XO = 72.3;   // partition centres: baggage|smoking, smoking|waiting, waiting|office (sheet)
YT = 11.65;  XT = 24.6;               // toilet wall (along x) and the wall between the toilets
// rooms: [x0, x1, y0, y1, floor, ceiling]
ROOMS = [[TW, XB - PW / 2, TW, W - TW, FLOOR, RCEIL],                 // baggage
         [XB + PW / 2, XS - PW / 2, YT + PW / 2, W - TW, FLOOR, RCEIL],   // smoking room
         [XB + PW / 2, XT - PW / 2, TW, YT - PW / 2, FLOOR, RCEIL],       // men's toilet
         [XT + PW / 2, XS - PW / 2, TW, YT - PW / 2, FLOOR, RCEIL],       // women's toilet
         [XS + PW / 2, XO - PW / 2, TW, W - TW, FLOOR, RCEIL],            // general waiting room
         [XO + PW / 2, L - TW, TW, W - TW, FLOOR, RCEIL]];                // office
// openings between rooms: [x0, x1, y0, y1, z0, z1]
INNER = [[XS - 0.4, XS + 0.4, 21.2, 24.2, FLOOR, FLOOR + 7.5],          // smoking room - waiting room
         [16.0, 18.7, YT - 0.4, YT + 0.4, FLOOR, FLOOR + 7],            // men's toilet, from the smoking room
         [XS - 0.4, XS + 0.4, 2.7, 5.4, FLOOR, FLOOR + 7],              // women's toilet, from the waiting room
         [XO - 0.4, XO + 0.4, 4.4, 7.4, FLOOR, FLOOR + 7],              // office door
         [XO - 0.4, XO + 0.4, 11.0, 13.6, FLOOR + 3.3, FLOOR + 5.8],    // ticket window
         [BX - BW / 2 + 0.6, BX + BW / 2 - 0.6, W - TW - 0.1, W + 0.1, FLOOR, BTOP - 0.6]];   // waiting room - bay
FLUES = [[XB - 0.8, XB + 0.8, 12.4, 14.0], [XO - 0.6, XO + 0.6, 17.2, 18.4]];   // brick flues in the partitions (sheet)
module rbox(r, g = 0) translate([ft(r[0] - g), ft(r[2] - g), ft(r[4])]) cube([ft(r[1] - r[0] + 2 * g), ft(r[3] - r[2] + 2 * g), ft(r[5] - r[4])]);
module room_voids() {
    for (r = ROOMS) rbox(CUTAWAY ? [r[0], r[1], r[2], r[3], r[4], PLATE + 0.1] : r);   // cutaway: open to the sky
    translate([0, 0, ft(FLOOR)]) linear_extrude(ft((CUTAWAY ? BTOP + 0.1 : BTOP - 0.6) - FLOOR)) bay_shape(-TW * 0.8);
}
module cut_box(w, z0, h) translate([-ft(w / 2), ft(z0), -ft(1.6)]) cube([ft(w), ft(h), ft(1.62)]);
module all_cuts() {
    for (o = WINS)  on_face(MAIN, o[0], o[1]) cut_box(o[2], o[4], o[3]);
    for (o = DOORS) on_face(MAIN, o[0], o[1]) cut_box(o[2], FLOOR, o[3] + (o[4] == 2 ? 0 : 1.3));
    for (f = BAYFACES) on_seg(f[0], f[1]) cut_box(f[2], WS, WH);
    for (c = INNER) rbox(c);
}
// ---- finishes: beadboard on every wall and ceiling, plank floor ----
module lining(r) {
    difference() {
        paint("wainscot") difference() { rbox(r); rbox([r[0], r[1], r[2], r[3], r[4] - 1, r[5] + 1], -0.06); }
        all_cuts();
    }
    paint("wainscot") difference() {                                     // chair rail
        rbox([r[0], r[1], r[2], r[3], r[4] + 3.3, r[4] + 3.5]); rbox([r[0], r[1], r[2], r[3], r[4] - 1, r[5] + 1], -0.14); all_cuts(); }
    paint("floor") rbox([r[0], r[1], r[2], r[3], r[4], r[4] + 0.06]);
    if (!CUTAWAY) paint("ceiling") rbox([r[0], r[1], r[2], r[3], r[5] - 0.08, r[5]]);
}
module bay_lining() {
    paint("wainscot") difference() {
        translate([0, 0, ft(FLOOR)]) linear_extrude(ft(BTOP - 0.6 - FLOOR)) difference() { bay_shape(-TW * 0.8); bay_shape(-TW * 0.8 - 0.06); }
        all_cuts();
        fbox(BX - BW / 2, W - TW - 1, 0, BW, TW + 1.05, 20);
    }
    paint("floor") translate([0, 0, ft(FLOOR)]) linear_extrude(ft(0.06)) bay_shape(-TW * 0.8);
    if (!CUTAWAY) paint("ceiling") translate([0, 0, ft(BTOP - 0.68)]) linear_extrude(ft(0.08)) bay_shape(-TW * 0.8);
}
// ---- fittings -------------------------------------------------------------------
// plain slatted depot bench along x, back line at y, facing +y (s = 1) or -y (ESTIMATE)
module bench(x0, len, y, s) paint("oak") translate([ft(x0), ft(y), ft(FLOOR)]) mirror([0, s > 0 ? 0 : 1, 0]) {
    for (x = [0, len - 0.2]) cube([ft(0.2), ft(1.6), ft(1.45)]);              // ends
    translate([0, 0, ft(1.35)]) cube([ft(len), ft(1.6), ft(0.12)]);           // seat
    cube([ft(len), ft(0.12), ft(3.0)]);                                        // back
    translate([0, ft(1.45), ft(0.2)]) cube([ft(len), ft(0.1), ft(1.15)]);      // apron
}
module double_bench(x0, len, yc) { bench(x0, len, yc + 0.08, 1); bench(x0, len, yc - 0.08, -1); }
module bench_y(y0, len, x, s) translate([ft(x), ft(y0), 0]) rotate([0, 0, 90]) bench(0, len, 0, -s);
// coal base-burner (1915 photo): round body on a square base, dome, pipe up and across to the flue
module stove(x, y, fx, fy, big = 1) {
    r = 0.9 * big;  h = 3.6 * big;  zp = RCEIL - 1.2;
    paint("iron") translate([ft(x), ft(y), ft(FLOOR)]) {
        translate([-ft(r + 0.2), -ft(r + 0.2), 0]) cube([ft(2 * r + 0.4), ft(2 * r + 0.4), ft(0.8)]);
        translate([0, 0, ft(0.8)]) cylinder(r = ft(r), h = ft(h - 1.6), $fn = 32);
        translate([0, 0, ft(h - 0.8)]) cylinder(r1 = ft(r), r2 = ft(0.3), h = ft(0.8), $fn = 32);
        translate([0, 0, ft(h - 0.2)]) cylinder(r = ft(0.28), h = ft(zp - FLOOR - h + 0.2), $fn = 16);   // pipe up
    }
    paint("tile") translate([ft(x), ft(y), ft(FLOOR + 1.6)]) intersection() {                      // mica windows
        cylinder(r = ft(r + 0.02), h = ft(1.0 * big), $fn = 32);
        for (a = [0 : 60 : 300]) rotate([0, 0, a]) translate([0, -ft(0.25), 0]) cube([ft(r + 0.1), ft(0.5), ft(1.0 * big)]); }
    paint("brass") translate([ft(x), ft(y), ft(FLOOR + 0.8 + h - 1.6)]) cylinder(r = ft(r + 0.08), h = ft(0.15), $fn = 32);   // nickel trim ring
    paint("iron") hull() { translate([ft(x), ft(y), ft(zp)]) sphere(r = ft(0.28), $fn = 12);           // pipe across to the flue
                           translate([ft(fx), ft(fy), ft(zp)]) sphere(r = ft(0.28), $fn = 12); }
    paint("tile") translate([ft(x), ft(y), ft(FLOOR)]) translate([-ft(r + 1), -ft(r + 1), 0]) cube([ft(2 * r + 2), ft(2 * r + 2), ft(0.03)]);   // zinc stove board
}
module lamp(x, y, drop = 3) {
    paint("brass") { translate([ft(x), ft(y), ft(RCEIL - drop)]) cylinder(r = ft(0.05), h = ft(drop), $fn = 8);
                     translate([ft(x), ft(y), ft(RCEIL - drop - 0.6)]) cylinder(r1 = ft(0.9), r2 = ft(0.15), h = ft(0.6), $fn = 24); }
    paint("tile") translate([ft(x), ft(y), ft(RCEIL - drop - 0.55)]) sphere(r = ft(0.28), $fn = 16);
}
module wall_clock(x, y, z, a) translate([ft(x), ft(y), ft(z)]) rotate([0, 0, a]) {
    paint("oak") rotate([0, 90, 0]) cylinder(r = ft(0.95), h = ft(0.25), $fn = 32);
    paint("tile") translate([ft(0.25), 0, 0]) rotate([0, 90, 0]) cylinder(r = ft(0.8), h = ft(0.04), $fn = 32);
    paint("board") translate([ft(0.29), 0, 0]) { rotate([30, 0, 0]) translate([0, -ft(0.03), 0]) cube([ft(0.02), ft(0.06), ft(0.6)]);
                                                    rotate([-100, 0, 0]) translate([0, -ft(0.03), 0]) cube([ft(0.02), ft(0.06), ft(0.45)]); }
}
module spittoon(x, y) paint("brass") translate([ft(x), ft(y), ft(FLOOR)]) cylinder(r1 = ft(0.45), r2 = ft(0.3), h = ft(0.8), $fn = 20);

module waiting_room() {
    double_bench(39, 10, 13);  double_bench(52, 10, 13);
    bench(36, 6, TW, 1);  bench(44, 9, TW, 1);  bench(61, 6, TW, 1);   // town wall, between windows and doors
    bench(BX - 3, 6, W + BD - TW * 0.8 - 0.1, -1);                      // in the bay
    stove(XO - 3.2, 19.5, XO - PW / 2, 17.8, 1.15);
    for (x = [42, 53, 64]) lamp(x, 13);
    wall_clock(XO - PW / 2, 9.0, FLOOR + 9, 180);
    paint("board") fbox(XO - PW / 2 - 0.12, 1.6, FLOOR + 4.5, 0.12, 2.4, 3.6);                    // train board
    paint("oak") fbox(XO - PW / 2 - 0.9, 11.0, FLOOR + 3.2, 0.9, 2.6, 0.15);                     // ticket shelf
    spittoon(37, 20);  spittoon(66, 3);  spittoon(55, 21);
}
module smoking_room() {
    bench_y(YT + 0.8, 6, XB + PW / 2, 1);  bench(XB + 2, 9, W - TW, -1);
    bench(XB + 3, 8, YT + PW / 2, 1);
    stove(XB + 2.8, 16.5, XB + PW / 2, 13.2, 1.0);
    lamp(24, 18.5);
    spittoon(19, 21);  spittoon(28, 15);  spittoon(31, 22);
}
module toilets() {
    paint("oak") for (x = [19.8, 22.1, 26.4, 28.7]) fbox(x, YT - PW / 2 - 4.3, FLOOR, 0.1, 4.3, 6.5);   // stall partitions
    paint("tile") {
        for (x = [21.0, 23.3, 25.4, 27.6]) { fbox(x - 0.5, YT - PW / 2 - 1.6, FLOOR, 1.0, 1.4, 1.4);     // closets
                                            fbox(x - 0.5, YT - PW / 2 - 0.5, FLOOR + 1.4, 1.0, 0.45, 2.4); }   // tanks
        fbox(XB + PW / 2, 2.2, FLOOR, 0.6, 1.1, 4.2);                                                   // urinal
        for (x = [22.7, 26.3]) fbox(x - 0.7, TW, FLOOR + 2.5, 1.4, 1.1, 0.4);                          // basins
        fbox(XS - PW / 2 - 1.3, YT - PW / 2 - 1.5, FLOOR + 2.0, 1.3, 1.3, 1.0);                        // slop sink
    }
    lamp(20, 6, 2);  lamp(29, 6, 2);
}
module office() {
    paint("oak") {
        fbox(76.8, 18.6, FLOOR, 1.8, W - TW - 18.6, 3.4);                         // the 1906 new counter
        fbox(76.6, 18.6, FLOOR + 3.4, 2.2, W - TW - 18.6, 0.12);
        fbox(L - TW - 2.6, 18.6, FLOOR + 2.4, 2.6, W - TW - 18.6, 0.15);          // telegraph table (sheet, NE corner)
        for (y = [18.8, W - TW - 0.3]) fbox(L - TW - 2.5, y, FLOOR, 0.2, 0.2, 2.4);
        fbox(L - TW - 4.2, 21.2, FLOOR, 1.4, 1.4, 1.5); fbox(L - TW - 4.25, 21.2, FLOOR + 1.5, 0.15, 1.4, 1.4);   // operator's chair
        fbox(XO + PW / 2, 9.8, FLOOR + 3.2, 1.2, 4.6, 0.15);                       // ticket counter at the window
        fbox(XO + PW / 2, 14.5, FLOOR, 1.6, 2.4, 6.0);                             // ticket case
        fbox(78, TW, FLOOR, 5.2, 2.6, 2.5);                                         // roll-top desk under the town window
        hull() { fbox(78, TW, FLOOR + 2.5, 5.2, 2.6, 0.1); fbox(78, TW, FLOOR + 3.9, 5.2, 1.0, 0.1); }
        fbox(L - TW - 4.4, 9.0, FLOOR, 3.0, 2.2, 2.5);                              // agent's table
    }
    paint("iron") fbox(L - TW - 2.4, 3.0, FLOOR, 2.2, 2.0, 3.4);                    // safe
    paint("brass") { fbox(L - TW - 2.0, 21.5, FLOOR + 2.55, 0.6, 0.4, 0.35); fbox(L - TW - 1.8, 20.6, FLOOR + 2.55, 0.5, 0.3, 0.15); }   // sounder, key
    translate([ft(XO + PW / 2 - 0.02), ft(11.0), ft(FLOOR + 3.35)]) rotate([0, 0, 90]) paint("brass")
        for (k = [0 : 10]) translate([ft(k * 0.25), 0, 0]) cube([ft(0.04), ft(0.04), ft(2.4)]);   // ticket grille
    stove(XO + 3.0, 20.8, XO + PW / 2, 17.8, 0.85);
    lamp(79, 12);  lamp(83, 21, 2.5);
    wall_clock(XO + PW / 2, 3.5, FLOOR + 8.5, 0);
}
module baggage_room() {
    stove(10.5, 13.2, XB - PW / 2, 13.2, 0.9);
    paint("iron") { fbox(3.0, 15.5, FLOOR, 6.6, 6.0, 0.12); fbox(9.6, 20.6, FLOOR, 0.6, 0.6, 4.2); fbox(9.7, 18.0, FLOOR + 4.2, 0.2, 3.2, 0.15); }   // platform scale
    paint("oak") fbox(3.2, 15.7, FLOOR + 0.12, 6.2, 5.6, 0.02);
    for (c = [[2.5, 3.0]]) {                                                         // baggage truck
        paint("oak") fbox(c[0], c[1], FLOOR + 1.6, 9, 3.2, 0.25);
        paint("iron") for (x = [c[0] + 1.2, c[0] + 7.8], y = [c[1] - 0.05, c[1] + 3.1])
            translate([ft(x), ft(y), ft(FLOOR + 0.8)]) rotate([90, 0, 0]) cylinder(r = ft(0.8), h = ft(0.15), center = true, $fn = 20);
    }
    paint("oak") { fbox(3.5, 3.6, FLOOR + 1.85, 3, 2, 1.8); fbox(7.0, 3.8, FLOOR + 1.85, 2.5, 1.6, 1.2);
                   fbox(TW + 0.2, 8.5, FLOOR, 3, 2, 2.2); }
    lamp(7, 12, 2.5);
}
module interior() {
    for (r = ROOMS) lining(r);
    bay_lining();
    paint("chimney") for (f = FLUES) fbox(f[0], f[2], FLOOR, f[1] - f[0], f[3] - f[2], RCEIL + 0.2 - FLOOR);
    waiting_room();  smoking_room();  toilets();  office();  baggage_room();
}


waukesha();
