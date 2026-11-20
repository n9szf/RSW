// =====================================================================
//  rsw_truck_passenger.scad  -  RSW shared truck library, part 3
//  Milwaukee Road four-wheel passenger trucks (pt_*), moved in from
//  Passenger cars / common / mr_truck.scad on 13 Oct 2026 (TDQ-266).
//  Do not open on its own - include rsw_trucks.scad.
//
//  Styles (PT_STYLE):
//    "A-4778"  1947 equalizer truck, MPL drawing A-4778, 7'-0" wheelbase (1947-48 cars)
//    "1938"    1938 Hiawatha truck, RME March 1939 photo, 8 ft (1935-1942 cars) - BEST GUESS
//    "nystrom" the earlier best-guess cast frame
//  The six-wheel truck is still in mr_truck.scad (its centre axle sits under the bolster).
//
//  SPRUNG BOLSTER (PT_SPRUNG = true, TDQ-268 option A, the default):
//    The bolster is NOT glued. Its ends pass through a window in each sideframe and ride
//    up and down in it; a collar on each end bears on the sideframe's inner face so the
//    bolster cannot slide sideways. It rests on 4 bought steel compression springs
//    (PT_SPRING = [OD, free length], 4 x 12 mm, 0.4-0.5 mm wire - TDQ-269) standing on
//    pins on a printed spring plank, which glues across between the two sideframes.
//    The window gives PT_TRAVEL_UP / PT_TRAVEL_DOWN of movement - the frame is the stop.
//    The sideframes, end beams (or cross beams) and the spring plank are the glued frame.
//    PT_SPRUNG = false gives the old glued bolster, unchanged.
//
//  Settings a car or kit file can give before the include:
//    PT_STYLE = "A-4778";  PT_WB_FT = 7;  PT_SPRUNG = true;
//    PT_RAIL_TO_SILL_FT = 3.2;  PT_PAD_H = 6;  PT_WHEEL_D_IN = 36;
//  Origin: truck centre, z = 0 at rail top. Prototype sizes via rg_in().
// =====================================================================

pt_style   = is_undef(PT_STYLE) ? "A-4778" : PT_STYLE;
pt_wb_ft   = is_undef(PT_WB_FT) ? (pt_style == "1938" ? 8 : 7) : PT_WB_FT;
pt_sprung  = is_undef(PT_SPRUNG) ? true : PT_SPRUNG;
pt_sill_ft = is_undef(PT_RAIL_TO_SILL_FT) ? 3.2 : PT_RAIL_TO_SILL_FT;
pt_pad_h   = is_undef(PT_PAD_H) ? 6 : PT_PAD_H;          // pad under the car floor that sits on the bolster
pt_wheel_in = is_undef(PT_WHEEL_D_IN) ? 36 : PT_WHEEL_D_IN;
pt_paint   = "#1C1C1C";                                    // black trucks (Milwaukee Magazine July 1947)

PT_ZC   = rg_in(pt_wheel_in) / 2;                          // axle centre height
PT_ZTOP = rg_ft(pt_sill_ft) - pt_pad_h;                    // bolster top = under the car's pad
PT_YI   = rg_yi;                                           // sideframe inner face
PT_SF_T = rg_sf_t;
PT_TOP  = PT_ZC + rg_in(17);                               // sideframe top (nystrom)
PT_WIN  = rg_in(11.5);                                     // bolster window half-width
PT_EQ   = pt_style == "A-4778";
PT_38   = pt_style == "1938";
function pt_axles(wb) = [-wb / 2, wb / 2];
PT_WB   = rg_ft(pt_wb_ft);

PT_TOP_EQ = min(rg_in(37), rg_ft(pt_sill_ft) - 1.2);       // frame top (A-4778 and 1938), clear of the car floor

