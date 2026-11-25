// =====================================================================
//  MILWAUKEE ROAD - EDGERTON, WIS. PASSENGER DEPOT
//  Source: Album sheet 58, drawing A-7532, June 19 1906 (J. A. Lindstrand).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 128 ft overall: building 98 x 24 ft + 30 ft pavilion; baggage 24, smoking 21 ft 10 x 20, office with bay, general waiting 36 ft 4 x 21 ft 10; brick veneer below, stained shingle roof, half pitch.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 98, 0, 24, 12.5, 0.5, 0, 5, 2], [38, 34, 0, 24, 14, 0.55, 0, 4, 2]],
      pavs   = [[98, 30, 0, 24, 12.5, 0.5, 0, 5, 2, 2]],
      wins   = [[29.0, 1, 3, 6, 4.2], [35.0, 1, 3, 6, 4.2], [41.0, 1, 3, 6, 4.2], [65.4, 1, 3, 6, 4.2], [72.2, 1, 3, 6, 4.2], [79.0, 1, 3, 6, 4.2], [85.8, 1, 3, 6, 4.2], [92.6, 1, 3, 6, 4.2], [6.7, 0, 3, 6, 4.2], [16.1, 0, 3, 6, 4.2], [25.5, 0, 3, 6, 4.2], [34.9, 0, 3, 6, 4.2], [44.3, 0, 3, 6, 4.2], [53.7, 0, 3, 6, 4.2], [63.1, 0, 3, 6, 4.2], [72.5, 0, 3, 6, 4.2], [81.9, 0, 3, 6, 4.2], [91.3, 0, 3, 6, 4.2]],
      doors  = [[10, 1, 5, 8, 1], [38, 1, 3.5, 7.5, 0], [64, 1, 3.5, 7.5, 0]],
      bays   = [[51, 1, 14, 3]],
      chims  = [[12, 12, 25], [60, 12, 27]],
      plat   = [-6, 140, 12, 0.8]);
