// =====================================================================
//  MILWAUKEE ROAD - LA CROSSE, WIS. PASSENGER STATION, BREEZEWAY AND
//  BAGGAGE & EXPRESS BUILDING  (601 St. Andrew St, North La Crosse)
//  Source: Album sheet 119 (passenger station, drawing B-3..., June 21 1926) and
//  sheet 120 (baggage and express building, B-3191, June 21 1926).  Drawings are
//  private reference (in copyright): Research Library / RSW / Stations / Standard
//  depots / Album of Depot Plans 1919.  Colours and materials: NRHP nomination
//  97001512 (1997).  Architect A. O. Lagerstrom; opened 31 Jan 1927.  STANDS (Amtrak).
//  Rev 3 (26 Nov): roll-up doors on the baggage building, canopy switches (1927 plan /
//  1974 photo / 2001 today), waiting-room interior (INTERIOR) and a CUTAWAY switch.
//  Rib Side Works, 26 Nov 2026.  HAND-BUILT (not made by the generator).  Rev 2 (26 Nov):
//  heights and colours checked against photos 01-08 in reference / Station photos web /
//  La Crosse (1974 overhead, 2025 track side + west end, 2026 town side straight on).
//  FIRST SHAPE MODEL for review - not cut into print sections.
//  Era modelled: 1927 as built (red clay tile roof, open breezeway, entrance
//  awning and track-side canopy, all later lost or changed).
//
//  KNOWN (from the sheets, scaled - both 1/16 in = 1 ft):
//   station about 104 x 33.4 ft, 2 storeys, 7 bays, centre entrance on the town
//   (south) side; ticket office 13'10 x 18'0 in a bay about 17 x 6 ft on the track
//   side; general waiting 31'6 x 46'0, smoking 14'0 x 14'1, women's 14'0 x 19'1,
//   lunch 20'1 x 25'7, kitchen 11'10 x 25'7 (lunch and kitchen at the east end).
//   Eave about 33 ft, ridge about 46 ft, eave overhang about 4.5 ft (sheet heights
//   scaled at the horizontal scale - agrees with the 2026 straight-on photo), tall
//   limestone base with a stone band at the 1st floor sills, dark brick quoins, recessed
//   brick panels between the floors, white soffit and downspouts.
//   baggage & express about 115 x 37.2 ft, east of the station: check room 7'8 x 23,
//   baggage 28'6 x 35'7, express office 19'6 x 26'6, express room 35'7 x 54'9;
//   eave about 15.5 ft, ridge about 28 ft; rolling doors both sides.
//   NRHP: brown brick, dark brown quoins and panels, Bedford (Indiana) limestone
//   base, water table and sills, red clay tile hipped roofs; tracks on the NORTH.
//  ESTIMATE: breezeway length (24 ft) and height, how the two buildings line up
//   (track faces in line), track-side window and door layout on the second floor,
//   end-wall openings, window sash colour (cream), all colour shades, floor height,
//   canopy and awning heights, platform.  The separate five-car-length train canopy
//   (NRHP) is not on the album sheets and is not modelled.
//  Built with the shared depot builder ../../../_common/rsw_depot.scad (x along the
//  track, west to east; y = 0 town side, track side +y; feet).  SCALE: 29 G, 48 O, 87 HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>

// COLOURS from photos 03 (1974), 04 (2025) and 05 (2026), shades averaged between sun
// and shade.  Quoins are drawn with the "doors" paint (dark brown) because the builder's
// "trim" paint is the white soffit/fascia here.
COL_BRICK = "#9A5538";   // orange-brown brick
COL_DOOR  = "#5E3526";   // dark brown brick quoins (and doors)
COL_TRIM  = "#EAE5D8";   // white soffit, fascia, downspouts, door surrounds
COL_STONE = "#CFC5B2";   // Bedford limestone
COL_FOUND = "#CFC5B2";
COL_ROOF  = "#B8503A";   // red clay tile (1927; baggage roof still red in 1974); station re-roofed dark gray by 1974, red asphalt now
COL_SASH  = "#E4E1D8";   // white/pale sash as in 1974 (ESTIMATE for 1927; stained red-brown today)
COL_PLAT  = "#8A867E";   // ESTIMATE concrete platform
FLOOR = 2.5;             // ESTIMATE floor above grade (steps at the doors)
COL_STUC  = "#E8DDBF";   // interior plaster, cream (photo 06)