// end beams: a cross bar at each end of the frame ties the sideframes together
PT_EB_L  = rg_in(5);
PT_EB_H  = rg_in(4);
PT_EB_Z  = PT_TOP_EQ - rg_in(5);
PT_EB_IN = PT_SF_T * 0.7;                                  // how far each end goes into a sideframe
function pt_end_beam_xs(wb) = [-wb / 2 - rg_in(29.5), wb / 2 + rg_in(28)];
function pt_xbeam38_xs() = [-rg_in(21), rg_in(21)];        // 1938: cross beams between the bolster and the wheels
PT_EB_Z38 = PT_TOP_EQ - rg_in(5.5);
function pt_truck_half(wb) = pt_style == "A-4778" ? wb / 2 + rg_in(45) : wb / 2 + rg_in(20);

module pt_end_beam() {                                     // print flat; 2 per truck
    translate([-PT_EB_L / 2, -PT_YI - PT_EB_IN + 0.2, 0]) cube([PT_EB_L, 2 * (PT_YI + PT_EB_IN - 0.2), PT_EB_H]);
}

// ---------------- sprung bolster geometry ----------------
pt_travel_up   = is_undef(PT_TRAVEL_UP) ? 1.0 : PT_TRAVEL_UP;      // mm the bolster can rise (car lifted off)
pt_travel_down = is_undef(PT_TRAVEL_DOWN) ? 1.0 : PT_TRAVEL_DOWN;  // mm it can drop - needs the car floor's wheel wells (TDQ-276)
pt_spring      = is_undef(PT_SPRING) ? [4.0, 12.0] : PT_SPRING;    // bought spring: [outside diameter, free length]
PT_SPRING_LN   = 9.0;           // spring length with the bolster at ride height (3 mm squeezed by the car)
PT_SOCK        = 1.5;           // spring socket depth in the bolster underside
PT_PIN_D       = pt_spring[0] - 1.4;   // pin inside the spring (4 mm OD, 0.4-0.5 wire -> 3 mm ID)
PT_PIN_H       = 2.5;
PT_CLR         = 0.3;           // sliding clearance round the bolster ends
PT_COLLAR      = 1.2;           // collar thickness, inside the sideframe
// window in the sideframe the bolster end rides in: open between the bolster columns
PT_WIN_BOT = PT_EQ ? rg_in(18.5) : rg_in(15.5);                     // top of the equalizer / lower beam
PT_WIN_TOP = PT_EQ ? PT_TOP_EQ - rg_in(6) : PT_TOP_EQ - rg_in(7);   // underside of the top member
PT_WIN_SKIN = PT_EQ ? 0 : 0.9;  // 1938: the shock absorber sits on the outside, so the window stops 0.9 mm short (blind)
// spring plank: glued across between the sideframes, low down, clear of the rails
PT_PLANK_Z = 5.0; PT_PLANK_T = 2.0; PT_PLANK_HL = rg_in(8);         // 5 mm above the rail top
PT_SPRING_XY = [for (sx = [-1, 1], sy = [-1, 1]) [sx * (PT_PLANK_HL - pt_spring[0] / 2 - 1.2), sy * (PT_YI - PT_COLLAR - 6)]];
// bolster: flat bottom (prints bottom down), the ends' bottoms are the down stop on the window floor
PT_TEN_BOT = PT_WIN_BOT + pt_travel_down;
PT_TEN_TOP = PT_WIN_TOP - pt_travel_up - 0.15;
PT_SEAT_Z  = PT_TEN_BOT + PT_SOCK - PT_SPRING_LN;                  // spring seat (top of the boss) on the plank
assert(!pt_sprung || PT_SEAT_Z >= PT_PLANK_Z + PT_PLANK_T - 0.01,
       str("sprung bolster: no room for the springs - seat ", PT_SEAT_Z, " below plank top ", PT_PLANK_Z + PT_PLANK_T));
assert(!pt_sprung || PT_EQ || PT_38, "sprung bolster is drawn for the A-4778 and 1938 styles only");

