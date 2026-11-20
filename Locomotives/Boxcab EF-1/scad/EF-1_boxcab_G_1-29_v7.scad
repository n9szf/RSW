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
//  v7 (15 Nov 2026): front end (Tom 11/15: footboards, end platform, corner steps). PILOT_STYLE picks
//  the snowplow pilot or a footboard pilot: switchmen's footboards either side of the coupler (separate
//  print, pinned under the pilot beam) with wire grab irons in the beam face. End platform deck, plate
//  and pilot beam get rounded front corners (brass photo), cast stanchion bases at the railing holes and a
//  toe angle along the front edge. Corner steps redrawn as a ladder: flat-bar stringers, open-grate treads
//  with a turned-up nosing, and a grab-iron hole pair in each stringer.
//  v6 (13 Nov 2026): trucks - EF-1 driving-truck sideframes redrawn from the GE drawing (deep bar
//  frame, pedestal jaws, big openings, centre bolster casting with struts, 52 in leaf springs on
//  hangers over the drivers, articulation lug / fork at the frame ends, rivets), separate brake beams
//  with shoes outboard of each axle, sand-pipe holes (1 mm wire), spoked drivers (WHEEL_STYLE_DRIVE),
//  speedometer drive on the pilot truck. The driving truck now prints as two plates.
//  v5 (12 Nov 2026): from Tom's brass-model reference photo - box visor on the cab-end window only,
//  diamond-plate end platform (separate thin print) and three-tread corner steps, roof-edge
//  diamond-plate strips, full-length roof handrails on printed posts (1 mm wire), roof boxes of mixed
//  sizes (some off centre) instead of one long housing, pantograph moved to just behind the cab-end
//  hood and shown raised in the preview (PAN_RAISE), bell and horn beside the headlight.
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
part = "assembly"; // [assembly, exploded, body_1, body_2, body_3, roof_1, roof_2, roof_3, frame_1, frame_2, frame_3, drive_truck_frames, drive_truck_running, pilot_truck, bearing_coupon, headlight, pantograph, drawbar, step, footboard, bell_horn, end_platform]
// Rivet detail (slow to render in old CGAL builds)
rivets = true;
// Show wheels, axles, bearings, pivot bolts and track in assembly views
show_wheels = true;
// Show the road number on the side number boards (preview only)
show_lettering = true;

/* [Era 1950-1973 details] */
// Pilot truck springs: "coil" = newer trucks, "leaf" = old trucks (both ran in the 1950s, E23C)
PILOT_SPRINGS = "coil"; // [coil, leaf]
// Front pilot: "plow" = sloped snowplow plate (lead units in winter), "footboard" = switchmen's footboards
PILOT_STYLE = "plow"; // [plow, footboard]
// Pantograph height in the preview: 0 = locked down, 1 = up to the wire (prints are always down)
PAN_RAISE = 0.6; // [0:0.05:1]
// Diamond-plate texture on the roof-edge strips (slower to render)
ROOF_TREAD = true;
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
WHEEL_STYLE_DRIVE = "spoked"; // [spoked, disc]
WHEEL_STYLE_PILOT = "disc";   // [disc, spoked]
SPOKES_DRIVE = 16;      // spokes on the 52 in drivers (ESTIMATE)
SPOKES_PILOT = 10;      // spokes on the 36 in pilot wheels, if spoked
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
CAB_WIN = [WIN4[2]];                            // cab-end side window gets the box visor (brass photo)
SIDE_NB_X = 303;                                // side number board centre (over door bay 2, E50B photo)
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
    pts = [[I(HW) - 0.01, I(150)], [I(HW + 5), I(150)], [I(HW + 5), I(148.4)], [I(HW + 4.4), I(148.4)], [I(HW) - 0.01, I(144)]];   // box hood, 45 deg under
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
            for (b = ROOF_BOXES) {                                  // roof equipment boxes with lids (brass photo, ESTIMATE)
                Bi(b[0], b[1], b[2] - b[3], b[2] + b[3], 162, b[4]);
                Bi(b[0] - 1, b[1] + 1, b[2] - b[3] - 1, b[2] + b[3] + 1, b[4], b[4] + 1.2);
            }
            Bi(PAN_X - 40, PAN_X + 40, -30, 30, 162, 168);          // pantograph platform
            Bi(620, 636, -10, 10, 164, 170);                        // headlight block
            for (sd = [1, -1]) Bi(SIDE_NB_X - 15, SIDE_NB_X + 15, sd * (RHW - 2.5), sd * RHW, 154, 163);   // side number boards (E50B)
            for (sx = RAIL_POST_X) for (s = [1, -1]) {              // handrail posts, 1 mm wire threads through
                Bi(sx - 1.8, sx + 1.8, s * RAIL_Y - 1.8, s * RAIL_Y + 1.8, 160, 163.2);   // foot
                B(I(sx) - 0.8, I(sx) + 0.8, I(s * RAIL_Y) - 0.8, I(s * RAIL_Y) + 0.8, I(160), I(RAIL_TOP) + 0.9);
            }
        }
        for (mx = MAGX) for (s = [1, -1])
            zhole(magx(mx), s * yin, MAG, zt - 1, zt + MAG_D, 32);  // magnet pockets
        for (sd = [1, -1]) B(I(SIDE_NB_X - 13.5), I(SIDE_NB_X + 13.5), sd * I(RHW) - sd * 0.4, sd * (I(RHW) + 1), I(155.5), I(161.5));   // decal recess
        for (sx = RAIL_POST_X) for (s = [1, -1])                    // wire hole through each post, along the loco
            translate([I(sx) - 2, I(s * RAIL_Y), I(RAIL_TOP)]) rotate([0, 90, 0]) cylinder(d = WIRE, h = 4, $fn = 12);
    }
}

