// =====================================================================
//  Interior  -  floors and furniture, best guess for about 1912
//  (room layout from B2077; furniture and floor finishes are period-typical, not from the prints)
//
//  FLOORS: 1 mm overlays that drop into each room on top of the foundation (Tom's choices, Oct 2026).
//    "herring"  waiting room, smoking room, passage, vestibule: ceramic tile 6" x 12" in herringbone,
//               with a 2 ft basket-weave ("parquet") border.   Floor_<room> (tile) + Floor_<room>_dark (grout)
//    "check"    toilets: black and white 9" tile.              Floor_<room> (white) + Floor_<room>_dark (black)
//    "check45"  lunch room, annex, kitchen: black and white 9" tile turned 45 degrees.   same two bodies
//    "wood"     ticket and telegraph (train-order) office: pine strip; baggage and express rooms: plank. One color.
//    Load the two bodies of a section together for the AMS.
//  FURNITURE (oak color unless noted). Each STL is ONE piece; quantities are in QTY below.
//    Furniture_bench_double   back-to-back waiting bench, 10 ft   - print standing on end
//    Furniture_bench_single   wall bench, 8 ft                    - print standing on end
//    Furniture_lunch_counter  11 ft counter                       - print standing on end
//    Furniture_backbar        shelves behind the counter          - print standing on end
//    Furniture_stools         5 counter stools                    - print as they sit in the STL (seat down)
//    Furniture_desk           agent's desk, 5 ft                  - print top down
//    Furniture_ticket_case    pigeonhole ticket case              - print on its back
//    Furniture_safe           office safe (black)
//    Furniture_ticket_grilles 2 ticket-window grilles (brass) with counter shelves (oak)
//    Furniture_bulletin (+ _white)  10 ft x 6 ft train board, black with white lines and the 1940 trains
// =====================================================================
include <../janesville_common.scad>

PART = "Floor_waiting"; TILE = -1; LAYER = -1; LIST = false; VIEW = "flat";
OAK = "#9A6B3A";
FL_T = 0.6; FL_TOP = 0.2;             // floor overlay thickness, pattern depth (mm)
GROUT = 0.4; HB_W = BX * ft(0, 6); BAND = 2 * HB_W; CHECK = BX * ft(0, 9); PLANK = BX * ft(0, 3.25); PGAP = 0.3;
DETAIL = true;                        // draw the floor patterns in the assembled view (set false for a faster preview)
iM = T_MAIN + 0.3; iL = T_LIGHT + 0.3; iB = 1.3; iS = 1.1; i0 = 0.3;      // insets from wall lines (mm)
XL0 = ft(98 + 1/12); XL1 = X_MAIN_E;

// rect helper: lines in ft, insets [west, south, east, north] in mm  ->  [x0, y0, x1, y1] mm
function R(x0, y0, x1, y1, ins) = [ft(x0) + ins[0], ft(y0) + ins[1], ft(x1) - ins[2], ft(y1) - ins[3]];
function Rm(x0, y0, x1, y1) = [x0, y0, x1, y1];
function fp(p) = [ft(p[0]), ft(p[1])];
// [name, kind ("herring" / "check" / "check45" / "wood"), [rects]]
ROOMS = [
  ["waiting",     "herring", [R(0, 0, 40.25, 32, [iM, iM, iB, iM])]],
  ["ticket",      "wood", [R(40.25, 0, 55, 11.75, [iB, iM, iS, iS]),
                           Rm(ft(40.45) + 0.3, 0.3, ft(54.67) - 0.3, iM + 0.01),            // through the wall opening
                           Rm(ft(42.5), -ft(3) + T_LIGHT + 0.3, ft(51.33), 0.31)]],         // bay window floor
  ["trainorder",  "wood", [R(55, 0, 60.25, 11.75, [iS, iM, iB, iS])]],
  ["passage",     "herring", [R(40.25, 11.75, 60.25, 21.25, [iB, iS, iB, iS])]],
  ["womens",      "check", [R(40.25, 21.25, 49.5, 32, [iB, iS, iS, iM])]],
  ["vestibule",   "herring", [R(49.5, 21.25, 60.25, 32, [iS, iS, iB, iM])]],
  ["smoking",     "herring", [R(60.25, 0, 87.35, 32, [iB, iM, iB, iM])]],
  ["annex",       "check45", [R(87.35, 0, 98 + 1/12, 16, [iB, iM, iM, iS])]],
  ["mens",        "check", [R(87.35, 16, 98 + 1/12, 32, [iB, iS, iM, iM])]],
  ["lunch",       "check45", [Rm(XL0 + i0, LUNCH_Y0 + iL, ft(116) - iS, LUNCH_Y1 - iL),
                           Rm(ft(116) - iS - 0.01, LUNCH_Y0 + iL, XL1 - iL, ft(13.5) - i0)]],
  ["kitchen",     "check45", [Rm(ft(116) + iS, ft(13.5) + i0, XL1 - iL, LUNCH_Y1 - iL)]],
  ["baggage",     "wood", [Rm(X_BAG_W + iL, BAG_Y0 + iL, X_BAG_W + ft(30.58) - iB, BAG_Y1 - iL)]],
  ["express",     "wood", [Rm(X_BAG_W + ft(30.58) + iB, BAG_Y0 + iL, X_BAG_E - iL, BAG_Y1 - iL)]]
];
function room(n) = ROOMS[search([n], ROOMS)[0]];
function rbb(r) = [min([for (q = r[2]) q[0]]), min([for (q = r[2]) q[1]]), max([for (q = r[2]) q[2]]), max([for (q = r[2]) q[3]])];
function rgrid(r, bed) = let(b = rbb(r)) [ceil((b[2] - b[0]) / (bed[0] - 8)), ceil((b[3] - b[1]) / (bed[1] - 8))];
function floor_count(n, bed) = let(g = rgrid(room(n), bed)) g[0] * g[1];
// wire feed holes: the same positions as the 8 mm holes in the foundation (Basement/foundation_base.scad)
FEED_D = 5.5;
FEEDS = [[X_PAV_W / 2, MAIN_DEPTH / 2], [(X_PAV_W + X_PAV_E) / 2, ft(6)], [(X_PAV_W + X_PAV_E) / 2, ft(16)], [(X_PAV_W + X_PAV_E) / 2 - ft(5), ft(26)],
         [(X_PAV_E + X_SMOKE_E) / 2 - ft(4), MAIN_DEPTH / 2], [X_SMOKE_E - ft(6), ft(25)], [X_SMOKE_E + ft(12), ft(9)], [X_SMOKE_E + ft(10), ft(21)],
         [X_BAG_W + ft(14), (BAG_Y0 + BAG_Y1) / 2], [X_BAG_E - ft(10), (BAG_Y0 + BAG_Y1) / 2]];
module room2d(r) difference() { for (q = r[2]) translate([q[0], q[1]]) square([q[2] - q[0], q[3] - q[1]]);
    for (f = FEEDS) translate(f) circle(d = FEED_D, $fn = 24); }
