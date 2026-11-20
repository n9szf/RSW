// =====================================================================
//  MILWAUKEE ROAD - WEST MADISON FREIGHT HOUSE, Madison, Wisconsin
//  Frame freight house on concrete piers, drawn Jan-Feb 1903 (C.M.&St.P.
//  Bridge & Building Dept.). Rib Side Works, G scale (1:29).
//  FIRST SHAPE MODEL for review - not cut into printable sections.
//
//  Sources (private reference, RSW / reference / Stations / Wisconsin /
//  Madison Freight House): Milwaukee Public Library drawings 16-906-1 to
//  -10 and a 1919 valuation sheet with a photo.
//
//  KNOWN (figures read from the 1903 drawings): 166 ft long, 40 ft wide;
//    bays of 16 ft and 24 ft; freight doors 8 ft 6 in wide x 8 ft high;
//    composition roof; "out platform" along the track side.
//  MEASURED (scaled off the 1/8 in drawings, +/- 1 ft): floor 4 ft above
//    the ground, eave 15 ft 4 in, ridge 24 ft 10 in, 6 ft roof overhang
//    on brackets, door positions, the 17 ft office at one end (1903).
//  LATER OFFICE (alteration drawings 16-906-7 and the 1919 photo): the
//    office end became a two-storey block with a one-storey gabled office
//    in front of it. Lengths 53 ft and 33 ft are scaled; HOW THESE JOIN
//    THE 1903 HOUSE IS MY READING and wants checking (a note on the
//    drawing mentions a "30 x 50 extension made Feb 1909").
//  ESTIMATE: colours; window sizes; the stairs and porch.
//
//  Layout: x = feet along the track from the far end of the freight
//  room. y = 0 is the team (wagon) side, the track side is +y. z = 0 is
//  the ground; the floor is 4 ft up, at car-floor height.
// =====================================================================

SCALE = 29;
ERA   = 1920;      // 1903 = as first drawn (small office in the end of the house)
                   // 1920 = with the two-storey office block and front office (alteration drawings, 1919 photo)
SHOW  = "all";     // all, house, office, platform
function f(ft) = ft * 304.8 / SCALE;

house_l = 166;  W = 40;                         // 1903 building                                   KNOWN
room_l  = 149;                                  // freight room; the rest was the 1903 office      MEASURED
floor_h = 4;    eave_h = 15.3;  ridge_h = 24.8; // MEASURED
ov      = 6;    ov_end = 3;                     // roof overhang, sides and ends                   MEASURED
door_w  = 8.5;  door_h = 8;                     // KNOWN
team_doors  = [11.8, 28.6, 54.1, 70.3, 95.8, 112, 136.2];   // door centres, team side             MEASURED (plan)
track_doors = [11.8, 54.1, 95.8, 136.2];                    // track side                          MEASURED (plan)
plat_w  = 7;                                    // out platform, track side (valuation: 7 ft wide)
two_l   = 53;   two_eave = 26;  two_ridge = 34.8;   // two-storey office block                     MEASURED
front_l = 33;   front_eave = 15; front_ridge = 23;  // one-storey front office                     MEASURED

body = "#6B3A2E"; trimc = "#E6E0CF"; roofc = "#3E4144"; conc = "#B9B5AA"; glass = "#5B7C93"; wood = "#8A7A62"; doorc = "#54302A";