// ---- switches (Rev 3) ----
CANOPY_1927 = true;    // canopy hung from the station's track wall, from the sheet 119 plan outline (ESTIMATE height)
CANOPY_1974 = false;   // flat canopy on curved brackets along the baggage building and breezeway (photo 03, 1974)
CANOPY_2001 = false;   // today's platform canopy on curved steel posts, built 2001 (photos 04, 07)
INTERIOR    = true;    // general waiting room: oval ticket counter, marble wainscot, pilasters, benches
CUTAWAY     = false;   // true = cut everything above 16.4 ft, to look into the waiting room

// ---- dimensions (feet) ----
SL = 104;  SW = 33.4;  SY = 3.8;     // station: length, depth, town-side y (track faces in line)
BX = 128;  BL = 115;   BW = 37.2;    // baggage & express: x start, length, depth (y 0..37.2)
TY = SY + SW;                        // track face y = 37.2
S_EAVE = 33;   S_RISE = 0.6;  S_OV = 4.5;
B_EAVE = 15.5; B_RISE = 0.54; B_OV = 4.5;
S1_SILL = 6.5; S1_H = 8.4; S2_SILL = 22.6; S2_H = 6.4;   // window sills and heights (photo 05)

BAYS = [9.9, 22.3, 36.8, 52.2, 67.6, 82.1, 94.4];   // station window bays (town side)

// three tripartite windows across an end wall, 2nd floor
function for_end(side) = [for (f = [0.2, 0.5, 0.8]) each [[SY + SW * f, side, 3.6, S2_H, S2_SILL], [SY + SW * f - 2.9, side, 1.3, S2_H, S2_SILL], [SY + SW * f + 2.9, side, 1.3, S2_H, S2_SILL]]];
// tripartite window: wide centre and two narrow sides
function tri(x, side, sill, h, blk = 0) = [[x, side, 4.4, h, sill, blk], [x - 3.3, side, 1.5, h, sill, blk], [x + 3.3, side, 1.5, h, sill, blk]];

S_WINS = concat(
    [for (x = BAYS) if (x != 52.2) each tri(x, 0, S1_SILL, S1_H)],          // town side, 1st floor
    [for (x = BAYS) each tri(x, 0, S2_SILL, S2_H)],                      // town side, 2nd floor
    [for (x = BAYS) each tri(x, 1, S2_SILL, S2_H)],                      // track side, 2nd floor (ESTIMATE)
    tri(9, 1, S1_SILL, S1_H), tri(95, 1, S1_SILL, S1_H),                            // smoking and lunch rooms
    [for (f = [0.2, 0.5, 0.8]) [SY + SW * f, 2, 3.6, 9, 5.4]],         // west end 1st floor, 3 tall windows (photo 04)
    for_end(2),                                                      // west end 2nd floor, 3 tripartite (photo 04)
    [for (f = [0.44, 0.70]) [SY + SW * f, 3, 3.5, 6, S1_SILL]],       // east end 1st floor
    for_end(3));                                                      // east end 2nd floor
S_DOORS = [[52.2, 0, 5.2, 8.4, 1],                                    // main entrance
           [22.7, 1, 5, 8, 1], [37.7, 1, 5, 8, 1], [67.6, 1, 5, 8, 1], [83, 1, 5, 8, 1],
           [SY + SW * 0.11, 3, 3.2, 7.5, 0]];                         // kitchen door, east end

