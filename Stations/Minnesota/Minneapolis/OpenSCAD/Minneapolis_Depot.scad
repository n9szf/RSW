// =====================================================================
//  MILWAUKEE ROAD - MINNEAPOLIS, MINN. PASSENGER STATION (1899)
//  Charles S. Frost, architect.  Head house with the 1899 tower (Giralda-style
//  spire, lost 1941), midway, 625 ft train shed, baggage building.
//  HAND-BUILT - not written by the depot generator; do not overwrite.
//  Rib Side Works, 26 Nov 2026 (rev 1, first shape).
//
//  SOURCES
//   - MPL drawings 1899, MilwRoad 8483-8502 (private, in copyright):
//     Research Library / RSW / Stations / Minnesota / Minneapolis.  Rev 1 read
//     from the SMALL copies (about 1250 px); proportions only, no dimension text.
//   - NRHP nomination 1978 (reference / Station photos web / Minneapolis / 16):
//     shed 625 x 100 ft, 40 ft at the monitor ridge, five stub tracks, one
//     100 ft riveted Fink truss, steel posts with pierced brackets under a
//     longitudinal lattice beam; baggage room 225 x 20 x 14 ft with a 75 ft
//     brick chimney; head house three stories (50 ft) on the street fronts,
//     pink granite first story, yellow brick above, Roman arches through
//     stories 2-3, heavy cornice; tower 140 ft, cornice at about 100 ft today.
//   - Sheet 01 (front elevation, scaled so the finial = 140 ft, 7.64 px/ft):
//     main parapet 46 ft, tower shaft cornice 86-91 ft, open clock stage
//     94-106 ft, corner urns, bell-shaped scaled spire 112-126 ft, lantern,
//     finial 140 ft.  Front (Third Ave) about 92 ft; tower 18 ft square.
//   - Sheet 03 (south elevation, Washington Ave): about 95 ft; two plain bays
//     at each end, five arched bays in the middle, arched entrance; one-story
//     midway with two large arches at the track end.
//   - Colours from web photos 06, 08, 12 (2009-2018, daylight): buff-orange
//     brick (the NRHP "yellow brick"), pinkish-gray granite.
//  ESTIMATE (check against the full-size sheets when they are in):
//   head house 92 x 95 ft and all of it three stories (NRHP: rear parts two
//   stories); window sizes and spacing; north and east fronts (copied from the
//   south / simple grid); midway 24 ft deep, 16 ft high, flat roof; shed eave
//   22 ft, frames every 25 ft, monitor 20 ft wide, shed placed y -4..96;
//   track and platform layout; baggage building openings; chimney size;
//   spire colour (dark slate) and its octagonal plan; door colour.
//
//  x = along the tracks (x = 0 is the Third Ave front, tracks run to +x),
//  y = 0 is the Washington Ave (south) face, +y north.  z = 0 grade.  Feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.  Whole complex is about 760 ft long
//  (G about 26 ft / 8 m, O about 16 ft, HO about 9 ft).  Not cut for printing yet.
// =====================================================================
SCALE = 29;
SHOW_SHED     = true;    // 625 ft train shed
SHOW_BAGGAGE  = true;    // baggage building and 75 ft chimney
SHOW_TRACKS   = true;    // rails on the five stub tracks
SHOW_UMBRELLA = false;   // umbrella shed beyond the train shed (NRHP 1978; date not known - ESTIMATE)
COL_STEEL = "#3C3E40";   // train shed steel
COL_RAIL  = "#5A524C";
COL_CLOCK = "#E9E4D6";
include <../../../_common/rsw_depot.scad>

// ---- colours (photos 06, 08, 12) ----
COL_BRICK = "#C08A66";   // buff-orange "yellow" brick
COL_STONE = "#9C8A82";   // pink-gray granite
COL_TRIM  = "#B49A80";   // cornices, belts, arch rings (terra cotta / stone - ESTIMATE)
COL_ROOF  = "#4B4F55";   // slate (spire and shed) - ESTIMATE
COL_DOOR  = "#4E3322";   // dark varnished wood - ESTIMATE
COL_SASH  = "#6B4A33";   // window frames - ESTIMATE
PAINTS = [["walls", COL_BODY], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND],
          ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH], ["steel", COL_STEEL],
          ["rails", COL_RAIL], ["clock", COL_CLOCK]];

