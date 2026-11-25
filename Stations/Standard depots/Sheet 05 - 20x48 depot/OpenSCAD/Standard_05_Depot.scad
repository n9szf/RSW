// =====================================================================
//  MILWAUKEE ROAD - STANDARD 20 X 48 FT DEPOT (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 05. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 20 x 48 ft; waiting room 19 ft 8, office 10 with bay, freight room 27 ft 6; shingle roof, drop siding; built at Summit, Morrisonville, Pierpont.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 48, 0, 20, 11, 0.55, 1, 2.5, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [14, 1, 3, 6, 3.2], [17, 1, 3, 6, 3.2], [10, 2, 3, 6, 3.2]],
      doors  = [[8, 1, 3, 7.5, 0], [34, 1, 6, 8, 2], [34, 0, 6, 8, 2]],
      bays   = [[15, 0, 8, 2.5]],
      chims  = [[19.5, 10, 19.5]],
      plat   = [-6, 60, 10, 0.6]);
