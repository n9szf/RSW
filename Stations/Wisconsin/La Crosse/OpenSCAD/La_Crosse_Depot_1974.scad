// =====================================================================
//  MILWAUKEE ROAD - LA CROSSE, WIS. - 1974 CANOPY VERSION
//  The whole model comes from La_Crosse_Depot.scad (same folder); this file only flips
//  the canopy switches, so it never needs editing when the main model changes.
//  CANOPY_1974: flat canopy on curved brackets along the track side of the baggage
//  building and breezeway, as in photo 03 (Jerry Plant, Aug 1974, from the US 53 bridge).
//  The station's hung 1927 canopy is off (none on the station in the 1974 photo).
//  Not changed (ESTIMATE / to do): in 1974 the station roof was dark gray asphalt and the
//  breezeway was being closed in - the model keeps the 1927 red tile and open breezeway.
//  Rib Side Works, 26 Nov 2026.  'Make La Crosse GLB.bat' builds this as La_Crosse_Depot_1974.glb.
// =====================================================================
include <La_Crosse_Depot.scad>
CANOPY_1927 = false;
CANOPY_1974 = true;

// make_glb.py reads only this file and the files it includes from this folder, so the colour
// list and paint() are repeated here (same values as the builder and the main file) - otherwise
// the .glb comes out as one grey piece.
PAINTS = [["walls", "#BDBDB6"], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", "#3F5866"], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH]];
module paint(n) { if (PAINT == "" || PAINT == n) color([for (p = PAINTS) if (p[0] == n) p[1]][0]) children(); }