module lines2d(b, pitch, w) {
    for (x = [floor(b[0] / pitch) * pitch : pitch : b[2]]) translate([x - w / 2, b[1] - 1]) square([w, b[3] - b[1] + 2]);
}
function md(a, n) = ((a % n) + n) % n;
// herringbone field: tiles HB_W x 2 HB_W on a grid of HB_W cells, anchored at the room corner
module herring2d(b) { w = HB_W; g = GROUT / 2; nc = ceil((b[2] - b[0]) / w) + 1; nr = ceil((b[3] - b[1]) / w) + 1;
    translate([b[0], b[1]]) for (c = [-2 : nc]) for (r = [-2 : nr]) {
        d = md(c - r, 4);
        if (d == 0) translate([c * w + g, r * w + g]) square([2 * w - 2 * g, w - 2 * g]);
        if (d == 3) translate([c * w + g, r * w + g]) square([w - 2 * g, 2 * w - 2 * g]);
    } }
// basket-weave ("parquet") border: units of 2 tiles, turned on alternate units
module basket2d(b) { w = HB_W; g = GROUT / 2; n = ceil((b[2] - b[0]) / (2 * w)); m = ceil((b[3] - b[1]) / (2 * w));
    translate([b[0], b[1]]) for (i = [0 : n]) for (j = [0 : m]) translate([i * 2 * w, j * 2 * w]) for (k = [0, 1])
        if (md(i + j, 2) == 0) translate([g, k * w + g]) square([2 * w - 2 * g, w - 2 * g]);
        else translate([k * w + g, g]) square([w - 2 * g, 2 * w - 2 * g]); }
module checker2d(b, s, ang) { c = [(b[0] + b[2]) / 2, (b[1] + b[3]) / 2]; n = ceil(norm([b[2] - b[0], b[3] - b[1]]) / 2 / s) + 1;
    translate(c) rotate(ang) for (i = [-n : n]) for (j = [-n : n]) if (md(i + j, 2) == 0) translate([i * s, j * s]) square(s + 0.01); }
// main body of the pattern (the lighter / tile color).  The dark body is the rest of the room.
module main2d(r) { b = rbb(r); k = r[1];
    if (k == "wood") difference() { room2d(r); lines2d(b, PLANK, PGAP); }
    if (k == "check") difference() { room2d(r); checker2d(b, CHECK, 0); }
    if (k == "check45") difference() { room2d(r); checker2d(b, CHECK, 45); }
    if (k == "herring") {
        intersection() { offset(delta = -BAND - GROUT) room2d(r); herring2d(b); }
        intersection() { difference() { room2d(r); offset(delta = -BAND) room2d(r); } basket2d(b); }
    } }
module clip2d(b, i, j, w, h) intersection() { children(); translate([b[0] + i * w, b[1] + j * h]) square([w, h]); }
// k: 0 base, 1 main pattern body, 2 dark body (grout or black tiles; not for wood floors)
module floor_layer(n, tile, k, bed = BED) {
    r = room(n); b = rbb(r); g = rgrid(r, bed); w = (b[2] - b[0]) / g[0]; h = (b[3] - b[1]) / g[1]; det = tile >= 0 || DETAIL;
    for (i = [0 : g[0] - 1]) for (j = [0 : g[1] - 1]) if (tile < 0 || tile == i + j * g[0])
        translate(tile < 0 ? [0, 0, 0] : [-b[0] - i * w, -b[1] - j * h, 0]) {
            if (k == 0) linear_extrude(FL_T - FL_TOP) clip2d(b, i, j, w, h) room2d(r);
            if (k == 1) translate([0, 0, FL_T - FL_TOP]) linear_extrude(FL_TOP) clip2d(b, i, j, w, h) if (det) main2d(r); else room2d(r);
            if (k == 2 && r[1] != "wood" && det) translate([0, 0, FL_T - FL_TOP]) linear_extrude(FL_TOP) clip2d(b, i, j, w, h) difference() { room2d(r); main2d(r); }
        }
}
function fcol(k) = k == "wood" ? "#D9B77E" : k == "herring" ? "#B8683C" : "#F2F0EA";
function fdark(k) = k == "herring" ? "#3A332E" : "#1B1B1B";
module floors_place() for (r = ROOMS) translate([0, 0, FLOOR_Z]) {
    color(fcol(r[1])) { floor_layer(r[0], -1, 0); floor_layer(r[0], -1, 1); }
    if (DETAIL) color(fdark(r[1])) floor_layer(r[0], -1, 2); }

// ------------------------------------------------------------------ furniture
$fn = 36;
// lunch-room chair (the first bench design, short): profile (u = depth from the back, v = height) in ft
module chair_half2d() polygon([for (p = [[0.15, 1.35], [1.75, 1.5], [1.75, 1.62], [0.3, 1.5], [0.12, 3.6], [0, 3.6], [0, 1.35]]) fp(p)]);
// solid end / divider with the arm rest and legs
module chair_end2d() polygon([for (p = [[0, 0], [0.25, 0], [0.3, 1.2], [1.45, 1.2], [1.5, 0], [1.75, 0], [1.8, 2.25], [0.45, 2.35], [0.12, 3.75], [0, 3.75]]) fp(p)]);
module chair_seat_G(L, double) {    // built along +z = the bench length; stand it on end to print
    n = round(L / 2.5); T = 1.4;
    linear_extrude(ft(L)) { chair_half2d(); if (double) mirror([1, 0]) chair_half2d(); }
    for (i = [0 : n]) translate([0, 0, i * (ft(L) - T) / n]) linear_extrude(T) { chair_end2d(); if (double) mirror([1, 0]) chair_end2d(); }
}
// Waiting-room bench, Chicago Union Station style (Tom's photos): solid shaped ends with scroll arms and a
// domed centre back, heavy seat rail, panelled base with a centre roundel, brass kick plate (paint), no
// arm dividers along the seat.  Profiles in ft: u = depth from the centre line, v = height.
B_END = [[0, 0], [2.25, 0], [2.25, 0.25], [2.1, 0.3], [2.1, 1.3], [2.2, 1.4], [2.45, 1.45], [2.5, 1.6], [2.45, 1.75], [2.3, 1.78], [2.3, 1.9],
         [2.4, 1.95], [2.45, 2.1], [2.35, 2.25], [2.2, 2.28], [1.5, 2.3], [1.1, 2.45], [0.85, 2.8], [0.7, 3.3], [0.6, 3.6], [0.45, 3.75], [0.4, 3.8], [0.3, 3.95], [0, 4.0]];
