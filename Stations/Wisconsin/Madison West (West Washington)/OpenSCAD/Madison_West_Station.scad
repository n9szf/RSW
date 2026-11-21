// =====================================================================
//  MILWAUKEE ROAD - WEST MADISON PASSENGER STATION
//  640 West Washington Ave, Madison, Wisconsin. Built 1903,
//  architects Frost & Granger. Rib Side Works, HO scale (1:87.1); G (1:29) by SCALE.
//
//  DRAWN FROM the railroad's own 1903-04 drawings (Milwaukee Public
//  Library, Milwaukee Road Drawing Collection, "West Madison Passenger
//  Station", 14 sheets, scale 1/8 in = 1 ft; copies are private
//  reference in RSW / reference / Stations / Wisconsin).
//
//  KNOWN - figures read from the drawings:
//    depot 140 ft long; 37 ft 10 in gap; baggage + express building
//    63 ft long (240 ft 10 in over all); general waiting room 60 x 36;
//    roof trusses and arches at 20 ft centres; baggage room 23 ft deep;
//    platform shed runs 65 ft from the depot to the Washington Ave gate.
//  MEASURED - scaled off the 1/8 in drawings with a ruler (to about
//    +/- 6 in): every height, the 100 ft / 40 ft split of main block and
//    wing, depths, window and door sizes and positions.
//  1940 VERSION (14 Oct) - from the 1985 National Register nomination,
//    the Wisconsin Historical Society record, and Tom's photos of the
//    building today (9 Oct, Photos (private) / 2026-10-09 Tom):
//    - main town-side door at the Washington Ave end closed and its
//      porch gone; an arched window in its place (photo).
//    - two waiting room arch windows (first and third) made into doors.
//    - a flat Moderne marquee with an ENTRANCE blade sign over the third
//      arch (photo; the nomination's "68 ft" does not match the marquee
//      standing today, which is about 18 ft - see TDQ).
//    - 155 ft of narrower canopy north of the baggage building: centre
//      posts with braces both ways and a low gable roof (photo).
//    - baggage building two storeys since the 1928 roof raise (photo).
//    - road name on the end panel C. M. ST. P. & P. (the name from 1928).
//    - round roof vents (dormers): lost, date unknown; left off for 1940.
//    - cornice is metal, painted bronze green like the trim (1903 sheet;
//      the photos show it today as green copper).
//
//  WAITING ROOM INTERIOR (20 Nov, TDQ-548) - from six railroad photos of
//    6 Feb 1941 (Photos (private) / 1941-02-06 waiting room album): the
//    general waiting room (60 x 36, KNOWN) between the two end pavilions,
//    hollowed out with a coffered, beamed ceiling and dentil cornice, dark
//    wood wainscot, the TICKETS wall with four windows and BULLETIN boards
//    at the Washington Ave end, the NEWS - RESTAURANT doorway with WOMEN and
//    MEN doors at the wing end, double-sided oak benches and the white
//    open-slat 1940 hanging lights. Which end is which comes from the
//    photos (track side on the right when facing the ticket windows).
//    Sizes are judged from the photos against the known room size.
//
//  SCALES: SCALE = 87.1 HO, 48 O, 29 G - or open Madison_West_Station_HO /
//  _O / _G.scad, which set it for you.
//
//  THIS IS THE SHAPE MODEL for review. It is not yet cut into printable
//  sections.
//
//  Layout: x = feet from the Washington Ave end of the depot, running
//  toward the baggage building. y = 0 is the town (street) side wall,
//  the track side is +y. z = 0 is the platform.
// =====================================================================

SCALE   = 87.1;     // 87.1 = HO (Tom 10/14: print in HO)   48 = O   29 = G   (Tom 11/20: all scales)
ERA     = 1940;     // 1903 = as drawn    1940 = marquee, long canopy, raised baggage roof
DORMERS = ERA < 1940;   // the small round roof vents; removed at an unknown date - ESTIMATE: gone by 1940
PAINT   = "";       // "" = full colour; a colour name (e.g. "brick") = only the parts in that colour, for STL export to Blender / multi-colour printing
SHOW    = "all";    // all, depot, baggage, canopy, gate, platform, signs, interior
INTERIOR = true;    // waiting room hollowed out and fitted as in Feb 1941 (TDQ-548)
MIN_MM  = 0.4;      // thinnest printable part in mm (rods, slats, sign letters): small parts never go below this
// Station signs, from sheet 14 "Proposed Station Signs for Madison, Wis.": No. 26 galvanised iron letters
// planted on the brick wall, painted bronze green to match the trim. One on the panel high on the
// Washington Ave end, one on the gate wall. 1903 wording as drawn; by 1940 the road was the
// C. M. St. P. & P. (reorganised 1928) and the end panel reads so today. MADISON stayed on the gate
// until the later "The Milwaukee Road" sign (National Register nomination).
SIGN_ROAD = ERA >= 1940 ? "C. M. ST. P. & P." : "C. M. & ST. P. RY.";
SIGN_TOWN = "\u00B7 MADISON \u00B7";
SIGN_FONT = "Liberation Serif:style=Bold";

function f(ft) = ft * 304.8 / SCALE;
function t(ft) = max(f(ft), MIN_MM);     // size for thin parts: true size, but never thinner than MIN_MM

