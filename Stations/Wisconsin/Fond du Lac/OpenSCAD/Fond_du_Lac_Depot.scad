// =====================================================================
//  MILWAUKEE ROAD - FOND DU LAC, WIS. PASSENGER DEPOT (1898)
//  Source: Album sheet 132, Nov 1898 (J. U. Nettenstrom).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 60 ft; women's waiting 16 ft 6 x 22, office 12 x 15 with bay, men's waiting 17 x 22, baggage 11 x 22; brick veneer, stone trim, flared hip roof with hipped dormer, cresting.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 60, 0, 24, 12, 0.9, 3, 4.5, 2]],
      pavs   = [],
      wins   = [[7.6, 1, 3, 6, 4.2], [18.8, 1, 3, 6, 4.2], [30.0, 1, 3, 6, 4.2], [41.2, 1, 3, 6, 4.2], [52.4, 1, 3, 6, 4.2], [7.6, 0, 3, 6, 4.2], [18.8, 0, 3, 6, 4.2], [30.0, 0, 3, 6, 4.2], [41.2, 0, 3, 6, 4.2], [52.4, 0, 3, 6, 4.2]],
      doors  = [[16, 1, 3.5, 8, 0], [36, 1, 3.5, 8, 0], [54, 1, 5, 8, 1]],
      bays   = [[25, 1, 11, 3]],
      chims  = [[30, 12, 28]],
      plat   = [-5, 70, 12, 0.8]);
