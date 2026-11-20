// =====================================================================
//  Milwaukee Road EF-1 boxcab (GE 1915, C.M.&St.P. 10100 class)
//  G scale 1:29  -  one half-unit (2-B-B).  Print twice for the A+B pair.
//  CAB UNIT (lead A / C unit), UNPOWERED, on printed trucks (Tom 10/26).
//
//  v3 (26 Oct 2026): ERA 1950-1973 (Tom 10/26), from Holley, The Milwaukee Electrics (1999):
//  four slot louvres per door leaf (E50B), ladder grabs on both cab-door posts full height
//  (10200A, E23B, E25B), weather visors over the cab side windows, side number boards at the
//  eave (E50B), bell + horn print for lead units (E23C), coil- or leaf-spring pilot truck
//  (E23C caption), maroon / orange / black preview paint (1963, E42ACB).
//  v2 (20 Oct 2026): screw mounts and joints as the RSW ES-2 v8 and the passenger cars -
//  M2.5 x 8 self-tappers up through the deck into 8 mm body bosses, frame sections on
//  2 mm brass rods, ISO 7379 shoulder-bolt truck pivots with nylon lock nuts, separate
//  pinned steps, M2 coupler screw, 1.25 mm wire holes, 6.3 mm magnet pockets.
//  v1 was the native parametric OpenSCAD port of boxcab.py.
//
//  v4 (26 Oct 2026): PRINTED, UNPOWERED TRUCKS as the ES-2 (Tom 10/26) - two GE bar-frame driving
//  trucks (52 in drivers, 10 ft 9 in wheelbase, leaf springs over the boxes, cosmetic traction motors)
//  and a pilot truck (36 in wheels, coil or leaf springs), F683ZZ bearings in the sideframes, 3 mm
//  brass axles, printed wheels, all from the shared RSW running gear
//  (../../../Trucks/library/rsw_running_gear.scad - keep this file in its RSW folder).
//  Cab unit for now: the lead (A or C) unit with headlight, bell, horn and plow.
//
//  HARDWARE PER CAB UNIT (v4)
//   - 6 axles: 3 mm brass rod cut to 65.3 mm (rg_axle_len); 12 F683ZZ flanged bearings; 12 printed wheels
//   - 16 M2.5 x 8 self-tapping screws: body to deck, up from under the deck (8 stations x 2 sides)
//   - 8 x 2 mm brass rod, 100 mm: frame joints (4 per joint, 50 mm into each section)
//   - 3 shoulder bolts 4 x 16 mm, M3 thread (ISO 7379) + 3 M3 nylon lock nuts (DIN 985): 2 truck + 1 pilot
//     pivot. Drop the bolt in from the deck top BEFORE the body goes on; run the nut up against the end
//     of the shoulder - the truck must swivel freely.
//   - 1 M2 self-tapper: coupler to its pad (truck bolsters are glued into the sideframe slots)
//   - 32 disc magnets 6 x 3 mm (16 body + 16 roof);  1 mm brass wire: grabs, roof railings, platform rail, 4 step pins
//   - 1 M3 screw + nut per pair: drawbar
//  ORDER: print bearing_coupon first and check the F683 fit -> rods into frame sections + glue ->
//  bodies screwed down -> trucks (wheels pressed on at 40.5 mm back-to-back, bearings into the
//  pockets, bolster tabs into the slots, glue) -> shoulder bolts down from the deck top -> nuts up
//  to the shoulder (trucks must swivel freely) -> steps pinned on.
//  Use the Customizer (Window > Customizer) to pick a part and change
//  parameters, then F6 render + F7 export STL.
//  OpenSCAD 2021.01+ works; a 2024+ build with the Manifold backend
//  (Preferences > Advanced > 3D Rendering: Manifold) renders MUCH faster,
//  especially with rivets on.
//
//  Coordinates: author values are PROTOTYPE INCHES converted with I().
//    x = along unit, 0 = drawbar pivot, + toward the cab end
//    y = across, 0 = centreline;  z = above top of rail
// =====================================================================

/* [Part to show / export] */
// Pick "assembly" to view, or a single part (already in print orientation)
part = "assembly"; // [assembly, exploded, body_1, body_2, body_3, roof_1, roof_2, roof_3, frame_1, frame_2, frame_3, drive_truck, pilot_truck, bearing_coupon, headlight, pantograph, drawbar, step, bell_horn]
// Rivet detail (slow to render in old CGAL builds)
rivets = true;
// Show wheels, axles, bearings, pivot bolts and track in assembly views
show_wheels = true;
// Show the road number on the side number boards (preview only)
show_lettering = true;

/* [Era 1950-1973 details] */
// Pilot truck springs: "coil" = newer trucks, "leaf" = old trucks (both ran in the 1950s, E23C)
PILOT_SPRINGS = "coil"; // [coil, leaf]
// Road number shown on the preview number boards (not printed)
ROAD_NO = "E50B";
// Paint in the preview: maroon below this height (prototype inches above rail), orange above (ESTIMATE)
PAINT_LINE = 116;

/* [Scale & printer] */
SCALE = 29;             // 1:29 G scale
WALL = 2.4;             // body wall thickness
MAG = 6.3;              // round pocket for 6 x 3 mm disc magnets (as ES-2 MAGNET)
MAG_D = 3.2;            // magnet pocket depth
WIRE = 1.25;            // hole for 1 mm brass wire grabs / railings (as ES-2 RAIL_HOLE)

/* [Screw mounts - as the ES-2 v8 and the passenger cars] */
// Body sections screwed down: M2.5 x 8 self-tapping screws up through the deck into bosses
BODY_BOSS = 8.0;        // boss width, mm
BODY_BOSS_H = 12.0;     // boss height, mm (45 degree top against the wall)
BODY_PILOT = 2.2;       // pilot hole, M2.5 self-tapping
BODY_CLEAR_D = 2.9;     // clearance hole in the deck
BODY_HEAD_D = 5.2;      // counterbore for the head, from under the deck
BODY_HEAD_LEFT = 1.6;   // deck left above the counterbore
// Frame sections joined by 2 mm brass rods, half the rod in each section
JOIN_ROD = [2.0, 100, 2.2];         // rod dia, rod length, hole dia (mm)
JOIN_ROD_Y = [-38, -18, 18, 38];    // rod positions across the frame (mm) - clear of the pivots and body screws
// Truck pivots: ISO 7379 shoulder bolt dropped in from the deck top, M3 nylon lock nut (DIN 985) under the truck
PIVOT_BOLT = [4.0, 16, 7.0, 3.0];   // shoulder dia, shoulder length, head dia, head height (mm)
PIVOT_FIT = [4.15, 4.3, 7.6];       // hole in the frame (snug), hole in the truck bolster (turns), head counterbore
PIVOT_PLAY = 0.3;       // shoulder ends this far below the truck bolster, so the nut clamps the shoulder, not the truck
PIVOT_GAP = 0.3;        // truck bolster to frame boss
PIVOT_NUT = [5.5, 4.0]; // M3 nylon lock nut (DIN 985): across flats, height
TRUCK_BOLSTER_T = 12;   // printed driving-truck bolster thickness (the bolt passes through it)
PILOT_BOLSTER_T = 10;   // printed pilot-truck bolster thickness
// Steps printed separately (ES-2 v8: printed-on steps broke) and pinned up with 1 mm wire
STEP_PIN = 1.25;
// Coupler on its pad: M2 self-tapping screw
COUPLER_SCREW = 2.0;

