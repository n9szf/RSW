// =====================================================================
//  Interior detail, "as in about 1909" (Oct 2026, Tom's list):
//    lunch room  : better counter (marble top, panelled oak front, brass foot rail), 6 counter stools,
//                  back bar with mirrors, coffee urns and pie case, cash register
//    kitchen     : coal range with hood, short-order griddle ("grill") with hood, oak icebox,
//                  work table, dish cupboard, shelves of crockery, pot rack with copper pots, sink taps
//    toilets     : two water closets each (high oak tanks, pull chains) in marble stalls,
//                  two lavatories each with mirrors, two urinals in the men's room
//    doors       : oak five-panel doors in every inside doorway (annex pair and kitchen door open)
//    ticket office: roll-top desk, operator's counter round the bay window with telegraph sounder,
//                  key and green lamp, L-shaped ticket counter under both ticket windows, swivel chairs
//    waiting room: 3 ft gallery clocks over the passages (waiting and smoking rooms);
//                  the train board and ticket-window clocks are in interior.scad
//    pictures    : framed photographs of Janesville trains and the depot (photo = image, added in Blender)
//    kitchen     : (Oct 17) coal hod with coal and shovel beside the range
//    pictures    : (Oct 17) two more train pictures - the 4-6-0 and the wooden coaches, cropped from the depot postcard
//    render only : plaster ceilings over the 18 ft rooms and period pendant lamps (not printed parts);
//                  (Oct 17) wainscot, plaster, window casings and ceiling inside the ticket bay (was bare brick)
//
//  Every object is drawn one MATERIAL at a time: obj(m) draws only the parts made of material m.
//  details(m) = everything of material m, in place.  details_place() = all materials, coloured.
//  Printing: D_<object>_<material> parts (see detail_parts()).  These are modelled as they stand,
//  NOT turned for printing - check the orientation in the slicer.
//
//  Positions are real feet from the west end wall line (x) and the track-side wall line (y).
// =====================================================================
include <../janesville_common.scad>
use <interior.scad>
use <../Walls/interior_walls.scad>
use <../Walls/walls.scad>

PART = "D_stool_leather";       // when opened directly
VIEW = "placed";                // "placed" | "part" | "art"
FL = 1.0;                       // floor overlay thickness (interior.scad FL_T)
ZF = FLOOR_Z + FL;              // top of the finished floor
LINER = 1.2;                    // wall liner + trim thickness (mm) - things stand off the walls by this

MATS = [["oak", "#9A6B3A"], ["oak_dark", "#5A3A22"], ["marble", "#E9E6DF"], ["nickel", "#C8CCD0"], ["brass", "#B8923A"],
        ["iron", "#262626"], ["porcelain", "#F4F4F0"], ["leather", "#5A1E14"], ["mirror", "#AFC3CF"], ["glass", "#D8E8EE"],
        ["crockery", "#F7F5EE"], ["copper", "#B87333"], ["steel", "#8C9196"], ["bread", "#C68E4E"], ["frame", "#3B2414"],
        ["gilt", "#B08D57"], ["mat", "#EFE6D2"], ["paper", "#F3EEDC"], ["shade", "#2F6B3A"], ["bulb", "#FFE3A0"],
        ["black", "#151515"], ["cream", "#F1E9D2"], ["plaster", "#F3EBD3"]];
function mcol(m) = MATS[search([m], MATS)[0]][1];

// ------------------------------------------------------------------ helpers (all sizes in feet)
module at(x, y, a = 0, z = 0) translate([ft(x), ft(y), ZF + ft(z)]) rotate([0, 0, a]) children();
module bx(x0, y0, z0, x1, y1, z1) translate([ft(min(x0, x1)), ft(min(y0, y1)), ft(min(z0, z1))]) cube([ft(abs(x1 - x0)), ft(abs(y1 - y0)), ft(abs(z1 - z0))]);
module cz(x, y, z0, z1, d, n = 24) translate([ft(x), ft(y), ft(z0)]) cylinder(d = ft(d), h = ft(z1 - z0), $fn = n);
module cz2(x, y, z0, z1, d0, d1, n = 24) translate([ft(x), ft(y), ft(z0)]) cylinder(d1 = ft(d0), d2 = ft(d1), h = ft(z1 - z0), $fn = n);
module rx(x0, x1, y, z, d, n = 16) translate([ft(x0), ft(y), ft(z)]) rotate([0, 90, 0]) cylinder(d = ft(d), h = ft(x1 - x0), $fn = n);
module ry(x, y0, y1, z, d, n = 16) translate([ft(x), ft(y0), ft(z)]) rotate([-90, 0, 0]) cylinder(d = ft(d), h = ft(y1 - y0), $fn = n);
module sph(x, y, z, d, sz = 1, n = 24) translate([ft(x), ft(y), ft(z)]) scale([1, 1, sz]) sphere(d = ft(d), $fn = n);
module ring(x, y, z, r, t, n = 32) translate([ft(x), ft(y), ft(z)]) rotate_extrude($fn = n) translate([ft(r), 0]) circle(d = ft(t), $fn = 8);
// a raised panel field on a face that looks toward +y (front at y)
module field(x0, x1, z0, z1, y, p = 0.05, step = 0.12) { bx(x0, y, z0, x1, y + p, z1); bx(x0 + step, y, z0 + step, x1 - step, y + 2 * p, z1 - step); }
// cup + saucer, plate stack, standing plate
module cup(x, y, z) { cz(x, y, z, z + 0.03, 0.42); cz2(x, y, z + 0.03, z + 0.28, 0.24, 0.3); }
module plates(x, y, z, n = 8) cz(x, y, z, z + 0.035 * n, 0.8, 32);
module plate_up(x, y, z, a = 75) translate([ft(x), ft(y), ft(z + 0.37)]) rotate([a, 0, 0]) cylinder(d = ft(0.75), h = ft(0.04), $fn = 32);

