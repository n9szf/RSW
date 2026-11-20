// =====================================================================
//  Platform canopy, 42 ft shed and end shelters  (B2077 plan, B2079 track elevation,
//  B2080 end elevations, B2082 shed sections)
//
//  One continuous slate roof along the track side:
//    west shelter (43'-6" beyond the west wall, hip end, two rows of columns)
//    lean-to along the main block and the lunch wing (wall line up to ~18 ft)
//    42 ft shed between the lunch wing and the baggage building (gable, ridge along the track)
//    low lean-to along the baggage building, east shelter (40 ft, hip end)
//  Columns 13'-4" out from the wall, eave 4'-2" beyond the columns, eave 12'-0" above the platform.
//
//  Parts (all Pullman green except the slate):
//    Canopy_roof_*      slate panels, flat, texture up (seams fall on rafters / trusses)
//    Canopy_posts_*     cast-iron columns, printed upright, one plate per row
//    Canopy_beams_*     girders along each column row        Canopy_rafters_* / Canopy_truss_*
//    Canopy_brackets_*  knee braces (flat)                   Canopy_fascia_*  boarded end closures
//  Geometry in REAL FEET: x along the track from the west end wall, y from the track-side wall
//  line toward town (the platform is at negative y), z above finished floor.
// =====================================================================
include <../janesville_common.scad>
use <../Roof/roofs.scad>

PART = "Canopy_roof_south";
TILE = -1; LAYER = -1; VIEW = "flat"; LIST = false;
$fn = 24;

SLATE_GRAY = "#4B5560";
T_PANEL = 2.4; SG_D = 0.4;
// ---------- key numbers (ft) ----------
LM = 98 + 1/12; LX1 = LM + 30 + 4/12; LY0 = 1 + 5/12; LY1 = LY0 + 25 + 4/12;
BX0 = LX1 + 42; BX1 = BX0 + 47 + 2/12;
PLATFORM = -0.5;                 // platform top below finished floor
Y_EAVE = -17.5; Y_POST = -(13 + 4/12);     // eave line and column line (track side)
Z_EAVE = PLATFORM + 12;          // 12'-0" above the platform
PC = 14;                         // canopy pitch (low, about 3 in 12, per the valuation photos)
XW = -43.5; YWN = 9.7;           // west shelter: west end, north eave
YRW = (Y_EAVE + YWN) / 2;        // west shelter ridge line
YSN = 22.5; YRS = (Y_EAVE + YSN) / 2;      // 42 ft shed: north eave, ridge line
// Per the valuation photos the canopy is ONE continuous roof at one eave height: it runs over the front of the
// baggage building (whose own gable roof pokes up through it) and ends in a wide hipped shelter at the east end.
Z_BAG_EAVE = Z_EAVE; P4 = PC; P5 = PC;
XE = BX1 + 40; YEN = YSN; YRE = (Y_EAVE + YEN) / 2;               // east shelter: same width as the 42 ft shed
// where the canopy plane lands on the baggage building's own roof slope (roof: eave 12.25 ft at y = 0.17, 37 deg)
YBI = (12.25 - 0.17 * tan(37) - Z_EAVE + Y_EAVE * tan(PC)) / (tan(PC) - tan(37));
function zc(y) = Z_EAVE + (y - Y_EAVE) * tan(PC);                  // main canopy plane
function z4(y) = Z_BAG_EAVE + (y - Y_EAVE) * tan(P4);
function z5(y) = Z_BAG_EAVE + (y - Y_EAVE) * tan(P5);
hW = YRW - Y_EAVE; hE = YRE - Y_EAVE;

