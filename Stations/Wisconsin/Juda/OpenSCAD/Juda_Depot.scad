// =====================================================================
//  MILWAUKEE ROAD - JUDA, WIS. PASSENGER STATION
//  Source: Album sheet 124, drawing B-?, June 1 1928.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 44 x 24 ft depot + 24 ft exterior high platform; baggage and freight room, waiting room, ticket office with bay; drop siding, gable roof.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[24, 44, 0, 24, 11, 0.55, 1, 2, 0]],
      pavs   = [],
      wins   = [[49.67, 1, 3, 6, 4.2], [57.0, 1, 3, 6, 4.2], [64.33, 1, 3, 6, 4.2], [51.5, 0, 3, 6, 4.2], [62.5, 0, 3, 6, 4.2]],
      doors  = [[36, 1, 5, 8, 1], [64, 1, 3.5, 7.5, 0]],
      bays   = [[55, 1, 9, 2.5]],
      chims  = [[50, 12, 23]],
      plat   = [0, 24, 24, 3.5]);
