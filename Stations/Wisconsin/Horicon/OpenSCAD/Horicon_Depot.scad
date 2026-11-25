// =====================================================================
//  MILWAUKEE ROAD - HORICON, WIS. PASSENGER STATION
//  Source: Album sheet 86, built 1914 (drawn Apr 10 1917).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 110 ft overall: 86 ft 6 building + 24 ft pavilion; freight room 20 ft 6 x 18; general waiting, ticket office, smoking room; enlarged from a 42 ft old building; lap siding, shingle hip roofs.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[20.5, 66, 0, 24, 12, 0.55, 0, 3, 0], [0, 20.5, 3, 18, 11, 0.55, 0, 3, 0]],
      pavs   = [[86.5, 24, 0, 24, 12, 0.55, 0, 3, 2, 2]],
      wins   = [[27.75, 1, 3, 6, 4.2], [35.25, 1, 3, 6, 4.2], [42.75, 1, 3, 6, 4.2], [50.25, 1, 3, 6, 4.2], [57.75, 1, 3, 6, 4.2], [65.25, 1, 3, 6, 4.2], [72.75, 1, 3, 6, 4.2], [80.25, 1, 3, 6, 4.2], [28.29, 0, 3, 6, 4.2], [36.86, 0, 3, 6, 4.2], [45.43, 0, 3, 6, 4.2], [54.0, 0, 3, 6, 4.2], [62.57, 0, 3, 6, 4.2], [71.14, 0, 3, 6, 4.2], [79.71, 0, 3, 6, 4.2]],
      doors  = [[5, 1, 5, 8, 1, 1], [42, 1, 3.5, 7.5, 0]],
      bays   = [[62, 1, 12, 2.5]],
      chims  = [[35, 12, 24], [70, 12, 24]],
      plat   = [-5, 120, 12, 0.8]);
