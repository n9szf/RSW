// =====================================================================
//  Foundation base  -  grade to finished floor (1'-9" = 18.4 mm)
//  Hollow underneath with ribs.  The top is the building floor.
//  NeoPixel: notches in every rib form a free wiring space under the floor,
//  and an 8 mm feed hole comes up into each room.
//
//  Open this file on its own to look at / export the base, or open
//  ../Janesville_Station.scad to see everything together.
//  foundation_base(building, tile, bed):
//    building = "main" or "baggage"
//    tile     = -1 whole base, 0..n-1 one printable section
//    bed      = printer bed from janesville_common.scad (BED, or bed_for("GIGA"))
// =====================================================================
include <../janesville_common.scad>

// ---- settings when this file is opened directly ----
BUILDING = "main";      // "main" or "baggage"
TILE     = -1;          // -1 = whole base, 0..n-1 = one printable section

SHELL  = 1.6;           // outer wall
TOP_T  = 1.2;           // floor plate
RIB_T  = 1.6;
RIB_SP = 40;            // rib spacing

// approximate room centers for wire feed holes (refined when interiors are drawn)
FEEDS_MAIN = [
    [X_PAV_W / 2,                  MAIN_DEPTH / 2],     // general waiting room
    [(X_PAV_W + X_PAV_E) / 2,      ft(6)],              // ticket office
    [(X_PAV_W + X_PAV_E) / 2,      ft(16)],             // passage
    [(X_PAV_W + X_PAV_E) / 2 - ft(5), ft(26)],          // women's toilet
    [(X_PAV_E + X_SMOKE_E) / 2 - ft(4), MAIN_DEPTH / 2], // smoking room
    [X_SMOKE_E - ft(6),            ft(25)],             // men's toilet
    [X_SMOKE_E + ft(12),           ft(9)],              // lunch room
    [X_SMOKE_E + ft(10),           ft(21)]              // kitchen
];
FEEDS_BAG = [
    [X_BAG_W + ft(14),             (BAG_Y0 + BAG_Y1) / 2],   // baggage room
    [X_BAG_E - ft(10),             (BAG_Y0 + BAG_Y1) / 2]    // express room
];

// ---------- helpers ----------
function base_bb(b) = b == "main"
    ? [[X_WEST_END - BASE_PROJ, -BAY_PROJ - BASE_PROJ], [X_MAIN_E + BASE_PROJ, MAIN_DEPTH + PORCH_PROJ + BASE_PROJ]]
    : [[X_BAG_W - BASE_PROJ, BAG_Y0 - BASE_PROJ], [X_BAG_E + BASE_PROJ, BAG_Y1 + BASE_PROJ]];
function grid_n(bb, bed) = [ceil((bb[1][0] - bb[0][0]) / bed[0]), ceil((bb[1][1] - bb[0][1]) / bed[1])];
function cuts(lo, hi, n) = n < 2 ? [] : [for (i = [1 : n - 1]) lo + i * (hi - lo) / n];

// number of printable sections - used by the build-all script
function foundation_count(b, bed) = let(n = grid_n(base_bb(b), bed)) n[0] * n[1];

module fp(b) { if (b == "main") footprint_main(); else footprint_baggage(); }

module foundation_base(building = "main", tile = -1, bed = BED) {
    bb    = base_bb(building);
    span  = bb[1] - bb[0];
    n     = grid_n(bb, bed);
    xcuts = cuts(bb[0][0], bb[1][0], n[0]);
    ycuts = cuts(bb[0][1], bb[1][1], n[1]);
    feeds = building == "main" ? FEEDS_MAIN : FEEDS_BAG;

    module outline() offset(delta = BASE_PROJ) fp(building);

    module ribs() {
        difference() {
            union() {
                for (x = [bb[0][0] : RIB_SP : bb[1][0]]) translate([x, bb[0][1], 0]) cube([RIB_T, span[1], FLOOR_Z]);
                for (y = [bb[0][1] : RIB_SP : bb[1][1]]) translate([bb[0][0], y, 0]) cube([span[0], RIB_T, FLOOR_Z]);
            }
            for (x = [bb[0][0] + RIB_SP / 2 : RIB_SP : bb[1][0]])
                translate([x - WIRE_CHANNEL[0] / 2, bb[0][1] - 1, -1]) cube([WIRE_CHANNEL[0], span[1] + 2, WIRE_CHANNEL[1] + 1]);
            for (y = [bb[0][1] + RIB_SP / 2 : RIB_SP : bb[1][1]])
                translate([bb[0][0] - 1, y - WIRE_CHANNEL[0] / 2, -1]) cube([span[0] + 2, WIRE_CHANNEL[0], WIRE_CHANNEL[1] + 1]);
        }
    }

    module cut_bands() {
        for (c = xcuts) translate([c - CUT_BAND, bb[0][1], 0]) cube([2 * CUT_BAND, span[1], FLOOR_Z]);
        for (c = ycuts) translate([bb[0][0], c - CUT_BAND, 0]) cube([span[0], 2 * CUT_BAND, FLOOR_Z]);
    }

    module pin_holes() {
        zc = (FLOOR_Z - TOP_T) / 2;
        for (c = xcuts) for (y = [bb[0][1] + 10 : 30 : bb[1][1] - 8])
            translate([c, y, zc]) rotate([0, 90, 0]) cylinder(d = PIN_D + PIN_CLEAR, h = 2 * PIN_DEPTH, center = true, $fn = 24);
        for (c = ycuts) for (x = [bb[0][0] + 10 : 30 : bb[1][0] - 8])
            translate([x, c, zc]) rotate([90, 0, 0]) cylinder(d = PIN_D + PIN_CLEAR, h = 2 * PIN_DEPTH, center = true, $fn = 24);
    }

    module whole() {
        difference() {
            union() {
                difference() {
                    linear_extrude(FLOOR_Z) outline();
                    translate([0, 0, -1]) linear_extrude(FLOOR_Z - TOP_T + 1) offset(delta = -SHELL) outline();
                }
                intersection() {
                    linear_extrude(FLOOR_Z) offset(delta = -SHELL + 0.01) outline();
                    union() { ribs(); cut_bands(); }
                }
            }
            for (p = feeds) translate([p[0], p[1], -1]) cylinder(d = FEED_HOLE_D, h = FLOOR_Z + 2, $fn = 32);
            // shallow stone coursing line at the water table (paint guide)
            translate([0, 0, FLOOR_Z - 2]) linear_extrude(0.6)
                difference() { offset(delta = 1) outline(); offset(delta = -0.3) outline(); }
            pin_holes();
        }
    }

    if (tile < 0) whole();
    else {
        ix = tile % n[0]; iy = floor(tile / n[0]);
        x0 = ix == 0 ? bb[0][0] - 1 : xcuts[ix - 1];
        x1 = ix == n[0] - 1 ? bb[1][0] + 1 : xcuts[ix];
        y0 = iy == 0 ? bb[0][1] - 1 : ycuts[iy - 1];
        y1 = iy == n[1] - 1 ? bb[1][1] + 1 : ycuts[iy];
        intersection() {
            whole();
            translate([x0, y0, -1]) cube([x1 - x0, y1 - y0, FLOOR_Z + 2]);
        }
    }
}

// runs only when this file is opened directly (ignored when another file "use"s it)
echo(str("BASE ", BUILDING, " ", PRINTER, ": ", foundation_count(BUILDING, BED), " sections"));
foundation_base(BUILDING, TILE, BED);
