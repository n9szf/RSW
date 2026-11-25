// =====================================================================
//  MILWAUKEE ROAD - STANDARD 20 X 96 FT DEPOT WITH PAVILIONS, GRAYS LAKE (C.M.&ST.P.)
//  Album of Depot Plans (1919), sheet 12. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 96 ft overall: pavilion 20 ft, depot 40 x 20 (two waiting rooms 13 ft 6, octagonal office bay 11 ft) with a centre gable, pavilion 20 ft, baggage room 16 ft; flared hipped shingle roofs with cresting.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[20, 40, 0, 20, 11, 0.7, 3, 3.5, 0], [34, 12, 0, 20, 11.5, 0.9, 2, 2, 0], [80, 16, 0, 20, 11, 0.7, 3, 3, 0]],
      pavs   = [[0, 20, 0, 20, 11, 0.7, 3, 3.5, 2, 2], [60, 20, 0, 20, 11, 0.7, 3, 3.5, 2, 2]],
      wins   = [[24, 1, 3, 6, 3.2], [29, 1, 3, 6, 3.2], [51, 1, 3, 6, 3.2], [56, 1, 3, 6, 3.2], [10, 2, 3, 6, 3.2], [10, 3, 3, 6, 3.2]],
      doors  = [[33, 1, 3, 7.5, 0], [47, 1, 3, 7.5, 0], [88, 1, 5, 8, 1, 2]],
      bays   = [[40, 1, 11, 3]],
      chims  = [[30, 10, 21.0]],
      plat   = [-5, 106, 12, 0.6]);
