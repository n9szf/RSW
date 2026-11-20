// =====================================================================
//  es2_truck.scad  -  ES-2 truck, PRINTED and UNPOWERED (Tom 10/13:
//  "non power, best looking"). GE equalized bar-frame motor truck from
//  the GE drawing of 10050 and Tom's HO E83: journal boxes with lids in
//  pedestal jaws, equalizer bars under the boxes on coil springs, centre
//  bolster column with its spring nest, frame ends dropping past the wheels,
//  the central brake cylinder and the two traction motors between the axles
//  (cosmetic, on the bolster piece). v5 (17 Oct 2026): corrected to the MPL
//  Truck Assembly drawing 18524-A (sheet 10): frame centres 6 ft 6 in, spring
//  centres 4 ft 2 in, longer frame ends, one Westinghouse 10 x 12 brake cylinder;
//  the sandboxes are inside the hoods (sheets 03 / 04), not on the truck.
//  Wheels, brass axles and F683 bearings: the shared RSW running gear
//  (Trucks / library / rsw_running_gear.scad), as on the passenger cars.
//  Locomotive trucks keep their own library in the loco's folder (TDQ-266).
//  Truck frame: x = 0 truck centre, z = 0 rail top.
//  Per truck: 2 sideframes, 1 bolster (with the motors), 4 wheels,
//  2 axles (3 mm brass, see the report), 4 F683ZZ bearings, 1 shoulder bolt 4 x 16 (M3) + M3 nylon nut,
//  2 pins of 1 mm brass wire (bolster to sideframes).
//  v10 (18 Nov 2026, Tom): the bolster ends are dovetails that slide down into dovetail grooves in the
//  sideframes (stop the sideframes spreading), and a 1 mm brass pin from the outside of each sideframe
//  through the groove into the dovetail (stops the bolster lifting out). No glue: the truck comes apart.
// =====================================================================

tk_ax      = p(WB) / 2;                       // 42.0 mm
tk_box_hx  = p(TK_BOX[0]) / 2;                // journal box half length (MPL sheet 10)
tk_box_z   = [axle_z - p(TK_BOX[1]) * 0.48, axle_z + p(TK_BOX[1]) * 0.52];
tk_box_out = 3.5;                             // box stands proud of the frame
tk_chord_z = [tk_box_z[1], tk_box_z[1] + 4.5];
tk_tie_z   = [12, 15];
tk_eq_z    = [5.5, 8.5];                      // equalizer bar
tk_col_hx  = p(10);
tk_col_top = pivot_z - 4;
tk_end     = tk_ax + p(TK_END_OUT);           // frame end beyond each axle (MPL sheet 10)
tk_yi      = p(TK_FRAME_C) / 2 - rg_sf_t / 2;  // sideframe inner face: frame centres 6 ft 6 in (MPL sheet 10)
tk_yo      = tk_yi + rg_sf_t;
tk_axle_len = 2 * (tk_yi + rg_axle_depth) - 0.4; // brass axle cut length for these wider-set frames
tk_bol_hx  = 7;
tk_bol_z   = [pivot_z - 12, pivot_z];
tk_tab     = 2;                                // (v9 and before: glued 2 mm tab)
// v10 dovetail joint and pin
tk_dove_d  = rg_sf_t * 0.53;                  // dovetail depth into the sideframe: G 2.4 mm, O 1.85 mm
tk_dove_u  = tk_dove_d * 0.33;                // undercut each side (about 18 degrees)
TK_DOVE_FIT = 0.15;                           // clearance all round - CHECK with es2_dovetail_coupon()
TK_PIN     = [1.0, 1.15, 0.95];               // pin wire, hole through the sideframe, hole in the bolster (snug)
tk_pin_z   = (tk_bol_z[0] + tk_col_top) / 2;  // G 32.1 mm: on the column above the spring nest
tk_pin_in  = 5;                               // pin goes this far into the bolster past the sideframe face
tk_pin_len = rg_sf_t + tk_pin_in;             // brass pin cut length (G 9.5 mm)
tk_motor   = [13, 6.5, 18];                   // traction motor: centre x (each side of the bolster), radius, axis height

