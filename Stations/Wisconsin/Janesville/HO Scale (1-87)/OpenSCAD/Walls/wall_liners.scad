// =====================================================================
//  Interior wall finish (Tom's reference photo): cream-white plaster above a dark pine
//  beadboard wainscot, with pine baseboard, cap rail, crown and door/window trim.
//
//  One thin LINER panel (0.8 mm, trim 1.2 mm) per wall face per room.  Glue it to the inside of
//  the brick walls and to both faces of the partitions, standing on the finished floor.
//  It also covers the wire chases and splice plates.
//    Liner_<id>        cream white (plaster)        Liner_<id>_pine   dark pine (wainscot + trim)
//  Load the two bodies together (AMS).  Printed flat, room side up.
//  Wainscot 5'-0" high (B2082), boards 4" wide.
// =====================================================================
include <../janesville_common.scad>
use <walls.scad>
use <interior_walls.scad>

LINER = "Main_west"; TILE = -1; LAYER = -1; LIST = false;
CREAM = "#F3EBD3"; PINE = "#5A3A22";
LT = 0.5; LBASE = 0.2; LTRIM = 0.75;       // liner thickness, base layer, raised trim (mm)
WAIN = 5.0; BASEB = 0.75; CAP = 0.3; CROWN = 0.5; TRIM = 0.4;   // ft
BOARD = BX * ft(0, 4); BGAP = 0.3; FLR = 0.6;  // bead spacing, groove, floor overlay thickness (mm)
B = 1.1 / ft(1); S = 0.9 / ft(1); TM = T_MAIN / ft(1); TL = T_LIGHT / ft(1);
LM = 98 + 1/12; LX1 = LM + 30 + 4/12; LY0 = 1 + 5/12; LY1 = LY0 + 25 + 4/12;
BX0 = X_BAG_W / ft(1); BX1 = X_BAG_E / ft(1); BXP = BX0 + 30.58;

