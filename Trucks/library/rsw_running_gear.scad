// =====================================================================
//  rsw_running_gear.scad  -  RSW shared truck library, part 1 of 2
//  Wheels, axles, bearings and the bearing pocket, for every truck in
//  Rib Side Works (caboose, freight cars, passenger cars, locomotives).
//  One place to fix: change a number here and every truck that uses
//  the library picks it up.                                  (TDQ-266)
//
//  Do not open on its own. Include rsw_trucks.scad, after setting
//      RG_SCALE = "G";        // "G" (1:29, 45 mm track) or "O" (1:48)
//  Optional, before the include:
//      RG_BEARING = "F683";   // overrides the scale's default bearing
//      RG_BEARING_FIT = 0.10; // overrides the pocket oversize
//
//  Sizes are mm unless the name ends in _in (prototype inches).
//  rg_in(x) turns prototype inches into model mm at the chosen scale.
// =====================================================================

rg_scale_name = is_undef(RG_SCALE) ? "G" : RG_SCALE;

// ---------------- standards, one row per scale ----------------
// ratio, gauge, back-to-back, wheel width, flange thickness, flange depth,
// axle rod, default bearing, sideframe thickness, hub-to-frame gap,
// pivot screw clearance, hub collar (radius past the axle), hub proud
// of the tread face, tread-face recess depth
//
// G: the values the caboose and passenger trucks were drawn with (7 Oct).
// O: 1:48 two-rail (TDQ-265). Back-to-back, wheel width and flange from
//    the NMRA O scale standard / RP-25 as best known - CHECK against an
//    NMRA O gauge before printing many (TDQ-267). Smaller axle and bearing
//    because a 7 mm bearing is wider than an O scale journal box.
RG_STD = [
//   name ratio gauge  b2b   w    fl_t fl_h axle brg     sf_t clr  screw hub  proud recess
    ["G", 29,  45.0,  40.5, 6.5, 1.5, 2.0, 3.0, "F683", 4.5, 0.8, 3.4,  3.5, 1.0,  2.2],
    ["O", 48,  31.75, 29.0, 4.4, 1.0, 1.0, 2.0, "MR52", 3.5, 0.6, 2.2,  2.5, 0.6,  1.4]
];
function rg_row(n) = [for (r = RG_STD) if (r[0] == n) r][0];
RG_ROW = rg_row(rg_scale_name);
assert(!is_undef(RG_ROW), str("RG_SCALE must be one of G, O - got ", rg_scale_name));

rg_scale       = RG_ROW[1];
rg_gauge       = RG_ROW[2];
rg_b2b         = RG_ROW[3];
rg_wheel_w     = RG_ROW[4];
rg_flange_t    = RG_ROW[5];
rg_flange_h    = RG_ROW[6];
rg_axle_d      = RG_ROW[7];
rg_bearing     = is_undef(RG_BEARING) ? RG_ROW[8] : RG_BEARING;
rg_sf_t        = RG_ROW[9];
rg_sf_clear    = RG_ROW[10];
rg_screw_d     = RG_ROW[11];
rg_hub         = RG_ROW[12];
rg_hub_proud   = RG_ROW[13];
rg_recess      = RG_ROW[14];
rg_brg_fit     = is_undef(RG_BEARING_FIT) ? 0.10 : RG_BEARING_FIT;   // CHECK with the bearing coupon
rg_axle_hole_d = rg_axle_d + 0.25;                                  // plain hole when rg_bearing = "none"

function rg_in(i) = i * 25.4 / rg_scale;      // prototype inches -> model mm
function rg_ft(f) = f * 304.8 / rg_scale;     // prototype feet   -> model mm
function rg_mm(g_mm) = g_mm * 29 / rg_scale;  // a size drawn in G (1:29) mm, carried to this scale

// ---------------- bearings ----------------
// [bore, OD, width, flange OD, flange thickness]
RG_BEARINGS = [
    ["F683", [3, 7, 3, 8.1, 0.8]],    // F683ZZ flanged, 3 x 7 x 3      (G default)
    ["683",  [3, 7, 3, 0,   0  ]],    // 683ZZ plain
    ["MR63", [3, 6, 2.5, 0, 0  ]],    // MR63ZZ, 3 x 6 x 2.5
    ["MR52", [2, 5, 2.5, 0, 0  ]],    // MR52ZZ, 2 x 5 x 2.5           (O default)
    ["F682", [2, 5, 2.3, 6.1, 0.6]],  // F682ZZ flanged, 2 x 5 x 2.3
    ["none", []]                      // axle runs in a plain printed hole
];
rg_brg = [for (b = RG_BEARINGS) if (b[0] == rg_bearing) b[1]][0];
assert(!is_undef(rg_brg), str("unknown bearing ", rg_bearing));
assert(len(rg_brg) == 0 || rg_brg[0] == rg_axle_d,
       str("bearing ", rg_bearing, " bore ", rg_brg[0], " mm does not match the ", rg_axle_d, " mm axle"));

// how far each axle end goes into a sideframe: through the bearing, tip in the relief behind it
rg_axle_depth = len(rg_brg) > 0 ? rg_brg[4] + rg_brg[2] + 0.5 : 2.5;

// sideframe inner face, measured out from the track centre line
rg_yi = rg_b2b / 2 + rg_wheel_w + rg_hub_proud + rg_sf_clear;
// cut the brass axle rod to this
rg_axle_len = 2 * (rg_yi + rg_axle_depth) - 0.4;