module es2_sideframe_2d() {
    offset(r = 0.05) offset(delta = -0.05) offset(delta = 0.05) union() {     // offsets weld the slivers so CGAL gets a closed mesh
        for (s = [-1, 1]) {
            translate([s * tk_ax - tk_box_hx, tk_box_z[0]]) square([2 * tk_box_hx, tk_box_z[1] - tk_box_z[0]]);
            for (j = [-1, 1]) translate([s * tk_ax + j * (tk_box_hx + 0.8) - 0.8, tk_box_z[0] - 0.5])     // pedestal jaws
                square([1.6, tk_chord_z[0] - tk_box_z[0] + 0.5]);
            translate([s * tk_ax - 1, tk_eq_z[1] - 0.01]) square([2, tk_box_z[0] - tk_eq_z[1] + 0.02]);   // hanger, box to equalizer
        }
        translate([-tk_end, tk_chord_z[0]]) square([2 * tk_end, tk_chord_z[1] - tk_chord_z[0]]);           // top chord
        translate([-tk_ax + tk_box_hx - 1, tk_tie_z[0]]) square([2 * (tk_ax - tk_box_hx + 1), tk_tie_z[1] - tk_tie_z[0]]);
        translate([-tk_col_hx, tk_tie_z[0]]) square([2 * tk_col_hx, tk_col_top - tk_tie_z[0]]);           // bolster column
        hull() {                                                                                           // equalizer, dropped in the middle
            translate([-tk_ax - 4, tk_eq_z[0] + 1]) square([8, tk_eq_z[1] - tk_eq_z[0]]);
            translate([-tk_ax + 14, tk_eq_z[0]]) square([1, tk_eq_z[1] - tk_eq_z[0]]);
        }
        hull() {
            translate([tk_ax - 4, tk_eq_z[0] + 1]) square([8, tk_eq_z[1] - tk_eq_z[0]]);
            translate([tk_ax - 15, tk_eq_z[0]]) square([1, tk_eq_z[1] - tk_eq_z[0]]);
        }
        translate([-tk_ax + 14, tk_eq_z[0]]) square([2 * (tk_ax - 14), tk_eq_z[1] - tk_eq_z[0]]);
        for (s = [-1, 1]) hull() {                                                                         // frame end, dropping past the wheel
            translate([s * tk_end - (s > 0 ? 14 : 0), tk_chord_z[0]]) square([14, tk_chord_z[1] - tk_chord_z[0]]);
            translate([s * (tk_end - 2) - 1.5, axle_z - 2]) square([3, 3]);
        }
    }
}
module es2_sideframe() {            // +y side, inner face at y = tk_yi
    difference() {
        union() {
            translate([0, tk_yi, 0]) rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(rg_sf_t) es2_sideframe_2d();
            for (s = [-1, 1]) {
                // journal box, lid and hinge lug
                translate([s * tk_ax - tk_box_hx, tk_yi, tk_box_z[0]]) cube([2 * tk_box_hx, rg_sf_t + tk_box_out, tk_box_z[1] - tk_box_z[0]]);
                translate([s * tk_ax - tk_box_hx + 1, tk_yo + tk_box_out - 0.01, tk_box_z[0] + 1]) cube([2 * tk_box_hx - 2, 0.6, tk_box_z[1] - tk_box_z[0] - 3]);
                translate([s * tk_ax, tk_yo + tk_box_out - 0.5, tk_box_z[1] - 2.2]) rotate([0, 90, 0]) cylinder(d = 2.2, h = 5, center = true, $fn = 16);
                // equalizer springs (two coils each side of the column)
                translate([s * p(TK_SPRING_C) / 2, tk_yi + rg_sf_t / 2, tk_eq_z[1] - 0.01]) coil(4.4, tk_tie_z[0] - tk_eq_z[1] + 0.02);   // spring centres 4 ft 2 in
            }
            // bolster spring nest on the column, and the brake cylinder
            for (dx = [-3.2, 3.2]) translate([dx, tk_yo - 0.5, tk_tie_z[1]]) coil(4.2, 8, outward = true);
        }
        for (s = [-1, 1]) translate([s * tk_ax, tk_yi - 0.01, axle_z]) rotate([-90, 0, 0]) rg_bearing_pocket();
        truck_sand_holes();
        translate([0, 0, tk_bol_z[0] - TK_DOVE_FIT]) linear_extrude(50) tk_dove_2d(TK_DOVE_FIT);                   // v10 dovetail groove, open at the top
        translate([0, tk_yi - 1, tk_pin_z]) rotate([-90, 0, 0]) cylinder(d = TK_PIN[1], h = rg_sf_t + tk_box_out + 2, $fn = 16);   // pin hole, right through
        for (s = [-1, 1]) translate([s * tk_ax - tk_box_hx - 1, tk_yo + tk_box_out - 0.5, tk_box_z[0] + 2.5]) cube([2 * tk_box_hx + 2, 1.2, 0.5]);  // box lid line
    }
}
// coil spring: a stack of rings (reads as a spring at G size); axis z
module coil(d, h, outward = false) {
    n = max(2, floor(h / 1.4));
    translate(outward ? [0, d / 2, 0] : [0, 0, 0]) {
        cylinder(d = d * 0.62, h = h, $fn = 16);
        for (i = [0 : n - 1]) translate([0, 0, (i + 0.5) * h / n]) scale([1, 1, 0.55]) rotate_extrude($fn = FN) translate([d / 2 - 0.55, 0]) circle(r = 0.7, $fn = 10);
    }
}

