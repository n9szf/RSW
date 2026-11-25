// =====================================================================
//  MILWAUKEE ROAD - NASHOTAH, WIS. PASSENGER STATION
//  Source: Album sheet 94, built 1915.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 50 x 24 ft, waiting room 22 ft 6 x 40, ticket office 9 x 16 ft 6; stucco, asbestos shingles; built on a slope with a lower storey and grand stair on the track side (lower storey NOT modelled yet).
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 50, 0, 24, 11, 0.6, 1, 3, 1]],
      pavs   = [[50, 24, 0, 24, 10, 0.1, 4, 2, 2, 2]],
      wins   = [[7.75, 1, 3, 6, 4.2], [19.25, 1, 3, 6, 4.2], [30.75, 1, 3, 6, 4.2], [42.25, 1, 3, 6, 4.2], [7.75, 0, 3, 6, 4.2], [19.25, 0, 3, 6, 4.2], [30.75, 0, 3, 6, 4.2], [42.25, 0, 3, 6, 4.2]],
      doors  = [[25, 0, 5, 8, 1], [25, 1, 4, 8, 0]],
      bays   = [[44, 1, 9, 2.5]],
      chims  = [[5, 12, 24]],
      plat   = 0);