module box(x0, y0, z0, l, w, h) { translate([f(x0), f(y0), f(z0)]) cube([f(l), f(w), f(h)]); }
module on_wall(x, y, side) { translate([f(x), f(y), 0]) rotate([90, 0, side ? 180 : 0]) children(); }     // 0 = team side (faces -y), 1 = track side
module on_end(x, y, side) { translate([f(x), f(y), 0]) rotate([90, 0, side ? 90 : -90]) children(); }      // 0 faces -x, 1 faces +x
module window(w, h, sill, nx = 2, ny = 2) {
    translate([-f(w) / 2, f(sill), f(0.02)]) {
        color(glass) cube([f(w), f(h), f(0.1)]);
        color(trimc) { for (k = [0 : nx]) translate([k * f(w) / nx - f(0.12), 0, 0]) cube([f(0.24), f(h), f(0.25)]);
            for (k = [0 : ny]) translate([0, k * f(h) / ny - f(0.12), 0]) cube([f(w), f(0.24), f(0.25)]);
            translate([-f(0.35), -f(0.35), 0]) cube([f(w) + f(0.7), f(0.35), f(0.35)]); translate([-f(0.35), f(h), 0]) cube([f(w) + f(0.7), f(0.45), f(0.35)]);
            for (x = [-f(0.35), f(w)]) translate([x, 0, 0]) cube([f(0.35), f(h), f(0.3)]); }
    }
}
module freight_door() {                         // sliding door with a row of small lights over it
    translate([-f(door_w) / 2, f(floor_h), f(0.02)]) {
        color(doorc) cube([f(door_w), f(door_h), f(0.2)]);
        color(trimc) { for (x = [-f(0.4), f(door_w)]) translate([x, 0, 0]) cube([f(0.4), f(door_h + 2.2), f(0.3)]); translate([-f(0.4), f(door_h), 0]) cube([f(door_w) + f(0.8), f(0.35), f(0.3)]); translate([-f(0.4), f(door_h + 1.9), 0]) cube([f(door_w) + f(0.8), f(0.35), f(0.3)]);
            for (k = [1 : 5]) translate([k * f(door_w) / 6 - f(0.08), f(door_h), 0]) cube([f(0.16), f(1.9), f(0.25)]);
            for (a = [0, 1]) hull() { translate([a ? f(door_w) - f(0.3) : 0, 0, f(0.2)]) cube([f(0.3), f(0.3), f(0.08)]); translate([a ? 0 : f(door_w) - f(0.3), f(door_h) - f(0.3), f(0.2)]) cube([f(0.3), f(0.3), f(0.08)]); } }
        color(glass) translate([0, f(door_h + 0.35), 0]) cube([f(door_w), f(1.55), f(0.1)]);
    }
}
module gable_roof(x0, l, eave, ridge, o, oe) {  // ridge along x; wide eaves
    color(roofc) translate([f(x0 - oe), 0, 0]) rotate([90, 0, 90]) linear_extrude(f(l + 2 * oe)) {
        s = (ridge - eave) / (W / 2);
        polygon([[-f(o), f(eave - s * o)], [f(W) / 2, f(ridge)], [f(W + o), f(eave - s * o)], [f(W + o), f(eave - s * o + 0.5)], [f(W) / 2, f(ridge + 0.55)], [-f(o), f(eave - s * o + 0.5)]]);
    }
}
module gable_wall(x, eave, ridge) { color(body) translate([f(x), 0, f(eave)]) rotate([90, 0, 90]) linear_extrude(f(0.6), center = true) polygon([[0, 0], [f(W), 0], [f(W) / 2, f(ridge - eave)]]); }
module braces(x0, x1, eave, o, step = 8) {      // knee braces under the eaves, both sides
    s = (ridge_h - eave_h) / (W / 2);
    color(wood) for (x = [x0 : step : x1], side = [0, 1]) translate([f(x), f(side ? W : 0), f(eave)]) rotate([90, 0, side ? -90 : 90]) translate([0, 0, -f(0.25)])
        linear_extrude(f(0.5)) polygon([[0, -f(4.2)], [0, -f(3.6)], [f(o - 1.2), -f(s * (o - 1)) - f(0.2)], [f(o - 0.6), -f(s * (o - 1)) - f(0.2)]]);
}
module piers(x0, x1) {                          // concrete piers and the skirt boards between them
    color(conc) for (x = [x0 + 1 : 8 : x1 - 1], y = [0.2, W / 3, 2 * W / 3, W - 1.8]) hull() { box(x - 1.1, y - 0.3, 0, 2.2, 2.2, 0.1); box(x - 0.8, y, floor_h - 1.1, 1.6, 1.6, 0.1); }
    color(wood) box(x0, 0, floor_h - 1.1, x1 - x0, W, 1.1);
    color(doorc) for (y = [0.6, W - 0.9]) for (z = [0.6, 1.5, 2.3]) box(x0, y, z, x1 - x0, 0.3, 0.6);
}

module house() {
    l = ERA < 1910 ? house_l : room_l;
    piers(0, l);
    color(body) box(0, 0, floor_h, l, W, eave_h - floor_h);
    color(trimc) { for (x = [0, l - 0.4], y = [-0.08, W - 0.32]) box(x, y, floor_h, 0.4, 0.4, eave_h - floor_h); box(0, -0.1, floor_h, l, W + 0.2, 0.5); }
    for (x = [0, l]) gable_wall(x, eave_h, ridge_h);
    gable_roof(0, l, eave_h, ridge_h, ov, ov_end);
    braces(4, l - 3, eave_h, ov);
    for (x = team_doors) on_wall(x, 0, 0) freight_door();
    for (x = track_doors) on_wall(x, W, 1) freight_door();
    on_end(0, W / 2, 0) window(3, 3, eave_h + 2.5, 2, 2);                                  // louvre / light in the far gable
    if (ERA < 1910) {                           // 1903: the office is the last 17 ft of the house
        for (x = [154, 161]) { on_wall(x, 0, 0) window(3, 6, floor_h + 2.5); on_wall(x, W, 1) window(3, 6, floor_h + 2.5); }
        for (y = [6, 20, 27, 34]) on_end(house_l, y, 1) window(3, 6, floor_h + 2.5);
        on_end(house_l, 13, 1) translate([0, 0, f(0.02)]) { color(doorc) translate([-f(1.6), f(floor_h), 0]) cube([f(3.2), f(7.2), f(0.2)]); }
        stairs(house_l, 13);
        color("#7A4A3A") box(house_l - 9, W / 2 - 1, ridge_h - 3, 2, 2, 6);                 // office chimney
    }
}
module stairs(x, y) { color(wood) { for (k = [0 : 5]) box(x + k * 0.9, y - 2.5, 0, 0.9, 5, floor_h - k * 0.66); box(x, y - 2.5, floor_h, 0.3, 0.3, 3); box(x + 5, y - 2.5, 0.7, 0.3, 0.3, 3); hull() { box(x, y - 2.5, floor_h + 2.8, 0.3, 0.3, 0.2); box(x + 5, y - 2.5, 3.5, 0.3, 0.3, 0.2); } } }

