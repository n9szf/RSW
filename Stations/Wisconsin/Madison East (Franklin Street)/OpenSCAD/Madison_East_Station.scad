// =====================================================================
//  MILWAUKEE ROAD - EAST MADISON PASSENGER DEPOT (Franklin Street)
//  Madison, Wisconsin. Closed 1952, when all trains moved to West Madison.
//  Rib Side Works, G scale (1:29).  FIRST SHAPE MODEL for review.
//
//  Sources (private reference, RSW / reference / Stations / Wisconsin /
//  Madison East): Milwaukee Public Library drawings 16-1041-3 to -10 and
//  two valuation photos. The drawings are the 1917 job: a NEW BAGGAGE
//  ROOM BUILDING, the old baggage room turned into more waiting room,
//  and platform shelter sheds. The old depot itself appears only as a
//  floor plan and in outline on one small track-side elevation, so:
//
//  KNOWN (figures read): women's and men's waiting rooms about 22 ft 6 in
//    each with the ticket office between; depot about 62 ft 4 in long;
//    old baggage room 24 ft 11 in; new baggage building 46 ft; ceiling
//    15 ft 6 in; window openings 3 ft x 7 ft 6 in.
//  MEASURED (scaled off the 1/8 in elevation and the plan, +/- 1 ft):
//    all heights, depths, roof outlines, positions of dormers.
//  FROM THE PHOTOS / ESTIMATE: everything about how the old depot's
//    walls, dormers, frieze and awning actually look.
//  Valuation notes: slate roof, metal ridges and hips with finials,
//    common brick walls, stone water table and sills.
//
//  Layout: x = feet along the track from the far end of the new baggage
//  building. y = 0 is the track-side wall of the depot, the street side
//  is +y. z = 0 is the platform.
// =====================================================================

SCALE = 29;
ERA   = 1945;      // 1925 = after the 1917 work: tall Victorian roof with gables, dormers and finials, shelter shed
                   // 1945 = as in the 1940s photo: plain hipped roof, awning on the track side only, no shed,
                   //        FRANKLIN ST sign and the railroad's sign board on the roof. (When the roof was
                   //        rebuilt is not known - between the two photos, about 1925 to 1940.)
SHOW  = "all";     // all, depot, addition, baggage, sheds, platform
SHEDS = ERA < 1940;   // shelter shed at the depot end, toward the street (gone by the 1940s photo)
// Built 1886 (Victorian Gothic), replacing an 1869 station; demolished 1952. 501 East Wilson Street.
function f(ft) = ft * 304.8 / SCALE;

// ---------------- sizes in feet ----------------
bag_l = 46.7;  bag_w = 22;   bag_h = 14;      // 1917 baggage building: stucco, flat roof      KNOWN length, rest MEASURED
drive = 11.8;                                 // covered driveway ("pavilion") between          MEASURED
add_l = 24.9;  add_w = 17.6; add_eave = 14;  add_ridge = 22.5;   // old baggage room, made waiting room in 1917
dep_l = 62.3;  dep_w = 24.5;                  // the old depot                                  KNOWN / MEASURED
wall_h = 17;   deck_h = 27;                   // eave and the flat top of the main roof         MEASURED
hip_h  = 29;                                  // top of the plain 1940s roof                    ESTIMATE from the photo
gable_w = 16;  gable_h = 33.5;                // centre gables, track and street side           MEASURED
awn_h = 9.5;   awn_out = 6;                   // awning roof round the depot                    MEASURED / photo
x_add = bag_l + drive;   x_dep = x_add + add_l;   xc = x_dep + dep_l / 2;
y_add = (dep_w - add_w) / 2;

brick = "#B9AE98"; brick2 = "#A59A84"; stucco = "#8F8C84"; stone = "#D8D2C0"; slate = "#4A4E52"; trim = "#2F4A3A"; glass = "#5B7C93"; sash = "#EDE7D6"; pave = "#77706A"; metal = "#5E6B5E";