// baggage openings: x from the baggage building's west end
B_WINS = concat(
    [for (x = [5.6, 33.1, 51.4, 59.9, 78.9, 107.7]) [BX + x, 0, 4.2, 3.5, 7, 1]],
    [for (x = [7.7, 36.6, 56.3, 64.8, 83.1, 107]) [BX + x, 1, 4.2, 3.5, 7, 1]],
    [[0.24 * BW, 3, 4.2, 3.5, 7, 1], [0.73 * BW, 3, 4.2, 3.5, 7, 1], [0.16 * BW, 2, 4.2, 3.5, 7, 1]]);
B_ROLL = concat([for (x = [14.1, 24.6, 43, 69, 87.3, 97.9]) [BX + x, 0]],      // roll-up doors (sheet 120)
                 [for (x = [17.6, 28.2, 73.2, 91.5, 102]) [BX + x, 1]]);
B_DOORS = [[BX + 46.8, 1, 3.2, 7.5, 0, 1], [0.72 * BW, 2, 3.2, 7.5, 0, 1]];     // express office and west end

module lc_builder() depot(blocks = [[0, SL, SY, SW, S_EAVE + S_OV * S_RISE, S_RISE, 0, S_OV, 2],
                [BX, BL, 0, BW, B_EAVE + B_OV * B_RISE, B_RISE, 0, B_OV, 2]],
      pavs   = [[SL, BX - SL, SY + 0.5, SW - 1, 13, 0, 4, 0.5, 3, 2]],   // open breezeway, flat roof (ESTIMATE)
      wins   = concat(S_WINS, B_WINS),
      doors  = concat(S_DOORS, B_DOORS),
      chims  = [[22.3, SY + SW * 0.59, 52.4], [76.4, SY + SW * 0.25, 47.1]],
      plat   = [-10, BX + BL + 20, 22, 0.5]);

// ---- details the builder does not draw ----
module lc_details() {
    // stone base / water table (Bedford stone)
    paint("stone") {
        fbox(-0.2, SY - 0.2, 0.5, SL + 0.4, SW + 0.4, 4.0);                 // limestone base
        fbox(-0.25, SY - 0.25, S1_SILL - 0.5, SL + 0.5, SW + 0.5, 0.5);       // stone band at the 1st floor sills
        for (x = BAYS, y = [SY - 0.3, TY]) fbox(x - 4.6, y, S2_SILL - 0.45, 9.2, 0.3, 0.45);   // 2nd floor stone sills
        fbox(BX - 0.2, -0.2, 0.5, BL + 0.4, BW + 0.4, 3.3);
    }
    // quoins at the corners: alternate long and short dark brown blocks
    paint("doors") {
        for (c = [[0, SY, S_EAVE], [SL, SY, S_EAVE], [0, TY, S_EAVE], [SL, TY, S_EAVE],
                  [BX, 0, B_EAVE], [BX + BL, 0, B_EAVE], [BX, BW, B_EAVE], [BX + BL, BW, B_EAVE]])
            for (z = [4.5 : 1.1 : c[2] - 1]) let (k = round((z - 4.5) / 1.1) % 2 == 0 ? 1.8 : 1.0,
                                                   sx = (c[0] == 0 || c[0] == BX) ? 1 : -1,     // wall runs +x from this corner
                                                   sy = (c[1] == SY || c[1] == 0) ? 1 : -1) {   // wall runs +y from this corner
                // block on the long (y) face
                fbox(sx > 0 ? c[0] - 0.15 : c[0] - k, sy > 0 ? c[1] - 0.15 : c[1], z, k + 0.15, 0.15, 0.8);
                // block on the end (x) face
                fbox(sx > 0 ? c[0] - 0.15 : c[0], sy > 0 ? c[1] - 0.15 : c[1] - k, z, 0.15, k + 0.15, 0.8);
            }
        // dark brick outline of the recessed panels between the floors, both long sides
        for (x = BAYS, y = [SY - 0.12, TY]) difference() {
            fbox(x - 3.9, y, 16.6, 7.8, 0.12, 3.6);
            fbox(x - 3.5, y - 0.1, 17.0, 7.0, 0.4, 2.8);
        }
    }
    // white downspouts with goosenecks (photos 04, 05)
    paint("trim") for (x = [0.6, 26, 77, SL - 0.6], y = [SY - 0.5, TY + 0.2]) {
        fbox(x - 0.2, y, 1, 0.4, 0.3, S_EAVE - 2.5);
        hull() { fbox(x - 0.2, y, S_EAVE - 1.6, 0.4, 0.3, 0.3); fbox(x - 0.2, y < SY ? y - 2.6 : y + 2.6, S_EAVE - 0.6, 0.4, 0.3, 0.3); }
    }
    // ticket office bay on the track side, flat roof
    paint("brick") fbox(44.3, TY, 0.5, 16.7, 5.9, 11.3);                   // one storey, flat roof (photo 03)
    paint("stone") { fbox(44.1, TY, 0.5, 17.1, 6.1, 4.0); fbox(44.0, TY, 11.8, 17.3, 6.3, 0.7); }
    on_face([44.3, 16.7, TY, 5.9], 52.65, 1) window(11, 6.5, 5.5);
    // entrance awning on the town side (removed later)
    paint("roof") fbox(43, SY - 6.4, 11.6, 21, 6.4, 0.4);
    paint("trim") {
        fbox(43, SY - 6.4, 11.1, 21, 0.3, 0.7);
        for (x = [44, 62.7]) hull() { fbox(x, SY, 16, 0.2, 0.2, 0.2); fbox(x, SY - 6.2, 11.8, 0.2, 0.2, 0.2); }
    }
    // entrance steps, town side
    paint("stone") for (i = [0 : 3]) fbox(47 - i * 0.5, SY - 1.2 - i * 1.0, 0, 10.4 + i, 1.2 + i * 1.0, 2.5 - i * 0.6);
}

