// =====================================================================
//  MILWAUKEE ROAD (C.M.&St.P.) - BRODHEAD, WIS. FREIGHT AND PASSENGER DEPOT (1881)
//  Mineral Point Division (Janesville - Brodhead - Monroe), now the WSOR.
//  Stands: 1108 1st Center Ave - Brodhead Historical Society Depot Museum (since 1981).
//  Rib Side Works, 26 Nov 2026, rev 2 (hand-built - do not regenerate).
//
//  SOURCES (no album sheet or MPL plan exists for this depot):
//   - Sanborn maps, Library of Congress sanborn09509 (public domain):
//       1887 / 1900: "Freight & Passgr Depot (Veneered)" - brick veneer on frame,
//         1 storey, shingle roof, about 30 x 103 ft, three-sided bay on the
//         NORTH (track) side about 31 ft from the WEST end; platforms both sides.
//       1915: same building, wall height "16'", plus a 1-storey FRAME addition
//         about 29 x 30 ft on the EAST end (not on the 1900 sheet), with a
//         3 ft high freight platform on its south side.
//   - NRHP 84000724 (Brodhead commercial district, map no. 1): cream brick, now
//     painted yellow; frame covered with one layer of brick; gently pitched gable
//     roof, widely projecting eaves on large wooden brackets; stilted segmental
//     brick hoods over every opening; three round-headed windows in the west
//     gable; one window in the east gable; bay window on the north wall.
//   - Brodhead Historical Society photo, c.1914 looking east (item 9571): west
//     gable - triple round-arched window, "BRODHEAD" board below it, a second
//     board above that, brackets under the rake, chimney near the west end.
//     Roof pitch measured from it about 7 in 12. Photos are private reference.
//   - Monroe Times: rebuilt after a July 1881 fire with ladies' and men's waiting
//     rooms, telegraph office, baggage room and freight room. Tracks on the north
//     side (Tom, 25 Nov 2026).
//  KNOWN: footprint, 1 storey, 16 ft walls, bay position, gable windows, roof type,
//   brackets, brick veneer, cream brick, the east frame addition and its dates.
//  ESTIMATE: roof pitch (from the photo), 5 ft eaves, room order, every side-wall
//   window and door position, second chimney, the addition's roof and doors,
//   trim colours. The 2017-18 "Knight addition" (museum) is NOT modelled.
//  ERA: 1887 = as built (default)  |  1915 = with the east frame addition
//       2026 = museum today: yellow paint, frame addition kept (ESTIMATE).
//  x along the track from the WEST end, y = 0 town (south) side, +y north = track.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
ERA = is_undef(ERA_SET) ? 1887 : ERA_SET;      // Brodhead_Depot_2026.scad sets ERA_SET = 2026; or -D ERA=1915
include <../../../_common/rsw_depot.scad>

PRESENT = ERA >= 2000;
ADDN = ERA >= 1915;
// Colours as built: natural cream brick (NRHP); trim, roof and doors are the MR defaults
// (ESTIMATE - no colour photo).  Today's colours are in Brodhead_Depot_2026.scad.
// Plain "#hex" lines so make_glb.py can read them.
COL_BRICK = "#D8C9A3";
COL_TRIM  = "#55585A";
COL_SASH  = "#55585A";
COL_BODY  = "#BDBDB6";   // east addition siding
COL_ROOF  = "#4E4A46";
COL_STONE = "#B9B0A0";   // sills, water table
COL_DOOR  = "#4A2E1C";
FLOOR = 1.5;

L = 103;  W = 30;  PLATE = 16;  RISE = 0.58;  OV = 5;  RAKE = 3;
RIDGE = PLATE + RISE * W / 2;
// rooms (ESTIMATE from the openings): ladies 0-24, office 24-36 (bay), men's 36-52, baggage 52-62, freight 62-103
AL = 29;  AW = 30;  AFLOOR = 3;  APLATE = 12;  ARISE = 0.44;  // east frame addition (Sanborn 1915; Street View today)