// ---------------- sizes in feet ----------------
main_l = 100;  main_w = 40;      // main block (waiting room + end pavilions)      MEASURED
wing_l = 40;   wing_w = 38;      // lunch room / kitchen wing, set in 2 ft on the town side   MEASURED
bay    = 20;                     // arch and truss spacing                          KNOWN
base_h = 4;                      // stone base (water table)                        MEASURED
eave_h = 27;   ridge_h = 41;     // main block                                      MEASURED
weave_h = 22;  wridge_h = 33;    // wing                                            MEASURED
ov     = 3.5;                    // eave overhang                                   MEASURED
arch_w = 11.5; arch_top = 24;    // big arches                                      MEASURED
gap    = 37 + 10/12;             // depot to baggage building                       KNOWN
bag_l  = 63;   bag_w = 25;       // baggage + express building                      KNOWN / MEASURED
bag_eave = ERA >= 1940 ? 22 : 14.5;   bag_rise = 8.5;   // 1928: roof raised for a meeting room   1940 height ESTIMATE
can_out = 15;                    // post row out from the track-side wall           MEASURED (Washington Ave elevation)
can_h   = 10.5;                  // canopy eave above the platform                  MEASURED
shed_l  = 65;  shed_w = 30;      // gabled shed from the depot to the gate, centred on the track-side wall   KNOWN / MEASURED
gate_h  = 16.3;                  // gate piers to the top of the stone cap          MEASURED
can_ext = 155;                   // 1940 canopy extension, narrower                 KNOWN length
ext_w  = 16;   ext_y = main_w + 9;    // its width and the line of its centre posts      ESTIMATE from the photos
mq_w = 18;  mq_out = 6.5;  mq_z = 13.5;   // 1940 marquee over the third arch, town side   ESTIMATE from the photos
// waiting room (1941 photos)
WALL   = 1.5;                    // brick wall thickness                            ESTIMATE
wr_x0  = 20;  wr_x1 = 80;        // general waiting room 60 ft between the pavilions   KNOWN (60 x 36 room)
floor_z = base_h - 1.2;          // floor level = sill of the arch doors
ceil_z  = 25.5;                  // ceiling, above the tops of the arches (24 ft)  ESTIMATE from the photos
wain_h  = 5;                     // dark wood wainscot                              ESTIMATE from the photos

plaster = "#D8CDB0"; wood = "#4E3220"; oak = "#8A6238"; floorc = "#B5AC9A"; lampw = "#F2EFE6"; board = "#1C1C1C";
brick = "#C4682E"; band = "#B55E28"; stone = "#D8D2C0"; slate = "#4A4E52"; trim = "#2F4A3A"; glass = "#1E2A33"; pave = "#8E5A45"; metal = "#5E6B5E";
T = main_w;   // y of the track-side wall

