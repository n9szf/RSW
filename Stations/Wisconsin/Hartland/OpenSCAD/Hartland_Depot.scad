// =====================================================================
//  MILWAUKEE ROAD - HARTLAND, WIS. PASSENGER STATION
//  Source: Album sheet 111, built 1917 (drawn Aug 26 1919).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 63 ft 4 in station + pavilions (15 ft 4 in and 60 ft, tar and gravel roofs); baggage 19 x 27, smoking 16 ft 6 x 27, ticket office 15 ft 8 x 17 ft 10, general waiting 24 ft 10 x 37 ft 4; stucco, red asphalt shingles, half-timbered gable.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[15.4, 63.3, 0, 33.5, 11, 0.55, 0, 3, 1]],
      pavs   = [[0, 15.4, 4, 25, 9.5, 0.1, 4, 1.5, 2, 2], [78.7, 60, 4, 25, 9.5, 0.1, 4, 1.5, 4, 2]],
      wins   = [[23.8, 1, 3, 6, 4.2], [35.4, 1, 3, 6, 4.2], [47.0, 1, 3, 6, 4.2], [58.6, 1, 3, 6, 4.2], [70.2, 1, 3, 6, 4.2], [23.8, 0, 3, 6, 4.2], [35.4, 0, 3, 6, 4.2], [47.0, 0, 3, 6, 4.2], [58.6, 0, 3, 6, 4.2], [70.2, 0, 3, 6, 4.2]],
      doors  = [[20, 1, 5, 8, 1], [52, 1, 3.5, 7.5, 0]],
      bays   = [[44, 1, 12, 3]],
      chims  = [[40, 17, 24]],
      plat   = [-5, 150, 10, 0.8]);
