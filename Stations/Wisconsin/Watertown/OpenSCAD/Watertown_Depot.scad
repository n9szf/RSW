// =====================================================================
//  MILWAUKEE ROAD - WATERTOWN, WIS. PASSENGER DEPOT (FROST & GRANGER)
//  Source: Album sheet 48, drawing 6945, Sept 1896 (Frost & Granger).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 168 ft overall: depot 88 x 30 ft (women's and men's waiting rooms 36 ft 6, office with bay), 40 ft pavilion, 40 x 30 baggage room; stone base, brick walls, hip roofs, centre gable dormer with lantern.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 88, 0, 30, 13, 0.75, 0, 5, 2], [30.5, 27, -3, 33, 14, 0.9, 1, 3, 2], [128, 40, 0, 30, 13, 0.75, 0, 5, 2]],
      pavs   = [[88, 40, 0, 30, 13, 0.75, 0, 5, 2, 2]],
      wins   = [[6.5, 1, 3, 6, 4.2], [15.5, 1, 3, 6, 4.2], [24.5, 1, 3, 6, 4.2], [63.5, 1, 3, 6, 4.2], [72.5, 1, 3, 6, 4.2], [81.5, 1, 3, 6, 4.2], [6.5, 0, 3, 6, 4.2], [15.5, 0, 3, 6, 4.2], [24.5, 0, 3, 6, 4.2], [63.5, 0, 3, 6, 4.2], [72.5, 0, 3, 6, 4.2], [81.5, 0, 3, 6, 4.2], [136.0, 1, 3, 6, 4.2, 2], [148.0, 1, 3, 6, 4.2, 2], [160.0, 1, 3, 6, 4.2, 2]],
      doors  = [[22, 1, 4, 8, 0], [66, 1, 4, 8, 0], [148, 1, 5, 8, 1, 2]],
      bays   = [[44, 1, 14, 3.5]],
      chims  = [[20, 15, 29.15], [68, 15, 29.15], [160, 15, 29.15]],
      plat   = [-8, 184, 14, 0.8]);