// ---- roll-up doors on the baggage building (sheet 120 shows slatted rolling doors) ----
module rollup(w, h) {
    translate([-ft(w) / 2, ft(0.5), 0]) {
        paint("doors") cube([ft(w), ft(h), ft(0.12)]);
        paint("doors") for (z = [0.45 : 0.45 : h - 0.3]) translate([0, ft(z), 0]) cube([ft(w), ft(0.08), ft(0.18)]);   // slats
        paint("trim") {
            for (x = [-ft(0.35), ft(w)]) translate([x, 0, 0]) cube([ft(0.35), ft(h + 1.2), ft(0.3)]);                   // guides
            translate([-ft(0.5), ft(h), 0]) cube([ft(w + 1), ft(1.2), ft(0.7)]);                                         // roll hood
        }
    }
}
module bag_doors() for (d = B_ROLL) on_face([BX, BL, 0, BW], d[0], d[1]) rollup(7, 10);

// ---- canopies ----
module gooseneck(x, y0, dir, z0, z1, reach) paint("trim")          // curved bracket from the wall up to the deck edge
    for (i = [0 : 5]) let (a = i * 18, b = (i + 1) * 18) hull() {
        fbox(x, y0 + dir * reach * (1 - cos(a)), z0 + (z1 - z0) * sin(a), 0.25, 0.25, 0.25);
        fbox(x, y0 + dir * reach * (1 - cos(b)), z0 + (z1 - z0) * sin(b), 0.25, 0.25, 0.25);
    }