// [id, kind ("ext"/"int"), wall or partition name, from, to (WORLD ft along the wall: x for walls running
//  east-west, y for walls running north-south), height ft, side]
//  ext side: "in" = room side of an outside wall, "out" = its other face.  int side: "A" / "B" (the two faces).
LINERS = [
  ["MT_waiting",   "ext", "Main_track", TM, 40.25 - B, 18, "in"],
  ["MT_trainorder","ext", "Main_track", 55 + S, 60.25 - B, 10, "in"],
  ["MT_smoking",   "ext", "Main_track", 60.25 + B, 87.35 - B, 18, "in"],
  ["MT_annex",     "ext", "Main_track", 87.35 + B, LM - TM, 10, "in"],
  ["MN_waiting",   "ext", "Main_town", TM, 40.25 - B, 18, "in"],
  ["MN_womens",    "ext", "Main_town", 40.25 + B, 49.5 - S, 10, "in"],
  ["MN_vestibule", "ext", "Main_town", 49.5 + S, 60.25 - B, 10, "in"],
  ["MN_smoking",   "ext", "Main_town", 60.25 + B, 87.35 - B, 18, "in"],
  ["MN_mens",      "ext", "Main_town", 87.35 + B, LM - TM, 10, "in"],
  ["MW_waiting",   "ext", "Main_west", TM, 32 - TM, 18, "in"],
  ["ME_annex",     "ext", "Main_east", TM, 16 - S, 10, "in"],
  ["ME_mens",      "ext", "Main_east", 16 + S, 32 - TM, 10, "in"],
  ["ME_lunch",     "ext", "Main_east", LY0 + TL, LY1 - TL, 10, "out"],
  ["LT_lunch",     "ext", "Lunch_track", LM + 0.05, LX1 - TL, 10, "in"],
  ["LN_lunch",     "ext", "Lunch_town", LM + 0.05, 116 - S, 9.5, "in"],
  ["LN_kitchen",   "ext", "Lunch_town", 116 + S, LX1 - TL, 9.5, "in"],
  ["LE_lunch",     "ext", "Lunch_east", LY0 + TL, LY1 - TL, 9.5, "in"],
  ["BT_baggage",   "ext", "Baggage_track", BX0 + TL, BXP - B, 10, "in"],
  ["BT_express",   "ext", "Baggage_track", BXP + B, BX1 - TL, 10, "in"],
  ["BN_baggage",   "ext", "Baggage_town", BX0 + TL, BXP - B, 10, "in"],
  ["BN_express",   "ext", "Baggage_town", BXP + B, BX1 - TL, 10, "in"],
  ["BW_baggage",   "ext", "Baggage_west", LY0 + TL, LY1 - TL, 10, "in"],
  ["BE_express",   "ext", "Baggage_east", LY0 + TL, LY1 - TL, 10, "in"],
  // partitions running north-south: side A faces east, side B faces west
  ["W1_waiting",   "int", "W1_waiting_pavilion", TM, 32 - TM, 18, "B"],
  ["W1_ticket",    "int", "W1_waiting_pavilion", TM, 11.75 - S, 10, "A"],
  ["W1_passage",   "int", "W1_waiting_pavilion", 11.75 + S, 21.25 - S, 10, "A"],
  ["W1_womens",    "int", "W1_waiting_pavilion", 21.25 + S, 32 - TM, 10, "A"],
  ["W2_smoking",   "int", "W2_pavilion_smoking", TM, 32 - TM, 18, "A"],
  ["W2_trainorder","int", "W2_pavilion_smoking", TM, 11.75 - S, 10, "B"],
  ["W2_passage",   "int", "W2_pavilion_smoking", 11.75 + S, 21.25 - S, 10, "B"],
  ["W2_vestibule", "int", "W2_pavilion_smoking", 21.25 + S, 32 - TM, 10, "B"],
  ["S1_smoking",   "int", "S1_smoking_east", TM, 32 - TM, 18, "B"],
  ["S1_annex",     "int", "S1_smoking_east", TM, 16 - S, 10, "A"],
  ["S1_mens",      "int", "S1_smoking_east", 16 + S, 32 - TM, 10, "A"],
  ["P2_ticket",    "int", "P2_ticket_trainorder", TM, 11.75 - S, 9.5, "B"],
  ["P2_trainorder","int", "P2_ticket_trainorder", TM, 11.75 - S, 9.5, "A"],
  ["P4_womens",    "int", "P4_toilet_vestibule", 21.25 + S, 32 - TM, 9.5, "B"],
  ["P4_vestibule", "int", "P4_toilet_vestibule", 21.25 + S, 32 - TM, 9.5, "A"],
  ["K1_lunch",     "int", "K1_kitchen", 13.5, LY1 - TL, 9, "B"],
  ["K1_kitchen",   "int", "K1_kitchen", 13.5, LY1 - TL, 9, "A"],
  ["B1_baggage",   "int", "B1_baggage_express", LY0 + TL, LY1 - TL, 10, "B"],
  ["B1_express",   "int", "B1_baggage_express", LY0 + TL, LY1 - TL, 10, "A"],
  // partitions running east-west: side A faces south (track), side B faces north (town)
  ["P1_ticket",    "int", "P1_ticket_passage", 40.25 + B, 55 - S, 9.5, "A"],
  ["P1_trainorder","int", "P1_ticket_passage", 55 + S, 60.25 - B, 9.5, "A"],
  ["P1_passage",   "int", "P1_ticket_passage", 40.25 + B, 60.25 - B, 9.5, "B"],
  ["P3_passage",   "int", "P3_passage_town", 40.25 + B, 60.25 - B, 9.5, "A"],
  ["P3_womens",    "int", "P3_passage_town", 40.25 + B, 49.5 - S, 9.5, "B"],
  ["P3_vestibule", "int", "P3_passage_town", 49.5 + S, 60.25 - B, 9.5, "B"],
  ["S2_annex",     "int", "S2_menstoilet", 96.4, LM - TM, 9.5, "A"],
  ["S2_mens",      "int", "S2_menstoilet", 96.4, LM - TM, 9.5, "B"]
];
function lrow(n) = LINERS[search([n], LINERS)[0]];
function liner_list() = [for (l = LINERS) l[0]];
// wall frame: [origin mm, angle, thickness, start offset mm]
function frame(l) = l[1] == "ext" ? let(r = wrow(l[2])) [r[7], r[8], r[3], 0]
                                  : let(r = irow(l[2]), d = r[2] - r[1]) [r[1], atan2(d[1], d[0]), r[4], 0];
function norm_a(a) = ((round(a) % 360) + 360) % 360;
// world ft -> u (mm from the wall origin, along the wall)
function wu(f, w) = let(a = norm_a(f[1])) a == 0 ? ft(w) - f[0][0] : a == 180 ? f[0][0] - ft(w) : a == 90 ? ft(w) - f[0][1] : f[0][1] - ft(w);
function useg(l) = let(f = frame(l), a = wu(f, l[3]), b = wu(f, l[4])) [min(a, b), max(a, b)];
function liner_len(l) = let(u = useg(l)) u[1] - u[0];
function liner_count(n, bed) = ceil(liner_len(lrow(n)) / (bed[0] - 6));