// roof equipment boxes [x0, x1, y centre, half width, top] - prototype inches, ESTIMATE from the brass photo
ROOF_BOXES = [[40, 78, 0, 18, 172], [110, 140, -10, 12, 170], [175, 215, 0, 20, 173], [250, 282, 10, 12, 170],
              [315, 355, 0, 20, 173], [395, 425, -10, 12, 170], [455, 490, 0, 18, 172]];
PAN_X = 575;                                    // pantograph centre, just behind the cab-end hood
RAIL_Y = 42; RAIL_TOP = 172;                    // roof handrail line and wire height (inches)
RAIL_POST_X = [24, 70, 116, 150, 205, 250, 296, 342, 390, 430, 476, 522, 568, 614];
TREAD_Y = [48, 59];                             // roof-edge diamond-plate strip, inches off the centre line
// diamond-plate lugs (ES-2 walkway pattern): length, width, height, pitch (mm)
TREAD_LUG = [3.2, 0.9, 0.3, 2.2];
module tread_2d(L, Wd) {
    P = TREAD_LUG[3];
    intersection() {
        square([L, Wd]);
        for (i = [0 : floor(L / P)], j = [0 : floor(Wd / P)])
            translate([i * P + P / 2, j * P + P / 2]) rotate((i + j) % 2 == 0 ? 45 : -45) square([TREAD_LUG[0], TREAD_LUG[1]], center = true);
    }
}
// lugs on a plane tangent to the arch at the middle of the strip (the arch is flat to 0.07 mm across it)
module roof_tread(x0, x1) if (ROOF_TREAD) for (sd = [1, -1]) {
    yc = (TREAD_Y[0] + TREAD_Y[1]) / 2; wd = I(TREAD_Y[1] - TREAD_Y[0]);
    ang = atan(-yc / sqrt(ARC_R * ARC_R - yc * yc));
    scale([1, sd, 1]) translate([0, I(yc), I(roof_z(yc))]) rotate([ang, 0, 0])
        translate([x0, -wd / 2, -0.25]) linear_extrude(TREAD_LUG[2] + 0.25) tread_2d(x1 - x0, wd);
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
    roof_tread(I(a) + 1, I(b) - 1);
}

// =====================================================================
//  FRAME / UNDERFRAME
// =====================================================================
DH = HW + 1;
// steps (stirrups) at the cab-end corners: separate prints, pinned up into the deck (ES-2 v8)
STEP_LEGS_X = [637.5, 646.5];            // leg centres, prototype inches
step_y = I(DH) - 2;                      // leg plane, mm off the centre line
STEP_TREADS_Z = [40, 51, 62];            // three treads (brass photo), prototype inches
rod_hx = JOIN_ROD[1] / 2 + 0.5;          // rod pocket depth in each section
rod_z = deck_bot - 0.6;

