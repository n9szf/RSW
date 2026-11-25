// =====================================================================
//  MILWAUKEE ROAD - STANDARD 18 X 36 FT DEPOT (C.M.&ST.P., JAN 1900)
//  Album of Depot Plans (1919), sheet 03. Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 18 x 36 ft; waiting room 18 ft 8, freight room 15 ft 6, office 10 ft with bay; shingle roof, drop siding; built at Whalan, Twin Brooks, James, Granada, Chandler, Bixby, Utica, St. Olaf, Alpha, Okabena, Vienna, Pratt, Trent, Fostoria, Long Grove, Buena Vista.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 36, 0, 18, 10.5, 0.55, 1, 2.5, 0]],
      pavs   = [],
      wins   = [[6.0, 1, 3, 6, 4.2], [14.0, 1, 3, 6, 4.2], [9, 0, 3, 6, 3.2], [9, 2, 3, 6, 3.2]],
      doors  = [[8, 1, 3, 7.5, 0], [28, 1, 6, 8, 2], [28, 0, 6, 8, 2]],
      bays   = [[14, 1, 8, 2.5]],
      chims  = [[18.5, 9, 18.45]],
      plat   = [-6, 48, 10, 0.6]);
