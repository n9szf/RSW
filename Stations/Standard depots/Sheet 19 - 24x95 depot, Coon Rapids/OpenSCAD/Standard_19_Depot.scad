// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 95 FT DEPOT, COON RAPIDS (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 19. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 95 ft; two waiting rooms 17, office 11 with bay, baggage room 10, freight room 48 (low and high floors) with a high platform; hipped shingle roof with cresting, lap siding over drop siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 95, 0, 24, 11, 0.55, 0, 3.5, 0]],
      pavs   = [],
      wins   = [[3, 1, 3, 6, 3.2], [12, 1, 3, 6, 3.2], [15, 1, 3, 6, 3.2], [32, 1, 3, 6, 3.2], [39, 1, 3, 6, 3.2]],
      doors  = [[9, 1, 3, 7.5, 0], [35, 1, 3, 7.5, 0], [58, 1, 6, 8, 2], [75, 1, 6, 8, 2]],
      bays   = [[22.5, 1, 9, 2.5]],
      chims  = [[22, 12, 20.6]],
      plat   = [95, 10, 24, 3.5]);