// deck plan, front corners rounded (brass photo); hw = half width (in), inset in mm
DECK_R = 8;                                // front corner radius, prototype inches (ESTIMATE from the brass photo)
module deck_2d(hw, inset) {
    x0 = I(XB0) + inset; x1 = I(X_DECK1) - inset; y = I(hw) - inset; r = max(0.5, I(DECK_R) - inset);
    hull() { translate([x0, -y]) square([1, 2 * y]); for (s = [1, -1]) translate([x1 - r, s * (y - r)]) circle(r = r, $fn = 32); }
}
module frame_adds() {
    xp = I(XB0) - DRAWBAR_PIN_OUT;
    translate([0, 0, deck_bot]) linear_extrude(deck_top - deck_bot) deck_2d(DH, 0);   // deck, rounded front corners
    B(xp - 7, I(XB0) + 1, -10, 10, I(75), I(ZB));            // drawbar tongue
    for (tx = TRUCKS) B(I(tx) - 7, I(tx) + 7, -7, 7, TRUCK_BOSS_Z, I(75));            // truck bosses (frame bolsters)
    B(I(PILOT_X) - 6, I(PILOT_X) + 6, -6, 6, PILOT_BOSS_Z + PIVOT_GAP, I(75));        // pilot boss
    translate([0, 0, I(44)]) linear_extrude(I(75 - 44) + 0.01) intersection() { deck_2d(56, 0); translate([I(647), -100]) square([100, 200]); }   // pilot beam
    if (PILOT_STYLE == "footboard") for (s = [1, -1]) Bi(647, X_DECK1, s * 9, s * 56, FB_BEAM_Z, 44.01);   // deeper end sill behind the footboards
    if (rivets) for (z = PILOT_STYLE == "footboard" ? [72, 47, FB_BEAM_Z + 3] : [72, 47]) for (y = [-45 : 5 : 45]) if (abs(y) > 11)   // end-sill rivet rows
        translate([I(X_DECK1) - 0.01, I(y), I(z)]) rotate([0, 90, 0]) cylinder(d = 0.9, h = 0.4, $fn = 8);
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
    if (PILOT_STYLE == "footboard") for (s = [1, -1]) {
        for (y = FB_BRACKET_Y) zhole(I(FB_PIN_X), s * I(y), WIRE, I(FB_BEAM_Z) - 1, I(FB_BEAM_Z) + 5, 12);           // footboard pins
        for (y = FB_GRAB_Y) translate([I(X_DECK1) - 4, s * I(y), I(FB_GRAB_Z)]) rotate([0, 90, 0]) cylinder(d = WIRE, h = 5, $fn = 12);   // grab irons
    }
    for (h = concat(PLAT_HOLES, [[600, 59], [560, 59], [600, -59], [560, -59]]))
        zhole(I(h[0]), I(h[1]), WIRE, I(ZB) - 3, I(ZB) + 1, 12);
}

// diamond-plate end platform: thin separate print (tread up), glued on the deck in front of the cab
PLAT_HOLES = [[642, 58], [654, 58], [654, 22], [642, -58], [654, -58], [654, -22]];
PLAT_TOE = 1.4;                            // toe angle along the front edge, mm high
module end_platform() {
    x0 = I(XB1) + 0.3; x1 = I(X_DECK1);
    difference() {
        union() {
            intersection() {
                union() {
                    linear_extrude(0.9) deck_2d(HW + 1, 0.3);
                    translate([0, 0, 0.9 - 0.01]) linear_extrude(TREAD_LUG[2] + 0.01) intersection() {
                        deck_2d(HW + 1, 1.2); translate([x0, -I(HW + 1)]) tread_2d(x1 - x0, 2 * I(HW + 1)); }
                    linear_extrude(0.9 + PLAT_TOE) difference() { deck_2d(HW + 1, 0.3); deck_2d(HW + 1, 1.1); }   // toe angle
                    for (h = PLAT_HOLES) translate([I(h[0]), I(h[1]), 0]) cylinder(d = 3.2, h = 1.9, $fn = 20);   // stanchion bases
                }
                translate([x0, -100, -1]) cube([100, 200, 10]);
            }
        }
        for (h = PLAT_HOLES) zhole(I(h[0]), I(h[1]), WIRE + 0.2, -1, 3, 12);
        translate([x0 - 1, -100, -1]) cube([1.2, 200, 10]);            // toe angle stops short of the cab face
    }
}

// one step: two legs and two treads, local frame: leg tops at z = 0 (against the deck), legs at x = 0 and x = Ls
module step() {
    Ls = I(STEP_LEGS_X[1] - STEP_LEGS_X[0]);
    H = deck_bot - I(STEP_TREADS_Z[0]);
    t = 2.0; th = 2.4; td = 8;           // stringer width, stringer thickness, tread depth (inward)
    difference() {
        union() {
            for (x = [0, Ls]) B(x - t / 2, x + t / 2, 0, th, -H - 1.2, 0);                  // flat-bar stringers
            for (z = STEP_TREADS_Z) {
                zt = I(z) - deck_bot;
                B(-t / 2 - 0.6, Ls + t / 2 + 0.6, 0, td, zt, zt + 1.4);                         // tread
                B(-t / 2 - 0.6, Ls + t / 2 + 0.6, td - 0.9, td, zt, zt + 2.4);                  // turned-up nosing
            }
            for (x = [0, Ls]) B(x - t / 2, x + t / 2, 0, th + 1.2, -H - 1.2, -H + 0.6);        // bottom tie lugs
        }
        for (x = [0, Ls]) translate([x, th / 2, -4]) cylinder(d = STEP_PIN, h = 5, $fn = 12);   // pin holes
        for (z = STEP_TREADS_Z) { zt = I(z) - deck_bot;                                             // open grate
            for (i = [0 : 2]) B(0.8, Ls - 0.8, 1.4 + i * 2.0, 2.4 + i * 2.0, zt - 1, zt + 3); }
        for (x = [0, Ls]) for (z = [STEP_TREADS_Z[1] + 4, STEP_TREADS_Z[2] + 4])                   // grab-iron holes
            translate([x, -1, I(z) - deck_bot]) rotate([-90, 0, 0]) cylinder(d = WIRE * 0.8, h = th + 2, $fn = 10);
    }
}
module steps_placed() for (s = [1, -1])
    translate([I(STEP_LEGS_X[0]), s * step_y, deck_bot]) scale([1, s > 0 ? -1 : 1, 1]) translate([0, -2.4 / 2, 0]) step();

