// =====================================================================
//  MILWAUKEE ROAD - MONROE, WIS. PASSENGER DEPOT (J. T. W. JENNINGS)
//  Source: Album sheet 144 (marked 14), drawing 2005, July 1888 (J. T. W. Jennings).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut into print sections.
//  KNOWN (from the sheet): 62 ft 6 in x 20 ft; two waiting rooms 24 ft 3, octagonal office bay 11 ft, baggage 12 ft; steep hipped roof with flared eaves, gabled dormer, iron cresting; lap siding with vertical boards below.
//  ESTIMATE: wall and ridge heights where not written, window count and spacing, colours.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
// COLOURS measured from photos 24 Nov 2026: railpictures.net (Greg Mross) colour photo before the 1993 move. Pale yellow body, maroon-brown trim and wainscot, green shingles, red brick chimney (a later repaint - the standard was light gray with dark gray trim).
COL_BODY = "#D2BC82";
COL_TRIM = "#6E4040";
COL_ROOF = "#4F5C4C";

depot(blocks = [[0, 62.5, 0, 20, 13, 1.0, 3, 4.5, 0]],
      pavs   = [],
      wins   = [[7.0, 1, 3, 6, 4.2], [17.0, 1, 3, 6, 4.2], [27.0, 1, 3, 6, 4.2], [37.0, 1, 3, 6, 4.2], [47.0, 1, 3, 6, 4.2], [57.0, 1, 3, 6, 4.2], [6.83, 0, 3, 6, 4.2], [16.5, 0, 3, 6, 4.2], [26.17, 0, 3, 6, 4.2], [35.83, 0, 3, 6, 4.2], [45.5, 0, 3, 6, 4.2], [55.17, 0, 3, 6, 4.2]],
      doors  = [[16, 1, 3.5, 8, 0], [37, 1, 3.5, 8, 0], [56, 1, 5, 8, 1]],
      bays   = [[25, 1, 11, 3.5]],
      chims  = [[25, 10, 29]],
      plat   = [-6, 75, 12, 0.8]);
