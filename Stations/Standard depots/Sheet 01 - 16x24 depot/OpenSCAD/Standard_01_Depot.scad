// =====================================================================
//  MILWAUKEE ROAD - STANDARD 16 X 24 FT DEPOT (C.M.&ST.P., NOV 1898)
//  Album of Depot Plans (1919), sheet 01. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 16 x 24 ft; waiting room 11 x 8, office with bay, freight room 11 ft 4 x 16; shingle roof with cresting, drop siding; as built at Medary(ville?) and Riggs; also used at Arbor Vitae, Oconto Jct and Knowlton Wis., Templeton, Marvin, Bell Center and others.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 24, 0, 16, 10.5, 0.55, 1, 2.5, 0]],
      pavs   = [],
      wins   = [[5, 1, 3, 6, 3.2], [5, 0, 3, 6, 3.2], [8, 2, 3, 6, 3.2]],
      doors  = [[17, 1, 5, 8, 2], [10, 1, 3, 7.5, 0]],
      bays   = [[5, 1, 7, 2.5]],
      chims  = [[11.5, 8, 17.9]],
      plat   = [-4, 32, 10, 0.6]);