module bench_end2d() polygon([for (p = B_END) fp(p)]);
module bench_half2d() polygon([for (p = [[0, 1.45], [2.3, 1.45], [2.3, 1.62], [0.55, 1.6], [0.3, 3.5], [0, 3.5]]) fp(p)]);
module bench_leg2d() polygon([for (p = [[0, 0], [1.9, 0], [1.9, 0.25], [1.75, 0.3], [1.75, 1.3], [1.9, 1.45], [0, 1.45]]) fp(p)]);
module bench_panel2d() difference() { translate([ft(0.25), ft(0.5)]) square([ft(1.6), ft(0.7)]); }        // recessed base panel (per half)
module dbl(double) { children(); if (double) mirror([1, 0]) children(); }
module bench_G(L, double) {    // built along +z = the bench length; stand it on end to print
    T = 2.0; R = 0.4; n = max(1, round(L / 3.5));
    translate([0, 0, T]) linear_extrude(ft(L) - 2 * T) dbl(double) bench_half2d();
    for (z = [0, ft(L) - T]) translate([0, 0, z + (z == 0 ? R : 0)]) linear_extrude(T - R) dbl(double) bench_end2d();
    for (z = [0, ft(L) - R]) translate([0, 0, z]) linear_extrude(R) difference() {           // outer face: recessed panels, raised roundel
        dbl(double) bench_end2d(); dbl(double) bench_panel2d();
        translate([0, ft(1.9)]) dbl(double) translate([ft(0.25), 0]) square([ft(1.9), ft(0.22)]); }
    for (z = [0, ft(L) - R]) translate([0, 0, z]) linear_extrude(R) translate([double ? 0 : ft(0.25), ft(0.85)]) circle(d = ft(0.45), $fn = 24);
    if (n > 1) for (k = [1 : n - 1]) translate([0, 0, k * ft(L) / n - 0.7]) linear_extrude(1.4) dbl(double) bench_leg2d();
}
// lunch counter and back bar: profiles extruded along the length
module counter2d() {
    polygon([for (p = [[0, 0], [0.15, 0], [0.15, 3.3], [1.85, 3.3], [1.85, 0], [2, 0], [2, 3.3], [2.1, 3.3], [2.1, 3.5], [-0.5, 3.5], [-0.5, 3.3], [0, 3.3]]) fp(p)]);
    translate([ft(0.15), ft(1.6)]) square([ft(1.7), 1.2]);
}
module counter_G(L) { linear_extrude(ft(L)) counter2d();
    for (z = [0, ft(L) - 1.2]) translate([0, 0, z]) linear_extrude(1.2) square([ft(2), ft(3.3)]); }
module backbar2d() { square([1.2, ft(7)]);
    for (v = [0, 2.8, 4.2, 5.6, 6.9]) translate([0, ft(v)]) square([ft(v < 3 ? 1.5 : 0.9), 1.2]);
    square([ft(1.5), ft(0.3)]); translate([ft(1.5) - 1.2, 0]) square([1.2, ft(2.8)]); }
module backbar_G(L) { linear_extrude(ft(L)) backbar2d();
    for (z = [0, ft(L) / 2 - 0.6, ft(L) - 1.2]) translate([0, 0, z]) linear_extrude(1.2) hull() backbar2d(); }
// stool, modeled seat-down (print orientation)
module stool_G() { cylinder(d = ft(1.15), h = 1.6); cylinder(d = 3, h = ft(2.2) - 3);
    translate([0, 0, ft(2.2) - 4]) cylinder(d1 = 3, d2 = ft(0.85), h = 4); }
// desk, modeled top-down (print orientation): 5'-0" x 2'-6" x 2'-6", drawer block one side
module desk_G() { w = ft(5); d = ft(2.5); h = ft(2.5);
    cube([w, d, 1.4]);
    for (x = [1, w - 3.2]) for (y = [1, d - 3.2]) translate([x, y, 0]) cube([2.2, 2.2, h]);
    translate([w - ft(1.5), 1, 0]) cube([ft(1.5) - 1, d - 2, ft(1.6)]);
    translate([1, d - 2.2, 0]) cube([w - 2, 1.2, ft(1.2)]); }
// ticket case, modeled on its back: 3'-0" wide, 6'-0" high, 1'-0" deep, pigeonholes above a cupboard
module ticket_case_G() { w = ft(3); h = ft(6); d = ft(1);
    cube([w, h, 1]);
    linear_extrude(d) { difference() { square([w, h]); offset(delta = -1) square([w, h]); }
        for (i = [1 : 5]) translate([i * w / 6 - 0.4, ft(2.5)]) square([0.8, h - ft(2.5)]);
        for (j = [0 : 7]) translate([0, ft(2.5) + j * (h - ft(2.5)) / 8 - 0.4]) square([w, 0.8]); }
    cube([w, ft(2.5), d - 0.6]); }
module safe_G() { cube([ft(2.5), ft(2.5), ft(4)]); translate([ft(0.2), -0.6, ft(0.3)]) cube([ft(2.1), 0.7, ft(3.4)]);
    translate([ft(1.9), -1.4, ft(2)]) rotate([-90, 0, 0]) cylinder(d = 2.5, h = 1); }
// ticket-window grille (printed flat) + counter shelf.  w = opening width (ft); opening 3'-6" high
module grille_G(w) { W = ft(w) + 3; H = ft(3.5) + 3;
    linear_extrude(0.8) { difference() { square([W, H]); translate([1.5, 1.5]) square([W - 3, H - 3]); }
        for (x = [1.5 + 2.2 : 2.2 : W - 2.5]) translate([x - 0.3, ft(1.1)]) square([0.6, H - ft(1.1)]);
        translate([0, ft(1.1)]) square([W, 1]); translate([0, H - ft(0.7)]) square([W, 0.8]); }
}
module shelf_G(w) cube([ft(w) + 6, ft(1), 1.4]);
// Train bulletin board, 10'-0" x 6'-0" (105 x 63 mm): black board, white lines and lettering.
// Trains at Janesville from the 1940 Milwaukee Road public timetable (Tables 14, 15, 17, 34).
// The white body is INLAID flush in the top 0.4 mm (AMS: Furniture_bulletin black + Furniture_bulletin_white).
// Lettering is 2.2 mm high: print at 0.1-0.12 mm layers, slow, "Arachne" walls; a 0.2 mm nozzle is best.
BB = [ft(10), ft(6)]; BB_M = 1.3; BB_TOP = 8.0; BB_CH = 3.4; BB_COLS = [11, 80]; BB_TXT = 2.2;
BB_FONT = "Liberation Sans:style=Bold";
BB_TRAINS = [
  ["22",  "CHICAGO - THE SIOUX",            "5:13 AM"],
  ["33",  "MADISON - MOTOR FROM BELOIT",    "7:45 AM"],
  ["20",  "CHICAGO",                        "9:35 AM"],
  ["8",   "MILWAUKEE",                      "9:35 AM"],
  ["21",  "ARRIVES FROM MILWAUKEE",         "10:30 AM"],
  ["17",  "MADISON - THE VARSITY",          "11:14 AM"],
  ["21",  "MINERAL POINT",                  "11:20 AM"],
  ["",    "ARRIVES FROM MINERAL POINT",     "5:30 PM"],
  ["18",  "CHICAGO - THE MARQUETTE",        "5:46 PM"],
  ["6",   "MILWAUKEE",                      "5:55 PM"],
  ["7",   "ARRIVES FROM MILWAUKEE",         "7:30 PM"],
  ["325", "BELOIT - ROCKFORD - DAVIS JCT.", "7:47 PM"],
  ["37",  "MADISON",                        "8:30 PM"],
  ["3",   "MADISON - THE MARQUETTE",        "12:52 AM"]];
