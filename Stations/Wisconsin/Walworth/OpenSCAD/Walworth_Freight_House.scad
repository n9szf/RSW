// =====================================================================
//  MILWAUKEE ROAD - WALWORTH, WIS. 24 X 48 FT FREIGHT HOUSE
//  Source: Album sheet 125, drawing B-755, Sept 16 1910 (also used at Mobridge, S.D. 1912).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 24 x 48 ft, floor 3 ft 6 above rail on posts, 6 ft platform track side; 14 ft walls, 1/3 pitch shingle roof, drop siding, class B rolling doors.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 48, 0, 24, 17.5, 0.66, 1, 2, 0]],
      pavs   = [],
      wins   = [],
      doors  = [[12, 1, 6, 8, 2], [36, 1, 6, 8, 2], [24, 0, 6, 8, 2]],
      bays   = [],
      chims  = [],
      plat   = [-6, 60, 6, 3.5]);