/* [Printed trucks / running gear] */
TRUCK_BOSS_Z = 59.7;    // bottom of the frame bolster over each driving truck (6 mm under the deck, as the ES-2)
PILOT_BOSS_Z = 40.0;    // top of the pilot-truck bolster above rail
COUPLER_PAD_Z = 35.5;   // underside of coupler pad above rail (Kadee G ~35-36)
DRAWBAR_PIN_OUT = 8.0;  // drawbar pin distance outside the body end
DRIVE_WB = 112.97;      // driving truck wheelbase, 10 ft 9 in (GE drawing)
DRIVE_WHEEL_D = 45.54;  // 52 in drivers
PILOT_WB = 63.06;       // pilot truck wheelbase, 6 ft (GE drawing)
PILOT_WHEEL_D = 31.53;  // 36 in wheels

/* [Hidden] */
// shared RSW running gear: wheels, 3 mm brass axles, F683ZZ bearings (same as the ES-2 and the cars)
RG_SCALE = "G";
include <../../../Trucks/library/rsw_running_gear.scad>
function I(v) = v * 25.4 / SCALE;       // prototype inches -> model mm
eps = 0.01;

// ---------------- prototype layout (inches)
XB0 = 11;  XB1 = 636;          // body ends (drawbar end, cab end)
HW = 60;                       // half width of body (10'-0")
ZB = 81;   ZE = 150;           // body bottom (on deck), eave
CUTS = [160, 404];             // body / roof joints
FCUTS = [220, 440];            // frame joints
WIN4 = [[72, 105], [504, 534], [579, 609]];     // 4-pane windows
LDOORS = [[208, 258], [278, 328], [347, 396]];  // louvred doors
LOUVRE_Z = [93, 104, 115, 126];                 // slot centres, 4 per door leaf (E50B photo, ESTIMATE spacing)
CAB_WIN = [WIN4[1], WIN4[2]];
SIDE_NB_X = 303;                                // side number board centre (over door bay 2, E50B photo)                   // cab side windows that get weather visors
LADDER_Z = [88, 98, 108, 118, 128, 138];        // cab-end ladder rungs on both door posts (10200A, E23B)
CREW = [419, 445];                              // crew door
MAGX = [20, 140, 180, 268, 337, 470, 560, 622]; // magnet / boss stations
TRUCKS = [127, 388];           // drive truck centres
PILOT_X = 580;                 // pilot truck centre
X_DECK1 = 657;                 // front of end platform / pilot beam
BODY_ENDS = [XB0, CUTS[0], CUTS[1], XB1];
RX0 = XB0 - 2;  RX1 = XB1 + 2;  RHW = HW + 1.5;
ROOF_ENDS = [RX0, CUTS[0], CUTS[1], RX1];
FRAME_ENDS = [-100, FCUTS[0], FCUTS[1], 800];
ARC_R = (RHW * RHW + 100) / 20;
ARC_ZC = 166 - ARC_R;
function roof_z(y) = ARC_ZC + sqrt(ARC_R * ARC_R - y * y);

W = I(HW);
yin = W - WALL - 4.5;          // centre of the magnet corbels (mm)
yscr = W - WALL - BODY_BOSS / 2; // centre of the body screw bosses (mm)
deck_top = I(81);  deck_bot = I(75);
// shoulder-bolt pivots (ES-2 v8): the shoulder runs from under the head down through the frame boss and the
// truck bolster and stops PIVOT_PLAY below it; the head sits in a counterbore from the deck top (under the body)
function pivot_head_z(boss_bot, bolster_t) = boss_bot - PIVOT_GAP - bolster_t - PIVOT_PLAY + PIVOT_BOLT[1];
drive_head_z = pivot_head_z(TRUCK_BOSS_Z, TRUCK_BOLSTER_T);
pilot_head_z = pivot_head_z(PILOT_BOSS_Z + PIVOT_GAP, PILOT_BOLSTER_T);
assert(drive_head_z > TRUCK_BOSS_Z + 1, "drive pivot: shoulder bolt too long for the frame boss - use a shorter one");
assert(drive_head_z + PIVOT_BOLT[3] <= deck_top, "drive pivot: bolt head would stand above the deck - use a longer shoulder");
assert(pilot_head_z > PILOT_BOSS_Z + PIVOT_GAP + 1, "pilot pivot: shoulder bolt too long - use a shorter one");
assert(pilot_head_z + PIVOT_BOLT[3] <= deck_top, "pilot pivot: bolt head would stand above the deck - use a longer shoulder");
function magx(mx) = min(max(I(mx), I(XB0) + WALL + 4.5), I(XB1) - WALL - 4.5);

// ---------------- helpers
// box from corner coords in mm (any order)
module B(x0, x1, y0, y1, z0, z1)
    translate([min(x0, x1), min(y0, y1), min(z0, z1)])
        cube([abs(x1 - x0), abs(y1 - y0), abs(z1 - z0)]);
// same, prototype inches
module Bi(x0, x1, y0, y1, z0, z1) B(I(x0), I(x1), I(y0), I(y1), I(z0), I(z1));
module cyl_x(y, z, r, x0, x1, fn = 24) translate([x0, y, z]) rotate([0, 90, 0]) cylinder(r = r, h = x1 - x0, $fn = fn);
module cyl_y(x, z, r, y0, y1, fn = 24) translate([x, y0, z]) rotate([-90, 0, 0]) cylinder(r = r, h = y1 - y0, $fn = fn);
module cyl_z(x, y, r, z0, z1, fn = 24) translate([x, y, z0]) cylinder(r = r, h = z1 - z0, $fn = fn);
// square hole of side d through a box region
module sqhole(x, y, d, z0, z1) B(x - d / 2, x + d / 2, y - d / 2, y + d / 2, z0, z1);
// round rod between two points
// round vertical hole
module zhole(x, y, d, z0, z1, fn = 20) translate([x, y, z0]) cylinder(d = d, h = z1 - z0, $fn = fn);
module rod(p0, p1, d) hull() { translate(p0) sphere(d = d, $fn = 10); translate(p1) sphere(d = d, $fn = 10); }

