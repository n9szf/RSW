// =====================================================================
//  MILWAUKEE ROAD - SPARTA, WIS. PASSENGER STATION
//  Source: Album sheet 112, built 1916 (drawn Chicago, July 14 1919).  Drawings are private
//  reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
//  Rib Side Works, 27 Nov 2026. HAND-BUILT FIRST SHAPE MODEL for review - not cut into print sections.
//  Do not let the generator (make_depots.py) overwrite this file.
//
//  KNOWN (from the sheet): 127 ft 8 in overall.  Station 57 ft 8 x 27 ft 10: smoking room
//  17-6 x 26-6, passage with men's and women's toilets, ticket office 15-0 x 16-0 with a 12 ft
//  track-side bay, general waiting room 21-6 x 26-6.  Wing 70 ft long x 22 ft (2 ft 11 in in from
//  each side of the station): coal + boiler room 10 ft, open pavilion 16 ft, baggage room 20-8 x 21-0
//  and express room 20-8 x 21-2 (44 ft).  Track-side bays 22 / 12 / 23-8.  Gable roof of wood
//  shingles over the station with a shed dormer (ribbon windows) over the ticket bay and a ridge
//  ventilator; two chimneys on the ridge; low tar-and-gravel roof on the wing.  Lap siding over
//  V-ceiling wainscot, bracketed eaves, double doors to baggage and express rooms.
//
//  ESTIMATE (scaled off the 1/16 in elevations, or guessed): eave 13.5 ft and ridge 24 ft, wing eave
//  12.5 ft, roof overhangs, window and door sizes, all town-side and end openings (the sheet shows the
//  track side and one end only), dormer depth, platform.
//  COLOURS (27 Nov 2026): from Tom's colour photo (about 1970s, track side and west gable; blue cast
//  of the old slide corrected by eye): pale gray lap siding, light gray-white trim and corner boards,
//  darker gray V-ceiling wainscot, green asphalt-shingle roof, red brick chimney.  The 1916 roof was
//  wood shingles, so the green roof is the later look.
//  STATUS: stood into the 1970s at least (photo); the surviving 704 Milwaukee St building is a
//  freight house, and the station looks gone today (27 Nov 2026).  Shape kept to the 1916 sheet.
//
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the track,
//  y = 0 town side, track side +y, feet).  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
COL_WAIN  = "#7B8183";   // darker gray V-ceiling wainscot
include <../../../_common/rsw_depot.scad>
// colours from the photo (station values win over the builder's)
COL_BODY  = "#C3C5BD";   // pale gray siding
COL_TRIM  = "#DCDDD4";   // light trim, corner boards, frames
COL_ROOF  = "#4E6852";   // green asphalt shingles
COL_DOOR  = "#6A6F6D";   // gray doors
COL_SASH  = "#DCDDD4";
PAINTS = [["walls", COL_BODY], ["wainscot", COL_WAIN], ["trim", COL_TRIM], ["roof", COL_ROOF], ["glass", COL_GLASS],
          ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH],
          // inside (ESTIMATE): varnished V-ceiling, plaster, maple floor, oak, iron, brass, porcelain, slate
          ["v_ceiling", "#9A6A3C"], ["plaster", "#E6DCC4"], ["floor", "#B88E5E"], ["oak", "#7E5230"],
          ["iron", "#2B2B2B"], ["brass", "#B8923A"], ["tile", "#ECEBE4"], ["board", "#1C1C1C"]];
FLOOR = 1.2;    // ESTIMATE: low floor, belt under the sills (about 3.8 ft above grade)
WAIN  = 2.6;

INTERIOR = true;    // rooms and fittings from the floor plan (fittings ESTIMATE)
CUTAWAY  = false;   // true: leave off the roofs, dormer and ceilings to look inside

L  = 57.67;  W  = 27.83;          // station block
WY = 2.92;   WW = 22;             // wing, set in 2 ft 11 in each side

