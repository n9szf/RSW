// =====================================================================
//  MILWAUKEE ROAD - OCONOMOWOC, WIS. PASSENGER DEPOT (1896)
//  Charles Sumner Frost, architect, 604 Pullman Bldg, Chicago.  Stands today at
//  115 E. Collins St. (Maxim's Restaurant), NRHP 80000206.
//  Sources: MPL station drawings (small copies) "default (22)-(25)":
//   (23) B-2087 ground plan + elevation toward track, (24) B-2086 foundation +
//   elevation toward street, (25) B-2088 end elevation, cross section, tablet,
//   trusses, bracket, (22) 6949-50 later redraw of the plan "from drawings by C.S. Frost".
//  Drawings are private reference: Research Library / RSW / Stations / (to sort).
//  Rib Side Works, 27 Nov 2026 (rev 4: raised fieldstone work on the outside walls, gables and piers).
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
//  FROM TOM'S PHOTOS 27 Nov (44-48): curved red brackets, each on a granite corbel about 6.5 ft up,
//   roughly 11 ft apart on both long sides; painting 45 shows the truck shed OPEN with timber
//   Tudor-arch trusses between stone piers (as sheet 25 "trusses for twenty foot span");
//   aerial (46) confirms the cross gable runs right through the roof.
//  LATER CHANGES NOT MODELLED: truck shed bricked in as a dining room, passage between
//   depot and baggage room closed with wood doors, gray frame enclosure on the track side.
//  ESTIMATE: bay on the track side (photo 42 suggests it), roof overhang 6 ft sides / 3 ft ends,
//   window and door sizes and spacing (small sheets), colours (web photos, no gray card),
//   chimney sizes, pier size 2.5 ft.  Bracket and truss sizes are ESTIMATE (sheet 25 too small to read).
//  x along the track (x = 0 baggage / east end, truck shed at x = 193 / west), y = 0 town side, track +y, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
STONES = true;           // raised fieldstones on the outside (false = plain walls, faster preview)
SEED = 1896;             // change for a different stone layout

include <../../../_common/rsw_depot.scad>
COL_STONE = "#BDB6AA";   // mortar between the stones (wall colour) - ESTIMATE
// Stone shades (photos 21, 42, 43, 48 - ESTIMATE until a gray-card photo). Spare builder paints are
// reused so make_glb.py exports them: "walls" = gray granite, "stucco" = pink granite, "foundation" = buff/rust.
COL_BODY  = "#8E9094";
COL_STUC  = "#B08A7C";
COL_FOUND = "#A8957A";
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
module tablet() {
    paint("brick") fbox(GX - 13, 30, 14.9, 26, 0.35, 2.2);
    paint("brick") translate([ft(GX), ft(30.35), ft(16)]) rotate([90, 0, 180])
        linear_extrude(ft(0.15)) text("-OCONOMOWOC-", size = ft(1.25), halign = "center", valign = "center",
                                       font = "Liberation Sans:style=Bold");
}

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
    paint("walls") fbox(c[0] - c[3] / 2, c[1] - c[3] / 2, 8, c[3], c[3], c[2] - 8.5);   // granite
    paint("brick") fbox(c[0] - c[3] / 2 - 0.25, c[1] - c[3] / 2 - 0.25, c[2] - 0.5, c[3] + 0.5, c[3] + 0.5, 0.5);
}

module piers() paint("stone")
    for (x = [L_ALL - 2.5, L_ALL - 24.5 - 1.25], y = [0, 27.5]) fbox(x, y, 0, 2.5, 2.5, EAVE + 0.5);

// curved bracket on a granite corbel; s = 0 town face (y = 0), 1 track face (y = 30)
module bracket(x, s) {
    y0 = s ? 30 : 0; d = s ? 1 : -1; zc = 5.8; reach = 5.2; rise = 4.1;
    function P(t) = [y0 + d * (reach - reach * cos(t)), zc + rise * sin(t)];
    paint("stone") fbox(x - 0.5, s ? 30 : -0.7, zc - 0.9, 1, 0.7, 0.9);                   // corbel
    paint("trim") {
        fbox(x - 0.25, s ? 30 : -0.5, zc, 0.5, 0.5, PLATE - zc);                          // post on the wall
        fbox(x - 0.25, s ? 30 : -reach - 0.3, zc + rise - 0.1, 0.5, reach + 0.3, 0.55);    // top arm under the eave
        for (t = [0 : 10 : 80]) hull() for (u = [t, t + 10])                              // curved brace
            translate([ft(x - 0.25), ft(P(u)[0] - 0.25), ft(P(u)[1] - 0.25)]) cube([ft(0.5), ft(0.6), ft(0.6)]);
    }
}
module brackets() for (s = [0, 1]) {
    for (i = [0 : 3]) bracket(1.5 + i * 12.3, s);                        // baggage room 0-40
    for (i = [0 : 8]) bracket(MAIN_X + 1.5 + i * 10.6, s);              // depot 60-148
}