module canopies() {
    if (CANOPY_1927) {
        paint("roof") fbox(14.8, TY, 12.6, 74.8, 8.7, 0.5);
        paint("trim") {
            fbox(14.8, TY + 8.4, 12.0, 74.8, 0.3, 0.9);
            for (x = [16 : 12 : 89]) hull() { fbox(x, TY, 19, 0.2, 0.2, 0.2); fbox(x, TY + 8.3, 13, 0.2, 0.2, 0.2); }
        }
    }
    if (CANOPY_1974) {                                            // ESTIMATE: 8 ft deep at 11 ft, brackets every 12 ft
        paint("roof") fbox(SL, BW, 11.4, BX + BL - SL, 8, 0.4);
        paint("trim") fbox(SL, BW + 7.7, 10.8, BX + BL - SL, 0.3, 1.0);
        for (x = [SL + 3 : 12 : BX + BL - 2]) gooseneck(x, BW, 1, 7, 11.4, 7.6);
    }
    if (CANOPY_2001) {                                            // ESTIMATE: one row of posts, deck 14 ft wide at 13 ft
        for (x = [8 : 16 : BX + 60]) {
            paint("doors") fbox(x - 0.3, TY + 12.7, 0.5, 0.6, 0.6, 12.5);
            for (d = [-1, 1]) paint("doors") for (i = [0 : 5]) let (a = i * 15, b = (i + 1) * 15) hull() {
                fbox(x - 0.15, TY + 13 + d * 6.5 * sin(a), 9 + 3.8 * (1 - cos(a)), 0.3, 0.3, 0.3);
                fbox(x - 0.15, TY + 13 + d * 6.5 * sin(b), 9 + 3.8 * (1 - cos(b)), 0.3, 0.3, 0.3);
            }
        }
        paint("doors") fbox(6, TY + 6, 13, BX + 64, 14, 0.4);
        paint("trim") for (y = [TY + 5.8, TY + 19.8]) fbox(6, y, 12.6, BX + 64, 0.2, 0.9);
    }
}

