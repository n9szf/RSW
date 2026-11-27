// =====================================================================
//  BRODHEAD, WIS. DEPOT - TODAY (Brodhead Historical Society Depot Museum)
//  Same model as Brodhead_Depot.scad with ERA 2026: bay gone (two windows in its place),
//  steel-sided east addition with an overhead door, museum colours.
//  Colours from Google Street View (2020s): cream walls, dark red hoods, sills and base band,
//  red-brown brackets and fascia, red-brown shingles, white sash.  The 2017-18 Knight
//  addition (L-shaped, south-east) is NOT modelled.  Rib Side Works, 26 Nov 2026.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
ERA_SET = 2026;
include <Brodhead_Depot.scad>
COL_BRICK = "#E9E1C8";
COL_TRIM  = "#7A3328";
COL_SASH  = "#F2EFE6";
COL_BODY  = "#E4DCC2";
COL_ROOF  = "#8C4A3E";
COL_STONE = "#7E2E26";
COL_DOOR  = "#6E2A24";
COL_GLASS = "#3F5866";   // unchanged builder colours, repeated for make_glb.py
COL_FOUND = "#A8A398";
COL_PLAT  = "#8E8A84";
COL_STUC  = "#D8CDB2";
// Same list as _common/rsw_depot.scad, repeated here so make_glb.py finds the colours
// (it reads one include level; module paint(n) itself comes from rsw_depot.scad).
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH]];
