// =====================================================================
//  rsw_truck_bettendorf.scad  -  RSW shared truck library, part 2
//  Printed Bettendorf-style freight / caboose truck (1930s cast frame).
//  First used under the Milwaukee Road 1939 rib side caboose.
//
//  Do not open on its own - include rsw_trucks.scad.
//
//  SHAPE IS A BEST GUESS, drawn by eye (TDQ-192): 5'-6" wheelbase,
//  33" wheels. No drawing or photo of the caboose's own trucks yet.
//
//  Per truck: 2 sideframes + 1 bolster (glued), 4 printed wheels,
//  2 brass axles, 4 bearings, 1 pivot screw.
//
//  Settings a car can give before the include (prototype inches unless noted):
//      BT_WB_IN       = 66;    // wheelbase
//      BT_WHEEL_D     = mm;    // tread diameter in mm (default: 33", 29 mm in G)
//      BT_BOLSTER_TOP = mm;    // rail top to top of bolster, mm, where the car rests
//                              //   (default: 22 mm in G, 13.3 mm in O)
//  Origin: truck centre, z = 0 at the rail top, x along the track.
// =====================================================================

bt_wb        = is_undef(BT_WB_IN) ? rg_in(66) : rg_in(BT_WB_IN);
bt_wheel_d   = is_undef(BT_WHEEL_D) ? rg_mm(29) : BT_WHEEL_D;           // 33" wheels (29 mm in G)
bt_bolster_h = is_undef(BT_BOLSTER_TOP) ? rg_mm(22) : BT_BOLSTER_TOP;   // 22 mm in G, scaled for O

bt_top_in    = 27.5;          // inches above rail: top of the sideframe        ESTIMATE
bt_end_in    = 7.5;           // inches the frame runs past each axle            ESTIMATE
bt_bolster_d = rg_mm(8);      // bolster depth (top to underside)
bt_bolster_l = rg_in(12);     // bolster size along the track
bt_tongue    = rg_mm(2.4);    // how far each bolster end goes into a sideframe
bt_plate_d   = rg_mm(16);     // centre plate diameter
bt_paint     = "#1E1E1E";

bt_zc  = bt_wheel_d / 2;      // axle centre above the rail
bt_win = rg_in(8);            // bolster tongue half-width

// side view outline (x along the track, y up from the rail), one piece
module bt_sideframe2d() {
    h  = bt_wb / 2;
    zt = rg_in(bt_top_in);
    e  = rg_in(bt_end_in);
    function q(i) = rg_in(i);
    difference() {
        polygon([
            [-h - e, q(10.5)], [-h - e, q(22.5)], [-h + q(4), q(23.5)], [-q(15), zt],
            [ q(15), zt], [ h - q(4), q(23.5)], [ h + e, q(22.5)], [ h + e, q(10.5)],
            [ h - q(6), q(10.5)], [ q(14), q(6)], [-q(14), q(6)], [-h + q(6), q(10.5)]]);
        // the open triangle between the column and the pedestal, each side
        for (s = [1, -1]) scale([s, 1])
            polygon([[q(12.5), q(10.6)], [q(12.5), q(23.8)], [h - q(8), q(20.3)], [h - q(8), q(14.4)]]);
    }
}

