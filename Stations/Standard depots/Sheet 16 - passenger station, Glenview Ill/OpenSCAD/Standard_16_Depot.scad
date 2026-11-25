// =====================================================================
//  MILWAUKEE ROAD - PASSENGER STATION, GLENVIEW, ILL. (C.M.&ST.P. ENGINEERING DEPT., C.1912)
//  Album of Depot Plans (1919), sheet 16. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 66 x 20 ft; smoking room 15 ft 8 x 18 ft 4, ticket office with bay, general waiting room 25 x 18 ft 4; shingle gable roof with centre dormer, lap siding, three chimneys.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 66, 0, 20, 11, 0.6, 1, 2.5, 0], [26, 14, 0, 20, 12.5, 0.9, 2, 2, 0]],
      pavs   = [],
      wins   = [[5.33, 1, 3, 6, 4.2], [12.0, 1, 3, 6, 4.2], [18.67, 1, 3, 6, 4.2], [47.33, 1, 3, 6, 4.2], [54.0, 1, 3, 6, 4.2], [60.67, 1, 3, 6, 4.2], [5.88, 0, 3, 6, 4.2], [13.62, 0, 3, 6, 4.2], [21.38, 0, 3, 6, 4.2], [29.12, 0, 3, 6, 4.2], [36.88, 0, 3, 6, 4.2], [44.62, 0, 3, 6, 4.2], [52.38, 0, 3, 6, 4.2], [60.12, 0, 3, 6, 4.2]],
      doors  = [[24, 1, 3, 7.5, 0], [42, 1, 3, 7.5, 0]],
      bays   = [[33, 1, 12, 3]],
      chims  = [[12, 10, 21.8], [33, 10, 21.8], [54, 10, 21.8]],
      plat   = [-6, 78, 12, 0.6]);