WINS = [// track side, station
                [5.4, 1, 3.3, 7, 3.9], [15.4, 1, 3.3, 7, 3.9], [41.5, 1, 3.3, 7, 3.9], [51.8, 1, 3.3, 7, 3.9],
                // dormer ribbon (small - large - small)
                [24.8, 1, 2.2, 2.3, 14.6], [28, 1, 3.7, 2.3, 14.6], [31.2, 1, 2.2, 2.3, 14.6],
                // town side, station (ESTIMATE): smoking room, toilets (small, high), waiting room
                [9.7, 0, 3.3, 7, 3.9], [21, 0, 2, 2.5, 7.5], [30, 0, 2, 2.5, 7.5], [51.3, 0, 3.3, 7, 3.9],
                // smoking room end (x-min), from the plan
                [7.8, 2, 3.3, 7, 3.9], [19.1, 2, 3.3, 7, 3.9],
                // baggage room high window, express room end window (from the end elevation)
                [87.4, 1, 5.5, 2.4, 8.5, 2], [WY + WW / 2, 3, 6, 2.6, 8.3, 2]];
DOORS = [[10.3, 1, 3, 7.5, 0], [46.6, 1, 3, 7.5, 0], [45.7, 0, 3, 7.5, 0],
                [60.6, 1, 2.8, 7, 0, 1],                                            // boiler room
                [95.4, 1, 6, 8, 1, 2], [116.9, 1, 6, 8, 1, 2],                       // baggage, express (track)
                [96.3, 0, 6, 8, 1, 2], [112.4, 0, 6, 8, 1, 2]];                      // town side (ESTIMATE)
RK = CUTAWAY ? 5 : 1;              // roof kind: 5 = none (cutaway)
BLOCKS = [[0, L, 0, W, 15.4, 0.63, RK, 3, 0],                 // 0 station, gable along the track
          [L, 10, WY, WW, 12.5, 0.12, RK, 2, 0],               // 1 coal and boiler room
          [L + 26, 44, WY, WW, 12.5, 0.12, RK, 2, 0]];         // 2 baggage and express

// Eave brackets: the shared builder's (fixed 27 Nov 2026 to hang under the soffit).

// ---- wood siding (27 Nov 2026) --------------------------------------------------------
// Lap siding above the belt, V-ceiling (vertical beaded boards) below it, as on the sheet.
// One shaped piece per wall face, with the windows and doors cut out.  SIDING = false for plain walls.
// ESTIMATE: 4 1/2 in exposure, 3 1/2 in V-ceiling boards (standard for the period).
SIDING   = true;
LAP_EXP  = 0.375;   // ft, lap siding exposure (4 1/2 in)
LAP_T    = 0.06;    // ft, how far each course stands out at its butt
VB_W     = 0.29;    // ft, V-ceiling board width (3 1/2 in)
VB_T     = 0.05;    // ft, V-ceiling relief
K = 304.8 / SCALE;  // feet -> mm inside a face

function blk_of(o) = o[5] == undef ? 0 : o[5];
// u = position along the face, measured from the face centre the way on_face() draws it
function u_of(side, c, x) = (side == 0 || side == 3) ? x - c : c - x;