BLOCKS = [[0, L, 0, W, PLATE, RISE, 5, OV, 2]];

// segmental (stilted) windows: [x, side, w, h(to springing), sill]   sides: 0 town (S), 1 track (N), 2 west end, 3 east end
WH = 7.5;  WS = 3.2;
// Track side MEASURED from two Street View stills (bearings + 103 ft length): win 6, door 13.5,
// win 20.7, [27.1, 31.5 today = where the bay was], door 38.8, win 46.4, wide arched door 57.4.
// Town side: ESTIMATE (hidden behind loco 781) - same rhythm as the track side.
WINS = concat(
  [[6, 1, 3, WH, WS], [20.7, 1, 3, WH, WS], [46.4, 1, 3, WH, WS]],
  ERA >= 2000 ? [[27.1, 1, 3, WH, WS], [31.5, 1, 3, WH, WS]] : [],
  [[6, 0, 3, WH, WS], [20.7, 0, 3, WH, WS], [27.1, 0, 3, WH, WS], [31.5, 0, 3, WH, WS], [46.4, 0, 3, WH, WS]],
  [[5, 2, 3, WH, WS], [15, 2, 3, WH, WS], [25, 2, 3, WH, WS]]);                                                  // west end: three (Street View)
// doors: [x, side, w, h, type]  type 0 passenger, 1 baggage double, 2 freight slider
DOORS = concat(
  [[13.5, 1, 3.5, 8.5, 0], [38.8, 1, 3.5, 8.5, 0], [57.4, 1, 6.5, 9, 1]],
  ERA >= 2000 ? [] : [[76, 1, 8, 9, 2], [92, 1, 8, 9, 2]],                                                       // freight doors (ESTIMATE; wall is blank today)
  [[13.5, 0, 3.5, 8.5, 0], [38.8, 0, 3.5, 8.5, 0], [57.4, 0, 6.5, 9, 1], [84, 0, 8, 9, 2]],
  ADDN ? [] : [[15, 3, 7, 9, 2]]);                                                                               // east end (covered by the addition)
BAY = [30.5, 11, 3.5];        // centre from west end, width at the wall, depth (Sanborn 1887-1915; gone today)
CHIMS = [[29, W / 2, RIDGE + 3.5]];                                                                              // one chimney near the office (Street View)

// ---- walls, foundation, water table ----
module walls() {
    paint("brick") difference() {
        union() {
            fbox(0, 0, 0.5, L, W, PLATE - 0.5);
            for (x = [0, L - 0.8]) translate([ft(x), 0, ft(PLATE)]) rotate([90, 0, 90])
                linear_extrude(ft(0.8)) polygon([[0, 0], [ft(W), 0], [ft(W / 2), ft(RISE * W / 2)]]);
        }
        openings_cut();
    }
    paint("foundation") fbox(-0.2, -0.2, 0, L + 0.4, W + 0.4, 0.5);
    paint("stone") difference() { fbox(-0.25, -0.25, 0.5, L + 0.5, W + 0.5, 0.9); openings_cut(); }
    paint("brick") fbox(-0.25, -0.25, PLATE - 1.0, L + 0.5, W + 0.5, 0.5);          // corbel course under the eave
    for (x = [0, L - 0.8]) paint("brick")                                             // belt at the gable base
        fbox(x - (x == 0 ? 0.25 : 0), -0.25, PLATE, 1.05, W + 0.5, 0.35);
}

