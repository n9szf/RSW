// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 60 FT DEPOT (C.M.&ST.P., NOV 1899)
//  Album of Depot Plans (1919), sheet 08. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 60 ft; waiting room 17, office 11 with bay, freight room 30; hipped shingle roof with cresting, lap siding over drop siding; built at Elm Springs, Middleton, So. Amana, Dexter and Arlington.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 60, 0, 24, 11, 0.6, 0, 3.5, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [11, 1, 3, 6, 3.2], [14, 1, 3, 6, 3.2], [12, 2, 3, 6, 3.2]],
      doors  = [[8, 1, 3, 7.5, 0], [42, 1, 6, 8, 2]],
      bays   = [[22.5, 1, 9, 2.5]],
      chims  = [[22, 12, 21.2]],
      plat   = [-6, 72, 12, 0.6]);