// ---------------- colours (views only) ----------------
RG_PAINT_WHEEL   = "#D9DCDF";   // printed wheels, painted light silver
RG_PAINT_AXLE    = "#B5A642";   // brass
RG_PAINT_BEARING = "#D01C1F";   // bearings shown red so they are easy to spot

// ---------------- printed wheel ----------------
// flange (back) face at z = 0, tread outward along +z. Print flange face down.
// wheel_d: tread diameter in mm. ream: leave the bore this much undersize.
module rg_wheel(wheel_d, ream = 0) {
    R   = wheel_d / 2;
    rb  = rg_axle_d * 0.97 / 2 - ream / 2;                          // press fit on the axle
    hub = rg_axle_d / 2 + rg_hub;
    w = rg_wheel_w; ft = rg_flange_t; fh = rg_flange_h;
    rotate_extrude($fn = 96) polygon([
        [rb, 0], [R + fh, 0], [R + fh, ft * 0.5], [R + 0.3 * ft / 1.5, ft + 0.3 * ft / 1.5],
        [R, ft + 0.8 * ft / 1.5], [R - (w - ft) * 0.05, w], [R - rg_recess, w],
        [R - rg_recess, w * 0.55], [hub, w * 0.55], [hub, w + rg_hub_proud], [rb, w + rg_hub_proud]]);
}

// bought ball bearing (views only): flange at z = 0, axle runs through the bore
module rg_bearing_part() {
    if (len(rg_brg) > 0) difference() {
        union() {
            if (rg_brg[3] > 0) cylinder(d = rg_brg[3], h = rg_brg[4], $fn = 48);
            cylinder(d = rg_brg[1], h = rg_brg[4] + rg_brg[2], $fn = 48);
        }
        translate([0, 0, -1]) cylinder(d = rg_brg[0], h = rg_brg[4] + rg_brg[2] + 2, $fn = 24);
    }
}

// pocket in the journal box, opening on the sideframe's inner face; axis along +z from the face
module rg_bearing_pocket(fit = rg_brg_fit) {
    if (len(rg_brg) == 0) cylinder(d = rg_axle_hole_d, h = rg_axle_depth + 0.01, $fn = 20);
    else {
        if (rg_brg[3] > 0) cylinder(d = rg_brg[3] + fit + 0.2, h = rg_brg[4] + 0.01, $fn = 48);   // flange counterbore
        cylinder(d = rg_brg[1] + fit, h = rg_brg[4] + rg_brg[2] + 0.01, $fn = 48);                // bearing, press fit
        cylinder(d = rg_brg[0] + 1.0, h = rg_brg[4] + rg_brg[2] + 1.2, $fn = 20);                 // relief for the axle tip
    }
}
// widest the pocket gets, for wall checks
rg_pocket_d = len(rg_brg) == 0 ? rg_axle_hole_d : max(rg_brg[1] + rg_brg_fit, rg_brg[3] > 0 ? rg_brg[3] + rg_brg_fit + 0.2 : 0);

// fit test: three pockets at FIT - 0.05, FIT, FIT + 0.05 (engraved -, 0, +)
module rg_bearing_coupon() {
    d = len(rg_brg) > 0 ? rg_brg[4] + rg_brg[2] + 1.5 : rg_axle_depth + 1.5;
    pitch = rg_pocket_d + 5;
    difference() {
        translate([0, -6, 0]) cube([3 * pitch, 12, d]);
        for (i = [0:2]) translate([pitch / 2 + i * pitch, 0, -0.01]) rg_bearing_pocket(rg_brg_fit - 0.05 + i * 0.05);
        for (i = [0:2]) translate([pitch / 2 + i * pitch, -5.5, d - 0.4]) linear_extrude(1)
            text(i == 0 ? "-" : i == 1 ? "0" : "+", size = 3, halign = "center");
    }
}

// a wheelset centred on the axle: brass rod, two printed wheels, a bearing at each end
module rg_wheelset(wheel_d, yi = rg_yi, bearings = true) {
    color(RG_PAINT_AXLE) rotate([90, 0, 0]) cylinder(d = rg_axle_d, h = 2 * (yi + rg_axle_depth) - 0.4, center = true, $fn = 20);
    for (s = [1, -1]) scale([1, s, 1]) {
        translate([0, rg_b2b / 2, 0]) rotate([-90, 0, 0]) color(RG_PAINT_WHEEL) rg_wheel(wheel_d);
        if (bearings) translate([0, yi, 0]) rotate([-90, 0, 0]) color(RG_PAINT_BEARING) rg_bearing_part();
    }
}

module rg_track(len) {
    color("#8C8C8C") for (s = [-1, 1]) translate([-len / 2, s * rg_gauge / 2 - rg_mm(1.5), -rg_mm(8)])
        cube([len, rg_mm(3), rg_mm(8)]);
}

function rg_buy_text(axles_per_truck, trucks = 2) = str(
    trucks * axles_per_truck, " axles: ", rg_axle_d, " mm brass rod cut to ", round(rg_axle_len * 10) / 10, " mm; ",
    len(rg_brg) > 0 ? str(2 * trucks * axles_per_truck, " ", rg_bearing, "ZZ bearings; ") : "no bearings (plain holes); ",
    trucks, " pivot screws ", rg_scale_name == "G" ? "M3" : "M2");
