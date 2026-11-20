// =====================================================================
//  es2_extras.scad  -  v7 (Tom 10/17, TDQ-342 "yes"): trolley pole and base,
//  the pole hook mast, sand pipes, air hoses, uncoupling levers.
//  MPL sheet 08 (Roof Plan): US 13-B trolley base on the roof, S-141-A slider
//  trolley. HO E83: the pole lies back from the roof to a braced mast with a hook
//  near the end of hood 2, to one side. Wire and pole are bought brass (black);
//  the printed parts carry the holes for them.
// =====================================================================

// ---------------- trolley pole ----------------
TB_X    = p(50);          // trolley base on the roof, toward hood 2 (MPL sheet 08, scaled)
TB_Y    = -p(18);         // to one side, so the pole clears the headlight (HO E83: mast to one side)
TH_X    = p(128);         // hook mast on hood 2, from the cab face (HO E83: near the end, clear of the sand caps)
TH_H    = p(30);          // pole rest above the hood top
POLE_D  = 2.0;            // mm brass rod or tube (bought)
POLE_TIP = p(26);         // pole beyond the hook, to the slider
tb_pad   = p(16);
tb_pad_top = roof_z(abs(TB_Y) - tb_pad / 2) + p(1);            // roof frame (z = 0 at the eave)
tb_pivot = [TB_X, TB_Y, deck_z + eave_z + tb_pad_top + p(7)];  // loco frame
th_rest  = [cab_hx + TH_X, TB_Y, deck_z + hood_top(TH_X) + TH_H];
pole_dir = (th_rest - tb_pivot) / norm(th_rest - tb_pivot);
pole_end = th_rest + pole_dir * POLE_TIP;
pole_pitch = atan2(-pole_dir[2], pole_dir[0]);                  // degrees down toward +x
module along_pole() rotate([0, 90 + pole_pitch, 0]) children(); // z axis -> the pole direction

// US 13-B base on the roof (part of the roof print): pad, turntable, two springs, pole socket
module roof_trolley_base() {
    translate([TB_X, TB_Y, 0]) {
        translate([-tb_pad / 2, -tb_pad / 2, roof_e]) cube([tb_pad, tb_pad, tb_pad_top - roof_e]);
        translate([0, 0, tb_pad_top - 0.01]) cylinder(d = p(10), h = p(2), $fn = FN);                // turntable
        translate([0, 0, tb_pad_top + p(2) - 0.01]) cylinder(d = p(5), h = p(5), $fn = FN);          // pivot post
        for (s = [-1, 1]) translate([-p(9), s * p(3.2), tb_pad_top + p(3.5)]) rotate([0, 90, 0]) cylinder(d = p(3), h = p(12), $fn = 16);   // springs
        translate([0, 0, tb_pad_top + p(7)]) along_pole() translate([0, 0, -p(3)]) cylinder(d = p(4.4), h = p(12), $fn = FN);           // socket
    }
}
module roof_trolley_hole() translate([TB_X, TB_Y, tb_pad_top + p(7)]) along_pole() translate([0, 0, -p(2)]) cylinder(d = POLE_D + 0.15, h = p(20), $fn = 16);

// hook mast on hood 2 (part of the hood 2 print): tapered post, diagonal brace toward the cab, U hook on top
// v9 (Tom 10/20): the hook mast is a SEPARATE print on a level pad on hood 2, with a 2 mm pin (like the headlight).
mast_pad = p(8);
mast_pad_top = pad_top(TH_X, mast_pad);                 // hood local frame
module hood_mast_pad() translate([TH_X - mast_pad / 2, TB_Y - mast_pad / 2, hood_top(TH_X + mast_pad / 2) - HOOD_WALL])
    cube([mast_pad, mast_pad, mast_pad_top - (hood_top(TH_X + mast_pad / 2) - HOOD_WALL)]);
module hood_mast_hole() translate([TH_X, TB_Y, mast_pad_top - 4]) cylinder(d = 2.1, h = 5, $fn = 16);
// the mast: z = 0 on the pad, x toward the end of the hood is +x (hood local)
module es2_pole_mast() {
    H = hood_top(TH_X) + TH_H - POLE_D / 2 - 0.4 - mast_pad_top;   // hook bottom under the pole
    zb = hood_top(TH_X - p(16)) - mast_pad_top;                     // hood top under the brace foot
    difference() {
        union() {
            hull() { translate([-p(1.8), -p(1.8), 0]) cube([p(3.6), p(3.6), 0.1]); translate([-p(1.2), -p(1.2), H - 0.1]) cube([p(2.4), p(2.4), 0.1]); }
            translate([-mast_pad / 2, -mast_pad / 2, 0]) cube([mast_pad, mast_pad, 0.7]);            // foot plate
            hull() {                                                                                  // brace
                translate([-0.6, -0.7, H * 0.62]) cube([1.2, 1.4, 1.2]);
                translate([-p(16), -0.7, zb]) cube([1.2, 1.4, 0.8]);
            }
            translate([0, 0, H - 0.3]) {                                                              // U hook across the pole
                translate([-0.9, -p(2.6), 0]) cube([1.8, p(5.2), 1.2]);
                for (s = [-1, 1]) translate([-0.9, s * p(2.6) - (s > 0 ? 1.2 : 0), 0]) cube([1.8, 1.2, POLE_D + 1.6]);
            }
        }
        translate([0, 0, -0.1]) cylinder(d = 2.1, h = 4, $fn = 16);
    }
}
module es2_pole_mast_placed() translate([TH_X, TB_Y, mast_pad_top]) es2_pole_mast();     // hood local frame
// pole (bought rod, preview / pictures) and the S-141-A slider at its tip (a small print on the cab plate)
module es2_trolley_pole() {
    hull() { translate(tb_pivot) sphere(d = POLE_D, $fn = 12); translate(pole_end) sphere(d = POLE_D * 0.85, $fn = 12); }
}
module es2_slider() {        // pole-tip frame: z = 0 at the pole end, z along the pole; socket for the rod
    difference() {
        union() {
            cylinder(d = p(3.2), h = p(4), $fn = 20);                                    // ferrule
            translate([0, 0, p(4)]) hull() { cylinder(d = p(3.2), h = 0.1, $fn = 20); translate([0, 0, p(5)]) cube([p(2), p(9), 0.1], center = true); }   // harp
            translate([-p(1), -p(6), p(9)]) cube([p(2), p(12), p(2.4)]);                  // slider shoe
            for (s = [-1, 1]) translate([-p(1), s * p(6) - (s > 0 ? 0 : p(1.6)), p(9)]) cube([p(2), p(1.6), p(4)]);   // shoe horns
        }
        translate([0, 0, -0.1]) cylinder(d = POLE_D + 0.15, h = p(3.5), $fn = 16);
    }
}
module es2_slider_placed() translate(pole_end) along_pole() translate([0, 0, -p(3.5)]) es2_slider();
// printed upright: ferrule on the bed, socket opening down, shoe on top

