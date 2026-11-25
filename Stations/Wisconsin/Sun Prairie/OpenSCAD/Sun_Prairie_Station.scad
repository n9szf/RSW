// =====================================================================
//  MILWAUKEE ROAD - SUN PRAIRIE, WISCONSIN, PASSENGER STATION (1914)
//  C.M.&St.P. Ry. Engineering Dept., Chicago, May 22 1914, drawings
//  B-1610 (floor and foundation plans, 16-1040-1) and B-1611 (cross
//  section and elevations, 16-1040-2). Architect J. A. Lindstrand (?).
//  Rib Side Works. FIRST SHAPE MODEL for review (TDQ-316) - not cut into
//  printable sections yet.
//
//  Sources (private reference): Research Library / RSW / Stations /
//  Wisconsin / Sun Prairie / MPL drawings (private - in copyright).
//
//  The 1914 job: the old depot (80 ft 6 in, freight and baggage room at
//  the west end) was kept and a 24 ft "new portion" (general waiting
//  room) was added at the east end, all under one roof.
//
//  KNOWN (figures written on the drawings): 104 ft 0 in long overall
//    (old depot 80 ft 6 in + new portion 24 ft); 25 ft 0 in wide;
//    freight and baggage room 24 x 45 ft; general waiting room
//    23 ft 6 in x 24 ft; operator's bay 9 ft wide on the track side;
//    shingle roof, 4 in lap siding below, boards and battens above;
//    face-brick chimneys; concrete platform; piers 16 in square.
//  Album of Depot Plans sheet 104 (drawn 1919, 'built in 1914'): walls
//    12 ft floor to plate, eave overhang 5 ft, freight room 24 x 48, smoking
//    room 15 ft 6 x 24, ticket office 15 ft 6 x 17 ft 6, platform 20 ft wide.
//  MEASURED (scaled, +/- 1 ft): gutter 13 ft 6 in above grade, ridge about
//    22 ft 6 in, window and door positions and sizes, chimney
//    positions, room divisions in the old depot.
//  ESTIMATE: colours (Milwaukee Road depot colours, to confirm), the
//    bracket count under the eaves, the end overhang, door panels.
//
//  Layout: x = feet along the track from the freight-room end.
//  y = 0 is the TOWN side, the track side is +y (y = 25).
//  z = 0 is the grade.
// =====================================================================

SCALE = 29;        // 29 = G (1:29), 48 = O (1:48), 87 = HO (1:87)
SHOW  = "all";     // all, building, roof, platform
function f(ft) = ft * 304.8 / SCALE;

L = 104;  W = 25;                       // KNOWN
floor_h = 1.5;                          // MEASURED (door sills just above the platform)
eave_h  = 13.5; ridge_h = 22.5;         // MEASURED off album sheet 104 (1919), 12 ft walls floor to plate
ov = 5; ov_end = 2;                     // side overhang KNOWN (5 ft 0 in, sheet 104), end overhang ESTIMATE
rise   = (ridge_h - eave_h) / (W / 2 + ov);   // roof slope; eave_h is the gutter line
plate_h = eave_h + ov * rise;           // where the roof meets the wall face
lap_top = 9.6;                          // top of the lap siding / bottom of the boards and battens band (MEASURED)
plat_w  = 20;                           // platform to its edge, track side (KNOWN, sheet 104)

// windows: [x centre, width, height, sill above grade]
win_w = 3; win_h = 6;   win_sill = 3.5;                      // MEASURED
town_windows  = [51.6, 59.2, 72, 84.2, 90.8, 98];            // MEASURED (townside elevation)
track_windows = [49, 52.5, 61, 69, 79, 90.5, 97];            // MEASURED (trackside elevation)
// doors: [x centre, width, height, side 0 = town / 1 = track, type 0 = passenger 1 = baggage 2 = freight]
doors = [ [15,   7,   8,   0, 2],      // freight door, town side
          [39.4, 5,   8,   0, 1],      // baggage double door, town side
          [39.5, 5.5, 8,   1, 1],      // baggage double door, track side
          [56.5, 3,   7.5, 1, 0],      // smoking room door
          [84,   3,   7.5, 1, 0] ];    // general waiting room door
