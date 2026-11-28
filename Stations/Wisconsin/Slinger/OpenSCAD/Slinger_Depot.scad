// =====================================================================
//  MILWAUKEE ROAD - SCHLEISINGERVILLE (SLINGER), WIS. PASSENGER DEPOT (1911)
//  HAND-BUILT 27 Nov 2026 - do not overwrite with the album generator.
//  Source: Album sheet 74, drawing B-1026, Chicago Oct 30 1911 (track side elevation,
//  end elevation, floor plan, half section).  Drawings are private reference (in copyright):
//  Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works.  Not cut into print sections yet.
//
//  KNOWN (written on the sheet):
//   - main building 70 ft 6 in x 24 ft; open pavilion 32 ft long at the waiting-room end
//   - track side: 38 ft 2 to the office bay, bay 12 ft 0, then 20 ft 4
//   - town side: 37 ft 2 to the toilet annex, annex 13 ft 6, then 19 ft 10
//   - rooms: freight and baggage 24-3 x 23-0, smoking 11-11 x 23-0, office 12-6 x 17-0,
//     general waiting 19-4 x 23-6
//   - floor to ceiling 12 ft 2 in (section); 4 in lap siding above, V-ceiling (beaded
//     board) set vertical below the belt; shingle hip roof; boxed cornice with frieze and
//     pilasters (no knee brackets drawn on the main building)
//   - pavilion: hip roof, lower ridge and narrower than the main roof; twin tapered
//     columns on square pedestals, 4 piers plus engaged posts at the building
//  SCALED FROM THE SHEET (not written): eave overhang about 5 ft; roof pitch about 6 in 12;
//   pavilion roof 27 ft wide, about 35 ft long; pier centres about x 85.5 and 100.5;
//   door and window positions on the track side; chimneys on the ridge over the freight-
//   room heater and the office.
//  ESTIMATE (not shown on the sheet): floor 1 ft above grade; town-side and end window
//   positions; toilet-annex windows; pilaster spacing; column and pedestal sizes; colours
//   (Milwaukee Road default light gray body, dark gray trim - no colour photo yet).
//
//  NOW: the building stands - moved off the MILW/Soo crossing and turned about 90 deg to
//  face Kettle Moraine Dr S (no. 414); restored 1986 (E.H. Wolf & Sons); since 2020 the
//  Schleisingerville to Slinger Historical Museum.  This model is the 1911 building as drawn.
//
//  Data below is in sheet feet from the freight end; the last line mirrors it so the
//  freight room is on the left seen from the track (see the note there).
//  Shared builder ../../../_common/rsw_depot.scad (x along the track, y = 0 town side,
//  track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.  PAINT = "<name>" draws one paint.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

FLOOR = 1.0;          // ESTIMATE: floor above grade
WAIN  = 3.2;          // belt about 4 ft 2 above grade, as scaled from the elevation

L    = 70.5;          // KNOWN
W    = 24;            // KNOWN
EAVE = FLOOR + 12.2;  // eave at ceiling level (section: rafters bear at the ceiling line)
OV   = 5;             // eave overhang, scaled
RISE = 0.5;           // 6 in 12, scaled from section and end elevation
PLATE = EAVE + OV * RISE;   // builder's "plate" = eave + overhang drop
SOFFIT = EAVE - 0.6;

// ---- pavilion (KNOWN 32 ft; rest scaled) ----
PX1  = L + 32;        // end of pavilion floor
PRX1 = PX1 + 3;       // end of pavilion roof
PY0 = -1.5; PY1 = 25.5;     // pavilion roof edges (27 ft wide)
PIER_X = [85.5, 100.5];
PIER_Y = [2, 22];

// ---- annex and bay (KNOWN plan sizes) ----
TOI = [37 + 2/12, 13.5, 4.5];   // toilet annex on the town side: x0, length, depth (depth scaled)
BAY = [38 + 2/12, 12, 3];       // office bay on the track side: x0, width, depth (depth scaled)

module wall_trim(x0, l, y0, w) paint("trim") {          // frieze under the soffit
    fbox(x0 - 0.12, y0 - 0.12, SOFFIT - 1.3, l + 0.24, w + 0.24, 1.3);
}
// a pilaster strip on the town (side 0) or track (side 1) face of a box
module pilaster(x, yface, side) paint("trim")
    fbox(x - 0.3, side ? yface : yface - 0.14, 0.5, 0.6, 0.14, SOFFIT - 1.3 - 0.5);

// a small box building that sits under the main eave (annex, bay)
module lean(x0, l, y0, w) {
    paint("walls") fbox(x0, y0, 0.5, l, w, SOFFIT - 0.5);
    paint("foundation") fbox(x0, y0, 0, l, w, 0.5);
    paint("trim") {
        fbox(x0 - 0.15, y0 - 0.15, FLOOR + WAIN - 0.2, l + 0.3, w + 0.3, 0.35);
        fbox(x0 - 0.15, y0 - 0.15, 0.5, l + 0.3, w + 0.3, 0.4);
        for (x = [x0 - 0.25, x0 + l - 0.15], y = [y0 - 0.25, y0 + w - 0.15]) fbox(x, y, 0.5, 0.4, 0.4, SOFFIT - 0.5);
    }
    wall_trim(x0, l, y0, w);
}

