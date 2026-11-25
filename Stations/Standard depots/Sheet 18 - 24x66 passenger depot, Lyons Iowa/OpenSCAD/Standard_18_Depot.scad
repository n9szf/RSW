// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 66 FT PASSENGER DEPOT, LYONS, IOWA (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 18. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 66 ft; men's waiting room 20, office 12 with bay, women's waiting room 19, baggage room 12 ft 6; steep flared hipped shingle roof with iron cresting, lap siding with vertical boards below.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 66, 0, 24, 11, 1.0, 3, 4.5, 0]],
      pavs   = [],
      wins   = [[4.0, 1, 3, 6, 4.2], [10.0, 1, 3, 6, 4.2], [16.0, 1, 3, 6, 4.2], [36.17, 1, 3, 6, 4.2], [42.5, 1, 3, 6, 4.2], [48.83, 1, 3, 6, 4.2], [12, 2, 3, 6, 3.2], [12, 3, 3, 6, 3.2]],
      doors  = [[6, 1, 3, 7.5, 0], [36, 1, 3, 7.5, 0], [60, 1, 5, 8, 1]],
      bays   = [[26, 1, 10, 3]],
      chims  = [[30, 12, 26.0]],
      plat   = [-6, 78, 12, 0.6]);
