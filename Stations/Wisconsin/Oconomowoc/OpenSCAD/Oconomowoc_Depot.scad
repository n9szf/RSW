// =====================================================================
//  MILWAUKEE ROAD - OCONOMOWOC, WIS. PASSENGER DEPOT (1896)
//  Charles Sumner Frost, architect, 604 Pullman Bldg, Chicago.  Stands today at
//  115 E. Collins St. (Maxim's Restaurant), NRHP 80000206.
//  Sources: MPL station drawings (small copies) "default (22)-(25)":
//   (23) B-2087 ground plan + elevation toward track, (24) B-2086 foundation +
//   elevation toward street, (25) B-2088 end elevation, cross section, tablet,
//   trusses, bracket, (22) 6949-50 later redraw of the plan "from drawings by C.S. Frost".
//  Drawings are private reference: Research Library / RSW / Stations / (to sort).
//  Rib Side Works, 26 Nov 2026 (rev 2: NRHP form and photos applied).
//
//  FROM THE SHEETS:
//   - 193'-0" overall under ONE long hip roof, from one end: baggage room 40 x 30,
//     open covered passage 20 ft, depot 88'-4" x 30 (women's waiting, ticket office,
//     men's waiting), open truck shed 44'-6" x 30 on stone piers (24'-6" + 20'-0").
//   - Split granite (fieldstone) walls; tall cross gable at the ticket office, about
//     43 ft wide, with stepped vertical shoulders and four windows high up.
//     The track gable carries the OCONOMOWOC tablet (sheet 25).
//   - Measured off the small sheets (about 7.5-9.4 px/ft, +/- 1 ft): eave 10 ft,
//     main ridge 25 ft, gable shoulders 21.4 ft, gable apex 33.6 ft, big chimney 40 ft.
//   - Octagonal ticket office bay at the centre (drawn on the plan's lower side).
//  FROM THE NRHP FORM (1978): split granite boulders with Lake Superior sandstone trim;
//   extended hipped roof on wooden brackets resting on granite corbels; both gables have
//   PARAPETS with sandstone coping and four attic windows split by granite mullions, cut
//   sandstone sills; baggage room to the EAST, open truck shed to the WEST on four square
//   columns with Tudor-arch trusses.  Depot is on the north side of the tracks, so
//   x = 0 is the east end, +x runs west, y = 0 is the north (Collins St.) face.
//  FROM PHOTOS (reference/Station photos web/Oconomowoc 01-27, 41-43; 2005-2020 plus a
//   Dec 1963 slide): street gable is STONE like the track gable; two stone chimneys (on the
//   gable ridge and at the east end of the main ridge); slate roof, gray with green
//   patina, metal ridge cresting; red brackets today (white in 1963, roof then brown).
//  LATER CHANGES NOT MODELLED: truck shed bricked in as a dining room, passage between
//   depot and baggage room closed with wood doors, gray frame enclosure on the track side.
//  ESTIMATE: bay on the track side (photo 42 suggests it), roof overhang 6 ft sides / 3 ft ends,
//   window and door sizes and spacing (small sheets), colours (web photos, no gray card),
//   chimney sizes, pier size 2.5 ft.  No brackets, corbels, lettering or shed trusses yet.
//  x along the track (x = 0 baggage / east end, truck shed at x = 193 / west), y = 0 town side, track +y, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;

include <../../../_common/rsw_depot.scad>
COL_STONE = "#A89D92";   // granite boulders, gray with pink and tan (ESTIMATE, photos 21, 42, 43)
COL_FOUND = "#8E8980";
COL_ROOF  = "#59635F";   // slate, gray with green patina
COL_TRIM  = "#9A3A2C";   // red brackets and fascia (today)
COL_SASH  = "#5A3A30";
COL_DOOR  = "#4A2E1C";
COL_BRICK = "#7E5A4A";   // Lake Superior brownstone: tablet, coping, sills (uses the "brick" paint)

L_ALL = 193;             // overall
EAVE  = 10;              // eave line
OV    = 6;               // side overhang (ESTIMATE)
OV_END = 3;              // hip-end overhang (elevations show about 2.5-3 ft)
RISE  = 15 / (15 + OV);  // ridge 25 ft
PLATE = EAVE + OV * RISE;

BAG_X = 0;      BAG_L = 40;
MAIN_X = 60;    MAIN_L = 88 + 4 / 12;
SHED_X = MAIN_X + MAIN_L;  SHED_L = L_ALL - SHED_X;   // 44'-6"
GX = 104;       GW = 43;   // cross gable centre and width
G_PLATE = 21.4; G_RISE = (33.6 - 21.4) / (GW / 2 + 0.5);

BLOCKS = [
    [MAIN_X, MAIN_L, 0, 30, PLATE, RISE, 5, OV, 3],          // 0 depot (big roof drawn below)
    [BAG_X,  BAG_L,  0, 30, PLATE, RISE, 5, OV, 3],          // 1 baggage room
    [GX - GW / 2, GW, 0, 30, G_PLATE, G_RISE, 2, 0.5, 3],    // 2 cross gable, ridge across the track
];