module box(x0, y0, z0, l, w, h) { translate([f(x0), f(y0), f(z0)]) cube([f(l), f(w), f(h)]); }
module on_wall(x, y, side) { translate([f(x), f(y), 0]) rotate([90, 0, side ? 180 : 0]) children(); }   // side 0 faces -y (track), 1 faces +y (street)
module on_end(x, y, side) { translate([f(x), f(y), 0]) rotate([90, 0, side ? 90 : -90]) children(); }    // side 0 faces -x, 1 faces +x
module win2d(w, h, arch = false) { if (arch) { translate([-w / 2, 0]) square([w, h - w / 2]); translate([0, h - w / 2]) circle(d = w, $fn = 48); } else translate([-w / 2, 0]) square([w, h]); }
module pane(w, h, sill, arch = false, nx = 2, ny = 2) {      // a window drawn at the origin of a wall, proud by a hair
    translate([0, f(sill), f(0.02)]) {
        color(glass) linear_extrude(f(0.1)) win2d(f(w), f(h), arch);
        color(trim) linear_extrude(f(0.3)) difference() { win2d(f(w), f(h), arch); offset(-f(0.25)) win2d(f(w), f(h), arch); }
        color(sash) for (k = [1 : 1 : nx - 1]) translate([-f(w) / 2 + k * f(w) / nx - f(0.1), 0, 0]) cube([f(0.2), f(h) - (arch ? f(w) * 0.07 : 0), f(0.25)]);
        color(sash) for (k = [1 : 1 : ny - 1]) translate([-f(w) / 2, k * f(arch ? h - w / 2 : h) / ny - f(0.1), 0]) cube([f(w), f(0.2), f(0.25)]);
        color(stone) translate([-f(w) / 2 - f(0.3), -f(0.5), 0]) cube([f(w) + f(0.6), f(0.5), f(0.6)]);
        if (!arch) color(stone) translate([-f(w) / 2 - f(0.4), f(h), 0]) cube([f(w) + f(0.8), f(0.8), f(0.45)]);
    }
}
module finial(x, y, z) { color(metal) translate([f(x), f(y), f(z)]) { cylinder(d = f(0.25), h = f(3.5), $fn = 10); translate([0, 0, f(1.2)]) sphere(d = f(0.8), $fn = 16); } }

