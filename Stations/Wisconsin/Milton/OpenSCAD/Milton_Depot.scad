// =====================================================================
//  MILWAUKEE ROAD - MILTON, WIS. PASSENGER STATION
//  Source: Album sheet 99, built 1914.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 101 ft 6 in: freight and baggage 49 ft 6 x 18 (tar and gravel roof), station 52 x 28 (shingle gable roof); waiting 24 x 25, ticket office 14 x 14, smoking 12 ft 6 x 25 ft 6; brick; pavilion at the waiting-room end.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[49.5, 52, 0, 28, 11, 0.6, 1, 3, 2], [0, 49.5, 5, 18, 11, 0, 4, 3, 2]],
      pavs   = [[101.5, 16, 0, 28, 10, 0.1, 4, 2, 2, 2]],
      wins   = [[56.7, 1, 3, 6, 4.2], [66.1, 1, 3, 6, 4.2], [75.5, 1, 3, 6, 4.2], [84.9, 1, 3, 6, 4.2], [94.3, 1, 3, 6, 4.2], [56.7, 0, 3, 6, 4.2], [66.1, 0, 3, 6, 4.2], [75.5, 0, 3, 6, 4.2], [84.9, 0, 3, 6, 4.2], [94.3, 0, 3, 6, 4.2], [10.33, 1, 3, 6, 4.2, 1], [25.0, 1, 3, 6, 4.2, 1], [39.67, 1, 3, 6, 4.2, 1]],
      doors  = [[60, 1, 3.5, 7.5, 0], [92, 1, 3.5, 7.5, 0], [25, 1, 5, 8, 1, 1]],
      bays   = [[76, 1, 13, 3]],
      chims  = [[60, 14, 25], [90, 14, 25]],
      plat   = [-5, 125, 12, 0.8]);
