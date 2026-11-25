// =====================================================================
//  MILWAUKEE ROAD - ELKHORN, WIS. PASSENGER STATION
//  Source: Album sheet 96, built 1914 (drawn Mar 11 1916); unbuilt 1913 design on sheet 127.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 110 x 20 ft + 30 ft pavilion (tar and gravel roof); baggage 21 x 24 ft 6, smoking 22 ft 6 x 24 ft 4, ticket office 15 ft 5 x 17 ft 2, general waiting 26 ft 4 x 36 ft 8; stucco, slate roof, centre gable.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 110, 0, 20, 12, 0.6, 1, 2.5, 1], [53, 19, 0, 22, 13, 0.6, 2, 2.5, 1]],
      pavs   = [[110, 30, 0, 20, 10, 0.1, 4, 2, 2, 2]],
      wins   = [[24.0, 1, 3, 6, 4.2], [32.0, 1, 3, 6, 4.2], [40.0, 1, 3, 6, 4.2], [48.0, 1, 3, 6, 4.2], [77.38, 1, 3, 6, 4.2], [86.12, 1, 3, 6, 4.2], [94.88, 1, 3, 6, 4.2], [103.62, 1, 3, 6, 4.2], [18.75, 0, 3, 6, 4.2], [26.25, 0, 3, 6, 4.2], [33.75, 0, 3, 6, 4.2], [41.25, 0, 3, 6, 4.2], [48.75, 0, 3, 6, 4.2], [56.25, 0, 3, 6, 4.2], [63.75, 0, 3, 6, 4.2], [71.25, 0, 3, 6, 4.2], [78.75, 0, 3, 6, 4.2], [86.25, 0, 3, 6, 4.2], [93.75, 0, 3, 6, 4.2], [101.25, 0, 3, 6, 4.2]],
      doors  = [[8, 1, 5, 8, 1], [48, 1, 4, 8, 0], [78, 1, 4, 8, 0]],
      bays   = [[62.5, 1, 14, 3, 1]],
      chims  = [[40, 10, 24], [85, 10, 24]],
      plat   = [-5, 150, 12, 0.8]);