// ---------------- helpers ----------------
PAINTS = [["brick", brick], ["band", band], ["stone", stone], ["slate", slate], ["trim", trim], ["glass", glass], ["pave", pave], ["metal", metal], ["signred", "#7A2A2A"], ["signcream", "#E8E0C8"], ["plaster", plaster], ["wood", wood], ["oak", oak], ["floor", floorc], ["lamp", lampw], ["board", board]];
module paint(c) {
    if (PAINT == "") color(c) children();
    else if ([for (p = PAINTS) if (p[0] == PAINT) p[1]][0] == c) children();
}
module box(x0, y0, z0, l, w, h) { translate([f(x0), f(y0), f(z0)]) cube([f(l), f(w), f(h)]); }
module arch2d(w, h) { translate([-w / 2, 0]) square([w, h - w / 2]); translate([0, h - w / 2]) circle(d = w, $fn = 72); }
// things drawn on a wall: side = 0 town side (faces -y), 1 track side (faces +y); x = centre, y = wall face
module on_wall(x, y, side) { translate([f(x), f(y), 0]) rotate([90, 0, side ? 180 : 0]) children(); }
module window(x, y, side, w, h, sill, panes = [2, 3], stone_sill = true) {
    on_wall(x, y, side) translate([0, f(sill), -f(0.5)]) {
        paint(glass) translate([-f(w) / 2, 0, 0]) cube([f(w), f(h), f(0.1)]);
        paint(trim) translate([0, 0, 0]) {
            for (k = [0 : panes[0]]) translate([-f(w) / 2 + k * f(w) / panes[0] - f(0.12), 0, 0]) cube([f(0.24), f(h), f(0.3)]);
            for (k = [0 : panes[1]]) translate([-f(w) / 2, k * f(h) / panes[1] - f(0.12), 0]) cube([f(w), f(0.24), f(0.3)]);
        }
        if (stone_sill) paint(stone) translate([-f(w) / 2 - f(0.4), -f(0.6), f(0.3)]) cube([f(w) + f(0.8), f(0.6), f(0.6)]);
    }
}
module door(x, y, side, w, h, transom = 2) {
    on_wall(x, y, side) translate([0, 0, -f(0.5)]) {
        paint(trim) translate([-f(w) / 2, 0, 0]) cube([f(w), f(h), f(0.2)]);
        paint(glass) translate([-f(w) / 2 + f(0.4), f(h), 0]) cube([f(w) - f(0.8), f(transom), f(0.1)]);
        paint(glass) for (s = [-1, 1]) translate([s * f(w) / 4 - f(w) / 4 + f(0.5), f(3.2), f(0.1)]) cube([f(w) / 2 - f(1), f(h) - f(4.2), f(0.2)]);
    }
}
module opening(x, y, side, w, h, sill) { on_wall(x, y, side) translate([-f(w) / 2, f(sill), -f(0.5)]) cube([f(w), f(h), f(0.6)]); }
module arch_cut(x, y, side) {
    d = INTERIOR ? WALL + 1 : 0.8;
    on_wall(x, y, side) translate([0, f(base_h) - f(1.2), -f(d - 0.1)]) linear_extrude(f(d)) arch2d(f(arch_w), f(arch_top - base_h + 1.2));
}
module room_hole() { box(wr_x0 + WALL / 2, WALL, floor_z, wr_x1 - wr_x0 - WALL, main_w - 2 * WALL, ceil_z - floor_z); }
module arch_fill(x, y, side, doors) {
    h = arch_top - base_h + 1.2;  sp = h - arch_w / 2;       // spring line above the opening sill
    on_wall(x, y, side) translate([0, f(base_h) - f(1.2), -f(0.7)]) {
        paint(glass) linear_extrude(f(0.1)) arch2d(f(arch_w), f(h));
        paint(trim) {
            linear_extrude(f(0.35)) difference() { arch2d(f(arch_w), f(h)); offset(-f(0.35)) arch2d(f(arch_w), f(h)); }
            translate([-f(arch_w) / 2, f(sp) - f(0.3), 0]) cube([f(arch_w), f(0.6), f(0.4)]);                 // transom bar
            translate([-f(arch_w) / 2, f(sp) - f(5), 0]) cube([f(arch_w), f(0.4), f(0.4)]);
            for (dx = [-arch_w / 6, arch_w / 6]) translate([f(dx) - f(0.2), 0, 0]) cube([f(0.4), f(sp) + f(arch_w) / 2 * 0.93, f(0.4)]);
            for (a = [45, 135]) translate([0, f(sp), 0]) rotate([0, 0, a]) translate([0, -f(0.12), 0]) cube([f(arch_w) / 2, f(0.24), f(0.3)]);   // fan light bars
            linear_extrude(f(0.3)) translate([0, f(sp)]) difference() { circle(d = f(arch_w) * 0.55, $fn = 48); circle(d = f(arch_w) * 0.55 - f(0.5), $fn = 48); translate([-f(arch_w), -f(arch_w) * 2]) square(f(arch_w) * 2); }
            if (doors) translate([-f(arch_w) / 6 + f(0.2), 0, 0]) cube([f(arch_w) / 3 - f(0.4), f(8), f(0.25)]);   // pair of doors in the centre light
            else translate([-f(arch_w) / 2, 0, 0]) cube([f(arch_w), f(3.2), f(0.25)]);                               // panel below the windows
        }
    }
    // brick arch ring and stone keystone, proud of the wall
    on_wall(x, y, side) translate([0, f(base_h) - f(1.2), 0]) {
        paint(band) linear_extrude(f(0.25)) difference() { arch2d(f(arch_w) + f(3), f(h) + f(1.5)); arch2d(f(arch_w), f(h)); translate([-f(arch_w), -1]) square([f(arch_w) * 2, f(sp) + 1]); }
        paint(stone) translate([-f(0.8), f(h) - f(0.2), 0]) linear_extrude(f(0.5)) polygon([[0, 0], [f(1.6), 0], [f(2), f(2.4)], [-f(0.4), f(2.4)]]);
    }
}
module hip(x0, y0, l, w, z, rise, o) {        // hipped roof over a block; eave line at z
    hull() {
        box(x0 - o, y0 - o, z, l + 2 * o, w + 2 * o, 0.35);
        box(x0 + w / 2, y0 + w / 2 - 0.3, z + rise - 0.05, l - w, 0.6, 0.05);
    }
}
module cornice(x0, y0, l, w, z, o) {          // metal cornice with brackets under the eave, bronze green
    paint(trim) {
        box(x0 - 0.6, y0 - 0.6, z - 2.2, l + 1.2, w + 1.2, 0.8);
        box(x0 - o + 0.3, y0 - o + 0.3, z - 0.5, l + 2 * o - 0.6, w + 2 * o - 0.6, 0.5);
        n = round(l / 3.3); m = round(w / 3.3);
        for (k = [0 : n], s = [0, 1]) box(x0 + k * l / n - 0.4, s ? y0 + w : y0 - o + 0.5, z - 1.5, 0.8, o - 0.5, 1.0);
        for (k = [0 : m], s = [0, 1]) box(s ? x0 + l : x0 - o + 0.5, y0 + k * w / m - 0.4, z - 1.5, o - 0.5, 0.8, 1.0);
    }
}
module bands(x0, y0, l, w, z0, z1) {          // the brickwork is laid in raised bands: grooves every 2 ft
    for (z = [z0 : 2 : z1]) box(x0 - 0.01, y0 - 0.01, z, l + 0.02, w + 0.02, 0.25);
}

