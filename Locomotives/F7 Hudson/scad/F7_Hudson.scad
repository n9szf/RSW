// =====================================================================
//  Rib Side Works - Milwaukee Road class F7 4-6-4 "Baltic" No. 100 (1938)
//  One stand-alone file: G 1:29 (display), O 1:48 and HO 1:87 (printed
//  kits, HO in resin), and FULL size in feet for the Everett Street movies.
//
//  Sources: ALCO elevation and sections, Railway Mechanical Engineer,
//  Nov 1938 pp. 446-448; Railway Age 24 Sept 1938 photo; ALCO builder
//  photo of No. 100. Notes: RSW / export / Locomotives / F7 Hudson / notes.
//  TDQ-577 to TDQ-597.
//
//  All dimensions below are FULL SIZE INCHES. x = distance back from the
//  pilot front, z = height above top of rail, y = across (0 = track CL).
//  The model is placed with the pilot at the origin facing +X.
//
//  Rev E 22 Nov 2026 (Claude): number boards in streamlined housings on the casing shoulder
//  (builder photo), stainless nose bands raised to match the photo.
//  Rev D 22 Nov 2026 (Claude): cab to the ALCO section (straight sides to 12'-8", tight corners,
//  taller windows); firebox casing brought down to flow into the cab front.
//  Rev C 22 Nov 2026 (Claude): bell, whistle, air horn, sand pipes, brake gear,
//  generator, throttle linkage, injector checks, lubricators, access panels, plates,
//  cylinder cocks, speed recorder, pilot hoses, cab roof, tender rear lamps and steps.
//  Rev B 22 Nov 2026 (Claude): shroud rebuilt as boiler casing + skirt
//  ledge + cowling (from the ALCO sections and photos), rounded bullet nose
//  with stainless wing bands, arched cab with framed windows, detailed
//  Boxpok drivers, trucks with journal boxes, Walschaert valve gear,
//  handrails, marker lamps, steps, tender bunker, hatch, ladders.
//  No libraries - kits stay stand-alone.
// =====================================================================

/* [Choose] */
SCALE = "G";        // [G, O, HO, FULL]
PART  = "assembly"; // [assembly, engine, tender, shroud, cab, frame, cylinders, driver, lead_wheel, trailing_wheel_front, trailing_wheel_rear, tender_wheel, rods, lead_truck, trailing_truck, tender_truck, tender_body, pilot_coupler, details]
PIECE = 0;          // print piece number for shroud / tender_body (0 = whole)
COLOURS = true;     // preview colours (Milwaukee 1938 scheme, see TDQ-592)
CRANK_DEG = 30;     // driver crank angle for the assembly view

// ---------------------------------------------------------------- scale
RATIO = SCALE == "G" ? 29 : SCALE == "O" ? 48 : SCALE == "HO" ? 87.1 : 1;
K = SCALE == "FULL" ? 1/12 : 25.4 / RATIO;     // inches -> output units (mm, or feet for FULL)
WALL = SCALE == "G" ? 2.0*29/25.4 : SCALE == "O" ? 1.6*48/25.4 : SCALE == "HO" ? 0.9*87.1/25.4 : 3;
// smallest printable detail, model inches (rails, lamps)
FINE = SCALE == "G" ? 0.8*29/25.4 : SCALE == "O" ? 0.6*48/25.4 : SCALE == "HO" ? 0.3*87.1/25.4 : 1;
$fn = SCALE == "FULL" ? 72 : 56;

// ---------------------------------------------------------------- ALCO data
GAUGE      = 56.5;
ENGINE_LEN = 714.875;           // 59'-6 7/8" over all
TOTAL_LEN  = 1200;              // 100'-0" over couplers
MAX_H      = 186;               // 15'-6"
BOILER_CL  = 129;               // 10'-9"
CAB        = [601, 716, 52, 165];          // x front, x back, z bottom, z roof
CAB_HALF_W = 63;                // cab 126" wide
CYL        = [136, 45.5, 51, 30, 40];      // x, y (91" centres), z, casing dia, length
STROKE     = 30;
LEAD   = [[92.75, 36], [178.75, 36]];
DRIVER = [[252.75, 84], [340.75, 84], [428.75, 84]];
TRAIL  = [[536.75, 38], [600.75, 44]];
MAIN_DRIVER = 1;
ROD_Y = GAUGE/2 + 9;

// tender (height from builder photo; length from 100'-0" total; trucks best guess)
T_FRONT = ENGINE_LEN + 2;
T_BACK  = TOTAL_LEN;
T_TOP   = 156;
T_BOT   = 36;
T_HALF_W = 62;
T_TRUCKS = [820, 1104.75];
T_WB     = 66;
T_WHEEL  = 38;

