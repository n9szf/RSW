// =====================================================================
//  Brick platform  -  under the whole canopy, out to the track, and 10 m (32.8 ft)
//  beyond each end of the canopy.  Top = 6" below the floor (canopy eave is 12'-0" above it).
//  Brick pavers 8" x 4" in running bond.  Two bodies for the AMS (load together):
//    Platform          brick red            Platform_mortar   white joints (top 0.4 mm only)
//  Square holes let the canopy column footings pass through and locate the columns.
//  Printed flat, brick up.  Sections butt together; they sit on the layout.
// =====================================================================
include <../janesville_common.scad>
use <../Canopy/canopy.scad>

EXT = 10 / 0.3048;                     // 10 m in feet
CE = canopy_x_ends();
PX0 = CE[0] - EXT; PX1 = CE[1] + EXT;  // platform ends (ft)
PY_TRACK = -19;                        // platform edge at the track (ft)
P_TOP = FLOOR_Z + ft(-0.5);            // platform top above grade (mm)
JOINT = 0.4;                           // mortar joint depth (mm)
BRK = [ft(0, 8), ft(0, 4)]; MJ = 0.55; // paver size, joint width (mm)
PL_BX0 = 98 + 1/12 + 30 + 4/12 + 42; PL_BX1 = PL_BX0 + 47 + 2/12; PL_LX1 = 98 + 1/12 + 30 + 4/12;
// regions (ft): the long strip at the track + the three areas behind it
REGIONS = [[PX0, PY_TRACK, PX1, 0], [CE[0], 0, 0, 10.5], [PL_LX1, 0, PL_BX0, 23], [PL_BX1, 0, CE[1], 23]];
PART = "Platform"; TILE = -1; LAYER = -1; LIST = false;

function platform_x() = [PX0, PX1];
function ptiles(bed) = [for (r = REGIONS) let(n = ceil(ft(r[2] - r[0]) / (bed[0] - 10)), w = (r[2] - r[0]) / n)
    for (i = [0 : n - 1]) [r[0] + i * w, r[1], r[0] + (i + 1) * w, r[3]]];
function platform_count(bed) = len(ptiles(bed));
function platform_parts(bed) = [["Platform", platform_count(bed)], ["Platform_mortar", platform_count(bed)]];

module plat2d() difference() {
    for (r = REGIONS) translate([ft(r[0]), ft(r[1])]) square([ft(r[2] - r[0]), ft(r[3] - r[1])]);
    offset(delta = BASE_PROJ + 0.4) { footprint_main(); footprint_baggage(); }
    for (p = canopy_post_xy()) translate([ft(p[0]), ft(p[1])]) square(ft(1.25) + 0.6, center = true);
    translate([ft(PL_BX1 + 20) + 12, ft(-13.33)]) circle(d = 9, $fn = 24);      // wire slot beside the east-shelter column: canopy lighting riser
}
module tile2d(t) intersection() { plat2d(); translate([ft(t[0]), ft(t[1])]) square([ft(t[2] - t[0]), ft(t[3] - t[1])]); }
module grooves(t) {
    x0 = ft(t[0]); x1 = ft(t[2]); y0 = ft(t[1]); y1 = ft(t[3]); px = BRK[0]; py = BRK[1];
    for (j = [floor(y0 / py) : ceil(y1 / py)]) {
        translate([x0 - 1, j * py - MJ / 2]) square([x1 - x0 + 2, MJ]);
        for (i = [floor(x0 / px) - 1 : ceil(x1 / px)]) translate([(i + (j % 2 == 0 ? 0 : 0.5)) * px - MJ / 2, j * py]) square([MJ, py]);
    }
}
module platform_layer(tile, k, bed = BED) {
    T = ptiles(bed);
    for (i = [0 : len(T) - 1]) if (tile < 0 || tile == i) translate(tile < 0 ? [0, 0, 0] : [-ft(T[i][0]), -ft(T[i][1]), 0]) {
        if (k == 0) linear_extrude(P_TOP - JOINT) tile2d(T[i]);
        if (k == 1) translate([0, 0, P_TOP - JOINT]) linear_extrude(JOINT) difference() { tile2d(T[i]); if (tile >= 0) grooves(T[i]); }
        if (k == 2 && tile >= 0) translate([0, 0, P_TOP - JOINT]) linear_extrude(JOINT) intersection() { tile2d(T[i]); grooves(T[i]); }
    }
}
module platform_part(n, tile = -1, bed = BED) {
    if (n == "Platform") { platform_layer(tile, 0, bed); platform_layer(tile, 1, bed); }
    if (n == "Platform_mortar") platform_layer(tile, 2, bed);
}
module platform_place() color(BRICK_RED) { platform_layer(-1, 0); platform_layer(-1, 1); }

if (LIST) for (p = platform_parts(BED)) echo(str("PPART|", p[0], "|", p[1]));
else if (LAYER >= 0) platform_layer(TILE, LAYER, BED);
else platform_part(PART, TILE, BED);