// ---- openings ----
function seg_r(w) = w * 0.75;
function seg_zc(w, h, sill) = sill + h - sqrt(pow(seg_r(w), 2) - pow(w / 2, 2));
module seg_shape(w, h, sill, grow = 0) {
    translate([-ft(w / 2 + grow), ft(sill - grow)]) square([ft(w + 2 * grow), ft(h + grow)]);
    intersection() {
        translate([0, ft(seg_zc(w, h, sill))]) circle(ft(seg_r(w) + grow), $fn = 64);
        translate([-ft(w / 2 + grow), ft(sill + h)]) square([ft(w + 2 * grow), ft(3)]);
    }
}
module face(x, side) on_face(BLOCKS[0], x, side) children();
GZ = PLATE + 1.2;                                     // gable window sill
module rnd_shape(w, h) { translate([-ft(w / 2), ft(GZ)]) square([ft(w), ft(h)]); translate([0, ft(GZ + h)]) circle(ft(w / 2), $fn = 40); }
GW = 1.6;  GH = 3.4;  GDX = 2.3;                      // west gable arcade (photo)
module openings_cut() {
    for (o = WINS) face(o[0], o[1]) translate([0, 0, -ft(2)]) linear_extrude(ft(3)) seg_shape(o[2], o[3], o[4]);
    for (o = DOORS) face(o[0], o[1]) translate([0, 0, -ft(2)]) linear_extrude(ft(3))
        if (o[4] == 2) translate([-ft(o[2] / 2), ft(FLOOR)]) square([ft(o[2]), ft(o[3])]);
        else seg_shape(o[2], o[3], FLOOR);
    if (ERA < 2000) translate([ft(BAY[0] - BAY[1] / 2 + 0.6), ft(W - 1), ft(FLOOR + 1)]) cube([ft(BAY[1] - 1.2), ft(2), ft(10)]);
    for (dx = [-GDX, 0, GDX]) face(W / 2 + dx, 2) translate([0, 0, -ft(2)]) linear_extrude(ft(3)) rnd_shape(GW, GH);
    face(W / 2, 3) translate([0, 0, -ft(2)]) linear_extrude(ft(3)) rnd_shape(2.4, GH);
}

module seg_window(w, h, sill) {
    paint("glass") translate([0, 0, ft(0.45)]) linear_extrude(ft(0.06)) seg_shape(w, h, sill);
    paint("sash") translate([0, 0, ft(0.4)]) linear_extrude(ft(0.15)) {
        difference() { seg_shape(w, h, sill); seg_shape(w - 0.5, h - 0.25, sill + 0.25); }
        translate([-ft(w / 2), ft(sill + h * 0.55)]) square([ft(w), ft(0.15)]);
        translate([-ft(0.06), ft(sill)]) square([ft(0.12), ft(h + 1)]);
    }
    hood(w, h, sill);
    paint("stone") translate([-ft(w / 2 + 0.3), ft(sill - 0.35), 0]) cube([ft(w + 0.6), ft(0.35), ft(0.3)]);
}
module hood(w, h, sill) paint("brick") linear_extrude(ft(0.25)) difference() {   // stilted segmental brick hood
    union() {
        intersection() {
            translate([0, ft(seg_zc(w, h, sill))]) circle(ft(seg_r(w) + 0.7), $fn = 64);
            translate([-ft(w / 2 + 0.7), ft(sill + h - 0.5)]) square([ft(w + 1.4), ft(4)]);
        }
        for (s = [-1, 1]) translate([s * ft(w / 2 + 0.35) - ft(0.35), ft(sill + h - 1.2)]) square([ft(0.7), ft(1.2)]);
    }
    seg_shape(w, h, sill);
}
module slider(w, h) {
    paint("doors") translate([-ft(w / 2), ft(FLOOR), ft(0.4)]) cube([ft(w), ft(h), ft(0.15)]);
    paint("trim") {
        translate([-ft(w / 2 + 0.5), ft(FLOOR + h + 0.1), 0]) cube([ft(2 * w + 0.6), ft(0.3), ft(0.3)]);
        for (k = [0, 1]) translate([-ft(w / 2) + k * ft(w - 0.3), ft(FLOOR), ft(0.55)]) cube([ft(0.3), ft(h), ft(0.12)]);
        hull() { translate([-ft(w / 2), ft(FLOOR), ft(0.55)]) cube([ft(0.3), ft(0.3), ft(0.12)]);
                 translate([ft(w / 2 - 0.3), ft(FLOOR + h - 0.3), ft(0.55)]) cube([ft(0.3), ft(0.3), ft(0.12)]); }
    }
}
module seg_door(w, h, type) {
    if (type == 2) {
        slider(w, h);
        paint("stone") translate([-ft(w / 2 + 0.6), ft(FLOOR + h + 0.4), 0]) cube([ft(w + 1.2), ft(0.6), ft(0.3)]);
    } else {
        paint("doors") translate([0, 0, ft(0.4)]) linear_extrude(ft(0.12)) seg_shape(w, h, FLOOR);
        paint("glass") translate([-ft(w / 2 - 0.25), ft(FLOOR + h - 0.1), ft(0.45)]) cube([ft(w - 0.5), ft(1), ft(0.1)]);
        if (type == 1) paint("trim") translate([-ft(0.07), ft(FLOOR), ft(0.5)]) cube([ft(0.14), ft(h - 0.2), ft(0.1)]);
        hood(w, h, FLOOR);
    }
}