bay_x = 74; bay_w = 9; bay_d = 2.5;                         // operator's bay, KNOWN width, depth MEASURED
chimneys = [47, 79.5];  vents = [55.4, 92];                  // MEASURED
high_win = [17, 5.5, 2.2, 10.5];                             // small freight room window, track side [x, w, h, sill] MEASURED

body = "#8C7B5A"; band = "#6E5E44"; trimc = "#E6E0CF"; roofc = "#4A4E52"; conc = "#B9B5AA";
glass = "#5B7C93"; doorc = "#54302A"; brick = "#8E4A36";   // ESTIMATE - Milwaukee Road depot colours to confirm

module box(x0, y0, z0, l, w, h) { translate([f(x0), f(y0), f(z0)]) cube([f(l), f(w), f(h)]); }
module on_wall(x, side) { translate([f(x), side ? f(W) : 0, 0]) rotate([90, 0, side ? 180 : 0]) children(); }

module window(w, h, sill) {             // two-sash window, 4 lights in the top sash
    translate([-f(w) / 2, f(sill), f(0.02)]) {
        color(glass) cube([f(w), f(h), f(0.1)]);
        color(trimc) {
            translate([-f(0.4), -f(0.4), 0]) cube([f(w) + f(0.8), f(0.4), f(0.4)]);          // sill
            translate([-f(0.4), f(h), 0]) cube([f(w) + f(0.8), f(0.5), f(0.35)]);            // head
            for (x = [-f(0.35), f(w)]) translate([x, 0, 0]) cube([f(0.35), f(h), f(0.3)]);
            translate([0, f(h) / 2 - f(0.1), 0]) cube([f(w), f(0.2), f(0.25)]);             // meeting rail
            translate([f(w) / 2 - f(0.06), f(h) / 2, 0]) cube([f(0.12), f(h) / 2, f(0.2)]);
            translate([0, f(h) * 0.75 - f(0.06), 0]) cube([f(w), f(0.12), f(0.2)]);
        }
    }
}
module door(w, h, type) {
    translate([-f(w) / 2, f(floor_h), f(0.02)]) {
        color(doorc) cube([f(w), f(h), f(0.2)]);
        color(trimc) {
            for (x = [-f(0.4), f(w)]) translate([x, 0, 0]) cube([f(0.4), f(h + (type == 2 ? 0 : 1.6)), f(0.3)]);
            translate([-f(0.4), f(h), 0]) cube([f(w) + f(0.8), f(0.35), f(0.3)]);
            if (type != 2) translate([-f(0.4), f(h + 1.4), 0]) cube([f(w) + f(0.8), f(0.4), f(0.35)]);
            if (type >= 1) translate([f(w) / 2 - f(0.08), 0, 0]) cube([f(0.16), f(h), f(0.3)]);   // centre stile of a double door
            if (type == 0) translate([f(0.4), f(h) * 0.55, f(0.1)]) color(glass) cube([f(w - 0.8), f(h) * 0.38, f(0.15)]);
        }
        if (type != 2) color(glass) translate([0, f(h + 0.35), 0]) cube([f(w), f(1.05), f(0.1)]);   // transom
    }
}
module walls() {
    difference() {
        union() {
            color(body) box(0, 0, 0.5, L, W, lap_top - 0.5);
            color(band) box(0, 0, lap_top, L, W, plate_h - lap_top);
            color(body) translate([0, 0, f(plate_h)]) rotate([90, 0, 90]) linear_extrude(f(L))
                polygon([[0, 0], [f(W), 0], [f(W) / 2, f(ridge_h - plate_h)]]);       // gable fill under the roof
        }
    }
    // battens on the upper band, every 1.5 ft, both sides and both ends
    color(trimc) for (x = [0.75 : 1.5 : L - 0.5]) { box(x, -0.12, lap_top, 0.18, 0.12, eave_h - lap_top); box(x, W, lap_top, 0.18, 0.12, eave_h - lap_top); }
    color(trimc) { box(-0.15, -0.15, lap_top - 0.25, L + 0.3, W + 0.3, 0.3); box(-0.15, -0.15, 0.5, L + 0.3, W + 0.3, 0.35); }    // belt course and water table
    color(trimc) for (x = [-0.25, L - 0.15]) for (y = [-0.25, W - 0.15]) box(x, y, 0.5, 0.4, 0.4, plate_h - 0.5);                 // corner boards
    color(conc) for (x = [0 : 13 : L]) for (y = [0, W - 1.33]) box(min(x, L - 1.33), y, 0, 1.33, 1.33, 0.6);                     // piers
}
module openings() {
    for (x = town_windows)  on_wall(x, 0) window(win_w, win_h, win_sill);
    for (x = track_windows) if (abs(x - bay_x) > bay_w / 2) on_wall(x, 1) window(win_w, win_h, win_sill);
    for (d = doors) on_wall(d[0], d[3]) door(d[1], d[2], d[4]);
    on_wall(high_win[0], 1) window(high_win[1], high_win[2], high_win[3]);
    // ends: two windows in each end (MEASURED from the end elevations)
    for (e = [0, 1]) for (yy = [7, 18]) translate([e ? f(L) : 0, f(yy), 0]) rotate([90, 0, e ? 90 : -90]) window(win_w, win_h, win_sill);
}
module bay() {                           // operator's bay on the track side
    xb = bay_x;
    color(body) translate([f(xb), f(W), 0]) linear_extrude(f(eave_h + (ov - bay_d) * rise - 0.3))
        polygon([[-f(bay_w) / 2, 0], [f(bay_w) / 2, 0], [f(bay_w) / 2 - f(bay_d) * 0.7, f(bay_d)], [-f(bay_w) / 2 + f(bay_d) * 0.7, f(bay_d)]]);
    for (a = [-1, 0, 1]) translate([f(xb + a * (bay_w / 2 - 1.2)), f(W + bay_d * (a == 0 ? 1 : 0.55)) + f(0.05), 0])
        rotate([90, 0, 180 + a * 35]) window(2.4, win_h, win_sill);
}
module brackets() {                      // row of shaped brackets under the eaves (the drawings show them close-set)
    color(trimc) for (x = [0.6 : 1.33 : L - 0.4]) for (s = [0, 1])
        translate([f(x), s ? f(W) : 0, f(eave_h - 1.2)]) rotate([0, 0, s ? 0 : 180]) rotate([90, 0, 90])
            linear_extrude(f(0.25)) polygon([[0, 0], [0, f(1.2 + ov * rise)], [f(ov - 0.4), f(1.2 + 0.4 * rise)], [f(0.6), f(0.5)]]);
}
module roof() {
    t = 0.5;
    color(roofc) translate([-f(ov_end), 0, 0]) rotate([90, 0, 90]) linear_extrude(f(L + 2 * ov_end))
        polygon([[-f(ov), f(eave_h)], [f(W / 2), f(ridge_h)], [f(W + ov), f(eave_h)],
                 [f(W + ov), f(eave_h + t)], [f(W / 2), f(ridge_h + t * 1.1)], [-f(ov), f(eave_h + t)]]);
    color(trimc) for (y = [-ov, W + ov - 0.5]) box(-ov_end, y, eave_h - 0.45, L + 2 * ov_end, 0.5, 0.5);   // gutters
    color(trimc) box(-ov_end, W / 2 - 0.25, ridge_h + 0.45, L + 2 * ov_end, 0.5, 0.25);                                // ridge board
    for (x = chimneys) color(brick) { box(x - 0.75, W / 2 - 0.75, ridge_h - 3, 1.5, 1.5, 6); box(x - 0.95, W / 2 - 0.95, ridge_h + 2.6, 1.9, 1.9, 0.4); }
    for (x = vents) color(trimc) { box(x - 0.6, W / 2 - 0.6, ridge_h, 1.2, 1.2, 2); box(x - 0.85, W / 2 - 0.85, ridge_h + 2, 1.7, 1.7, 0.35); }
}
module platform() {
    color(conc) box(-6, W, 0, L + 12, plat_w, floor_h - 0.25);
    color(conc) box(-6, -6, 0, L + 12, 6, 0.4);                                   // town-side walk (ESTIMATE)
    for (d = doors) if (d[3] == 0 && d[4] == 0) color(conc) box(d[0] - 2.5, -2.5, 0, 5, 2.5, floor_h - 0.25);
}

if (SHOW == "all" || SHOW == "building") { walls(); openings(); bay(); brackets(); }
if (SHOW == "all" || SHOW == "roof") roof();
if (SHOW == "all" || SHOW == "platform") platform();
