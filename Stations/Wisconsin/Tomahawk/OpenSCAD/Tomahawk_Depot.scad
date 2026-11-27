// =====================================================================
//  MILWAUKEE ROAD - TOMAHAWK, WIS. PASSENGER STATION
//  Source: Album sheet 100, built 1915 (drawn Chicago Aug 7 1916).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 26 Nov 2026. HAND-BUILT FIRST SHAPE MODEL for review - not cut into print sections.
//  Not in the generator (stations.py) - do not overwrite.
//
//  KNOWN (from the sheet): building 121 ft 11 in x 26 ft (baggage and freight 82 ft 1-1/2 in incl. warm and
//    coal rooms; ticket office 13 ft 5-1/2 in; general waiting 26 ft 4 in); stucco walls, slate roof,
//    gable ends; cross gable over the trackside ticket-office front; 5 ft 6 in gap, then an open shelter
//    41 ft (2 x 20 ft 6 in) x 26 ft on 12 columns in pairs (rows 1, 5, 21, 25 ft across);
//    plank freight platform and incline on the town side at the north end.
//  From photos: 1921 postcard (WHS 150387) and 1982 survey (WHS AHI 21954): round Doric columns on square
//    bases, flat-roofed shelter with exposed beam ends, bracketed eaves.
//  ESTIMATE (scaled off the sheet or guessed): eave 14.5 ft, ridge 25.7 ft, cross-gable peak 21.6 ft,
//    trackside projection depth 3.6 ft, window and door sizes, shelter height (12 ft to the beams),
//    platform sizes, small end vestibule at the south door left off, colours (no colour photo yet:
//    default stucco, dark gray trim, dark slate roof).
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track from the
//  NORTH end, y = 0 town (east) side, track (west) side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
COL_ROOF = "#4F5358";   // ESTIMATE: dark slate

L = 121.92;             // building length
W = 26;                 // building width
EAVE = 14.5;            // ESTIMATE, scaled
// blocks: 0 main, 1 trackside projection (ticket office front), 2 cross gable over it
BLK = [[0, L, 0, W, EAVE + 3.5 * 0.68, 0.68, 1, 3.5, 1],
       [66, 38, W - 1, 4.6, EAVE, 0, 5, 0, 1],
       [79, 22, 17, 12.6, EAVE + 1.5 * 0.57, 0.57, 2, 1.5, 1]];

TALL  = [3.2, 6.7, 4.6];   // double-hung: w, h, sill
SMALL = [2.5, 4.8, 7.4];
HIGH  = [5.5, 2.6, 9.4];   // short wide freight-room windows
function w(x, s, t, b = 0) = [x, s, t[0], t[1], t[2], b];

depot(blocks = BLK,
      wins = [ // track side (west)
               w(9.6, 1, HIGH), w(27.2, 1, HIGH), w(55.9, 1, TALL), w(108.6, 1, TALL), w(114.3, 1, TALL),
               w(67.8, 1, TALL, 1), w(86.8, 1, TALL, 1), w(92.3, 1, TALL, 1),
               // town side (east)
               w(9.8, 0, HIGH), w(31.9, 0, HIGH), w(42.2, 0, HIGH), w(52.1, 0, SMALL),
               w(65.3, 0, TALL), w(71.6, 0, TALL), w(81.2, 0, SMALL), w(91.0, 0, SMALL),
               w(102.0, 0, TALL), w(108.2, 0, TALL), w(114.3, 0, TALL),
               // south end
               w(7, 3, TALL), w(19, 3, TALL)],
      doors = [[41.2, 1, 7, 10, 2], [73.2, 1, 3.2, 7.5, 0, 1], [78.9, 1, 3.2, 7.5, 0, 1], [100.1, 1, 3.2, 7.5, 0, 1],
               [22.5, 0, 6, 10, 2], [7, 2, 6.5, 9, 2], [13, 3, 3.5, 7.5, 0]],
      chims = [[58.8, 13, 29], [94.6, 13, 29]],
      plat  = [-2, 172, 16, 0.4]);

// ---- open shelter (pergola) at the south end ---------------------------------
SX0 = L + 5.5;            // first column line
SH  = 12;                 // ESTIMATE: top of columns
module column(x, y) {
    paint("trim") {
        fbox(x - 0.8, y - 0.8, 0, 1.6, 1.6, 1.2);                              // square base
        translate([ft(x), ft(y), ft(1.2)]) cylinder(r1 = ft(0.6), r2 = ft(0.5), h = ft(SH - 2), $fn = 20);
        fbox(x - 0.75, y - 0.75, SH - 0.8, 1.5, 1.5, 0.8);                     // cap
    }
}
for (i = [0 : 2], y = [1, 5, 21, 25]) column(SX0 + i * 20.5, y);
paint("trim") {
    for (y = [1, 5, 21, 25]) fbox(L, y - 0.45, SH, SX0 + 41 + 2 - L, 0.9, 1.2);    // beams along the track
    for (i = [0 : 2]) fbox(SX0 + i * 20.5 - 0.45, -2, SH + 1.2, 0.9, W + 4, 1); // cross beams, ends exposed
}
roof(L, SX0 + 41 + 2 - L, -1, W + 2, SH + 2.2, 0, 4, 0);                        // flat roof

// ---- plank freight platform and incline, town side at the north end ------------
paint("platform") {
    fbox(-2, -6.5, 0, 33.5, 6.5, 2.5);
    hull() { fbox(-2, -6.5, 0, 0.1, 6.5, 2.5); fbox(-18, -6.5, 0, 0.1, 6.5, 0.1); }
}