// ---------------- the old depot ----------------
module wall_gable(side) {                    // centre gable rising through the eave, with the big arched window
    y = side ? dep_w : 0;
    on_wall(xc, y, side) {
        color(brick) translate([0, 0, -f(1.2)]) linear_extrude(f(2)) polygon([[-f(gable_w) / 2, f(wall_h) - f(0.5)], [f(gable_w) / 2, f(wall_h) - f(0.5)], [f(gable_w) / 2, f(wall_h + 6.5)], [0, f(gable_h)], [-f(gable_w) / 2, f(wall_h + 6.5)]]);
        translate([0, 0, f(0.8)]) pane(9, 7.5, wall_h + 1.5, true, 4, 2);
        color(stone) translate([0, 0, f(0.8)]) linear_extrude(f(0.3)) difference() { translate([0, f(wall_h + 1.5)]) win2d(f(10.4), f(8.4), true); translate([0, f(wall_h + 1.5)]) win2d(f(9), f(7.5), true); translate([-f(6), f(wall_h)]) square([f(12), f(1.5)]); }
        color(stone) translate([0, 0, f(0.8)]) linear_extrude(f(0.2)) polygon([[-f(gable_w) / 2 - f(0.4), f(wall_h + 6.5)], [0, f(gable_h) + f(0.5)], [f(gable_w) / 2 + f(0.4), f(wall_h + 6.5)], [f(gable_w) / 2 + f(0.4), f(wall_h + 5.8)], [0, f(gable_h) - f(0.3)], [-f(gable_w) / 2 - f(0.4), f(wall_h + 5.8)]]);
    }
    // its roof, running back into the main roof
    color(slate) translate([f(xc), f(side ? dep_w + 0.8 : -0.8), 0]) rotate([90, 0, side ? 180 : 0]) translate([0, 0, -f(dep_w / 2)])
        linear_extrude(f(dep_w / 2 - 1.5)) polygon([[-f(gable_w) / 2 + f(0.5), f(wall_h + 6)], [0, f(gable_h) - f(0.6)], [f(gable_w) / 2 - f(0.5), f(wall_h + 6)]]);
    finial(xc, side ? dep_w + 0.2 : -0.2, gable_h);
}
module dormer(x, side) {                     // small hip-roofed dormers either side of the gable
    y = side ? dep_w - 0.4 : 0.4;
    color(brick) box(x - 3.5, side ? y - 5 : y, wall_h - 0.5, 7, 5, 5.5);
    for (d = [-1.4, 1.4]) on_wall(x + d, y, side) pane(2.2, 3.6, wall_h + 0.9, false, 1, 2);
    color(slate) hull() { box(x - 4, side ? y - 5.5 : y - 0.5, wall_h + 5, 8, 6, 0.2); box(x - 0.2, side ? y - 2.7 : y + 2.3, wall_h + 9, 0.4, 0.4, 0.1); }
    finial(x, side ? y - 2.5 : y + 2.5, wall_h + 9);
}
module end_dormer(e) {                        // gabled dormer on each end slope of the roof, small square window (photos)
    x = e ? x_dep + dep_l - 0.2 : x_dep + 0.2;
    color(brick2) translate([f(x), f(dep_w / 2), f(wall_h + 1)]) rotate([90, 0, e ? 90 : -90]) translate([0, 0, -f(1)]) linear_extrude(f(1.6)) polygon([[-f(4), 0], [f(4), 0], [0, f(6)]]);
    on_end(x + (e ? 0.6 : -0.6), dep_w / 2, e) pane(2.4, 2.2, wall_h + 2, false, 2, 2);
    color(slate) translate([f(x + (e ? 0.9 : -0.9)), f(dep_w / 2), f(wall_h + 1)]) rotate([90, 0, e ? 90 : -90]) translate([0, 0, -f(7)]) linear_extrude(f(7.2)) polygon([[-f(4.6), -f(0.3)], [0, f(6.5)], [f(4.6), -f(0.3)], [f(4.6), f(0.2)], [0, f(7)], [-f(4.6), f(0.2)]]);
}
module depot() {
    color(stone) box(x_dep - 0.3, -0.3, 0, dep_l + 0.6, dep_w + 0.6, 2.5);                 // stone water table
    color(brick) box(x_dep, 0, 2.5, dep_l, dep_w, wall_h - 2.5);
    // decorated frieze band above the awning (shown as a raised band with blocks)
    color(brick2) box(x_dep - 0.25, -0.25, 13.2, dep_l + 0.5, dep_w + 0.5, 3.2);
    color(stone) { box(x_dep - 0.4, -0.4, 13, dep_l + 0.8, dep_w + 0.8, 0.4); box(x_dep - 0.8, -0.8, wall_h - 0.6, dep_l + 1.6, dep_w + 1.6, 0.6);
        n = round(dep_l / 2); for (k = [0 : n], s = [0, 1]) box(x_dep + k * dep_l / n - 0.25, s ? dep_w + 0.2 : -0.5, 13.9, 0.5, 0.3, 1.8); }
    if (ERA < 1940) {
        // main roof: steep hip with a flat deck, centre gables, dormers, finials
        color(slate) hull() { box(x_dep - 1.2, -1.2, wall_h, dep_l + 2.4, dep_w + 2.4, 0.3); box(x_dep + 5, 5.5, deck_h - 0.1, dep_l - 10, dep_w - 11, 0.1); }
        color(metal) box(x_dep + 4.8, 5.3, deck_h, dep_l - 9.6, dep_w - 10.6, 0.3);
        for (x = [x_dep + 5, x_dep + dep_l - 5], y = [5.5, dep_w - 5.5]) finial(x, y, deck_h);
        for (s = [0, 1]) { wall_gable(s); for (dx = [-17, 17]) dormer(xc + dx, s); }
        for (e = [0, 1]) end_dormer(e);
        color(brick) { box(xc - 5.5, dep_w / 2 - 1.5, deck_h - 4, 3, 3, 12); box(x_dep + 9, dep_w / 2 - 1.2, deck_h - 3, 2.4, 2.4, 7); }
        color(stone) { box(xc - 5.8, dep_w / 2 - 1.8, deck_h + 8, 3.6, 3.6, 0.6); box(x_dep + 8.7, dep_w / 2 - 1.5, deck_h + 4, 3, 3, 0.5); }
    } else {
        // 1940s: one plain hipped roof with a wide eave on brackets
        color(slate) hull() { box(x_dep - 2.5, -2.5, wall_h, dep_l + 5, dep_w + 5, 0.3); box(x_dep + dep_w / 2, dep_w / 2 - 0.2, hip_h - 0.05, dep_l - dep_w, 0.4, 0.05); }
        color(stone) { n = round(dep_l / 2.5); for (k = [0 : n], s = [0, 1]) box(x_dep + k * dep_l / n - 0.25, s ? dep_w : -2.2, wall_h - 1.3, 0.5, 2.2, 1.3);
            m = round(dep_w / 2.5); for (k = [0 : m]) box(x_dep + dep_l, k * dep_w / m - 0.25, wall_h - 1.3, 2.2, 0.5, 1.3); }
        // the railroad's sign board on the end slope of the roof, and the station name on the end wall
        translate([f(x_dep + dep_l + 0.3), f(dep_w / 2 + 4), f(wall_h + 4.6)]) rotate([90, 0, 90]) rotate([0, 0, -14]) {    // stands upright above the eave
            color("#B3261E") translate([-f(3.6), -f(2.6), 0]) cube([f(7.2), f(5.2), f(0.3)]);
            color("white") translate([0, 0, f(0.3)]) linear_extrude(f(0.08)) { translate([0, f(0.7)]) text("The", size = f(0.8), halign = "center", font = "Liberation Sans:style=Bold Italic"); translate([0, -f(0.6)]) text("MILWAUKEE", size = f(0.9), halign = "center", font = "Liberation Sans:style=Bold"); translate([0, -f(1.9)]) text("ROAD", size = f(0.9), halign = "center", font = "Liberation Sans:style=Bold"); }
        }
        translate([f(x_dep + dep_l + 0.05), f(dep_w / 2), f(11.3)]) rotate([90, 0, 90]) { color("#1B1B1B") translate([-f(4.2), -f(0.65), 0]) cube([f(8.4), f(1.3), f(0.2)]); color("white") translate([0, 0, f(0.2)]) linear_extrude(f(0.06)) text("FRANKLIN ST", size = f(0.75), halign = "center", valign = "center", font = "Liberation Sans:style=Bold"); }
    }
    // ticket office bay, track side
    translate([f(xc), 0, 0]) { color(stone) linear_extrude(f(2.5)) polygon([[-f(6.5), 0], [f(6.5), 0], [f(3.6), -f(3.6)], [-f(3.6), -f(3.6)]]);
        color(brick) translate([0, 0, f(2.5)]) linear_extrude(f(9)) polygon([[-f(6.5), 0], [f(6.5), 0], [f(3.6), -f(3.6)], [-f(3.6), -f(3.6)]]);
        color(glass) translate([0, 0, f(4)]) linear_extrude(f(6)) polygon([[-f(6.1), -f(0.5)], [f(6.1), -f(0.5)], [f(3.5), -f(3.75)], [-f(3.5), -f(3.75)]]); }
    // ground floor openings, from the floor plan: 3 ft x 7 ft 6 in windows in pairs, a door to each waiting room
    for (s = [0, 1], sg = [-1, 1]) {
        for (c = [27, 11.3], d = [-1.9, 1.9]) on_wall(xc + sg * c + d, s ? dep_w : 0, s) pane(3, 7.5, 3.5, false, 1, 2);
        on_wall(xc + sg * 17.8, s ? dep_w : 0, s) pane(4.5, 9.5, 0.2, false, 2, 3);                           // doors, with a transom
    }
    for (d = [-3, 3]) on_wall(xc + d, dep_w, 1) pane(2.5, 4, 6.5, false, 1, 2);                               // toilets: high windows, street side
    for (y = [4.2, dep_w - 4.2]) on_end(x_dep + dep_l, y, 1) pane(3, 7.5, 3.5, false, 1, 2);                  // men's waiting room end: a window each side of the arch
    // men's waiting room end: half-round window in a stone arch, a tall window each side (1940s photo)
    on_end(x_dep + dep_l, dep_w / 2, 1) { translate([0, f(5.5), f(0.02)]) { color(glass) linear_extrude(f(0.1)) intersection() { circle(d = f(8.5), $fn = 60); translate([-f(5), 0]) square(f(10)); }
        color(sash) { translate([-f(0.12), 0, 0]) cube([f(0.24), f(4.2), f(0.3)]); translate([-f(4.25), 0, 0]) cube([f(8.5), f(0.3), f(0.3)]); }
        color(stone) linear_extrude(f(0.35)) intersection() { difference() { circle(d = f(11), $fn = 60); circle(d = f(8.5), $fn = 60); } translate([-f(6), -f(0.01)]) square(f(12)); }
        color(stone) translate([-f(5.5), -f(0.7), 0]) cube([f(11), f(0.7), f(0.5)]); } }                                        // big arched window, men's waiting room end (photo)
    if (ERA < 1940) {
        // awning roof on brackets, all round except where the addition joins
        color(slate) difference() {
            hull() { box(x_dep - awn_out + 4, -awn_out, awn_h, dep_l + awn_out * 2 - 4, dep_w + 2 * awn_out, 0.3); box(x_dep, -0.2, awn_h + 3.4, dep_l + 0.2, dep_w + 0.4, 0.2); }
            box(x_dep + 0.05, 0.05, awn_h - 1, dep_l - 0.1, dep_w - 0.1, 6);
            box(x_dep - awn_out - 1, y_add, awn_h - 1, awn_out + 1, add_w, 6);
        }
        awn_brackets(x_dep + 1, x_dep + dep_l - 1, 8, 0);  awn_brackets(x_dep + 1, x_dep + dep_l - 1, 8, 1);
    } else {
        // 1940s: awning on the track side only, running on past the old baggage room to the baggage building
        color(slate) hull() { box(bag_l, -awn_out, awn_h, x_dep + dep_l - bag_l, 0.3, 0.3); box(bag_l, -0.2, awn_h + 3.4, x_dep + dep_l - bag_l, 0.2, 0.2); }
        color(slate) hull() { box(bag_l, -awn_out, awn_h, x_add + add_l - bag_l, 0.3, 0.3); box(bag_l, y_add, awn_h + 3.4, x_add + add_l - bag_l, 0.2, 0.2); }
        awn_brackets(x_dep + 1, x_dep + dep_l - 1, 8, 0);
    }
}
module awn_brackets(x0, x1, n, s) {
    color(trim) for (x = [x0 : (x1 - x0) / n : x1]) translate([f(x), f(s ? dep_w : 0), f(awn_h)]) rotate([90, 0, s ? -90 : 90]) translate([0, 0, -f(0.2)]) linear_extrude(f(0.4)) polygon([[0, 0], [f(awn_out - 0.5), 0], [f(awn_out - 0.5), -f(0.5)], [f(0.5), -f(5)], [0, -f(5)]]);
}

