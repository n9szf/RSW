// =====================================================================
//  MILWAUKEE ROAD - STANDARD 24 X 60 FT DEPOT WITH LIVING ROOMS (C.M.&ST.P., JAN 16 1900) - SHEETS 14 AND 15
//  Album of Depot Plans (1919), sheet 14 (and sheet 15, the plans). Private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 60 ft overall: two-storey part 28 ft 6 x 24 (waiting room and office with bay below; kitchen, sitting room and two bedrooms above) and a one-storey freight room 30 x 24; hipped roofs with cresting, cross gable over the bay, lap siding below, drop siding above; built at Rockland Mich., Lavinia, Lytton, Varina, Webb, Gillet Grove, Nemaha and Northam, Iowa.
//  ESTIMATE: wall and ridge heights (sheets are small copies), window spacing, colours.
//  Shared depot builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 28.5, 0, 24, 20, 0.7, 0, 2, 0], [13, 12, 0, 24, 21, 0.9, 2, 2, 0], [28.5, 31.5, 0, 24, 11, 0.55, 0, 3, 0]],
      pavs   = [],
      wins   = [[4, 1, 3, 6, 3.2], [21, 1, 3, 6, 3.2], [4, 1, 3, 5, 12.5], [9, 1, 3, 5, 12.5], [23, 1, 3, 5, 12.5], [12, 2, 3, 6, 3.2], [12, 2, 3, 5, 12.5]],
      doors  = [[9, 1, 3, 7.5, 0], [44, 1, 6, 8, 2, 2]],
      bays   = [[19, 1, 9, 2.5]],
      chims  = [[14, 12, 31.4]],
      plat   = [-6, 72, 12, 0.6]);