// ------------------------------------------------------------------ lunch room
module stool(m) {                                   // origin: floor, centre
    if (m == "iron")    cz2(0, 0, 0, 0.22, 1.15, 0.55, 32);
    if (m == "nickel") { cz(0, 0, 0.2, 2.42, 0.16, 16); ring(0, 0, 0.95, 0.42, 0.05);
        for (a = [0, 120, 240]) rotate(a) bx(0, -0.02, 0.93, 0.42, 0.02, 0.97);
        cz(0, 0, 2.38, 2.46, 1.22, 40); }
    if (m == "leather") { cz(0, 0, 2.46, 2.54, 1.18, 40);
        intersection() { sph(0, 0, 2.54, 1.18, 0.22, 40); bx(-1, -1, 2.54, 1, 1, 3); } }
}
module ncr(m) {                                     // cash register, keys toward local -y
    if (m == "brass") { bx(0, 0, 0, 1.2, 1.1, 0.45); hull() { bx(0, 0.05, 0.45, 1.2, 1.1, 0.5); bx(0, 0.62, 1.0, 1.2, 1.1, 1.05); }
        bx(0.1, 0.65, 1.0, 1.1, 1.05, 1.45); bx(0.2, 0.75, 1.45, 1.0, 0.95, 1.8); bx(-0.05, -0.04, 0.05, 1.25, 0.0, 0.4);
        rx(1.2, 1.38, 0.55, 0.7, 0.1); rx(1.36, 1.4, 0.55, 0.7, 0.35); }
    if (m == "black") for (i = [0 : 5]) for (j = [0 : 2]) let(t = 0.2 + 0.3 * j) translate([ft(0.15 + i * 0.18), ft(0.05 + 0.57 * t), ft(0.47 + 0.55 * t)])
        rotate([-46, 0, 0]) cylinder(d = ft(0.11), h = ft(0.06), $fn = 10);
    if (m == "cream") bx(0.3, 0.73, 1.52, 0.9, 0.75, 1.72);
}
// counter: x 0..L, y = 0 the panelled customer face, server side to y = 2.  Marble top 3'-5".
module counter09(m, L = 11) {
    n = round(L / 2.75); p = L / n;
    if (m == "oak") {
        difference() { bx(0, 0, 0.35, L, 2, 3.3); bx(0.3, 1.0, 0.5, L - 0.3, 2.1, 3.12); }
        for (z = [1.45, 2.3]) bx(0.3, 1.0, z, L - 0.3, 2, z + 0.06);                       // server-side shelves
        for (i = [0 : n]) bx(i * p - 0.14, -0.1, 0.35, i * p + 0.14, 0, 3.3);             // pilasters
        for (i = [0 : n - 1]) field(i * p + 0.32, (i + 1) * p - 0.32, 0.75, 2.95, 0, -0.04, 0.12);   // raised panels
        bx(-0.06, -0.14, 3.05, L + 0.06, 0, 3.3); bx(-0.06, -0.14, 0.35, L + 0.06, 0, 0.5);   // top rail, base moulding
        bx(-0.08, 0, 0.35, 0, 2, 3.3); bx(L, 0, 0.35, L + 0.08, 2, 3.3);                   // end panels
    }
    if (m == "oak_dark") bx(0.1, 0.3, 0, L - 0.1, 1.9, 0.35);                              // recessed plinth
    if (m == "marble") hull() { bx(-0.12, -0.38, 3.3, L + 0.12, 2.06, 3.42); rx(-0.12, L + 0.12, -0.4, 3.36, 0.12, 16); }
    if (m == "brass") { rx(-0.2, L + 0.2, -0.42, 0.62, 0.13);
        for (x = [0.1 : 2.6 : L]) bx(x - 0.03, -0.42, 0.56, x + 0.03, -0.05, 0.62);
        for (x = [-0.2, L + 0.2]) cz(x, -0.42, 0, 0.62, 0.1, 12); }
    translate([ft(L - 1.45), ft(1.6), ft(3.42)]) rotate([0, 0, 180]) translate([-ft(1.2), 0, 0]) ncr(m);   // keys face the server
    if (m == "crockery") { for (x = [1.0, 3.0, 5.1, 7.0]) cup(x, 0.35, 3.42); cz(2.1, 0.8, 3.42, 3.6, 0.3); cz(6.2, 0.8, 3.42, 3.6, 0.3);
        cz(4.1, 1.0, 3.42, 3.47, 1.0, 32); }                                               // cake plate
    if (m == "glass") intersection() { sph(4.1, 1.0, 3.47, 0.95, 1.1, 32); bx(3, 0, 3.47, 5.2, 2, 4.2); }
    if (m == "bread") cz(4.1, 1.0, 3.47, 3.75, 0.7, 32);
}
module urn(m) {                                     // coffee urn, origin floor of the counter, spigot toward +y
    if (m == "nickel") { for (a = [0, 120, 240]) rotate(a) cz2(0.38, 0, 0, 0.3, 0.12, 0.08, 10);
        cz(0, 0, 0.3, 1.75, 1.0, 32); intersection() { sph(0, 0, 1.75, 1.0, 0.6, 32); bx(-1, -1, 1.75, 1, 1, 2.2); }
        cz(0, 0, 2.03, 2.15, 0.12, 12); ry(0, 0.45, 0.72, 0.55, 0.12); cz(0, 0.68, 0.45, 0.62, 0.1, 10);
        ring(0, 0, 0.3, 0.5, 0.06); ring(0, 0, 1.75, 0.5, 0.06); }
    if (m == "black") { for (s = [-1, 1]) translate([ft(s * 0.52), 0, ft(1.25)]) rotate([0, s * 90, 0]) cylinder(d = ft(0.08), h = ft(0.2), $fn = 10); }
}
module pie_case(m) {                                // 2.2 x 1.2 x 1.3, origin back-left-bottom, front +y
    if (m == "oak") { bx(0, 0, 0, 2.2, 1.2, 0.1); bx(0, 0, 1.25, 2.2, 1.2, 1.35);
        for (x = [0, 2.12]) for (y = [0, 1.12]) bx(x, y, 0.1, x + 0.08, y + 0.08, 1.25); }
    if (m == "glass") { bx(0.08, 0.08, 0.1, 2.12, 1.12, 1.25); }
    if (m == "crockery") for (z = [0.12, 0.68]) for (x = [0.55, 1.65]) cz(x, 0.6, z, z + 0.03, 0.85, 32);
    if (m == "bread") for (z = [0.15, 0.71]) for (x = [0.55, 1.65]) { cz(x, 0.6, z, z + 0.1, 0.75, 32); intersection() { sph(x, 0.6, z + 0.1, 0.75, 0.18, 32); bx(x - 1, 0, z + 0.1, x + 1, 2, z + 1); } }
}
// back bar: x 0..L, y = 0 back, front (y = 1.6) toward the counter
module backbar09(m, L = 8) {
    n = round(L / 2); p = L / n; q = L / 3;
    if (m == "oak") {
        bx(0, 0.1, 0.3, L, 1.6, 3.0);
        for (i = [0 : n - 1]) field(i * p + 0.2, (i + 1) * p - 0.2, 0.55, 2.75, 1.6, 0.04, 0.1);
        for (i = [0 : n]) bx(i * p - 0.1, 1.6, 0.3, i * p + 0.1, 1.68, 3.0);
        bx(0, 0, 3.1, L, 0.15, 7.1);                                                         // back board
        for (i = [0 : 3]) { bx(i * q - 0.18, 0.15, 3.1, i * q + 0.18, 0.42, 7.0); bx(i * q - 0.24, 0.15, 6.75, i * q + 0.24, 0.5, 7.0); }
        for (z = [4.55, 5.75]) bx(0.18, 0.15, z, L - 0.18, 0.8, z + 0.06);                   // shelves
        bx(-0.15, 0, 7.0, L + 0.15, 0.62, 7.22); bx(-0.25, 0, 7.22, L + 0.25, 0.78, 7.42);  // cornice
        intersection() { translate([ft(L / 2), ft(0.05), ft(6.9)]) rotate([-90, 0, 0]) cylinder(r = ft(1.5), h = ft(0.2), $fn = 48); bx(0, 0, 7.42, L, 1, 9); }
    }
    if (m == "oak_dark") bx(0.05, 0.2, 0, L - 0.05, 1.5, 0.3);
    if (m == "brass") for (i = [0 : n - 1]) cz(i * p + p / 2, 1.72, 1.6, 1.66, 0.12, 12);
    if (m == "marble") bx(-0.05, 0, 3.0, L + 0.05, 1.75, 3.1);
    if (m == "mirror") for (i = [0 : 2]) bx(i * q + 0.2, 0.15, 3.2, (i + 1) * q - 0.2, 0.17, 6.7);
    if (m == "crockery") { for (z = [4.61, 5.81]) for (x = [0.5 : 0.42 : L - 0.4]) cz2(x, 0.48, z, z + 0.25, 0.24, 0.3);
        plates(L / 2 - 1.6, 1.1, 3.1, 10); plates(L / 2 + 1.6, 1.1, 3.1, 7); }
    translate([ft(1.0), ft(0.85), ft(3.1)]) urn(m);
    translate([ft(L - 1.0), ft(0.85), ft(3.1)]) urn(m);
    translate([ft(L / 2 - 1.1), ft(0.3), ft(3.1)]) pie_case(m);
}