// ---------- roof planes: [name, E0, e, n, pitch, polygon (ft 3D), holes, cuts] ----------
S_CUTS_P1S = [-21.75, 0, 21.9, 43.2, 64.5, 85.8, 107.1, LX1, 149.42];
S_CUTS_GIGA = [21.9, 85.8, 149.42];
YSN_ = 22.5;
CPLANES = [
  ["Canopy_roof_south", [XW, Y_EAVE, Z_EAVE], [1, 0, 0], [0, 1, 0], PC,
     [[XW, Y_EAVE, Z_EAVE], [BX0, Y_EAVE, Z_EAVE], [BX0, YRS, zc(YRS)], [LX1, YRS, zc(YRS)], [LX1, LY0, zc(LY0)],
      [LM, LY0, zc(LY0)], [LM, 0, zc(0)], [0, 0, zc(0)], [0, YRW, zc(YRW)], [XW + hW, YRW, zc(YRW)]],
     [], ["x", S_CUTS_P1S, S_CUTS_GIGA]],
  ["Canopy_roof_west_north", [0, YWN, Z_EAVE], [-1, 0, 0], [0, -1, 0], PC,
     [[0, YWN, Z_EAVE], [XW, YWN, Z_EAVE], [XW + hW, YRW, zc(YRW)], [0, YRW, zc(YRW)]], [], ["x", [-21.75], []]],
  ["Canopy_roof_west_hip", [XW, YWN, Z_EAVE], [0, -1, 0], [1, 0, 0], PC,
     [[XW, YWN, Z_EAVE], [XW, Y_EAVE, Z_EAVE], [XW + hW, YRW, zc(YRW)]], [], ["auto"]],
  ["Canopy_roof_shed_north", [BX0, YSN, Z_EAVE], [-1, 0, 0], [0, -1, 0], PC,
     [[BX0, YSN, Z_EAVE], [LX1, YSN, Z_EAVE], [LX1, YRS, zc(YRS)], [BX0, YRS, zc(YRS)]], [], ["x", [149.42], []]],
  ["Canopy_roof_baggage", [BX0, Y_EAVE, Z_EAVE], [1, 0, 0], [0, 1, 0], PC,
     [[BX0, Y_EAVE, Z_EAVE], [BX1, Y_EAVE, Z_EAVE], [BX1, YBI, zc(YBI)], [BX0, YBI, zc(YBI)]], [],
     ["auto"]],
  ["Canopy_roof_east_south", [BX1, Y_EAVE, Z_BAG_EAVE], [1, 0, 0], [0, 1, 0], P5,
     [[BX1, Y_EAVE, Z_BAG_EAVE], [XE, Y_EAVE, Z_BAG_EAVE], [XE - hE, YRE, z5(YRE)], [BX1, YRE, z5(YRE)]], [], ["x", [BX1 + 20], []]],
  ["Canopy_roof_east_north", [XE, YEN, Z_BAG_EAVE], [-1, 0, 0], [0, -1, 0], P5,
     [[XE, YEN, Z_BAG_EAVE], [BX1, YEN, Z_BAG_EAVE], [BX1, YRE, z5(YRE)], [XE - hE, YRE, z5(YRE)]], [], ["x", [BX1 + 20], []]],
  ["Canopy_roof_east_hip", [XE, Y_EAVE, Z_BAG_EAVE], [0, 1, 0], [-1, 0, 0], P5,
     [[XE, Y_EAVE, Z_BAG_EAVE], [XE, YEN, Z_BAG_EAVE], [XE - hE, YRE, z5(YRE)]], [], ["auto"]]
];
function crow_(n) = CPLANES[search([n], CPLANES)[0]];
function cplane_list() = [for (p = CPLANES) p[0]];
function cplane_count(n, bed) = let(r = crow_(n)) (len(p_ucuts(r, bed)) + 1) * (len(p_vcuts(r, bed)) + 1);
module cplane_layer(n, k, tile = -1, bed = BED) {
    r = crow_(n); poly = p_poly(r); bb = bbox2(poly);
    tb = tile < 0 ? [bb[0] - [5, 5], bb[1] + [5, 5]] : tile_box(bb[0], bb[1], p_ucuts(r, bed), p_vcuts(r, bed), tile);
    z = [[0, T_PANEL - SG_D], [T_PANEL - SG_D, T_PANEL]][k];
    translate([0, 0, z[0]]) linear_extrude(z[1] - z[0]) intersection() {
        translate(tb[0]) square(tb[1] - tb[0]);
        difference() { polygon(poly); if (k == 1) slate2d(bb); }
    }
}
module cplane_place(n) {
    r = crow_(n); e = r[2]; s = slope_dir(r[3], r[4]); N = crossp(e, s); E = v3(r[1]) + [0, 0, FLOOR_Z];
    multmatrix([[e[0], s[0], N[0], E[0]], [e[1], s[1], N[1], E[1]], [e[2], s[2], N[2], E[2]], [0, 0, 0, 1]])
        for (k = [0, 1]) cplane_layer(n, k);
}