// Tudor-arch timber truss panel between two points along x (or y), springing ESTIMATE
module tudor_truss(l, t = 0.7) {
    top = EAVE + 0.3; spring = 5.5; crown = 8.6; b = 1.0;   // beam depth b at the top
    pts = concat([[0, spring - 1.2], [0, top], [l, top], [l, spring - 1.2]],
                 [for (a = [0 : 10 : 90]) [l - 2.2 + 2.2 * cos(a), spring + 1.6 * sin(a)]],
                 [for (k = [0 : 0.25 : 1]) [l - 2.2 - (l / 2 - 2.2) * k, spring + 1.6 + (crown - spring - 1.6) * k * (2 - k)]],
                 [for (k = [0 : 0.25 : 1]) [l / 2 - (l / 2 - 2.2) * k, crown - (crown - spring - 1.6) * k * k]],
                 [for (a = [90 : 10 : 180]) [2.2 + 2.2 * cos(a), spring + 1.6 * sin(a)]]);
    paint("trim") rotate([90, 0, 0]) linear_extrude(ft(t), center = true) polygon([for (p = pts) [ft(p[0]), ft(p[1])]]);
}
module shed_trusses() {
    xs = [SHED_X, L_ALL - 24.5 - 1.25, L_ALL - 1.25];
    for (y = [1.25, 28.75], i = [0, 1]) {           // along both long sides, wall-pier-pier
        x0 = i == 0 ? SHED_X : xs[1] + 1.25; x1 = i == 0 ? xs[1] - 1.25 : L_ALL - 2.5;
        translate([ft(x0), ft(y), 0]) tudor_truss(x1 - x0);
    }
    for (x = [xs[1], L_ALL - 1.25])                   // across the shed at each pair of piers
        translate([ft(x), ft(2.5), 0]) rotate([0, 0, 90]) tudor_truss(25);
}

// ---------------------------------------------------------------- fieldstone work
// Stones are laid in random courses on a face L ft long from z0 to z1 (face coordinates u, z),
// skipping openings (holes [u0, u1, z0, z1]); gable faces are clipped to the roof line.
function _cum(v) = [for (i = 0, a = 0; i <= len(v); a = a + (i < len(v) ? v[i] : 0), i = i + 1) a];
function _hit(u0, u1, a, b, h) = len([for (o = h) if (u1 > o[0] - 0.3 && u0 < o[1] + 0.3 && b > o[2] - 0.3 && a < o[3] + 0.3) 1]) > 0;
function _under(u0, u1, zt, g) = len(g) == 0 ? true :
    let(f = function (u) g[1] - (g[1] - g[0]) * abs(u - g[2]) / g[2]) zt <= f(u0) - 0.2 && zt <= f(u1) - 0.2;
function stone_list(L, z0, z1, holes, sd, g = []) =
    let(hs = rands(1.0, 2.1, 40, sd), zs = [for (z = _cum(hs)) z0 + z])
    [for (k = [0 : 39]) if (zs[k] < z1 - 0.5)
        let(zb = zs[k], zt = min(zs[k + 1], z1), ws = rands(1.3, 3.0, ceil(L / 1.3) + 3, sd + 7 * k + 1),
            sh = rands(0, 1.2, 1, sd + 7 * k + 2)[0], us = [for (u = _cum(ws)) u - sh],
            cs = rands(0, 2.99, len(ws), sd + 7 * k + 3), js = rands(0.28, 0.48, len(ws), sd + 7 * k + 4))
        for (j = [0 : len(ws) - 1]) if (us[j] < L - 0.4)
            let(u0 = max(us[j], 0) + 0.06, u1 = min(us[j + 1], L) - 0.06)
            if (u1 - u0 > 0.5 && zt - zb > 0.5 && !_hit(u0, u1, zb, zt, holes) && _under(u0, u1, zt, g))
                [u0, u1, zb + 0.06, zt - 0.06, floor(cs[j]), js[j]]];
module stone_shapes(st, c, t = 0.12)
    for (q = st) if (q[4] == c) let(w = q[1] - q[0], h = q[3] - q[2], r = min(w, h) * q[5])
        linear_extrude(ft(t)) polygon([for (p = [[q[0] + r, q[2]], [q[1] - r, q[2]], [q[1], q[2] + r], [q[1], q[3] - r],
                                                   [q[1] - r, q[3]], [q[0] + r, q[3]], [q[0], q[3] - r], [q[0], q[2] + r]]) [ft(p[0]), ft(p[1])]]);