module bb_white2d() { W = BB[0]; H = BB[1]; n = len(BB_TRAINS); rh = (H - 2 * BB_M - BB_TOP - BB_CH) / n; lw = 0.45; y0 = H - BB_M - BB_TOP - BB_CH;
    difference() { translate([0.4, 0.4]) square([W - 0.8, H - 0.8]); translate([0.9, 0.9]) square([W - 1.8, H - 1.8]); }
    translate([W / 2, H - BB_M - 2.6]) text("THE MILWAUKEE ROAD", size = 3.0, halign = "center", valign = "center", font = BB_FONT);
    translate([W / 2, H - BB_M - 6.2]) text("TRAINS AT JANESVILLE", size = 2.0, halign = "center", valign = "center", font = BB_FONT);
    for (y = concat([H - BB_M - BB_TOP, y0], [for (r = [1 : n - 1]) y0 - r * rh])) translate([BB_M, y - lw / 2]) square([W - 2 * BB_M, lw]);
    for (c = BB_COLS) translate([BB_M + c - lw / 2, BB_M]) square([lw, H - 2 * BB_M - BB_TOP]);
    hy = y0 + BB_CH / 2;
    translate([BB_M + BB_COLS[0] / 2, hy]) text("NO.", size = 1.9, halign = "center", valign = "center", font = BB_FONT);
    translate([BB_M + (BB_COLS[0] + BB_COLS[1]) / 2, hy]) text("TRAIN", size = 1.9, halign = "center", valign = "center", font = BB_FONT);
    translate([(BB_M + BB_COLS[1] + W - BB_M) / 2, hy]) text("TIME", size = 1.9, halign = "center", valign = "center", font = BB_FONT);
    for (r = [0 : n - 1]) { yc = y0 - (r + 0.5) * rh - BB_TXT / 2; t = BB_TRAINS[r];
        translate([BB_M + BB_COLS[0] / 2, yc]) text(t[0], size = BB_TXT, halign = "center", valign = "baseline", font = BB_FONT);
        translate([BB_M + BB_COLS[0] + 1.5, yc]) text(t[1], size = BB_TXT, halign = "left", valign = "baseline", font = BB_FONT);
        translate([W - BB_M - 1.5, yc]) text(t[2], size = BB_TXT, halign = "right", valign = "baseline", font = BB_FONT); }
}
module bulletin() linear_extrude(0.8) square(BB);      // HO: plain black board - the lettering is too small to print, use a paper print or decal
module bulletin_white() translate([0, 0, 0.8]) linear_extrude(0.4) bb_white2d();

// Ticket-window clock: Seth Thomas style octagon drop regulator (from Tom's photo), about 24" x 41" (21 x 36 mm).
// Four AMS bodies, loaded together as one object, printed flat, face up:
//   Furniture_ticket_clock        case           dark cherry
//   Furniture_ticket_clock_face   dial           cream
//   Furniture_ticket_clock_black  hour marks, hands, bezel line, pendulum-window glass   black
//   Furniture_ticket_clock_brass  pendulum rod and bob                                   brass
// The hour marks are bold bars (true Roman numerals are too fine to print at this size).
TC_R = 10.5; TC_DIAL = 7.5;
module tc_oct2d(r) rotate(22.5) circle(r = r / cos(22.5), $fn = 8);
module tc_drop2d() polygon([[-5.5, -8], [5.5, -8], [5.5, -22], [0, -25.5], [-5.5, -22]]);
module tc_case2d() { tc_oct2d(TC_R); tc_drop2d(); }
module tc_win2d() polygon([[-3, -12.5], [3, -12.5], [3, -20.8], [0, -22.6], [-3, -20.8]]);
module tc_brass2d() { translate([0.5, -19]) circle(d = 3.8, $fn = 40); hull() { translate([0, -12.7]) circle(d = 0.6, $fn = 12); translate([0.5, -19]) circle(d = 0.6, $fn = 12); } }
module tc_marks2d() {
    difference() { circle(r = TC_DIAL + 0.55, $fn = 72); circle(r = TC_DIAL, $fn = 72); }
    for (h = [0 : 11]) rotate(-h * 30) translate([-(h % 3 == 0 ? 0.4 : 0.28), 5.0]) square([h % 3 == 0 ? 0.8 : 0.56, 1.9]);
    rotate(-125) hull() { circle(d = 0.7, $fn = 12); translate([0, 3.9]) circle(d = 0.5, $fn = 12); }      // hour hand, about 4 o'clock
    rotate(2) hull() { circle(d = 0.6, $fn = 12); translate([0, 5.9]) circle(d = 0.45, $fn = 12); }        // minute hand, at 12
    circle(d = 1.4, $fn = 20);
}
module tc_black2d() { tc_marks2d(); difference() { tc_win2d(); tc_brass2d(); } }
module tc_face2d() circle(r = TC_DIAL, $fn = 72);      // HO: plain dial
module tc_part_G(n) {
    if (n == "Furniture_ticket_clock") {
        linear_extrude(1.2) tc_case2d();
        translate([0, 0, 1.2]) linear_extrude(0.4) difference() { tc_case2d(); circle(r = TC_DIAL + 0.55, $fn = 72); tc_win2d(); }
        translate([0, 0, 1.6]) linear_extrude(0.7) {                                                           // raised mouldings
            difference() { tc_oct2d(TC_R); circle(r = TC_DIAL + 1.2, $fn = 72); }
            difference() { tc_drop2d(); offset(delta = 0.8) tc_win2d(); tc_oct2d(TC_R); }
            difference() { offset(delta = 0.8) tc_win2d(); tc_win2d(); tc_oct2d(TC_R); } }
    }
    if (n == "Furniture_ticket_clock_face")  translate([0, 0, 1.2]) linear_extrude(0.4) tc_face2d();
    if (n == "Furniture_ticket_clock_black") translate([0, 0, 1.2]) linear_extrude(0.4) tc_black2d();
    if (n == "Furniture_ticket_clock_brass") translate([0, 0, 1.2]) linear_extrude(0.4) tc_brass2d();
}
TC_PARTS = ["Furniture_ticket_clock", "Furniture_ticket_clock_face"];
module tc_colored() { color("#4A1512") tc_part(TC_PARTS[0]); color("#F1E9D2") tc_part(TC_PARTS[1]); }