// ---- operator's bay (track side) ----
module op_bay() {
    x = BAY[0]; w = BAY[1]; d = BAY[2]; bh = 12.5;
    pts = [[-w / 2, 0], [w / 2, 0], [w / 2 - d * 0.7, d], [-w / 2 + d * 0.7, d]];
    paint("brick") translate([ft(x), ft(W - 0.2), ft(0.5)]) linear_extrude(ft(bh - 0.5)) polygon([for (p = pts) [ft(p[0]), ft(p[1])]]);
    paint("stone") translate([ft(x), ft(W - 0.2), ft(0.5)]) linear_extrude(ft(0.9)) offset(delta = ft(0.25)) polygon([for (p = pts) [ft(p[0]), ft(p[1])]]);
    paint("roof") translate([ft(x), ft(W - 0.2), ft(bh)]) linear_extrude(ft(1.4), scale = 0.2)
        polygon([for (p = pts) [ft(p[0] * 1.1), ft(p[1] * 1.2)]]);
    fw = w - 2 * d * 0.7;  sw = sqrt(pow(d, 2) + pow(d * 0.7, 2));  ang = atan2(d, d * 0.7);
    translate([ft(x), ft(W + d - 0.2), 0]) rotate([90, 0, 180]) translate([0, 0, -0.02]) seg_window(fw - 1.4, WH, WS);
    for (s = [-1, 1]) translate([ft(x + s * (w / 2 - d * 0.35)), ft(W - 0.2 + d / 2), 0])
        rotate([0, 0, s * (90 - ang)]) rotate([90, 0, 180]) translate([0, 0, -0.02]) seg_window(sw - 1.3, WH, WS);
}

// ---- roof and brackets ----
module gable_roof(x0, l, y0, w, plate, rise, ov, rake) {
    ridge = plate + rise * w / 2;
    paint("roof") for (s = [0, 1]) hull() {
        fbox(x0 - rake, s ? y0 + w + ov - 0.1 : y0 - ov, plate - ov * rise, l + 2 * rake, 0.1, 0.5);
        fbox(x0 - rake, y0 + w / 2 - 0.05, ridge, l + 2 * rake, 0.1, 0.5);
    }
    paint("trim") {
        for (s = [0, 1]) fbox(x0 - rake, s ? y0 + w + ov - 0.3 : y0 - ov - 0.2, plate - ov * rise - 0.8, l + 2 * rake, 0.5, 0.9);
        for (x = [x0 - rake, x0 + l + rake - 0.4], s = [0, 1]) hull() {
            fbox(x, s ? y0 + w + ov - 0.3 : y0 - ov, plate - ov * rise - 0.7, 0.4, 0.3, 0.7);
            fbox(x, y0 + w / 2 - 0.15, ridge - 0.3, 0.4, 0.3, 0.7);
        }
    }
}
module bracket(o) paint("trim") linear_extrude(ft(0.5), center = true)    // large scrolled bracket, outward in +x
    polygon([[0, 0], [0, ft(4)], [ft(o - 0.4), ft(4)], [ft(o - 0.4), ft(3.4)], [ft(o * 0.4), ft(2.6)], [ft(o * 0.22), ft(1.2)], [ft(0.45), ft(0.3)]]);