// ---------- column rows: [name, y, [x...], top of beam (= underside of roof at the column line)] ----------
BEAM_H = 1.0; BEAM_W = 8 / 12;
ROWS = [
  ["south",   Y_POST, [-36, -21.75, 0.6, 21.9, 43.2, 64.5, 85.8, 107.1, LX1, BX0], zc(Y_POST)],
  ["west_n",  YWN - 3.9, [-36, -21.75], zc(Y_EAVE + 3.9)],
  ["shed_n",  YSN - 4.17, [LX1 + 0.6, BX0 - 0.6], zc(Y_POST)],
  ["baggage", Y_POST, [BX0 + 15.72, BX0 + 31.44, BX1], z4(Y_POST)],
  ["east_s",  Y_POST, [BX1 + 20, XE - 5.5], z5(Y_POST)],
  ["east_n",  YEN - 3.8, [BX1 + 20, XE - 5.5], z5(Y_EAVE + 3.8)]
];
function canopy_post_xy() = [for (r = ROWS) for (x = r[2]) [x, r[1]]];     // ft, for the platform footing holes
function canopy_x_ends() = [XW, XE];
function rowr(n) = ROWS[search([n], ROWS)[0]];
function row_list() = [for (r = ROWS) r[0]];
function post_h(r) = FLOOR_Z + ft(r[3] - BEAM_H);        // from grade to underside of the beam
// The posts are BRASS TUBE (K&S 9/32 in square = 7.14 mm; the 8 x 8 timber is 7.0 mm at 1:29).
// Printed: a footing block with a hole for the tube (Canopy_footings_<row>) and a cap that plugs into the
// top of the tube and carries the beam ends (Canopy_post_caps).  The tube stands in a hole in the plywood base.
TUBE = 7.14;        // tube size across the flats (mm)
TUBE_BORE = 6.4;    // inside size of the tube (9/32 square, 0.014 in wall = 6.43 mm)
TUBE_FIT = 0.3;     // clearance in the footing hole
TUBE_INTO_BASE = 12; // tube goes this far into the plywood base (mm)
CAP_T = 1.2;        // cap pad thickness
BRASS = "#B8923A";
function tube_len(r) = post_h(r) - CAP_T + TUBE_INTO_BASE;       // cut length for a row (mm)
function canopy_tube_lengths() = [for (r = ROWS) [r[0], len(r[2]), tube_len(r)]];
module footing() { base = ft(1.25); w = TUBE + TUBE_FIT;
    difference() { union() { translate([-base / 2, -base / 2, 0]) cube([base, base, FLOOR_Z + ft(PLATFORM) + 0.5]);
                             translate([-ft(0.5), -ft(0.5), 0]) cube([ft(1), ft(1), FLOOR_Z + ft(PLATFORM + 0.5)]); }
                   translate([-w / 2, -w / 2, -1]) cube([w, w, 100]); } }
