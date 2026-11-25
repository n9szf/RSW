// =====================================================================
//  MILWAUKEE ROAD - STANDARD 26 X 70 FT PASSENGER AND FREIGHT DEPOT, GUTTENBERG, IOWA (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 10. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 26 x 70 ft; two waiting rooms 17 ft 4, office 11 with bay, freight room 39 ft (low and high floors) with a high platform; hipped shingle roof with cresting, lap siding over drop siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 70, 0, 26, 11, 0.55, 0, 3.5, 0]],
      pavs   = [],
      wins   = [[3, 1, 3, 6, 3.2], [9, 1, 3, 6, 3.2], [13, 1, 3, 6, 3.2], [8, 2, 3, 6, 3.2], [18, 2, 3, 6, 3.2]],
      doors  = [[24, 1, 3, 7.5, 0], [44, 1, 6, 8, 2], [13, 3, 3, 7.5, 0]],
      bays   = [[23, 1, 9, 2.5]],
      chims  = [[8, 13, 21.15]],
      plat   = [70, 12, 26, 3.5]);