// ---------------- sideframe outlines (X-Z plane, Z from the rail) ----------------
module pt_sideframe2d_eq(wb) {
    function q(i) = rg_in(i);
    a = wb / 2; t = PT_TOP_EQ; r = q(2);
    hull() { translate([-a - q(33) + r, t - r]) circle(r); translate([a + q(31.5) - r, t - r]) circle(r);
             translate([-a - q(33) + r, t - q(6) + r]) circle(r); translate([a + q(31.5) - r, t - q(6) + r]) circle(r); }
    for (e = [[-a - q(33), -a - q(14)], [a + q(14), a + q(31.5)]])
        hull() { translate([e[0] + r, t - q(6)]) circle(r); translate([e[1] - r, t - q(6)]) circle(r);
                 translate([(e[0] + e[1]) / 2, t - q(12)]) circle(q(3)); }
    for (sx = [-1, 1]) let(x = sx * a) {
        for (k = [-1, 1]) translate([x + k * q(7.1) + (k > 0 ? 0 : -q(3)), q(9)]) square([q(3), t - q(9) - 0.01]);
        translate([x - q(10.1), q(9)]) square([q(20.2), q(2)]);
        translate([x - q(7.1), PT_ZC - q(6)]) square([q(14.2), q(12)]);
    }
    for (sx = [-1, 1]) translate([sx * (PT_WIN + q(1.5)) - q(1.5), q(18)]) square([q(3), t - q(18) - 0.01]);
    for (sx = [-1, 1]) translate([sx > 0 ? PT_WIN + q(1.5) : -a + q(7), t - q(9)]) square([a - q(7) - PT_WIN - q(1.5), q(3.5)]);
    difference() {
        offset(r = q(4)) offset(delta = -q(4)) translate([-a + q(7), q(5)]) square([2 * (a - q(7)), q(13.5)]);
        for (sx = [-1, 1]) translate([sx * q(16), q(10)]) hull() { translate([-q(2.5), 0]) circle(q(1.8)); translate([q(2.5), 0]) circle(q(1.8)); }
    }
    for (sx = [-1, 1]) translate([sx * q(21) - q(4), q(18.5) - 0.01]) square([q(8), t - q(6) - q(18.5) + 0.02]);
}

module pt_sideframe2d_38(wb) {
    function q(i) = rg_in(i);
    a = wb / 2; t = PT_TOP_EQ; r = q(2); re = q(2.75);
    difference() {
        union() {
            hull() for (sx = [-1, 1], dz = [r, q(7) - r]) translate([sx * (a + q(10.1) - r), t - dz]) circle(r);
            for (sx = [-1, 1]) {
                x = sx * a;
                for (k = [-1, 1]) translate([x + k * q(8.6) - q(1.5), q(9)]) square([q(3), t - q(9) - 0.01]);
                translate([x - q(10.1), q(9)]) square([q(20.2), q(2)]);
                translate([x - q(7.1), PT_ZC - q(6)]) square([q(14.2), q(12)]);
            }
            hull() for (sx = [-1, 1]) { translate([sx * (a - q(18)), q(6.25)]) circle(re); translate([sx * (a - q(19)), q(12.75)]) circle(re); }
            pts = [[a - q(18), q(6.25)], [a - q(13.5), q(8.5)], [a - q(11.3), q(14)], [a - q(10.5), q(21)], [a - q(10.2), q(28)]];
            for (sx = [-1, 1]) for (k = [0:1:len(pts) - 2]) hull() {
                translate([sx * pts[k][0], pts[k][1]]) circle(re); translate([sx * pts[k + 1][0], pts[k + 1][1]]) circle(re); }
            for (sx = [-1, 1]) translate([sx * (a - q(23)) - q(5.5), q(15) - 0.01]) square([q(11), t - q(7) - q(15) + 0.02]);
            for (sx = [-1, 1]) translate([sx * (PT_WIN + q(1.25)) - q(1.25), q(13) - 0.01]) square([q(2.5), t - q(7) - q(13) + 0.02]);
        }
        for (sx = [-1, 1]) translate([sx * (a - q(17)), t - q(3.5)]) circle(d = q(3), $fn = 20);
    }
}

