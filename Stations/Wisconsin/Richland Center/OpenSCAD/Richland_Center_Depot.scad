// =====================================================================
//  MILWAUKEE ROAD - RICHLAND CENTER, WIS. PASSENGER DEPOT
//  Source: Album sheet 67, drawing B-616, Nov 3 1909.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 64 x 20 ft; baggage 12 ft 6 x 19, smoking 16 x 19, ticket office 11 ft 10 x 9 with bay, women's waiting 16 x 19; hipped shingle roof with flared eaves, diamond-pane upper sash.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 64, 0, 20, 12, 0.75, 3, 4, 0]],
      pavs   = [],
      wins   = [[18.0, 1, 3, 6, 4.2], [26.0, 1, 3, 6, 4.2], [34.0, 1, 3, 6, 4.2], [42.0, 1, 3, 6, 4.2], [50.0, 1, 3, 6, 4.2], [58.0, 1, 3, 6, 4.2], [18.0, 0, 3, 6, 4.2], [26.0, 0, 3, 6, 4.2], [34.0, 0, 3, 6, 4.2], [42.0, 0, 3, 6, 4.2], [50.0, 0, 3, 6, 4.2], [58.0, 0, 3, 6, 4.2]],
      doors  = [[6, 1, 5, 8, 1], [24, 1, 3.5, 7.5, 0], [48, 1, 3.5, 7.5, 0]],
      bays   = [[38, 1, 10, 2.5]],
      chims  = [[30, 10, 24]],
      plat   = [-5, 74, 12, 0.8]);
