// =====================================================================
//  MILWAUKEE ROAD - WOODMAN, WIS. PASSENGER STATION (built 1914)
//  Source: Album of Depot Plans 1919, sheet 105 (C.M.&St.P. Engineering Dept.,
//  drawn Chicago May 20 1919).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 26 Nov 2026.  HAND-BUILT FIRST SHAPE MODEL - not cut into print
//  sections.  Not in the generator (do not let make_depots.py overwrite it).
//
//  Fate: not known.  No sign on the web that it still stands (checked 26 Nov 2026).
//
//  KNOWN (from the sheet):
//   - 52 ft 2 in x 24 ft 2 in.  From the west end: 17 ft 0 waiting, 9 ft 0 ticket bay,
//     26 ft 2 baggage.  General waiting 14 x 23, smoking 11 ft 4 x 13, ticket office
//     11 ft 4 x 13, baggage and freight 23 x 23 with a 4-ton depot scale.
//   - Square-cornered ticket bay, 9 ft wide, on the track side, paired window.
//   - Gable roof, ridge along the track, shingles, quarter pitch (rise 1/2 per ft).
//   - 6 in drop siding, cement curbing at the base, brackets under the eaves.
//   - Track side: window, passenger door with transom, bay, freight door with transom.
//   - One high 4-light window in each gable end; brick chimney at the office wall.
//   - Ceilings 12 ft (waiting), 14 ft (baggage); baggage floor is cement near grade.
//  ESTIMATE (scaled from the sheet or guessed):
//   - Plate 14.6 ft above grade, eave overhang 4 ft, gable rake overhang 4 ft.
//   - Window and door sizes and positions scaled off the drawing (about +/- 0.5 ft).
//   - Town side is NOT drawn: windows and the freight door placed from the floor plan.
//   - Bay depth 3.2 ft (scaled from the plan); bay wall height.
//   - Platform size.  Colours: RSW default light gray body, dark gray trim (no photo).
//
//  Shared builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE 29 G, 48 O, 87 HO.  Data below is measured from the
//  waiting-room end; the whole model is mirrored so the track side reads like the sheet
//  (waiting room on the left, freight door on the right).  Compass direction not known.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
WAIN = -1.0;    // no belt course on the sheet: tuck the builder's belt into the water table

L  = 52.17;     // length
W  = 24.17;     // width
PL = 14.6;      // ESTIMATE plate height
RISE = 0.5;     // quarter pitch
OV = 4;         // ESTIMATE eave overhang
RAKE = 4;       // ESTIMATE gable rake overhang
BAY_D = 3.2;    // ESTIMATE bay depth

// main block draws its own roof below (roof kind 5) so the rake can be wider than the builder's 1 ft
MAIN = [0, L, 0, W, PL, RISE, 5, OV, 0];
BAYB = [17, 9, W, BAY_D, PL - OV * RISE + (OV - BAY_D) * RISE, 0, 5, 0, 0];   // bay walls run up under the eave

translate([ft(L), 0, 0]) mirror([1, 0, 0]) {
depot(blocks = [MAIN, BAYB],
      wins = [
        // track side
        [3.9, 1, 2.8, 6.5, 4.3],
        [20.2, 1, 2.6, 6.5, 4.3, 1], [23.0, 1, 2.6, 6.5, 4.3, 1],     // paired bay window
        // town side (ESTIMATE from the plan)
        [7.6, 0, 2.8, 6.5, 4.3],
        [18.0, 0, 2.8, 6.5, 4.3], [24.1, 0, 2.8, 6.5, 4.3],
        // high window in each gable end (over the benches)
        [W / 2, 2, 5.5, 3.0, 8.6], [W / 2, 3, 5.5, 3.0, 8.6]
      ],
      doors = [
        [11.2, 1, 3.0, 7.2, 0],           // waiting-room door with transom
        [35.0, 1, 6.0, 7.5, 2],           // freight door, track side
        [39.8, 0, 6.0, 7.5, 2]            // freight door, town side (from the plan)
      ],
      chims = [[15.6, W / 2, 24.4]],
      plat = [-6, L + 12, 12, 0.5]);

// gable roof with the wider rake, its fascia, and the gable walls
EAVE = PL - OV * RISE;
paint("roof") roof_solid(-RAKE, L + 2 * RAKE, -OV, W + 2 * OV, EAVE, RISE, 1);
paint("trim") {
    fbox(-RAKE, -OV, EAVE - 0.6, L + 2 * RAKE, 0.4, 0.6);
    fbox(-RAKE, W + OV - 0.4, EAVE - 0.6, L + 2 * RAKE, 0.4, 0.6);
}
gable_ends(0, L, 0, W, PL, RISE, 1, 0);

// brackets under the rake at each gable end (ESTIMATE spacing)
paint("trim") for (x = [0, L], y = [2, W - 2.3])
    translate([ft(x), ft(y), ft(PL - 2.4 + (y < W / 2 ? y : W - y - 0.3) * RISE)])
        rotate([0, 0, x == 0 ? 180 : 0]) rotate([90, 0, 0]) translate([0, 0, -ft(0.15)])
            linear_extrude(ft(0.3)) polygon([[0, 0], [0, ft(2.4)], [ft(RAKE * 0.75), ft(2.4)], [ft(0.4), ft(0.3)]]);
}
