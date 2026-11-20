// =====================================================================
//  es2_details.scad  -  later-era headlight towers and the printed coupler
//  (the pantograph is bought - Tom 10/13)
// =====================================================================

// Headlight tower, as on E82 in the 1950s-70s: a four-leg frame on the hood end
// carrying the headlight over a number board, facing +x (outward).
// Base on z = 0, prints upright. 2 mm pin into the hood pad.
module es2_headlight_tower() {
    H = p(HL_TOWER_H); b0 = p(12); b1 = p(8); leg = 2.0; bar = 1.6;
    function lp(z) = b0 + (b1 - b0) * z / H;        // leg spacing at height z
    difference() {
        union() {
            translate([-p(7), -p(7), 0]) cube([p(14), p(14), 1.2]);               // foot plate
            for (sx = [-1, 1], sy = [-1, 1]) hull() {
                translate([sx * b0 / 2 - leg / 2, sy * b0 / 2 - leg / 2, 0]) cube([leg, leg, 0.1]);
                translate([sx * b1 / 2 - leg / 2, sy * b1 / 2 - leg / 2, H - 0.1]) cube([leg, leg, 0.1]);
            }
            for (zf = [0.5]) let(z = H * zf, w = lp(z)) {                          // braces half way up
                for (s = [-1, 1]) translate([-w / 2, s * w / 2 - bar / 2, z]) cube([w, bar, bar]);
                for (s = [-1, 1]) translate([s * w / 2 - bar / 2, -w / 2, z]) cube([bar, w, bar]);
            }
            translate([-p(7), -p(7), H]) cube([p(14), p(14), 1.6]);                // platform
            translate([p(7) - p(5), -p(9), H + 1.6]) cube([p(5), p(18), p(7)]);   // number board box, board faces +x
            translate([-p(6), -p(6), H + 1.6 + p(7)]) cube([p(11), p(12), p(11)]); // lamp housing
            translate([p(5) - 0.01, 0, H + 1.6 + p(7) + p(5.5)]) rotate([0, 90, 0]) cylinder(d = p(10), h = p(2.5), $fn = FN);
            es2_lamp_visor();
        }
        translate([p(5) + p(2.5) - 1.2, 0, H + 1.6 + p(7) + p(5.5)]) rotate([0, 90, 0]) cylinder(d = p(10) - 2, h = 2, $fn = FN);   // lens seat, 1.2 deep
        translate([p(7) - 0.4, -p(8), H + 1.6 + 1]) cube([1, p(16), p(7) - 2]);       // number board recess (decal)
        translate([0, 0, -1]) cylinder(d = 2.1, h = 4, $fn = 16);
    }
}

// White headlight lens (Tom 10/17): a small disc, print it in white (or clear and paint the back white),
// press it into the seat in the lamp. es2_headlight_lens_placed() shows it in the lamp for the preview.
lens_d = p(10) - 2 - 0.25;
module es2_headlight_lens() {
    cylinder(d = lens_d, h = 1.0, $fn = FN);
    translate([0, 0, 1.0]) scale([1, 1, 0.12]) sphere(d = lens_d, $fn = FN);      // slight dome
}
module es2_headlight_lens_placed() {
    H = p(HL_TOWER_H);
    translate([p(7.5) - 1.2, 0, H + 1.6 + p(7) + p(5.5)]) rotate([0, 90, 0]) es2_headlight_lens();
}
// visor (hood) over the lamp, part of the tower print
module es2_lamp_visor() {
    H = p(HL_TOWER_H);
    translate([p(7.5) - 0.2, 0, H + 1.6 + p(7) + p(5.5)]) rotate([0, 90, 0]) difference() {
        cylinder(d = p(10) + 1.2, h = 1.6, $fn = FN);
        translate([0, 0, -1]) cylinder(d = p(10) - 0.2, h = 4, $fn = FN);
        translate([p(1), -50, -1]) cube([50, 100, 50]);             // keep the top half (local -x is up)
    }
}

// Printed dummy coupler (knuckle look, does not open), screwed to the end-sill pad.
// Drawn in loco position for the +x end. Print it upside down: es2_print turns it over.
cz = p(COUPLER_Z);
cpl_pad_bot = esill_bot - 2.5;
cpl_face = p(OVER_COUPLERS) / 2;                    // coupler face, 41 ft 5 in over couplers
module es2_coupler() {
    x0 = frame_hx - COUPLER_PAD[0]; x1 = frame_hx;
    hz0 = cz - 4.0;                                  // head bottom; the top is flush with the mounting plate
    difference() {
        union() {
            translate([x0, -COUPLER_PAD[1] / 2 + 1, cpl_pad_bot - 3]) cube([COUPLER_PAD[0], COUPLER_PAD[1] - 2, 3]);     // mounting plate
            translate([x1 - 6, -2.75, cz - 2]) cube([cpl_face - 8 - (x1 - 6), 5.5, cpl_pad_bot - (cz - 2)]);              // shank
            translate([0, 0, hz0]) linear_extrude(cpl_pad_bot - hz0) polygon([          // knuckle head, plan view
                [cpl_face - 9, -5.5], [cpl_face - 1.5, -5.5], [cpl_face, -4], [cpl_face, -0.6],     // knuckle
                [cpl_face - 2.2, -0.6], [cpl_face - 2.2, 1.6], [cpl_face, 1.6], [cpl_face, 4.4],    // throat, guard arm
                [cpl_face - 3, 5.2], [cpl_face - 9, 5.2]]);
        }
        translate([x0 + COUPLER_PAD[0] / 2, 0, cpl_pad_bot - 5]) cylinder(d = COUPLER_SCREW + 0.3, h = 10, $fn = 16);
        translate([x0 + COUPLER_PAD[0] / 2, 0, cpl_pad_bot - 3 - 0.01]) cylinder(d = 4.2, h = 1.2, $fn = FN);   // screw head seat
    }
}
// coupler height gauge: a block to stand on the rail with a notch at the coupler centre
module es2_coupler_gauge() {
    difference() {
        cube([12, 8, cz + 8]);
        translate([-1, -1, cz - 0.4]) cube([6, 10, 0.8]);
    }
    translate([0, 8, 0]) linear_extrude(0.6) text(str(round(cz * 10) / 10), size = 3);
}

// Bell on hood 1 (MPL sheet 06), on a short pedestal; base on z = 0, prints upright
// (the bell widens downward and sits on a 45 degree cone, so no support). 2 mm pin into the hood pad.
module es2_bell() {
    d = p(14); h = p(11); col = p(5);
    difference() {
        union() {
            translate([-p(4.5), -p(4.5), 0]) cube([p(9), p(9), 1.2]);
            cylinder(d = col, h = p(8), $fn = FN);
            translate([0, 0, p(8) - (d - col) / 2]) cylinder(d1 = col, d2 = d, h = (d - col) / 2 + 0.01, $fn = FN);   // support cone
            translate([0, 0, p(8)]) cylinder(d1 = d, d2 = d * 0.55, h = h, $fn = FN);                            // bell
            translate([0, 0, p(8) + h]) cylinder(d = d * 0.3, h = p(2), $fn = 20);                                 // crown
        }
        translate([0, 0, -1]) cylinder(d = 2.1, h = 4, $fn = 16);
    }
}