// ---------------- old baggage room, waiting room since 1917 ----------------
module addition() {
    color(stone) box(x_add, y_add - 0.3, 0, add_l, add_w + 0.6, 2.5);
    color(brick) { box(x_add, y_add, 2.5, add_l, add_w, add_eave - 2.5);
        translate([f(x_add), f(y_add), f(add_eave)]) rotate([90, 0, 90]) linear_extrude(f(0.8)) polygon([[0, 0], [f(add_w), 0], [f(add_w) / 2, f(add_ridge - add_eave)]]); }
    color(slate) translate([f(x_add - 0.8), f(y_add), f(add_eave)]) rotate([90, 0, 90]) linear_extrude(f(add_l + 0.8))
        polygon([[-f(1.5), -f(0.7)], [f(add_w) / 2, f(add_ridge - add_eave) + f(0.5)], [f(add_w) + f(1.5), -f(0.7)], [f(add_w) + f(1.5), -f(1.2)], [-f(1.5), -f(1.2)]]);
    for (x = [x_add + 5, x_add + 12.5, x_add + 20]) { on_wall(x, y_add, 0) pane(3, 7.5, 3.5, false, 1, 2); on_wall(x, y_add + add_w, 1) pane(3, 7.5, 3.5, false, 1, 2); }
    on_end(x_add, dep_w / 2, 0) pane(3, 2, add_eave + 3.5, false, 3, 1);                                      // louvre in the gable
}