// twin tapered columns on a square pedestal (pavilion pier); dx = column spacing
module pier(x, y, twin = true, ped = 3.4) {
    PH = 3.8;                              // pedestal height
    top = SOFFIT - 1.6;                     // underside of the beam
    paint("trim") {
        fbox(x - ped / 2, y - ped / 2, 0, ped, ped, PH);
        fbox(x - ped / 2 - 0.2, y - ped / 2 - 0.2, PH, ped + 0.4, ped + 0.4, 0.3);
        for (dx = twin ? [-0.8, 0.8] : [0]) hull() {
            fbox(x + dx - 0.5, y - 0.5, PH + 0.3, 1.0, 1.0, 0.1);
            fbox(x + dx - 0.38, y - 0.38, top - 0.6, 0.76, 0.76, 0.1);
        }
        fbox(x - (twin ? 1.5 : 0.7), y - 0.7, top - 0.5, twin ? 3.0 : 1.4, 1.4, 0.5);   // capital
    }
}

module pavilion_slinger() {
    // roof: hip at the far end, near end runs into the main roof
    paint("roof") hull() {
        fbox(L - 12, PY0, EAVE, PRX1 - (L - 12), PY1 - PY0, 0.6);
        fbox(L - 12, (PY0 + PY1) / 2 - 0.05, EAVE + RISE * (PY1 - PY0) / 2, PRX1 - (PY1 - PY0) / 2 - (L - 12), 0.1, 0.6);
    }
    paint("trim") fbox(L, PY0, SOFFIT, PRX1 - L, PY1 - PY0, 0.6);            // boxed soffit and fascia
    // beams on the piers and frieze
    paint("trim") {
        for (y = PIER_Y) fbox(L, y - 0.6, SOFFIT - 1.6, PIER_X[1] + 0.6 - L, 1.2, 1.6);
        for (x = PIER_X) fbox(x - 0.6, PIER_Y[0] - 0.6, SOFFIT - 1.6, 1.2, PIER_Y[1] - PIER_Y[0] + 1.2, 1.6);
    }
    for (x = PIER_X, y = PIER_Y) pier(x, y);
    for (y = PIER_Y) pier(L + 0.6, y, twin = false, ped = 1.6);             // engaged posts at the building
    paint("platform") fbox(L, -1, 0, PX1 - L + 1, W + 1, 0.5);            // pavilion floor
}

module slinger_depot() {
    B = [0, L, 0, W, PLATE, RISE, 5, OV, 0];
    block(B);                                            // walls, belt, water table, corner boards (roof drawn below)
    roof(0, L, 0, W, PLATE, RISE, 0, OV);                // hip roof with boxed eave all round
    wall_trim(0, L, 0, W);
    lean(TOI[0], TOI[1], -TOI[2], TOI[2]);               // toilet annex (town side)
    lean(BAY[0], BAY[1], W, BAY[2]);                     // office bay (track side)
    for (x = [16, 24.25, 31.6, 36.6, 54.4, 60.75, 67.5]) pilaster(x, W, 1);
    for (x = [16, 24.25, 31.6, 53.0, 60.25, 67.5])        pilaster(x, 0, 0);
    // track side (side 1) - positions scaled from the elevation
    for (o = [[28.3, 3, 6.5, 4.5], [57.6, 3, 6.5, 4.5], [63.9, 3, 6.5, 4.5]]) on_face(B, o[0], 1) window(o[1], o[2], o[3]);
    on_face(B, 11.9, 1) door(5.8, 7.8, 1);               // baggage, double
    on_face(B, 34.1, 1) door(3, 7, 0);                   // smoking room
    on_face(B, 52.2, 1) door(3, 7, 0);                   // general waiting
    BB = [BAY[0], BAY[1], W, BAY[2]];
    for (x = [41.3, 45.4]) on_face(BB, x, 1) window(3, 6.5, 4.5);
    for (y = [W + 1.5]) { on_face(BB, y, 2) window(1.4, 6.5, 4.5); on_face(BB, y, 3) window(1.4, 6.5, 4.5); }   // ESTIMATE bay side lights
    // town side (side 0) - baggage door from the plan, windows ESTIMATE
    on_face(B, 11.6, 0) door(5.8, 7.8, 1);
    for (x = [28.5, 57.8, 62.6]) on_face(B, x, 0) window(3, 6.5, 4.5);
    TT = [TOI[0], TOI[1], -TOI[2], TOI[2]];
    for (x = [40.5, 47.4]) on_face(TT, x, 0) window(2, 2.5, 8.5);   // toilet lights, ESTIMATE
    // ends - ESTIMATE
    for (y = [8, 16]) on_face(B, y, 2) window(3.5, 2.5, 9);         // freight room: high lights
    for (y = [8, 16]) on_face(B, y, 3) window(3, 6.5, 4.5);         // waiting room, under the pavilion
    // chimneys on the ridge (freight-room heater, office) - scaled from the plan
    for (x = [23.8, 49.0]) paint("chimney") { fbox(x - 0.8, W / 2 - 0.8, 6, 1.6, 1.6, 18.6); fbox(x - 1, W / 2 - 1, 24.1, 2, 2, 0.5); }
    pavilion_slinger();
    paint("platform") fbox(-5, W, 0, PRX1 + 5, 12, 0.8);              // track-side platform
}

// The sheet's plan has the track side at the bottom, so its x/y are mirrored against the
// builder's axes (y = 0 town, track +y).  All data above is in sheet feet from the freight
// end; this mirror puts the freight room on the LEFT when seen from the track, as drawn.
// Result: freight end at x = 0 ... 70.5 reversed, pavilion toward -x.
translate([ft(L), 0, 0]) mirror([1, 0, 0]) slinger_depot();