// switchmen's footboards: one per side of the coupler, separate print (boards down), pinned with 1 mm
// wire up into the deepened pilot beam. Prototype inches. ESTIMATE: 12 in deep, top 17 in above rail.
FB_Y = [13, 55];                 // board span across, from the centre line
FB_X = [648, 670];               // back (under the beam) to front edge
FB_Z = 17;                       // board top
FB_BRACKET_Y = [17, 34, 51];     // hanger brackets
FB_PIN_X = 650.5;                // bracket centre line (pins up into the beam)
FB_GRAB_Y = [22, 46];            // grab iron in the beam face, 1 mm wire
FB_GRAB_Z = 60;
FB_BEAM_Z = 30;                  // end sill deepened to here in footboard mode
module footboard() {             // +y side, assembled position
    t = I(2.5); zb = I(FB_Z) - t;
    difference() {
        union() {
            for (i = [0, 1]) Bi(FB_X[0] + 1 + i * 10.5, FB_X[0] + 1 + i * 10.5 + 10, FB_Y[0], FB_Y[1], FB_Z - 2.5, FB_Z);  // two planks
            for (y = FB_BRACKET_Y) {
                Bi(FB_X[0], FB_X[1], y - 1, y + 1, FB_Z - 3.5, FB_Z - 2.49);                        // strap under the planks
                Bi(FB_PIN_X - 1.5, FB_PIN_X + 1.5, y - 1, y + 1, FB_Z - 3.5, FB_BEAM_Z);             // hanger up to the end sill
                hull() { Bi(FB_PIN_X + 1.4, FB_PIN_X + 1.5, y - 0.75, y + 0.75, FB_Z - 0.01, FB_Z + 4);   // gusset, hidden behind the sill face
                         Bi(FB_PIN_X + 1.4, FB_X[0] + 9, y - 0.75, y + 0.75, FB_Z - 0.01, FB_Z); }
            }
            Bi(FB_X[1] - 1, FB_X[1], FB_Y[0], FB_Y[1], FB_Z - 3.5, FB_Z + 0.5);                      // nosing
            for (y = [FB_BRACKET_Y[0], FB_BRACKET_Y[2]], x = [FB_X[0] + 6, FB_X[1] - 6])             // carriage bolts
                translate([I(x), I(y), I(FB_Z) - 0.01]) cylinder(d = 0.9, h = 0.3, $fn = 8);
        }
        for (y = FB_BRACKET_Y) zhole(I(FB_PIN_X), I(y), WIRE, I(FB_BEAM_Z) - 4, I(FB_BEAM_Z) + 1, 12);   // pin holes
        for (i = [0, 1], k = [1 : 5]) Bi(FB_X[0] + 1 + i * 10.5 + k * 1.75 - 0.1, FB_X[0] + 1 + i * 10.5 + k * 1.75 + 0.1,
                                        FB_Y[0] - 1, FB_Y[1] + 1, FB_Z - 0.25, FB_Z + 1);           // wood grain
    }
}

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
        if (PILOT_STYLE == "plow") {
            pilot_plate(-50, -10, 44);
            pilot_plate(10, 50, 44);
            pilot_plate(-10.5, 10.5, 22);
        }
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
// Local: z = 0 on the roof; bell at x = 0, horn at y = -HORN_Y. Glue at x = 628 in, y = +17 in: bell one side of the headlight, horn the other.
HORN_Y = 34;
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
// GE diamond pantograph; local, z = 0 on the platform top. raise 0 = locked down (as printed), 1 = up.
function pan_knee(H) = let(P = [30, 10], A = [0, H], L1 = sqrt(30 * 30 + 9), L2 = sqrt(60 * 60 + 16),
                            v = A - P, d = norm(v), a = (L1 * L1 - L2 * L2 + d * d) / (2 * d), h = sqrt(max(0, L1 * L1 - a * a)))
    P + a * v / d + h * [v[1], -v[0]] / d;