module lap_profile(len, z0, z1) {          // sawtooth courses, extruded along the face
    n = floor((z1 - z0) / LAP_EXP);
    pts = concat([[0.02, z0]], [for (i = [0 : n - 1]) each [[-LAP_T, z0 + i * LAP_EXP], [0, z0 + (i + 1) * LAP_EXP]]],
                 [[-LAP_T, z0 + n * LAP_EXP], [0, z1], [0.02, z1]]);
    translate([-len / 2, 0, 0]) rotate([0, 90, 0]) linear_extrude(len) polygon(pts);
}
module vceil_profile(len, z0, z1) {        // vertical boards with V joints
    n = floor(len / VB_W);
    pts = concat([[-len / 2, 0.02], [-len / 2, -VB_T]],
                 [for (j = [1 : n - 1]) let (u = -len / 2 + j * VB_W) each [[u - 0.04, -VB_T], [u, -VB_T + 0.035], [u + 0.04, -VB_T]]],
                 [[len / 2, -VB_T], [len / 2, 0.02]]);
    translate([0, z0, 0]) rotate([-90, 0, 0]) linear_extrude(z1 - z0) polygon(pts);
}
module face_outline(len, z0, plate, rise, depth = 1) {   // wall outline, with the gable when rise > 0
    translate([0, 0, -depth / 2]) linear_extrude(depth)
        polygon(rise > 0 ? [[-len / 2, z0], [len / 2, z0], [len / 2, plate], [0, plate + rise * len / 2], [-len / 2, plate]]
                         : [[-len / 2, z0], [len / 2, z0], [len / 2, plate], [-len / 2, plate]]);
}
module face_cuts(bi, side, c, doors_only = false) {
    if (!doors_only) for (o = WINS) if (o[1] == side && blk_of(o) == bi)
        translate([u_of(side, c, o[0]) - (o[2] + 0.7) / 2, o[4] - 0.4, -1]) cube([o[2] + 0.7, o[3] + 0.95, 2]);
    for (o = DOORS) if (o[1] == side && blk_of(o) == bi)
        translate([u_of(side, c, o[0]) - (o[2] + 0.8) / 2, 0, -1]) cube([o[2] + 0.8, FLOOR + o[3] + 1.75, 2]);
    if (bi == 0 && side == 1) translate([u_of(1, c, 28) - 6, 0, -1]) cube([12, 20, 2]);   // ticket bay
}
module sided_block(bi) {
    B = BLOCKS[bi]; x0 = B[0]; l = B[1]; y0 = B[2]; w = B[3]; plate = B[4]; rise = B[5];
    belt = FLOOR + WAIN - 0.2;
    for (side = [0 : 3]) {
        c   = side < 2 ? x0 + l / 2 : y0 + w / 2;
        len = side < 2 ? l : w;
        gr  = (side >= 2 && !CUTAWAY) ? rise : 0;                       // gables are on the ends (ridge along the track)
        on_face(B, c, side) scale(K) {
            paint("walls") difference() {
                intersection() { lap_profile(len, belt + 0.35, plate + gr * len / 2); face_outline(len, belt + 0.35, plate, gr); }
                face_cuts(bi, side, c);
            }
            paint("wainscot") difference() { vceil_profile(len, 0.9, belt); face_cuts(bi, side, c, true); }
        }
    }
}
// ---- shed dormer over the ticket bay (front flush with the track wall) ----
DX0 = 20.9; DL = 14.3;
module dormer_etc() {
wall_paint(0) fbox(DX0, W / 2, 13, DL, W / 2, 5);
paint("trim") fbox(DX0 - 0.15, W - 0.15, 13, DL + 0.3, 0.35, 0.4);
if (SIDING) on_face([DX0, DL, W / 2, W / 2], DX0 + DL / 2, 1) scale(K) paint("walls") difference() {
    intersection() { lap_profile(DL, 13.4, 17.6); face_outline(DL, 13.4, 17.6, 0); }
    translate([-DL / 2 + 2.6, 14.2, -1]) cube([DL - 5.2, 3.3, 2]);          // ribbon windows
}
paint("roof") hull() {
    fbox(DX0 - 0.6, W + 1.5, 17.6, DL + 1.2, 0.1, 0.5);       // front eave
    fbox(DX0 - 0.6, W / 2, 23.6, DL + 1.2, 0.1, 0.5);          // meets the main roof at the ridge
}
paint("trim") fbox(DX0 - 0.6, W + 1.4, 17.1, DL + 1.2, 0.2, 0.6);
// cap on the ticket bay, under the dormer windows
paint("roof") fbox(21.6, W, 14.3, 12.8, 3.6, 0.4);
}   // dormer_etc
// ---- SPARTA name board in the west gable (photo and D S Peterson's model) ----
module name_board() on_face(BLOCKS[0], W / 2, 2) scale(K) {
    paint("trim")  translate([-3.2, 17.6, 0]) cube([6.4, 1.3, 0.12]);
    paint("doors") translate([0, 17.95, 0.12]) linear_extrude(0.05)
        text("SPARTA", size = 0.62, font = "Liberation Sans:style=Bold", halign = "center");
}
// ---- ridge ventilator ----
module ventilator() paint("trim") { fbox(36.4, W / 2 - 0.8, 23.5, 1.6, 1.6, 2.6); fbox(36.0, W / 2 - 1.2, 26.1, 2.4, 2.4, 0.4); }