// the +Y sideframe in place: inner face at y = rg_yi, detail on the outside
module bt_sideframe() {
    function q(i) = rg_in(i);
    h  = bt_wb / 2;
    yo = rg_yi + rg_sf_t;              // outer face of the frame
    yf = yo - rg_mm(1.0);              // floor of the recessed bolster window
    zb = bt_bolster_h;
    difference() {
        union() {
            translate([0, yo, 0]) rotate([90, 0, 0]) linear_extrude(rg_sf_t) bt_sideframe2d();
            for (a = [-h, h]) {
                // journal box: a square box with a sloping lid
                translate([a - q(4.5), yo - 0.01, bt_zc - q(5)]) cube([q(9), q(3.2), q(10.5)]);
                translate([a - q(4), yo + q(3.2) - 0.02, bt_zc - q(4.5)]) hull() {
                    cube([q(8), 0.01, q(9.5)]);
                    translate([q(0.5), q(1.3), q(0.3)]) cube([q(7), 0.01, q(7.5)]);
                }
            }
            translate([-q(8.5), yo - 0.01, q(8.3)]) cube([q(17), q(2.4), q(1.7)]);   // spring seat lip
        }
        // bolster window, recessed (not through - the bolster tongue slot is behind it)
        translate([-q(8.5), yf, q(10)]) cube([q(17), rg_mm(1.0) + 0.01, q(14)]);
        // bearing pockets
        for (a = [-h, h]) translate([a, rg_yi - 0.01, bt_zc]) rotate([-90, 0, 0]) rg_bearing_pocket();
        // slot for the bolster tongue
        translate([-bt_win, rg_yi - 1, zb - bt_bolster_d - 0.15]) cube([2 * bt_win, bt_tongue + 1.2, bt_bolster_d + 0.3]);
    }
    // in the window: the bolster end, and two coil springs standing on the spring seat
    translate([-q(7), yf - 0.01, zb - q(6.5)]) cube([q(14), rg_mm(1.0) + q(1.0), q(6)]);
    for (sx = [-1, 1]) translate([sx * q(3.7), yf + rg_mm(0.3), q(10)])
        for (k = [0 : 4]) translate([0, 0, q(0.9) + k * q(1.5)])
            rotate_extrude($fn = 24) translate([q(2.0), 0]) circle(r = q(0.9), $fn = 10);
}

// beam between the two sideframes; its ends glue into the sideframe slots.
// The car's bolster pad sits on the centre plate; the pivot screw goes up
// through the hole into the pilot hole in the car's underframe.
module bt_bolster() {
    zb = bt_bolster_h;
    difference() {
        union() {
            translate([-bt_bolster_l / 2, -rg_yi, zb - bt_bolster_d]) cube([bt_bolster_l, 2 * rg_yi, bt_bolster_d]);
            for (s = [1, -1]) scale([1, s, 1])
                translate([-bt_win + 0.2, rg_yi - 0.01, zb - bt_bolster_d]) cube([2 * bt_win - 0.4, bt_tongue - 0.2, bt_bolster_d]);
            translate([0, 0, zb - bt_bolster_d]) cylinder(d = bt_plate_d, h = bt_bolster_d, $fn = 48);   // centre plate
        }
        translate([0, 0, zb - bt_bolster_d - 1]) cylinder(d = rg_screw_d, h = bt_bolster_d + 2, $fn = 24);
    }
}

module bt_frame() { for (s = [1, -1]) scale([1, s, 1]) bt_sideframe(); bt_bolster(); }
module bt_assembly(wheels = true) {
    color(bt_paint) bt_frame();
    if (wheels) for (a = [-bt_wb / 2, bt_wb / 2]) translate([a, 0, bt_zc]) rg_wheelset(bt_wheel_d);
}

// print layouts (what the STLs hold)
module bt_sideframe_print() { translate([0, 0, -rg_yi]) rotate([90, 0, 0]) bt_sideframe(); }   // inner face down
module bt_bolster_print()   { translate([0, 0, -(bt_bolster_h - bt_bolster_d)]) bt_bolster(); } // flat
module bt_wheel_print()     { rg_wheel(bt_wheel_d); }                                            // flange face down

// wall left round the bearing pocket inside the frame, for the echo check
bt_pocket_wall = min(bt_zc - rg_pocket_d / 2 - rg_in(10.5), rg_in(22.5) - bt_zc - rg_pocket_d / 2);

module bt_part(part = "truck") {
    echo(str("Bettendorf truck, ", rg_scale_name, " scale 1:", rg_scale, ": wheelbase ", round(bt_wb * 10) / 10,
             " mm, wheels ", round(bt_wheel_d * 10) / 10, " mm, bolster top ", round(bt_bolster_h * 10) / 10, " mm above rail"));
    echo(str("Buy per car: ", rg_buy_text(2)));
    if (bt_pocket_wall < 0.6) echo(str("WARNING: only ", round(bt_pocket_wall * 100) / 100, " mm of frame round the bearing pocket"));
    if (part == "truck_sideframe")     bt_sideframe_print();   // print 4 per car
    else if (part == "truck_bolster")  bt_bolster_print();     // print 2 per car
    else if (part == "truck_wheel")    bt_wheel_print();       // print 8 per car
    else if (part == "bearing_coupon") rg_bearing_coupon();    // print 1 first
    else { bt_assembly(); rg_track(bt_wb + rg_mm(60)); }        // "truck": to look at
}