// ---------------- sand pipes (truck frame) ----------------
// One in front of each outer wheel, from the sideframe end (GE PRACTICE: truck-mounted sand pipes,
// fed by hose from the sandboxes in the hood ends). 1 mm brass wire, black; a hole in each frame end.
sp_x = tk_end - 2; sp_y = tk_yi + rg_sf_t / 2;
module truck_sand_holes() for (s = [-1, 1], m = [-1, 1]) translate([s * sp_x, m * sp_y, axle_z - 2.5]) cylinder(d = RAIL_HOLE, h = 4, $fn = 12);
module truck_sand_pipes() for (s = [-1, 1], m = [-1, 1])
    wire([[s * sp_x, m * sp_y, axle_z + 0.5], [s * sp_x, m * sp_y, 8], [s * (tk_ax + wheel_d / 2 + 2.2), m * (rg_gauge / 2 + 1), 3.2]]);

// ---------------- air hose (train line), one each end ----------------
// Angle cock on the end sill, hose hanging to the glad hand. Printed flat (separate, on the underside
// plate) and pinned into the end sill with a 1 mm wire. Drawn for the +x end, in the x-z plane at y = 0.
AH_Y = -p(16);
ah_z0 = esill_bot + 3;
ah_pts = [[1.6, 0], [3.2, 0], [5.5, -3.5], [7.0, -9], [7.4, -13.5], [7.0, -15.5]];
module es2_air_hose_2d() {
    for (i = [0 : len(ah_pts) - 2]) hull() { translate(ah_pts[i]) circle(d = 2.0, $fn = 12); translate(ah_pts[i + 1]) circle(d = 2.0, $fn = 12); }
    translate([-0.01, -1.4]) square([1.6, 2.8]);                                  // cock body against the sill
    translate([1.6, 0]) square([1.2, 2.6]);                                       // cock handle, up
    translate([6.2, -17.6]) square([2.6, 2.4]);                                   // glad hand
}
module es2_air_hose() difference() {
    translate([0, 1.0, 0]) rotate([90, 0, 0]) linear_extrude(2.0) es2_air_hose_2d();
    translate([-0.1, 0, 0]) rotate([0, 90, 0]) cylinder(d = RAIL_HOLE, h = 2.2, $fn = 12);
}
module es2_air_hose_placed() for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) mirror([0, s > 0 ? 0 : 1, 0]) translate([frame_hx, AH_Y, ah_z0]) es2_air_hose();
module es2_air_hose_print() translate([0, 0, 1.0]) rotate([-90, 0, 0]) es2_air_hose();
module frame_air_hose_holes() for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) mirror([0, s > 0 ? 0 : 1, 0])
    translate([frame_hx + 0.5, AH_Y, ah_z0]) rotate([0, -90, 0]) cylinder(d = RAIL_HOLE, h = 3.5, $fn = 12);

// ---------------- uncoupling levers ----------------
// One from each corner to the coupler, at the top of the end sill, in two printed brackets
// (part of the frame print); 1 mm wire, black (GE PRACTICE: a lever each side).
ul_z = deck_z - 3; ul_x = frame_hx + 2.0;
ul_br = [frame_hw - 7, 8];
module frame_lever_brackets() for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) for (m = [-1, 1], y = ul_br)
    translate([frame_hx - 0.01, m * y - 1.2, ul_z - 1.4]) cube([3.4, 2.4, 2.8]);
module frame_lever_holes() for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) for (m = [-1, 1], y = ul_br)
    translate([ul_x, m * y, ul_z]) rotate([90, 0, 0]) cylinder(d = RAIL_HOLE, h = 5, center = true, $fn = 12);
module es2_uncoupling_levers() for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) for (m = [-1, 1])
    wire([[ul_x, m * (frame_hw - 2.5), ul_z - 9], [ul_x, m * (frame_hw - 2.5), ul_z], [ul_x, m * 4, ul_z], [cpl_face - 6, m * 1.6, cpl_pad_bot - 1]]);

// all the black wire, loco position
module es2_black_wire() {
    es2_trolley_pole();
    es2_uncoupling_levers();
    for (s = [-1, 1]) translate([s * truck_x, 0, 0]) truck_sand_pipes();
}