module post_cap() {            // printed pad down, peg up; in place the peg goes down into the tube
    translate([-ft(0.75), -TUBE / 2, 0]) cube([ft(1.5), TUBE, CAP_T]);
    translate([-(TUBE_BORE - 0.25) / 2, -(TUBE_BORE - 0.25) / 2, 0]) cube([TUBE_BORE - 0.25, TUBE_BORE - 0.25, CAP_T + 6]);
}
module post(h) { color("#9A9A9A") footing(); color(BRASS) translate([-TUBE / 2, -TUBE / 2, -TUBE_INTO_BASE]) cube([TUBE, TUBE, h - CAP_T + TUBE_INTO_BASE]);
    color(PULLMAN_GREEN) translate([0, 0, h]) mirror([0, 0, 1]) post_cap(); }
module posts_part(n) { r = rowr(n); for (i = [0 : len(r[2]) - 1]) translate([i * 22, 0, 0]) footing(); }
module caps_part() for (i = [0 : N_POSTS + 3]) translate([(i % 5) * (ft(1.5) + 4), floor(i / 5) * (TUBE + 4), 0]) post_cap();     // 4 spares
module posts_place(n) { r = rowr(n); for (x = r[2]) translate([ft(x), ft(r[1]), 0]) post(post_h(r)); }
// beams along the row (between consecutive columns, 1 ft past the end columns)
function beam_spans(r) = [for (i = [0 : len(r[2]) - 2]) [r[2][i] - (i == 0 ? 1 : 0), r[2][i + 1] + (i == len(r[2]) - 2 ? 1 : 0)]];
function beam_cut(L, bed) = ft(L) > bed[0] - 4 ? 2 : 1;
module beam(L) cube([ft(L), ft(BEAM_H), ft(BEAM_W)]);     // printed lying on its side
module beams_part(n, bed = BED) {
    r = rowr(n); sp = beam_spans(r);
    for (i = [0 : len(sp) - 1]) let(L = sp[i][1] - sp[i][0], m = beam_cut(L, bed))
        for (j = [0 : m - 1]) translate([j * 3, (i * 2 + j) * (ft(BEAM_H) + 3), 0]) beam(L / m);
}
module beams_place(n) {
    r = rowr(n);
    for (s = beam_spans(r)) translate([ft(s[0]), ft(r[1]) - ft(BEAM_W) / 2, FLOOR_Z + ft(r[3] - BEAM_H)]) cube([ft(s[1] - s[0]), ft(BEAM_W), ft(BEAM_H)]);
}

// ---------- knee braces: plain diagonal timbers (flat, 1.6 mm), four per post (2 along the beam, 1 toward the eave, 1 toward the wall) ----------
BR = 2.5; BR_W = 0.3;          // reach = drop (ft), timber width (ft)
module bracket2d(reach, drop) { w = ft(BR_W) * 1.414;
    polygon([[0, -ft(drop)], [0, -ft(drop) + w], [ft(reach) - w, 0], [ft(reach), 0]]); }
module bracket(reach, drop) linear_extrude(1.6) bracket2d(reach, drop);
N_POSTS = len([for (r = ROWS) for (x = r[2]) 1]);
module brackets_part(kind) {
    n = 4 * N_POSTS; cols = floor(240 / (ft(BR) + 2));
    for (i = [0 : n - 1]) translate([(i % cols) * (ft(BR) + 2), -floor(i / cols) * (ft(BR_W) * 1.414 + 6), 0]) rotate(-45) translate([0, ft(BR), 0]) bracket(BR, BR);
}
module brackets_place() for (r = ROWS) for (x = r[2]) {
    zt = FLOOR_Z + ft(r[3] - BEAM_H);
    for (a = [0, 90, 180, 270]) translate([ft(x), ft(r[1]), zt]) rotate([0, 0, a]) translate([0, 0.8, 0]) rotate([90, 0, 0]) bracket(BR, BR);
}

