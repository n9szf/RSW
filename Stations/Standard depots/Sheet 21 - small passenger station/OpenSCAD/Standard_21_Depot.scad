// =====================================================================
//  MILWAUKEE ROAD - SMALL PASSENGER STATION, WEBSTER, MINN. (C.M.&ST.P. ENGINEERING DEPT., BUILT 1916)
//  Album of Depot Plans (1919), sheet 21. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 26 x 18 ft; office 11 ft 6 with bay, waiting room, freight room 11 ft 6; gable roof (asbestos shingle) with lean-to over the freight end, 6 in drop siding.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 14.5, 0, 18, 10, 0.6, 1, 1.5, 0], [14.5, 11.5, 1, 16, 9, 0.25, 1, 1, 0]],
      pavs   = [],
      wins   = [[10, 1, 3, 6, 3.2], [6, 2, 2, 5, 3.5], [22, 1, 3, 6, 3.2, 1]],
      doors  = [[5, 1, 3, 7.5, 0]],
      bays   = [[7, 0, 6, 2]],
      chims  = [[7, 9, 17.35]],
      plat   = [-4, 34, 10, 0.6]);
