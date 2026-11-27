// =====================================================================
//  MILWAUKEE ROAD - ABRAMS, WIS. PASSENGER STATION (built 1914)
//  Source: Album of Depot Plans 1919, sheet 33 (C.M.&St.P. Engineering Dept., Chicago).
//  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 26 Nov 2026.  HAND-BUILT FIRST SHAPE MODEL - not cut into print
//  sections.  Not in the generator (do not let make_depots.py overwrite it).
//
//  Line: Milwaukee & Northern (Green Bay - Menominee River), milepost 134, Oconto County.
//  Built after the Abrams Business Men's Association complaint to the Railroad
//  Commission of Wisconsin (decided 28 Jul 1914) that the old 1881 depot was inadequate.
//  Fate: not known, probably gone.  No sign on the web that it still stands (26 Nov 2026).
//
//  KNOWN (from the sheet):
//   - 52 ft 6 in x 24 ft.  Along the track side from the waiting-room end:
//     4 ft 6, bay 2 ft 10 / 4 ft 1 / 2 ft 10, 19 ft 9 to the freight door, 18 ft 6 to the end.
//   - Waiting room, office (with track-side bay), warm room, freight room (about 33 x 24).
//   - Freight doors on both sides, opposite each other; track-side one paired, panelled,
//     with a transom.
//   - Waiting-room door in the west (waiting) end, a window each side of it.
//     West end dims from the town side: 5 ft 8, 6 ft 8, 6 ft 0, 5 ft 8.
//   - Freight end marked at 8 ft, 8 ft, 8 ft.
//   - Gable roof, ridge along the track, shingles; lap siding with a belt and water table;
//     vertical boards in the gables over a boxed cornice; brick chimney near the office.
//   - Track side drawn: paired bay windows, freight door; no other openings.
//  ESTIMATE (scaled from the sheet, about +/- 0.5 ft, or guessed):
//   - Cornice 11.3 ft above grade, plate 13.7 ft, ridge 22.3 ft, roof slope about 8.6 in 12.
//   - Eave overhang 3.3 ft, gable rake overhang 4.2 ft; bay depth 3 ft (bay drawn square).
//   - Window 3.2 x 5.9 ft, sill 3.7 ft; freight door 5.4 x 7 ft.
//   - Town side is NOT drawn: freight door from the plan; one waiting-room window guessed.
//   - Freight-end windows at the 8 ft marks; chimney height; platform.
//   - Colours: RSW default light gray body, dark gray trim (no photo).
//
//  Shared builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE 29 G, 48 O, 87 HO.  Data below is measured from the
//  waiting-room end; the whole model is mirrored so the track side reads like the sheet
//  (waiting room on the left, freight door on the right).  Compass direction not known.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
WAIN = 1.8;     // belt course about 3.3 ft above grade (scaled from the sheet)

L  = 52.5;      // length
W  = 24;        // width
COR = 11.3;     // ESTIMATE top of the siding / boxed cornice
RISE = 0.72;    // ESTIMATE roof slope (about 8.6 in 12)
OV = 3.3;       // ESTIMATE eave overhang
RAKE = 4.2;     // ESTIMATE gable rake overhang
PL = COR + OV * RISE;   // plate where the roof plane meets the wall line
BAY_D = 3.0;    // ESTIMATE bay depth

MAIN = [0, L, 0, W, PL, RISE, 5, 0, 0];                // roof drawn below (kind 5); no knee braces (none on the sheet)
BAYB = [4.5, 9.75, W, BAY_D, COR - 0.2, 0, 5, 0, 0];  // square office bay under the eave

translate([ft(L), 0, 0]) mirror([1, 0, 0]) {
depot(blocks = [MAIN, BAYB],
      wins = [
        // track side: paired bay windows
        [6.9, 1, 3.2, 5.9, 3.7, 1], [11.6, 1, 3.2, 5.9, 3.7, 1],
        // narrow window in each side of the bay (end elevation)
        [W + 1.5, 2, 1.3, 5.9, 3.7, 1], [W + 1.5, 3, 1.3, 5.9, 3.7, 1],
        // west (waiting) end: window, door, office window
        [5.3, 2, 3.0, 5.9, 3.7], [18.3, 2, 3.0, 5.9, 3.7],
        // freight end (ESTIMATE, at the 8 ft marks)
        [8, 3, 2.6, 4.5, 5.0], [16, 3, 2.6, 4.5, 5.0],
        // town side, waiting room (ESTIMATE - side not drawn)
        [9.5, 0, 3.2, 5.9, 3.7]
      ],
      doors = [
        [12.5, 2, 3.0, 7.0, 0],          // waiting-room door, west end
        [34.0, 1, 5.4, 7.0, 1],          // freight door, track side (paired, transom)
        [34.0, 0, 5.4, 7.0, 2]           // freight door, town side (from the plan)
      ],
      chims = [[16.3, 12.2, 25.4]],
      plat = [-6, L + 12, 12, 0.5]);

// gable roof with the wider rake, its fascia, and the gable walls
EAVE = PL - OV * RISE;
paint("roof") roof_solid(-RAKE, L + 2 * RAKE, -OV, W + 2 * OV, EAVE, RISE, 1);
paint("trim") {
    fbox(-RAKE, -OV, EAVE - 0.6, L + 2 * RAKE, 0.4, 0.6);
    fbox(-RAKE, W + OV - 0.4, EAVE - 0.6, L + 2 * RAKE, 0.4, 0.6);
    // boxed cornice across each gable end (the pent line on the end elevation)
    for (x = [-0.8, L]) fbox(x, -OV, COR - 0.3, 0.8, W + 2 * OV, 0.5);
    // frieze board at the top of the siding all round
    fbox(-0.15, -0.15, COR - 0.9, L + 0.3, W + 0.3, 0.6);
}
gable_ends(0, L, 0, W, PL, RISE, 1, 0);
// vertical boards in the gables: thin battens on each gable face
paint("trim") for (x = [-0.12, L], y = [1 : 1.2 : W - 1])
    let (top = PL + RISE * (y < W / 2 ? y : W - y))
        if (top > COR + 0.6) fbox(x, y, COR + 0.2, 0.12, 0.15, top - COR - 0.3);
}