// ------------------------------------------------------------------ kitchen
module range09(m) {                                 // x 0..5 along the wall, y 0 = wall, front y = 2.75
    if (m == "iron") {
        for (x = [0.15, 4.85]) for (y = [0.4, 2.45]) cz2(x, y, 0, 0.6, 0.18, 0.28, 12);
        bx(0, 0.1, 0.6, 5, 2.6, 2.6); bx(-0.05, 0, 2.6, 5.05, 2.75, 2.73);
        bx(0, 0, 2.73, 5, 0.18, 4.4); bx(0.3, 0, 4.4, 4.7, 1.1, 5.25);
        cz(4.1, 0.5, 5.25, 9.3, 0.6, 24);                                                    // stove pipe
    }
    if (m == "black") for (x = [0.8, 2.0, 3.2]) for (y = [0.8, 1.9]) cz(x, y, 2.73, 2.76, 0.75, 24);
    if (m == "nickel") {
        for (d = [[0.35, 2.3], [2.7, 4.65]]) difference() { bx(d[0], 2.6, 0.85, d[1], 2.66, 2.3); bx(d[0] + 0.12, 2.5, 0.97, d[1] - 0.12, 2.7, 2.18); }
        for (d = [[0.35, 2.3], [2.7, 4.65]]) rx(d[0] + 0.3, d[1] - 0.3, 2.74, 2.05, 0.06);
        rx(-0.1, 5.1, 2.92, 2.42, 0.07); for (x = [-0.1, 5.05]) bx(x, 2.6, 2.4, x + 0.05, 2.95, 2.46);
        bx(-0.05, 2.73, 2.58, 5.05, 2.79, 2.75); bx(0.3, 1.1, 4.4, 4.7, 1.15, 4.5); bx(0.3, 1.1, 5.15, 4.7, 1.15, 5.25);
    }
    if (m == "copper") { cz(0.8, 1.9, 2.76, 3.05, 1.0, 32); rx(1.28, 2.0, 1.9, 2.98, 0.08); cz(0.8, 0.8, 2.76, 3.35, 0.7, 24); }
    if (m == "steel") { cz(3.2, 1.0, 2.76, 3.85, 1.15, 32); cz(2.0, 1.9, 2.76, 3.4, 0.5, 20); }
    if (m == "steel") hull() { bx(-0.4, 0, 7.4, 5.4, 3.5, 7.45); bx(0.7, 0, 8.6, 4.3, 1.4, 8.65); }  // hood
}
module griddle09(m) {                               // short-order griddle ("grill"), x 0..4, y 0 = wall
    if (m == "iron") { for (x = [0, 3.85]) for (y = [0.15, 2.3]) bx(x, y, 0, x + 0.15, y + 0.15, 2.0);
        bx(0.1, 0.2, 0.6, 3.9, 2.35, 0.66); bx(0, 0.05, 2.0, 4, 2.5, 2.6);
        for (x = [0, 3.92]) bx(x, 0, 2.75, x + 0.08, 2.5, 3.3); bx(0, 0, 2.75, 4, 0.12, 4.0); }
    if (m == "steel") { bx(0.08, 0.12, 2.6, 3.92, 2.45, 2.75); bx(0.1, 2.45, 2.48, 3.9, 2.7, 2.6);
        hull() { bx(-0.25, 0, 6.6, 4.25, 3.0, 6.65); bx(0.9, 0, 7.8, 3.1, 1.2, 7.85); } bx(1.5, 0.2, 7.85, 2.5, 1.0, 9.3); }
    if (m == "brass") for (x = [0.7, 1.6, 2.5, 3.4]) ry(x, 2.5, 2.62, 2.3, 0.15);
    if (m == "bread") { for (x = [0.7, 1.5]) cz(x, 1.4, 2.75, 2.8, 0.6); for (x = [2.6, 3.2]) intersection() { sph(x, 1.0, 2.75, 0.55, 0.35); bx(x - 1, 0, 2.75, x + 1, 3, 3.2); } }
    if (m == "crockery") for (x = [2.7, 3.3]) cz(x, 1.9, 2.75, 2.8, 0.38);
    if (m == "black") bx(1.0, 1.9, 2.75, 1.2, 2.6, 2.79);                                // spatula
}
module icebox09(m) {                                // 3 x 2 x 4.6, y 0 = wall, doors toward +y
    if (m == "oak") { bx(0, 0, 0.4, 3, 2, 4.5); bx(-0.08, 0, 4.5, 3.08, 2.08, 4.65);
        for (d = [[0.2, 1.4, 2.8, 4.3], [1.6, 2.8, 2.8, 4.3], [0.2, 2.8, 0.6, 2.6]]) { bx(d[0], 2.0, d[2], d[1], 2.05, d[3]); field(d[0] + 0.15, d[1] - 0.15, d[2] + 0.15, d[3] - 0.15, 2.05, 0.03, 0.08); } }
    if (m == "oak_dark") bx(0.05, 0.05, 0, 2.95, 1.95, 0.4);
    if (m == "nickel") for (d = [[0.2, 1.4, 2.8, 4.3], [1.6, 2.8, 2.8, 4.3], [0.2, 2.8, 0.6, 2.6]]) {
        for (z = [d[2] + 0.2, d[3] - 0.45]) bx(d[0] - 0.05, 2.05, z, d[0] + 0.05, 2.12, z + 0.25);
        bx(d[1] - 0.3, 2.05, (d[2] + d[3]) / 2 - 0.07, d[1] - 0.08, 2.16, (d[2] + d[3]) / 2 + 0.07); }
}
module worktable09(m) {                             // 4.5 x 2.5, top 2'-10"
    if (m == "oak") { for (x = [0.15, 4.35]) for (y = [0.15, 2.35]) cz(x, y, 0, 2.7, 0.24, 12);
        bx(0.05, 0.05, 2.35, 4.45, 2.45, 2.7); bx(0.1, 0.1, 0.45, 4.4, 2.4, 0.5); }
    if (m == "steel") bx(-0.05, -0.05, 2.7, 4.55, 2.55, 2.8);
    if (m == "oak_dark") { bx(2.6, 0.5, 2.8, 4.2, 1.6, 2.86); rx(0.4, 1.9, 2.1, 2.9, 0.15); }
    if (m == "crockery") { for (p = [[0.9, 0.9, 1.0], [1.8, 1.3, 0.75]]) difference() { intersection() { sph(p[0], p[1], 2.8 + p[2] / 2, p[2]); bx(p[0] - 1, p[1] - 1, 2.8, p[0] + 1, p[1] + 1, 2.8 + p[2] / 2); }
        sph(p[0], p[1], 2.8 + p[2] / 2, p[2] - 0.1); } plates(0.6, 2.0, 2.8, 6); }
    if (m == "bread") for (x = [3.0, 3.75]) sph(x, 1.05, 2.92, 0.7, 0.45);
}
module hutch09(m) {                                 // dish cupboard 2.5 x 1.5 x 7
    if (m == "oak") { bx(0, 0, 0.25, 2.5, 1.5, 3.0); for (x = [0.1, 1.3]) field(x, x + 1.1, 0.5, 2.8, 1.5, 0.03, 0.1);
        bx(-0.05, 0, 3.0, 2.55, 1.6, 3.1); bx(0, 0, 3.1, 0.1, 1.0, 6.8); bx(2.4, 0, 3.1, 2.5, 1.0, 6.8); bx(0, 0, 3.1, 2.5, 0.1, 6.8);
        for (z = [4.1, 5.1, 6.0]) bx(0.1, 0.1, z, 2.4, 1.0, z + 0.06); bx(-0.08, 0, 6.8, 2.58, 1.1, 7.0); }
    if (m == "oak_dark") bx(0.05, 0.05, 0, 2.45, 1.45, 0.25);
    if (m == "brass") for (x = [1.05, 1.45]) cz(x, 1.55, 1.7, 1.75, 0.1, 10);
    if (m == "crockery") { for (z = [4.16, 5.16]) for (x = [0.45 : 0.42 : 2.1]) plate_up(x, 0.3, z);
        for (x = [0.4 : 0.45 : 2.2]) cup(x, 0.55, 6.06); plates(0.7, 0.8, 3.1, 9); plates(1.8, 0.8, 3.1, 6); }
}
module coalhod09(m) {                               // coal hod (scuttle) with a short shovel, about 1'-3" high
    if (m == "black") { difference() { cz2(0, 0, 0, 1.2, 0.95, 1.1, 24); cz2(0, 0, 0.1, 1.3, 0.85, 1.0, 24); }
        translate([ft(0.45), 0, ft(1.05)]) rotate([0, -30, 0]) translate([0, -ft(0.3), 0]) cube([ft(0.5), ft(0.6), ft(0.05)]); }   // spout lip
    if (m == "iron") { ring(0, 0, 1.25, 0.42, 0.06, 24); for (s = [-1, 1]) cz(0, s * 0.45, 1.15, 1.3, 0.06, 8);
        intersection() { cz(0, 0, 0.1, 1.15, 0.84, 24); for (i = [0 : 6]) sph(-0.25 + (i % 3) * 0.22, -0.2 + floor(i / 3) * 0.2, 1.08, 0.24, 0.8, 8); } }   // coal
    if (m == "steel") translate([ft(-0.15), ft(0.25), ft(0.6)]) rotate([-12, 18, 0]) { cube([ft(0.3), ft(0.05), ft(0.9)]); translate([-ft(0.05), 0, -ft(0.35)]) cube([ft(0.4), ft(0.3), ft(0.35)]); }
}
module potrack(m) {                                 // 4 x 1.5 rack at 7 ft, centred on the origin
    if (m == "iron") { for (y = [-0.75, 0.75]) rx(-2, 2, y, 7.0, 0.06); for (x = [-2, 2]) ry(x, -0.75, 0.75, 7.0, 0.06);
        for (x = [-1.9, 1.9]) for (y = [-0.7, 0.7]) cz(x, y, 7.0, 9.4, 0.03, 6);
        for (x = [-1.5 : 0.75 : 1.5]) cz(x, 0.75, 6.45, 7.0, 0.03, 6); }
    if (m == "copper") for (i = [0 : 4]) let(x = -1.5 + 0.75 * i, d = [0.7, 0.9, 0.55, 0.8, 0.65][i]) translate([0, 0, 0]) {
        cz(x, 0.75, 6.0 - d * 0.3, 6.3, d, 24); rx(x - 0.03, x + 0.03, 0.75, 6.42, 0.05); bx(x - 0.02, 0.73, 6.3, x + 0.02, 0.77, 6.45); }
}
module plate_x(x, y, z) translate([ft(x), ft(y), ZF + ft(z + 0.37)]) rotate([0, 75, 0]) cylinder(d = ft(0.75), h = ft(0.04), $fn = 32);
module kitchen_place(m) {
    KN = LUNCH_Y1 / ft(1) - (T_LIGHT + LINER) / ft(1);      // kitchen north wall face
    KE = X_MAIN_E / ft(1) - (T_LIGHT + LINER) / ft(1);      // east wall face
    at(KE, 19.0, 90) range09(m);                            // range on the east wall, front facing west, hood over it
    at(124.85, KN, 180) griddle09(m);                       // short-order griddle on the north wall
    at(KE - 0.05, KN, 180) icebox09(m);                     // icebox in the north-east corner
    at(120.75, KN, 180) hutch09(m);                         // dish cupboard
    at(119.0, 19.6) worktable09(m);
    at(121.25, 20.85) potrack(m);
    at(127.35, 18.75) coalhod09(m);                          // coal hod and shovel beside the range
    // the partition at x = 116 (kitchen side): sink with splash board and taps, two shelves of crockery over it
    at(0, 0) {
        if (m == "oak") for (z = [5.0, 6.2]) { bx(116.18, 21.1, z, 116.95, 25.9, z + 0.06); for (y = [21.3, 25.6]) bx(116.18, y, z - 0.45, 116.24, y + 0.06, z); }
        if (m == "crockery") for (y = [21.5 : 0.45 : 25.7]) cup(116.6, y, 6.26);
        if (m == "nickel") for (y = [24.4, 25.2]) { cz(116.3, y, 3.0, 3.55, 0.08, 10); rx(116.3, 116.75, y, 3.5, 0.07); }
        if (m == "porcelain") bx(116.16, 21.0, 3.0, 116.24, 26.0, 4.0);
    }
    if (m == "crockery") for (y = [21.5 : 0.42 : 25.6]) plate_x(116.45, y, 5.06);
    if (m == "porcelain") translate([ft(116) + 2.4, ft(26), ZF + ft(3)]) rotate([0, 0, -90]) mirror([0, 0, 1]) kitchen_sink();
}
module lunch_place(m) {
    at(116.6, 11.6) counter09(m, 11);                       // panelled face toward the lunch room (south), server behind
    for (i = [0 : 5]) at(117.6 + i * 1.85, 10.55) stool(m);
    at(126.5, 18.2, 180) backbar09(m, 8);                   // 3 ft behind the counter, facing it
}

