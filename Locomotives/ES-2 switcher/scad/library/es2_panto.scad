// =====================================================================
//  es2_panto.scad  -  the pantograph, for the preview and the Blender
//  pictures only (Tom 10/17: "add the pantograph but this will not be
//  part of the print" - it is bought, TDQ-304).
//  GE diamond pantograph of the 1915-1920 Milwaukee electrics (GE PRACTICE):
//  a base frame on the four roof insulators, lower and upper arms making a
//  diamond in side view, springs at the base, and a pan shoe with horns.
//  PAN_RAISE: 0 locked down, 1 up at the wire. Roof frame: x = 0 roof middle,
//  z = 0 on the insulator tops.
// =====================================================================

module tube(a, b, d) hull() { translate(a) sphere(d = d, $fn = 12); translate(b) sphere(d = d, $fn = 12); }

pan_arm   = p(50);                    // ESTIMATE arm length (4 ft 2 in)
pan_hmin  = p(14);                    // locked down
pan_hmax  = 2 * pan_arm * 0.94;       // fully up
pan_shaft = p(16);                    // the two base shafts each side of the middle
pan_shoe_w = p(78);                   // pan shoe across the loco
module es2_pantograph(raise = PAN_RAISE) {
    h = pan_hmin + raise * (pan_hmax - pan_hmin);
    k = pan_shaft + sqrt(max(1, pan_arm * pan_arm - (h / 2) * (h / 2)));    // knee, out along x
    yb = pan_w / 2; yk = pan_w / 2 * 0.8; yt = pan_w / 2 * 0.45; d = 1.2;
    // base frame on the insulators, with the two shafts across
    for (sy = [-1, 1]) tube([-pan_l / 2, sy * yb, 1], [pan_l / 2, sy * yb, 1], 1.8);
    for (sx = [-1, 1]) tube([sx * pan_l / 2, -yb, 1], [sx * pan_l / 2, yb, 1], 1.8);
    for (sx = [-1, 1]) tube([sx * pan_shaft, -yb, 2.2], [sx * pan_shaft, yb, 2.2], 1.6);
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * pan_l / 2, sy * yb, 0]) cylinder(d = 3.2, h = 1.8, $fn = 16);   // feet
    // springs from the shafts to the frame ends
    for (sx = [-1, 1], sy = [-1, 1]) tube([sx * pan_shaft, sy * yb * 0.6, 3], [sx * (pan_l / 2 - 3), sy * yb * 0.6, 2.5], 2.2);
    // the diamond: shaft -> knee (lower arm), knee -> top (upper arm), each side
    for (sx = [-1, 1], sy = [-1, 1]) {
        tube([sx * pan_shaft, sy * yb * 0.9, 2.2], [sx * k, sy * yk, 2.2 + h / 2], d + 0.4);
        tube([sx * k, sy * yk, 2.2 + h / 2], [sx * pan_shaft * 0.5, sy * yt, 2.2 + h], d);
    }
    for (sx = [-1, 1]) tube([sx * k, -yk, 2.2 + h / 2], [sx * k, yk, 2.2 + h / 2], d);      // knee ties
    // pan shoe: two bars across, with horns curving down at the ends
    for (sx = [-1, 1]) {
        tube([sx * p(5), -pan_shoe_w / 2, 2.8 + h], [sx * p(5), pan_shoe_w / 2, 2.8 + h], 1.6);
        for (sy = [-1, 1]) tube([sx * p(5), sy * pan_shoe_w / 2, 2.8 + h], [sx * p(3), sy * (pan_shoe_w / 2 + p(10)), 2.8 + h - p(8)], 1.4);
    }
    for (sy = [-1, 1]) tube([-pan_shaft * 0.5, sy * yt, 2.2 + h], [pan_shaft * 0.5, sy * yt, 2.2 + h], 1.2);
    for (sy = [-1, 1]) tube([-p(5), sy * yt, 2.2 + h], [p(5), sy * yt, 2.8 + h], 1.2);
}
// on the loco
module es2_pantograph_placed() translate([0, 0, deck_z + eave_z + ins_top]) es2_pantograph();