// ---------------------------------------------------------------- shroud data
// Three lofted parts. Every station:
//   [x, casing radius, casing centre z, skirt bottom z, skirt top (ledge) z, skirt half-width,
//    cowling half-width, cowling top z]
// Nose stations follow the 16 degree rake (casing top = rake line), body stations
// follow the boiler: smokebox 85 1/2 OD, barrel 94 OD, plus jacket.
STATIONS = [
 [  6,  5,  10,   4,  14, 16,  0,   0],
 [ 14, 14,  30,  10,  34, 28,  0,   0],
 [ 24, 26,  36,  18,  52, 38,  0,   0],
 [ 34, 35,  60,  26,  70, 45,  0,   0],
 [ 44, 41,  89,  31,  86, 51,  0,   0],
 [ 54, 45, 119,  35,  96, 55,  6, 166],
 [ 62, 47, 128,  37,  98, 57, 12, 178],
 [ 76, 47, 129,  39, 100, 60, 15, 183],
 [100, 47, 129,  41, 100, 62, 16, 184],
 [112, 47, 129,  42, 100, 62, 17, 186],
 [128, 47, 129,  43, 100, 62, 16, 184],
 [160, 48, 129,  45, 100, 62, 16, 183],
 [198, 49, 129,  49, 100, 62, 16, 183],
 [232, 50, 129,  70, 100, 63, 16, 183],
 [265, 50, 129,  84, 100, 63, 16, 182],
 [330, 50, 129,  84, 100, 63, 16, 181],
 [470, 51, 129,  84, 100, 63, 16, 180],
 [530, 51, 129,  80, 104, 63, 18, 180],
 [570, 52, 122,  66, 116, 63, 24, 175],
 [600, 52, 110,  52, 134, 63, 30, 166],
];
SHROUD_CUTS = SCALE == "G" ? [300] : SCALE == "O" ? [330] : [];
TENDER_CUTS = SCALE == "G" ? [960] : [];

// ---------------------------------------------------------------- colours
C_GREY   = [0.66, 0.68, 0.70];
C_ORANGE = [0.93, 0.55, 0.13];
C_MAROON = [0.45, 0.10, 0.12];
C_BLACK  = [0.12, 0.12, 0.12];
C_STEEL  = [0.82, 0.83, 0.85];
C_GLASS  = [0.25, 0.32, 0.38];
module col(c) { if (COLOURS) color(c) children(); else children(); }

// ---------------------------------------------------------------- helpers
module place() { scale(K) mirror([1,0,0]) children(); }
module slab(x) { translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(0.01) children(); }
module rodbar(a, b, d) { hull() { translate(a) sphere(d/2, $fn = 16); translate(b) sphere(d/2, $fn = 16); } }

// 2D pieces of a station (in the Y-Z plane)
module casing2d(s, i=0)  { translate([0, s[2]]) circle(max(0.5, s[1] - i)); }
module skirt2d(s, i=0)   {
    r = min(10, (s[4] - s[3])/2);
    hull() for (sy = [-1, 1]) {
        translate([sy*(s[5] - r - i), s[3] + r + i]) circle(max(0.2, r));
        translate([sy*(s[5] - 0.5 - i) - 0.5, s[4] - 1 - i]) square([1, 1]);
    }
}
module cowl2d(s, i=0) {
    if (s[6] > 0) hull() for (sy = [-1, 1]) {
        translate([sy*max(0.5, s[6] - 5 - i), s[7] - 5 - i]) circle(5);
        translate([sy*max(0.5, s[6] - 1 - i) - 0.5, s[2] + s[1] - 14]) square([1, 1]);
    }
}
module loft_part(which, i=0) {
    for (k = [0 : len(STATIONS) - 2]) {
        a = STATIONS[k]; b = STATIONS[k+1];
        if (which != "cowl" || (a[6] > 0 && b[6] > 0))
        hull() {
            slab(a[0]) if (which == "casing") casing2d(a, i); else if (which == "skirt") skirt2d(a, i); else cowl2d(a, i);
            slab(b[0]) if (which == "casing") casing2d(b, i); else if (which == "skirt") skirt2d(b, i); else cowl2d(b, i);
        }
    }
}
// casing is cut flat at the skirt bottom so it never hangs below the skirt line
module casing_clip(i=0) {
    for (k = [0 : len(STATIONS) - 2]) hull() {
        a = STATIONS[k]; b = STATIONS[k+1];
        translate([a[0], -80, a[3] + i]) cube([0.01, 160, 220]);
        translate([b[0], -80, b[3] + i]) cube([0.01, 160, 220]);
    }
}
module shroud_body(i=0) {
    intersection() { loft_part("casing", i); casing_clip(i); }
    loft_part("skirt", i);
}

