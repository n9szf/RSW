// =====================================================================
//  MILWAUKEE ROAD - STOUGHTON, WIS. PASSENGER STATION
//  Source: Album sheet 106, built 1913 (drawn Apr 11 1919).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 129 ft 5 in incl. 27 ft 5 in pavilion; 27 ft 6 in wide; general waiting 26 x 36 ft 6, ticket office 18 ft 6 x 17, smoking 20 x 26, baggage 23 ft 6 x 26; cement plaster, brick base, shingle-tile roof, composition-roof pavilion.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[27.4, 102, 0, 27.5, 12, 0.55, 1, 3, 1], [64.4, 19, 0, 27.5, 13, 0.6, 2, 3, 1]],
      pavs   = [[0, 27.4, 0, 27.5, 10, 0.15, 4, 2, 2, 2]],
      wins   = [[34.0, 1, 3, 6, 4.2], [42.0, 1, 3, 6, 4.2], [50.0, 1, 3, 6, 4.2], [58.0, 1, 3, 6, 4.2], [87.33, 1, 3, 6, 4.2], [94.0, 1, 3, 6, 4.2], [100.67, 1, 3, 6, 4.2], [34.8, 0, 3, 6, 4.2], [44.4, 0, 3, 6, 4.2], [54.0, 0, 3, 6, 4.2], [63.6, 0, 3, 6, 4.2], [73.2, 0, 3, 6, 4.2], [82.8, 0, 3, 6, 4.2], [92.4, 0, 3, 6, 4.2], [102.0, 0, 3, 6, 4.2], [111.6, 0, 3, 6, 4.2], [121.2, 0, 3, 6, 4.2]],
      doors  = [[60, 1, 4, 8, 0], [86, 1, 4, 8, 0], [112, 1, 5, 8, 1]],
      bays   = [[73.8, 1, 14, 3]],
      chims  = [[45, 14, 26], [100, 14, 26]],
      plat   = [-5, 140, 14, 0.8]);