module pantograph(raise = 0) {
    H = 17 + raise * 70;                                     // pan head height above the platform, inches
    K = pan_knee(H);
    for (sx = [-35, 35]) for (sy = [-24, 24]) {
        cyl_z(I(sx), I(sy), I(2.8), 0, I(6), 16);
        cyl_z(I(sx), I(sy), I(3.6), I(1.5), I(2.3), 16);        // insulator sheds
        cyl_z(I(sx), I(sy), I(3.6), I(3.5), I(4.3), 16);
    }
    for (sy = [-24, 24]) Bi(-42, 42, sy - 1.5, sy + 1.5, 6, 9);
    for (sx = [-35, 35, -30, 30]) Bi(sx - 1.5, sx + 1.5, -24, 24, 6, 9);
    for (sx = [-30, 30]) cyl_y(I(sx), I(10), I(1.8), I(-24), I(24), 12);   // pivot shafts
    for (sy = [-20, 20]) for (g = [-1, 1]) {
        rod([I(g * 30), I(sy), I(10)], [I(g * K[0]), I(sy), I(K[1])], I(2.2));   // lower arms
        rod([I(g * K[0]), I(sy), I(K[1])], [0, I(sy), I(H)], I(1.8));           // upper arms
    }
    for (g = [-1, 1]) cyl_y(I(g * K[0]), I(K[1]), I(1.3), I(-21), I(21), 10);  // knee tubes
    Bi(-4, 4, -40, 40, H, H + 2);                                              // pan head
    Bi(-1, 1, -20, 20, H - 2, H);
    for (s = [1, -1]) hull() {                                                 // horns
        translate([0, I(s * 40), I(H + 1)]) cube([I(6), I(1.5), I(1.5)], center = true);
        translate([0, I(s * 46), I(H - 4)]) cube([I(6), I(1.5), I(1.5)], center = true);
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
module tk_sideframe(kind, speedo = false) {
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
                if (speedo && s > 0) translate([s * h, tk_yo + tk_box_out + 0.5, a + I(1)]) rotate([-90, 0, 0]) cylinder(d = I(4.5), h = I(3.5), $fn = 24);   // speedometer drive on the lead box (ESTIMATE)
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
        if (speedo) translate([h, tk_yo + tk_box_out + 2.5, a + I(1)]) rotate([0, 90, 0]) cylinder(d = WIRE, h = 6, center = true, $fn = 12);   // speedometer cable (wire)
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
// ---------------- v6 (13 Nov 2026): EF-1 driving-truck sideframe from the GE drawing ----------------
// Deep outside bar frame each side, about 9 ft 4 in either side of the truck centre: top bar, bottom
// bars, pedestal jaws with journal boxes, big openings between them, a centre bolster casting with
// diagonal struts, brake-hanger posts outboard of the wheels, and a 52 in leaf spring carried on
// hangers above each wheel (GE drawing, black springs over the drivers). The ends carry the
// articulation: a lug on the +x end, a fork on the -x end, so neighbouring trucks look hinged.
// Prototype inches in the 2D profile; truck frame x = 0 at the truck centre, z = 0 rail top.
DRIVE_FRAME_END = 112;                 // in, frame end from the truck centre (GE drawing, shortened so the frame prints)
function hin() = DRIVE_WB / 2 * SCALE / 25.4;          // half wheelbase in prototype inches (64.5)
module Si(x0, x1, z0, z1) translate([I(min(x0, x1)), I(min(z0, z1))]) square([I(abs(x1 - x0)), I(abs(z1 - z0))]);
module Hi(p0, p1, w) hull() { translate([I(p0[0]), I(p0[1])]) circle(d = I(w), $fn = 12); translate([I(p1[0]), I(p1[1])]) circle(d = I(w), $fn = 12); }

module ef1_frame_2d() {
    H = hin(); E = DRIVE_FRAME_END;
    g = tk_geom("drive"); col_top = (g[2] - g[3] * 0.4) * SCALE / 25.4;
    offset(r = 0.05) offset(delta = -0.05) offset(delta = 0.05) union() {
        Si(-E, E, 38, 44);                                    // top bar
        Si(-H + 12, H - 12, 17, 22);                          // centre bottom bar
        for (s = [-1, 1]) {
            Si(s * E, s * (E - 4), 17, 44);                   // end post
            Si(s * (H + 12), s * E, 17, 22);                  // end bottom bar
            Si(s * (H + 29), s * (H + 34), 17, 44);           // brake-hanger post (the brake beam glues to it)
            for (j = [-1, 1]) Si(s * H + j * 10, s * H + j * 12, 13, 38);   // pedestal jaws
            Si(s * H - 12, s * H + 12, 13, 16);               // pedestal binder
            Hi([s * (H - 15), 20.5], [s * 17, 39.5], 3);      // diagonal strut, pedestal to bolster
        }
        Si(-14, 14, 17, 44);                                  // centre bolster casting
        Si(-10, 10, 44, col_top);                             // bolster column up to the truck bolster
    }
}
module bc_coil(d, h) {                                         // coil spring as a stack of rings, axis z
    n = max(2, floor(h / 1.4));
    cylinder(d = d * 0.62, h = h, $fn = 16);
    for (i = [0 : n - 1]) translate([0, 0, (i + 0.5) * h / n]) scale([1, 1, 0.55])
        rotate_extrude($fn = 24) translate([d / 2 - 0.55, 0]) circle(r = 0.7, $fn = 10);
}
module ef1_drive_sideframe() {                                 // +y side, inner face at y = tk_yi
    H = hin(); E = DRIVE_FRAME_END; a = DRIVE_WHEEL_D / 2; g = tk_geom("drive");
    ym = tk_yi + rg_sf_t / 2;
    difference() {
        union() {
            translate([0, tk_yi, 0]) rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(rg_sf_t) ef1_frame_2d();
            for (s = [-1, 1]) {
                B(I(s * H - 9), I(s * H + 9), tk_yi, tk_yo + tk_box_out, I(17), I(35));                          // journal box
                B(I(s * H - 7.5), I(s * H + 7.5), tk_yo + tk_box_out - 0.01, tk_yo + tk_box_out + 0.6, I(19), I(33));   // lid
                translate([I(s * H), tk_yo + tk_box_out - 0.3, I(33.5)]) rotate([0, 90, 0]) cylinder(d = I(2.5), h = I(6), center = true, $fn = 16);
                for (i = [0 : 5]) { ln = [14, 22, 30, 38, 46, 52][i];                                            // 52 in leaf spring
                    B(I(s * H - ln / 2), I(s * H + ln / 2), tk_yi + 0.4, tk_yo - 0.1, I(49 + 1.5 * i), I(50.5 + 1.5 * i)); }
                B(I(s * H - 2.5), I(s * H + 2.5), tk_yi + 0.2, tk_yo + 0.5, I(48), I(58.5));                     // spring band
                B(I(s * H - 1.5), I(s * H + 1.5), tk_yi + 0.6, tk_yo - 0.6, I(35) - 0.01, I(48) + 0.01);       // spring post on the box
                for (d = [-1, 1]) { x = s * H + d * 25;                                                         // spring hangers
                    B(I(x - 1), I(x + 1), tk_yi + 0.6, tk_yo - 0.6, I(44) - 0.01, I(57.5));
                    translate([I(x), ym, I(57.5)]) rotate([90, 0, 0]) cylinder(d = I(3), h = rg_sf_t - 1.2, center = true, $fn = 12); }
                for (zz = [21, 33]) translate([I(s * 20), tk_yo - 0.5, I(zz) - I(5)]) bc_coil(I(5), I(10));    // bolster spring nests (ESTIMATE)
            }
            // articulation: lug on the +x end, fork on the -x end (pins cosmetic)
            B(I(E - 0.5), I(E + 12), tk_yi + 0.5, tk_yo - 0.5, I(28), I(34));
            translate([I(E + 9), ym, I(25)]) cylinder(d = I(3.5), h = I(12), $fn = 16);
            for (zz = [[22, 26], [36, 40]]) B(I(-E - 6), I(-E + 0.5), tk_yi + 0.5, tk_yo - 0.5, I(zz[0]), I(zz[1]));
            translate([I(-E - 3), ym, I(21)]) cylinder(d = I(3.5), h = I(20), $fn = 16);
            // centre-plate bolts and frame rivets
            for (bx = [-8, 8], bz = [24, 37]) translate([I(bx), tk_yo - 0.01, I(bz)]) rotate([-90, 0, 0]) cylinder(d = I(2.6), h = 0.7, $fn = 6);
            for (x = [-E + 3 : 6 : E - 3]) translate([I(x), tk_yo - 0.2, I(41)]) rotate([-90, 0, 0]) cylinder(d = 0.9, h = 0.6, $fn = 8);
            for (x = [-E + 3 : 6 : E - 3]) if (abs(abs(x) - H) > 13) translate([I(x), tk_yo - 0.2, I(19.5)]) rotate([-90, 0, 0]) cylinder(d = 0.9, h = 0.6, $fn = 8);
        }
        for (s = [-1, 1]) translate([I(s * H), tk_yi - 0.01, a]) rotate([-90, 0, 0]) rg_bearing_pocket();          // F683 pockets
        translate([-I(7) - 0.2, tk_yi - 0.01, g[2] - g[3] - 0.2]) cube([2 * I(7) + 0.4, tk_tab + 0.2, 50]);    // bolster slot, open at the top
        for (s = [-1, 1]) translate([I(s * H) - I(9) - 1, tk_yo + tk_box_out - 0.5, I(19.5)]) cube([I(18) + 2, 1.2, 0.5]);   // box lid line
        for (s = [-1, 1]) zhole(I(s * (H + 18)), ym, WIRE, I(17) - 1, I(17) + 3.5, 12);                         // sand pipes (1 mm wire)
    }
}
// brake beam with two shoes, one outboard of each axle; ends glue to the brake-hanger posts.
// Local: beam centre at x = 0 (truck x = +/-(h + R + 4.05)), shoes toward -x, z = 0 at axle height.
function brake_x() = DRIVE_WB / 2 + DRIVE_WHEEL_D / 2 + 4.05;
module ef1_brake_beam() {
    R = DRIVE_WHEEL_D / 2;
    difference() {
        union() {
            B(-1.25, 1.25, -(tk_yi - 0.1), tk_yi - 0.1, -1.5, 1.5);                     // beam
            for (s = [-1, 1]) B(-5.25, -1.24, s * 22.2, s * 26.4, -8, 8);              // shoe heads and shoes
            for (s = [-1, 1]) B(-1.25, 1.25, s * (tk_yi - 2.2), s * (tk_yi - 0.1), -5, 5);   // end pads (glue)
            for (s = [-1, 1]) B(-1.24, 0.5, s * 23.6, s * 25, -3, 3);                  // shoe hanger lugs
        }
        translate([-(R + 4.05), 0, 0]) rotate([90, 0, 0]) cylinder(r = R + 0.8, h = 70, center = true, $fn = 96);   // shoe faces follow the tread
    }
}
// ---------------- spoked wheels (as the ES-2: steel tyre on a spoked centre) ----------------
module bc_spoked_wheel(wheel_d, n) {
    R = wheel_d / 2; w = rg_wheel_w; ft = rg_flange_t; fh = rg_flange_h;
    rb = rg_axle_d * 0.97 / 2; hub = rg_axle_d / 2 + rg_hub; tyre = I(3.2);
    rim_in = R - tyre - 1.0; web = w * 0.55;
    rotate_extrude($fn = 96) polygon([[rim_in, 0], [R + fh, 0], [R + fh, ft * 0.5], [R + 0.3 * ft / 1.5, ft + 0.3 * ft / 1.5],
        [R, ft + 0.8 * ft / 1.5], [R - (w - ft) * 0.05, w], [R - tyre, w], [R - tyre, web + 0.6], [rim_in, web]]);
    rotate_extrude($fn = 48) polygon([[rb, 0], [hub + 1.6, 0], [hub + 1.6, web], [hub, w + rg_hub_proud], [rb, w + rg_hub_proud]]);
    for (i = [0 : n - 1]) rotate([0, 0, i * 360 / n]) hull() {
        translate([hub + 0.8, 0, 0]) cylinder(d = 2.1, h = web, $fn = 12);
        translate([rim_in + 0.4, 0, 0]) cylinder(d = 1.5, h = web * 0.85, $fn = 12);
    }
    for (i = [0 : 5]) rotate([0, 0, i * 60 + 30]) translate([hub - 0.3, 0, w + rg_hub_proud - 0.01]) cylinder(d = 0.9, h = 0.35, $fn = 8);
}
module tk_wheel(kind) {
    g = tk_geom(kind);
    style = kind == "drive" ? WHEEL_STYLE_DRIVE : WHEEL_STYLE_PILOT;
    if (style == "spoked") bc_spoked_wheel(g[1], kind == "drive" ? SPOKES_DRIVE : SPOKES_PILOT);
    else rg_wheel(g[1]);
}
module bc_wheelset(kind) {
    g = tk_geom(kind);
    color(RG_PAINT_AXLE) rotate([90, 0, 0]) cylinder(d = rg_axle_d, h = rg_axle_len, center = true, $fn = 20);
    for (s = [1, -1]) scale([1, s, 1]) {
        translate([0, rg_b2b / 2, 0]) rotate([-90, 0, 0]) color(RG_PAINT_WHEEL) tk_wheel(kind);
        translate([0, tk_yi, 0]) rotate([-90, 0, 0]) color(RG_PAINT_BEARING) rg_bearing_part();
    }
}
module tk_truck(kind, show_wheels = true) {
    g = tk_geom(kind);
    if (kind == "drive") {
        ef1_drive_sideframe(); mirror([0, 1, 0]) ef1_drive_sideframe();
        for (s = [-1, 1]) translate([s * brake_x(), 0, g[1] / 2]) scale([s, 1, 1]) ef1_brake_beam();
    } else {
        tk_sideframe(kind, speedo = true); mirror([0, 1, 0]) tk_sideframe(kind);
    }
    tk_bolster(kind);
    if (show_wheels) for (s = [-1, 1]) translate([s * g[0], 0, g[1] / 2]) bc_wheelset(kind);
}
// prints: driving truck in two plates (frames + brake beams; bolster + wheels), pilot truck in one
module tk_truck_plate(kind) {
    if (kind == "drive_frames") {
        for (i = [0, 1]) translate([0, -i * 44, -tk_yi]) rotate([90, 0, 0]) ef1_drive_sideframe();   // inner face down
        for (i = [0 : 3]) translate([-66 + i * 22, 38, 1.25]) rotate([0, 90, 0]) ef1_brake_beam();  // back face down
    } else if (kind == "drive_running") {
        g = tk_geom("drive"); W = g[1] + 8;
        translate([-50, 0, g[2]]) rotate([180, 0, 0]) tk_bolster("drive");                             // top down
        for (i = [0, 1], j = [0, 1]) translate([5 + i * W, -W / 2 + j * W, 0]) tk_wheel("drive");      // flange face down
    } else {
        g = tk_geom("pilot"); W = g[1] + 8;
        translate([0, 0, -tk_yi]) rotate([90, 0, 0]) tk_sideframe("pilot", speedo = true);
        translate([0, -39, -tk_yi]) rotate([90, 0, 0]) tk_sideframe("pilot");
        translate([-30, 35, g[2]]) rotate([180, 0, 0]) tk_bolster("pilot");
        for (i = [0, 1], j = [0, 1]) translate([15 + i * W, 22 + j * W, 0]) tk_wheel("pilot");
    }
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
    if (PILOT_STYLE == "footboard") color(dark) for (s = [1, -1]) scale([1, s, 1]) footboard();
    if (show_wheels) color([0.75, 0.75, 0.78]) pivot_hardware();
    color(dark) translate([I(628), 0, I(170) + 1.7 * ex]) headlight();
    color(dark) translate([I(PAN_X), 0, I(168) + 1.7 * ex]) pantograph(PAN_RAISE);
    color(dark) translate([I(628), I(17), I(165.5) + 1.7 * ex]) bell_horn();
    color(dark) translate([0, 0, I(ZB)]) end_platform();
    if (show_lettering) color("white") for (sd = [1, -1])      // road number on the side boards (preview only)
        translate([I(SIDE_NB_X), sd * (I(RHW) + 0.05), I(158.5) + 1.7 * ex]) rotate([90, 0, sd > 0 ? 180 : 0])
            linear_extrude(0.1) text(ROAD_NO, size = I(4.5), halign = "center", valign = "center");
    for (tx = TRUCKS) translate([I(tx), 0, 0]) { color(dark) tk_truck("drive", false); if (show_wheels) for (s = [-1, 1]) translate([s * DRIVE_WB / 2, 0, DRIVE_WHEEL_D / 2]) bc_wheelset("drive"); }
    translate([I(PILOT_X), 0, 0]) { color(dark) tk_truck("pilot", false); if (show_wheels) for (s = [-1, 1]) translate([s * PILOT_WB / 2, 0, PILOT_WHEEL_D / 2]) bc_wheelset("pilot"); }
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
    else if (p == "drive_truck_frames") tk_truck_plate("drive_frames");          // print 2: two sideframes + four brake beams
    else if (p == "drive_truck_running") tk_truck_plate("drive_running");        // print 2: bolster + motors, four wheels
    else if (p == "pilot_truck") tk_truck_plate("pilot");                        // print 1
    else if (p == "bearing_coupon") rg_bearing_coupon();                         // test the F683 fit first
    else if (p == "headlight") headlight();
    else if (p == "pantograph") pantograph();                                     // needs supports
    else if (p == "bell_horn") bell_horn();                                       // lead units only
    else if (p == "end_platform") translate([-I(XB1), 0, 0]) end_platform();     // diamond plate, tread up
    else if (p == "drawbar") drawbar();
    else if (p == "step") rotate([90, 0, 0]) step();                              // print 2 per unit, flat
    else if (p == "footboard") translate([-I(660), -I(34), -(I(FB_Z) - I(3.5))]) footboard();   // print 2 (PILOT_STYLE = footboard), boards down
}

if (part == "assembly") assembly(0);
else if (part == "exploded") assembly(45);
else print_part(part);