W = 3.5; WH = 5; WS = 4.5;      // window w, h, sill: heads about 9.5 ft (track elevation; ESTIMATE)
WINS = [
    // depot, track side
    [141.4, 1, W, WH, WS], [117, 1, 3, WH, WS], [71.3, 1, W, WH, WS],
    // depot, town side (four-light group under the gable)
    [141.4, 0, W, WH, WS], [92, 0, W, WH, WS], [68.2, 0, W, WH, WS],
    for (i = [0 : 3]) [GX - 4.35 + i * 2.9, 0, 2.5, WH, WS],
    // depot end toward the truck shed
    for (y = [9.5, 15, 20.5]) [y, 3, 2.5, 5, 5.5],
    // baggage room
    [32.4, 1, W, WH, WS, 1], [8.6, 1, W, WH, WS, 1], [32.4, 0, W, WH, WS, 1], [8.6, 0, W, WH, WS, 1],
    [15, 2, W, WH, WS, 1],
    // gable windows, both faces
    for (s = [0, 1], i = [0 : 3]) [GX - 4.35 + i * 2.9, s, 2.4, 3.4, 17.6, 2],
];
DOORS = [
    [130.2, 1, 3.5, 7, 0], [80.7, 1, 3.5, 7, 0],
    [130.2, 0, 3.5, 7, 0], [80.7, 0, 3.5, 7, 0],
    [19.9, 1, 6, 8, 1, 1], [20.5, 0, 6, 8, 1, 1],
];

module big_roof() {
    eave = PLATE - OV * RISE;
    paint("roof") roof_solid(-OV_END, L_ALL + 2 * OV_END, -OV, 30 + 2 * OV, eave, RISE, 0);
    paint("trim") fbox(-OV_END, -OV, eave - 0.6, L_ALL + 2 * OV_END, 30 + 2 * OV, 0.6);
}

// ticket office bay (three-sided), kept under the eave
module ticket_bay(x = GX, w = 14, d = 4, top = 10.8) {
    pts = [[-w / 2, 0], [w / 2, 0], [w / 2 - d * 0.7, d], [-w / 2 + d * 0.7, d]];
    paint("stone") translate([ft(x), ft(30), ft(0.5)]) linear_extrude(ft(top - 0.5)) polygon([for (p = pts) [ft(p[0]), ft(p[1])]]);
    paint("glass") translate([ft(x), ft(30 + d) + 0.02, 0]) rotate([90, 0, 180])
        translate([-ft(w - 1.4 * d) / 2 + ft(0.3), ft(WS), 0]) cube([ft(w - 1.4 * d - 0.6), ft(WH - 0.5), ft(0.08)]);
}

// OCONOMOWOC tablet in the track gable (sheet 25), lettering not modelled
module tablet() paint("brick") fbox(GX - 13, 30, 14.9, 26, 0.35, 2.2);

// sandstone parapet coping on both gables, and sills under the attic windows
module coping() paint("brick") {
    x0 = GX - GW / 2; apex = G_PLATE + G_RISE * GW / 2;
    for (y = [-1.2, 30.2]) {                         // parapets stand proud of the gable roof
        for (k = [0, 1]) hull() {                       // rakes
            fbox(k ? x0 + GW - 1.6 : x0, y, G_PLATE + 0.7, 1.6, 1, 0.9);
            fbox(GX - 0.5, y, apex + 0.4, 1, 1, 0.9);
        }
        fbox(x0 - 0.6, y, G_PLATE - 0.3, 2.2, 1, 0.6);  // shoulder caps
        fbox(x0 + GW - 1.6, y, G_PLATE - 0.3, 2.2, 1, 0.6);
        fbox(GX - 6, y < 0 ? 0.9 - 1.6 : 29.4, 16.9, 12, 1.2, 0.5);       // attic window sill
    }
}

// stone chimneys with brownstone caps
module stone_chimneys() for (c = [[GX + 3, 15, 38, 3.2], [30, 15, 30, 2.8]]) {
    paint("stone") fbox(c[0] - c[3] / 2, c[1] - c[3] / 2, 8, c[3], c[3], c[2] - 8.5);
    paint("brick") fbox(c[0] - c[3] / 2 - 0.25, c[1] - c[3] / 2 - 0.25, c[2] - 0.5, c[3] + 0.5, c[3] + 0.5, 0.5);
}

module piers() paint("stone")
    for (x = [L_ALL - 2.5, L_ALL - 24.5 - 1.25], y = [0, 27.5]) fbox(x, y, 0, 2.5, 2.5, EAVE + 0.5);

module oconomowoc() {
    depot(blocks = BLOCKS, wins = WINS, doors = DOORS,
          plat = [-5, L_ALL + 10, 14, 0.5]);
    big_roof();
    ticket_bay();
    coping();
    stone_chimneys();
    tablet();
    piers();
}
oconomowoc();