// ---------------------------------------------------------------- shroud
module shroud_solid() {
    difference() {
        union() {
            shroud_body();
            loft_part("cowl");
            // fishtail: cowling flares and slopes down onto the cab roof
            hull() {
                translate([598, -30, 148]) cube([2, 60, 18]);
                translate([630, -44, CAB[3] - 5]) cube([2, 88, 4]);
            }
        }
        if (SCALE != "FULL") shroud_body(WALL);
        // opening in the cowling front for the air horn and whistle (ALCO elevation)
        translate([52, -7, 166]) cube([30, 14, 22]);
        // headlight recess and grille slots on the nose
        translate([40, 0, 104]) rotate([0, 74, 0]) cylinder(d = 17, h = 30, center = true);
        for (z = [122:5:142]) translate([48 + (z - 122)*0.29, -11, z]) rotate([0, -16, 0]) cube([12, 22, 2.2]);
    }
}
module stainless_bands() {   // horizontal wings round the nose and pilot (Kuhler)
    col(C_STEEL) for (z = [56, 63, 70]) intersection() {
        shroud_body(-0.6);
        translate([0, -80, z]) cube([200 - (z - 56)*2, 160, 1.6]);
    }
    // wing ornament above the headlight
    col(C_STEEL) for (sy = [-1, 1]) intersection() {
        shroud_body(-0.5);
        translate([40, sy > 0 ? 6 : -40, 112]) rotate([sy*8, 0, 0]) cube([40, 34, 1.6]);
    }
}
module headlight() {
    col(C_STEEL) translate([40, 0, 104]) rotate([0, 74, 0]) difference() {
        cylinder(d = 17, h = 4, center = true);
        translate([0, 0, 1.5]) cylinder(d = 12, h = 4, center = true);
    }
    col([1, 0.95, 0.75]) translate([40, 0, 104]) rotate([0, 74, 0]) cylinder(d = 12, h = 2, center = true);
}
module shroud_paint() {   // 1938 article: grey casing, black cowling, orange/maroon skirt bands
    col(C_ORANGE) intersection() { loft_part("skirt", -0.25); translate([30, -100, 86]) cube([440, 200, 11]); }
    col(C_MAROON) intersection() { loft_part("skirt", -0.35); translate([30, -100, 84]) cube([440, 200, 2.5]); }
    col(C_MAROON) intersection() { loft_part("skirt", -0.35); translate([30, -100, 97]) cube([440, 200, 2.5]); }
    col(C_MAROON) intersection() { loft_part("skirt", -0.3); translate([0, -100, 0]) cube([60, 200, 34]); }
    col(C_BLACK)  loft_part("cowl", -0.3);
}
module handrails() {          // stainless rails along the boiler and up the nose
    col(C_STEEL) for (sy = [-1, 1]) {
        y = sy*(50 + 3);
        rodbar([80, sy*(48 + 3), 150], [596, y + sy*6, 150], max(FINE, 1.6));
        for (x = [100:70:580]) rodbar([x, sy*(48), 150], [x, y + sy*(x > 540 ? 6 : 0), 150], max(FINE, 1.2));
        // nose rails following the headlight line
        rodbar([52, sy*30, 118], [80, sy*(48 + 3), 150], max(FINE, 1.6));
    }
}
// Number boards: streamlined housings on the casing shoulder either side of the cowling,
// about 7'-6" to 10'-2" back from the pilot at 13'-5" (ALCO builder photo of No. 100).
// Each carries "100" on its outer face and a marker lens looking forward.
NB = [90, 122, 161, 36];        // x front, x back, z centre, y (each side)
module number_board_housing(sy) {
    hull() {
        translate([NB[0] + 4, sy*NB[3], NB[2]]) scale([4, 3.2, 4]) sphere(1, $fn = 24);
        translate([NB[1] - 3, sy*NB[3], NB[2]]) scale([3, 3.8, 4.6]) sphere(1, $fn = 24);
        translate([NB[1] - 3, sy*(NB[3] - 4), NB[2] - 4]) cube([2, 2, 2], center = true);   // foot onto the casing
    }
}
module number_boards() {
    for (sy = [-1, 1]) {
        col(C_BLACK) number_board_housing(sy);
        // white number panel on the outer face, black figures
        col([0.95, 0.95, 0.92]) translate([NB[0] + 9, sy*(NB[3] + 4.2) - 0.2, NB[2] - 3]) cube([16, 0.4, 6]);
        if (COLOURS) col(C_BLACK) translate([NB[0] + 17, sy*(NB[3] + 4.45), NB[2] - 2.2])
            rotate([90, 0, sy > 0 ? 180 : 0]) linear_extrude(0.3) mirror([1, 0, 0])
                text("100", size = 4.4, halign = "center", font = "Liberation Sans:style=Bold");
        // forward marker lens
        col([0.85, 0.85, 0.80]) translate([NB[0] + 0.3, sy*NB[3], NB[2]]) rotate([0, -90, 0]) cylinder(d = 3.2, h = 0.6);
    }
}
module marker_lamps() { number_boards(); }

