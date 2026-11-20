// =====================================================================
//  CMSP Janesville WI Station  -  HO SCALE (1:87)  -  MASTER FILE
//  Open this one file to see the whole model, or to export any single part.
//
//  To rebuild EVERY STL for both printers in one go, double-click
//  "Build All STLs.command" in this folder (it runs this file once per part).
//
//  SHOW = "all"   -> everything assembled (press F5 to preview)
//  SHOW = a part name from PARTS below -> that part; TILE picks one printable section
//  Walls come in three bodies per section for multi-color printing (AMS):
//    Wall_<name>        brick red     Wall_<name>_mortar  white     Wall_<name>_stone  buff
//  Load all three of a section together in Bambu Studio as ONE object with three parts.
//  Window_<wall>_<n>  = window/door inserts, Pullman green
// =====================================================================
include <janesville_common.scad>
use <Basement/foundation_base.scad>
use <Walls/walls.scad>
use <Walls/interior_walls.scad>
use <Walls/windows.scad>
use <Roof/roofs.scad>
use <Walls/signs.scad>
use <Canopy/canopy.scad>
use <Platform/platform.scad>
use <Track/track.scad>
use <Furniture/interior.scad>
use <Walls/wall_liners.scad>
use <Base/base.scad>
use <People/people.scad>

// ---------------------------------------------------------------------------------
// CUSTOMIZER: Window > Customizer (untick "Hide Customizer"). Tick or untick the boxes
// below and the preview updates. They only change what is SHOWN, not the printed parts.
// ---------------------------------------------------------------------------------
/* [What to show] */
// Roofs (untick to look inside)
ROOF = true;
// Platform canopy
CANOPY = true;
// Ceilings over the ticket office block and the restrooms (untick to see into those rooms)
CEILINGS = true;
// Light bars across the waiting rooms, lunch room and baggage building
LIGHT_BARS = true;
// Cream and pine wall finish
LINERS_ON = true;
// Floors and furniture
FITOUT = true;
// Brick platform
PLATFORM = true;
// People (figures on the benches, in the rooms and on the platform)
PEOPLE = true;
// G-gauge display track is not part of the HO model (lay real HO track)
TRACK = false;
// Plywood base under the whole model (not printed)
BASE = true;

/* [Single part (for export)] */
// "all" = the whole model, or a part name from the parts list
SHOW = "all";
// -1 = whole part, 0..n-1 = one printable section
TILE = -1;
// true = print the parts list (used by the build script)
LIST = false;

/* [Hidden] */
// ---- parts registry: name, section count for the current PRINTER ----
// New parts (walls, roofs, sheds, furniture) get added here as they are built.
WL = walls_list();
IL = interior_list();
WN = window_list();
RP = roof_parts(BED);
CP = canopy_parts(BED);
PP = platform_parts(BED);
TP = track_parts(BED);
FP = interior_floor_parts(BED);
FU = furniture_parts();
LP = light_parts(BED);
NP = liner_parts(BED);
PARTS = concat(
    [["Foundation_main",    foundation_count("main", BED)],
     ["Foundation_baggage", foundation_count("baggage", BED)]],
    [for (w = WL) [str("Wall_", w), wall_count(w, BED)]],
    [for (w = WL) [str("Wall_", w, "_mortar"), wall_count(w, BED)]],
    [for (w = WL) [str("Wall_", w, "_stone"), wall_count(w, BED)]],
    [for (id = WN) [window_part_name(id), 1]],
    [for (p = RP) [p[0], p[1]]],
    [for (n = sign_parts()) [n, 1]],
    [for (p = CP) [p[0], p[1]]],
    [for (p = PP) [p[0], p[1]]],
    [for (p = FP) [p[0], p[1]]],
    [for (p = FU) [p[0], p[1]]],
    [for (p = LP) [p[0], p[1]]],
    [for (p = NP) [p[0], p[1]]],
    [for (w = WL) if (splice_count(w, BED) > 0) [str("Splices_", w), 1]],
    [for (w = IL) [str("Interior_", w), interior_count(w, BED)]],
    [for (w = IL) if (interior_splice_count(w, BED) > 0) [str("Splices_Int_", w), 1]]
);

module part(name, tile = -1) {
    if (name == "Foundation_main")    foundation_base("main", tile, BED);
    if (name == "Foundation_baggage") foundation_base("baggage", tile, BED);
    for (w = WL) {
        if (name == str("Wall_", w))           wall_part(w, tile, BED, "brick");
        if (name == str("Wall_", w, "_mortar")) wall_part(w, tile, BED, "mortar");
        if (name == str("Wall_", w, "_stone"))  wall_part(w, tile, BED, "stone");
        if (name == str("Splices_", w)) wall_splices(w, BED);
    }
    for (id = WN) if (name == window_part_name(id)) window_part(id);
    for (p = RP) if (name == p[0]) roof_part(name, tile, BED);
    for (n = sign_parts()) if (name == n) sign_part(n);
    for (p = CP) if (name == p[0]) canopy_part(name, tile, BED);
    for (p = PP) if (name == p[0]) platform_part(name, tile, BED);
    for (p = TP) if (name == p[0]) track_part(name, tile, BED);
    for (p = FP) if (name == p[0]) floor_part(name, tile, BED);
    for (p = FU) if (name == p[0]) furniture_part(name);
    for (p = LP) if (name == p[0]) light_part(name, tile, BED);
    for (p = NP) if (name == p[0]) liner_part(name, tile, BED);
    for (w = IL) {
        if (name == str("Interior_", w))     interior_part(w, tile, BED);
        if (name == str("Splices_Int_", w)) interior_splices(w, BED);
    }
}

if (LIST) {
    for (p = PARTS) echo(str("PART|", p[0], "|", p[1]));
} else if (SHOW == "all") {
    color("tan") { foundation_base("main", -1, BED); foundation_base("baggage", -1, BED); }
    for (w = WL) { color(BRICK_RED) wall_place(w, "brick"); color(MORTAR_WHITE) wall_place(w, "mortar");
                   color(STONE_BUFF) wall_place(w, "stone"); }
    for (id = WN) window_place(id);
    if (ROOF) roofs_place();
    chimney_base_place();
    sign_place();
    if (PLATFORM) platform_place();
    if (LINERS_ON) liners_place();
    if (FITOUT) interior_fit_place(CEILINGS, LIGHT_BARS);
    if (BASE) base_place();
    if (PEOPLE) people_place();
    if (CANOPY) { canopy_place(); sign_oval_place(); }
    color("burlywood") for (w = IL) interior_place(w);
} else {
    part(SHOW, TILE);
}
