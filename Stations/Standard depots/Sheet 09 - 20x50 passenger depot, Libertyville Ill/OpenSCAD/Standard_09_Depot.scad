// =====================================================================
//  MILWAUKEE ROAD - STANDARD 20 X 50 FT PASSENGER DEPOT, LIBERTYVILLE, ILL. (C.M.&ST.P., JAN 15 1900)
//  Album of Depot Plans (1919), sheet 09. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 20 x 50 ft; two waiting rooms 12 ft 6, octagonal office bay 11 ft, baggage room 11 ft 6; steep flared hipped roof with cresting, lap siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 50, 0, 20, 11, 0.9, 3, 4, 0]],
      pavs   = [],
      wins   = [[3, 1, 3, 6, 3.2], [9, 1, 3, 6, 3.2], [27, 1, 3, 6, 3.2], [33, 1, 3, 6, 3.2], [10, 2, 3, 6, 3.2], [10, 3, 3, 6, 3.2]],
      doors  = [[6, 1, 3, 7.5, 0], [30, 1, 3, 7.5, 0], [44, 1, 5, 8, 1]],
      bays   = [[18, 1, 11, 3]],
      chims  = [[18, 10, 23.0]],
      plat   = [-6, 62, 12, 0.6]);