// ------------------------------------------------------------------ toilets
module toilet09(m) {                                // origin: wall, centre; bowl toward +y
    if (m == "porcelain") difference() {
        hull() { translate([0, ft(0.85), 0]) scale([1, 1.35, 1]) cylinder(d = ft(0.75), h = ft(0.1), $fn = 32);
                 translate([0, ft(1.05), ft(1.18)]) scale([1, 1.3, 1]) cylinder(d = ft(1.15), h = ft(0.12), $fn = 40);
                 bx(-0.3, 0.3, 0.6, 0.3, 0.45, 1.3); }
        translate([0, ft(1.08), ft(1.0)]) scale([1, 1.3, 1]) cylinder(d = ft(0.8), h = ft(0.5), $fn = 40);
    }
    if (m == "oak") { difference() { translate([0, ft(1.05), ft(1.3)]) scale([1, 1.3, 1]) cylinder(d = ft(1.2), h = ft(0.06), $fn = 40);
                                     translate([0, ft(1.08), ft(1.2)]) scale([1, 1.3, 1]) cylinder(d = ft(0.72), h = ft(0.3), $fn = 40); }
        translate([0, ft(0.36), ft(1.36)]) rotate([-8, 0, 0]) translate([-ft(0.55), 0, 0]) cube([ft(1.1), ft(0.06), ft(1.45)]);
        bx(-0.8, 0.02, 6.3, 0.8, 0.82, 7.35); bx(-0.86, 0, 7.35, 0.86, 0.9, 7.45); bx(-0.86, 0, 6.2, 0.86, 0.9, 6.3); }
    if (m == "nickel") { cz(0, 0.2, 1.2, 6.2, 0.14, 12); ry(0, 0.1, 0.45, 1.22, 0.14);
        cz(0.62, 0.78, 4.2, 6.2, 0.025, 6); cz(0.62, 0.78, 4.0, 4.2, 0.12, 10); }
}
module urinal09(m) {                                // stall urinal, origin: wall, centre
    if (m == "porcelain") difference() {
        intersection() { cz(0, 0, 0, 4.0, 1.9, 48); bx(-1, 0, 0, 1, 1, 4); }
        cz(0, -0.05, 0.25, 4.1, 1.6, 48); bx(-1, 0.75, 0.25, 1, 1, 4.1); }
    if (m == "nickel") { cz(0, 0.3, 4.0, 6.0, 0.1, 10); bx(-0.15, 0.2, 5.6, 0.15, 0.45, 5.95); ry(0, 0, 0.3, 4.1, 0.1); }
    if (m == "porcelain") bx(-0.95, 0, 0, 0.95, 0.95, 0.12);
}
module lav09(m) {                                   // pedestal lavatory, origin: wall, centre; mirror above
    if (m == "porcelain") { difference() { hull() { bx(-1, 0, 2.4, 1, 0.6, 2.75); translate([0, ft(0.85), ft(2.4)]) scale([1, 0.75, 1]) cylinder(r = ft(1), h = ft(0.35), $fn = 48); }
            translate([0, ft(0.85), ft(2.78)]) scale([1, 0.75, 0.4]) sphere(r = ft(0.68), $fn = 40); }
        bx(-1, 0, 2.75, 1, 0.12, 3.35);
        hull() { cz(0, 0.8, 0, 0.12, 0.6, 24); cz(0, 0.8, 2.3, 2.4, 0.32, 24); } }
    if (m == "nickel") for (s = [-1, 1]) { cz(s * 0.42, 0.28, 2.75, 3.08, 0.08, 10); ry(s * 0.42, 0.28, 0.6, 3.04, 0.07); rx(s * 0.42 - 0.12, s * 0.42 + 0.12, 0.28, 3.1, 0.04); }
    if (m == "nickel") { cz(0, 0.55, 1.75, 2.42, 0.1, 10); ry(0, 0, 0.55, 1.78, 0.1); }
    if (m == "oak") difference() { bx(-0.85, 0, 4.0, 0.85, 0.1, 6.2); bx(-0.7, -1, 4.15, 0.7, 1, 6.05); }
    if (m == "mirror") bx(-0.72, 0, 4.13, 0.72, 0.06, 6.07);
}
// marble stall: side partitions at the given ys (ft), from the wall (x = xw) out to x = xf; floor 0.6, top 6.6
module stall_side(m, x0, x1, y) { if (m == "marble") bx(x0, y - 0.05, 0.6, x1, y + 0.05, 6.6);
    if (m == "nickel") { for (x = [min(x0, x1) + 0.3, max(x0, x1) - 0.25]) cz(x, y, 0, 0.6, 0.12, 10); } }
