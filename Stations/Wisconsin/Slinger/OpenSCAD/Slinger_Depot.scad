// =====================================================================
//  MILWAUKEE ROAD - SCHLEISINGERVILLE (SLINGER), WIS. PASSENGER DEPOT
//  Source: Album sheet 74, drawing B-1026, Oct 30 1911.  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 70 ft 6 in x 24 ft + 32 ft pavilion; freight and baggage 24 ft 3 x 23 ft 6, smoking 11 ft 11 x 23, office 12 ft 6 x 17, general waiting 19 ft 4 x 23 ft 6; hipped shingle roof, lap siding.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

depot(blocks = [[0, 70.5, 0, 24, 12, 0.5, 0, 3.5, 0]],
      pavs   = [[70.5, 32, 0, 24, 12, 0.5, 0, 3.5, 2, 2]],
      wins   = [[43.75, 1, 3, 6, 4.2], [51.25, 1, 3, 6, 4.2], [58.75, 1, 3, 6, 4.2], [66.25, 1, 3, 6, 4.2], [30.4, 0, 3, 6, 4.2], [39.2, 0, 3, 6, 4.2], [48.0, 0, 3, 6, 4.2], [56.8, 0, 3, 6, 4.2], [65.6, 0, 3, 6, 4.2]],
      doors  = [[8, 1, 5, 8, 1], [30, 1, 3.5, 7.5, 0], [56, 1, 3.5, 7.5, 0]],
      bays   = [[44, 1, 12, 2.5]],
      chims  = [[20, 12, 24], [45, 12, 24]],
      plat   = [-5, 112, 12, 0.8]);