module pt_sideframe2d_nystrom(wb) {
    function q(i) = rg_in(i);
    xs = pt_axles(wb); hl = wb / 2 + q(20); zc = PT_ZC; r = q(1.8);
    hull() {
        translate([-hl + q(8), PT_TOP - r]) circle(r = r); translate([hl - q(8), PT_TOP - r]) circle(r = r);
        translate([-hl + r, zc + q(4)]) circle(r = r);     translate([hl - r, zc + q(4)]) circle(r = r);
        translate([-hl + q(10), PT_TOP - q(4)]) circle(r = r); translate([hl - q(10), PT_TOP - q(4)]) circle(r = r);
    }
    for (a = xs) translate([a - q(10), zc - q(8)]) square([q(20), PT_TOP - (zc - q(8)) - 0.01]);
    for (i = [0:1:len(xs) - 2]) {
        x0 = xs[i] + q(9); x1 = xs[i + 1] - q(9); xm = (x0 + x1) / 2;
        pts = [[x0, zc - q(5)], [x0 + (xm - x0) * 0.45, zc - q(10)], [xm, zc - q(11)],
               [x1 - (x1 - xm) * 0.45, zc - q(10)], [x1, zc - q(5)]];
        for (k = [0:1:len(pts) - 2]) hull() { translate(pts[k]) circle(r = q(2)); translate(pts[k + 1]) circle(r = q(2)); }
    }
    for (sx = [-1, 1]) translate([sx * (PT_WIN + q(1.5)) - q(1.5), zc - q(10)]) square([q(3), PT_TOP - zc + q(10) - 0.01]);
}

module pt_spring(h) {                                      // printed coil spring (detail), base at z = 0
    n = 5; p = h / n; rr = rg_in(1.0);
    for (k = [0:1:n - 1]) translate([0, 0, rr + k * p * (h - 2 * rr) / (h - p)])
        rotate_extrude($fn = 24) translate([rg_in(3.5), 0]) circle(r = rr, $fn = 12);
    cylinder(r = rg_in(2.8), h = h);
}

