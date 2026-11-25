// =====================================================================
//  MILWAUKEE ROAD - STANDARD 16 X 26 FT DEPOT, EAST MOLINE (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 02. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 16 x 26 ft; waiting room 14, office 11 with bay; shingle roof with cresting, drop siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 26, 0, 16, 10.5, 0.55, 1, 2.5, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [16, 1, 3, 6, 3.2], [19.5, 1, 3, 6, 3.2], [4, 2, 3, 6, 3.2], [12, 3, 3, 6, 3.2]],
      doors  = [[9, 1, 3, 7.5, 0]],
      bays   = [[19, 0, 7, 2.5]],
      chims  = [[14, 8, 17.9]],
      plat   = [-4, 34, 10, 0.6]);