// ---------------- main block + wing ----------------
arches = [30, 50, 70];
module depot() {
    // stone base
    paint(stone) difference() { union() { box(-0.4, -0.4, 0, main_l + 0.4, main_w + 0.8, base_h); box(main_l, 2 - 0.4, 0, wing_l + 0.4, wing_w + 0.4, base_h); } if (INTERIOR) room_hole(); }
    // brick walls with the openings cut in
    paint(brick) difference() {
        union() { box(0, 0, base_h, main_l, main_w, eave_h - base_h); box(main_l, 2, base_h, wing_l, wing_w, weave_h - base_h); }
        difference() {                        // band grooves on the main block, kept clear of the pavilion corners (quoins)
            bands(0, 0, main_l, main_w, base_h + 2, eave_h - 5);
            for (x = arches, y = [0, T]) translate([f(x - arch_w / 2 - 1.5), f(y - 1), 0]) cube([f(arch_w + 3), f(2), f(eave_h)]);
        }
        for (x = arches) { arch_cut(x, 0, 0); arch_cut(x, T, 1); }
        if (INTERIOR) room_hole();
        for (x = [10, 90], s = [0, 1]) opening(x, s ? T : 0, s, 9, 3.6, 19.2);           // blind panels high in the end pavilions
        opening(89, 0, 0, 7, 8, base_h + 3.5);                                            // segmental window, town side
        if (ERA < 1940) opening(10, 0, 0, 5.5, 10, 0);
        else opening(10, 0, 0, 7, 8, base_h + 3.5);                                       // 1940: door closed, window in its place
        opening(10, T, 1, 8, 7, base_h + 3);
        for (y = [12, 28]) translate([-f(0.1), f(y - 2.25), f(base_h + 3)]) cube([f(0.6), f(4.5), f(8)]);   // Washington Ave end: two windows
        translate([-f(0.1), f(8), f(18.5)]) cube([f(0.35), f(24), f(4)]);                                    // and the name panel above
        for (x = [104, 119.5, 123, 128.6]) opening(x, 2, 0, 3.6, 7, base_h + 3);
        for (x = [106, 112, 124, 130, 136]) opening(x, T, 1, 3.6, 7, base_h + 3);
    }
    for (x = arches) { arch_fill(x, 0, 0, ERA >= 1940 && x != 50); arch_fill(x, T, 1, true); }
    for (x = [10, 90], s = [0, 1]) paint(band) on_wall(x, s ? T : 0, s) translate([-f(4.5), f(19.2), -f(0.5)]) cube([f(9), f(3.6), f(0.15)]);
    paint(stone) for (y = [12, 28]) translate([-f(0.5), f(y - 2.6), f(base_h + 2.5)]) cube([f(0.5), f(5.2), f(0.5)]);
    paint(glass) for (y = [12, 28]) translate([f(0.3), f(y - 2.25), f(base_h + 3)]) cube([f(0.1), f(4.5), f(8)]);
    paint(band) translate([f(0.2), f(8), f(18.5)]) cube([f(0.1), f(24), f(4)]);
    window(89, 0, 0, 7, 8, base_h + 3.5, [3, 3]);
    window(10, T, 1, 8, 7, base_h + 3, [4, 3]);
    if (ERA < 1940) { door(10, 0, 0, 5.5, 8); porch(); }
    else window(10, 0, 0, 7, 8, base_h + 3.5, [3, 3]);
    for (x = [104, 119.5, 128.6]) window(x, 2, 0, 3.6, 7, base_h + 3);
    door(123, 2, 0, 3.6, 7.5 + base_h, 0);  door(113.5, 2, 0, 3.6, 7.5 + base_h, 0);
    for (x = [106, 124, 136]) window(x, T, 1, 3.6, 7, base_h + 3);
    door(112, T, 1, 3.6, 8);  door(130, T, 1, 3.6, 8);
    // ticket office bay on the track side
    translate([f(89), f(T), 0]) {
        paint(stone) linear_extrude(f(base_h)) polygon([[-f(7), 0], [f(7), 0], [f(4), f(5)], [-f(4), f(5)]]);
        paint(trim) translate([0, 0, f(base_h)]) linear_extrude(f(8.5)) polygon([[-f(7), 0], [f(7), 0], [f(4), f(5)], [-f(4), f(5)]]);
        paint(glass) translate([0, 0, f(base_h + 1)]) linear_extrude(f(6)) polygon([[-f(6.6), f(0.5)], [f(6.6), f(0.5)], [f(3.8), f(5.15)], [-f(3.8), f(5.15)]]);
    }
    // roofs
    paint(slate) { hip(0, 0, main_l, main_w, eave_h, ridge_h - eave_h, ov); hull() { box(main_l, 2 - 3, weave_h, wing_l + 3, wing_w + 6, 0.35); box(main_l, 2 + wing_w / 2 - 0.3, wridge_h - 0.05, wing_l - wing_w / 2, 0.6, 0.05); } }
    paint(metal) box(main_w / 2 - 1, main_w / 2 - 0.5, ridge_h - 0.2, main_l - main_w + 2, 1, 1);          // metal ventilated ridge
    cornice(0, 0, main_l, main_w, eave_h, ov);
    cornice(main_l + 3.2, 2, wing_l - 3.2, wing_w, weave_h, 3);
    if (DORMERS) for (x = arches, s = [0, 1])                // round "eyebrow" roof vents, three a side
        translate([f(x), f(s ? T - 6.5 : 6.5), f(eave_h + 5.2)]) rotate([90, 0, s ? 180 : 0]) {
            paint(metal) translate([0, 0, 0]) linear_extrude(f(5)) difference() { circle(d = f(5), $fn = 40); translate([-f(3), -f(6)]) square(f(6)); }
            paint(glass) translate([0, f(0.9), f(4.9)]) cylinder(d = f(1.8), h = f(0.25), $fn = 24);
        }
    // chimney where the wing meets the main block
    paint(brick) box(main_l + 6, 16, weave_h, 4, 4, 22);  paint(stone) box(main_l + 5.6, 15.6, weave_h + 22, 4.8, 4.8, 1);
    if (ERA >= 1940) marquee();
}
module marquee() {                                            // 1940: flat marquee over the doors in the third arch, hung on rods
    x0 = arches[2] - mq_w / 2;
    paint(metal) box(x0, -mq_out, mq_z, mq_w, mq_out, 1.4);                         // slab with a deep fascia
    paint(stone) box(x0 + 0.3, -mq_out + 0.3, mq_z - 0.05, mq_w - 0.6, mq_out - 0.3, 0.1);   // light soffit
    paint(trim) for (x = [x0 + 1.5, x0 + mq_w - 1.5]) hull() { box(x - 0.08, -mq_out + 0.6, mq_z + 1.3, 0.16, 0.16, 0.16); box(x - 0.08, -0.1, mq_z + 7, 0.16, 0.16, 0.16); }
    // ENTRANCE blade sign standing up from the left end of the marquee (as today)
    translate([f(x0 + 0.6), -f(2.6), f(mq_z + 1.4)]) {
        paint("#7A2A2A") cube([f(0.5), f(2.2), f(10)]);
        // letters read top to bottom on both faces, tops of the letters to the reader's right (as today)
        paint("#E8E0C8") for (sd = [0, 1]) translate([sd ? f(0.5) : 0, f(1.1), f(5)])
            multmatrix(sd ? [[0, 0, 1, 0], [0, 1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 1]] : [[0, 0, -1, 0], [0, -1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 1]])
                linear_extrude(f(0.04)) text("ENTRANCE", size = f(1.15), font = SIGN_FONT, halign = "center", valign = "center", spacing = 1.05);
    }
}
module porch() {                                              // 1903 entrance porch, town side at the Washington end
    paint(trim) { for (x = [5, 15]) box(x - 0.4, -6, 0, 0.8, 0.8, 9); box(4, -6.5, 9, 12, 6.5, 0.6); }
    paint(slate) translate([f(10), 0, f(9.6)]) rotate([90, 0, 0]) linear_extrude(f(7)) polygon([[-f(7), 0], [f(7), 0], [0, f(3.5)]]);
}

