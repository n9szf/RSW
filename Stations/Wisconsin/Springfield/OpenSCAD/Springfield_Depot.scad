// =====================================================================
//  MILWAUKEE ROAD - SPRINGFIELD, WIS. PASSENGER DEPOT
//  Source: Album sheet 82, drawing B-943, May 29 1912.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 80 x 24 ft; waiting 18 ft 3, office 12 ft 6 with bay, smoking 12 ft 6, freight room 36 ft 9; hipped shingle roof, lap siding.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 80, 0, 24, 11.5, 0.5, 0, 3, 0]],
      pavs   = [],
      wins   = [[5.2, 1, 3, 6, 4.2], [13.6, 1, 3, 6, 4.2], [22.0, 1, 3, 6, 4.2], [30.4, 1, 3, 6, 4.2], [38.8, 1, 3, 6, 4.2], [5.2, 0, 3, 6, 4.2], [13.6, 0, 3, 6, 4.2], [22.0, 0, 3, 6, 4.2], [30.4, 0, 3, 6, 4.2], [38.8, 0, 3, 6, 4.2], [53.5, 1, 3, 6, 4.2], [70.5, 1, 3, 6, 4.2]],
      doors  = [[19, 1, 3.5, 7.5, 0], [37, 1, 3.5, 7.5, 0], [62, 1, 6, 8, 2]],
      bays   = [[25, 1, 12, 2.5]],
      chims  = [[18, 12, 23], [38, 12, 23]],
      plat   = [-5, 90, 12, 0.8]);
