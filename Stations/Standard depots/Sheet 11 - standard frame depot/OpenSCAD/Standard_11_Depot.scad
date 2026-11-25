// =====================================================================
//  MILWAUKEE ROAD - STANDARD FRAME PASSENGER STATION 17 X 33 FT 4 IN (C.M.&ST.P. ENGINEERING DEPT., C.1916)
//  Album of Depot Plans (1919), sheet 11. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 17 x 33 ft 4 in; waiting room 10, office 9 with bay, baggage and freight room 14 ft 4; asbestos roofing, lap siding; used at Knoke, Iowa (1925), Bethesda, Wis., Dover, S.D..
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 33.3, 0, 17, 10, 0.5, 1, 1.5, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [14, 1, 3, 6, 3.2], [17, 1, 3, 6, 3.2], [8, 2, 3, 6, 3.2], [10, 3, 3, 6, 3.2]],
      doors  = [[8, 1, 3, 7.5, 0], [26, 1, 6, 8, 2]],
      bays   = [[14.5, 1, 9, 2.5]],
      chims  = [[15, 8.5, 17.25]],
      plat   = [-5, 44, 10, 0.6]);