// ---------------------------------------------------------------- cab
module cab2d(i=0) {           // ALCO cab section: near-vertical sides to 12'-8", tight corners, crowned roof
    r = 14;
    hull() {
        translate([-(CAB_HALF_W - i), CAB[2] + i]) square([2*(CAB_HALF_W - i), 100]);
        for (sy = [-1, 1]) translate([sy*(CAB_HALF_W - r - i), 152 - i]) circle(r);
        translate([0, CAB[3] - 40]) scale([CAB_HALF_W - 20 - i, 40 - i]) circle(1, $fn = 64);
    }
}
CAB_WINDOWS = [[610, 642, 102, 140], [646, 680, 102, 140], [688, 712, 102, 140]];   // ALCO elevation
module cab() {
    x0 = CAB[0]; x1 = CAB[1];
    col(C_GREY) difference() {
        union() {
            translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) cab2d();
            // roof overhang / rain strip
            translate([x0 - 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0 + 6)
                difference() { cab2d(-1.5); cab2d(0); }
        }
        if (SCALE != "FULL") translate([x0 + WALL, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0 - 2*WALL) cab2d(WALL);
        else translate([x0 + 3, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0 - 6) cab2d(3);
        for (w = CAB_WINDOWS) translate([w[0], -CAB_HALF_W - 5, w[2]]) cube([w[1] - w[0], 2*CAB_HALF_W + 10, w[3] - w[2]]);
        // front windows either side of the cowling, and the rear vestibule opening
        for (sy = [-1, 1]) translate([x0 - 4, sy*46 - 10, 112]) cube([12, 20, 36]);
        translate([x1 - 4, -30, CAB[2] + 4]) cube([10, 60, 96]);
    }
    // window frames and narrow aluminium mullions
    col(C_STEEL) for (w = CAB_WINDOWS) for (sy = [-1, 1]) translate([0, sy*(CAB_HALF_W + 0.3), 0]) {
        difference() {
            translate([w[0] - 1.2, -0.6, w[2] - 1.2]) cube([w[1] - w[0] + 2.4, 1.2, w[3] - w[2] + 2.4]);
            translate([w[0], -1, w[2]]) cube([w[1] - w[0], 2, w[3] - w[2]]);
        }
        translate([w[0], -0.6, (w[2] + w[3])/2 - 0.6]) cube([w[1] - w[0], 1.2, max(FINE, 1.2)]);
    }
    col(C_GLASS) for (w = CAB_WINDOWS) translate([w[0], -CAB_HALF_W + 1, w[2]]) cube([w[1] - w[0], 2*CAB_HALF_W - 2, 0.01 + (w[3] - w[2])]);
    // grab irons and steps under the cab doors
    col(C_STEEL) for (sy = [-1, 1]) {
        rodbar([716, sy*(CAB_HALF_W + 2), 60], [716, sy*(CAB_HALF_W + 2), 100], max(FINE, 1.4));
        rodbar([606, sy*(CAB_HALF_W + 2), 60], [606, sy*(CAB_HALF_W + 2), 100], max(FINE, 1.4));
    }
    col(C_BLACK) for (sy = [-1, 1]) for (z = [20, 36]) translate([694, sy*(CAB_HALF_W - 2) - 2, z]) cube([16, 4, 2]);
    col(C_BLACK) for (sy = [-1, 1]) translate([694, sy*(CAB_HALF_W - 2) - 1, 18]) cube([2, 2, 36]);
    col(C_BLACK) for (sy = [-1, 1]) translate([708, sy*(CAB_HALF_W - 2) - 1, 18]) cube([2, 2, 36]);
    // number "100" on the cab side (decal on printed kits)
    if (COLOURS) col(C_STEEL) for (sy = [-1, 1]) translate([660, sy*(CAB_HALF_W + 0.4), 80])
        rotate([90, 0, sy > 0 ? 180 : 0]) linear_extrude(0.4) mirror([1, 0, 0]) text("100", size = 10, halign = "center", font = "Liberation Sans:style=Bold");
}

// ---------------------------------------------------------------- running gear
module wheel(d, w = 5.5) {            // spoked-disc trailing / truck wheel with flange and tread
    rotate([90, 0, 0]) {
        difference() {
            union() {
                cylinder(d = d, h = w, center = true);
                translate([0, 0, w/2 - 0.5]) cylinder(d = d + 2.5, h = 1.5);       // flange (inside)
            }
            for (sz = [-1, 1]) translate([0, 0, sz*(w/2)]) cylinder(d = d*0.78, h = 2, center = true);
        }
        cylinder(d = d*0.24, h = w + 3, center = true);                          // hub
    }
}
module boxpok(d, w = 6) {             // Boxpok centre: box-section disc with oval openings
    rotate([90, 0, 0]) {
        difference() {
            union() {
                cylinder(d = d, h = w, center = true);                               // tyre
                translate([0, 0, w/2 - 0.5]) cylinder(d = d + 3, h = 1.5);           // flange
            }
            cylinder(d = d - 8, h = w + 2, center = true);                           // inside of tyre
        }
        difference() {
            cylinder(d = d - 7, h = w - 2, center = true);                           // box disc
            for (a = [0 : 360/9 : 359]) rotate([0, 0, a + 20]) translate([d*0.30, 0, 0])
                scale([1, 0.58, 1]) cylinder(d = d*0.21, h = w + 2, center = true);
        }
        for (sz = [-1, 1]) translate([0, 0, sz*(w/2 - 0.6)]) difference() {      // box ribs
            cylinder(d = d - 7.5, h = 1, center = true);
            cylinder(d = d - 13, h = 2, center = true);
        }
        cylinder(d = d*0.26, h = w + 4, center = true);                              // hub
        // counterweight crescent (cast in), opposite the crank
        rotate([0, 0, 180]) intersection() {
            difference() { cylinder(d = d - 8.5, h = w - 1.3, center = true); translate([0, d*0.06, 0]) cylinder(d = d - 4, h = w + 2, center = true); }
            translate([-d, -d, -w]) cube([2*d, d*0.85, 2*w]);
        }
    }
}
module axle(x, d, track_y = GAUGE/2 + 2.75) {
    translate([x, 0, d/2]) {
        for (sy = [-1, 1]) translate([0, sy*track_y, 0]) children();
        rotate([90, 0, 0]) cylinder(d = 8, h = 2*track_y, center = true);
    }
}
function crank(xc, d, a) = [xc + (STROKE/2)*cos(a), d/2 + (STROKE/2)*sin(a)];

module drivers() {
    col(C_GREY) for (dw = DRIVER) axle(dw[0], dw[1]) boxpok(dw[1]);
    col(C_MAROON) for (dw = DRIVER) for (sy = [-1, 1]) translate([dw[0], sy*(GAUGE/2 + 6.5), dw[1]/2]) rotate([90, 0, 0]) cylinder(d = 11, h = 1.2, center = true);
    col(C_BLACK) for (dw = DRIVER) for (sy = [-1, 1]) translate([dw[0] - 7, sy*(GAUGE/2 - 9) - 4, dw[1]/2 - 9]) cube([14, 8, 18]);   // driving boxes
}
module lead_wheels()  { col(C_GREY) for (w = LEAD)  axle(w[0], w[1]) wheel(w[1]); }
module trail_wheels() { col(C_GREY) for (w = TRAIL) axle(w[0], w[1]) wheel(w[1]); }

module rods(a = CRANK_DEG) {
    col(C_STEEL) for (sy = [-1, 1]) {
        aa = sy > 0 ? a : a + 90;
        p0 = crank(DRIVER[0][0], 84, aa); p1 = crank(DRIVER[1][0], 84, aa); p2 = crank(DRIVER[2][0], 84, aa);
        pm = crank(DRIVER[MAIN_DRIVER][0], 84, aa);
        y = sy*ROD_Y; ym = sy*(ROD_Y + 3.5); yv = sy*(ROD_Y + 7);
        // side rods, fluted look: two bars
        rodbar([p0[0], y, p0[1] + 1.2], [p2[0], y, p2[1] + 1.2], 3.2);
        rodbar([p0[0], y, p0[1] - 1.2], [p2[0], y, p2[1] - 1.2], 3.2);
        for (p = [p0, p1, p2]) translate([p[0], y, p[1]]) rotate([90, 0, 0]) cylinder(d = 8, h = 3, center = true);
        // crosshead, guides, main rod (129"), piston rod
        xh = pm[0] - sqrt(129*129 - pow(pm[1] - CYL[2], 2));
        translate([xh - 7, ym - sy*1.5 - 1.5, CYL[2] - 6]) cube([14, 3, 12]);
        for (dz = [-7, 7]) translate([CYL[0] + CYL[4]/2, ym - 1, CYL[2] + dz - 1]) cube([xh - CYL[0] - CYL[4]/2 + 10, 2, 2]);
        rodbar([xh, ym, CYL[2]], [pm[0], ym, pm[1]], 4.5);
        translate([pm[0], ym, pm[1]]) rotate([90, 0, 0]) cylinder(d = 9, h = 3, center = true);
        translate([CYL[0], ym, CYL[2]]) rotate([0, 90, 0]) cylinder(d = 4, h = xh - CYL[0]);
        // Walschaert valve gear: eccentric crank, eccentric rod, expansion link, radius rod,
        // combination lever and union link
        ec = [pm[0] + 9*cos(aa + 90), pm[1] + 9*sin(aa + 90)];
        rodbar([pm[0], yv, pm[1]], [ec[0], yv, ec[1]], 3);
        lk = [pm[0] - 70, 74];
        rodbar([ec[0], yv, ec[1]], [lk[0], yv, lk[1] - 8], 2.5);
        translate([lk[0] - 2, yv - 1.5, lk[1] - 12]) cube([4, 3, 24]);                       // expansion link
        rodbar([lk[0], yv, lk[1]], [CYL[0] + 26, yv, 72], 2.5);                               // radius rod
        rodbar([CYL[0] + 26, yv, 72], [CYL[0] + 26, yv, CYL[2] - 4], 2.5);                    // combination lever
        rodbar([CYL[0] + 26, yv, CYL[2] - 4], [xh, yv - sy*2, CYL[2] - 4], 2);                // union link
        // valve chest above the cylinder
        translate([CYL[0] - 16, sy*CYL[1] - 7, CYL[2] + 14]) cube([32, 14, 10]);
    }
}

module frame() {
    col(C_BLACK) {
        for (sy = [-1, 1]) translate([60, sy*20 - 3, 30]) cube([640, 6, 22]);            // cast bed sides
        for (x = [70, 230, 470, 640]) translate([x, -20, 30]) cube([8, 40, 22]);
        translate([600, -CAB_HALF_W, 48]) cube([116, 2*CAB_HALF_W, 4]);                 // cab deck
        for (x = [210, 300, 390]) translate([x, -32, 74]) cube([20, 64, 10]);            // brake hangers / ash pan supports
        translate([476, -36, 28]) cube([110, 72, 22]);                                    // ash pan
    }
}
module cylinders() {
    col(C_BLACK) for (sy = [-1, 1]) translate([CYL[0] - CYL[4]/2, sy*CYL[1], CYL[2]]) rotate([0, 90, 0]) {
        cylinder(d = CYL[3], h = CYL[4]);
        for (z = [0, CYL[4]]) translate([0, 0, z - 1.5]) cylinder(d = CYL[3] + 3, h = 3);    // heads
    }
    col(C_BLACK) translate([CYL[0] - 20, -CYL[1], CYL[2] - 12]) cube([40, 2*CYL[1], 24]);
}
module journal_box(x, z, y) { translate([x - 5, y - 4, z - 6]) cube([10, 8, 12]); }
module truck(xc, wb, n, d, y = GAUGE/2 + 9) {
    col(C_BLACK) for (sy = [-1, 1]) {
        for (k = [0 : n - 1]) journal_box(xc - (n - 1)*wb/2 + k*wb, d/2, sy*y);
        hull() {                                  // cast side frame, arched between boxes
            translate([xc - (n - 1)*wb/2 - 6, sy*y - 2, d/2 - 2]) cube([(n - 1)*wb + 12, 4, 8]);
            translate([xc - (n - 1)*wb/2 + 10, sy*y - 2, d/2 - 10]) cube([max(1, (n - 1)*wb - 20), 4, 4]);
        }
        for (k = [0 : n - 2]) translate([xc - (n - 1)*wb/2 + (k + 0.5)*wb - 8, sy*y - 2, d/2 - 14]) cube([16, 4, 8]);   // spring pockets
    }
}
module lead_truck()     { truck((LEAD[0][0] + LEAD[1][0])/2, 86, 2, 36); }
module trailing_truck() {                       // Delta trailing truck
    truck((TRAIL[0][0] + TRAIL[1][0])/2, 64, 2, 41);
    col(C_BLACK) hull() { translate([500, -16, 26]) cube([4, 32, 10]); translate([600, -40, 24]) cube([8, 80, 12]); }
}
module pilot_coupler() {
    col(C_BLACK) {
        translate([-2, -5, 28]) cube([16, 10, 8]);                    // Buckeye folding coupler head
        translate([10, -3, 29]) cube([30, 6, 6]);
        for (sy = [-1, 1]) translate([8, sy*26 - 4, 10]) cube([10, 8, 2]);   // pilot steps
    }
    col(C_STEEL) for (sy = [-1, 1]) rodbar([6, sy*18, 36], [18, sy*30, 44], max(FINE, 1.2));   // pilot grab irons
}

// ---------------------------------------------------------------- tender
module tender2d(i = 0) {      // section: straight sides, well-rounded top edges
    r = 14;
    hull() {
        translate([-(T_HALF_W - i), T_BOT + i]) square([2*(T_HALF_W - i), 1]);
        for (sy = [-1, 1]) translate([sy*(T_HALF_W - r - i), T_TOP - r - i]) circle(r);
    }
}
module tender_plan(i = 0) {   // plan view: rounded rear corners
    r = 22;
    hull() {
        translate([T_FRONT + i, -(T_HALF_W - i)]) square([1, 2*(T_HALF_W - i)]);
        for (sy = [-1, 1]) translate([T_BACK - r - i, sy*(T_HALF_W - r - i)]) circle(r);
    }
}
module tender_body_solid(i = 0) {
    intersection() {
        translate([T_FRONT, 0, 0]) rotate([90, 0, 90]) linear_extrude(T_BACK - T_FRONT) tender2d(i);
        translate([0, 0, T_BOT - 1]) linear_extrude(T_TOP - T_BOT + 2) tender_plan(i);
        // rear top edge rounded down
        hull() {
            translate([T_FRONT - 1, -100, 0]) cube([1, 200, T_TOP + 1]);
            translate([T_BACK - 40, -100, 0]) cube([1, 200, T_TOP + 1]);
            translate([T_BACK - i, -100, 0]) cube([0.01, 200, T_TOP - 26]);
        }
    }
}
module tender_body() {
    col(C_MAROON) difference() {
        union() {
            tender_body_solid();
            // coal bunker hood at the front, up to the cab roof line
            hull() {
                translate([T_FRONT, -48, T_TOP - 10]) cube([4, 96, 18]);
                translate([T_FRONT + 90, -40, T_TOP - 4]) cube([4, 80, 6]);
            }
        }
        if (SCALE != "FULL") tender_body_solid(WALL);
        translate([T_FRONT - 1, -26, 70]) cube([10, 52, 80]);           // coal space opening to the cab
    }
    // water hatch, top rails, rear ladders, footboards
    col(C_BLACK) translate([1010, 0, T_TOP - 1]) cylinder(d = 26, h = 4);
    col(C_STEEL) for (sy = [-1, 1]) {
        rodbar([T_FRONT + 100, sy*(T_HALF_W - 12), T_TOP + 4], [T_BACK - 50, sy*(T_HALF_W - 12), T_TOP + 4], max(FINE, 1.4));
        for (x = [T_FRONT + 100 : 90 : T_BACK - 50]) rodbar([x, sy*(T_HALF_W - 12), T_TOP - 2], [x, sy*(T_HALF_W - 12), T_TOP + 4], max(FINE, 1.2));
        for (z = [44 : 12 : 140]) translate([T_BACK - 2, sy*36 - 6, z]) cube([2.5, 12, max(FINE, 1.2)]);   // rear ladder rungs
        for (dy = [-6, 6]) translate([T_BACK - 2, sy*36 + dy - 0.8, 40]) cube([2.5, max(FINE, 1.6), 104]);
    }
    col(C_BLACK) translate([T_BACK - 4, -44, 30]) cube([12, 88, 3]);        // rear footboard
    col(C_BLACK) translate([T_BACK - 2, -5, 28]) cube([18, 10, 8]);        // rear coupler
}
module tender_paint() {
    col(C_ORANGE) intersection() { tender_body_solid(-0.25); translate([T_FRONT, -100, 98]) cube([T_BACK - T_FRONT, 200, 14]); }
    col(C_ORANGE) intersection() { tender_body_solid(-0.25); translate([T_FRONT, -100, 36]) cube([T_BACK - T_FRONT, 200, 8]); }
    col(C_MAROON) intersection() { tender_body_solid(-0.35); translate([T_FRONT, -100, 96]) cube([T_BACK - T_FRONT, 200, 2]); }
    if (COLOURS) col(C_STEEL) for (sy = [-1, 1]) translate([(T_FRONT + T_BACK)/2 + 20, sy*(T_HALF_W + 0.3), 124])
        rotate([90, 0, sy > 0 ? 180 : 0]) linear_extrude(0.4) mirror([1, 0, 0])
            text("THE MILWAUKEE ROAD", size = 10, halign = "center", font = "Liberation Serif:style=Bold");
}
module tender_wheels() { col(C_GREY) for (tc = T_TRUCKS) for (k = [-1, 0, 1]) axle(tc + k*T_WB, T_WHEEL) wheel(T_WHEEL); }
module tender_trucks() {
    for (tc = T_TRUCKS) truck(tc, T_WB, 3, T_WHEEL);
    col(C_BLACK) for (tc = T_TRUCKS) translate([tc - 30, -T_HALF_W + 4, T_BOT - 4]) cube([60, 2*T_HALF_W - 8, 4]);   // bolsters
}

// ---------------------------------------------------------------- rev C details
// Bell, whistle and horn: the 1938 article puts the whistle and air horn on the smokebox
// front under the nose doors; the ALCO elevation shows the horn mouth at the top front of
// the cowling. Bell position is not in the sources - best guess under the nose (TDQ-598).
module whistle() {              // three-chime whistle, standing on the smokebox front
    col([0.78, 0.66, 0.30]) translate([74, 0, 164]) {
        cylinder(d = 7, h = 14);                                   // bell of the whistle
        translate([0, 0, 14]) cylinder(d1 = 7, d2 = 4, h = 3);
        translate([0, 0, -6]) cylinder(d = 3, h = 6);              // stem
        translate([0, -2, -4]) rotate([0, 90, 0]) cylinder(d = 1.6, h = 10);   // valve lever
    }
}
module air_horn() {             // horn mouth looking forward out of the cowling front
    col(C_BLACK) translate([60, 0, 175]) rotate([0, -90, 0]) {
        cylinder(d1 = 3, d2 = 9, h = 12);
        translate([0, 0, -8]) cylinder(d = 3, h = 8);
    }
}
module bell() {
    col([0.80, 0.62, 0.25]) translate([60, 0, 21]) {
        rotate_extrude($fn = 48) polygon([[0, 0], [7.5, 0], [7.2, 2], [5.6, 6], [4.6, 10], [4.2, 12.5], [0, 13]]);
        translate([0, 0, 13]) cylinder(d = 2, h = 3);
    }
    col(C_BLACK) { translate([54, -6, 36]) cube([12, 12, 2]); translate([59, -1, 34]) cube([2, 2, 4]); }   // yoke bracket
}
module sand_pipes() {           // from the sandbox (under the cowling) down ahead of each driver
    col(C_BLACK) for (dw = DRIVER) for (sy = [-1, 1]) {
        rodbar([dw[0] - 50, sy*(GAUGE/2 + 1), 84], [dw[0] - 44, sy*(GAUGE/2 + 1), 10], max(FINE, 1.4));
    }
}
module brake_gear() {           // clasp brake shoes and hangers on the drivers
    col(C_BLACK) for (dw = DRIVER) for (sy = [-1, 1]) for (side = [-1, 1]) {
        a = side > 0 ? 200 : 340;
        translate([dw[0] + 43*cos(a), sy*(GAUGE/2 + 2.75) - 3, 42 + 43*sin(a) - 7]) cube([3, 6, 14]);
        rodbar([dw[0] + 43*cos(a), sy*(GAUGE/2 - 2), 42 + 43*sin(a)], [dw[0] + 30*cos(a), sy*(GAUGE/2 - 2), 76], max(FINE, 1.2));
    }
    col(C_BLACK) for (sy = [-1, 1]) translate([196, sy*30 - 6, 60]) rotate([0, 90, 0]) cylinder(d = 16, h = 12);   // driver brake cylinders
}
module generator() {            // Pyle-National turbo-generator on a bracket behind No. 3 driver
    col(C_BLACK) translate([476, -52, 66]) {
        rotate([0, 90, 0]) cylinder(d = 12, h = 22);
        translate([22, 0, 0]) rotate([0, 90, 0]) cylinder(d = 9, h = 8);
        translate([2, -2, -10]) cube([18, 4, 10]);
    }
}
module throttle_linkage() {     // front-end throttle arm and rod, left uncovered (article)
    col(C_STEEL) {
        rodbar([118, 46, 170], [118, 49, 158], max(FINE, 1.6));                    // throttle crank at the dome
        rodbar([118, 49, 158], [598, 52, 156], max(FINE, 1.4));                    // rod back to the cab
        for (x = [200:100:500]) rodbar([x, 48.5, 157], [x, 52, 157], max(FINE, 1));   // guides
    }
}
module injector_checks() {      // injector check valves and flue blower pipes, uncovered
    col(C_STEEL) for (sy = [-1, 1]) {
        translate([150, sy*48.5, 140]) rotate([sy*90, 0, 0]) cylinder(d1 = 7, d2 = 5, h = 4);
        rodbar([150, sy*50, 140], [596, sy*55, 128], max(FINE, 1.2));               // feed pipe to the cab
        rodbar([96, sy*48, 156], [596, sy*54, 162], max(FINE, 1.0));                // blower pipe
    }
}
module lubricators() {          // Nathan DV5 (right) and five-feed (left) on the running board
    col(C_BLACK) for (sy = [-1, 1]) translate([214, sy*56 - 5, 100]) {
        cube([18, 10, 12]);
        translate([4, 2, 12]) cube([10, 6, 2]);
    }
    col(C_BLACK) for (sy = [-1, 1]) rodbar([214, sy*56, 101], [CYL[0] + 18, sy*CYL[1], CYL[2] + 14], max(FINE, 0.9));
}
module access_panels() {        // hinged side panels over the air pumps behind the pilot (article)
    col(C_BLACK) for (sy = [-1, 1]) {
        translate([118, sy*(63.4) - 0.3, 52]) difference() { cube([46, 0.6, 30]); translate([1, -1, 1]) cube([44, 3, 28]); }
        for (z = [56, 76]) translate([120, sy*63.8 - 0.4, z]) cube([4, 0.8, 2]);    // hinges
    }
}
module plates() {               // chromium builder's plate and the Kuhler 'speedline' name plate
    col(C_STEEL) for (sy = [-1, 1]) {
        translate([296, sy*63.2, 90]) rotate([sy*90, 0, 0]) scale([1.6, 1, 1]) cylinder(d = 7, h = 0.5, center = true);
        translate([CYL[0] - 6, sy*(CYL[1] + CYL[3]/2 + 0.6), CYL[2] + 2]) cube([12, 0.5, 4], center = true);
    }
}
module cylinder_cocks() {
    col(C_BLACK) for (sy = [-1, 1]) for (dx = [-14, 14])
        rodbar([CYL[0] + dx, sy*CYL[1], CYL[2] - CYL[3]/2], [CYL[0] + dx*1.4, sy*CYL[1], 20], max(FINE, 1.0));
}
module speed_recorder() {       // Valve Pilot speed recorder drive off the trailing truck
    col(C_BLACK) translate([600, -56, 22]) { cube([8, 6, 10]); rodbar([4, 3, 10], [4, 3, 30], max(FINE, 1)); }
}
module pilot_hoses() {          // train line air and signal hoses either side of the coupler
    col(C_BLACK) for (sy = [-1, 1]) rodbar([10, sy*12, 30], [4, sy*14, 16], max(FINE, 2));
    col(C_STEEL) for (sy = [-1, 1]) translate([4, sy*14 - 1.5, 13]) cube([3, 3, 4]);
}
module cab_roof() {             // roof ventilator, sun visors, cab number lamp
    col(C_GREY) translate([650, -12, CAB[3] - 3]) cube([24, 24, 5]);
    col(C_STEEL) for (sy = [-1, 1]) translate([606, sy*(CAB_HALF_W - 6) - 6, 145]) rotate([0, 20, 0]) cube([1, 12, 6]);
    col(C_BLACK) for (sy = [-1, 1]) for (w = CAB_WINDOWS) translate([w[0] - 1, sy*(CAB_HALF_W + 0.5) - 0.5, w[3] + 2]) cube([w[1] - w[0] + 2, sy*3 + 1, 1]);
}
module tender_details() {
    // back-up light and marker lamps at the rear, front steps and grab irons, air hoses
    col(C_BLACK) translate([T_BACK - 2, -6, 128]) cube([6, 12, 12]);
    col([1, 0.95, 0.75]) translate([T_BACK + 4, 0, 134]) rotate([0, 90, 0]) cylinder(d = 8, h = 0.5);
    col(C_BLACK) for (sy = [-1, 1]) translate([T_BACK - 4, sy*(T_HALF_W - 8) - 3, 140]) {
        cube([6, 6, 7]);
        col([0.9, 0.2, 0.15]) translate([6, 1, 1.5]) cube([0.5, 4, 4]);
    }
    col(C_BLACK) for (sy = [-1, 1]) for (z = [20, 32]) translate([T_FRONT + 4, sy*(T_HALF_W - 2) - 2, z]) cube([16, 4, 2]);
    col(C_STEEL) for (sy = [-1, 1]) rodbar([T_FRONT + 6, sy*(T_HALF_W + 2), 50], [T_FRONT + 6, sy*(T_HALF_W + 2), 120], max(FINE, 1.4));
    col(C_BLACK) for (sy = [-1, 1]) rodbar([T_BACK + 6, sy*12, 30], [T_BACK + 12, sy*14, 16], max(FINE, 2));
    // tender brake cylinders and air reservoir under the frame
    col(C_BLACK) for (tc = T_TRUCKS) translate([tc - 7, -7, T_WHEEL/2 + 4]) cube([14, 14, 10]);
    col(C_BLACK) translate([900, 0, 30]) rotate([0, 90, 0]) cylinder(d = 18, h = 120);
}

// ---------------------------------------------------------------- groups
module details() {
    stainless_bands(); headlight(); handrails(); marker_lamps();
    whistle(); air_horn(); bell(); sand_pipes(); brake_gear(); generator(); throttle_linkage();
    injector_checks(); lubricators(); access_panels(); plates(); cylinder_cocks(); speed_recorder();
    pilot_hoses(); cab_roof();
}
module engine() {
    col(C_GREY) shroud_solid(); if (COLOURS) shroud_paint();
    details();
    cab(); frame(); cylinders();
    drivers(); lead_wheels(); trail_wheels(); rods();
    lead_truck(); trailing_truck(); pilot_coupler();
}
module tender() {
    tender_body(); if (COLOURS) tender_paint();
    tender_wheels(); tender_trucks(); tender_details();
}
module piece(cuts, x0, x1, n) {
    edges = concat([x0], cuts, [x1]);
    if (n == 0) children();
    else intersection() { children(); translate([edges[n-1], -200, -50]) cube([edges[n] - edges[n-1], 400, 400]); }
}
module print_part(p) {
    if (p == "shroud")             piece(SHROUD_CUTS, 0, 640, PIECE) shroud_solid();
    else if (p == "tender_body")   piece(TENDER_CUTS, T_FRONT, T_BACK + 20, PIECE) tender_body();
    else if (p == "cab")           cab();
    else if (p == "frame")         frame();
    else if (p == "cylinders")     cylinders();
    else if (p == "driver")        boxpok(84);
    else if (p == "lead_wheel")    wheel(36);
    else if (p == "trailing_wheel_front") wheel(38);
    else if (p == "trailing_wheel_rear")  wheel(44);
    else if (p == "tender_wheel")  wheel(T_WHEEL);
    else if (p == "rods")          rods(0);
    else if (p == "lead_truck")    lead_truck();
    else if (p == "trailing_truck") trailing_truck();
    else if (p == "tender_truck")  truck(0, T_WB, 3, T_WHEEL);
    else if (p == "pilot_coupler") pilot_coupler();
    else if (p == "details")       details();
}

// ---------------------------------------------------------------- output
if (PART == "assembly")      place() { engine(); tender(); }
else if (PART == "engine")   place() engine();
else if (PART == "tender")   place() tender();
else                         place() print_part(PART);

echo(str("F7 No. 100 rev E  scale ", SCALE, "  length over couplers ", TOTAL_LEN*K,
         SCALE == "FULL" ? " ft" : " mm", "  height ", MAX_H*K));
