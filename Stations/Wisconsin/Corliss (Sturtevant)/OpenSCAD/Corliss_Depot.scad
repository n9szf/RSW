// =====================================================================
//  MILWAUKEE ROAD - CORLISS (STURTEVANT), WIS. JUNCTION DEPOT
//  Source: Album sheet 39, drawing A-725, May 16 1901 (J. U. Nettenstrom).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 68 x 68 ft L at the junction of two lines: smoking 15 x 19, general waiting 27 x 27 with octagonal office bay 15 x 15, two 24 and 20 ft pavilions, baggage 15 x 19; tall conical turret over the office, cresting.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 40, 0, 20, 13, 0.6, 0, 4, 0], [0, 20, 20, 48, 13, 0.6, 0, 4, 0], [64, 16, 0, 20, 13, 0.6, 0, 4, 0]],
      pavs   = [[40, 24, 0, 20, 13, 0.6, 0, 4, 2, 2]],
      wins   = [[6.5, 1, 3, 6, 4.2], [15.5, 1, 3, 6, 4.2], [24.5, 1, 3, 6, 4.2], [33.5, 1, 3, 6, 4.2], [6.5, 0, 3, 6, 4.2], [15.5, 0, 3, 6, 4.2], [24.5, 0, 3, 6, 4.2], [33.5, 0, 3, 6, 4.2]],
      doors  = [[30, 1, 3.5, 8, 0], [72, 1, 5, 8, 1, 2]],
      bays   = [],
      chims  = [[30, 10, 26]],
      plat   = [-5, 90, 10, 0.8]);