// ---- HO: furniture is the G-scale (1:29) design reduced to 1:87
module g() if ($sc == 29) children(); else scale(29 / SCALE) { $sc = 29; children(); }
module chair_seat(L, double) g() chair_seat_G(L, double);
module bench(L, double) g() bench_G(L, double);
module counter(L) g() counter_G(L);
module backbar(L) g() backbar_G(L);
module stool() g() stool_G();
module desk() g() desk_G();
module ticket_case() g() ticket_case_G();
module safe() g() safe_G();
module grille(w) g() grille_G(w);
module shelf(w) g() shelf_G(w);
module radiator() g() radiator_G();
module clock() g() clock_G();
module range() g() range_G();
module truck_body() g() truck_body_G();
module truck_wheel() g() truck_wheel_G();
module bag_scale() g() bag_scale_G();
module sink() g() sink_G();
module toilet() g() toilet_G();
module wall_mirror() g() wall_mirror_G();
module kitchen_sink() g() kitchen_sink_G();
module pedestal(dtop, h) g() pedestal_G(dtop * SCALE / 29, h * SCALE / 29);
module tc_part(n) scale([29 / SCALE, 29 / SCALE, 0.5]) tc_part_G(n);
// ---- more furniture
module radiator_G() { n = 14; p = ft(4) / n;                       // cast-iron column radiator, 4 ft x 3 ft high; print upright
    linear_extrude(ft(3)) { translate([0, ft(0.25)]) square([ft(4) - p + 1.2, ft(0.2)]);
        for (i = [0 : n - 1]) translate([i * p, 0]) hull() { translate([0.6, 0.6]) circle(d = 1.2, $fn = 12); translate([0.6, ft(0.7) - 0.6]) circle(d = 1.2, $fn = 12); } }
    linear_extrude(1) square([ft(4) - p + 1.2, ft(0.7)]); }
module clock_G() {                                                 // wall regulator clock, printed flat
    linear_extrude(0.8) { translate([ft(0.75), ft(1.9)]) circle(d = ft(1.5)); translate([ft(0.35), 0]) square([ft(0.8), ft(1.4)]); }
    translate([0, 0, 0.8]) linear_extrude(0.5) { translate([ft(0.75), ft(1.9)]) { difference() { circle(d = ft(1.5)); circle(d = ft(1.5) - 2); }
            square([0.5, ft(0.55)]); rotate(-120) square([0.5, ft(0.4)]); circle(d = 1.2); }
        translate([ft(0.35), 0]) difference() { square([ft(0.8), ft(1.4)]); translate([1, 1]) square([ft(0.8) - 2, ft(1.4) - 2]); }
        translate([ft(0.75) - 0.25, ft(0.4)]) square([0.5, ft(0.9)]); translate([ft(0.75), ft(0.4)]) circle(d = 2.2); } }
module range_G() { cube([ft(4), ft(2.5), ft(2.7)]); cube([ft(4), 1.2, ft(5)]);      // kitchen range; back against the wall
    translate([0, 0, ft(4.6)]) cube([ft(4), ft(0.9), 1.2]);
    for (x = [1, 3]) for (y = [0.8, 1.8]) translate([ft(x), ft(y), ft(2.7)]) cylinder(d = ft(0.8), h = 0.5);
    translate([ft(3.3), ft(0.45), ft(4.6)]) cylinder(d = ft(0.5), h = ft(3)); }
module pedestal_G(dtop, h) { cylinder(d = dtop, h = 1.4); cylinder(d = 3.2, h = h - 3);    // modeled top-down (print orientation)
    translate([0, 0, h - 5]) cylinder(d1 = 3.2, d2 = ft(1.6), h = 5); }
module truck2d() { polygon([for (p = [[0, 2.2], [0, 5], [0.15, 5], [0.15, 2.9], [0.8, 2.45], [5.2, 2.45], [5.85, 2.9], [5.85, 5], [6, 5], [6, 2.2], [5.2, 2.2], [5.2, 1.0], [4.7, 1.0], [4.7, 2.2], [1.3, 2.2], [1.3, 1.0], [0.8, 1.0], [0.8, 2.2]]) fp(p)]); }
module truck_body_G() linear_extrude(ft(3)) truck2d();               // baggage truck, printed on its side
module truck_wheel_G() difference() { union() { cylinder(d = ft(2), h = 1.2); cylinder(d = ft(0.5), h = 1.8); }
    for (a = [0 : 60 : 300]) rotate(a) translate([ft(0.3), -ft(0.12), -1]) cube([ft(0.5), ft(0.24), 4]); }
module bag_scale_G() { cube([ft(3), ft(2.5), ft(0.35)]); translate([ft(0.1), ft(1), 0]) cube([ft(0.5), ft(0.5), ft(4.2)]);
    translate([ft(0.1), ft(0.3), ft(3.9)]) cube([ft(0.5), ft(1.9), ft(0.5)]); }

// ---- plumbing fixtures (white porcelain)
// pedestal lavatory, modeled upside down (print orientation): 2'-0" x 1'-6", rim 2'-7" high.  y = 0 is the wall side.
module sink_G() { w = ft(2); d = ft(1.5); h = ft(2.6);
    difference() { hull() { cube([w, d, 1.2]); translate([2, 0, 3.6]) cube([w - 4, d - 2.5, 0.4]); }
        translate([w / 2, d / 2 + 0.6, 0]) scale([w / 2 - 2.2, d / 2 - 2.6, 2.6]) sphere(r = 1, $fn = 32); }
    translate([w / 2, d / 2 - 1, 4]) cylinder(d1 = 8.5, d2 = 6, h = h - 4 - 2, $fn = 24);
    translate([w / 2, d / 2 - 1, h - 2]) cylinder(d1 = 6, d2 = 9, h = 2, $fn = 24); }