// ---------------- sideframe (the +Y one, inner face at y = PT_YI) ----------------
module pt_sideframe(wb = PT_WB) {
    $fn = 48;                                               // as mr_config.scad had it, so the outline matches the old trucks
    function q(i) = rg_in(i);
    xs = pt_axles(wb); zc = PT_ZC; eq = PT_EQ; s38 = PT_38;
    difference() {
        intersection() {                                    // nothing below the inner face - it prints face down
            translate([-500, PT_YI, -50]) cube([1000, 100, 200]);
            union() {
                translate([0, PT_YI + PT_SF_T, 0]) rotate([90, 0, 0]) linear_extrude(PT_SF_T)
                    if (eq) pt_sideframe2d_eq(wb); else if (s38) pt_sideframe2d_38(wb); else pt_sideframe2d_nystrom(wb);
                for (a = xs) {                              // journal box + roller-bearing cap
                    translate([a, PT_YI + PT_SF_T - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = q(12), h = q(2.5), $fn = 64);
                    translate([a, PT_YI + PT_SF_T + q(2.5) - 0.01, zc]) rotate([-90, 0, 0]) cylinder(d = q(9), h = q(2.2), $fn = 48);
                    translate([a, PT_YI + PT_SF_T + q(4.7) - 0.02, zc]) rotate([-90, 0, 0]) cylinder(d1 = q(9), d2 = q(7.4), h = q(0.8), $fn = 48);
                }
                if (eq) {
                    for (sx = [-1, 1])
                        translate([sx * q(21), PT_YI + PT_SF_T / 2 + 0.6, q(18.5)]) pt_spring(PT_TOP_EQ - q(6) - q(18.5));
                    translate([-wb / 2 - q(45), PT_YI + PT_SF_T / 2, PT_TOP_EQ - q(3.5)]) rotate([0, 90, 0])
                        cylinder(d = q(11), h = q(12), $fn = 32);
                    translate([-wb / 2 - q(33) - 0.01, PT_YI, PT_TOP_EQ - q(8)]) cube([q(3), PT_SF_T + q(2), q(8)]);
                    for (sx = [-1, 1]) translate([sx * q(10.5), PT_YI + PT_SF_T - 0.01, q(19)])
                        cylinder(d = q(3), h = PT_TOP_EQ - q(6) - q(19), $fn = 16);
                }
                if (s38) {
                    yo = PT_YI + PT_SF_T;
                    zs = q(17); hs = PT_TOP_EQ - q(7) - zs;
                    for (sx = [-1, 1]) translate([sx * (wb / 2 - q(23)), PT_YI + PT_SF_T / 2 + 0.6, 0]) {
                        translate([0, 0, zs]) scale([1.8, 1.8, 1]) pt_spring(hs);
                        translate([0, 0, zs - q(2.2)]) cylinder(d = q(15), h = q(2.2) + 0.01, $fn = 40);
                        translate([0, 0, zs + hs - q(1.2)]) cylinder(d = q(14), h = q(1.2), $fn = 40);
                    }
                    for (zr = [q(3.6), q(11.4)])
                        translate([-(wb / 2 - q(19)), yo - 0.01, zr]) cube([2 * (wb / 2 - q(19)), q(1.2), q(3.2)]);
                    translate([-q(8.5), yo - 0.01, q(4.5)]) cube([q(17), q(3), q(6.5)]);
                    translate([0, yo + q(2), q(10.5)]) cylinder(d = q(6), h = PT_TOP_EQ - q(5) - q(10.5), $fn = 24);
                    for (sx = [-1, 1]) {
                        translate([sx * (PT_WIN + q(1.25)), yo - 0.01, q(14.5)]) rotate([-90, 0, 0]) cylinder(d = q(5), h = q(2), $fn = 20);
                        translate([sx > 0 ? PT_WIN : -(wb / 2 - q(28.5)), yo - 0.01, q(25.5)])
                            cube([wb / 2 - q(28.5) - PT_WIN, q(1.8), q(2)]);
                    }
                    translate([-q(17), yo + q(2.2), PT_TOP_EQ - q(3.6)]) rotate([0, 90, 0]) cylinder(d = q(7), h = q(22), $fn = 32);
                    translate([q(5) - 0.01, yo + q(2.2), PT_TOP_EQ - q(3.6)]) rotate([0, 90, 0]) cylinder(d = q(2), h = q(14), $fn = 12);
                }
                if (!eq && !s38) {
                    for (sx = [-1, 1]) translate([sx * q(22), PT_YI + PT_SF_T / 2, zc - q(8)]) pt_spring(PT_TOP - q(4) - (zc - q(8)));
                    translate([-q(34), PT_YI + PT_SF_T + q(3.5), zc + q(9)]) rotate([0, 90, 0]) cylinder(d = q(8), h = q(10), $fn = 24);
                    translate([-q(34), PT_YI + PT_SF_T - 0.01, zc + q(9) - q(2)]) cube([q(10), q(3.5), q(4)]);
                    translate([-wb / 2 + q(10), PT_YI + PT_SF_T + q(3.5), zc + q(9)]) rotate([0, 90, 0])
                        cylinder(d = q(1.5), h = wb / 2 - q(10) - q(34), $fn = 10);
                }
            }
        }
        for (a = xs) translate([a, PT_YI - 0.01, zc]) rotate([-90, 0, 0]) rg_bearing_pocket();   // bearing pockets
        if (pt_sprung) {
            // window the bolster end rides in (through on the A-4778, blind behind the 1938's shock absorber)
            translate([-PT_WIN, PT_YI - 1, PT_WIN_BOT]) cube([2 * PT_WIN, PT_SF_T + 1 - PT_WIN_SKIN + (PT_WIN_SKIN == 0 ? 0.01 : 0), PT_WIN_TOP - PT_WIN_BOT]);
            // spring plank slot
            translate([-PT_PLANK_HL - 0.15, PT_YI - 1, PT_PLANK_Z - 0.15]) cube([2 * PT_PLANK_HL + 0.3, PT_EB_IN + 1, PT_PLANK_T + 0.3]);
        } else                                                                       // glued bolster tongue slot
            translate([-PT_WIN + 0.2, PT_YI - 1, PT_ZTOP - q(9) - 0.3]) cube([2 * PT_WIN - 0.4, PT_SF_T * 0.7 + 1, q(9) + 0.6]);
        if (eq) for (x = pt_end_beam_xs(wb)) translate([x - PT_EB_L / 2 - 0.15, PT_YI - 1, PT_EB_Z - 0.15])
            cube([PT_EB_L + 0.3, PT_EB_IN + 1, PT_EB_H + 0.3]);
        if (s38) for (x = pt_xbeam38_xs()) translate([x - PT_EB_L / 2 - 0.15, PT_YI - 1, PT_EB_Z38 - 0.15])
            cube([PT_EB_L + 0.3, PT_EB_IN + 1, PT_EB_H + 0.3]);
    }
}

// ---------------- bolsters ----------------
module pt_bolster_glued() {                               // the old one: tongues glue into the sideframes
    bt = rg_in(9);
    difference() {
        union() {
            translate([-rg_in(8), -PT_YI, PT_ZTOP - bt]) cube([rg_in(16), 2 * PT_YI, bt]);
            for (s = [1, -1]) scale([1, s, 1])
                translate([-PT_WIN + 0.4, PT_YI - 0.01, PT_ZTOP - rg_in(9)]) cube([2 * PT_WIN - 0.8, PT_SF_T * 0.7, rg_in(9)]);
            translate([0, 0, PT_ZTOP - 0.01]) cylinder(d = 14, h = 0.01);
        }
        translate([0, 0, PT_ZTOP - bt - 1]) cylinder(d = rg_screw_d, h = bt + 2, $fn = 20);
    }
}

// sprung bolster at ride height. Flat bottom: print bottom down.
PT_END_Y = PT_YI + PT_SF_T - PT_WIN_SKIN - (PT_WIN_SKIN > 0 ? 0.2 : 0.1);   // tip of each end (just inside the outer face)
module pt_bolster_sprung() {
    yc = PT_YI - PT_CLR;                                   // collar outer face, against the sideframe
    difference() {
        union() {
            translate([-rg_in(8), -yc, PT_TEN_BOT]) cube([rg_in(16), 2 * yc, PT_ZTOP - PT_TEN_BOT]);          // body
            for (s = [1, -1]) scale([1, s, 1]) {
                translate([-PT_WIN + PT_CLR, yc - PT_COLLAR - 0.5, PT_TEN_BOT])                              // end, through the window
                    cube([2 * (PT_WIN - PT_CLR), PT_END_Y - (yc - PT_COLLAR - 0.5), PT_TEN_TOP - PT_TEN_BOT]);
                translate([-PT_WIN - rg_in(1.5), yc - PT_COLLAR, PT_TEN_BOT])                                // collar
                    cube([2 * (PT_WIN + rg_in(1.5)), PT_COLLAR, PT_TEN_TOP - PT_TEN_BOT]);
            }
            translate([0, 0, PT_ZTOP - 0.01]) cylinder(d = 14, h = 0.01);
        }
        translate([0, 0, PT_TEN_BOT - 1]) cylinder(d = rg_screw_d, h = PT_ZTOP - PT_TEN_BOT + 2, $fn = 20);   // pivot screw
        for (p = PT_SPRING_XY) translate([p[0], p[1], PT_TEN_BOT - 0.01]) cylinder(d = pt_spring[0] + 0.6, h = PT_SOCK + 0.01, $fn = 32);   // spring sockets
    }
}
module pt_bolster() { if (pt_sprung) pt_bolster_sprung(); else pt_bolster_glued(); }

// spring plank, in place. Print flat (it is printed upside down: top face with the pins up is fine as is).
module pt_spring_plank() {
    yl = PT_YI + PT_EB_IN - 0.2;
    difference() {
        union() {
            translate([-PT_PLANK_HL, -yl, PT_PLANK_Z]) cube([2 * PT_PLANK_HL, 2 * yl, PT_PLANK_T]);
            for (p = PT_SPRING_XY) translate([p[0], p[1], PT_PLANK_Z + PT_PLANK_T - 0.01]) {
                cylinder(d = pt_spring[0] + 1.6, h = PT_SEAT_Z - PT_PLANK_Z - PT_PLANK_T + 0.01, $fn = 32);   // seat boss
                cylinder(d = PT_PIN_D, h = PT_SEAT_Z - PT_PLANK_Z - PT_PLANK_T + PT_PIN_H, $fn = 24);        // pin inside the spring
            }
        }
        translate([0, 0, PT_PLANK_Z - 1]) cylinder(d = 7, h = PT_PLANK_T + 2, $fn = 32);   // reach the pivot screw from below
    }
}

// steel spring, for the views: coil at a given length
module pt_steel_spring(len) {
    n = 7; d = 0.45; R = (pt_spring[0] - d) / 2;
    color("#9AA3AD") for (k = [0:1:n * 12 - 1]) hull() {
        a0 = k * 30; a1 = (k + 1) * 30;
        translate([R * cos(a0), R * sin(a0), d / 2 + (len - d) * k / (n * 12)]) sphere(d = d, $fn = 6);
        translate([R * cos(a1), R * sin(a1), d / 2 + (len - d) * (k + 1) / (n * 12)]) sphere(d = d, $fn = 6);
    }
}

// ---------------- whole truck ----------------
module pt_frame_parts(wb = PT_WB) {
    for (s = [1, -1]) scale([1, s, 1]) pt_sideframe(wb);
    pt_bolster();
    if (PT_EQ) for (x = pt_end_beam_xs(wb)) translate([x, 0, PT_EB_Z]) pt_end_beam();
    if (PT_38) for (x = pt_xbeam38_xs()) translate([x, 0, PT_EB_Z38]) pt_end_beam();
    if (pt_sprung) pt_spring_plank();
}
module pt_assembly(wheels = true) {
    color(pt_paint) pt_frame_parts();
    if (pt_sprung) for (p = PT_SPRING_XY) translate([p[0], p[1], PT_SEAT_Z]) pt_steel_spring(PT_SPRING_LN);
    if (wheels) for (a = pt_axles(PT_WB)) translate([a, 0, PT_ZC]) rg_wheelset(rg_in(pt_wheel_in));
}

// ---------------- print layouts ----------------
module pt_part(part = "assembly") {
    echo(str("Passenger truck ", pt_style, ", ", pt_wb_ft, " ft wheelbase (", round(PT_WB), " mm), ",
             pt_sprung ? "SPRUNG bolster" : "glued bolster", ", 1:", rg_scale));
    echo(str("Buy per car: ", rg_buy_text(2), pt_sprung ? str("; 8 compression springs ", pt_spring[0], " mm OD x ",
             pt_spring[1], " mm long, 0.4-0.5 mm wire") : ""));
    if (pt_sprung) echo(str("Bolster travel: up ", pt_travel_up, " mm, down ", pt_travel_down, " mm; springs ", PT_SPRING_LN,
             " mm long at ride height (", pt_spring[1] - PT_SPRING_LN, " mm squeezed)"));
    if (part == "assembly")        { pt_assembly(); rg_track(PT_WB + 80); }
    else if (part == "sideframe")  translate([0, 0, -PT_YI]) rotate([90, 0, 0]) pt_sideframe();      // 2 per truck, inner face down
    else if (part == "bolster")    translate([0, 0, pt_sprung ? -PT_TEN_BOT : -(PT_ZTOP - rg_in(9))]) pt_bolster();   // 1 per truck, flat
    else if (part == "end_beam")   pt_end_beam();                                                     // 2 per truck, flat
    else if (part == "spring_plank" && pt_sprung) translate([0, 0, -PT_PLANK_Z]) pt_spring_plank();   // 1 per truck, flat
    else if (part == "wheel")      rg_wheel(rg_in(pt_wheel_in));                                       // 4 per truck, flange face down
    else if (part == "bearing_coupon") rg_bearing_coupon();
    else if (part == "section")    // cut through the truck centre, to check the springs and stops
        intersection() { pt_assembly(false); translate([-1, -100, -10]) cube([2, 200, 100]); }
}
