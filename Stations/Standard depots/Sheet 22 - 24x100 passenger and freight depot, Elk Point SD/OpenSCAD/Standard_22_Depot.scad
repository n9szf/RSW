// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 100 FT PASSENGER AND FREIGHT DEPOT, ELK POINT, S.D. (C.M.&ST.P., NOV 17 1899)
//  Album of Depot Plans (1919), sheet 22. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 100 ft: freight room 45 ft 6 with a high platform, waiting room 18 ft 6, office 15 with bay, waiting room 18 ft 6; flared hipped roofs, the passenger end higher, cresting, lap siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[45.5, 54.5, 0, 24, 11, 0.8, 3, 3.5, 0], [0, 45.5, 0, 24, 10, 0.55, 0, 3, 0]],
      pavs   = [],
      wins   = [[53.5, 1, 3, 6, 4.2], [60.5, 1, 3, 6, 4.2], [87.5, 1, 3, 6, 4.2], [94.5, 1, 3, 6, 4.2], [12, 3, 3, 6, 3.2]],
      doors  = [[66, 1, 3, 7.5, 0], [82, 1, 3, 7.5, 0], [14, 1, 6, 8, 2, 1], [32, 1, 6, 8, 2, 1]],
      bays   = [[73.5, 1, 10, 3]],
      chims  = [[60, 12, 23.6], [86, 12, 23.6]],
      plat   = [-6, 6, 24, 3.5]);