// ---------- rafters (lean-to, one under every panel seam) and trusses (shelters and shed) ----------
RAFT_D = 0.5;
// [name, x list, y at the wall, zfun id]  rafter runs from the column line to the wall
RAFTERS = [
  ["main",    [0.6, 21.9, 43.2, 64.5, 85.8], 0, 0],
  ["lunch",   [107.1, LX1 - 0.3], LY0, 0],
  ["baggage", [BX0 + 0.3, BX0 + 15.72, BX0 + 31.44, BX1 - 0.3], YBI - 0.3, 1]
];
function raftr(n) = RAFTERS[search([n], RAFTERS)[0]];
function raft_z(id, y) = id == 0 ? zc(y) : z4(y);
module rafter2d(r) {       // in (y, z) ft -> mm
    y0 = Y_POST - 0.4; y1 = r[2];
    polygon([[ft(y0), ft(raft_z(r[3], y0))], [ft(y1), ft(raft_z(r[3], y1))], [ft(y1), ft(raft_z(r[3], y1) - RAFT_D * 1.6)], [ft(y0), ft(raft_z(r[3], y0) - RAFT_D)]]);
}
module rafters_part(n) { r = raftr(n); for (i = [0 : len(r[1]) - 1]) translate([0, i * 14, 0]) translate([-ft(Y_POST - 0.4), -ft(raft_z(r[3], Y_POST - 0.4) - 1), 0]) linear_extrude(3) rafter2d(r); }
module rafters_place(n) { r = raftr(n); for (x = r[1]) translate([ft(x) + 1.5, 0, FLOOR_Z]) rotate([90, 0, -90]) mirror([1, 0, 0]) linear_extrude(3) rafter2d(r); }
// trusses: [name, x list, polygon (y,z) ft]
TRUSSES = [
  ["west", [-21.75], [[Y_EAVE + 0.3, Z_EAVE + 0.1], [YWN - 0.3, Z_EAVE + 0.1], [YRW, zc(YRW) - 0.1]]],
  ["shed", [LX1 + 0.3, 149.42, BX0 - 0.3], [[Y_EAVE + 0.3, Z_EAVE + 0.1], [YSN - 0.3, Z_EAVE + 0.1], [YRS, zc(YRS) - 0.1]]],
  ["east", [BX1 + 0.3, BX1 + 20], [[Y_EAVE + 0.3, Z_BAG_EAVE + 0.1], [YEN - 0.3, Z_BAG_EAVE + 0.1], [YRE, z5(YRE) - 0.1]]]
];
function trussr(n) = TRUSSES[search([n], TRUSSES)[0]];
module truss2d(t) {
    P = [for (p = t[2]) [ft(p[0]), ft(p[1])]];
    difference() { polygon(P); offset(delta = -5) polygon(P); }
    translate([P[2][0] - 1.5, P[0][1]]) square([3, P[2][1] - P[0][1]]);
}
function truss_n(t, bed) = ft(t[2][1][0] - t[2][0][0]) > bed[0] - 4 ? 2 : 1;
module truss_part(n, tile = -1, bed = BED) {
    t = trussr(n); P0 = [ft(t[2][0][0]), ft(t[2][0][1])]; xm = ft(t[2][2][0]); m = truss_n(t, bed);
    for (i = [0 : len(t[1]) - 1]) translate([-P0[0], -P0[1] + i * (ft(t[2][2][1] - t[2][0][1]) + 4), 0])
        linear_extrude(3) intersection() {
            truss2d(t);
            if (m == 2 && tile >= 0) translate([tile == 0 ? xm - 2000 : xm + 0.15, -2000]) square([2000 - 0.15, 4000]);
            else translate([-5000, -5000]) square([10000, 10000]);
        }
}
module truss_place(n) { t = trussr(n); for (x = t[1]) translate([ft(x) + 1.5, 0, FLOOR_Z]) rotate([90, 0, -90]) mirror([1, 0, 0]) linear_extrude(3) truss2d(t); }

