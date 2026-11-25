// =====================================================================
//  MILWAUKEE ROAD - COLUMBUS, WIS. PASSENGER DEPOT
//  Source: Album sheet 56, drawing A-7931, Aug 31 1906 (J. A. Lindstrand).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 96 x 23 ft; wings 25 ft 6 in, centre 45 ft; general waiting 26x40, smoking 20x22, office 13x16 ft 8, baggage 17 ft 8 x 20; quarter-pitch TILE roof; concrete (rusticated) walls; 2 porches.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 96, 0, 23, 13.5, 0.5, 0, 4, 1], [25.5, 45, -2, 27, 14.5, 0.5, 2, 3, 1]],
      pavs   = [],
      wins   = [[5.67, 0, 3, 6, 4.2], [13.0, 0, 3, 6, 4.2], [20.33, 0, 3, 6, 4.2], [75.67, 0, 3, 6, 4.2], [83.0, 0, 3, 6, 4.2], [90.33, 0, 3, 6, 4.2], [5.67, 1, 3, 6, 4.2], [13.0, 1, 3, 6, 4.2], [20.33, 1, 3, 6, 4.2], [75.67, 1, 3, 6, 4.2], [83.0, 1, 3, 6, 4.2], [90.33, 1, 3, 6, 4.2], [8, 2, 3, 6, 4.2], [15, 2, 3, 6, 4.2], [11.5, 3, 3, 6, 4.2]],
      doors  = [[35, 1, 4, 8, 0, 1], [61, 1, 4, 8, 0, 1], [85, 1, 5, 8, 1]],
      bays   = [[48, 1, 12, 3, 1]],
      chims  = [[48, 11.5, 26]],
      plat   = [-15, 126, 16, 1]);