// ---------------- 1917 baggage building ----------------
module baggage() {
    y0 = y_add;
    color(stone) box(-0.2, y0 - 0.2, 0, bag_l + 0.4, bag_w + 0.4, 2.2);                                       // concrete base
    color(stucco) box(0, y0, 2.2, bag_l, bag_w, bag_h - 2.2);
    color(metal) { box(-0.7, y0 - 0.7, bag_h - 0.9, bag_l + 1.4, bag_w + 1.4, 0.9); box(-0.3, y0 - 0.3, bag_h - 1.5, bag_l + 0.6, bag_w + 0.6, 0.6); }   // metal cornice
    color(brick2) { box(bag_l - 4.5, y0 + bag_w - 4, 0, 3.5, 3.5, 23); }  color(stone) box(bag_l - 4.8, y0 + bag_w - 4.3, 23, 4.1, 4.1, 0.6);              // chimney
    // track side: high window strip, baggage doors, two windows, office door
    on_wall(7, y0, 0) pane(7, 2.6, 8.2, false, 4, 1);
    on_wall(20, y0, 0) pane(9, 9, 0.3, false, 2, 2);
    for (x = [30, 36]) on_wall(x, y0, 0) pane(3, 6.5, 4, false, 1, 2);
    on_wall(42.5, y0, 0) pane(3, 7.5, 0.3, false, 1, 3);
    // street side: door, small window, double doors, window strip
    on_wall(40, y0 + bag_w, 1) pane(3, 7.5, 0.3, false, 1, 3);
    on_wall(33, y0 + bag_w, 1) pane(3.5, 3, 7, false, 2, 1);
    on_wall(21, y0 + bag_w, 1) pane(9, 9, 0.3, false, 2, 2);
    on_wall(8, y0 + bag_w, 1) pane(7.5, 2.6, 8.2, false, 4, 1);
    for (y = [y0 + 6, y0 + 16]) on_end(0, y, 0) pane(7, 2.6, 8.2, false, 4, 1);
    // roof over the driveway between the two buildings
    color(slate) box(bag_l, y0 - 3, bag_h - 2.2, drive, bag_w + 3, 0.6);
    color(trim) box(bag_l, y0 - 3, bag_h - 3.2, drive, 0.6, 1);
}

