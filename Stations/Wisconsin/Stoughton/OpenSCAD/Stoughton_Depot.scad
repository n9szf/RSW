// =====================================================================
//  MILWAUKEE ROAD - STOUGHTON, WIS. PASSENGER STATION  (AS BUILT 1913)
//  HAND-BUILT 26 Nov 2026 - do not let the album generator overwrite this file.
//  Source: Album of Depot Plans 1919, sheet 106 "Passenger Station, Stoughton Wis,
//  built in 1913" (drawn Chicago Apr 11 1919, scale 1/16 in = 1 ft).  Private
//  reference (in copyright): Research Library / RSW / Stations / Standard depots.
//  532 E. Main St., Stoughton (south end faces Main St.; tracks run north-south
//  on the EAST side; town / driveway side is west).
//
//  BASE ERA: 1913 as built (Tom 26 Nov 2026).  Remodels of 1923 and 1945 and the
//  1990 restoration are NOT modelled (see Notes / Stoughton_research_2026-11-26.md).
//
//  KNOWN (written on the sheet): 129 ft 5 in overall incl. 27 ft 5 in pavilion;
//    27 ft 6 in wide; waiting room 37 ft 0 (room 26 x 36 ft 6); ticket office
//    18 ft 10 (room 18 ft 6 x 17); smoking + baggage 46 ft 2 (smoking 20 x 26,
//    baggage 23 ft 6 x 26); cement plaster walls, brick base and corners,
//    shingle-tile roof, composition roof on the pavilion, columns of brick and
//    cement plaster.
//  SCALED from the sheet (about 11.6 px per ft at 2560 px; +/- 0.5 ft):
//    wall plate 13.5 ft, main ridge 24.5 ft, track-side gable peak 22 ft,
//    pavilion beam 12.5 ft, window sill 4.4 ft and head 10.8 ft, belt at 3.7 ft,
//    chimney tops 26.6 ft, ventilator tops 28 ft; opening centres along the track.
//  FROM PHOTOS (2007-2024, see reference/Station photos web/Stoughton/index.csv):
//    cream stucco, maroon-brown trim, base band and belt course, reddish-brown
//    roof shingles, pavilion piers of brown brick with cream plaster blocks.
//    D. Kalland (Historical Society): the 1990 restoration kept the original
//    colours, so the photo colours are used for 1913.
//  ESTIMATE: town-side (west) openings (not drawn on the sheet - only the plan),
//    eave overhang 2.5 ft, cross-gable on the town side (assumed none),
//    pavilion roof pitch, bracket spacing, exact colours.
//
//  Builder: ../../../_common/rsw_depot.scad (feet; x along the track from the
//  south / pavilion end, y = 0 town side, track side +y).  SCALE 29 G, 48 O, 87 HO.
//  FIRST SHAPE for review - not cut into print sections yet.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

// colours (photos 2007-2024, restoration said to match original)
COL_STUC  = "#D6CBB4";   // cream cement plaster
COL_TRIM  = "#6E4547";   // maroon-brown trim, base band, belt, fascia
COL_BRICK = "#6E4A3A";   // brown brick piers and chimneys
COL_ROOF  = "#5E4038";   // reddish-brown shingle tile
COL_FOUND = "#8A7766";
COL_SASH  = "#6E4547";
COL_DOOR  = "#5A3A2C";
FLOOR = 1.5;

L_MAIN = 102.0;   // 129 ft 5 in less 27 ft 5 in pavilion
W      = 27.5;
PLATE  = 13.5;
X0     = 27.42;   // south wall of the building (pavilion is x 0 .. 27.42)

// pavilion pier: brown brick with cream plaster blocks
module pier(xc, yc) {
    s = 2.2; h = 11.5;
    paint("brick") fbox(xc - s / 2, yc - s / 2, 0, s, s, h);
    paint("stucco") for (z = [1.2 : 1.1 : h - 1.5]) fbox(xc - s / 2 - 0.05, yc - s / 2 - 0.05, z, s * 0.55, s + 0.1, 0.5);
    paint("stucco") fbox(xc - s / 2 - 0.2, yc - s / 2 - 0.2, h, s + 0.4, s + 0.4, 0.5);   // cap
    paint("trim")   fbox(xc - s / 2 - 0.2, yc - s / 2 - 0.2, 0, s + 0.4, s + 0.4, 0.8);   // base
}

