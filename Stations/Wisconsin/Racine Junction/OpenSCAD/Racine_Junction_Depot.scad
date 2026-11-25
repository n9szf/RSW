// =====================================================================
//  MILWAUKEE ROAD - RACINE JUNCTION, WIS. UNION DEPOT (C.M.&ST.P. AND C.&N.W.)
//  Source: Album sheets 141-142, drawing 9804, Apr 6 1900 (J. U. Nettenstrom).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 63 ft 10 in x 24 ft (35 ft 9 at the octagon); octagonal centre with back-to-back C.&N.W. and C.M.&St.P. waiting rooms 17 x 22, two offices 10 x 15, baggage 15 x 22; stone base, bell-cast hip roofs, cresting. Octagon shown as a square block for now.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 63.8, 0, 24, 12, 0.9, 3, 4, 3], [24, 24, -6, 35.8, 13, 1.0, 3, 4, 3]],
      pavs   = [],
      wins   = [[7.0, 1, 3, 6, 4.2], [17.0, 1, 3, 6, 4.2], [7.0, 0, 3, 6, 4.2], [17.0, 0, 3, 6, 4.2], [56.0, 1, 3, 6, 4.2], [56.0, 0, 3, 6, 4.2]],
      doors  = [[36, 1, 4, 8, 0, 1], [36, 0, 4, 8, 0, 1], [56, 1, 5, 8, 1]],
      bays   = [],
      chims  = [[30, 12, 30], [42, 12, 30]],
      plat   = [-5, 74, 12, 0.8]);
