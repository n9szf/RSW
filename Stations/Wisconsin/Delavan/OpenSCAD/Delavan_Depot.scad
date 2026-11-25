// =====================================================================
//  MILWAUKEE ROAD - DELAVAN, WIS. PASSENGER DEPOT
//  Source: Album sheet 76, drawing B-950, Oct 10 1911.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 136 ft: baggage 24 x 25, 24 ft open pavilion, depot 88 x 25 (men's waiting 24 ft 6 x 25, ticket office 16 ft 6 x 13 ft 11, general waiting 34 ft 7 x 25); asbestos shingle roof, lap siding, centre gable over the office.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[48, 88, 0, 25, 12, 0.55, 1, 3, 0], [0, 24, 0, 25, 12, 0.55, 1, 3, 0], [83, 18, 0, 25, 13, 0.7, 2, 3, 0]],
      pavs   = [[24, 24, 0, 25, 12, 0.55, 1, 3, 2, 2]],
      wins   = [[54.0, 1, 3, 6, 4.2], [62.0, 1, 3, 6, 4.2], [70.0, 1, 3, 6, 4.2], [78.0, 1, 3, 6, 4.2], [106.0, 1, 3, 6, 4.2], [114.0, 1, 3, 6, 4.2], [122.0, 1, 3, 6, 4.2], [130.0, 1, 3, 6, 4.2], [54.2, 0, 3, 6, 4.2], [62.6, 0, 3, 6, 4.2], [71.0, 0, 3, 6, 4.2], [79.4, 0, 3, 6, 4.2], [87.8, 0, 3, 6, 4.2], [96.2, 0, 3, 6, 4.2], [104.6, 0, 3, 6, 4.2], [113.0, 0, 3, 6, 4.2], [121.4, 0, 3, 6, 4.2], [129.8, 0, 3, 6, 4.2]],
      doors  = [[12, 1, 5, 8, 1, 1], [79, 1, 3.5, 7.5, 0], [106, 1, 3.5, 7.5, 0]],
      bays   = [[92, 1, 16, 3]],
      chims  = [[70, 12.5, 25]],
      plat   = [-5, 146, 12, 0.8]);
