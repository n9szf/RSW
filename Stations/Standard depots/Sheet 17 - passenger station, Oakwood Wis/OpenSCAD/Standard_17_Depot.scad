// =====================================================================
//  MILWAUKEE ROAD - PASSENGER STATION, OAKWOOD, WIS. (C.M.&ST.P. ENGINEERING DEPT., BUILT 1913)
//  Album of Depot Plans (1919), sheet 17. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 38 x 24 ft (38 ft 1 in); waiting room, office 9 ft 6 x 15 with bay, baggage and freight room 15 ft x 14 ft 8; hipped asphalt-shingle roof, drop siding with vertical boards below.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 38.1, 0, 24, 10.5, 0.5, 0, 3, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [12, 1, 3, 6, 3.2], [15, 1, 3, 6, 3.2], [12, 2, 2, 5, 5]],
      doors  = [[8, 1, 3, 7.5, 0], [28, 1, 6, 8, 2]],
      bays   = [[17, 1, 7, 2]],
      chims  = [[17, 12, 19.5]],
      plat   = [-5, 48, 12, 0.6]);
