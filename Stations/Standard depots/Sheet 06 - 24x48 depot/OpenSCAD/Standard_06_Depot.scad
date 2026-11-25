// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 48 FT DEPOT (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 06. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 48 ft; waiting room 18 ft 6, office 14 with bay, freight room 28; shingle roof with cresting, drop siding; built at Grafton, Stiles, Walford and Nekoosa.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 48, 0, 24, 11, 0.55, 1, 2.5, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [15, 1, 3, 6, 3.2], [18, 1, 3, 6, 3.2], [12, 2, 3, 6, 3.2]],
      doors  = [[8, 1, 3, 7.5, 0], [30, 1, 6, 8, 2]],
      bays   = [[17, 0, 9, 2.5]],
      chims  = [[19, 12, 20.6]],
      plat   = [-6, 60, 12, 0.6]);
