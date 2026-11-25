// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 90 FT DEPOT, FARMINGTON (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 13. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 90 ft (the sheet says 24 x 90): waiting room 14, office 14 with bay, waiting room 14, baggage room 12, freight room 35; flared hipped shingle roof with cresting, lap siding over drop siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 90, 0, 24, 11, 0.7, 3, 4, 0]],
      pavs   = [],
      wins   = [[4.75, 1, 3, 6, 4.2], [10.25, 1, 3, 6, 4.2], [33.0, 1, 3, 6, 4.2], [39.0, 1, 3, 6, 4.2], [12, 2, 3, 6, 3.2]],
      doors  = [[16, 1, 3, 7.5, 0], [34, 1, 3, 7.5, 0], [50, 1, 6, 8, 2], [72, 1, 6, 8, 2]],
      bays   = [[21, 1, 9, 2.5]],
      chims  = [[18, 12, 22.4], [42, 12, 22.4]],
      plat   = [-6, 102, 12, 0.6]);