// water closet with wall tank and flush pipe, modeled on its back (print orientation): x = width, y = height, z = depth from the wall
module toilet_G() {
    translate([-ft(0.5), 0, 0]) linear_extrude(ft(1.6)) polygon([[0, 0], [ft(1), 0], [ft(0.85), ft(1.0)], [ft(0.15), ft(1.0)]]);        // pedestal
    translate([-ft(0.65), ft(1.0), 0]) difference() { linear_extrude(ft(2.2)) square([ft(1.3), ft(0.35)]);                              // bowl + seat
        translate([ft(0.65), ft(0.36), ft(1.25)]) rotate([90, 0, 0]) scale([ft(0.42), ft(0.62), 1]) cylinder(r = 1, h = ft(0.22), $fn = 32); }
    translate([-ft(0.08), ft(1.3), 0]) cube([ft(0.16), ft(3.4), ft(0.16)]);                                                             // flush pipe
    translate([-ft(0.85), ft(4.7), 0]) cube([ft(1.7), ft(1.2), ft(0.7)]);                                                               // tank
}
module wall_mirror_G() { linear_extrude(0.6) square([ft(1.5), ft(2)]); translate([0, 0, 0.6]) linear_extrude(0.5) difference() { square([ft(1.5), ft(2)]); translate([1.2, 1.2]) square([ft(1.5) - 2.4, ft(2) - 2.4]); } }
// kitchen sink on legs, modeled upside down (print orientation): 5'-0" x 2'-0" x 3'-0", basin + drainboard
module kitchen_sink_G() { w = ft(5); d = ft(2); h = ft(3);
    difference() { cube([w, d, 3.2]); translate([2, 2, -1]) cube([ft(2.2), d - 4, 2.6]);
        for (i = [0 : 7]) translate([ft(2.6) + i * 3, 2.5, -1]) cube([1.2, d - 5, 1.4]); }                                              // drainboard grooves
    for (x = [1, w - 3.4]) for (y = [1, d - 3.4]) translate([x, y, 0]) cube([2.4, 2.4, h]);
}
PORCELAIN = "#F4F4F0";
module fixtures_place() {
    color(PORCELAIN) {
        translate([ft(40.25) + 1.6, ft(28), ZF + ft(2.6)]) rotate([0, 0, -90]) mirror([0, 0, 1]) sink();                                // women's, on the waiting-room partition
        translate([ft(91), ft(18) + 0.4, ZF + ft(2.6)]) mirror([0, 0, 1]) sink();                                                        // men's, on the chimney breast
        translate([ft(49.5) - 2.4, ft(29), ZF]) rotate([0, 0, -90]) rotate([90, 0, 0]) toilet();                                         // women's
        translate([ft(98 + 1/12) - T_MAIN - 0.9, ft(29), ZF]) rotate([0, 0, -90]) rotate([90, 0, 0]) toilet();                           // men's
        translate([ft(116) + 2.4, ft(26), ZF + ft(3)]) rotate([0, 0, -90]) mirror([0, 0, 1]) kitchen_sink();                             // kitchen, on the lunch-room partition
    }
    color("#9FB7C4") {
        translate([ft(40.25) + 1.6, ft(28) - ft(1) - ft(0.75), FLOOR_Z + ft(4)]) rotate([90, 0, 90]) wall_mirror();
        translate([ft(92) + ft(0.75), ft(18) + 0.3, FLOOR_Z + ft(4)]) rotate([90, 0, 180]) wall_mirror();
    }
}

// ---- electronics bay in the express room of the baggage building ----
// Electronics_tray  sits on the floor over the express-room feed hole: pocket for an ESP32 dev board
//                   (up to 58 x 29 mm), space for a terminal block / fuse / level shifter, zip-tie slots.
// Electronics_cover a pile of express crates that drops over the tray and hides it; lift it off to get at the board.
//                   Modeled as it sits; print it UPSIDE DOWN (top on the bed).  Notches at the bottom for the wires.
EL = [98, 72];                      // tray size (mm)
EL_POS = [X_BAG_E - ft(10) - 60, (BAG_Y0 + BAG_Y1) / 2 - 36];   // tray corner: feed hole comes up near one end
module el_tray() difference() {
    union() { cube([EL[0], EL[1], 1.6]);
        difference() { cube([EL[0], EL[1], 4]); translate([1.6, 1.6, -1]) cube([EL[0] - 3.2, EL[1] - 3.2, 6]); }
        translate([6, 6, 0]) difference() { cube([61, 32, 5]); translate([1.4, 1.4, 1.6]) cube([58.2, 29.2, 5]); translate([-1, 8, 1.6]) cube([70, 16, 5]); }     // ESP32 pocket, open at the USB ends
    }
    translate([60, 36, -1]) cylinder(d = 12, h = 5, $fn = 32);                                   // over the foundation feed hole
    for (x = [14, 40, 80]) for (y = [46, 62]) translate([x, y, -1]) cube([6, 2, 5]);             // zip-tie slots
    for (x = [-1, EL[0] - 2]) translate([x, 28, 1.6]) cube([3, 16, 5]);                          // wire exits in the rim
}
module el_cover() { w = EL[0] + 4; d = EL[1] + 4; h1 = 34; t = 1.6;
    difference() {
        union() {
            cube([w, d, h1]); translate([14, 10, h1]) cube([58, 44, 20]);                         // two stacked crates
            for (x = [-0.6, w - 4.4]) translate([x, -0.6, 0]) cube([5, d + 1.2, h1]);             // battens
            for (z = [3, h1 - 7]) translate([-0.6, -0.6, z]) cube([w + 1.2, d + 1.2, 4]);
            for (z = [h1 + 2, h1 + 14]) translate([13.4, 9.4, z]) cube([59.2, 45.2, 3.5]);
        }
        translate([t, t, -1]) cube([w - 2 * t, d - 2 * t, h1 - t + 1]);
        translate([14 + t, 10 + t, h1 - t - 1]) cube([58 - 2 * t, 44 - 2 * t, 20 - t + 1]);
        for (x = [-2, w - 4]) translate([x, d / 2 - 9, -1]) cube([6, 18, 7]);                     // wire notches
    }
}
module electronics_place() translate([EL_POS[0], EL_POS[1], ZF]) { color("#2E6B3E") el_tray(); color("#A77B4B") translate([-2, -2, 0]) el_cover(); }

FURN = ["Furniture_bench_double", "Furniture_bench_single", "Furniture_lunch_counter", "Furniture_backbar", "Furniture_stools",
        "Furniture_desk", "Furniture_ticket_case", "Furniture_safe", "Furniture_ticket_grilles", "Furniture_bulletin",
        "Furniture_ticket_clock", "Furniture_ticket_clock_face",
        "Furniture_radiator", "Furniture_range", "Furniture_table", "Furniture_chair", "Furniture_baggage_truck", "Furniture_scale",
        "Furniture_sink", "Furniture_toilet", "Furniture_mirror", "Furniture_kitchen_sink"];
// how many of each STL to print (everything else: 1)
QTY = [["Furniture_ticket_clock (both bodies)", 2], ["Furniture_bench_double", 6], ["Furniture_bench_single", 2], ["Furniture_radiator", 6], 
       ["Furniture_table", 2], ["Furniture_sink", 2], ["Furniture_toilet", 2], ["Furniture_mirror", 2], ["Furniture_chair", 8], ["Furniture_baggage_truck", 2]];
module furniture_part(n) {
    if (n == "Furniture_bench_double") bench(10, true);
    if (n == "Furniture_bench_single") bench(8, false);
    if (n == "Furniture_lunch_counter") counter(11);
    if (n == "Furniture_backbar") backbar(8);
    if (n == "Furniture_stools") for (i = [0 : 4]) translate([i * (ft(1.15) + 3), 0, 0]) stool();
    if (n == "Furniture_desk") desk();
    if (n == "Furniture_ticket_case") ticket_case();
    if (n == "Furniture_safe") safe();
    if (n == "Furniture_ticket_grilles") { grille(3); translate([ft(3) + 8, 0, 0]) grille(4); translate([0, -ft(1) - 4, 0]) shelf(3); translate([ft(3) + 12, -ft(1) - 4, 0]) shelf(4); }
    if (n == "Furniture_bulletin") bulletin();
    if (n == "Furniture_bulletin_white") bulletin_white();
    for (t = TC_PARTS) if (n == t) tc_part(n);
    if (n == "Furniture_radiator") radiator();
    if (n == "Furniture_range") range();
    if (n == "Furniture_table") pedestal(ft(3), ft(2.5));
    if (n == "Furniture_chair") chair_seat(1.5, false);
    if (n == "Furniture_baggage_truck") { truck_body(); for (i = [0 : 3]) translate([ft(1.1) + i * (ft(2) + 2), -ft(1.2), 0]) truck_wheel(); }
    if (n == "Furniture_scale") bag_scale();
    if (n == "Furniture_sink") sink();
    if (n == "Furniture_toilet") toilet();
    if (n == "Furniture_mirror") wall_mirror();
    if (n == "Furniture_kitchen_sink") kitchen_sink();
    if (n == "Electronics_tray") el_tray();
    if (n == "Electronics_cover") translate([0, 0, 54]) mirror([0, 0, 1]) el_cover();     // exported upside down, ready to print
}
function interior_floor_parts(bed) = concat(
    [for (r = ROOMS) [str("Floor_", r[0]), floor_count(r[0], bed)]],
    [for (r = ROOMS) if (r[1] != "wood") [str("Floor_", r[0], "_dark"), floor_count(r[0], bed)]]);