// =====================================================================
//  BODY SHELL
// =====================================================================
module body_adds() {
    out = 0.6;
    difference() {
        Bi(XB0, XB1, -HW, HW, ZB, ZE);
        B(I(XB0) + WALL, I(XB1) - WALL, -W + WALL, W - WALL, I(ZB) - 1, I(ZE) + 1);
    }
    for (s = [1, -1]) {
        yo = s * W;
        for (w = WIN4)   B(I(w[0]), I(w[1]), yo + s * out, yo - s * eps, I(117), I(148));
        for (d = LDOORS) B(I(d[0] + 2), I(d[1] - 2), yo + s * out, yo - s * eps, I(136), I(149));
    }
    // cab end window frames
    for (s = [1, -1]) B(I(XB1) - eps, I(XB1) + out, I(s * 19), I(s * 49), I(117), I(146));
}

module body_cuts() {
    for (s = [1, -1]) {
        yo = s * W;
        ya = yo + s * 2;  yb = yo - s * (WALL + 1);     // through-wall range
        ra = yo + s * 1;  rb = yo - s * 0.5;            // 0.5 mm recess
        ga = yo + s * 1;  gb = yo - s * 1.8;            // louvre slots (dark, 0.6 mm wall left behind)
        for (w = WIN4) B(I(w[0] + 3), I(w[1] - 3), ya, yb, I(120), I(145));
        for (d = LDOORS) {
            a = d[0]; b = d[1]; m = (a + b) / 2;
            B(I(a + 4), I(b - 4), ya, yb, I(138), I(147));
            for (l = [[a + 1.5, m - 0.6], [m + 0.6, b - 1.5]]) {
                B(I(l[0]), I(l[1]), ra, rb, I(83), I(134));
                for (z = LOUVRE_Z) B(I(l[0] + 3), I(l[1] - 3), ga, gb, I(z - 1.75), I(z + 1.75));   // 4 slot louvres per leaf (E50B)
            }
        }
        // crew door
        B(I(CREW[0]), I(CREW[1]), ra, rb, I(83), I(147));
        B(I(CREW[0] + 4), I(CREW[1] - 4), ya, yb, I(124), I(143));
        for (g = [[CREW[0] - 4, 95], [CREW[0] - 4, 135], [CREW[1] + 4, 95], [CREW[1] + 4, 135], [CREW[1] - 3, 108],
                  [XB0 + 5, 95], [XB0 + 5, 135]])
            B(I(g[0]) - WIRE / 2, I(g[0]) + WIRE / 2, ya, yb, I(g[1]) - WIRE / 2, I(g[1]) + WIRE / 2);
    }
    // cab end
    xo = I(XB1); xa = xo - WALL - 1; xb = xo + 2;
    for (s = [1, -1]) B(xa, xb, I(s * 21), I(s * 47), I(119), I(144));
    B(xo - 0.5, xb, I(-14), I(14), I(83), I(147));     // door recess
    B(xa, xb, I(-9), I(9), I(122), I(143));            // door window
    cab_holes = concat([for (s = [1, -1]) for (yy = [15.5, 20]) for (z = LADDER_Z) [s * yy, z]],   // rung staples, both door posts
                       [for (s = [1, -1]) for (z = [95, 135]) [s * 56, z]]);                          // corner grabs
    for (h = cab_holes) B(xa, xb, I(h[0]) - WIRE / 2, I(h[0]) + WIRE / 2, I(h[1]) - WIRE / 2, I(h[1]) + WIRE / 2);
    // drawbar end
    xo2 = I(XB0);
    B(xo2 - 2, xo2 + 0.5, I(-13), I(13), I(83), I(147));
    B(xo2 - 2, xo2 + WALL + 1, I(-8), I(8), I(122), I(143));
    for (s = [1, -1]) for (z = [95, 135])
        B(xo2 - 2, xo2 + WALL + 1, I(s * 17) - WIRE / 2, I(s * 17) + WIRE / 2, I(z) - WIRE / 2, I(z) + WIRE / 2);
}

module body_mullions() {
    for (s = [1, -1]) {
        yo = s * W;
        ma = s * (W - WALL);  mb = yo - s * 0.8;
        for (w = WIN4) {
            m = (w[0] + w[1]) / 2;
            B(I(m - 0.8), I(m + 0.8), ma, mb, I(120), I(145));
            B(I(w[0] + 3), I(w[1] - 3), ma, mb, I(131.7), I(133.3));
        }
        for (d = LDOORS) {
            m = (d[0] + d[1]) / 2;
            B(I(m - 0.8), I(m + 0.8), ma, mb, I(138), I(147));
        }
    }
}

// internal magnet corbels (top) and screw bosses (bottom)
module body_blocks() {
    zt = I(ZE); zb = I(ZB);
    for (mx = MAGX) for (s = [1, -1]) {
        x = magx(mx);  yw = s * (W - WALL);
        B(x - 4.5, x + 4.5, yw, yw - s * 9, zt - 6, zt);
        for (k = [0 : 3]) {
            w = [7, 5, 3, 1][k];
            B(x - 4.5, x + 4.5, yw, yw - s * w, zt - 6 - 2 * (k + 1), zt - 6 - 2 * k);
        }
        // screw boss (ES-2 / passenger-car size), 45 degree top against the wall
        hull() {
            B(x - BODY_BOSS / 2, x + BODY_BOSS / 2, yw, yw - s * BODY_BOSS, zb, zb + BODY_BOSS_H - BODY_BOSS);
            B(x - BODY_BOSS / 2, x + BODY_BOSS / 2, yw, yw - s * 0.01, zb, zb + BODY_BOSS_H);
        }
    }
}
module body_block_holes() {
    zt = I(ZE); zb = I(ZB);
    for (mx = MAGX) for (s = [1, -1]) {
        x = magx(mx);
        zhole(x, s * yin, MAG, zt - MAG_D, zt + 1, 32);                          // magnet pocket
        zhole(x, s * yscr, BODY_PILOT, zb - 1, zb + BODY_BOSS_H - BODY_BOSS + 3);  // M2.5 pilot
    }
}

module body_full() {
    difference() {
        union() {
            difference() { body_adds(); body_cuts(); }
            body_mullions();
            body_blocks();
            for (w = CAB_WIN) for (sd = [1, -1]) cab_visor(w[0] - 1, w[1] + 1, sd);
        }
        body_block_holes();
    }
}

