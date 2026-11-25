// =====================================================================
//  MILWAUKEE ROAD - MAYVILLE, WIS. PASSENGER AND FREIGHT DEPOT
//  Source: Album sheet 140, drawing 7418, July 25 1897 (J. U. Nettenstrom).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 100 ft passenger and freight depot; freight room, smoking 9 x 20, office 14 x 20 with bay, waiting room 23 x 24; board-and-batten gables, lap siding.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 100, 0, 24, 12, 0.55, 1, 3, 0]],
      pavs   = [],
      wins   = [[51.4, 1, 3, 6, 4.2], [62.2, 1, 3, 6, 4.2], [73.0, 1, 3, 6, 4.2], [83.8, 1, 3, 6, 4.2], [94.6, 1, 3, 6, 4.2], [52.75, 0, 3, 6, 4.2], [66.25, 0, 3, 6, 4.2], [79.75, 0, 3, 6, 4.2], [93.25, 0, 3, 6, 4.2]],
      doors  = [[6, 1, 6, 8, 2], [30, 1, 6, 8, 2], [80, 1, 3.5, 7.5, 0]],
      bays   = [[60, 1, 11, 2.5]],
      chims  = [[62, 12, 24]],
      plat   = [-5, 110, 12, 0.8]);