// bolster with the two traction motors hung from it (cosmetic; they clear the axles and wheels)
module es2_bolster() {
    my = rg_b2b / 2 - 2;                       // motors stop 2 mm inside the wheel backs
    difference() {
        union() {
            translate([-tk_bol_hx, -tk_yi, tk_bol_z[0]]) cube([2 * tk_bol_hx, 2 * tk_yi, tk_bol_z[1] - tk_bol_z[0]]);
            for (m = [0, 1]) mirror([0, m, 0]) translate([0, 0, tk_bol_z[0]]) linear_extrude(tk_bol_z[1] - tk_bol_z[0]) tk_dove_2d(0);   // v10 dovetail ends
            // Westinghouse 10 x 12 in brake cylinder, at the truck centre beside the bolster (MPL sheet 10)
            translate([-tk_bol_hx - p(TK_BRAKE[1]) + 1, 0, tk_bol_z[0] - 1]) rotate([0, 90, 0]) cylinder(d = p(TK_BRAKE[0]), h = p(TK_BRAKE[1]), $fn = FN);
            for (s = [-1, 1]) {
                translate([s * tk_motor[0], 0, tk_motor[2]]) rotate([90, 0, 0]) cylinder(r = tk_motor[1], h = 2 * my, center = true, $fn = 8);   // motor frame (octagon)
                for (e = [-1, 1]) translate([s * tk_motor[0], e * (my - 1), tk_motor[2]]) rotate([90, 0, 0]) cylinder(r = tk_motor[1] - 1.2, h = 2.4, center = true, $fn = FN);  // end bells
                hull() {                                                                                        // nose lug up to the bolster
                    translate([s * tk_motor[0] - 3, -my + 3, tk_motor[2] + tk_motor[1] - 2]) cube([6, 2 * my - 6, 1]);
                    translate([s * (tk_bol_hx - 0.5) - (s > 0 ? 0 : 1), -my + 3, tk_bol_z[0]]) cube([1, 2 * my - 6, 0.6]);
                }
            }
        }
        translate([0, 0, tk_bol_z[0] - 30]) cylinder(d = PIVOT_FIT[1], h = 60, $fn = FN);                        // shoulder bolt (Tom 10/18)
        for (m = [0, 1]) mirror([0, m, 0]) translate([0, tk_yi - tk_pin_in - 0.5, tk_pin_z]) rotate([-90, 0, 0])
            cylinder(d = TK_PIN[2], h = tk_pin_in + tk_dove_d + 1, $fn = 16);                                       // v10 pin holes
    }
}
// v10 dovetail section, narrow neck at v = 0 (the sideframe face), wide at v = depth; fit grows it all round
module tk_dove_local(fit = 0) {
    w0 = tk_bol_hx - tk_dove_u + fit; w1 = tk_bol_hx + fit;
    polygon([[-w0, -0.6], [w0, -0.6], [w0, 0], [w1, tk_dove_d + fit], [-w1, tk_dove_d + fit], [-w0, 0]]);
}
module tk_dove_2d(fit = 0) translate([0, tk_yi]) tk_dove_local(fit);        // in the truck: x-y plane
// v10 test coupon (part dovetail_coupon): a block that prints inner face down like the sideframes, with three
// grooves (fit 0.10 / 0.15 / 0.20 mm, marked with 1 / 2 / 3 notches), and a key (a bolster end) that prints
// standing like the bolster. Pick the groove the key slides into by hand without rocking; set TK_DOVE_FIT to it.
module es2_dovetail_coupon() {
    L = 12; pitch = 2 * tk_bol_hx + 6; t = rg_sf_t;
    difference() {
        translate([-pitch / 2, 0, 0]) cube([3 * pitch, L, t]);
        for (i = [0 : 2]) translate([i * pitch, 0, 0]) {
            translate([0, -1, 0]) rotate([-90, 0, 0]) mirror([0, 1, 0]) linear_extrude(L + 2) tk_dove_local(0.10 + 0.05 * i);
            for (n = [0 : i]) translate([-tk_bol_hx - 1.6, 1.5 + 2 * n, t - 0.6]) cube([1, 0.8, 1]);               // notches
            translate([0, L / 2, -1]) cylinder(d = TK_PIN[1], h = t + 2, $fn = 16);                                  // pin hole
        }
    }
    translate([pitch, -12, 0]) difference() {                                                                       // the key
        union() {
            translate([-tk_bol_hx, -6, 0]) cube([2 * tk_bol_hx, 6, L]);
            linear_extrude(L) tk_dove_local(0);
        }
        translate([0, -tk_pin_in - 0.5, L / 2]) rotate([-90, 0, 0]) cylinder(d = TK_PIN[2], h = tk_pin_in + tk_dove_d + 1, $fn = 16);
    }
}
// ---------------- spoked wheel (Tom 10/17: "make the wheels spoked") ----------------
// Steel tyre on a spoked centre, as GE motor trucks of 1916 (GE PRACTICE: 40 in wheels, 14 spokes).
// Tread and flange as the RSW running gear (rg_wheel), so it runs the same. Flange face down to print.
ES2_SPOKES = 14;
module es2_wheel(wheel_d) {
    R = wheel_d / 2; w = rg_wheel_w; ft = rg_flange_t; fh = rg_flange_h;
    rb = rg_axle_d * 0.97 / 2;                          // press fit on the axle
    hub = rg_axle_d / 2 + rg_hub; tyre = p(3.2);        // tyre thickness
    rim_in = R - tyre - 1.0;                            // inside of the wheel-centre rim
    web = w * 0.55;
    rotate_extrude($fn = FN) polygon([                  // tyre and rim
        [rim_in, 0], [R + fh, 0], [R + fh, ft * 0.5], [R + 0.3 * ft / 1.5, ft + 0.3 * ft / 1.5],
        [R, ft + 0.8 * ft / 1.5], [R - (w - ft) * 0.05, w], [R - tyre, w], [R - tyre, web + 0.6], [rim_in, web]]);
    rotate_extrude($fn = FN) polygon([[rb, 0], [hub + 1.2, 0], [hub + 1.2, web], [hub, w + rg_hub_proud], [rb, w + rg_hub_proud]]);   // hub
    for (i = [0 : ES2_SPOKES - 1]) rotate([0, 0, i * 360 / ES2_SPOKES])        // spokes, tapering out to the rim
        hull() {
            translate([hub + 0.6, 0, 0]) cylinder(d = 1.9, h = web, $fn = 12);
            translate([rim_in + 0.4, 0, 0]) cylinder(d = 1.4, h = web * 0.85, $fn = 12);
        }
    for (i = [0 : 5]) rotate([0, 0, i * 60 + 30]) translate([hub - 0.5, 0, w + rg_hub_proud - 0.01]) cylinder(d = 0.9, h = 0.35, $fn = 8);   // hub bolts
}
module es2_wheelset(wheel_d, yi) {
    color(RG_PAINT_AXLE) rotate([90, 0, 0]) cylinder(d = rg_axle_d, h = 2 * (yi + rg_axle_depth) - 0.4, center = true, $fn = 20);
    for (s = [1, -1]) scale([1, s, 1]) {
        translate([0, rg_b2b / 2, 0]) rotate([-90, 0, 0]) color(RG_PAINT_WHEEL) es2_wheel(wheel_d);
        translate([0, yi, 0]) rotate([-90, 0, 0]) color(RG_PAINT_BEARING) rg_bearing_part();
    }
}

module es2_truck(show_wheels = true) {
    es2_sideframe();
    mirror([0, 1, 0]) es2_sideframe();
    es2_bolster();
    if (show_wheels) for (s = [-1, 1]) translate([s * tk_ax, 0, axle_z]) es2_wheelset(wheel_d, tk_yi);
}
// one print per truck: 2 sideframes (inner face down), the bolster (top down), 4 wheels (flange face down)
module es2_truck_plate() {
    for (i = [0, 1]) translate([0, 62 + i * 36, -tk_yi]) rotate([90, 0, 0]) es2_sideframe();
    translate([-60, -20, tk_bol_z[1]]) rotate([180, 0, 0]) es2_bolster();
    for (i = [0, 1], j = [0, 1]) translate([5 + i * 44, -40 + j * 44, 0]) es2_wheel(wheel_d);
}