module stall_door(m, w = 2.3, h = 5.0) {            // hinge at origin, leaf along +x
    if (m == "oak") { difference() { bx(0, -0.06, 0, w, 0.06, h); for (z = [[0.4, 2.3], [2.7, 4.6]]) for (s = [-1, 1]) bx(0.3, s * 0.06 - 0.03, z[0], w - 0.3, s * 0.06 + 0.03, z[1]); } }
    if (m == "nickel") { for (z = [0.5, h - 0.6]) cz(0, 0, z, z + 0.3, 0.06, 8); ry(w - 0.25, -0.15, 0.15, h / 2, 0.06); }
}
module restrooms_place(m) {
    // women's room: x 40.25 .. 49.5, y 21.25 .. 32.  Lavatories on the west wall, closets in stalls on the east wall.
    xw = 40.25 + (2.0 + LINER) / ft(1);  xe = 49.5 - (1.5 + LINER) / ft(1);  yn = 32 - (T_MAIN + LINER) / ft(1);
    for (y = [24.0, 27.3]) at(xw, y, -90) lav09(m);
    for (y = [26.7, 29.85]) at(xe, y, 90) toilet09(m);
    for (y = [25.1, 28.25]) at(0, 0) stall_side(m, xe, xe - 4.6, y);
    for (y = [25.1, 28.25]) at(xe - 4.6, y, 140) stall_door(m, 2.6, 5.0);
    // men's room: x 87.35 .. 98.08, y 16 .. 32.  Lavatories on the chimney breast (y = 18) facing north,
    // closets in stalls on the east wall, two stall urinals on the north wall.
    xm = 87.35 + (2.0 + LINER) / ft(1);  xme = 98 + 1/12 - (T_MAIN + LINER) / ft(1);
    for (x = [89.1, 91.7]) at(x, 18 + LINER / ft(1) + 0.03, 0) lav09(m);
    for (y = [26.9, 29.85]) at(xme, y, 90) toilet09(m);
    for (y = [25.35, 28.35]) at(0, 0) stall_side(m, xme, xme - 4.6, y);
    for (y = [25.35, 28.35]) at(xme - 4.6, y, 140) stall_door(m, 2.6, 5.0);
    for (x = [89.4, 91.4]) at(x, yn, 180) urinal09(m);
    for (x = [88.4, 90.4, 92.4]) at(x, yn, 180) if (m == "marble") bx(-0.05, 0, 0.3, 0.05, 1.7, 5.6);
}

// ------------------------------------------------------------------ inside doors (oak, five cross panels)
module door_leaf(m, w, h, t = 0.15) {               // hinge edge at x = 0, centred on y = 0
    s = 0.38; tr = 0.38; br = 0.8; mr = 0.25; ph = (h - tr - br - 4 * mr) / 5;
    if (m == "oak") difference() { bx(0, -t / 2, 0, w, t / 2, h);
        for (i = [0 : 4]) let(z0 = br + i * (ph + mr)) for (sd = [-1, 1]) bx(s, sd * t / 2 - 0.035, z0, w - s, sd * t / 2 + 0.035, z0 + ph); }
    if (m == "oak") for (i = [0 : 4]) let(z0 = br + i * (ph + mr)) for (sd = [-1, 1]) bx(s + 0.08, sd * (t / 2 - 0.035), z0 + 0.08, w - s - 0.08, sd * (t / 2 - 0.005), z0 + ph - 0.08);
    if (m == "brass") { for (sd = [-1, 1]) { ry(w - 0.28, 0, sd * (t / 2 + 0.12), 3.0, 0.07); sph(w - 0.28, sd * (t / 2 + 0.14), 3.0, 0.2); bx(w - 0.34, sd * t / 2, 2.7, w - 0.22, sd * (t / 2 + 0.02), 3.25); }
        for (z = [0.7, h / 2 - 0.15, h - 1.0]) cz(-0.02, 0, z, z + 0.35, 0.07, 10); }
}
module pdoor(m, name, idx, swing = 0, leaves = 1) {
    r = irow(name); p0 = r[1]; p1 = r[2]; d = (p1 - p0) / norm(p1 - p0); a = atan2(d[1], d[0]); o = r[5][idx];
    c = ft(o[0]); w = ft(o[1]); h = o[3] - 0.08; lw = (leaves == 1 ? o[1] : o[1] / 2) - 0.04;
    translate([p0[0], p0[1], ZF]) rotate([0, 0, a]) {
        translate([c - w / 2 + 0.3, 0, 0]) rotate([0, 0, swing]) door_leaf(m, lw, h);
        if (leaves == 2) translate([c + w / 2 - 0.3, 0, 0]) rotate([0, 0, -swing]) translate([-ft(lw), 0, 0]) door_leaf(m, lw, h);
    }
}
module doors_place(m) {
    pdoor(m, "S1_smoking_east", 0, -88, 2);         // pair into the lunch-counter annex, open
    pdoor(m, "S1_smoking_east", 1, 0);               // men's toilet
    pdoor(m, "P1_ticket_passage", 1, 0);             // train-order office from the passage
    pdoor(m, "P2_ticket_trainorder", 0, 0);          // ticket office | train-order office
    pdoor(m, "P3_passage_town", 0, 0);               // women's toilet
    pdoor(m, "K1_kitchen", 0, -55);                  // kitchen, swung part open
    pdoor(m, "B1_baggage_express", 0, 0);            // baggage | express
}

