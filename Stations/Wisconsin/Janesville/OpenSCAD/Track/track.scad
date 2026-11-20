// =====================================================================
//  Track  -  straight display track in front of the platform (G gauge, 45 mm)
//  Static display track with printed rails (not for powered running; for running trains
//  lay commercial G track in the same place - rail top height matches).
//
//  Change these to suit:
//    GAUGE         45 mm (G / No.1 gauge)
//    TRACK_Y       track center line, ft from the track-side wall (negative = toward the track)
//    N_TRACKS      number of parallel tracks, TRACK_SPACING ft apart (away from the station)
//    TRACK_X0/X1   ends of the track, ft (default = the ends of the brick platform)
//
//  Three bodies per section for the AMS (load together as one object):
//    Track_ballast  gray       Track_ties  dark brown       Track_rails  rust / steel
//  Printed flat as it sits.  Sections butt together; joints fall between ties.
//  Total height 6.3 mm, so the rail top is about 7" (scale) below the platform top.
// =====================================================================
include <../janesville_common.scad>
use <../Platform/platform.scad>

GAUGE = 45;
TRACK_Y = -24.6;
N_TRACKS = 1;
TRACK_SPACING = 14;
PXE = platform_x();
TRACK_X0 = PXE[0]; TRACK_X1 = PXE[1];
TIE = [ft(0, 9), ft(8.5)];          // tie width (along the track), length
TIE_PITCH = ft(1.75);               // 21" centers (adjusted slightly so every section ends between ties)
BALLAST_W = ft(11);
Z_BASE = 0.8; Z_BAL = 1.6; Z_TIE = 2.0;                  // ballast sheet, ballast between ties, tie tops (mm)
RAIL = [4.0, 0.8, 1.3, 2.2, 2.2, 1.3];                   // foot width, foot h, web width, web h, head width, head h
RAIL_TOP = Z_TIE + RAIL[1] + RAIL[3] + RAIL[5];          // 6.3 mm
PART = "Track_ballast"; TILE = -1; LAYER = -1; LIST = false;

function track_count(bed) = ceil(ft(TRACK_X1 - TRACK_X0) / (bed[0] - 10));
function track_parts(bed) = [["Track_ballast", track_count(bed)], ["Track_ties", track_count(bed)], ["Track_rails", track_count(bed)]];
function track_rail_top() = RAIL_TOP;
function track_y() = TRACK_Y;

// one section, origin at its west end on the track center line
module ties2d(L) { n = round(L / TIE_PITCH); p = L / n;
    for (i = [0 : n - 1]) translate([(i + 0.5) * p - TIE[0] / 2, -TIE[1] / 2]) square(TIE); }
module rails2d(L, w) for (s = [-1, 1]) translate([0, s * (GAUGE / 2 + RAIL[4] / 2) - w / 2]) square([L, w]);
module section_layer(L, k) {
    if (k == 0) linear_extrude(Z_BASE) translate([0, -BALLAST_W / 2]) square([L, BALLAST_W]);
    if (k == 1) translate([0, 0, Z_BASE]) linear_extrude(Z_BAL - Z_BASE) difference() {
        translate([0, -BALLAST_W / 2 + 3]) square([L, BALLAST_W - 6]); ties2d(L); }
    if (k == 2) translate([0, 0, Z_BASE]) linear_extrude(Z_TIE - Z_BASE) ties2d(L);
    if (k == 3) translate([0, 0, Z_TIE]) linear_extrude(RAIL[1]) rails2d(L, RAIL[0]);
    if (k == 4) translate([0, 0, Z_TIE + RAIL[1]]) linear_extrude(RAIL[3]) rails2d(L, RAIL[2]);
    if (k == 5) translate([0, 0, Z_TIE + RAIL[1] + RAIL[3]]) linear_extrude(RAIL[5]) rails2d(L, RAIL[4]);
}
function track_layers(n) = n == "Track_ballast" ? [0, 1] : n == "Track_ties" ? [2] : [3, 4, 5];
module track_layer(tile, k, bed = BED) {
    n = track_count(bed); L = ft(TRACK_X1 - TRACK_X0) / n;
    if (tile >= 0) translate([0, BALLAST_W / 2, 0]) section_layer(L, k);
    else for (t = [0 : N_TRACKS - 1]) for (i = [0 : n - 1])
        translate([ft(TRACK_X0) + i * L, ft(TRACK_Y - t * TRACK_SPACING), 0]) section_layer(L, k);
}
module track_part(n, tile = -1, bed = BED) for (k = track_layers(n)) track_layer(tile, k, bed);
module track_place() {
    color("#8A8A85") track_part("Track_ballast"); color("#4A3628") track_part("Track_ties"); color("#6E4A3A") track_part("Track_rails");
}

if (LIST) for (p = track_parts(BED)) echo(str("TPART|", p[0], "|", p[1]));
else if (LAYER >= 0) track_layer(TILE, LAYER, BED);
else if (TILE < 0) track_place();
else track_part(PART, TILE, BED);
