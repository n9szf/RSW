// =====================================================================
//  MILWAUKEE ROAD - PASSENGER STATION, WESTBY, WIS. (C.M.&ST.P. ENGINEERING DEPT., BUILT 1913)
//  Album of Depot Plans (1919), sheet 20. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): about 76 x 24 ft: general waiting room 21 ft 6 x 20 ft 4, ticket office with bay, smoking room, freight room 40 x 22; gable roof, lap siding, two chimneys.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 76.2, 0, 24, 11, 0.55, 1, 2, 0]],
      pavs   = [],
      wins   = [[5.25, 1, 3, 6, 4.2], [11.75, 1, 3, 6, 4.2], [28.0, 1, 3, 6, 4.2], [32.0, 1, 3, 6, 4.2], [6.0, 0, 3, 6, 4.2], [14.0, 0, 3, 6, 4.2], [22.0, 0, 3, 6, 4.2], [30.0, 0, 3, 6, 4.2]],
      doors  = [[16, 1, 3, 7.5, 0], [34.5, 1, 3, 7.5, 0], [56, 1, 6, 8, 2], [46, 0, 6, 8, 2]],
      bays   = [[25, 1, 11, 2.5]],
      chims  = [[20, 12, 20.6], [28, 12, 20.6]],
      plat   = [-6, 88, 12, 0.6]);