// ---------------- waiting room interior, Feb 1941 ----------------
ix0 = wr_x0 + WALL / 2;  ix1 = wr_x1 - WALL / 2;  iy0 = WALL;  iy1 = main_w - WALL;   // inside faces
module arch_holes() { for (x = arches) for (s = [0, 1]) on_wall(x, s ? T : 0, s) translate([0, f(base_h) - f(1.2), -f(WALL + 0.6)]) linear_extrude(f(WALL + 1.2)) arch2d(f(arch_w), f(arch_top - base_h + 1.2)); }
module itext(txt, h, wall) {     // letters on an end wall, read from inside the room. wall 0 = ticket end (faces +x), 1 = restaurant end (faces -x)
    rotate([90, 0, wall ? -90 : 90]) linear_extrude(t(0.08)) text(txt, size = f(h), font = SIGN_FONT, halign = "center", valign = "center", spacing = 1.25);
}
module interior() {
    L = ix1 - ix0;  W = iy1 - iy0;
    paint(floorc) box(ix0, iy0, floor_z + 0.04, L, W, 0.05);
    // plaster walls and the wood wainscot, cut round the arches
    difference() {
        union() {
            paint(plaster) { box(ix0, iy0, floor_z, L, 0.06, ceil_z - floor_z); box(ix0, iy1 - 0.06, floor_z, L, 0.06, ceil_z - floor_z);
                             box(ix0, iy0, floor_z, 0.06, W, ceil_z - floor_z); box(ix1 - 0.06, iy0, floor_z, 0.06, W, ceil_z - floor_z); }
            paint(wood)    { box(ix0, iy0, floor_z, L, 0.2, wain_h); box(ix0, iy1 - 0.2, floor_z, L, 0.2, wain_h);
                             box(ix0, iy0, floor_z, 0.2, W, wain_h); box(ix1 - 0.2, iy0, floor_z, 0.2, W, wain_h);
                             box(ix0, iy0, floor_z + wain_h, L, 0.35, 0.3); box(ix0, iy1 - 0.35, floor_z + wain_h, L, 0.35, 0.3); }   // cap rail
        }
        arch_holes();
        translate([f(ix1 - 1), f(main_w / 2 - 8), f(floor_z - 0.1)]) cube([f(2), f(16), f(9.1)]);         // restaurant doorway
        for (y = [5, main_w - 5]) translate([f(ix1 - 1), f(y - 1.75), f(floor_z - 0.1)]) cube([f(2), f(3.5), f(7.6)]);   // WOMEN / MEN doors
    }
    ceiling(); ticket_wall(); restaurant_wall();
    for (cy = [11, 20, 29]) for (cx = [37, 62]) bench(cx, cy, 17);
    for (x = [30, 50, 70]) for (y = [13.5, 26.5]) lamp(x, y);
    // radiators under the window panels, and the standing schedule frame by the ticket wall
    paint(metal) for (x = [40, 60], y = [iy0 + 0.3, iy1 - 1.1]) box(x - 2.5, y, floor_z, 5, 0.8, 2.6);
    paint(wood) { box(24, iy1 - 4, floor_z, 0.25, 0.25, 6); box(24, iy1 - 1.5, floor_z, 0.25, 0.25, 6); box(23.9, iy1 - 4, floor_z + 2.5, 0.3, 2.8, 3.5); }
    paint(plaster) box(24.2, iy1 - 3.8, floor_z + 2.7, 0.08, 2.4, 3.1);
}
module ceiling() {
    L = ix1 - ix0;  W = iy1 - iy0;
    paint(plaster) {
        box(ix0, iy0, ceil_z - 0.2, L, W, 0.12);
        // cornice round the room, with a dentil row below it
        difference() { box(ix0, iy0, ceil_z - 1.1, L, W, 1.0); box(ix0 + 0.8, iy0 + 0.8, ceil_z - 1.2, L - 1.6, W - 1.6, 1.2); }
        for (x = [ix0 + 1 : 0.9 : ix1 - 1]) for (y = [iy0 + 0.75, iy1 - 0.95]) box(x, y, ceil_z - 1.5, 0.45, 0.2, 0.4);
        for (y = [iy0 + 1 : 0.9 : iy1 - 1]) for (x = [ix0 + 0.75, ix1 - 0.95]) box(x, y, ceil_z - 1.5, 0.2, 0.45, 0.4);
        // beams: across the room at the truss lines, and two lengthwise, making the coffers
        for (x = [40, 60]) box(x - 0.7, iy0, ceil_z - 1.6, 1.4, W, 1.6);
        for (y = [iy0 + W / 3, iy0 + 2 * W / 3]) box(ix0, y - 0.6, ceil_z - 1.3, L, 1.2, 1.3);
        // big console brackets under the cross beams where they meet the long walls
        for (x = [40, 60], s = [0, 1]) translate([f(x - 0.6), f(s ? iy1 : iy0), f(ceil_z - 1.6)]) mirror([0, s, 0])
            rotate([90, 0, 90]) linear_extrude(f(1.2)) polygon([[0, 0], [f(1.6), 0], [f(1.6), -f(0.4)], [f(0.4), -f(3.2)], [0, -f(3.2)]]);
    }
}
module ticket_wall() {                         // Washington Ave end of the room: four ticket windows, BULLETIN boards, TICKETS band, clock
    x = ix0 + 0.06;  cy = main_w / 2;
    paint(wood) { box(x, cy - 10, floor_z, 0.5, 20, 3.6); box(x, cy - 10, floor_z + 7.4, 0.4, 20, 0.4); }   // counter front and the head of the windows
    for (k = [0 : 3]) {
        y = cy - 6.75 + k * 4.5;
        paint(board) box(x, y - 1.4, floor_z + 3.9, 0.08, 2.8, 3.3);                // window opening (dark)
        paint(lampw) for (d = [-0.9 : 0.45 : 0.9]) box(x + 0.1, y + d - 0.04, floor_z + 3.9, t(0.08) / f(1), 0.08, 3.3);   // grille bars
        paint(wood) for (d = [-1.6, 1.4]) box(x, y + d, floor_z + 3.6, 0.45, 0.2, 3.8);        // posts between the windows
    }
    paint(board) for (y = [cy - 13.2, cy + 10.2]) box(x, y, floor_z + 3.6, 0.15, 3, 4);       // BULLETIN boards
    paint(lampw) for (y = [cy - 13.2, cy + 10.2]) for (z = [0.6 : 0.35 : 3.5]) box(x + 0.16, y + 0.4, floor_z + 3.6 + z, 0.03, 2.2, 0.12);   // their lines of train times
    paint(plaster) box(x, cy - 14, floor_z + 8, 0.35, 28, 1.6);                                 // sign band
    paint(wood) translate([f(x + 0.36), f(cy), f(floor_z + 8.8)]) itext("T I C K E T S", 1.0, 0);
    paint(wood) for (y = [cy - 11.7, cy + 11.7]) translate([f(x + 0.36), f(y), f(floor_z + 8.8)]) itext("BULLETIN", 0.45, 0);
    // clock with the loudspeaker box under it
    paint(lampw) translate([f(x), f(cy), f(floor_z + 12.5)]) rotate([0, 90, 0]) cylinder(d = f(1.6), h = f(0.25), $fn = 40);
    paint(board) translate([f(x), f(cy), f(floor_z + 12.5)]) rotate([0, 90, 0]) cylinder(d = f(1.8), h = f(0.18), $fn = 40);
    paint(plaster) box(x, cy - 0.7, floor_z + 10.3, 0.4, 1.4, 1.4);
    paint(board) translate([f(x + 0.41), f(cy), f(floor_z + 11)]) rotate([0, 90, 0]) cylinder(d = f(0.7), h = f(0.02), $fn = 24);
}
module restaurant_wall() {                     // wing end: NEWS - RESTAURANT doorway, WOMEN and MEN doors
    x = ix1 - 0.06;  cy = main_w / 2;
    paint(board) box(ix1 + 0.2, cy - 8, floor_z, 0.1, 16, 9);                    // dark beyond the doorway
    paint(wood) { box(ix1 - 0.3, cy - 1, floor_z, 0.8, 7, 3.4); box(ix1 - 0.3, cy - 7, floor_z, 0.8, 4, 4.5); }   // news stand counter and cases
    paint(wood) for (y = [5, main_w - 5]) box(ix1 - 0.15, y - 1.6, floor_z, 0.2, 3.2, 7.4);    // the two doors
    paint(plaster) box(x - 0.35, iy0 + 0.5, floor_z + 9.2, 0.35, iy1 - iy0 - 1, 1.5);         // sign band across the wall
    paint(wood) {
        translate([f(x - 0.36), f(cy - 0.5), f(floor_z + 9.95)]) itext("R E S T A U R A N T", 0.85, 1);
        translate([f(x - 0.36), f(cy + 10.2), f(floor_z + 9.95)]) itext("NEWS", 0.55, 1);
        translate([f(x - 0.36), f(5), f(floor_z + 9.95)]) itext("MEN", 0.55, 1);
        translate([f(x - 0.36), f(main_w - 5), f(floor_z + 9.95)]) itext("WOMEN", 0.55, 1);
    }
}
module bench(cx, cy, l) {                      // double-sided oak bench with arm dividers (1941 photos)
    n = round(l / 2.2);
    paint(oak) {
        for (x = [cx - l / 2, cx, cx + l / 2 - 0.25]) translate([f(x), f(cy), f(floor_z)]) rotate([90, 0, 90]) linear_extrude(f(0.25))
            polygon([for (pt = [[-2.1, 0], [-1.6, 0], [-1.6, 0.5], [1.6, 0.5], [1.6, 0], [2.1, 0], [2.1, 2.2], [1.6, 2.4], [0.4, 3.5], [-0.4, 3.5], [-1.6, 2.4], [-2.1, 2.2]]) [f(pt[0]), f(pt[1])]]);
        for (s = [-1, 1]) box(cx - l / 2, cy + (s < 0 ? -1.95 : 0.15), floor_z + 1.4, l, 1.8, 0.18);            // seats
        box(cx - l / 2, cy - 0.15, floor_z + 1.4, l, 0.3, 1.9);                                              // back
        for (k = [1 : n - 1], s = [-1, 1]) box(cx - l / 2 + k * l / n - 0.1, cy + (s < 0 ? -1.95 : 1.6), floor_z + 1.58, 0.2, 0.35, 0.7);   // arm dividers
    }
}
module lamp(x, y) {                            // white open-slat hanging light, 1940
    z = 15;  w = 2.2;  h = 3.4;
    paint(lampw) {
        translate([f(x), f(y), f(z + h)]) cylinder(d = t(0.12), h = f(ceil_z - 1.3 - z - h), $fn = 8);       // rod
        for (dz = [0, h - 0.25]) difference() { box(x - w / 2, y - w / 2, z + dz, w, w, 0.25); box(x - w / 2 + 0.25, y - w / 2 + 0.25, z + dz - 0.1, w - 0.5, w - 0.5, 0.45); }
        for (i = [0 : 3], j = [0 : 3]) if (i == 0 || i == 3 || j == 0 || j == 3)
            translate([f(x - w / 2 + 0.1 + i * (w - 0.2) / 3) - t(0.15) / 2, f(y - w / 2 + 0.1 + j * (w - 0.2) / 3) - t(0.15) / 2, f(z)]) cube([t(0.15), t(0.15), f(h)]);
    }
}

