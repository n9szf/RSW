// =====================================================================
//  MILWAUKEE ROAD - KIEL, WIS. PASSENGER STATION
//  Source: Album sheet 93, built 1916 (drawn Aug 9 1916).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 113 ft 8 in + 28 ft pavilion; station 53 ft 8 x 26 (general waiting 19 ft 6 x 24 ft 8, ticket office 12 ft 2 x 15 ft 2, smoking 11 ft 6 x 24 ft 8), freight and baggage 62 x 24 (tar and gravel); stucco, asbestos shingles, clerestory dormer.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[28, 53.6, 0, 26, 12, 0.6, 1, 3, 1], [81.6, 62, 1, 24, 11, 0, 4, 2, 1]],
      pavs   = [[0, 28, 0, 26, 10, 0.1, 4, 2, 2, 2]],
      wins   = [[35.0, 1, 3, 6, 4.2], [45.0, 1, 3, 6, 4.2], [55.0, 1, 3, 6, 4.2], [65.0, 1, 3, 6, 4.2], [75.0, 1, 3, 6, 4.2], [35.0, 0, 3, 6, 4.2], [45.0, 0, 3, 6, 4.2], [55.0, 0, 3, 6, 4.2], [65.0, 0, 3, 6, 4.2], [75.0, 0, 3, 6, 4.2], [94.17, 1, 3, 6, 4.2, 1], [112.5, 1, 3, 6, 4.2, 1], [130.83, 1, 3, 6, 4.2, 1]],
      doors  = [[45, 1, 3.5, 7.5, 0], [65, 1, 3.5, 7.5, 0], [112, 1, 6, 8, 2, 1]],
      bays   = [[55, 1, 14, 3]],
      chims  = [[40, 13, 25], [70, 13, 25]],
      plat   = [-5, 155, 12, 0.8]);