// ---- waiting room (sheet 119: general waiting 31'6 x 46'0; photos 06, 09) ----
WX0 = 29.6; WX1 = 76.2; WY0 = SY + 1.0; WY1 = TY - 1.0; WZ = 18;   // room box (ESTIMATE ceiling 18 ft)
CX = 52.65; CY = TY - 5.4;                                         // ticket office front wall, centre of the oval counter
module room_void() fbox(WX0, WY0, FLOOR, WX1 - WX0, WY1 - WY0, WZ - FLOOR);
module openings() {                                                // window and door holes through the walls into the room
    for (x = [36.8, 67.6]) fbox(x - 4.6, SY - 0.0003, S1_SILL, 9.2, 1.2, S1_H);
    fbox(52.2 - 2.6, SY - 0.0003, FLOOR, 5.2, 1.2, 8.4);
    for (x = [37.7, 67.6]) fbox(x - 2.5, WY1 - 0.2, FLOOR, 5, 1.2003, 8);
    fbox(45.2, WY1 - 0.2, FLOOR, 14.9, 1.2003, 9);                  // office opens into the ticket bay
}
module half_ring(a, b, t, h) linear_extrude(ft(h)) intersection() {
    difference() { scale([ft(a), ft(b)]) circle(1, $fn = 72); scale([ft(a - t), ft(b - t)]) circle(1, $fn = 72); }
    translate([-ft(a + 1), -ft(b + 1)]) square([ft(2 * a + 2), ft(b + 1)]);
}
module waiting_room() {
    // floor: cream marble with a dark ring around the counter
    paint("stone") fbox(WX0, WY0, FLOOR - 0.1, WX1 - WX0, WY1 - WY0, 0.1);
    paint("doors") translate([ft(CX), ft(CY), ft(FLOOR)]) half_ring(14, 10, 0.6, 0.02);
    // walls: marble wainscot to 4.5 ft, cream plaster above, plaster ceiling
    difference() {
        union() {
            paint("stone") { fbox(WX0, WY0, FLOOR, WX1 - WX0, 0.15, 4.5); fbox(WX0, WY1 - 0.15, FLOOR, WX1 - WX0, 0.15, 4.5);
                             fbox(WX0, WY0, FLOOR, 0.15, WY1 - WY0, 4.5); fbox(WX1 - 0.15, WY0, FLOOR, 0.15, WY1 - WY0, 4.5); }
            paint("stucco") { fbox(WX0, WY0, FLOOR + 4.5, WX1 - WX0, 0.12, WZ - FLOOR - 4.5); fbox(WX0, WY1 - 0.12, FLOOR + 4.5, WX1 - WX0, 0.12, WZ - FLOOR - 4.5);
                              fbox(WX0, WY0, FLOOR + 4.5, 0.12, WY1 - WY0, WZ - FLOOR - 4.5); fbox(WX1 - 0.12, WY0, FLOOR + 4.5, 0.12, WY1 - WY0, WZ - FLOOR - 4.5);
                              fbox(WX0, WY0, WZ - 0.12, WX1 - WX0, WY1 - WY0, 0.12); }
        }
        openings();
    }
    // stone pilasters and plaster ceiling beams (photo 06)
    paint("stone") for (p = [[31, WY0], [45, WY0], [60, WY0], [74.5, WY0], [31, WY1 - 0.7], [42.5, WY1 - 0.7], [62.5, WY1 - 0.7], [74.5, WY1 - 0.7]])
        { fbox(p[0] - 0.8, p[1], FLOOR, 1.6, 0.7, WZ - FLOOR - 1.2); fbox(p[0] - 1.1, p[1] - 0.1, WZ - 1.4, 2.2, 0.9, 0.6); }
    paint("stucco") for (x = [31, 45, 60, 74.5]) fbox(x - 0.7, WY0, WZ - 1.3, 1.4, WY1 - WY0, 1.3);
    // ticket office side walls
    paint("stucco") for (x = [44.6, 60.4]) fbox(x, CY, FLOOR, 0.4, WY1 - CY, WZ - FLOOR);
    // oval ticket counter: black base, cream marble, wood ledge, wood screen with ticket windows, cornice, clock
    translate([ft(CX), ft(CY), ft(FLOOR)]) {
        paint("doors") half_ring(10.1, 6.9, 1.4, 0.6);
        paint("stone") translate([0, 0, ft(0.6)]) half_ring(10, 6.8, 1.2, 3.0);
        paint("doors") translate([0, 0, ft(3.6)]) half_ring(10.4, 7.2, 1.8, 0.25);
        difference() {
            paint("doors") translate([0, 0, ft(3.85)]) half_ring(9.6, 6.4, 0.5, 6.2);
            for (a = [-55, 0, 55]) rotate([0, 0, a - 90]) translate([-ft(1.3), ft(5), ft(4.6)]) cube([ft(2.6), ft(6), ft(4)]);
        }
        paint("glass") for (a = [-55, 55]) rotate([0, 0, a - 90]) translate([-ft(1.3), ft(5.6), ft(4.6)]) cube([ft(2.6), ft(0.3), ft(4)]);
        paint("sash")  rotate([0, 0, -90]) translate([-ft(1.3), ft(5.7), ft(4.6)]) cube([ft(2.6), ft(0.2), ft(4)]);   // train bulletin board
        paint("doors") translate([0, 0, ft(10.05)]) half_ring(10.2, 7.0, 1.4, 0.8);
        paint("doors") translate([-ft(1.1), -ft(6.6), ft(10.85)]) cube([ft(2.2), ft(0.6), ft(2.4)]);
        paint("sash")  translate([0, -ft(6.62), ft(12.05)]) rotate([90, 0, 0]) cylinder(r = ft(0.8), h = ft(0.05), $fn = 36);
    }
    // wooden benches, double-sided (ESTIMATE layout)
    for (x = [38.5, 66.8], y = [SY + 5.5, SY + 12]) paint("doors") {
        fbox(x - 6, y - 1.8, FLOOR + 1.3, 12, 3.6, 0.25);
        fbox(x - 6, y - 0.15, FLOOR + 1.3, 12, 0.3, 1.9);
        for (e = [x - 6, x + 5.7]) fbox(e, y - 1.8, FLOOR, 0.3, 3.6, 2.4);
    }
}

// ---- the whole model ----
difference() {
    union() { lc_builder(); lc_details(); bag_doors(); canopies(); }
    if (INTERIOR) { room_void(); openings(); }
    if (CUTAWAY) fbox(-60, -60, WZ - 1.6, 400, 200, 80);
}
if (INTERIOR) difference() { waiting_room(); if (CUTAWAY) fbox(-60, -60, WZ - 1.6, 400, 200, 80); }
