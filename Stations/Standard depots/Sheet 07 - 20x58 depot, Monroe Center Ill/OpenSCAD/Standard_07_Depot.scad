// =====================================================================
//  MILWAUKEE ROAD - STANDARD 20 X 58 FT DEPOT, MONROE CENTER, ILL. (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 07. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 20 x 58 ft; waiting room 17 x 19, office 10 x 19 with bay, freight room 29 x 19; shingle roof, board-and-batten gables, drop siding below.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 58, 0, 20, 11, 0.55, 1, 3, 0]],
      pavs   = [],
      wins   = [[8, 1, 3, 6, 3.2], [12, 1, 3, 6, 3.2], [20, 1, 3, 6, 3.2], [24, 1, 3, 6, 3.2], [10, 2, 3, 6, 3.2]],
      doors  = [[4, 1, 3, 7.5, 0], [42, 1, 6, 8, 2]],
      bays   = [[22, 0, 8, 2.5]],
      chims  = [[27, 10, 19.5]],
      plat   = [-6, 70, 12, 0.6]);