// ------------------------------------------------------------------ ticket office
module chair09(m) {                                 // oak swivel office chair, seat toward +y
    if (m == "oak") { cz(0, 0, 1.55, 1.65, 1.45, 40);
        translate([0, 0, ft(2.0)]) rotate([0, 0, 195]) rotate_extrude(angle = 150, $fn = 40) translate([ft(0.62), 0]) square([ft(0.08), ft(0.55)]);
        for (a = [205 : 30 : 325]) rotate(a) translate([ft(0.62), 0, ft(1.65)]) cylinder(d = ft(0.07), h = ft(0.4), $fn = 8);
        for (s = [-1, 1]) translate([ft(s * 0.66), ft(-0.2), ft(2.2)]) rotate([-90, 0, 0]) cylinder(d = ft(0.1), h = ft(0.75), $fn = 10); }
    if (m == "iron") { cz(0, 0, 0.45, 1.55, 0.18, 12); for (a = [45 : 90 : 315]) rotate(a) hull() { cz(0, 0, 0.4, 0.55, 0.15, 8); cz(1.0, 0, 0.1, 0.2, 0.08, 8); }
        for (a = [45 : 90 : 315]) rotate(a) sph(1.0, 0, 0.07, 0.14); }
}
module rolltop09(m, W = 4.5) {                      // x 0..W, y 0 = wall, front y = 2.6
    prof = [[0, 2.5], [1.45, 2.5], [1.45, 2.7], [1.25, 3.25], [0.85, 3.75], [0.35, 4.1], [0, 4.1]];
    if (m == "oak") {
        bx(0, 0.05, 0, 1.4, 2.5, 2.4); bx(W - 1.4, 0.05, 0, W, 2.5, 2.4); bx(1.4, 0.05, 0.4, W - 1.4, 0.15, 2.4);
        bx(-0.05, 0, 2.4, W + 0.05, 2.65, 2.5);
        for (x = [0, W - 0.08]) translate([ft(x), 0, 0]) rotate([90, 0, 90]) linear_extrude(ft(0.08)) polygon([for (p = prof) [ft(p[0]), ft(p[1])]]);
        bx(0, 0, 2.5, W, 0.1, 4.1); bx(0, 0, 4.05, W, 0.45, 4.15);
        for (x = [0.5 : 0.5 : W - 0.4]) bx(x - 0.02, 0.1, 2.5, x + 0.02, 0.9, 3.55);       // pigeonholes
        for (z = [2.9, 3.25, 3.55]) bx(0.08, 0.1, z, W - 0.08, 0.9, z + 0.03);
        for (x0 = [0, W - 1.4]) for (z = [0.15, 0.75, 1.35, 1.9]) bx(x0 + 0.08, 2.5, z, x0 + 1.32, 2.53, z + 0.5);
    }
    if (m == "oak_dark") rx(0.08, W - 0.08, 0.6, 3.75, 0.55, 24);
    if (m == "brass") for (x0 = [0, W - 1.4]) for (z = [0.4, 1.0, 1.6, 2.15]) bx(x0 + 0.55, 2.53, z, x0 + 0.85, 2.58, z + 0.05);
    if (m == "paper") { for (x = [0.5 : 0.5 : W - 0.6]) bx(x + 0.06, 0.15, 2.53, x + 0.44, 0.75, 2.75); translate([ft(2.0), ft(1.7), ft(2.5)]) rotate([0, 0, 12]) cube([ft(0.85), ft(0.6), ft(0.02)]); }
    if (m == "black") { bx(1.0, 1.6, 2.5, 1.9, 2.25, 2.62); cz(3.4, 1.9, 2.5, 2.62, 0.2, 12); }
}
// operator's counter round the inside of the track-side bay window
BAYP = [[BAY_CX - BAY_W_WALL / 2, ft(4)], [BAY_CX + BAY_W_WALL / 2, ft(4)], [BAY_CX + BAY_W_WALL / 2, 0],
        [BAY_CX + BAY_W_FRONT / 2, -BAY_PROJ], [BAY_CX - BAY_W_FRONT / 2, -BAY_PROJ], [BAY_CX - BAY_W_WALL / 2, 0]];
module bay_in2d() offset(delta = -T_LIGHT - 0.3) polygon(BAYP);
module bay_band2d(dp) intersection() { difference() { bay_in2d(); offset(delta = -ft(dp)) bay_in2d(); }
    translate([BAY_CX - ft(12), -ft(6)]) square([ft(24), ft(6) - ft(0.05)]); }
module baycounter09(m) {
    cx = BAY_CX / ft(1);
    if (m == "oak") { translate([0, 0, ZF + ft(2.5)]) linear_extrude(ft(0.1)) bay_band2d(1.8);
        difference() { translate([0, 0, ZF]) linear_extrude(ft(2.5)) bay_band2d(1.65); at(cx - 1.4, -2.6) bx(0, 0, -0.1, 2.8, 2.7, 2.25); }
        at(cx - 1.4, -2.6) bx(0, 0, 2.25, 2.8, 0.9, 2.5); }
    if (m == "brass") for (x = [cx - 3.6, cx + 3.6]) at(x, -0.9) bx(-0.15, 0, 1.6, 0.15, 0.06, 1.66);
    // telegraph sounder on its resonator, key, green-shaded lamp, train-order pads
    if (m == "oak") at(cx - 0.4, -2.0, 0, 2.6) rotate([0, 0, 0]) bx(-0.32, -0.22, 0, 0.32, 0.22, 0.48);
    if (m == "brass") { at(cx - 0.4, -2.0, 0, 3.08) { bx(-0.25, -0.12, 0, 0.25, 0.12, 0.05); cz(-0.08, 0, 0.05, 0.3, 0.13, 12); cz(0.08, 0, 0.05, 0.3, 0.13, 12); bx(-0.28, -0.03, 0.32, 0.22, 0.03, 0.37); }
        at(cx + 0.2, -1.25, 0, 2.6) { bx(-0.12, -0.25, 0, 0.12, 0.25, 0.05); bx(-0.03, -0.25, 0.05, 0.03, 0.2, 0.12); } }
    if (m == "black") at(cx + 0.2, -1.05, 0, 2.6) cz(0, 0, 0.12, 0.18, 0.12, 12);
    if (m == "nickel") at(cx + 1.5, -1.9, 0, 2.6) { cz(0, 0, 0, 0.06, 0.45, 20); cz(0, 0, 0.06, 1.0, 0.05, 8); ry(0, 0, 0.35, 1.0, 0.05); }
    if (m == "shade") at(cx + 1.5, -1.55, 0, 3.55) difference() { cz2(0, 0, 0, 0.3, 0.75, 0.3, 32); cz2(0, 0, -0.01, 0.28, 0.7, 0.26, 32); }
    if (m == "bulb") at(cx + 1.5, -1.55, 0, 3.55) sph(0, 0, 0.12, 0.2);
    if (m == "paper") { at(cx - 1.4, -1.6, 8, 2.6) bx(0, 0, 0, 0.7, 0.5, 0.05); at(cx + 2.4, -1.2, -40, 2.6) bx(0, 0, 0, 0.7, 0.5, 0.04); }
    if (m == "black") at(cx - 1.9, -1.9, 0, 2.6) cz(0, 0, 0, 0.18, 0.18, 12);
}
module ticketcounter09(m) {                         // L along the waiting-room partition and the passage partition
    x0 = 40.25 + (2.0 + LINER) / ft(1); yN = 11.75 - (1.5 + LINER) / ft(1);
    if (m == "oak") at(0, 0) { bx(x0, 4.6, 0, x0 + 2.0, yN, 2.9); bx(x0, yN - 2.0, 0, 47.4, yN, 2.9);
        bx(x0, 4.5, 2.9, x0 + 2.1, yN, 3.0); bx(x0, yN - 2.1, 2.9, 47.5, yN, 3.0);
        for (y = [5.0 : 1.6 : 8.5]) field_y(x0 + 2.0, y, y + 1.3, 0.4, 2.6);
        for (x = [x0 + 2.3 : 1.6 : 46.0]) field(x, x + 1.3, 0.4, 2.6, yN - 2.0, -0.04, 0.1); }
    if (m == "iron") at(x0 + 1.0, 7.6, 0, 3.0) { bx(-0.25, -0.2, 0, 0.25, 0.2, 0.55); bx(-0.06, -0.3, 0.55, 0.06, 0.3, 0.62); }   // ticket dater
    if (m == "brass") at(x0 + 1.0, 9.0, 0, 3.0) intersection() { sph(0, 0, 0.0, 0.35); bx(-1, -1, 0, 1, 1, 1); }                // counter bell
    if (m == "oak_dark") at(44.3, yN - 0.6, 0, 3.0) bx(0, -0.25, 0, 1.8, 0.25, 0.9);                                            // ticket rack
    if (m == "paper") { at(44.3, yN - 0.6, 0, 3.0) for (i = [0 : 5]) bx(0.1 + i * 0.28, -0.2, 0.15, 0.3 + i * 0.28, 0.27, 0.8); at(x0 + 0.7, 6.0, 20, 3.0) bx(0, 0, 0, 0.7, 0.5, 0.03); }
}
module field_y(x, y0, y1, z0, z1, p = 0.04) { bx(x, y0, z0, x + p, y1, z1); bx(x, y0 + 0.1, z0 + 0.1, x + 2 * p, y1 - 0.1, z1 - 0.1); }
module ticket_office_place(m) {
    ticketcounter09(m);
    at(52.1, 11.75 - (1.5 + LINER) / ft(1), 180) rolltop09(m, 4.5);
    at(49.85, 7.9, 0) chair09(m);
    at(BAY_CX / ft(1), 0.2, 180) chair09(m);
    baycounter09(m);
}