// The builder's axes are mirror-handed for this plan: seen from the track the sheet
// shows the pavilion on the LEFT (south), so the whole station is mirrored in x here.
// Model x = 0 is now the NORTH (baggage) end; data below is still measured from the south.
L_ALL = 129.42;
translate([ft(L_ALL), 0, 0]) mirror([1, 0, 0]) {
depot(blocks = [[X0, L_MAIN, 0, W, PLATE, 0.80, 1, 2.5, 1],          // main block, gable ends N and S
                [61.5, 24.6, 13.75, 13.75, PLATE, 0.69, 2, 2.5, 1]], // track-side cross gable over the ticket bay
      pavs   = [[0, X0, 0, W, 12.5, 0.15, 0, 3, 2, 2]],              // open pavilion, low hip, composition roof
      wins   = [// track side (east)
                [36.7, 1, 7.9, 6.4, 4.4], [48.9, 1, 8, 6.4, 4.4], [97.5, 1, 8, 6.4, 4.4],
                // town side (west) - ESTIMATE from the plan
                [33.5, 0, 5.5, 6.4, 4.4], [45.9, 0, 5.5, 6.4, 4.4], [58.0, 0, 5.5, 6.4, 4.4],
                [69.0, 0, 3, 2.5, 8.0], [76.5, 0, 3, 2.5, 8.0],
                [90.0, 0, 3.5, 6.4, 4.4], [100.0, 0, 3.5, 6.4, 4.4],
                // south end (under the pavilion): triple window
                [13.75, 2, 8, 6.4, 4.4],
                // north end: two small windows (sheet, north-end elevation)
                [9.5, 3, 2.5, 3, 7.5], [18.0, 3, 2.5, 3, 7.5]],
      doors  = [[60.2, 1, 5.9, 7.2, 1], [87.6, 1, 5.7, 7.2, 1], [115.0, 1, 5.8, 8.2, 1],   // track side
                [64.0, 0, 3.2, 7.2, 0], [119.0, 0, 5.8, 8.2, 1]],                         // town side ESTIMATE
      bays   = [[73.8, 1, 13, 3.5]],
      chims  = [[65.3, 13.75, 26.6], [103.3, 13.75, 26.6]],
      plat   = [-5, 140, 14, 0.8]);

// ---- Stoughton details the shared builder does not draw ----------------------
// maroon-brown base band (grade to 3.7 ft) and belt course at the window sills
paint("trim") {
    fbox(X0 - 0.15, -0.15, 0.5, L_MAIN + 0.3, W + 0.3, 3.2);
    fbox(X0 - 0.15, -0.15, 4.1, L_MAIN + 0.3, W + 0.3, 0.3);
    fbox(X0 - 0.15, -0.15, PLATE - 1.3, L_MAIN + 0.3, W + 0.3, 0.35);   // frieze band under the eave
}
// brick corner pilasters on the main block ("BRICK" on the sheet)
paint("brick") for (x = [X0 - 0.3, X0 + L_MAIN - 1.2], y = [-0.3, W - 1.2]) fbox(x, y, 0.5, 1.5, 1.5, PLATE - 1.6);

// pavilion piers: brown brick with cream plaster blocks, set on the builder's post spots
for (xc = [0.8, 26.62], yc = [0.8, 26.7]) pier(xc, yc);

// pavilion brackets under the wide eave (photos)
paint("trim") for (x = [2 : 4 : 26], s = [0, 1])
    translate([ft(x), s ? ft(W) : 0, ft(10.2)]) rotate([0, 0, s ? 0 : 180]) rotate([90, 0, 90])
        linear_extrude(ft(0.35)) polygon([[0, 0], [0, ft(2.3)], [ft(2.6), ft(2.3)], [ft(0.4), ft(0.3)]]);

// ridge ventilators (round, capped)
paint("trim") for (x = [43.3, 84.2]) translate([ft(x), ft(W / 2), ft(23.5)]) {
    cylinder(r = ft(0.9), h = ft(3.2), $fn = 24);
    translate([0, 0, ft(3.2)]) cylinder(r1 = ft(1.4), r2 = ft(0.2), h = ft(1.3), $fn = 24);
}
}   // end mirror