function furniture_parts() = [for (n = FURN) [n, 1]];
module floor_part(name, tile = -1, bed = BED) for (r = ROOMS) {
    if (name == str("Floor_", r[0])) { floor_layer(r[0], tile, 0, bed); floor_layer(r[0], tile, 1, bed); }
    if (name == str("Floor_", r[0], "_dark")) floor_layer(r[0], tile, 2, bed);
}

// ------------------------------------------------------------------ placement in the building
ZF = FLOOR_Z + FL_T;
// extruded pieces: length along local +x, depth along local +y from (x, y) ft, turned by ang
module along(x, y, ang) translate([ft(x), ft(y), ZF]) rotate([0, 0, ang]) multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) children();
module furniture_place() color(OAK) {
    for (y = [11, 21]) for (x = [5, 19]) along(x, y, 0) bench(10, true);          // general waiting room
    for (y = [2, 22]) along(0.75, y + 8, -90) bench(8, false);                    // west wall, either side of the door
    for (y = [11, 21]) along(67, y, 0) bench(10, true);                           // smoking room
    along(127.6, 13.6, 180) counter(11);                                          // lunch counter in front of the kitchen
    along(127.7, 26.0, 180) backbar(8);                                           // back bar on the kitchen's north wall
    for (i = [0 : 4]) translate([ft(118 + i * 2), ft(11.3), ZF + ft(2.2)]) mirror([0, 0, 1]) stool();
    translate([ft(44.4), ft(0.9), ZF + ft(2.5)]) mirror([0, 0, 1]) desk();        // agent's desk at the bay
    translate([ft(54.6), ft(2), ZF]) rotate([0, 0, 90]) rotate([90, 0, 0]) translate([0, 0, -ft(1)]) ticket_case();
    color("#222222") translate([ft(52), ft(10.6), ZF]) rotate([0, 0, 180]) translate([-ft(2.5), 0, 0]) safe();
    color("#B08D57") {
        translate([ft(40.25) + 1.6, ft(7) - ft(1.5) - 1.5, FLOOR_Z + ft(3) - 1.5]) rotate([90, 0, 90]) grille(3);
        translate([ft(45.25) - ft(2) - 1.5, ft(11.75) - 2.5, FLOOR_Z + ft(3) - 1.5]) rotate([90, 0, 0]) grille(4);
    }
    color("#3A3A3A") {                                                                         // radiators under the windows
        for (x = [8, 30, 74]) { translate([ft(x), T_MAIN + 1.5, ZF]) radiator(); translate([ft(x + 4), MAIN_DEPTH - T_MAIN - 1.5, ZF]) rotate([0, 0, 180]) radiator(); }
        translate([XL1 - T_LIGHT - 1, ft(19.5), ZF]) rotate([0, 0, 90]) range();               // kitchen, east wall
        translate([X_BAG_W + ft(3), ft(20), ZF]) bag_scale();
    }
    for (ty = [8, 19]) translate([ft(104), ft(ty), ZF]) {                                      // lunch-room tables and chairs
        translate([0, 0, ft(2.5)]) mirror([0, 0, 1]) pedestal(ft(3), ft(2.5));
        for (a = [0, 90, 180, 270]) rotate(a) translate([-ft(0.75), -ft(3.1), 0]) multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) chair_seat(1.5, false);
    }
    for (q = [[X_BAG_W + ft(12), ft(8), 0], [X_BAG_W - ft(20), ft(-9), 0]]) translate([q[0], q[1], q[0] > X_BAG_W ? ZF : FLOOR_Z - ft(0.5)]) {   // baggage trucks
        translate([0, ft(3), 0]) rotate([90, 0, 0]) truck_body();
        for (x = [1.05, 4.95]) for (y = [-1.3, ft(3) + 0.1]) translate([ft(x), y, ft(1)]) rotate([-90, 0, 0]) truck_wheel();
    }
}

// ------------------------------------------------------------------ lighting: light bars and ceilings
//  NeoPixel (WS2812B) strip, 10 mm wide, cut into single pixels or short lengths, lies LED-DOWN in the
//  channel of a light bar or on top of a ceiling panel; each LED shines through a 5.6 mm window.
//  Nothing is fixed to the roof, so the roof still lifts off.
//    Light_bar_main    spans the 32 ft rooms (waiting room x2, smoking room x2)     2 pixels each
//    Light_bar_short   spans the lunch wing (x3) and the baggage building (x3)      2 pixels each
//    Light_clips       ledges glued to the inside of the walls; each bar end sits on one
//    Light_splices     plates to join bar halves (small printer only)
//    Ceiling_pavilion  10 ft plaster ceiling over the ticket office block (5 pixels), rests on the partitions
//    Ceiling_east      10 ft ceiling over the annex and men's toilet (2 pixels)
LB_W = 13; LB_WALL = 1.2; LB_H = 3.3; LB_BASE = 0.8; PIX = 5.6;
BAR_MAIN = [MAIN_DEPTH - 2 * T_MAIN - 3, [ft(10.5) - T_MAIN, ft(21.5) - T_MAIN]];                  // length, pixel positions (mm from the track-side end)
BAR_SHORT = [LUNCH_Y1 - LUNCH_Y0 - 2 * T_LIGHT - 3, [ft(6.5), ft(18)]];
BARS_MAIN_X = [13.5, 27, 69, 79];  Z_BAR_MAIN = 17.5;             // ft
BARS_SHORT_X = [104, 111.5, 122];  Z_BAR_LOW = 9.6;
BARS_BAG_X = [10, 21, 39];                                        // ft east of the baggage building west wall
function bar_n(b, bed) = ceil(b[0] / (bed[0] - 10));
module bar(b, tile = -1, bed = BED) { n = bar_n(b, bed); L = b[0] / n;
    for (i = [0 : n - 1]) if (tile < 0 || tile == i) translate(tile < 0 ? [0, 0, 0] : [-i * L, 0, 0]) {
        linear_extrude(LB_BASE) intersection() { translate([i * L, 0]) square([L, LB_W]);
            difference() { square([b[0], LB_W]); for (u = b[1]) translate([u - PIX / 2, (LB_W - PIX) / 2]) square(PIX); } }
        for (y = [0, LB_W - LB_WALL]) translate([i * L, y, 0]) cube([L, LB_WALL, LB_H]);
    } }