// ---------------- baggage + express building ----------------
bx = main_l + wing_l + gap;
// 1940 upper floor windows: a pair, two singles, a pair (spacing from Tom's photo of the street side)
bag_up = concat([for (c = [0.18, 0.84]) for (d = [-2, 2]) bx + c * bag_l + d], [bx + 0.42 * bag_l, bx + 0.54 * bag_l]);
module baggage() {
    by = T - bag_w;                                           // track side wall in line with the depot (plat)
    paint(stone) box(bx - 0.2, by - 0.2, 0, bag_l + 0.4, bag_w + 0.4, 1.5);
    paint(brick) difference() {
        union() {
            box(bx, by, 1.5, bag_l, bag_w, bag_eave - 1.5);
            translate([f(bx), f(by), f(bag_eave)]) rotate([90, 0, 90]) linear_extrude(f(bag_l)) polygon([[0, 0], [f(bag_w), 0], [f(bag_w) / 2, f(bag_rise)]]);
        }
        for (x = [bx + 10, bx + 33, bx + 52], s = [0, 1]) opening(x, s ? T : by, s, 8, 9, 0.2);
        for (x = [bx + 21, bx + 43], s = [0, 1]) opening(x, s ? T : by, s, 3.6, 6, 5);
        if (ERA >= 1940) for (x = bag_up, s = [0, 1]) opening(x, s ? T : by, s, 3.4, 6, 14);
    }
    for (x = [bx + 10, bx + 33, bx + 52], s = [0, 1]) door(x, s ? T : by, s, 8, 7.5, 1.5);
    for (x = [bx + 21, bx + 43], s = [0, 1]) window(x, s ? T : by, s, 3.6, 6, 5);
    if (ERA >= 1940) for (x = bag_up, s = [0, 1]) window(x, s ? T : by, s, 3.4, 6, 14, [1, 2]);
    paint(slate) translate([f(bx - 2), f(by), f(bag_eave)]) rotate([90, 0, 90]) linear_extrude(f(bag_l + 4))
        polygon([[-f(2.5), -f(0.9)], [f(bag_w) / 2, f(bag_rise) + f(0.2)], [f(bag_w) + f(2.5), -f(0.9)], [f(bag_w) + f(2.5), -f(0.4)], [f(bag_w) / 2, f(bag_rise) + f(0.8)], [-f(2.5), -f(0.4)]]);
}

