// =====================================================================
//  MILWAUKEE ROAD - HORICON, WIS. PASSENGER STATION
//  HAND-BUILT 26 Nov 2026 - do not let the album generator overwrite this file.
//  Source: Album sheet 86, built 1914 (drawn Apr 10 1917).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works.  Shape model, not cut into print sections yet.
//
//  KNOWN (from the sheet):
//   - 110 ft overall: building 86 ft 4 x 18 ft + open pavilion 24 ft at the east end, posts at its outer end.
//   - Waiting-room wing on the TOWN side: 18 ft wide, projects 14 ft, from 26 ft 6 to 44 ft 6
//     (from the west end), hipped roof meeting the main ridge.  Steps at the wing end and on the track side.
//   - Freight room at the west end (double doors both sides, strip window track side and west end).
//   - "Old building 42 ft" = the east part (about 44 ft to 86 ft); the west part is the 1914 addition.
//   - One continuous shingle hip roof over building and pavilion; lap siding over a vertical-board wainscot;
//     two chimneys on the ridge (about 25 ft and 68 ft); eave brackets.
//   - Door and window positions measured off the four elevations.
//  ESTIMATE: heights scaled from the drawing (eave about 12 ft, ridge about 19 ft, chimneys 22 ft),
//   roof pitch, window and door sizes, overhang.
//  COLOURS: from a 2015 colour photo (cream body, white trim, gray shingles) - ESTIMATE until the
//   road trip colour card.  Later changes NOT modelled: track-side glazed lean-to, ramp, the pavilion
//   partly closed in with siding (2015).
//  x = along the track from the WEST end, y = 0 town-side wall, track side +y, feet.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad.  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

// colours (2015 photo, ESTIMATE)
COL_BODY = "#E4DAB4";   // cream siding
COL_TRIM = "#F1EEE4";   // white trim
COL_ROOF = "#6A6A66";   // gray shingles
COL_SASH = "#F1EEE4";

FLOOR = 1.4;
WAIN  = 2.7;            // wainscot cap about 4 ft above grade

L     = 86.33;          // building length
W     = 18;             // building depth
PLATE = 13.2;           // wall plate (eave works out about 12 ft)
RISE  = 0.65;           // roof rise per foot (about 7.8 in 12)
OV    = 1.75;           // eave overhang
PAV   = 24;             // pavilion length

WX0 = 26.5; WL = 18; WD = 14;   // town-side wing

// big windows 3.4 x 6.1, sill 4.4; small toilet windows 2.4 x 4, sill 6.1
module horicon() {
    depot(blocks = [[0, L, 0, W, PLATE, RISE, 5, OV, 0],                       // 0 main body (roof drawn below)
                    [WX0, WL, -WD, WD + W / 2, PLATE, RISE, 5, OV, 0]],        // 1 wing (roof drawn below)
          wins  = [// town side, main wall
                   [82.3, 0, 3.4, 6.1, 4.4], [73.1, 0, 3.4, 6.1, 4.4], [66.9, 0, 2.4, 4.0, 6.1], [62.4, 0, 2.4, 4.0, 6.1],
                   [55.8, 0, 3.4, 6.1, 4.4], [47.4, 0, 3.4, 6.1, 4.4], [22.2, 0, 2.2, 2.2, 7.8],
                   // wing: town face, west side, east side
                   [30.0, 0, 3.4, 6.1, 4.4, 1], [-5.9, 2, 3.4, 6.1, 4.4, 1], [-6.3, 3, 3.4, 6.1, 4.4, 1],
                   // track side
                   [20.8, 1, 6.9, 1.8, 8.4], [29.3, 1, 3.4, 6.1, 4.4], [46.5, 1, 3.4, 6.1, 4.4], [55.4, 1, 3.4, 6.1, 4.4],
                   [63.9, 1, 3.4, 6.1, 4.4], [72.2, 1, 3.4, 6.1, 4.4], [81.1, 1, 3.4, 6.1, 4.4],
                   // west end strip window, east end window
                   [8.7, 2, 6.6, 1.8, 8.4], [13.2, 3, 3.4, 6.1, 4.4]],
          doors = [[10.5, 0, 6, 8.5, 1], [10.5, 1, 6, 8.5, 1],                  // freight room
                   [39.6, 0, 3, 7.1, 0, 1],                                    // wing end
                   [39.2, 1, 3, 7.1, 0],                                       // track side
                   [4.5, 3, 3, 7.1, 0]],                                       // east end (under pavilion)
          chims = [[25, 9, 22.2], [68, 9, 22.2]],
          plat  = [-5, L + PAV + 10, 12, 0.8]);

    // one hip roof over building and pavilion
    roof(0, L + PAV, 0, W, PLATE, RISE, 0, OV);

    // wing roof: hipped at the town end, ridge running back into the main ridge
    EAVE = PLATE - OV * RISE;  RIDGE = PLATE + RISE * W / 2;
    paint("roof") hull() {
        fbox(WX0 - OV, -WD - OV, EAVE, WL + 2 * OV, WD + OV + W / 2, 0.6);
        fbox(WX0 + WL / 2 - 0.05, -WD + WL / 2, RIDGE, 0.1, WD + W / 2 - WL / 2, 0.6);
    }
    paint("trim") {                                                               // wing fascia
        fbox(WX0 - OV, -WD - OV, EAVE - 0.6, WL + 2 * OV, 0.3, 0.6);
        for (x = [WX0 - OV, WX0 + WL + OV - 0.3]) fbox(x, -WD - OV, EAVE - 0.6, 0.3, WD + OV - 0.2, 0.6);
    }

    // pavilion: two posts at the outer end, beams round the open sides
    paint("trim") {
        for (y = [0.2, W - 1.7]) fbox(L + PAV - 1.7, y, 0, 1.5, 1.5, PLATE - 1);
        fbox(L, 0, PLATE - 1.6, PAV, 0.8, 1.6);
        fbox(L, W - 0.8, PLATE - 1.6, PAV, 0.8, 1.6);
        fbox(L + PAV - 0.8, 0, PLATE - 1.6, 0.8, W, 1.6);
    }
    paint("foundation") for (y = [0.2, W - 1.7]) fbox(L + PAV - 1.9, y - 0.2, 0, 1.9, 1.9, 1.2);   // post bases

    // steps: wing end (town side) and track side
    paint("foundation") { fbox(38.5, -WD - 1.5, 0, 6, 1.5, 0.9); fbox(37.6, W, 0, 5.2, 1.5, 0.9); }
}
horicon();