// =====================================================================
//  THE OUTSIDE
// =====================================================================
module shell() {
    depot(blocks = BLOCKS,
          pavs   = [[L + 10, 16, WY, WW, 12.5, 0.12, CUTAWAY ? 5 : 1, 2, 2, 2]],   // open pavilion
          wins   = WINS,
          doors  = DOORS,
          bays   = [[BAYX, 1, BAYW, BAYD]],
          chims  = CUTAWAY ? [] : [[19.7, W / 2, 30], [57.2, W / 2, 30]],      // on the ridge; flues inside (plan)
          plat   = [-5, 138, 12, 0.8]);
    if (SIDING) for (bi = [0 : len(BLOCKS) - 1]) sided_block(bi);
    if (!CUTAWAY) { dormer_etc(); ventilator(); }
    name_board();
}
BAYX = 28;  BAYW = 12;  BAYD = 3;    // operator's bay of the ticket office (plan)

// =====================================================================
//  INSIDE (27 Nov 2026) - room plan from sheet 112; finishes and fittings ESTIMATE
//  The plan has no partition between the smoking room, the passage and the general waiting
//  room: one long room, with the ticket office (15 x 16) and its operator's bay on the track
//  side and the men's and women's toilets on the town side.  Ticket window and counter in the
//  office's passage wall; flue in the office's west wall; the boiler room (steam heat) flue in
//  the wall between the boiler room and the waiting room.  Benches as drawn: wall bench and a
//  double bench in the smoking room, two double benches in the waiting room.
//  ESTIMATE: ceiling 11.8 ft (wing 10.6), varnished V-ceiling wainscot to 4 ft with plaster
//  above, V-ceiling ceilings, maple floors; steam radiators; electric pendant lights; the
//  ticket office ceiling raised into the dormer as a light well (the ribbon windows light it);
//  baggage and express fittings.
// =====================================================================
TW = 0.5;  PW = 0.5;                      // outside walls and partitions (frame)
RC = FLOOR + 11.8;                        // main ceiling, above grade
WC = FLOOR + 10.6;                        // wing ceiling
XO0 = 18.0;  XO1 = 35.9;                  // ticket office and toilet block, outside faces (plan)
YT  = 6.1;                                // toilet block, passage face
YO  = 12.4;                               // ticket office, passage face
XMW = 26.7;                               // wall between men and women
XP  = 105.0;                              // baggage | express partition
YB  = 11.0;                               // coal room | boiler room partition
// rooms [x0, x1, y0, y1, floor, ceiling]
ROOMS = [[TW, L - TW, TW, W - TW, FLOOR, RC],                                          // 0 smoking room + passage + waiting room
         [XO0 + PW, XMW - PW / 2, TW, YT - PW, FLOOR, RC],                            // 1 men
         [XMW + PW / 2, XO1 - PW, TW, YT - PW, FLOOR, RC],                            // 2 women
         [XO0 + PW, XO1 - PW, YO + PW, W - TW, FLOOR, RC],                            // 3 ticket office
         [L + TW, L + 10 - TW, WY + TW, YB - PW / 2, FLOOR, WC],                       // 4 coal room
         [L + TW, L + 10 - TW, YB + PW / 2, WY + WW - TW, FLOOR, WC],                  // 5 boiler room
         [L + 26 + TW, XP - PW / 2, WY + TW, WY + WW - TW, FLOOR, WC],                 // 6 baggage room
         [XP + PW / 2, L + 70 - TW, WY + TW, WY + WW - TW, FLOOR, WC]];                // 7 express room