// ---------- boarded end closures (fascia) where two roofs of different height meet ----------
FASCIAS = [
  ["west_corner", 0, [[YRW, zc(YRW)], [0, zc(0)], [0, zc(YRW) - (0 - YRW) * tan(PC)]]]
];
function fasr(n) = FASCIAS[search([n], FASCIAS)[0]];
module fascia2d(f) { P = [for (p = f[2]) [ft(p[0]), ft(p[1])]]; polygon(P); }
module fascia_part(n) {
    f = fasr(n); P = [for (p = f[2]) [ft(p[0]), ft(p[1])]]; bb = bbox2(P);
    translate([-bb[0][0], -bb[0][1], 0]) {
        linear_extrude(1.2) fascia2d(f);
        translate([0, 0, 1.2]) linear_extrude(0.4) difference() { fascia2d(f); for (u = [bb[0][0] : ft(0, 6) : bb[1][0]]) translate([u, bb[0][1] - 1]) square([0.45, bb[1][1] - bb[0][1] + 2]); }
    }
}
module fascia_place(n) { f = fasr(n); translate([ft(f[1]), 0, FLOOR_Z]) rotate([90, 0, -90]) mirror([1, 0, 0]) { linear_extrude(1.6) fascia2d(f); } }

// ---------- registry ----------
function canopy_parts(bed) = concat(
  [for (p = cplane_list()) [p, cplane_count(p, bed), 2]],
  [for (r = row_list()) [str("Canopy_footings_", r), 1, 1]],
  [["Canopy_post_caps", 1, 1]],
  [for (r = row_list()) [str("Canopy_beams_", r), 1, 1]],
  [["Canopy_braces", 1, 1]],
  [for (r = RAFTERS) [str("Canopy_rafters_", r[0]), 1, 1]],
  [for (t = TRUSSES) [str("Canopy_truss_", t[0]), truss_n(t, bed), 1]],
  [for (f = FASCIAS) [str("Canopy_fascia_", f[0]), 1, 1]]
);
function in_l(n, L) = len([for (x = L) if (x == n) 1]) > 0;
module canopy_part_layer(n, tile, k, bed = BED) {
    if (in_l(n, cplane_list())) { r = crow_(n); bb = bbox2(p_poly(r)); translate([-bb[0][0], -bb[0][1], 0]) cplane_layer(n, k, tile, bed); }
    for (r = row_list()) { if (n == str("Canopy_footings_", r)) posts_part(r); if (n == str("Canopy_beams_", r)) beams_part(r, bed); }
    if (n == "Canopy_braces") brackets_part("all");
    if (n == "Canopy_post_caps") caps_part();
    for (r = RAFTERS) if (n == str("Canopy_rafters_", r[0])) rafters_part(r[0]);
    for (t = TRUSSES) if (n == str("Canopy_truss_", t[0])) truss_part(t[0], tile, bed);
    for (f = FASCIAS) if (n == str("Canopy_fascia_", f[0])) fascia_part(f[0]);
}
module canopy_part(n, tile = -1, bed = BED) {
    if (in_l(n, cplane_list())) for (k = [0, 1]) canopy_part_layer(n, tile, k, bed); else canopy_part_layer(n, tile, 0, bed);
}
module canopy_place() {
    color(SLATE_GRAY) for (p = cplane_list()) cplane_place(p);
    for (r = row_list()) posts_place(r);
    color(PULLMAN_GREEN) {
        for (r = row_list()) beams_place(r);
        brackets_place();
        for (r = RAFTERS) rafters_place(r[0]);
        for (t = TRUSSES) truss_place(t[0]);
        for (f = FASCIAS) fascia_place(f[0]);
    }
}

if (LIST) { for (p = canopy_parts(BED)) echo(str("CPART|", p[0], "|", p[1], "|", p[2])); for (t = canopy_tube_lengths()) echo(str("TUBE|", t[0], "|", t[1], "|", t[2])); }
else if (VIEW == "placed") canopy_place();
else if (LAYER >= 0) canopy_part_layer(PART, TILE, LAYER, BED);
else canopy_part(PART, TILE, BED);