// ------------------------------------------------------------------ clocks
module gallery_clock(m, d = 3.0) {                  // round 3 ft gallery clock, back on the wall (y = 0), face toward +y
    module face(y0, y1, dd) translate([0, ft(y0), 0]) rotate([-90, 0, 0]) cylinder(d = ft(dd), h = ft(y1 - y0), $fn = 64);
    if (m == "oak")   difference() { face(0, 0.3, d + 0.5); face(0.2, 0.5, d - 0.1); }
    if (m == "brass") difference() { face(0.25, 0.36, d + 0.06); face(0.2, 0.5, d - 0.12); }
    if (m == "cream") face(0, 0.24, d);
    if (m == "black") translate([0, ft(0.24), 0]) rotate([-90, 0, 0]) linear_extrude(ft(0.02)) {
        for (h = [0 : 11]) rotate(h * 30) translate([-ft(h % 3 == 0 ? 0.06 : 0.04), ft(d * 0.36)]) square([ft(h % 3 == 0 ? 0.12 : 0.08), ft(d * 0.1)]);
        for (k = [0 : 59]) if (k % 5 != 0) rotate(k * 6) translate([-ft(0.01), ft(d * 0.44)]) square([ft(0.02), ft(d * 0.03)]);
        difference() { circle(d = ft(d * 0.95), $fn = 64); circle(d = ft(d * 0.94), $fn = 64); }
        rotate(-305) hull() { circle(d = ft(0.1), $fn = 12); translate([0, ft(d * 0.24)]) circle(d = ft(0.05), $fn = 8); }      // 10:10
        rotate(-60) hull() { circle(d = ft(0.08), $fn = 12); translate([0, ft(d * 0.38)]) circle(d = ft(0.04), $fn = 8); }
        circle(d = ft(0.16), $fn = 16); }
}
module clocks_place(m) {
    at(40.25 - (2.0 + LINER) / ft(1), 16.5, 90, 12.8) gallery_clock(m);          // waiting room, over the passage opening
    at(87.35 - (2.0 + LINER) / ft(1), 17.0, 90, 12.0) gallery_clock(m);          // smoking room, east wall
}

// ------------------------------------------------------------------ pictures
// [image, x, y, angle (as at()), centre height, outer w, outer h]   angle 0 = on a south wall facing north,
// 180 = north wall facing south, -90 = west wall facing east, 90 = east wall facing west
YS = (T_MAIN + LINER) / ft(1); YN = 32 - YS; XW1 = 40.25 - (2.0 + LINER) / ft(1); XW2 = 60.25 + (2.0 + LINER) / ft(1);
XS1 = 87.35 - (2.0 + LINER) / ft(1); LXE = X_MAIN_E / ft(1) - (T_LIGHT + LINER) / ft(1); LYS = LUNCH_Y0 / ft(1) + (T_LIGHT + LINER) / ft(1); LYN = LUNCH_Y1 / ft(1) - (T_LIGHT + LINER) / ft(1);
FW = 0.24; MATW = 0.2;
ART = [
  ["jv_locos",       14.6, YS,  0,   7.2, 3.4, 2.5],     // waiting room, track wall, between the windows
  ["jv_station_cab", 26.0, YS,  0,   7.2, 3.4, 2.5],
  ["jv_postcard_1815",14.25, YN, 180, 7.2, 3.4, 2.5],     // waiting room, town wall
  ["jv_baggage",     26.25, YN, 180, 7.2, 3.4, 2.5],
  ["jv_val_1",        YS + 0.0, 6.0, -90, 7.6, 3.4, 2.3], // waiting room, west wall over the benches
  ["jv_val_2",        YS + 0.0, 26.0, -90, 7.6, 3.4, 2.3],
  ["jv_val_3",       73.7, YS,  0,   7.0, 3.4, 2.3],      // smoking room
  ["jv_locos",       73.85, YN, 180, 7.0, 3.4, 2.5],
  ["jv_station_cab", XS1, 17.0, 90,  6.6, 3.4, 2.5],
  ["jv_postcard_1815",109.2, LYS, 0, 6.1, 2.2, 1.75],     // lunch room, between the windows
  ["jv_val_1",       108.95, LYN, 180, 6.1, 2.2, 1.65],
  ["jv_baggage",     98 + 1/12 + LINER / ft(1), 20.0, -90, 6.4, 2.9, 2.2],
  ["jv_engine",      XW2, 26.5, -90, 7.4, 2.7, 3.3],         // smoking room, west wall: the 4-6-0 at the depot (postcard crop)
  ["jv_coaches",     LXE, 3.55, 90, 6.3, 3.0, 2.2]           // lunch room, east wall beside the counter: the wooden coaches
];
// image aspect (w / h) of each picture, after cropping (Blender/art/*.jpg)
ASPECT = [["jv_locos", 1.585], ["jv_station_cab", 1.582], ["jv_postcard_1815", 1.362], ["jv_baggage", 1.64],
          ["jv_val_1", 1.627], ["jv_val_2", 1.748], ["jv_val_3", 1.606],
          ["jv_engine", 0.780], ["jv_coaches", 1.514]];
function aspect(n) = ASPECT[search([n], ASPECT)[0]][1];
// picture area inside the mat, fitted to the image's shape
function pic_wh(e) = let(iw = e[5] - 2 * FW - 2 * MATW, ih = e[6] - 2 * FW - 2 * MATW, a = aspect(e[0]))
    iw / ih > a ? [ih * a, ih] : [iw, iw / a];
module picture(m, e) {                              // frame centred on the origin, back on the wall, face toward +y
    w = e[5]; h = e[6]; p = pic_wh(e); mw = p[0] + 2 * MATW; mh = p[1] + 2 * MATW;
    if (m == "frame") difference() { bx(-w / 2, 0, -h / 2, w / 2, 0.14, h / 2); bx(-mw / 2, -0.1, -mh / 2, mw / 2, 0.3, mh / 2);
        bx(-w / 2 - 0.1, 0.1, -h / 2 + 0.07, w / 2 + 0.1, 0.3, h / 2 - 0.07); }
    if (m == "gilt") difference() { bx(-mw / 2 - 0.04, 0, -mh / 2 - 0.04, mw / 2 + 0.04, 0.1, mh / 2 + 0.04); bx(-mw / 2, -0.1, -mh / 2, mw / 2, 0.3, mh / 2); }
    if (m == "mat") difference() { bx(-mw / 2, 0, -mh / 2, mw / 2, 0.06, mh / 2); bx(-p[0] / 2, 0.03, -p[1] / 2, p[0] / 2, 0.3, p[1] / 2); }
    if (m == "black") bx(-p[0] / 2, 0, -p[1] / 2, p[0] / 2, 0.035, p[1] / 2);                // backing behind the photograph
}
module art_place(m) for (e = ART) at(e[1], e[2], e[3], e[4]) picture(m, e);
// the photographs themselves: one line per picture for Blender (image quad in model mm)
module art_echo() for (e = ART) let(p = pic_wh(e), c = [ft(e[1]), ft(e[2]), ZF + ft(e[4])])
    echo(str("ART|", e[0], "|", c[0], "|", c[1], "|", c[2], "|", e[3], "|", ft(p[0]), "|", ft(p[1]), "|", ft(0.04)));