// face placement: f = 0 town (y = 0, out -y), 1 track (y = 30, out +y), 2 x-min end (out -x), 3 x-max end (out +x)
module on_wall(f, a, b) {
    if (f == 0) translate([ft(a), ft(b), 0]) rotate([90, 0, 0]) children();
    if (f == 1) translate([ft(a), ft(b), 0]) mirror([0, 1, 0]) rotate([90, 0, 0]) children();
    if (f == 2) translate([ft(b), ft(a), 0]) mirror([1, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) children();
    if (f == 3) translate([ft(b), ft(a), 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) children();
}
module stone_face(f, a, b, L, z0, z1, holes, sd, g = []) {
    st = stone_list(L, z0, z1, holes, sd, g);
    for (c = [0 : 2]) paint(c == 0 ? "walls" : c == 1 ? "stucco" : "foundation") on_wall(f, a, b) stone_shapes(st, c);
}
// openings on a face from WINS / DOORS: side s, block blk, face starting at a
function holes(s, blk, a, b) = concat(
    [for (w = WINS) if (w[1] == s && (len(w) > 5 ? w[5] : 0) == blk && w[0] > a && w[0] < b) [w[0] - w[2] / 2 - a, w[0] + w[2] / 2 - a, w[4], w[4] + w[3]]],
    [for (d = DOORS) if (d[1] == s && d[0] > a && d[0] < b) [d[0] - d[2] / 2 - a, d[0] + d[2] / 2 - a, 0, d[3]]]);
module stonework() if (STONES) {
    ZT = EAVE + 0.4;                                   // stones hidden above the eave line
    x0 = GX - GW / 2; apex = G_PLATE + G_RISE * GW / 2;
    gw = [for (i = [0 : 3]) [GX - 4.35 + i * 2.9 - 1.2 - x0, GX - 4.35 + i * 2.9 + 1.2 - x0, 17.4, 21.2]];
    // depot long sides (bay and its stonework kept clear on the track side)
    stone_face(0, MAIN_X, 0, MAIN_L, 1, ZT, holes(0, 0, MAIN_X, MAIN_X + MAIN_L), SEED);
    stone_face(1, MAIN_X, 30, MAIN_L, 1, ZT, concat(holes(1, 0, MAIN_X, MAIN_X + MAIN_L),
        [[GX - 7.5 - MAIN_X, GX + 7.5 - MAIN_X, 0, 12]]), SEED + 1000);
    // baggage room long sides
    stone_face(0, BAG_X, 0, BAG_L, 1, ZT, holes(0, 1, BAG_X, BAG_X + BAG_L), SEED + 2000);
    stone_face(1, BAG_X, 30, BAG_L, 1, ZT, holes(1, 1, BAG_X, BAG_X + BAG_L), SEED + 3000);
    // ends: baggage east end, both sides of the passage, depot west end (to the shed)
    stone_face(2, 0, BAG_X, 30, 1, ZT, [for (w = WINS) if (w[1] == 2) [w[0] - w[2] / 2, w[0] + w[2] / 2, w[4], w[4] + w[3]]], SEED + 4000);
    stone_face(3, 0, BAG_X + BAG_L, 30, 1, ZT, [], SEED + 5000);
    stone_face(2, 0, MAIN_X, 30, 1, ZT, [], SEED + 6000);
    stone_face(3, 0, MAIN_X + MAIN_L, 30, 1, ZT, [for (w = WINS) if (w[1] == 3) [w[0] - w[2] / 2, w[0] + w[2] / 2, w[4], w[4] + w[3]]], SEED + 7000);
    // the two gables above the roof, clipped to the parapet line
    stone_face(0, x0, 0, GW, PLATE - 0.3, apex, gw, SEED + 8000, [G_PLATE, apex, GW / 2]);
    stone_face(1, x0, 30, GW, PLATE - 0.3, apex, concat(gw, [[0, GW, 14.7, 17.3]]), SEED + 9000, [G_PLATE, apex, GW / 2]);
    // front face of the ticket bay (8.4 ft wide, 4 ft out), around its window
    stone_face(1, GX - 4.2, 34, 8.4, 1, 10.6, [[0.3, 8.1, WS, WS + WH - 0.5]], SEED + 9500);
    // truck shed piers, all four faces
    for (x = [L_ALL - 2.5, L_ALL - 24.5 - 1.25], y = [0, 27.5], f = [0 : 3])
        stone_face(f, f < 2 ? x : y, f == 0 ? y : f == 1 ? y + 2.5 : f == 2 ? x : x + 2.5, 2.5, 1, EAVE, [],
                   SEED + 10000 + 97 * x + 13 * y + f);
}

module oconomowoc() {
    depot(blocks = BLOCKS, wins = WINS, doors = DOORS,
          plat = [-5, L_ALL + 10, 14, 0.5]);
    big_roof();
    ticket_bay();
    coping();
    stone_chimneys();
    tablet();
    piers();
    stonework();
    brackets();
    shed_trusses();
}
oconomowoc();