module brackets() {
    zb = PLATE - OV * RISE - 3.9;
    for (x = [3.5 : 7 : L - 2]) {                                                // about 7 ft apart (Street View)
        if (ERA >= 2000 || abs(x - BAY[0]) > BAY[1] / 2 + 0.3) translate([ft(x), ft(W), ft(zb)]) rotate([90, 0, 90]) bracket(OV);
        translate([ft(x), 0, ft(zb)]) rotate([90, 0, -90]) bracket(OV);
    }
    for (y = [3, 8.5, W - 8.5, W - 3], e = [0, 1]) if (!(e == 1 && ADDN))   // rake brackets
        translate([e ? ft(L) : 0, ft(y), ft(PLATE + RISE * min(y, W - y) - 3.6)])
            rotate([90, 0, e ? 0 : 180]) scale([RAKE / OV, 1, 1]) bracket(OV);
}

// ---- station boards on the west gable (photo); board on the east gable until the addition ----
BOARD = ERA >= 2000 ? "sash" : "stone";               // white board, dark letters
module boards(e) face(W / 2, e ? 3 : 2) {
    paint(BOARD) translate([-ft(5.5), ft(PLATE - 2.6), 0]) cube([ft(11), ft(1.7), ft(0.25)]);
    paint("doors") translate([0, ft(PLATE - 2.25), ft(0.25)]) linear_extrude(ft(0.08))
        text("BRODHEAD", size = ft(1.0), font = "Liberation Sans:style=Bold", halign = "center");
    if (!e) paint(BOARD) translate([-ft(4.5), ft(PLATE - 0.4), 0]) cube([ft(9), ft(0.9), ft(0.2)]);
}

// ---- east frame addition (Sanborn: not in 1900, there by 1915) ----
// 1915: frame, drop siding, freight sliders, 3 ft platform on the south side (Sanborn).
// Today (Street View): re-sided in ribbed steel on a 3 ft concrete base, overhead garage door
// and one window in the east end, plain red trim.  Doors in 1915 are ESTIMATE.
module addition() {
    x0 = L;  now = ERA >= 2000;
    paint("foundation") fbox(x0, 0, 0, AL, AW, AFLOOR);
    paint("walls") difference() {
        union() {
            fbox(x0, 0, AFLOOR, AL, AW, APLATE - AFLOOR);
            translate([ft(x0 + AL - 0.5), 0, ft(APLATE)]) rotate([90, 0, 90])
                linear_extrude(ft(0.5)) polygon([[0, 0], [ft(AW), 0], [ft(AW / 2), ft(ARISE * AW / 2)]]);
        }
        if (!now) for (s = [0, 1]) translate([ft(x0 + AL / 2 - 4), s ? ft(AW - 1) : -ft(0.5), ft(AFLOOR + 0.2)]) cube([ft(8), ft(1.5), ft(7.5)]);
        if (now) { translate([ft(x0 + AL - 1), ft(4), ft(AFLOOR + 0.1)]) cube([ft(2), ft(9), ft(7.6)]);
                   translate([ft(x0 + AL - 1), ft(19), ft(AFLOOR + 4)]) cube([ft(2), ft(4), ft(2.6)]); }
    }
    if (!now) paint("trim") for (z = [AFLOOR + 0.6 : 0.6 : APLATE - 0.3]) for (s = [0, 1])   // drop siding lines
        fbox(x0, s ? AW : -0.06, z, AL, 0.06, 0.08);
    if (now) paint("walls") for (x = [x0 + 0.75 : 0.75 : x0 + AL - 0.3]) for (s = [0, 1])  // steel ribs
        fbox(x, s ? AW : -0.08, AFLOOR, 0.12, 0.08, APLATE - AFLOOR);
    paint("trim") for (xx = [x0, x0 + AL - 0.4], yy = [-0.1, AW - 0.3]) fbox(xx, yy, AFLOOR, 0.4, 0.4, APLATE - AFLOOR);
    if (!now) for (s = [0, 1]) translate([ft(x0 + AL / 2), s ? ft(AW) + 0.01 : -0.01, 0]) rotate([90, 0, s ? 180 : 0]) translate([0, ft(AFLOOR - FLOOR + 0.2), 0]) slider(8, 7.5);
    if (now) {
        paint("doors") fbox(x0 + AL - 0.45, 4, AFLOOR + 0.1, 0.1, 9, 7.6);                            // overhead door
        paint("sash")  for (z = [AFLOOR + 1.9 : 1.9 : AFLOOR + 7]) fbox(x0 + AL - 0.4, 4, z, 0.1, 9, 0.1);
        paint("trim")  { fbox(x0 + AL - 0.4, 3.6, AFLOOR, 0.15, 0.4, 8.1); fbox(x0 + AL - 0.4, 13, AFLOOR, 0.15, 0.4, 8.1); fbox(x0 + AL - 0.4, 3.6, AFLOOR + 7.7, 0.15, 9.8, 0.4); }
        paint("glass") fbox(x0 + AL - 0.45, 19, AFLOOR + 4, 0.1, 4, 2.6);
        paint("sash")  { fbox(x0 + AL - 0.4, 18.8, AFLOOR + 3.8, 0.15, 4.4, 0.2); fbox(x0 + AL - 0.4, 18.8, AFLOOR + 6.6, 0.15, 4.4, 0.2); fbox(x0 + AL - 0.4, 20.95, AFLOOR + 4, 0.15, 0.1, 2.6); }
        paint("foundation") fbox(x0 + AL, 4, AFLOOR - 0.4, 2, 9, 0.4);                                // dock ledge under the door
    }
    gable_roof(x0, AL, 0, AW, APLATE, ARISE, 2, 1.5);
    if (!now) paint("platform") fbox(x0 - 20, -10, 0, AL + 20, 10, AFLOOR);                         // 3 ft freight platform, south side
}