// ---------------- platform canopy ----------------
module post(x, y, h) {
    paint(trim) {
        box(x - 0.42, y - 0.42, 0, 0.84, 0.84, h);
        box(x - 0.7, y - 0.7, 0, 1.4, 1.4, 2.5);
        for (a = [0, 90, 180, 270]) translate([f(x), f(y), f(h)]) rotate([0, 0, a]) rotate([90, 0, 0]) translate([0, 0, -f(0.2)]) linear_extrude(f(0.4)) polygon([[0, -f(3.5)], [f(3.5), 0], [f(3), 0], [0, -f(2.8)]]);
    }
}
module lean_run(x0, x1, out, wall = true) {                   // canopy along the buildings: one row of posts, low roof
    n = max(1, round((x1 - x0) / bay));
    for (k = [0 : n]) post(x0 + k * (x1 - x0) / n, T + out, can_h);
    paint(trim) box(x0 - 1, T + out - 0.3, can_h, x1 - x0 + 2, 0.6, 0.9);
    y0 = wall ? T : T + out - (out + 4) / 2 - 2;
    paint(slate) translate([f(x0 - 2), 0, 0]) rotate([90, 0, 90]) linear_extrude(f(x1 - x0 + 4))
        polygon([[f(y0), f(can_h + 2.6)], [f(T + out + 4), f(can_h + 0.7)], [f(T + out + 4), f(can_h + 1.1)], [f(y0), f(can_h + 3)]]);
}
module umbrella(x0, x1) {                                     // 1940 shed: one row of centre posts, braces both ways, low gable
    n = max(1, round((x1 - x0) / bay));  h = can_h + 0.5;
    paint(trim) for (k = [0 : n]) translate([f(x0 + k * (x1 - x0) / n), f(ext_y), 0]) {
        translate([-f(0.4), -f(0.4), 0]) cube([f(0.8), f(0.8), f(h + 1.2)]);
        translate([-f(0.2), -f(ext_w / 2 - 0.5), f(h)]) cube([f(0.4), f(ext_w - 1), f(0.7)]);       // cross beam
        for (sd = [-1, 1]) hull() { translate([-f(0.15), 0, f(h - 4)]) cube(f(0.3)); translate([-f(0.15), sd * f(ext_w / 2 - 1.2), f(h)]) cube(f(0.3)); }   // braces
    }
    paint(trim) box(x0 - 1, ext_y - 0.35, h + 1.2, x1 - x0 + 2, 0.7, 0.8);                     // ridge beam
    paint(slate) translate([f(x0 - 1), f(ext_y), f(h + 0.7)]) rotate([90, 0, 90]) linear_extrude(f(x1 - x0 + 2))
        polygon([[-f(ext_w / 2), 0], [0, f(1.6)], [f(ext_w / 2), 0], [f(ext_w / 2), f(0.4)], [0, f(2)], [-f(ext_w / 2), f(0.4)]]);
}
module canopy() {
    lean_run(0, bx + bag_l, can_out);
    if (ERA >= 1940) umbrella(bx + bag_l, bx + bag_l + can_ext);                     // 1940: 155 ft more, narrower
    // gabled shed from the depot end to the gate at Washington Ave: brick piers with stone bands, three bays
    y0 = T + can_out - shed_w;
    for (k = [1, 2], y = [y0, T + can_out]) pier(-k * shed_l / 3, y, can_h);
    post(0, T + can_out, can_h);
    paint(trim) for (y = [y0, T + can_out]) box(-shed_l, y - 0.3, can_h, shed_l, 0.6, 0.9);
    paint(slate) translate([f(-shed_l), f(y0), f(can_h + 0.9)]) rotate([90, 0, 90]) linear_extrude(f(shed_l))
        polygon([[-f(4), -f(0.3)], [f(shed_w) / 2, f(4.2)], [f(shed_w) + f(4), -f(0.3)], [f(shed_w) + f(4), f(0.1)], [f(shed_w) / 2, f(4.7)], [-f(4), f(0.1)]]);
    paint(glass) translate([f(-shed_l / 3 - 5), f(y0 + shed_w / 2 - 3), f(can_h + 4.6)]) cube([f(10), f(6), f(0.9)]);   // skylight on the ridge
}
module pier(x, y, h, w = 2.6) {                               // brick pier with stone base, bands and cap
    paint(brick) box(x - w / 2, y - w / 2, 0, w, w, h);
    paint(stone) { box(x - w / 2 - 0.25, y - w / 2 - 0.25, 0, w + 0.5, w + 0.5, 1.6); for (z = [4.5, 7.5]) box(x - w / 2 - 0.08, y - w / 2 - 0.08, z, w + 0.16, w + 0.16, 0.7); box(x - w / 2 - 0.3, y - w / 2 - 0.3, h - 0.8, w + 0.6, w + 0.6, 0.8); }
}
// The Washington Ave end of the shed: a gate. Two tall brick piers with stone caps and balls stand at the
// corners; a brick wall with a stone coping runs between them and hides the gable of the shed roof; under
// it two fluted stone Doric columns carry a stone beam.
module gate() {
    y0 = T + can_out - shed_w;  x = -shed_l - 1.5;
    for (y = [y0, T + can_out]) {
        pier(x, y, gate_h, 3.6);
        paint(stone) translate([f(x), f(y), f(gate_h + 1.5)]) sphere(d = f(3), $fn = 36);
    }
    paint(stone) for (y = [y0 + shed_w / 3, y0 + 2 * shed_w / 3]) translate([f(x), f(y), 0]) {
        translate([-f(1.4), -f(1.4), 0]) cube([f(2.8), f(2.8), f(1)]);
        difference() { translate([0, 0, f(1)]) cylinder(d1 = f(2.3), d2 = f(1.9), h = f(8.4), $fn = 40); for (a = [0 : 18 : 359]) rotate([0, 0, a]) translate([f(1.15), 0, f(1.2)]) cylinder(d = f(0.22), h = f(8.4), $fn = 8); }
        translate([-f(1.35), -f(1.35), f(9.4)]) cube([f(2.7), f(2.7), f(0.6)]);
    }
    paint(stone) box(x - 1.3, y0 + 1.8, 10, 2.6, shed_w - 3.6, 1.2);            // stone beam on the columns
    paint(brick) box(x - 1, y0 + 1.8, 11.2, 2, shed_w - 3.6, 3.7);              // brick wall across, hiding the gable
    paint(stone) box(x - 1.25, y0 + 1.8, 14.9, 2.5, shed_w - 3.6, 0.6);         // stone coping
}
module platform() {
    x1 = bx + bag_l + (ERA >= 1940 ? can_ext : 0) + 4;
    paint(pave) box(-shed_l - 6, T, -0.5, x1 + shed_l + 6, can_out + 8, 0.5);
    paint(pave) box(-shed_l - 6, T + can_out - shed_w - 4, -0.5, shed_l + 6, shed_w, 0.5);
}

// letters on a wall that faces Washington Ave (-x): x = wall face, y = centre, z = centre height, h = letter height
module sign(txt, x, y, z, h) {
    paint(trim) translate([f(x), f(y), f(z)]) rotate([90, 0, -90]) linear_extrude(f(0.25))
        text(txt, size = f(h), font = SIGN_FONT, halign = "center", valign = "center", spacing = 1.12);
}
module signs() {
    sign(SIGN_ROAD, 0.2, main_w / 2, 20.5, 1.7);                         // on the panel, Washington Ave end
    sign(SIGN_TOWN, -shed_l - 2.5, T + can_out - shed_w / 2, 13.05, 1.7);   // on the gate wall
}

if (SHOW == "all") { depot(); baggage(); canopy(); gate(); platform(); signs(); if (INTERIOR) interior(); }
else if (SHOW == "interior") interior();
else if (SHOW == "signs") signs();
else if (SHOW == "depot") depot();
else if (SHOW == "baggage") baggage();
else if (SHOW == "canopy") canopy();
else if (SHOW == "gate") gate();
else if (SHOW == "platform") platform();
