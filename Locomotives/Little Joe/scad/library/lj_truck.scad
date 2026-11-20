// =====================================================================
//  lj_truck.scad - Little Joe running gear, unpowered, printed.
//  Each half of the loco is 2-D: a 4-axle driving truck and a 2-axle
//  guide truck. On the model each truck pivots on its own screw in the
//  frame (the real guide truck hangs off the driving frame - TDQ).
//  A truck = 2 sideframes + 1 "H" frame (spine, bolster, transoms),
//  screwed together from outside. Wheels on brass axles in bearings
//  (G, O - the RSW shared truck library); HO uses bought pinpoint wheelsets.
//  The middle two driving axles are blind (no flanges) for curves.
// =====================================================================

// truck kinds: [axles, spacing, wheel dia]
function tk(kind) = kind == "drive" ? [4, AX_SP, DRV_D] : [2, GDE_SP, GDE_D];
function tk_ax(kind) = kind == "drive" ? DRV_AX : [-GDE_SP / 2, GDE_SP / 2];      // DWG axle positions
BOX_W = p(13);                              // journal box width (x)

// sideframe, in place for side sy (inner face at sy * T_YI), axles along y
module lj_sideframe(kind, sy = 1) {
    t = tk(kind); R = t[2] / 2; xs = tk_ax(kind); hl = max(xs) + BOX_W / 2 + p(3);
    zb = R - p(9); zt = R + p(13);                     // ESTIMATE bar frame depth
    mirror([0, sy > 0 ? 0 : 1, 0]) difference() {
        union() {
            // bar frame plate
            translate([-hl, T_YI, zb]) cube([2 * hl, T_SF, zt - zb]);
            // journal boxes, proud of the outside
            for (x = xs) translate([x - BOX_W / 2, T_YI + T_SF - 0.01, R - p(8)]) cube([BOX_W, max(0.8, p(3)), p(16)]);
            // equalizer bar along the bottom with springs
            translate([-hl + p(2), T_YI + T_SF - 0.01, zb]) cube([2 * hl - p(4), max(0.6, p(2)), p(3)]);
            for (i = [0:len(xs) - 2]) translate([(xs[i] + xs[i + 1]) / 2, T_YI + T_SF, zb + p(3)])
                cylinder(d = p(6), h = p(7), $fn = 16);
        }
        // lightening windows between the axles
        for (i = [0:len(xs) - 2]) {
            w = xs[i + 1] - xs[i] - BOX_W - p(10);
            if (w > 1) translate([(xs[i] + xs[i + 1]) / 2 - w / 2, T_YI - 1, R - p(7)]) cube([w, T_SF + 2, p(7.5)]);   // below the H frame screws
        }
        // bearing pockets (G, O) or pinpoint cones (HO), opening on the inner face
        for (x = xs) translate([x, T_YI - 0.01, R]) rotate([-90, 0, 0])
            if (SC == "HO") cylinder(d1 = T_AXLE * 0.9, d2 = 0.2, h = 1.2, $fn = 16);
            else rg_bearing_pocket();
        // screw holes into the H frame
        for (x = h_screw_xs(kind)) translate([x, T_YI - 1, h_z0(kind) + T_HT / 2]) rotate([-90, 0, 0]) cylinder(d = TRUCK_SCREW[1], h = T_SF + 5, $fn = 16);
    }
}
// H frame: spine along x over the axles, bolster in the middle, transoms between the outer pairs (drive)
function h_z0(kind) = tk(kind)[2] / 2 + T_AXLE / 2 + 1;
function h_cross(kind) = let(xs = tk_ax(kind)) kind == "drive" ? [(xs[0] + xs[1]) / 2, (xs[1] + xs[2]) / 2, (xs[2] + xs[3]) / 2] : [0];
// width of each cross member: the gap it sits in, less the wheels at the H frame's lowest edge
function h_gap(kind, i) = let(xs = tk_ax(kind)) kind == "drive" ? xs[i + 1] - xs[i] : xs[1] - xs[0];
function h_cross_w(kind, i = 1) = let(R = tk(kind)[2] / 2, h = T_AXLE / 2 + 1) h_gap(kind, i) - 2 * sqrt(R * R - h * h) - 1.5;
function h_screw_xs(kind) = kind == "drive" ? h_cross(kind) : [-h_cross_w(kind, 0) / 4, h_cross_w(kind, 0) / 4];
module lj_hframe(kind) {
    t = tk(kind); xs = tk_ax(kind); z0 = h_z0(kind);
    sp = max(xs) + t[2] / 2 * 0.5;
    difference() {
        union() {
            translate([-sp, -max(2.5, p(8)), z0]) cube([2 * sp, 2 * max(2.5, p(8)), T_HT]);
            for (i = [0:len(h_cross(kind)) - 1]) let(x = h_cross(kind)[i], w = h_cross_w(kind, kind == "drive" ? i : 0))
                translate([x - w / 2, -T_YI + 0.15, z0]) cube([w, 2 * T_YI - 0.3, T_HT]);
        }
        // pivot hole and nut trap from below
        translate([0, 0, z0 - 1]) cylinder(d = PIVOT[0], h = T_HT + 2, $fn = 20);
        translate([0, 0, z0 - 0.01]) cylinder(d = PIVOT[1] / cos(30) + 0.3, h = T_HT * 0.5, $fn = 6);
        // pilot holes for the sideframe screws
        for (x = h_screw_xs(kind), sy = [-1, 1]) translate([x, sy * (T_YI + 1), z0 + T_HT / 2]) rotate([sy * 90, 0, 0])
            cylinder(d = TRUCK_SCREW[0], h = min(8, T_YI * 0.6) + 1, $fn = 16);
    }
}
// wheels (G, O printed; HO bought, shown simply)
module lj_wheel(d, blind = false) {
    if (SC == "HO") rotate_extrude($fn = 48) polygon([[0.5, 0], [d / 2 + (blind ? 0 : 0.6), 0], [d / 2 + (blind ? 0 : 0.6), 0.5], [d / 2, 0.8], [d / 2 - 0.1, 2.6], [0.5, 2.6]]);
    else if (blind) intersection() { rg_wheel(d); translate([0, 0, -1]) cylinder(d = d, h = 50, $fn = 96); }
    else rg_wheel(d);
}
function ho_b2b() = 14.4;
module lj_wheelsets(kind, mode = "both") {      // mode: both, wheels, axles
    t = tk(kind); xs = tk_ax(kind);
    for (i = [0:len(xs) - 1]) translate([xs[i], 0, t[2] / 2]) {
        blind = BLIND_MIDDLE && kind == "drive" && (i == 1 || i == 2);
        b2b = SC == "HO" ? ho_b2b() : rg_b2b;
        if (mode != "wheels") rotate([90, 0, 0]) cylinder(d = T_AXLE, h = 2 * T_YI + (SC == "HO" ? 2.4 : 2 * rg_axle_depth - 0.4), center = true, $fn = 16);
        if (mode != "axles") for (s = [1, -1]) scale([1, s, 1]) translate([0, b2b / 2, 0]) rotate([-90, 0, 0]) lj_wheel(t[2], blind);
    }
}
module lj_truck(kind, wheels = true) {
    for (sy = [-1, 1]) lj_sideframe(kind, sy);
    lj_hframe(kind);
    if (wheels) lj_wheelsets(kind);
}
// what: frames (sideframes + H), wheels, axles
module lj_trucks_placed(what = "frames") for (sx = [-1, 1]) {
    translate([sx * DRV_X, 0, 0]) if (what == "frames") lj_truck("drive", false); else lj_wheelsets("drive", what);
    translate([sx * GDE_X, 0, 0]) if (what == "frames") lj_truck("guide", false); else lj_wheelsets("guide", what);
}
