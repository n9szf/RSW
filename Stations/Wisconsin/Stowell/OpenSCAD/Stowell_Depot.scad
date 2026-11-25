// =====================================================================
//  MILWAUKEE ROAD - STOWELL, WIS. PASSENGER DEPOT
//  Source: Album sheet 69, drawing B-586, Sept 14 1909.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 56 x 20 ft; general waiting 16 x 19, office 11 ft 6 x 9 with bay, smoking 10 x 19, baggage and express 16 x 19; flared hipped shingle roof, diamond-pane upper sash, lap siding.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 56, 0, 20, 12, 0.8, 3, 4, 0]],
      pavs   = [],
      wins   = [[6.33, 1, 3, 6, 4.2], [15.0, 1, 3, 6, 4.2], [23.67, 1, 3, 6, 4.2], [32.33, 1, 3, 6, 4.2], [41.0, 1, 3, 6, 4.2], [49.67, 1, 3, 6, 4.2], [6.33, 0, 3, 6, 4.2], [15.0, 0, 3, 6, 4.2], [23.67, 0, 3, 6, 4.2], [32.33, 0, 3, 6, 4.2], [41.0, 0, 3, 6, 4.2], [49.67, 0, 3, 6, 4.2]],
      doors  = [[11, 1, 3.5, 7.5, 0], [34, 1, 3.5, 7.5, 0], [48, 1, 5, 8, 1]],
      bays   = [[22.75, 1, 12, 3]],
      chims  = [[22, 10, 25]],
      plat   = [-5, 66, 12, 0.8]);