$fn = 24;
// ---- main sizes (ft) ----
HX = 95;   HY = 92;        // head house: depth along the tracks, width of the Third Ave front
GR = 16;                   // granite first story (top of belt)
CORN = 42;  PAR = 46;      // cornice top, parapet top
TW = 18;  TY0 = HY / 2 - TW / 2;  TX0 = -6;   // tower 18 ft square, projects 6 ft
MX0 = HX;  MX1 = HX + 24;  MH = 16;           // midway (one story)
SX0 = MX1;  SL = 625;  SY0 = -4;  SW = 100;   // train shed
S_EAVE = 22;  S_TOP = 36;  S_MON = 20;  S_RIDGE = 40;  S_BAY = 25;
BX0 = SX0 + 6;  BL = 225;  BW = 20;  BH = 14;  BY0 = SY0 + SW;   // baggage building
TRACKS_Y = [12, 31, 50, 69, 88];

// ---------------------------------------------------------------------
//  face placement: children are built with X = along the face (ft via ft()),
//  Y = into the wall (+), Z = up.  Faces: "W" Third Ave, "S" Washington Ave,
//  "N" north, "E" track end.  (W/E use a mirror; fine for cuts and add-ons.)
// ---------------------------------------------------------------------
module onface(side, x0 = 0, x1 = HX, y0 = 0, y1 = HY) {
    if (side == "S") translate([ft(x0), ft(y0), 0]) children();
    else if (side == "N") translate([ft(x0), ft(y1), 0]) mirror([0, 1, 0]) children();
    else if (side == "W") translate([ft(x0), ft(y0), 0]) multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) children();
    else if (side == "E") translate([ft(x1), ft(y0), 0]) multmatrix([[0, -1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) children();
}
module lbox(u, w, z, h, d0, d) translate([ft(u - w / 2), ft(d0), ft(z)]) cube([ft(w), ft(d), ft(h)]);
// opening: rectangle, or arched (round top) when arch = true
module opening(u, w, z, h, d0, d, arch = false) {
    if (!arch) lbox(u, w, z, h, d0, d);
    else hull() {
        lbox(u, w, z, h - w / 2, d0, d);
        translate([ft(u), ft(d0), ft(z + h - w / 2)]) rotate([-90, 0, 0]) cylinder(r = ft(w / 2), h = ft(d), $fn = 32);
    }
}
// window set into a wall: hole cut by the caller, this adds glass and frame
module win_fill(u, w, z, h, arch = false, rec = 0.8) {
    paint("glass") opening(u, w - 0.2, z + 0.1, h - 0.2, rec, 0.1, arch);
    paint("sash") difference() {
        opening(u, w, z, h, rec - 0.15, 0.15, arch);
        opening(u, w - 0.7, z + 0.35, h - 0.7, rec - 0.3, 0.5, arch);
    }
    paint("sash") lbox(u, w, z + h * 0.55, 0.3, rec - 0.15, 0.15);        // meeting rail / transom bar
    if (w > 5) paint("sash") lbox(u, 0.3, z, arch ? h - w / 2 : h, rec - 0.15, 0.15);   // mullion
    paint("stone") lbox(u, w + 0.8, z - 0.5, 0.5, -0.3, 0.6);             // sill
}
module door_fill(u, w, z, h, arch = false, rec = 1.2) {
    paint("doors") opening(u, w - 0.1, z, arch ? h - w / 2 : h * 0.78, rec, 0.25, false);
    paint("glass") opening(u, w - 0.2, z + (arch ? h - w / 2 : h * 0.78), arch ? w / 2 - 0.1 : h * 0.22, rec + 0.05, 0.1, arch);
}

// ---------------------------------------------------------------------
//  facade data, per face: [u, w, z, h, kind]   kind 0 window, 1 arched window,
//  2 door, 3 arched door, 4 tall Roman arch recess (stories 2-3), 5 roundel
// ---------------------------------------------------------------------
function arch_bays(us) = [for (u = us) each [[u, 7.5, 17.5, 16.5, 4], [u, 5.5, 19, 6, 0], [u, 5, 26.5, 6.3, 1], [u, 5, 4, 8.5, 0]]];
function plain_bays(us) = [for (u = us) each [[u, 4.5, 19, 6, 0], [u, 4.5, 27, 6, 0], [u, 4.5, 4, 8.5, 0]]];
FRONT_W = concat(arch_bays([11, 20, 29, HY - 29, HY - 20, HY - 11]),
                 [[15.5, 2, 35.5, 2, 5], [24.5, 2, 35.5, 2, 5], [HY - 15.5, 2, 35.5, 2, 5], [HY - 24.5, 2, 35.5, 2, 5]]);
SOUTH = concat(plain_bays([6, 14, 78, 86]), arch_bays([25, 35.5, 46, 56.4]),
               [[66.8, 7.5, 17.5, 16.5, 4], [66.8, 5.5, 19, 6, 0], [66.8, 5, 26.5, 6.3, 1], [59.5, 9, 0.6, 14, 3]],
               [for (u = [30.3, 40.8, 51.2, 61.6]) [u, 2, 35.5, 2, 5]]);
NORTH = concat(plain_bays([6, 14, 78, 86]), arch_bays([25, 35.5, 46, 56.4, 66.8]));                   // ESTIMATE
EAST  = concat([for (u = [10, 18, 26, 66, 74, 82]) each [[u, 4.5, 19, 6, 0], [u, 4.5, 27, 6, 0]]],
               [for (u = [34, 46, 58]) each [[u, 8, 0.6, 14, 3], [u, 7.5, 17.5, 16.5, 4], [u, 5.5, 19, 6, 0], [u, 5, 26.5, 6.3, 1]]]);  // ESTIMATE

module cuts(F) for (o = F) {
    if (o[4] == 0) opening(o[0], o[1], o[2], o[3], -0.1, 0.9);
    if (o[4] == 1) opening(o[0], o[1], o[2], o[3], -0.1, 0.9, true);
    if (o[4] == 2) opening(o[0], o[1], o[2], o[3], -0.1, 1.3);
    if (o[4] == 3) opening(o[0], o[1], o[2], o[3], -0.1, 1.3, true);
    if (o[4] == 4) opening(o[0], o[1], o[2], o[3], -0.1, 0.5, true);     // shallow Roman arch recess
    if (o[4] == 5) translate([ft(o[0]), -ft(0.1), ft(o[2] + 1)]) rotate([-90, 0, 0]) cylinder(r = ft(o[1] / 2), h = ft(0.4));
}
module fills(F) for (o = F) {
    if (o[4] == 0) win_fill(o[0], o[1], o[2], o[3]);
    if (o[4] == 1) win_fill(o[0], o[1], o[2], o[3], true);
    if (o[4] == 2) door_fill(o[0], o[1], o[2], o[3]);
    if (o[4] == 3) door_fill(o[0], o[1], o[2], o[3], true);
    if (o[4] == 4) paint("trim") difference() {                         // arch ring and spandrel panel
        opening(o[0], o[1] + 1.4, o[2], o[3] + 0.7, -0.25, 0.3, true);
        opening(o[0], o[1], o[2] - 0.1, o[3] + 0.1, -0.5, 1, true);
    }
    if (o[4] == 4) paint("brick") lbox(o[0], o[1], 25.2, 1, 0.4, 0.1);   // spandrel between stories 2 and 3
    if (o[4] == 5) paint("trim") translate([ft(o[0]), ft(0.25), ft(o[2] + 1)]) rotate([-90, 0, 0]) cylinder(r = ft(o[1] / 2 - 0.2), h = ft(0.1));
}
// the granite / brick split of a face's cuts
module face_cuts(side, F) onface(side) cuts(F);
module face_fills(side, F) onface(side) fills(F);

// ---------------------------------------------------------------------
//  head house
// ---------------------------------------------------------------------
module head_shell(z0, z1) difference() {
    fbox(0, 0, z0, HX, HY, z1 - z0);
    face_cuts("W", FRONT_W); face_cuts("S", SOUTH); face_cuts("N", NORTH); face_cuts("E", EAST);
    fbox(1, 1, z0 - 1, HX - 2, HY - 2, z1 - z0 + 2);                     // hollow (keeps windows dark)
}
module head_house() {
    paint("stone") difference() { head_shell(0, GR); onface("W") lbox(HY / 2, TW, -1, GR + 2, -1, 3); }
    paint("brick") head_shell(GR, CORN);
    paint("roof") fbox(1, 1, CORN - 2, HX - 2, HY - 2, 0.6);             // flat roof deck
    // belts, cornice, parapet
    paint("stone") difference() { fbox(-0.4, -0.4, GR - 0.8, HX + 0.8, HY + 0.8, 0.8); fbox(0.5, 0.5, GR - 2, HX - 1, HY - 1, 3); }
    paint("trim") difference() { fbox(-0.25, -0.25, GR + 1, HX + 0.5, HY + 0.5, 0.5); fbox(0.5, 0.5, GR, HX - 1, HY - 1, 3); }
    paint("trim") difference() {
        union() { fbox(-1.6, -1.6, CORN - 1.2, HX + 3.2, HY + 3.2, 1.2); fbox(-0.8, -0.8, CORN - 2.4, HX + 1.6, HY + 1.6, 1.2);
                  fbox(-0.35, -0.35, CORN - 5, HX + 0.7, HY + 0.7, 2.6); }      // frieze with wreaths (flat band)
        fbox(0.5, 0.5, CORN - 6, HX - 1, HY - 1, 8);
    }
    paint("brick") difference() { fbox(0, 0, CORN, HX, HY, PAR - CORN - 0.5); fbox(1, 1, CORN - 1, HX - 2, HY - 2, 6);
        for (s = ["W", "S", "N", "E"]) onface(s) for (u = [6 : 8 : (s == "W" || s == "E" ? HY : HX) - 5]) lbox(u, 6, CORN + 0.9, 2.2, -0.1, 0.25); }
    paint("trim") difference() { fbox(-0.3, -0.3, PAR - 0.5, HX + 0.6, HY + 0.6, 0.5); fbox(0.7, 0.7, PAR - 2, HX - 1.4, HY - 1.4, 3); }
    face_fills("W", FRONT_W); face_fills("S", SOUTH); face_fills("N", NORTH); face_fills("E", EAST);
    // corner quoins (brick piers slightly proud)
    paint("brick") for (x = [-0.3, HX - 2.7]) for (y = [-0.3, HY - 2.7]) fbox(x, y, GR, 3, 3, CORN - GR - 1.2);
    // chimneys on the roof (ESTIMATE)
    paint("chimney") { fbox(70, 8, CORN, 4, 3, 10); fbox(70, HY - 11, CORN, 4, 3, 10); }
}

// ---------------------------------------------------------------------
//  tower (1899): brick shaft, cornice, open clock stage, urns, bell spire
// ---------------------------------------------------------------------
module tbox(x, y, z, l, w, h) fbox(TX0 + x, TY0 + y, z, l, w, h);
module clock_face(d) paint("clock") rotate([-90, 0, 0]) cylinder(r = ft(d / 2), h = ft(0.2), $fn = 48);
module on_tower(side) {   // face of the tower shaft: X along face (0..TW), Y into wall
    if (side == 0) translate([ft(TX0), ft(TY0), 0]) multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) children();
    if (side == 1) translate([ft(TX0), ft(TY0), 0]) children();
    if (side == 2) translate([ft(TX0), ft(TY0 + TW), 0]) mirror([0, 1, 0]) children();
    if (side == 3) translate([ft(TX0 + TW), ft(TY0), 0]) multmatrix([[0, -1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) children();
}
module tower() {
    c = TW / 2;
    // shaft
    paint("stone") difference() { tbox(0, 0, 0, TW, TW, GR); on_tower(0) opening(c, 8, 0.6, 13, -0.1, 1.4, true); }
    on_tower(0) door_fill(c, 8, 0.6, 13, true, 1.3);
    paint("doors") on_tower(0) translate([0, -ft(3), 0]) hull() {          // iron and glass canopy over the door
        lbox(c, 11, 13.5, 0.4, 0, 3); lbox(c, 11, 14.8, 0.2, 3, 0.1); }
    paint("brick") difference() {
        tbox(0, 0, GR, TW, TW, 86 - GR);
        for (s = [0 : 3]) on_tower(s) {
            lbox(c, 12, 44, 38, -0.1, 0.6);                                   // tall recessed panel
            for (u = [c - 2.2, c + 2.2]) { opening(u, 3.2, 19, 6, -0.1, 1); opening(u, 3.2, 26.5, 6.5, -0.1, 1, true); }
            translate([ft(c), -ft(0.1), ft(39.5)]) rotate([-90, 0, 0]) cylinder(r = ft(1.6), h = ft(1));
        }
        tbox(1, 1, GR - 1, TW - 2, TW - 2, 90);
    }
    for (s = [0 : 3]) on_tower(s) {
        for (u = [c - 2.2, c + 2.2]) { win_fill(u, 3.2, 19, 6); win_fill(u, 3.2, 26.5, 6.5, true); }
        translate([ft(c), ft(0.5), ft(39.5)]) paint("glass") rotate([-90, 0, 0]) cylinder(r = ft(1.5), h = ft(0.1));
        paint("trim") translate([ft(c), -ft(0.35), ft(76)]) rotate([-90, 0, 0]) difference() {   // clock surround
            cylinder(r = ft(5), h = ft(0.4), $fn = 48); translate([0, 0, -1]) cylinder(r = ft(4.3), h = ft(2), $fn = 48); }
        translate([ft(c), -ft(0.2), ft(76)]) clock_face(8.6);
        paint("doors") translate([ft(c), -ft(0.3), ft(76)]) for (a = [30, 300]) rotate([0, a, 0]) translate([-ft(0.15), 0, 0]) cube([ft(0.3), ft(0.1), ft(3.2)]);   // hands
        // corbelled arcade under the cornice
        paint("trim") for (u = [1.5 : 1.5 : TW - 1]) translate([ft(u), -ft(0.4), ft(83.6)]) rotate([-90, 0, 0]) difference() {
            cylinder(r = ft(0.75), h = ft(0.4), $fn = 16); translate([-ft(1), 0, -1]) cube([ft(2), ft(1), ft(1) + 2]); }
    }
    paint("trim") { tbox(-0.4, -0.4, 83, TW + 0.8, TW + 0.8, 0.6); tbox(-1.2, -1.2, 86, TW + 2.4, TW + 2.4, 2.5);
                    tbox(-1.8, -1.8, 88.5, TW + 3.6, TW + 3.6, 1); }
    // balustrade
    paint("trim") difference() { tbox(-1, -1, 89.5, TW + 2, TW + 2, 3); tbox(0, 0, 89, TW, TW, 5);
        for (s = [0 : 3]) on_tower(s) for (u = [2 : 2 : TW - 1.5]) lbox(u, 1.1, 90.1, 1.8, -1.5, 3); }
    paint("trim") tbox(-1.2, -1.2, 92.5, TW + 2.4, TW + 2.4, 0.6);
    // open clock stage 94-106: corner piers, arches, roundels, dark core
    paint("brick") difference() {
        tbox(0.5, 0.5, 93, TW - 1, TW - 1, 13);
        for (s = [0 : 3]) on_tower(s) { opening(c, 6, 94.5, 10, -1, 3, true);
            for (u = [c - 5.3, c + 5.3]) translate([ft(u), -ft(1), ft(101)]) rotate([-90, 0, 0]) cylinder(r = ft(1.3), h = ft(3)); }
        tbox(2.5, 2.5, 92, TW - 5, TW - 5, 16);
    }
    paint("glass") tbox(3, 3, 93, TW - 6, TW - 6, 13);                    // dark interior
    for (s = [0 : 3]) on_tower(s) {
        paint("trim") for (u = [c - 3.4, c + 3.4]) lbox(u, 0.8, 94.5, 6.5, 0.3, 0.8);      // columns
        for (u = [c - 5.3, c + 5.3]) translate([ft(u), ft(0.6), ft(101)]) clock_face(2.4);
    }
    paint("trim") { tbox(-0.3, -0.3, 105.6, TW + 0.6, TW + 0.6, 0.8); tbox(-1.1, -1.1, 106.4, TW + 2.2, TW + 2.2, 1.6); }
    // corner urns
    paint("trim") for (x = [0.3, TW - 1.7]) for (y = [0.3, TW - 1.7]) {
        tbox(x, y, 108, 1.4, 1.4, 1.6);
        translate([ft(TX0 + x + 0.7), ft(TY0 + y + 0.7), ft(111)]) { scale([1, 1, 1.4]) sphere(r = ft(1)); cylinder(r1 = ft(0.3), r2 = 0, h = ft(3.4)); }
    }
    // spire: octagonal drum, bell-shaped (ogee) scaled roof, lantern, finial
    translate([ft(TX0 + c), ft(TY0 + c), 0]) {
        paint("brick") translate([0, 0, ft(108)]) difference() { rotate(22.5) cylinder(r = ft(6.6), h = ft(4), $fn = 8);
            for (a = [0 : 90 : 270]) rotate(a) translate([ft(4), -ft(0.7), ft(0.8)]) cube([ft(4), ft(1.4), ft(2.4)]); }
        paint("trim") translate([0, 0, ft(111.8)]) rotate(22.5) cylinder(r = ft(7.2), h = ft(0.6), $fn = 8);
        paint("roof") rotate(22.5) rotate_extrude($fn = 8) polygon([for (p = [[0, 112.4], [6.8, 112.4], [6.9, 113.6], [6.5, 115.5], [5.4, 117.8],
                [4.0, 120.0], [3.0, 122.2], [2.5, 124.2], [2.4, 126], [0, 126]]) [ft(p[0]), ft(p[1])]]);
        paint("trim") translate([0, 0, ft(126)]) rotate(22.5) cylinder(r = ft(2.8), h = ft(0.5), $fn = 8);
        paint("trim") translate([0, 0, ft(126.5)]) difference() { rotate(22.5) cylinder(r = ft(2.3), h = ft(4.5), $fn = 8);
            for (a = [0 : 45 : 315]) rotate(a) translate([ft(1.2), -ft(0.45), ft(0.6)]) cube([ft(2), ft(0.9), ft(3)]); }
        paint("glass") translate([0, 0, ft(126.6)]) cylinder(r = ft(1.4), h = ft(4.3), $fn = 8);
        paint("roof") translate([0, 0, ft(131)]) { rotate(22.5) cylinder(r1 = ft(2.6), r2 = ft(1.2), h = ft(1.2), $fn = 8);
            translate([0, 0, ft(1.2)]) scale([1, 1, 1.2]) sphere(r = ft(1.15)); }
        paint("trim") translate([0, 0, ft(133.5)]) { cylinder(r = ft(0.18), h = ft(6.5), $fn = 8);
            translate([0, 0, ft(2.4)]) sphere(r = ft(0.55)); translate([0, 0, ft(4)]) sphere(r = ft(0.35)); }
    }
}

// ---------------------------------------------------------------------
//  midway (one story, between head house and shed)
// ---------------------------------------------------------------------
MID_S = [[6, 9, 0.6, 13.5, 3], [17.5, 9, 0.6, 13.5, 3]];   // two big arches (sheet 03); north the same (ESTIMATE)
module midway() {
    paint("stone") difference() {
        fbox(MX0, 0, 0, MX1 - MX0, HY, MH);
        onface("S", MX0) cuts(MID_S);  onface("N", MX0, MX1, 0, HY) cuts(MID_S);
        fbox(MX0 + 1, 1, -1, MX1 - MX0 - 1.01, HY - 2, MH + 2);
        fbox(MX1 - 1.5, 6, -1, 2, HY - 12, MH - 2);                     // open to the shed
    }
    onface("S", MX0) fills(MID_S);  onface("N", MX0, MX1, 0, HY) fills(MID_S);
    paint("trim") difference() { fbox(MX0 - 0.01, -0.6, MH - 1, MX1 - MX0, HY + 1.2, 1); fbox(MX0, 0.5, MH - 2, MX1 - MX0 + 1, HY - 1, 3); }
    paint("roof") fbox(MX0, 0, MH - 0.5, MX1 - MX0, HY, 0.5);
    paint("glass") fbox(MX0 + 4, 10, MH, MX1 - MX0 - 8, HY - 20, 0.6);  // skylight (ESTIMATE)
}

// ---------------------------------------------------------------------
//  train shed: steel posts every S_BAY ft, lattice beams, Fink trusses,
//  slate roof with a raised monitor, platforms, rails
// ---------------------------------------------------------------------
function roof_z(y) = let (d = abs(y - (SY0 + SW / 2))) d >= S_MON / 2 ? S_EAVE + (S_TOP - S_EAVE) * (SW / 2 - d) / (SW / 2 - S_MON / 2) : S_TOP;
module member(a, b, t = 0.6, x = 0) hull() { translate([ft(x - t / 2), ft(a[0] - t / 2), ft(a[1] - t / 2)]) cube(ft(t));
                                            translate([ft(x - t / 2), ft(b[0] - t / 2), ft(b[1] - t / 2)]) cube(ft(t)); }
module fink(x) {
    y0 = SY0; y1 = SY0 + SW; m = SY0 + SW / 2; e = S_EAVE; t = S_TOP - 1;
    q1 = [y0 + SW / 4, (e + t) / 2]; q2 = [y1 - SW / 4, (e + t) / 2];
    b1 = [y0 + SW / 3, e + 1]; b2 = [y1 - SW / 3, e + 1];
    member([y0, e], [m, t], 0.8, x); member([y1, e], [m, t], 0.8, x);          // top chords
    member([y0, e], b1, 0.6, x); member(b1, b2, 0.6, x); member(b2, [y1, e], 0.6, x);   // bottom chord (cambered)
    for (p = [[b1, q1], [b1, [m, t]], [b2, q2], [b2, [m, t]], [[y0 + SW / 6, (e * 3 + e + 1) / 4], [y0 + SW / 8, e + (t - e) / 4]],
              [[y1 - SW / 6, (e * 3 + e + 1) / 4], [y1 - SW / 8, e + (t - e) / 4]], [[y0 + SW / 6, e + 0.5], q1], [[y1 - SW / 6, e + 0.5], q2]])
        member(p[0], p[1], 0.35, x);
}
module shed() {
    n = floor(SL / S_BAY);
    paint("steel") for (i = [0 : n]) let (x = SX0 + i * S_BAY) {
        for (y = [SY0, SY0 + SW]) {
            fbox(x - 0.5, y - 0.5, 0, 1, 1, S_EAVE);                               // post (latticed in life)
            fbox(x - 0.8, y - 0.8, 0, 1.6, 1.6, 1.2);                              // base
            for (s = [-1, 1]) hull() { fbox(x - 0.1, y - 0.2 + s * 0.4, S_EAVE - 5, 0.2, 0.4, 0.2); fbox(x - 0.1, y + s * 3.5 - 0.2, S_EAVE - 0.4, 0.2, 0.4, 0.4); }  // bracket
        }
        fink(x);
    }
    paint("steel") for (y = [SY0, SY0 + SW]) difference() {                        // longitudinal lattice beams
        fbox(SX0 - 0.5, y - 0.3, S_EAVE - 3, SL + 1, 0.6, 3);
        for (x = [SX0 + 1.5 : 3 : SX0 + SL - 1]) translate([ft(x), ft(y - 1), ft(S_EAVE - 1.5)]) rotate([0, 45, 0]) cube([ft(1.2), ft(2), ft(1.2)], center = true);
    }
    // roof slopes and monitor
    paint("roof") for (s = [0, 1]) let (yE = s ? SY0 + SW + 3 : SY0 - 3, yM = SY0 + SW / 2 + (s ? 1 : -1) * S_MON / 2,
                                         zE = S_EAVE - 3 * (S_TOP - S_EAVE) / (SW / 2 - S_MON / 2)) hull() {
        fbox(SX0, yE - 0.05, zE, SL + 2, 0.1, 0.4); fbox(SX0, yM - 0.05, S_TOP, SL + 2, 0.1, 0.4); }
    paint("glass") for (s = [-1, 1]) fbox(SX0 + 2, SY0 + SW / 2 + s * S_MON / 2 - 0.1, S_TOP + 0.3, SL - 2, 0.2, S_RIDGE - S_TOP - 1.2);   // monitor sides (ESTIMATE glazed)
    paint("steel") for (x = [SX0 + 2 : S_BAY / 2 : SX0 + SL]) for (s = [-1, 1]) fbox(x - 0.15, SY0 + SW / 2 + s * S_MON / 2 - 0.2, S_TOP + 0.3, 0.3, 0.4, S_RIDGE - S_TOP - 1);
    paint("roof") hull() { fbox(SX0, SY0 + SW / 2 - S_MON / 2 - 1.5, S_RIDGE - 1, SL + 2, 0.1, 0.3);
                           fbox(SX0, SY0 + SW / 2 + S_MON / 2 + 1.4, S_RIDGE - 1, SL + 2, 0.1, 0.3);
                           fbox(SX0, SY0 + SW / 2 - 0.05, S_RIDGE, SL + 2, 0.1, 0.3); }
    // smoke jacks over the tracks (ESTIMATE)
    paint("steel") for (x = [SX0 + 40, SX0 + SL / 2]) for (y = [TRACKS_Y[0], TRACKS_Y[1], TRACKS_Y[3], TRACKS_Y[4]]) fbox(x, y - 1.5, roof_z(y) - 1, 6, 3, 5);
    // platforms between the tracks
    paint("platform") for (p = [[SY0, 6 - SY0], [18, 7], [37, 7], [56, 7], [75, 7], [94, SY0 + SW - 94]]) fbox(SX0, p[0], 0, SL + 2, p[1], 0.7);
    paint("platform") fbox(SX0 - 0.01, SY0, 0, 10, SW, 0.7);             // head (concourse) platform
    if (SHOW_TRACKS) paint("rails") for (y = TRACKS_Y) for (r = [-2.35, 2.35]) fbox(SX0 + 12, y + r - 0.12, 0, SL + 40, 0.24, 0.55);
}

// ---------------------------------------------------------------------
//  baggage building (225 x 20 x 14) and the 75 ft chimney
// ---------------------------------------------------------------------
module baggage() {
    paint("brick") difference() {
        fbox(BX0, BY0, 0, BL, BW, BH);
        fbox(BX0 + 1, BY0 + 1, -1, BL - 2, BW - 2, BH + 2);
        for (x = [BX0 + 8 : 15 : BX0 + BL - 6]) fbox(x - 3, BY0 - 0.1, 0.8, 6, 1.2, 9);               // doors to the tracks (ESTIMATE)
        for (x = [BX0 + 15.5 : 15 : BX0 + BL - 6]) fbox(x - 1.75, BY0 + BW - 1.1, 4.5, 3.5, 1.2, 5.5); // windows on the north side (ESTIMATE)
    }
    paint("doors") for (x = [BX0 + 8 : 15 : BX0 + BL - 6]) fbox(x - 3, BY0 + 0.6, 0.8, 6, 0.2, 9);
    paint("glass") for (x = [BX0 + 15.5 : 15 : BX0 + BL - 6]) fbox(x - 1.75, BY0 + BW - 0.8, 4.5, 3.5, 0.1, 5.5);
    paint("stone") difference() { fbox(BX0 - 0.2, BY0 - 0.2, 0, BL + 0.4, BW + 0.4, 1.5); fbox(BX0 + 0.5, BY0 + 0.5, -1, BL - 1, BW - 1, 4); }
    paint("trim") fbox(BX0 - 0.4, BY0 - 0.4, BH, BL + 0.8, BW + 0.8, 0.7);
    paint("roof") fbox(BX0, BY0, BH - 0.5, BL, BW, 0.6);
    // chimney at the east end
    paint("chimney") translate([ft(BX0 + BL - 4), ft(BY0 + BW / 2), 0]) {
        translate([-ft(4.5), -ft(4.5), 0]) cube([ft(9), ft(9), ft(BH + 2)]);
        cylinder(r1 = ft(4), r2 = ft(2.8), h = ft(75), $fn = 24);
        translate([0, 0, ft(73)]) cylinder(r = ft(3.3), h = ft(2), $fn = 24);
    }
}
module umbrella() {
    paint("steel") for (x = [SX0 + SL + 5 : 25 : SX0 + SL + 300]) fbox(x - 0.4, SY0 + SW / 2 - 0.4, 0, 0.8, 0.8, 14);
    paint("roof") fbox(SX0 + SL, SY0 + SW / 2 - 10, 14, 305, 20, 0.6);
}

// ---------------------------------------------------------------------
head_house();
tower();
midway();
if (SHOW_SHED) shed();
if (SHOW_BAGGAGE) baggage();
if (SHOW_UMBRELLA) umbrella();
paint("foundation") fbox(-8, -6, -0.3, MX1 + 8, HY + 12, 0.3);    // sidewalk / base pad
if (SHOW_SHED) paint("foundation") fbox(SX0, SY0 - 4, -0.3, SL + 45, SW + (SHOW_BAGGAGE ? BW + 8 : 8), 0.3);   // ballast / yard ground