// ------------------------------------------------------------------ render only: ceilings and pendant lamps
// The printed model is open to the roof (NeoPixel light bars).  For pictures and VR the 18 ft rooms get plaster
// ceilings with a cove and period pendant lamps (glass globes on drop rods).  Not printed.
CEIL_H = 18.0;
module ceilings_place(m) at(0, 0) {
    if (m == "plaster") { bx(YS - 0.05, YS - 0.05, CEIL_H, XW1 + 0.05, YN + 0.05, CEIL_H + 0.15);
                          bx(XW2 - 0.05, YS - 0.05, CEIL_H, XS1 + 0.05, YN + 0.05, CEIL_H + 0.15);
                          bx(98 + 1/12 - 0.05, LYS - 0.05, 10.0, X_MAIN_E / ft(1) - T_LIGHT / ft(1), LYN + 0.05, 10.15); }   // lunch wing
    if (m == "oak_dark") for (r = [[YS, XW1], [XW2, XS1]]) {                                    // beams and cornice
        for (y = [8, 16, 24]) bx(r[0], y - 0.35, CEIL_H - 0.7, r[1], y + 0.35, CEIL_H);
        bx(r[0], YS, CEIL_H - 0.45, r[1], YS + 0.5, CEIL_H); bx(r[0], YN - 0.5, CEIL_H - 0.45, r[1], YN, CEIL_H);
        bx(r[0], YS, CEIL_H - 0.45, r[0] + 0.5, YN, CEIL_H); bx(r[1] - 0.5, YS, CEIL_H - 0.45, r[1], YN, CEIL_H); }
}
// the ticket bay (render only): its three walls had bare brick inside.  Pine wainscot to 5 ft with a cap,
// cream plaster to the 10 ft ceiling, pine casings round the windows, and a plaster ceiling over the bay.
module bay_finish(m) {
    for (n = ["Bay_front", "Bay_side_W", "Bay_side_E"]) let(r = wrow(n), T = r[3], o = r[7], a = r[8], L = ft(r[1]), op = r[6][0],
            c = ft(op[1]), w = ft(op[2]), b = ft(op[3]), t = ft(op[4]), e = ft(0.4), top = min(t + e, ft(10)))
        translate([o[0], o[1], FLOOR_Z]) rotate([0, 0, a]) {
            if (m == "oak_dark") difference() {
                union() { translate([0, T, 1]) cube([L, 0.8, ft(5) - 1]); translate([0, T, ft(5)]) cube([L, 1.2, ft(0.3)]);
                          translate([c - w / 2 - e, T, b - ft(0.3)]) cube([w + 2 * e, 1.2, top - b + ft(0.3)]); }
                translate([c - w / 2, T - 1, b]) cube([w, 4, t - b]); }
            if (m == "plaster") difference() { translate([0, T, ft(5.3)]) cube([L, 0.8, ft(10) - ft(5.3)]);
                translate([c - w / 2 - e - 0.1, T - 1, b - ft(0.3) - 0.1]) cube([w + 2 * e + 0.2, 4, ft(10)]); }
        }
    if (m == "plaster") translate([0, 0, FLOOR_Z + ft(10)]) linear_extrude(1.2) intersection() {
        offset(delta = -T_LIGHT + 0.5) polygon(BAYP); translate([BAY_CX - ft(10), -ft(5)]) square([ft(20), ft(5) + T_MAIN + 1.5]); }
}
LAMPS = [[10, 12, 9.5], [30, 12, 9.5], [10, 20, 9.5], [30, 20, 9.5], [20, 4, 9.5], [20, 28, 9.5],           // waiting room
         [67, 12, 9.5], [80, 12, 9.5], [67, 20, 9.5], [80, 20, 9.5],                                       // smoking room
         [104, 13.5, 7.6], [110, 7, 7.6], [121.5, 7, 7.6], [118.0, 22.8, 7.6], [104, 4.5, 7.6], [104, 22, 7.6],  // lunch room, kitchen
         [124.0, 22.4, 7.6], [121.0, 15.1, 7.8],                                                                    // over the range and the server's aisle
         [47.5, 6, 7.6], [57.6, 6, 7.6], [50, 16.5, 7.6], [44.9, 26.5, 7.6], [55, 26.5, 7.6], [92.7, 8, 7.6], [92.7, 24, 7.6]];
module lamps_place(m) at(0, 0) for (l = LAMPS) let(top = l[2] > 9 ? CEIL_H : 10) {
    if (m == "brass") { cz(l[0], l[1], l[2] + 1.1, top, 0.05, 8); cz2(l[0], l[1], l[2] + 0.75, l[2] + 1.15, 0.45, 0.25, 24); cz(l[0], l[1], top - 0.12, top, 0.5, 24); }
    if (m == "glass") difference() { sph(l[0], l[1], l[2] + 0.2, 1.1, 1.0, 32); sph(l[0], l[1], l[2] + 0.2, 1.0, 1.0, 32); bx(l[0] - 1, l[1] - 1, l[2] + 0.6, l[0] + 1, l[1] + 1, l[2] + 2); }
    if (m == "bulb") sph(l[0], l[1], l[2] + 0.35, 0.35, 1.3, 16);
}

// ------------------------------------------------------------------ everything
module details(m, render = true) {
    lunch_place(m); kitchen_place(m); restrooms_place(m); doors_place(m); ticket_office_place(m); clocks_place(m); art_place(m);
    if (render) { ceilings_place(m); lamps_place(m); bay_finish(m); }
}
module details_place(render = false) for (c = MATS) color(c[1]) details(c[0], render);

// ------------------------------------------------------------------ parts for printing: D_<object>_<material>
OBJS = [["counter", ["oak", "oak_dark", "marble", "brass", "black", "cream", "crockery", "glass", "bread"]],
        ["stool", ["iron", "nickel", "leather"]], ["backbar", ["oak", "oak_dark", "brass", "marble", "mirror", "nickel", "black", "glass", "crockery", "bread"]],
        ["range", ["iron", "black", "nickel", "copper", "steel"]], ["griddle", ["iron", "steel", "brass", "bread", "crockery", "black"]],
        ["icebox", ["oak", "oak_dark", "nickel"]], ["worktable", ["oak", "steel", "oak_dark", "crockery", "bread"]],
        ["hutch", ["oak", "oak_dark", "brass", "crockery"]], ["potrack", ["iron", "copper"]],
        ["toilet", ["porcelain", "oak", "nickel"]], ["urinal", ["porcelain", "nickel"]], ["lavatory", ["porcelain", "nickel", "oak", "mirror"]],
        ["stall_door", ["oak", "nickel"]], ["door", ["oak", "brass"]], ["rolltop", ["oak", "oak_dark", "brass", "paper", "black"]],
        ["chair", ["oak", "iron"]], ["gallery_clock", ["oak", "brass", "cream", "black"]], ["coalhod", ["black", "iron", "steel"]]];
function detail_parts() = [for (o = OBJS) for (m = o[1]) [str("D_", o[0], "_", m), 1]];
module detail_obj(o, m) {
    if (o == "counter") counter09(m, 11);       if (o == "stool") stool(m);           if (o == "backbar") backbar09(m, 8);
    if (o == "range") range09(m);               if (o == "griddle") griddle09(m);     if (o == "icebox") icebox09(m);
    if (o == "worktable") worktable09(m);       if (o == "hutch") hutch09(m);         if (o == "potrack") translate([0, 0, -ft(5.9)]) potrack(m);
    if (o == "toilet") toilet09(m);             if (o == "urinal") urinal09(m);       if (o == "lavatory") lav09(m);
    if (o == "stall_door") stall_door(m);       if (o == "door") door_leaf(m, 2.75, 7.4); if (o == "rolltop") rolltop09(m);
    if (o == "chair") chair09(m);               if (o == "gallery_clock") gallery_clock(m);
    if (o == "coalhod") coalhod09(m);
}
module detail_part(name) for (o = OBJS) for (m = o[1]) if (name == str("D_", o[0], "_", m)) detail_obj(o[0], m);

if (VIEW == "placed") details_place(true);
else if (VIEW == "art") art_echo();
else if (VIEW == "part") detail_part(PART);