WELL = [DX0 + 0.5, DX0 + DL - 0.5, W / 2 + 0.5, W - TW, RC - 0.2, 17.4];           // light well into the dormer
// openings between rooms [x0, x1, y0, y1, z0, z1]
INNER = [[XO0 + 1.0, XO0 + 3.4, YT - PW - 0.1, YT + 0.1, FLOOR, FLOOR + 7],         // men's door
         [XO1 - 3.4, XO1 - 1.0, YT - PW - 0.1, YT + 0.1, FLOOR, FLOOR + 7],         // women's door
         [30.9, 33.6, YO - 0.1, YO + PW + 0.1, FLOOR, FLOOR + 7],                   // ticket office door
         [21.0, 28.0, YO - 0.1, YO + PW + 0.1, FLOOR + 3.4, FLOOR + 6.0],           // ticket window
         [64.3, 66.6, YB - PW / 2 - 0.1, YB + PW / 2 + 0.1, FLOOR, FLOOR + 7],      // coal room - boiler room
         [XP - PW / 2 - 0.1, XP + PW / 2 + 0.1, 12.0, 16.0, FLOOR, FLOOR + 7.5]];   // baggage - express
// partitions [x0, x1, y0, y1] (the shell is hollowed, these are put back)
PARTS = [[XO0, XO1, YT - PW, YT], [XO0, XO0 + PW, TW, YT], [XO1 - PW, XO1, TW, YT], [XMW - PW / 2, XMW + PW / 2, TW, YT - PW],
         [XO0, XO1, YO, YO + PW], [XO0, XO0 + PW, YO, W - TW], [XO1 - PW, XO1, YO, W - TW]];

module rbox(r, g = 0) translate([ft(r[0] - g), ft(r[2] - g), ft(r[4])]) cube([ft(r[1] - r[0] + 2 * g), ft(r[3] - r[2] + 2 * g), ft(r[5] - r[4])]);
module bay_poly(g) { d = BAYD - g; w = BAYW - 2 * g;
    polygon([[ft(BAYX - w / 2), ft(W - 1)], [ft(BAYX + w / 2), ft(W - 1)], [ft(BAYX + w / 2), ft(W)], [ft(BAYX + w / 2 - d * 0.7), ft(W + d)],
             [ft(BAYX - w / 2 + d * 0.7), ft(W + d)], [ft(BAYX - w / 2), ft(W)]]); }
module room_voids() {
    for (r = ROOMS) rbox(CUTAWAY ? [r[0], r[1], r[2], r[3], r[4], 30] : r);
    if (!CUTAWAY) rbox(WELL);
    translate([0, 0, ft(FLOOR)]) linear_extrude(ft((CUTAWAY ? 30 : RC) - FLOOR)) bay_poly(0.45);
}
module cut_box(w, z0, h) translate([-ft(w / 2), ft(z0), -ft(1.0)]) cube([ft(w), ft(h), ft(1.02)]);
module all_cuts() {
    for (o = WINS)  on_face(BLOCKS[blk_of(o)], o[0], o[1]) cut_box(o[2], o[4], o[3]);
    for (o = DOORS) on_face(BLOCKS[blk_of(o)], o[0], o[1]) cut_box(o[2], FLOOR, o[3] + (o[4] == 2 ? 0 : 1.3));
    for (c = INNER) rbox(c);
    translate([0, 0, ft(FLOOR + 2.8)]) linear_extrude(ft(5.5)) intersection() {                       // bay front window
        bay_poly(-0.5); translate([ft(BAYX - BAYW / 2 + 2.4), ft(W + BAYD - 1)]) square([ft(BAYW - 4.8), ft(2)]); }
}
// ---- finishes ----
WAIN_IN = 4.0;                                                // inside wainscot height
module shell_of(r, z0, z1) difference() { rbox([r[0], r[1], r[2], r[3], z0, z1]); rbox([r[0], r[1], r[2], r[3], z0 - 1, z1 + 1], -0.06); }
module lining(r) {
    difference() {
        union() {
            paint("v_ceiling") shell_of(r, r[4], r[4] + WAIN_IN);
            paint("plaster")   shell_of(r, r[4] + WAIN_IN, r[5]);
            paint("v_ceiling") difference() { rbox([r[0], r[1], r[2], r[3], r[4] + WAIN_IN, r[4] + WAIN_IN + 0.3]); rbox(r, -0.14); }   // cap rail
        }
        color("#E6DCC4") all_cuts();
    }
    paint("floor") rbox([r[0], r[1], r[2], r[3], r[4], r[4] + 0.05]);
    if (!CUTAWAY) paint("v_ceiling") rbox([r[0], r[1], r[2], r[3], r[5] - 0.06, r[5]]);
}
module partitions() difference() {
    union() for (p = PARTS) {
        paint("plaster") rbox([p[0], p[1], p[2], p[3], FLOOR, RC]);
        paint("v_ceiling") rbox([p[0], p[1], p[2], p[3], FLOOR, FLOOR + WAIN_IN], 0.04);
    }
    color("#E6DCC4") all_cuts();
}
// ---- fittings ----
module bench(x0, len, y, s) paint("oak") translate([ft(x0), ft(y), ft(FLOOR)]) mirror([0, s > 0 ? 0 : 1, 0]) {
    for (x = [0, len - 0.2]) cube([ft(0.2), ft(1.6), ft(1.5)]);
    translate([0, 0, ft(1.4)]) cube([ft(len), ft(1.6), ft(0.12)]);
    cube([ft(len), ft(0.12), ft(3.0)]);
    translate([0, ft(1.45), ft(0.25)]) cube([ft(len), ft(0.1), ft(1.1)]);
}
// bench running along y (as drawn on the plan): back at x, seat towards +x (s = 1) or -x
module bench_y(y0, len, x, s) translate([ft(x), ft(y0), 0]) rotate([0, 0, 90]) bench(0, len, 0, -s);
module double_bench_y(y0, len, xc) { bench_y(y0, len, xc + 0.08, 1); bench_y(y0, len, xc - 0.08, -1); }
module radiator(x, y, a, len = 3.5) translate([ft(x), ft(y), ft(FLOOR)]) rotate([0, 0, a]) paint("iron")
    for (i = [0 : floor(len / 0.25)]) translate([ft(i * 0.25 - len / 2), 0, ft(0.25)]) cube([ft(0.16), ft(0.7), ft(2.3)]);