// ---------------- platform shelter sheds ----------------
module shed_bay(x, y, l) {                   // umbrella shed: one row of posts, roof sloping up both ways
    color(trim) { box(x + l / 2 - 0.5, y - 0.5, 0, 1, 1, 10.5);
        for (s = [-1, 1]) hull() { box(x + l / 2 - 0.3, y - 0.3, 5.5, 0.6, 0.6, 0.6); box(x + l / 2 - 0.3, y + s * 7 - 0.3, 11, 0.6, 0.6, 0.4); }
        for (s = [-1, 1]) hull() { box(x + l / 2 - 0.3, y - 0.3, 6.5, 0.6, 0.6, 0.6); box(x + l / 2 + s * (l / 2 - 1) - 0.3, y - 0.3, 10.5, 0.6, 0.6, 0.4); }
        box(x, y - 0.4, 10.5, l, 0.8, 0.8); }
    color(slate) translate([f(x), f(y), 0]) rotate([90, 0, 90]) linear_extrude(f(l)) polygon([[-f(9), f(11)], [0, f(13)], [f(9), f(11)], [f(9), f(11.4)], [0, f(13.4)], [-f(9), f(11.4)]]);
}
module sheds() { for (k = [0 : 3]) shed_bay(x_dep + dep_l + 2 + k * 18, -4, 18); }      // four bents seen in the 1920s photo; length ESTIMATE
module platform() { color(pave) box(-6, -awn_out - 14, -0.5, x_dep + dep_l + (SHEDS ? 84 : 12), awn_out + 14 + dep_w + 8, 0.5); }

if (SHOW == "all") { depot(); addition(); baggage(); if (SHEDS) sheds(); platform(); }
else if (SHOW == "depot") depot();
else if (SHOW == "addition") addition();
else if (SHOW == "baggage") baggage();
else if (SHOW == "sheds") sheds();
else if (SHOW == "platform") platform();