// weather visor over a cab side window (1950s photos: E50B, E25B). 45 degree underside so it prints upright.
module cab_visor(x0, x1, sd) {
    pts = [[I(HW) - 0.01, I(150)], [I(HW + 3), I(150)], [I(HW + 3), I(149.2)], [I(HW) - 0.01, I(146.2)]];
    scale([1, sd, 1]) multmatrix([[0, 0, 1, I(x0)], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = I(x1 - x0)) polygon(pts);
}

// rivets as [x_in, kind, a, b]  kind 0 = side rivet (a=z_in, b=side), 1 = cab-end rivet (a=y_in, b=z_in)
BLOCKED = concat([for (w = WIN4) [w[0] - 2, w[1] + 2]], [for (d = LDOORS) [d[0] - 1, d[1] + 1]], [[CREW[0] - 6, CREW[1] + 6]]);
function rfree(x) = len([for (b = BLOCKED) if (x >= b[0] && x <= b[1]) 1]) == 0;
RIVETS = concat(
    [for (s = [1, -1]) for (x = [XB0 + 4 : 7 : XB1 - 3.01]) if (rfree(x)) for (z = [84, 149]) [x, 0, z, s]],
    [for (s = [1, -1]) for (x = [45, 140, 268, 337, 470, 560]) for (z = [91 : 7 : 144]) [x, 0, z, s]],
    [for (y = [-56 : 7 : 56]) for (z = [84, 149]) if (!(abs(y) < 16 && z < 148)) [XB1, 1, y, z]]);

module rivet(rv) {
    rr = 0.45; h = 0.4;     // 0.9 x 0.4 mm heads, as the ES-2
    if (rv[1] == 0) {
        s = rv[3];
        cyl_y(I(rv[0]), I(rv[2]), rr, min(s * (W - 0.2), s * (W + h)), max(s * (W - 0.2), s * (W + h)), 10);
    } else
        cyl_x(I(rv[2]), I(rv[3]), rr, I(XB1) - 0.2, I(XB1) + h, 10);
}

module collar(xc, dir) {
    zc0 = I(ZB) + 10; zc1 = I(ZE) - 16;
    L = 7; t = 1.6; clr = 0.25; yi = W - WALL;
    own = dir > 0 ? [xc - L, xc] : [xc, xc + L];
    pro = dir > 0 ? [xc, xc + L] : [xc - L, xc];
    for (s = [1, -1]) {
        B(own[0], own[1], s * yi, s * (yi - clr - t), zc0, zc1);
        B(pro[0], pro[1], s * (yi - clr), s * (yi - clr - t), zc0, zc1);
    }
}

// k = 0 (drawbar end), 1 (middle), 2 (cab end)
module body_section(k) {
    a = BODY_ENDS[k]; b = BODY_ENDS[k + 1];
    intersection() {
        body_full();
        B(I(a), I(b), -100, 100, -1, 300);
    }
    // bottom cross-ties so a section with no end wall prints as one rigid piece (sits on the deck)
    if (k == 1) for (xt = [I(a) + 12, I(b) - 12])
        B(xt - 1.5, xt + 1.5, -(W - WALL) - 0.01, W - WALL + 0.01, I(ZB), I(ZB) + 6);
    if (k == 0) collar(I(b), 1);
    if (k == 2) collar(I(a), -1);
    if (rivets) for (rv = RIVETS) if (rv[0] > a + 1 && rv[0] < b - 1) rivet(rv);
}

// =====================================================================
//  ROOF
// =====================================================================
module roof_rect() {
    zt = I(ZE);
    difference() {
        union() {
            Bi(RX0, RX1, -RHW, RHW, ZE, 155);                       // base slab
            Bi(40, 470, -22, 22, 163, 172);                         // equipment housing
            for (h = [[188, 210], [278, 302], [378, 400]]) {        // hatches
                Bi(h[0], h[1], -16, 16, 171, 177);
                Bi(h[0] - 1, h[1] + 1, -17, 17, 177, 178.2);
            }
            Bi(495, 585, -30, 30, 162, 168);                        // pantograph platform
            Bi(620, 636, -10, 10, 164, 170);                        // headlight block
            for (sd = [1, -1]) Bi(SIDE_NB_X - 15, SIDE_NB_X + 15, sd * (RHW - 2.5), sd * RHW, 154, 163);   // side number boards (E50B)
            for (sx = [30, 90, 150, 215, 270, 330, 390, 450, 520, 600]) for (s = [1, -1])
                Bi(sx - 2.3, sx + 2.3, s * 34 - 2.3, s * 34 + 2.3, 161.5, 166.5);   // stanchion pads
        }
        for (mx = MAGX) for (s = [1, -1])
            zhole(magx(mx), s * yin, MAG, zt - 1, zt + MAG_D, 32);  // magnet pockets
        for (sd = [1, -1]) B(I(SIDE_NB_X - 13.5), I(SIDE_NB_X + 13.5), sd * I(RHW) - sd * 0.4, sd * (I(RHW) + 1), I(155.5), I(161.5));   // decal recess
        for (x = [46 : 14 : 456]) for (s = [1, -1])                // housing side vents
            B(I(x), I(x + 9), s * I(22) + s * 0.5, s * I(22) - s * 0.6, I(166), I(170));
        for (sx = [30, 90, 150, 215, 270, 330, 390, 450, 520, 600]) for (s = [1, -1])
            sqhole(I(sx), I(s * 34), WIRE, I(166.5) - 2.5, I(166.5) + 1);
    }
}

module roof_arch(x0, x1) {
    pts = concat([[I(-RHW), I(154)], [I(RHW), I(154)]],
                 [for (i = [0 : 40]) let(y = RHW - 2 * RHW * i / 40) [I(y), I(roof_z(y))]]);
    // local x -> global y, local y -> global z, extrusion (local z) -> global x
    multmatrix([[0, 0, 1, x0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = x1 - x0) polygon(pts);
}

module roof_section(k) {
    a = ROOF_ENDS[k]; b = ROOF_ENDS[k + 1];
    intersection() { roof_rect(); B(I(a), I(b), -100, 100, -1, 300); }
    roof_arch(I(a), I(b));
}

// =====================================================================
//  FRAME / UNDERFRAME
// =====================================================================
DH = HW + 1;
// steps (stirrups) at the cab-end corners: separate prints, pinned up into the deck (ES-2 v8)
STEP_LEGS_X = [637.5, 646.5];            // leg centres, prototype inches
step_y = I(DH) - 2;                      // leg plane, mm off the centre line
STEP_TREADS_Z = [40, 57];                // tread heights, prototype inches
rod_hx = JOIN_ROD[1] / 2 + 0.5;          // rod pocket depth in each section
rod_z = deck_bot - 0.6;

module frame_adds() {
    xp = I(XB0) - DRAWBAR_PIN_OUT;
    Bi(XB0, X_DECK1, -DH, DH, 75, ZB);                       // deck
    B(xp - 7, I(XB0) + 1, -10, 10, I(75), I(ZB));            // drawbar tongue
    for (tx = TRUCKS) B(I(tx) - 7, I(tx) + 7, -7, 7, TRUCK_BOSS_Z, I(75));            // truck bosses (frame bolsters)
    B(I(PILOT_X) - 6, I(PILOT_X) + 6, -6, 6, PILOT_BOSS_Z + PIVOT_GAP, I(75));        // pilot boss
    Bi(647, X_DECK1, -56, 56, 44, 75);                       // pilot beam
    B(I(640), I(X_DECK1), I(-9), I(9), COUPLER_PAD_Z, I(75)); // coupler pad
    for (s = [1, -1]) Bi(512, 588, s * 30, s * 46, 70, 75);  // air reservoir saddles
    // ribs under the deck for the joining rods
    for (fc = FCUTS) for (y = JOIN_ROD_Y)
        B(I(fc) - rod_hx - 2, I(fc) + rod_hx + 2, y - 2.5, y + 2.5, deck_bot - 3, deck_bot + 0.01);
}
module frame_cuts() {
    xp = I(XB0) - DRAWBAR_PIN_OUT;
    zhole(xp, 0, 3.4, -1, 200);                              // drawbar pin (M3)
    // truck pivots: shoulder bolt from the deck top, head in a counterbore under the body
    for (tx = TRUCKS) {
        x = I(tx);
        zhole(x, 0, PIVOT_FIT[0], TRUCK_BOSS_Z - 1, deck_top + 1, 24);
        zhole(x, 0, PIVOT_FIT[2], drive_head_z, deck_top + 1, 32);
    }
    zhole(I(PILOT_X), 0, PIVOT_FIT[0], PILOT_BOSS_Z - 1, deck_top + 1, 24);
    zhole(I(PILOT_X), 0, PIVOT_FIT[2], pilot_head_z, deck_top + 1, 32);
    // body screws: M2.5 up through the deck, head in a counterbore underneath
    for (mx = MAGX) for (s = [1, -1]) {
        xx = magx(mx); yc = s * yscr;
        zhole(xx, yc, BODY_CLEAR_D, -1, deck_top + 1);
        zhole(xx, yc, BODY_HEAD_D, -1, deck_top - BODY_HEAD_LEFT, 24);
    }
    // joining rods
    for (fc = FCUTS) for (y = JOIN_ROD_Y)
        translate([I(fc), y, rod_z]) rotate([0, 90, 0]) cylinder(d = JOIN_ROD[2], h = 2 * rod_hx, center = true, $fn = 16);
    // step pins
    for (s = [1, -1]) for (lx = STEP_LEGS_X) zhole(I(lx), s * step_y, STEP_PIN, deck_bot - 1, deck_bot + 4, 12);
    zhole(I(649), 0, COUPLER_SCREW * 0.85, COUPLER_PAD_Z - 1, COUPLER_PAD_Z + 8, 16);   // M2 coupler screw
    for (h = [[642, 58], [654, 58], [654, 22], [642, -58], [654, -58], [654, -22], [600, 59], [560, 59], [600, -59], [560, -59]])
        zhole(I(h[0]), I(h[1]), WIRE, I(ZB) - 3, I(ZB) + 1, 12);
}

// one step: two legs and two treads, local frame: leg tops at z = 0 (against the deck), legs at x = 0 and x = Ls
module step() {
    Ls = I(STEP_LEGS_X[1] - STEP_LEGS_X[0]);
    H = deck_bot - I(STEP_TREADS_Z[0]);
    t = 2.0; th = 2.4; td = 8;           // leg width, leg thickness, tread depth (inward)
    difference() {
        union() {
            for (x = [0, Ls]) B(x - t / 2, x + t / 2, 0, th, -H, 0);                       // legs
            for (z = STEP_TREADS_Z) B(-t / 2 - 0.6, Ls + t / 2 + 0.6, 0, td, I(z) - deck_bot, I(z) - deck_bot + 1.8);  // treads
        }
        for (x = [0, Ls]) translate([x, th / 2, -4]) cylinder(d = STEP_PIN, h = 5, $fn = 12);   // pin holes
    }
}
module steps_placed() for (s = [1, -1])
    translate([I(STEP_LEGS_X[0]), s * step_y, deck_bot]) scale([1, s > 0 ? -1 : 1, 1]) translate([0, -2.4 / 2, 0]) step();

// sloped steel plate pilot (two cheeks + lower centre so the coupler clears)
function pilot_poly(zmax) = let(top = 44, bot = 6, zt = min(top, zmax),
                                ff = 657 + (670 - 657) * (top - zt) / (top - bot),
                                fb = 647 + (651 - 647) * (top - zt) / (top - bot))
    let(zt2 = zt >= top ? top + 1.5 : zt)     // full-height plates run up into the pilot beam so they fuse
    [[I(fb), I(zt2)], [I(ff), I(zt2)], [I(670), I(bot)], [I(651), I(bot)]];
module pilot_plate(y0, y1, zmax)
    translate([0, I(y1), 0]) rotate([90, 0, 0]) linear_extrude(height = I(y1 - y0)) polygon(pilot_poly(zmax));

module frame_section(k) {
    a = FRAME_ENDS[k]; b = FRAME_ENDS[k + 1];
    intersection() {
        difference() { frame_adds(); frame_cuts(); }
        B(I(a), I(b), -100, 100, -100, 300);
    }
    if (550 > a && 550 < b) for (s = [1, -1]) {                   // air reservoirs + straps
        cyl_x(I(s * 38), I(65), I(11), I(508), I(592), 32);
        for (sx = [522, 578]) cyl_x(I(s * 38), I(65), I(11.6), I(sx - 1.2), I(sx + 1.2), 32);
    }
    if (660 > a && 660 < b) {
        pilot_plate(-50, -10, 44);
        pilot_plate(10, 50, 44);
        pilot_plate(-10.5, 10.5, 22);
    }
    if (rivets) for (x = [XB0 + 3 : 7 : X_DECK1 - 2.01]) if (x > a && x < b) for (s = [1, -1])
        cyl_y(I(x), I(78), 0.5, min(s * (I(DH) - 0.2), s * (I(DH) + 0.4)), max(s * (I(DH) - 0.2), s * (I(DH) + 0.4)), 10);
}

// =====================================================================
//  ROOF DETAILS
// =====================================================================
// headlight + number boards; local, z = 0 glued to roof block, +x = toward cab end
module headlight() {
    difference() {
        union() {
            Bi(-6, 6, -9, 9, 0, 1.5);
            Bi(-2, 2, -18, 18, 1.5, 8);
            Bi(-6, 6, -22, 22, 8, 9.5);
            Bi(-5, 6, -7, 7, 9.5, 23.5);        // lamp housing
            Bi(-3, 3, -3, 3, 23.5, 25.5);
            for (s = [1, -1]) Bi(0, 2.5, s * 7, s * 21, 9.5, 16.5);   // number boards
        }
        for (s = [1, -1]) B(I(2.5) - 0.4, I(3), I(s * 8), I(s * 20), I(10.5), I(15.5));
    }
    zc = I(16.5);
    cyl_x(0, zc, I(5.2), I(6) - 0.1, I(6.6), 32);                 // lens
    translate([I(6) - 0.1, 0, zc]) rotate([0, 90, 0])            // rim ring
        difference() { cylinder(r = I(7.0), h = 1.0, $fn = 32); translate([0, 0, -1]) cylinder(r = I(4.8), h = 3, $fn = 32); }
}

// bell and horn for a lead unit (E23C caption: headlight, horn, bell and snowplow pilot). ESTIMATE sizes.
// Local: z = 0 on the roof; bell at x = 0, horn at y = -HORN_Y. Glue at x = 604 in, either side of the headlight.
HORN_Y = 24;
module bell_horn() {
    // bell in a yoke
    Bi(-5, 5, -4, 4, 0, 1.5);
    for (sy = [-3.5, 2.5]) Bi(-1, 1, sy, sy + 1, 1.5, 12);
    cyl_y(0, I(11), I(0.8), I(-3.5), I(3.5), 12);
    translate([0, 0, I(3)]) cylinder(r1 = I(5.5), r2 = I(3.2), h = I(7), $fn = 32);
    translate([0, 0, I(10)]) cylinder(r = I(1.2), h = I(1.2), $fn = 16);
    // single-chime horn on a short stand, bell mouth forward (+x)
    translate([0, I(-HORN_Y), 0]) {
        Bi(-3, 3, -2, 2, 0, 1.5);
        Bi(-1, 1, -1, 1, 1.5, 6);
        translate([I(-3), 0, I(7)]) rotate([0, 90, 0]) cylinder(r1 = I(1.2), r2 = I(3), h = I(10), $fn = 24);
        translate([I(-4), 0, I(7)]) rotate([0, 90, 0]) cylinder(r = I(1.5), h = I(2), $fn = 16);
        Bi(-4, -2, -1, 1, 5.5, 7);
    }
}

// static folded diamond pantograph; local, z = 0 on platform top
module pantograph() {
    for (sx = [-35, 35]) for (sy = [-24, 24]) {
        cyl_z(I(sx), I(sy), I(2.8), 0, I(6), 16);
        cyl_z(I(sx), I(sy), I(3.6), I(1.5), I(2.3), 16);        // insulator sheds
        cyl_z(I(sx), I(sy), I(3.6), I(3.5), I(4.3), 16);
    }
    for (sy = [-24, 24]) Bi(-42, 42, sy - 1.5, sy + 1.5, 6, 9);
    for (sx = [-35, 35, -30, 30]) Bi(sx - 1.5, sx + 1.5, -24, 24, 6, 9);
    for (sx = [-30, 30]) cyl_y(I(sx), I(10), I(1.8), I(-24), I(24), 12);   // pivot shafts
    for (sy = [-20, 20]) for (g = [-1, 1]) {
        rod([I(g * 30), I(sy), I(10)], [I(g * 60), I(sy), I(13)], I(2.2));   // lower arms
        rod([I(g * 60), I(sy), I(13)], [0, I(sy), I(17)], I(1.8));           // upper arms
    }
    for (g = [-1, 1]) cyl_y(I(g * 60), I(13), I(1.3), I(-21), I(21), 10);  // knee tubes
    Bi(-4, 4, -40, 40, 17, 19);                                               // pan head
    Bi(-1, 1, -20, 20, 15, 17);
    for (s = [1, -1]) hull() {                                                // horns
        translate([0, I(s * 40), I(18)]) cube([I(6), I(1.5), I(1.5)], center = true);
        translate([0, I(s * 46), I(13)]) cube([I(6), I(1.5), I(1.5)], center = true);
    }
}

// =====================================================================
//  RUNNING GEAR - PRINTED, UNPOWERED (Tom 10/26), built like the ES-2 trucks:
//  printed sideframes with F683ZZ bearing pockets on the inner face, a bolster whose tabs drop
//  into slots in the sideframes (glued), cosmetic traction motors and brake cylinder on the
//  bolster, printed wheels on 3 mm brass axles. Wheels, axles, bearings and the pocket come from
//  the shared RSW running gear (Trucks / library / rsw_running_gear.scad).
//  Truck frame: x = 0 truck centre, z = 0 rail top, sideframe inner face at y = +/- rg_yi.
//  Per cab unit: 2 driving trucks (52 in drivers, 10 ft 9 in wheelbase, GE drawing) and
//  1 pilot truck (36 in wheels, 6 ft wheelbase). EF-1 is 2-B+B per half (Holley, wheel arrangements).
// =====================================================================
tk_yi  = rg_yi;                      // sideframe inner face
tk_yo  = tk_yi + rg_sf_t;
tk_tab = 2;                          // bolster tab into the sideframe slot
tk_box_out = 3.5;                    // journal box proud of the frame

// one truck's numbers: [half wheelbase, wheel dia, bolster top z, bolster thickness, frame end past axle]
function tk_geom(kind) = kind == "drive"
    ? [DRIVE_WB / 2, DRIVE_WHEEL_D, TRUCK_BOSS_Z - PIVOT_GAP, TRUCK_BOLSTER_T, I(25)]
    : [PILOT_WB / 2, PILOT_WHEEL_D, PILOT_BOSS_Z, PILOT_BOLSTER_T, I(14)];

// sideframe profile in the x-z plane: GE bar frame with pedestal jaws, journal boxes, top chord,
// lower tie bar, equalizer dropped between the boxes, centre column carrying the bolster
module tk_sideframe_2d(kind) {
    g = tk_geom(kind); h = g[0]; a = g[1] / 2; btop = g[2]; bt = g[3]; endx = h + g[4];
    bx = I(kind == "drive" ? 9 : 7);          // journal box half length (6 x 11 / 5 x 9 journals, ESTIMATE)
    bz = [a - I(kind == "drive" ? 9 : 7), a + I(kind == "drive" ? 10 : 8)];
    chord = [bz[1], bz[1] + (kind == "drive" ? 4.5 : 3.5)];
    tie = [a - 0.6 * a, a - 0.6 * a + 3];
    eq0 = max(1.5, tie[0] - 6.5);                               // equalizer never below 1.5 mm above the rail
    eq = [eq0, min(eq0 + 3, tie[0] - 0.5)];
    col = kind == "drive" ? I(11) : I(9);
    offset(r = 0.05) offset(delta = -0.05) offset(delta = 0.05) union() {
        for (s = [-1, 1]) {
            translate([s * h - bx, bz[0]]) square([2 * bx, bz[1] - bz[0]]);                      // box
            for (j = [-1, 1]) translate([s * h + j * (bx + 0.8) - 0.8, bz[0] - 1.5])                // pedestal jaws
                square([1.6, chord[0] - bz[0] + 1.5]);
            translate([s * h - bx - 1.6, bz[0] - 2.5]) square([2 * bx + 3.2, 1.2]);                // pedestal binder
            translate([s * h - 1, eq[1] - 0.01]) square([2, bz[0] - eq[1] + 0.02]);                // hanger, box to equalizer
            hull() {                                                                                // frame end, dropping past the wheel
                translate([s * endx - (s > 0 ? 10 : 0), chord[0]]) square([10, chord[1] - chord[0]]);
                translate([s * (endx - 2) - 1.5, a - 1]) square([3, 3]);
            }
        }
        translate([-endx, chord[0]]) square([2 * endx, chord[1] - chord[0]]);                   // top chord
        translate([-h + bx, tie[0]]) square([2 * (h - bx), tie[1] - tie[0]]);                    // lower tie bar
        translate([-col, tie[0]]) square([2 * col, btop - bt - 0.2 - tie[0] + bt * 0.6]);         // centre column up into the bolster
        hull() {                                                                                    // equalizer, dropped in the middle
            translate([-h - 3, eq[0] + 1]) square([6, eq[1] - eq[0]]);
            translate([-h / 2, eq[0]]) square([h, eq[1] - eq[0]]);
            translate([h - 3, eq[0] + 1]) square([6, eq[1] - eq[0]]);
        }
    }
}
// one sideframe, +y side, inner face at y = tk_yi
module tk_sideframe(kind) {
    g = tk_geom(kind); h = g[0]; a = g[1] / 2; btop = g[2]; bt = g[3];
    bx = I(kind == "drive" ? 9 : 7);
    bz = [a - I(kind == "drive" ? 9 : 7), a + I(kind == "drive" ? 10 : 8)];
    chord_top = bz[1] + (kind == "drive" ? 4.5 : 3.5);
    difference() {
        union() {
            translate([0, tk_yi, 0]) rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(rg_sf_t) tk_sideframe_2d(kind);
            for (s = [-1, 1]) {
                translate([s * h - bx, tk_yi, bz[0]]) cube([2 * bx, rg_sf_t + tk_box_out, bz[1] - bz[0]]);              // journal box
                translate([s * h - bx + 1, tk_yo + tk_box_out - 0.01, bz[0] + 1]) cube([2 * bx - 2, 0.6, bz[1] - bz[0] - 3]);   // lid
                translate([s * h, tk_yo + tk_box_out - 0.5, bz[1] - 2.2]) rotate([0, 90, 0]) cylinder(d = 2.2, h = 5, center = true, $fn = 16);   // hinge lug
                if (kind == "drive") {
                    // leaf spring over each journal box, above the driver tops (GE drawing), with its hangers
                    zs = a + 22.5;
                    for (i = [0 : 4]) { ln = [14, 19, 24, 29, 34][i];
                        translate([s * h - ln / 2, tk_yi, zs + 1.1 * i]) cube([ln, rg_sf_t, 1.1]); }
                    translate([s * h - 2.5, tk_yi, zs - 1]) cube([5, rg_sf_t + 0.6, 7.5]);                // spring band
                    translate([s * h - 1.5, tk_yi, chord_top - 0.01]) cube([3, rg_sf_t, zs - chord_top + 0.02]);   // spring post on the frame
                    for (d = [-1, 1]) translate([s * h + d * 17.5 - 0.9, tk_yi, chord_top - 0.01]) cube([1.8, rg_sf_t - 0.5, zs + 5.5 - chord_top]);   // hangers
                }
            }
            if (kind == "pilot") {                                                                      // pilot-truck bolster springs
                if (PILOT_SPRINGS == "coil")
                    for (i = [0 : 3]) for (xs = [-I(5), I(5)])
                        translate([xs - 2.5, tk_yo - 0.01, a - 5 + 3.5 * i]) cube([5, 1.2, 2]);
                else {
                    for (i = [0 : 4]) { ln = [10, 14, 18, 22, 26][i];
                        translate([-ln / 2, tk_yo - 0.01, a - 4 + 1.6 * i]) cube([ln, 1.2, 1.6]); }
                    translate([-2, tk_yo - 0.01, a - 5]) cube([4, 1.8, 9.5]);
                }
            }
        }
        for (s = [-1, 1]) translate([s * h, tk_yi - 0.01, a]) rotate([-90, 0, 0]) rg_bearing_pocket();             // F683 pockets
        translate([-I(kind == "drive" ? 7 : 6) - 0.2, tk_yi - 0.01, btop - bt - 0.2]) cube([2 * I(kind == "drive" ? 7 : 6) + 0.4, tk_tab + 0.2, 50]);   // bolster slot, open at the top
        for (s = [-1, 1]) translate([s * h - bx - 1, tk_yo + tk_box_out - 0.5, bz[0] + 2.5]) cube([2 * bx + 2, 1.2, 0.5]);   // box lid line
    }
}
// bolster: tabs into the sideframe slots, shoulder-bolt hole; the drive bolster carries the cosmetic
// traction motors (nose-hung between the axles) and a brake cylinder
module tk_bolster(kind) {
    g = tk_geom(kind); h = g[0]; a = g[1] / 2; btop = g[2]; bt = g[3];
    hx = I(kind == "drive" ? 7 : 6);
    my = rg_b2b / 2 - 2;                                      // motors stop 2 mm inside the wheel backs
    difference() {
        union() {
            translate([-hx, -tk_yi - tk_tab, btop - bt]) cube([2 * hx, 2 * (tk_yi + tk_tab), bt]);
            if (kind == "drive") {
                translate([-hx - I(12) + 1, 0, btop - bt - 1]) rotate([0, 90, 0]) cylinder(d = I(10), h = I(12), $fn = 32);   // brake cylinder (ESTIMATE)
                mx = h - g[1] / 2 - 9.5; mr = 8.5; mz = a + 2;       // motor between the axle and the bolster, clear of the wheels
                for (s = [-1, 1]) {
                    translate([s * mx, 0, mz]) rotate([90, 0, 0]) cylinder(r = mr, h = 2 * my, center = true, $fn = 8);
                    for (e = [-1, 1]) translate([s * mx, e * (my - 1), mz]) rotate([90, 0, 0]) cylinder(r = mr - 1.4, h = 2.4, center = true, $fn = 32);
                    hull() {                                          // nose lug up to the bolster
                        translate([s * mx - 3, -my + 3, mz + mr - 2]) cube([6, 2 * my - 6, 1]);
                        translate([s * (hx - 0.5) - (s > 0 ? 0 : 1), -my + 3, btop - bt]) cube([1, 2 * my - 6, 0.6]);
                    }
                }
            }
        }
        translate([0, 0, btop - 60]) cylinder(d = PIVOT_FIT[1], h = 80, $fn = 24);     // shoulder bolt turns in this hole
    }
}
module tk_wheel(kind) rg_wheel(tk_geom(kind)[1]);
module tk_truck(kind, show_wheels = true) {
    g = tk_geom(kind);
    tk_sideframe(kind);
    mirror([0, 1, 0]) tk_sideframe(kind);
    tk_bolster(kind);
    if (show_wheels) for (s = [-1, 1]) translate([s * g[0], 0, g[1] / 2]) rg_wheelset(g[1], tk_yi);
}
// one print per truck: 2 sideframes (inner face down), the bolster (top down), 4 wheels (flange face down)
module tk_truck_plate(kind) {
    g = tk_geom(kind); d = kind == "drive";
    sf_gap = d ? 53 : 39;                      // sideframes lie inner face down, one behind the other
    W = g[1] + 8;                              // wheel pitch on the plate
    for (i = [0, 1]) translate([0, -i * sf_gap, -tk_yi]) rotate([90, 0, 0]) tk_sideframe(kind);
    translate([d ? -45 : -30, d ? 40 : 35, g[2]]) rotate([180, 0, 0]) tk_bolster(kind);   // top down
    for (i = [0, 1], j = [0, 1]) translate([(d ? 20 : 15) + i * W, (d ? 31 : 22) + j * W, 0]) tk_wheel(kind);   // flange face down
}

module drawbar() difference() {
    B(-6, 36, -6, 6, 0, 3);
    zhole(0, 0, 3.4, -1, 4);
    hull() { zhole(8, 0, 3.4, -1, 4); zhole(30, 0, 3.4, -1, 4); }   // slot
}


// =====================================================================
//  ASSEMBLY & PRINT LAYOUT
// =====================================================================
// shoulder bolts + nylon lock nuts at the three pivots (preview only)
module pivot_hardware() {
    for (pv = [[I(TRUCKS[0]), drive_head_z], [I(TRUCKS[1]), drive_head_z], [I(PILOT_X), pilot_head_z]]) translate([pv[0], 0, 0]) {
        hz = pv[1];
        translate([0, 0, hz]) cylinder(d = PIVOT_BOLT[2], h = PIVOT_BOLT[3], $fn = 24);
        translate([0, 0, hz - PIVOT_BOLT[1]]) cylinder(d = PIVOT_BOLT[0], h = PIVOT_BOLT[1], $fn = 20);
        translate([0, 0, hz - PIVOT_BOLT[1] - 4.5]) cylinder(d = 3, h = 4.5, $fn = 16);
        translate([0, 0, hz - PIVOT_BOLT[1] - PIVOT_NUT[1]]) cylinder(d = PIVOT_NUT[0] / cos(30), h = PIVOT_NUT[1], $fn = 6);
    }
}

module assembly(ex = 0) {
    orange = [0.9, 0.42, 0.12]; maroon = [0.36, 0.1, 0.09]; dark = [0.13, 0.13, 0.13];   // 1963: maroon, orange and black
    for (k = [0 : 2]) translate([0, 0, ex]) {
        color(maroon) intersection() { body_section(k); B(-100, 700, -100, 100, -1, I(PAINT_LINE)); }
        color(orange) intersection() { body_section(k); B(-100, 700, -100, 100, I(PAINT_LINE), 300); }
    }
    for (k = [0 : 2]) {
        color(dark) translate([0, 0, 1.7 * ex]) roof_section(k);
        color(dark) frame_section(k);
    }
    color(dark) steps_placed();
    if (show_wheels) color([0.75, 0.75, 0.78]) pivot_hardware();
    color(dark) translate([I(628), 0, I(170) + 1.7 * ex]) headlight();
    color(dark) translate([I(540), 0, I(168) + 1.7 * ex]) pantograph();
    color(dark) translate([I(604), I(14), I(166) + 1.7 * ex]) bell_horn();
    if (show_lettering) color("white") for (sd = [1, -1])      // road number on the side boards (preview only)
        translate([I(SIDE_NB_X), sd * (I(RHW) + 0.05), I(158.5) + 1.7 * ex]) rotate([90, 0, sd > 0 ? 180 : 0])
            linear_extrude(0.1) text(ROAD_NO, size = I(4.5), halign = "center", valign = "center");
    for (tx = TRUCKS) translate([I(tx), 0, 0]) { color(dark) tk_truck("drive", false); if (show_wheels) for (s = [-1, 1]) translate([s * DRIVE_WB / 2, 0, DRIVE_WHEEL_D / 2]) rg_wheelset(DRIVE_WHEEL_D, tk_yi); }
    translate([I(PILOT_X), 0, 0]) { color(dark) tk_truck("pilot", false); if (show_wheels) for (s = [-1, 1]) translate([s * PILOT_WB / 2, 0, PILOT_WHEEL_D / 2]) rg_wheelset(PILOT_WHEEL_D, tk_yi); }
    if (show_wheels) color("#8C8C8C") translate([I(330), 0, 0]) rg_track(700);
}

// single parts, in print orientation, centred near the origin, sitting on z = 0
module print_part(p) {
    k = p == "body_1" || p == "roof_1" || p == "frame_1" ? 0 :
        p == "body_2" || p == "roof_2" || p == "frame_2" ? 1 : 2;
    if (p == "body_1" || p == "body_2" || p == "body_3")
        translate([-I(BODY_ENDS[k] + BODY_ENDS[k + 1]) / 2, 0, -I(ZB)]) body_section(k);
    else if (p == "roof_1" || p == "roof_2" || p == "roof_3")
        translate([-I(ROOF_ENDS[k] + ROOF_ENDS[k + 1]) / 2, 0, -I(ZE)]) roof_section(k);
    else if (p == "frame_1" || p == "frame_2" || p == "frame_3")    // upside down: deck top on the bed
        translate([-I(max(FRAME_ENDS[k], 0) + min(FRAME_ENDS[k + 1], X_DECK1 + 13)) / 2, 0, I(ZB)])
            rotate([180, 0, 0]) frame_section(k);
    else if (p == "drive_truck") tk_truck_plate("drive");                        // print 2: sideframes, bolster + motors, 4 wheels
    else if (p == "pilot_truck") tk_truck_plate("pilot");                        // print 1
    else if (p == "bearing_coupon") rg_bearing_coupon();                         // test the F683 fit first
    else if (p == "headlight") headlight();
    else if (p == "pantograph") pantograph();                                     // needs supports
    else if (p == "bell_horn") bell_horn();                                       // lead units only
    else if (p == "drawbar") drawbar();
    else if (p == "step") rotate([90, 0, 0]) step();                              // print 2 per unit, flat
}

if (part == "assembly") assembly(0);
else if (part == "exploded") assembly(45);
else print_part(part);