// ---- platform (track side brick/plank, town side walk) ----
module platform() paint("platform") { fbox(-15, W, 0, L + (ADDN ? AL : 0) + 30, 16, 0.6); fbox(-15, -10, 0, ADDN && ERA < 2000 ? L - 20 + 15 : L + (ADDN ? AL : 0) + 30, 10, 0.4); }

// ---- the depot ----
walls();
for (o = WINS) face(o[0], o[1]) seg_window(o[2], o[3], o[4]);
for (o = DOORS) face(o[0], o[1]) seg_door(o[2], o[3], o[4]);
for (dx = [-GDX, 0, GDX]) face(W / 2 + dx, 2) {
    paint("glass") translate([0, 0, ft(0.45)]) linear_extrude(ft(0.06)) rnd_shape(GW, GH);
    paint("brick") linear_extrude(ft(0.25)) difference() { offset(delta = ft(0.35)) rnd_shape(GW, GH); rnd_shape(GW, GH); }
}
paint("stone") face(W / 2, 2) translate([-ft(3.6), ft(GZ - 0.35), 0]) cube([ft(7.2), ft(0.35), ft(0.3)]);
if (!ADDN) face(W / 2, 3) { paint("glass") translate([0, 0, ft(0.45)]) linear_extrude(ft(0.06)) rnd_shape(2.4, GH);
                            paint("brick") linear_extrude(ft(0.25)) difference() { offset(delta = ft(0.35)) rnd_shape(2.4, GH); rnd_shape(2.4, GH); } }
if (ERA < 2000) op_bay();
gable_roof(0, L, 0, W, PLATE, RISE, OV, RAKE);
brackets();
boards(0);
for (c = CHIMS) paint("chimney") { fbox(c[0] - 1, c[1] - 1.3, PLATE, 2, 2.6, c[2] - PLATE); fbox(c[0] - 1.2, c[1] - 1.5, c[2] - 0.6, 2.4, 3, 0.6); }
if (ADDN) addition();
platform();
