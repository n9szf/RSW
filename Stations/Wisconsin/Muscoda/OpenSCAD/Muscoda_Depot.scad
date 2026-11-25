// =====================================================================
//  MILWAUKEE ROAD - MUSCODA, WIS. PASSENGER STATION
//  Source: Album sheet 118, drawing B-3261, July 26 1927.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 78 ft 6 in x about 24 ft; waiting 20 x 23, ticket office 10 x 13 with bay, freight and baggage 32 ft 3 x 39?; high platforms; brick, hipped shingle roof.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 78.5, 0, 24, 12, 0.55, 0, 3, 2]],
      pavs   = [],
      wins   = [[6.25, 1, 3, 6, 4.2], [14.75, 1, 3, 6, 4.2], [23.25, 1, 3, 6, 4.2], [31.75, 1, 3, 6, 4.2], [8.17, 0, 3, 6, 4.2], [20.5, 0, 3, 6, 4.2], [32.83, 0, 3, 6, 4.2], [45.17, 0, 3, 6, 4.2], [57.5, 0, 3, 6, 4.2], [69.83, 0, 3, 6, 4.2]],
      doors  = [[16, 1, 3.5, 7.5, 0], [46, 1, 5, 8, 1], [66, 1, 5, 8, 1]],
      bays   = [[30, 1, 11, 3]],
      chims  = [[30, 12, 24]],
      plat   = [40, 38, 10, 3.5]);
