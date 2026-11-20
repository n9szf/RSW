// =====================================================================
//  Wood base  -  the board the whole model sits on (NOT printed: cut it from 3/4" plywood)
//  It lies under everything: track, platform, both buildings and the canopy.
//  Two pieces, joined in the gap between the depot and the baggage building, so each fits a
//  standard 4 x 8 ft (1220 x 2440 mm) sheet.  Holes: one under every foundation wire feed
//  hole, plus one for the canopy lighting riser.
//
//  Cutting and drilling drawing: Notes/"Wood Base - cutting and drilling.pdf"
//  CNC / template outlines: OpenSCAD/Base/wood_base_west.dxf and wood_base_east.dxf
//  PIECE = "both" (default), "west" or "east";  FLAT = true gives the 2D outline for DXF export.
// =====================================================================
include <../janesville_common.scad>
use <../Platform/platform.scad>
use <../Canopy/canopy.scad>
POST_D = 3.6;                 // holes for the brass-tube canopy posts: 2.38 mm square tube is 3.4 mm corner to corner -> drill 9/64 in

BASE_T = 19;                 // a 1 x 12 board is 3/4" thick (mm)
MARGIN = 20;                 // board shows this far beyond the model all round (mm)
HOLE_D = 6;                 // wire holes (mm)
WOOD = "#B88A55";
PIECE = "both"; FLAT = false;

PXB = platform_x();                              // platform ends (ft)
X0 = ft(PXB[0]) - MARGIN;  X1 = ft(PXB[1]) + MARGIN;
Y0 = ft(-24.6 - 5.5) - MARGIN;                   // beyond the far edge of the ballast
Y1 = MAIN_DEPTH + PORCH_PROJ + BASE_PROJ + MARGIN;   // town side of the porch
XJ = ft(150);                                    // joint, in the 42 ft gap between the buildings
// wire holes (mm, model coordinates): the foundation feed holes + the canopy riser at the east shelter
HOLES = [[X_PAV_W / 2, MAIN_DEPTH / 2], [(X_PAV_W + X_PAV_E) / 2, ft(6)], [(X_PAV_W + X_PAV_E) / 2, ft(16)], [(X_PAV_W + X_PAV_E) / 2 - ft(5), ft(26)],
         [(X_PAV_E + X_SMOKE_E) / 2 - ft(4), MAIN_DEPTH / 2], [X_SMOKE_E - ft(6), ft(25)], [X_SMOKE_E + ft(12), ft(9)], [X_SMOKE_E + ft(10), ft(21)],
         [X_BAG_W + ft(14), (BAG_Y0 + BAG_Y1) / 2], [X_BAG_E - ft(10), (BAG_Y0 + BAG_Y1) / 2],
         [X_BAG_E + ft(20) + 6, ft(-13.33)]];
function base_size() = [X1 - X0, Y1 - Y0, XJ - X0, X1 - XJ];      // overall L, W, west piece L, east piece L
function base_post_holes() = [for (p = canopy_post_xy()) [ft(p[0]) - X0, ft(p[1]) - Y0]];
function base_holes() = [for (h = HOLES) [h[0] - X0, h[1] - Y0]];  // from the west / track-side corner

module base2d(piece = "both") difference() {
    translate([piece == "east" ? XJ : X0, Y0]) square([(piece == "west" ? XJ : X1) - (piece == "east" ? XJ : X0), Y1 - Y0]);
    for (h = HOLES) translate(h) circle(d = HOLE_D, $fn = 32);
    for (p = canopy_post_xy()) translate([ft(p[0]), ft(p[1])]) circle(d = POST_D, $fn = 16);
}
module base_place() color(WOOD) translate([0, 0, -BASE_T]) linear_extrude(BASE_T) base2d("both");      // HO: one board

if (FLAT) base2d(PIECE); else base_place();
