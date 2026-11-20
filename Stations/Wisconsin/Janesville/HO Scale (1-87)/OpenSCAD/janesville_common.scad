// =====================================================================
//  CMSP Janesville WI Station - shared settings and footprint
//  Frost & Granger, 1902 as-built prints.  HO scale 1:87 (adapted from the G scale 1:29 model).  Units: model mm.
//  Every other .scad file in this project does:  include <../janesville_common.scad>
// =====================================================================

// ---------- scale ----------
SCALE = 87;
BX = 2;        // brick, slate and tile texture is drawn this many times oversize so a 0.4 mm nozzle can print it
$sc = 0;      // furniture is drawn at the G-scale size and reduced: see g() in Furniture/interior.scad
function ft(f, i = 0) = (f * 12 + i) * 25.4 / ($sc == 0 ? SCALE : $sc);   // real feet + inches -> model mm

// ---------- printer ----------
// "P1S"  = Bambu Lab P1S, 256 x 256 x 256 bed  (use 252 usable)
// "GIGA" = Tom's large-format printer, 800 x 800 x 1000 (use 780 usable)
PRINTER = "P1S";
function bed_for(p) = p == "GIGA" ? [780, 780, 980] : [252, 252, 250];
BED = bed_for(PRINTER);

// ---------- colors (preview only; print color = filament) ----------
PULLMAN_GREEN = "#3B4A2C";   // windows, doors, trim
BRICK_RED     = "#8E3B2C";
MORTAR_WHITE  = "#F2EFE6";
STONE_BUFF    = "#C9B79C";

// ---------- joints between printed sections ----------
PIN_D      = 1.75;   // alignment pin (a stub of 1.75 mm filament)
PIN_CLEAR  = 0.2;   // hole oversize
PIN_DEPTH  = 4;      // hole depth each side of a cut
CUT_BAND   = 3;      // solid band each side of a cut so pins land in plastic

// ---------- NeoPixel wiring ----------
WIRE_CHANNEL = [6, 3.5];   // width x height of notches in under-floor ribs (3-wire bus)
FEED_HOLE_D  = 5;         // hole up through the floor into each room

// ---------- coordinates ----------
// x runs west -> east along the track.  x = 0 at the west end wall line.
// y = 0 at the main track-side wall line, +y toward town.
// Dimensions are to the MAIN WALL LINE (as the drawings are figured).

// Main building, B2077 / B2076.  Overall 128'-5".
X_WEST_END   = 0;
X_PAV_W      = ft(38, 9);                 // general waiting room wing  38'-9"
X_PAV_E      = X_PAV_W + ft(22, 6);       // center pavilion            22'-6"
X_SMOKE_E    = X_PAV_E + ft(36, 10);      // smoking room wing          36'-10"
X_MAIN_E     = X_SMOKE_E + ft(30, 4);     // lunch room wing            30'-4"  -> 128'-5"
MAIN_DEPTH   = ft(32, 0);                 // west wing, pavilion, smoking wing

// Lunch-room wing is narrower: 25'-4" deep (7'-2" + 11'-0" + 7'-2"),
// set back 1'-5" on the track side and 5'-3" on the town side.  VERIFY vs B2078/B2079.
LUNCH_Y0     = ft(1, 5);
LUNCH_Y1     = LUNCH_Y0 + ft(25, 4);

// Pavilion projections.  APPROXIMATE - verify against elevations.
PORCH_PROJ   = ft(3, 6);    // town side: two 6'-9" blocks project 3'-6"
PORCH_W      = ft(9, 0);    // recessed porch between them (open to y = MAIN_DEPTH)
BAY_PROJ     = ft(3, 0);    // track side: canted ticket-office bay
BAY_W_WALL   = ft(15, 6);   // bay width at the wall
BAY_W_FRONT  = ft(9, 6);    // bay width at its face
BAY_CX       = ft(46, 11);  // bay center from west end (B2077 track-side chain), not centered on the pavilion

// Baggage & express building, B2077: 47'-2" x 25'-4", 42'-0" east of the main building.
// Track wall assumed in line with the lunch wing.  VERIFY.
X_BAG_W      = X_MAIN_E + ft(42, 0);
X_BAG_E      = X_BAG_W + ft(47, 2);
BAG_Y0       = LUNCH_Y0;
BAG_Y1       = BAG_Y0 + ft(25, 4);

// Wall thicknesses (model mm)
T_MAIN  = 3.0;     // main block exterior walls (real 1'-5" = 5.0 mm, thinned)
T_LIGHT = 2.6;     // lunch wing, porch, bay, baggage building

// Heights (B2082 / B2078)
FLOOR_Z      = ft(1, 9);    // finished floor above finished grade
WALL_H       = ft(19, 0);   // floor to cornice, town side
SILL_H       = ft(2, 9);    // floor to top of window sill
BASE_PROJ    = ft(0, 4);    // stone base / water table projects past the wall line

// ---------- footprints (2D) ----------
module footprint_main() {
    union() {
        translate([X_WEST_END, 0]) square([X_SMOKE_E - X_WEST_END, MAIN_DEPTH]);
        translate([X_SMOKE_E, LUNCH_Y0]) square([X_MAIN_E - X_SMOKE_E, LUNCH_Y1 - LUNCH_Y0]);
        // town-side pavilion blocks with the recessed porch between them
        difference() {
            translate([X_PAV_W, MAIN_DEPTH - 0.01]) square([X_PAV_E - X_PAV_W, PORCH_PROJ]);
            translate([(X_PAV_W + X_PAV_E - PORCH_W) / 2, MAIN_DEPTH - 1]) square([PORCH_W, PORCH_PROJ + 2]);
        }
        // track-side canted bay
        let(cx = BAY_CX)
        polygon([[cx - BAY_W_WALL / 2, 0.01], [cx + BAY_W_WALL / 2, 0.01],
                 [cx + BAY_W_FRONT / 2, -BAY_PROJ], [cx - BAY_W_FRONT / 2, -BAY_PROJ]]);
    }
}

module footprint_baggage() {
    translate([X_BAG_W, BAG_Y0]) square([X_BAG_E - X_BAG_W, BAG_Y1 - BAG_Y0]);
}