// openings in wall coordinates (u from the wall origin, v from the floor)
module l_open2d(l) {
    if (l[1] == "ext") { r = wrow(l[2]); translate([w_off(r), 0]) openings2d(r); }
    else i_openings2d(irow(l[2]));
}
// everything below is in SEGMENT coordinates: x from the segment start, v from the floor
module seg(l) translate([-useg(l)[0], 0]) children();
module region2d(l) difference() { translate([0, FLR]) square([liner_len(l), ft(l[5]) - FLR]); seg(l) l_open2d(l); }
module trim2d(l) intersection() { region2d(l); union() {
    translate([-1, 0]) square([liner_len(l) + 2, ft(BASEB)]);
    translate([-1, ft(WAIN - CAP)]) square([liner_len(l) + 2, ft(CAP)]);
    translate([-1, ft(l[5] - CROWN)]) square([liner_len(l) + 2, ft(CROWN) + 1]);
    seg(l) offset(delta = ft(TRIM)) l_open2d(l); } }
module wain2d(l) intersection() { region2d(l); translate([-1, 0]) square([liner_len(l) + 2, ft(WAIN)]); }
module grooves2d(l) for (x = [BOARD : BOARD : liner_len(l)]) translate([x - BGAP / 2, ft(BASEB)]) square([BGAP, ft(WAIN - BASEB - CAP)]);
// layers: cream 0 base, 1 top;  pine 2 base, 3 boards, 4 raised trim
module liner_layer2d(l, k) {
    if (k == 0) difference() { region2d(l); wain2d(l); }
    if (k == 1) difference() { region2d(l); wain2d(l); trim2d(l); }
    if (k == 2) wain2d(l);
    if (k == 3) difference() { wain2d(l); grooves2d(l); trim2d(l); }
    if (k == 4) trim2d(l);
}
function lz(k) = [[0, LBASE], [LBASE, LT], [0, LBASE], [LBASE, LT], [LBASE, LTRIM]][k];
function mirrored(l) = (l[1] == "ext" && l[6] == "in") || (l[1] == "int" && l[6] == "B");     // faces local +y
// printable: room side up; faces that look toward local +y are mirrored so they read correctly
module liner_layer(n, k, tile = -1, bed = BED) {
    l = lrow(n); L = liner_len(l); m = liner_count(n, bed); w = L / m; z = lz(k);
    for (i = [0 : m - 1]) if (tile < 0 || tile == i) translate([tile < 0 ? 0 : -i * w, 0, z[0]]) linear_extrude(z[1] - z[0])
        intersection() { translate([i * w, 0]) square([w, ft(l[5]) + 1]);
            if (mirrored(l)) translate([L, 0]) mirror([1, 0]) liner_layer2d(l, k); else liner_layer2d(l, k); }
}
module liner_part(name, tile = -1, bed = BED) for (l = LINERS) {
    if (name == str("Liner_", l[0])) for (k = [0, 1]) liner_layer(l[0], k, tile, bed);
    if (name == str("Liner_", l[0], "_pine")) for (k = [2, 3, 4]) liner_layer(l[0], k, tile, bed);
}
function liner_parts(bed) = concat([for (l = LINERS) [str("Liner_", l[0]), liner_count(l[0], bed)]],
                                   [for (l = LINERS) [str("Liner_", l[0], "_pine"), liner_count(l[0], bed)]]);
// in place on the building
module liner_place(n) {
    l = lrow(n); f = frame(l); u = useg(l); T = f[2]; mir = mirrored(l);
    yf = l[1] == "ext" ? (l[6] == "in" ? T : 0) : (l[6] == "B" ? T / 2 : -T / 2);
    translate([f[0][0], f[0][1], FLOOR_Z]) rotate([0, 0, f[1]]) translate([u[0], yf, 0])
        if (mir) mirror([0, 1, 0]) rotate([90, 0, 0]) unm(l); else rotate([90, 0, 0]) unm(l);
}
module unm(l) {      // unmirrored (wall-coordinate) liner, both colors
    color(CREAM) for (k = [0, 1]) translate([0, 0, lz(k)[0]]) linear_extrude(lz(k)[1] - lz(k)[0]) liner_layer2d(l, k);
    color(PINE) for (k = [2, 3, 4]) translate([0, 0, lz(k)[0]]) linear_extrude(lz(k)[1] - lz(k)[0]) liner_layer2d(l, k);
}
module liners_place() for (l = LINERS) liner_place(l[0]);

if (LIST) for (p = liner_parts(BED)) echo(str("LPART|", p[0], "|", p[1]));
else if (LAYER >= 0) liner_layer(LINER, LAYER, TILE, BED);
else if (TILE < 0) liners_place();
else liner_part(str("Liner_", LINER), TILE, BED);