module office() {                               // two-storey block, then the one-storey front office
    x1 = room_l;  x2 = room_l + two_l;  x3 = x2 + front_l;
    piers(x1, x3);
    color(body) { box(x1, 0, floor_h, two_l, W, two_eave - floor_h); box(x2, 0, floor_h, front_l, W, front_eave - floor_h); }
    color(trimc) { for (x = [x1, x2 - 0.4, x3 - 0.4], y = [-0.08, W - 0.32]) box(x, y, floor_h, 0.4, 0.4, (x < x2 ? two_eave : front_eave) - floor_h);
        box(x1, -0.1, floor_h, x3 - x1, W + 0.2, 0.5); box(x1, -0.1, 14.6, two_l, W + 0.2, 0.4); }
    for (x = [x1, x2]) gable_wall(x, two_eave, two_ridge);
    gable_wall(x3, front_eave, front_ridge);
    gable_roof(x1, two_l, two_eave, two_ridge, 4, 3);
    gable_roof(x2, front_l, front_eave, front_ridge, 4, 3);
    // upper floor: six windows a side; below: windows and a door
    for (k = [0 : 5], s = [0, 1]) on_wall(x1 + 5.5 + k * 8.4, s ? W : 0, s) window(3, 5.5, 17.5);
    for (x = [x1 + 6, x1 + 40], s = [0, 1]) on_wall(x, s ? W : 0, s) window(3, 6, floor_h + 2.5);
    on_wall(x1 + 22, 0, 0) translate([0, 0, f(0.02)]) color(doorc) translate([-f(1.8), f(floor_h), 0]) cube([f(3.6), f(7.5), f(0.2)]);
    on_wall(x1 + 31, 0, 0) freight_door();
    for (x = [x2 + 6, x2 + 14.5, x2 + 23], s = [0, 1]) on_wall(x, s ? W : 0, s) window(3, 6, floor_h + 2.5);
    // street end: five openings below with the door and stairs, windows in both gables (1919 photo)
    for (y = [5, 12, 26.5, 34]) on_end(x3, y, 1) window(3, 6, floor_h + 2.5);
    on_end(x3, 19.5, 1) translate([0, 0, f(0.02)]) { color(doorc) translate([-f(1.6), f(floor_h), 0]) cube([f(3.2), f(7.2), f(0.2)]); color(glass) translate([-f(1.1), f(floor_h + 3.6), f(0.2)]) cube([f(2.2), f(3), f(0.05)]); }
    on_end(x3, W / 2, 1) window(2.6, 3.4, front_eave + 2.2, 1, 2);
    for (y = [9, 12.6, 27.4, 31]) on_end(x2, y, 1) window(2.8, 5, 19.5);
    on_end(x2, W / 2, 1) window(2.4, 3, two_eave + 3.2, 1, 2);
    color(wood) { box(x3, 14, floor_h - 0.4, 6, 11, 0.4); for (y = [14, 24.7]) for (x = [x3 + 0.2, x3 + 5.5]) box(x, y, floor_h, 0.3, 0.3, 3.2); for (y = [14, 24.7]) box(x3, y, floor_h + 3, 6, 0.3, 0.25); }
    translate([f(x3 + 6), 0, 0]) stairs(0, 19.5);
    color("#7A4A3A") box(x1 + 30, W / 2 - 1, two_ridge - 3, 2, 2, 6);
}
module platform() {                             // "out platform" along the track side, at floor height
    l = ERA < 1910 ? house_l : room_l;
    color(wood) { box(0, W, floor_h - 0.5, l, plat_w, 0.5); for (x = [1 : 8 : l]) box(x - 0.4, W + plat_w - 0.9, 0, 0.8, 0.8, floor_h - 0.5); }
    color("#6F6A62") box(-8, -14, -0.5, (ERA < 1910 ? house_l : room_l + two_l + front_l) + 22, W + 14 + plat_w + 6, 0.5);
}

if (SHOW == "all") { house(); if (ERA >= 1910) office(); platform(); }
else if (SHOW == "house") house();
else if (SHOW == "office") office();
else if (SHOW == "platform") platform();