module clip() linear_extrude(LB_W + 3) polygon([[0, 0], [1.2, 0], [1.2, 6], [5, 6], [5, 7.2], [1.2, 7.2], [1.2, 12], [0, 12]]);   // printed on its side
CEIL = [["Ceiling_pavilion", R(40.25, 0, 60.25, 32, [iB + 1, iM + 1, iB + 1, iM + 1]), [[47.5, 6], [57.6, 6], [50, 16.5], [45, 26.5], [55, 26.5]], 10],
        ["Ceiling_east",     R(87.35, 0, 98 + 1/12, 32, [iB + 1, iM + 1, iM + 1, iM + 1]), [[92.7, 8], [92.7, 24]], 10,
         [[ft(87.62) - 0.5, ft(14) - 0.5, ft(96.3) + 0.5, ft(18) + 0.5]]]];      // notch round the chimney base
function ceil_grid(c, bed) = [ceil((c[1][2] - c[1][0]) / (bed[0] - 8)), ceil((c[1][3] - c[1][1]) / (bed[1] - 8))];
module ceiling(c, tile = -1, bed = BED) { q = c[1]; g = ceil_grid(c, bed); w = (q[2] - q[0]) / g[0]; h = (q[3] - q[1]) / g[1];
    for (i = [0 : g[0] - 1]) for (j = [0 : g[1] - 1]) if (tile < 0 || tile == i + j * g[0])
        translate(tile < 0 ? [0, 0, 0] : [-q[0] - i * w, -q[1] - j * h, 0]) linear_extrude(0.8) intersection() {
            translate([q[0] + i * w, q[1] + j * h]) square([w, h]);
            difference() { translate([q[0], q[1]]) square([q[2] - q[0], q[3] - q[1]]);
                for (p = c[2]) translate([ft(p[0]) - PIX / 2, ft(p[1]) - PIX / 2]) square(PIX);
                if (len(c) > 4) for (n = c[4]) translate([n[0], n[1]]) square([n[2] - n[0], n[3] - n[1]]); } } }
function light_parts(bed) = concat([["Light_bar_main", bar_n(BAR_MAIN, bed)], ["Light_bar_short", bar_n(BAR_SHORT, bed)], ["Light_clips", 1], ["Light_splices", 1]],
    [for (c = CEIL) [c[0], ceil_grid(c, bed)[0] * ceil_grid(c, bed)[1]]]);
module light_part(n, tile = -1, bed = BED) {
    if (n == "Light_bar_main") bar(BAR_MAIN, tile, bed);
    if (n == "Light_bar_short") bar(BAR_SHORT, tile, bed);
    if (n == "Light_clips") for (i = [0 : 9]) translate([(i % 5) * 9, floor(i / 5) * 16, 0]) clip();
    if (n == "Light_splices") for (i = [0 : 3]) translate([i * 14, 0, 0]) cube([LB_W - 2 * LB_WALL - 0.4, 30, 1]);
    for (c = CEIL) if (n == c[0]) ceiling(c, tile, bed);
}
module lights_place(ceilings = true, bars = true) {
    color("#E8E4D8") {
        if (bars) for (x = BARS_MAIN_X) translate([ft(x) + LB_W / 2, T_MAIN + 1.5, FLOOR_Z + ft(Z_BAR_MAIN)]) rotate([0, 0, 90]) bar(BAR_MAIN);
        if (bars) for (x = BARS_SHORT_X) translate([ft(x) + LB_W / 2, LUNCH_Y0 + T_LIGHT + 1.5, FLOOR_Z + ft(Z_BAR_LOW)]) rotate([0, 0, 90]) bar(BAR_SHORT);
        if (bars) for (x = BARS_BAG_X) translate([X_BAG_W + ft(x) + LB_W / 2, BAG_Y0 + T_LIGHT + 1.5, FLOOR_Z + ft(Z_BAR_LOW)]) rotate([0, 0, 90]) bar(BAR_SHORT);
        if (ceilings) for (c = CEIL) translate([0, 0, FLOOR_Z + ft(c[3])]) ceiling(c);
    }
    color("#FFD27A") {            // the pixels
        if (bars) for (x = BARS_MAIN_X) for (u = BAR_MAIN[1]) translate([ft(x), T_MAIN + 0.5 + u, FLOOR_Z + ft(Z_BAR_MAIN) - 0.3]) cube([5, 5, 1.4], center = true);
        if (bars) for (x = concat(BARS_SHORT_X, [for (b = BARS_BAG_X) X_BAG_W / ft(1) + b])) for (u = BAR_SHORT[1]) translate([ft(x), LUNCH_Y0 + T_LIGHT + 0.5 + u, FLOOR_Z + ft(Z_BAR_LOW) - 0.3]) cube([5, 5, 1.4], center = true);
        if (ceilings) for (c = CEIL) for (p = c[2]) translate([ft(p[0]), ft(p[1]), FLOOR_Z + ft(c[3]) - 0.3]) cube([5, 5, 1.4], center = true);
    }
}
BOARD_Z = 5.5;      // bottom of the train board above the floor (ft): just above the wainscot cap, top at 11 ft 6 in
module board_place() translate([ft(40.25) - 1.6, ft(30.9), FLOOR_Z + ft(BOARD_Z)]) rotate([90, 0, -90]) color("#151515") bulletin();   // train board, waiting room east wall
module ticket_clock_place() {
    translate([ft(40.25) - 1.6, ft(7), FLOOR_Z + ft(7.2) + 8.5]) rotate([90, 0, -90]) tc_colored();   // over the waiting-room ticket window
    translate([ft(60.25) + 1.6, ft(7), FLOOR_Z + ft(7.2) + 8.5]) rotate([90, 0, 90]) tc_colored();    // smoking room, same height
}
module interior_fit_place(ceilings = true, bars = true) { floors_place(); furniture_place(); fixtures_place(); board_place(); ticket_clock_place(); lights_place(ceilings, bars); }
function is_floor(n) = len(n) > 6 && n[0] == "F" && n[1] == "l";

if (LIST) { for (p = interior_floor_parts(BED)) echo(str("IPART|", p[0], "|", p[1])); for (p = furniture_parts()) echo(str("IPART|", p[0], "|", p[1])); for (p = light_parts(BED)) echo(str("IPART|", p[0], "|", p[1])); }
else if (VIEW == "placed") interior_fit_place();
else if (LAYER >= 0) floor_layer(PART, TILE, LAYER, BED);
else if (is_floor(PART)) floor_part(PART, TILE, BED);
else if (PART[0] == "L" || PART[0] == "C") light_part(PART, TILE, BED);
else furniture_part(PART);