module pendant(x, y, top, drop = 3) {
    paint("brass") translate([ft(x), ft(y), ft(top - drop)]) cylinder(r = ft(0.04), h = ft(drop), $fn = 8);
    paint("tile")  translate([ft(x), ft(y), ft(top - drop - 0.5)]) cylinder(r1 = ft(0.75), r2 = ft(0.15), h = ft(0.5), $fn = 24);
}
module wall_clock(x, y, z, a) translate([ft(x), ft(y), ft(z)]) rotate([0, 0, a]) {
    paint("oak") rotate([0, 90, 0]) cylinder(r = ft(0.95), h = ft(0.25), $fn = 32);
    paint("tile") translate([ft(0.25), 0, 0]) rotate([0, 90, 0]) cylinder(r = ft(0.8), h = ft(0.04), $fn = 32);
}
module spittoon(x, y) paint("brass") translate([ft(x), ft(y), ft(FLOOR)]) cylinder(r1 = ft(0.45), r2 = ft(0.3), h = ft(0.8), $fn = 20);
module flue(x0, y0, dx, dy, top) paint("plaster") fbox(x0, y0, FLOOR, dx, dy, top - FLOOR);

module big_room() {
    // smoking room: bench along the west wall and a double bench (plan)
    bench_y(1.0, 25.8, TW, 1);
    double_bench_y(4.3, 18.3, 9.0);
    // general waiting room: two double benches (plan)
    double_bench_y(11.3, 12.6, 41.3);
    double_bench_y(3.0, 20.3, 51.3);
    // radiators under the windows (steam from the boiler room)
    for (y = [7.8, 19.1]) radiator(TW + 1.9, y, 90, 3);
    for (x = [4.6, 15.4, 41.5, 51.8]) radiator(x, W - TW - 0.8, 0);
    for (x = [9.6, 51.3]) radiator(x, TW + 0.1, 0);
    flue(L - TW - 0.8, W / 2 - 0.8, 0.8, 1.6, RC);                                    // boiler flue (plan)
    paint("board") fbox(L - TW - 0.1, 4.0, FLOOR + 4.5, 0.1, 3.0, 3.8);             // train board
    wall_clock(L - TW - 0.25, 20.5, FLOOR + 9, 180);
    for (x = [8, 27, 46]) pendant(x, W / 2 - 1, RC);
    spittoon(5, 3);  spittoon(14, 25);  spittoon(37.5, 3);  spittoon(56, 25);
}
module toilets() {
    paint("oak") { fbox(XO0 + 3.6, TW, FLOOR, 0.1, 3.2, 6.5); fbox(XO1 - 3.7, TW, FLOOR, 0.1, 3.2, 6.5); }     // closet stalls
    paint("tile") {
        fbox(XO0 + 4.8, TW, FLOOR, 1.0, 1.5, 1.4);  fbox(XO0 + 4.8, TW, FLOOR + 1.4, 1.0, 0.4, 2.3);   // men: closet and tank
        fbox(XMW - PW / 2 - 0.7, TW + 0.3, FLOOR, 0.6, 1.1, 4.2);                                     // urinal
        fbox(XO1 - 6.2, TW, FLOOR, 1.0, 1.5, 1.4);  fbox(XO1 - 6.2, TW, FLOOR + 1.4, 1.0, 0.4, 2.3);   // women: closet and tank
        fbox(XO0 + 1.0, TW, FLOOR + 2.5, 1.4, 1.0, 0.35);  fbox(XO1 - 2.4, TW, FLOOR + 2.5, 1.4, 1.0, 0.35);   // basins
    }
    pendant(22.5, 3, RC, 2);  pendant(31, 3, RC, 2);
}
module ticket_office() {
    paint("oak") {
        fbox(20.5, YO - 1.6, FLOOR + 3.3, 8, 1.6, 0.15);                         // counter in the passage (plan)
        fbox(20.5, YO - 1.5, FLOOR, 8, 0.12, 3.3);
        fbox(20.5, YO + PW, FLOOR, 8, 2.0, 3.2); fbox(20.5, YO + PW, FLOOR + 3.2, 8, 2.2, 0.15);   // agent's counter inside
        fbox(XO0 + PW, 20.0, FLOOR, 1.6, 4.5, 6.5);                              // ticket case
        fbox(BAYX - 4, W - TW - 0.2, FLOOR + 2.5, 8, 2.6, 0.15);                  // operator's table in the bay
        for (x = [BAYX - 3.8, BAYX + 3.6]) fbox(x, W - TW + 0.1, FLOOR, 0.2, 0.2, 2.5);
        fbox(BAYX - 0.7, W - TW - 2.2, FLOOR, 1.4, 1.4, 1.5); fbox(BAYX - 0.7, W - TW - 2.35, FLOOR + 1.5, 1.4, 0.15, 1.4);   // chair
        fbox(XO1 - PW - 3.0, 14.5, FLOOR, 3.0, 5.0, 2.5);                         // agent's desk
    }
    paint("iron") fbox(XO1 - PW - 2.4, 21.5, FLOOR, 2.2, 2.0, 3.4);              // safe
    paint("brass") { fbox(BAYX - 2.0, W - TW + 0.8, FLOOR + 2.65, 0.6, 0.4, 0.35); fbox(BAYX + 1.0, W - TW + 0.6, FLOOR + 2.65, 0.5, 0.3, 0.15); }   // sounder, key
    translate([ft(21.0), ft(YO + PW / 2), ft(FLOOR + 3.45)]) paint("brass")
        for (k = [0 : 28]) translate([ft(k * 0.25), 0, 0]) cube([ft(0.04), ft(0.04), ft(2.5)]);   // ticket grille
    flue(XO0 + PW, 15.2, 2.0, 2.0, RC);                                            // office flue (plan)
    radiator(XO1 - PW - 0.8, 18.0, 90, 3);
    pendant(26, 18, CUTAWAY ? RC : 17.4, 4.5);
    wall_clock(XO1 - PW - 0.25, 15.5, FLOOR + 8.5, 180);
}
module wing() {
    // boiler room: steam boiler (plan) and its pipe to the flue
    paint("iron") {
        translate([ft(L + 4.6), ft(16.5), ft(FLOOR)]) cylinder(r = ft(1.9), h = ft(5.5), $fn = 36);
        translate([ft(L + 4.6), ft(16.5), ft(FLOOR + 5.5)]) cylinder(r1 = ft(1.9), r2 = ft(0.4), h = ft(1), $fn = 36);
        hull() { translate([ft(L + 4.6), ft(16.5), ft(FLOOR + 6.8)]) sphere(r = ft(0.4), $fn = 12);
                 translate([ft(L + TW), ft(W / 2), ft(FLOOR + 7.5)]) sphere(r = ft(0.4), $fn = 12); }
        translate([ft(L + 4.6), ft(16.5), ft(FLOOR + 6.4)]) cylinder(r = ft(0.4), h = ft(0.6), $fn = 12);
    }
    // coal room: a coal pile
    paint("board") hull() { fbox(L + TW + 0.3, WY + TW + 0.3, FLOOR, 7, 6.5, 0.1); fbox(L + 2.5, WY + 2.2, FLOOR + 2.8, 2.5, 2, 0.1); }
    // baggage room: trucks and the platform scale
    for (c = [[L + 29, 6.0], [L + 29, 17.0]]) {
        paint("oak") fbox(c[0], c[1], FLOOR + 1.6, 10, 3.4, 0.25);
        paint("iron") for (x = [c[0] + 1.3, c[0] + 8.7], y = [c[1] - 0.05, c[1] + 3.3])
            translate([ft(x), ft(y), ft(FLOOR + 0.8)]) rotate([90, 0, 0]) cylinder(r = ft(0.8), h = ft(0.15), center = true, $fn = 20);
    }
    paint("oak") { fbox(L + 30, 7.0, FLOOR + 1.85, 3, 2, 1.8); fbox(L + 34, 18, FLOOR + 1.85, 2.5, 1.6, 1.2); }   // trunks
    paint("iron") { fbox(XP - 8.5, WY + TW + 0.3, FLOOR, 6.6, 5.0, 0.12); fbox(XP - 2.0, WY + TW + 0.5, FLOOR, 0.6, 0.6, 4.2);
                    fbox(XP - 1.9, WY + TW + 0.5, FLOOR + 4.2, 0.2, 3.2, 0.15); }                                    // scale
    // express room: counter, shelves, safe
    paint("oak") { fbox(XP + 3, 9.0, FLOOR, 12, 2.2, 3.4); fbox(XP + 2.8, 8.9, FLOOR + 3.4, 12.4, 2.4, 0.12);
                   for (z = [FLOOR + 0.5 : 1.8 : FLOOR + 7]) fbox(L + 70 - TW - 1.4, WY + TW + 2, z, 1.4, 14, 0.1);
                   fbox(L + 70 - TW - 1.4, WY + TW + 2, FLOOR, 1.4, 0.1, 7); fbox(L + 70 - TW - 1.4, WY + TW + 16, FLOOR, 1.4, 0.1, 7); }
    paint("iron") fbox(XP + 1, WY + WW - TW - 2.4, FLOOR, 2.2, 2.0, 3.0);
    for (x = [L + 5, L + 36, L + 48, L + 59]) pendant(x, WY + WW / 2, WC, 2.5);
}
module interior() {
    for (r = ROOMS) lining(r);
    partitions();
    if (!CUTAWAY) {                                                            // light well lining (plaster)
        paint("plaster") difference() { rbox(WELL); rbox([WELL[0], WELL[1], WELL[2], WELL[3], WELL[4] - 1, WELL[5] - 0.06], -0.06); all_cuts(); }
    }
    paint("floor") translate([0, 0, ft(FLOOR)]) linear_extrude(ft(0.05)) bay_poly(0.45);
    paint("glass") fbox(BAYX - BAYW / 2 + 2.4, W + BAYD - 0.12, FLOOR + 2.8, BAYW - 4.8, 0.06, 5.5);   // bay front glass (put back after the cut)
    big_room();  toilets();  ticket_office();  wing();
}

// =====================================================================
if (INTERIOR) {
    difference() { shell(); color(COL_BODY) { room_voids(); all_cuts(); } }
    interior();
} else shell();
