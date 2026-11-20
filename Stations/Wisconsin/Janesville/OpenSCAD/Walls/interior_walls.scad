// =====================================================================
//  Interior walls (partitions) from B2077 Plan of Main Floor, 1902
//  Printed flat. Both faces carry the varnished-oak wainscot noted on the plan:
//  baseboard line, cap rail at 5'-0", panel stiles every 2'-0"; plaster above.
//  Brick partitions run full height (18'-6"); stud partitions 10'-0" (ceilings come later).
//
//  interior_part(name, tile, bed)   interior_place(name)   interior_list()
//  interior_count(name, bed)        interior_splices(name, bed) / interior_splice_count(...)
// =====================================================================
include <../janesville_common.scad>

INT  = "W1_waiting_pavilion";   // when opened directly
TILE = -1;
VIEW = "flat";                  // "flat" or "placed"

T_BRICK = 4.0;      // brick partition (real 13")
T_STUD  = 3.0;      // stud partition (real 6")
WAIN_H  = 5.0;      // wainscot cap rail height, ft (B2082 lunch room section)
BASE_H  = 0.75;     // baseboard top, ft
STILE   = 2.0;      // panel stile spacing, ft
GROOVE  = 0.5;  GROOVE_D = 0.3;
SPLICE_W = 16; SPLICE_T = 1.0; SPLICE_CLEAR = 0.3;
HIGH = 18.5; LOW = 10;
$fn = 32;
L_MAIN_FT = 98 + 1/12;

// opening helpers: [center_ft along wall from start point, width_ft, bottom_ft, top_ft]
function O(c, w, b, t) = [c, w, b, t];
function DR(c, w = 2.83, t = 7.5) = [c, w, 0, t];

// lunch wing and baggage building interior faces (mm)
LW_Y0 = LUNCH_Y0 + 5;  LW_Y1 = LUNCH_Y1 - 5;
BG_Y0 = BAG_Y0 + 5;    BG_Y1 = BAG_Y1 - 5;
YT = T_MAIN; YN = MAIN_DEPTH - T_MAIN;        // main block inside faces, track / town

// [name, start [x,y] mm, end [x,y] mm, height_ft, thickness, openings]
// Openings are measured from the START point (ft).
INT_TABLE = [
  // general waiting room | pavilion  (x = 40'-3")
  ["W1_waiting_pavilion", [ft(40.25), YT], [ft(40.25), YN], HIGH, T_BRICK,
     [O(7 - T_MAIN / ft(1), 3, 3, 6.5),          // ticket window into the ticket office
      O(16.5 - T_MAIN / ft(1), 8, 0, 10)]],      // wide passage opening (I-beams over)
  // pavilion | smoking room  (x = 60'-3")
  ["W2_pavilion_smoking", [ft(60.25), YT], [ft(60.25), YN], HIGH, T_BRICK,
     [O(16.5 - T_MAIN / ft(1), 8, 0, 10)]],
  // smoking room | men's toilet + lunch-counter annex  (x = 87'-4": smoking room 26 ft inside)
  ["S1_smoking_east", [ft(87.35), YT], [ft(87.35), YN], HIGH, T_BRICK,
     [DR(7.5 - T_MAIN / ft(1), 5.67, 7.5),       // two 2'-10" doors to the lunch-counter annex
      DR(25 - T_MAIN / ft(1), 2.67)]],           // men's toilet door
  // ticket office + train order | passage  (y = 11'-9")
  ["P1_ticket_passage", [ft(40.25) + T_BRICK / 2, ft(11.75)], [ft(60.25) - T_BRICK / 2, ft(11.75)], LOW, T_STUD,
     [O(5, 4, 3, 6.5),                            // ticket counter window to the passage
      DR(16, 2.5)]],                              // door into the train-order office
  // ticket office | train order  (x = 55'-0")
  ["P2_ticket_trainorder", [ft(55), YT], [ft(55), ft(11.75) - T_STUD / 2], LOW, T_STUD,
     [DR(8, 2.5)]],
  // passage | women's toilet + vestibule  (y = 21'-3")
  ["P3_passage_town", [ft(40.25) + T_BRICK / 2, ft(21.25)], [ft(60.25) - T_BRICK / 2, ft(21.25)], LOW, T_STUD,
     [DR(4.5, 2.5),                               // women's toilet door
      O(13.5, 8, 0, 8.5)]],                       // open to the vestibule
  // women's toilet | vestibule  (x = 49'-6")
  ["P4_toilet_vestibule", [ft(49.5), ft(21.25) + T_STUD / 2], [ft(49.5), YN], LOW, T_STUD, []],
  // men's toilet | lunch-counter annex  (y = 16'-0")
  ["S2_menstoilet", [ft(96.3) + 0.3, ft(16)], [ft(L_MAIN_FT) - T_MAIN, ft(16)], LOW, T_STUD, []],     // short stub: the chimney base fills the rest of this line
  // kitchen | lunch room  (x = 116'-0")
  ["K1_kitchen", [ft(116), ft(13.5)], [ft(116), LW_Y1], 9.5, T_STUD,
     [DR(6.25, 2.67)]],
  // baggage room | express room
  ["B1_baggage_express", [X_BAG_W + ft(30.58), BG_Y0], [X_BAG_W + ft(30.58), BG_Y1], 10.5, T_BRICK,
     [DR(17.5, 3, 7.5)]]
];


function irow(n) = INT_TABLE[search([n], INT_TABLE)[0]];
function interior_list() = [for (r = INT_TABLE) r[0]];
function i_len(r) = norm(r[2] - r[1]);
function i_h(r)   = ft(r[3]);
function i_cuts(r, bed) = let(L = i_len(r), H = i_h(r), nx = ceil(L / (bed[0] - 2)), ny = ceil(H / (bed[1] - 2)))
    [nx, ny, [for (i = [1 : max(1, nx - 1)]) if (nx > 1) i * L / nx], [for (j = [1 : max(1, ny - 1)]) if (ny > 1) j * H / ny]];
function interior_count(n, bed) = let(c = i_cuts(irow(n), bed)) c[0] * c[1];
function interior_splice_count(n, bed) = len(i_cuts(irow(n), bed)[2]) * i_cuts(irow(n), bed)[1];
function i_splice_len(r) = min(i_h(r) - 20, ft(WAIN_H) - 8);

module i_openings2d(r) for (o = r[5]) {
    c = ft(o[0]); w = ft(o[1]); b = ft(o[2]); t = ft(o[3]);
    translate([c - w / 2, b - (b == 0 ? 1 : 0)]) square([w, t - b + (b == 0 ? 1 : 0)]);
}
module wainscot2d(L) {
    translate([-1, ft(WAIN_H) - GROOVE / 2]) square([L + 2, GROOVE]);       // cap rail
    translate([-1, ft(BASE_H) - GROOVE / 2]) square([L + 2, GROOVE]);       // baseboard
    for (u = [ft(STILE) : ft(STILE) : L - 2])
        translate([u - GROOVE / 2, ft(BASE_H)]) square([GROOVE, ft(WAIN_H - BASE_H)]);
}
function i_layers(r) = [0, GROOVE_D, SPLICE_T, r[4] - GROOVE_D, r[4]];

module i_region2d(r, k, bed) {
    L = i_len(r); H = i_h(r); cu = i_cuts(r, bed);
    difference() {
        square([L, H]);
        i_openings2d(r);
        if (k == 0 || k == 3) wainscot2d(L);
        if (k <= 1) for (c = cu[2]) translate([c - (SPLICE_W + SPLICE_CLEAR) / 2, 4])
            square([SPLICE_W + SPLICE_CLEAR, i_splice_len(r) + SPLICE_CLEAR]);
    }
}

module interior_part(n, tile = -1, bed = BED, only = -1) {
    r = irow(n); L = i_len(r); H = i_h(r); z = i_layers(r); cu = i_cuts(r, bed);
    nx = cu[0]; xc = cu[2]; yc = cu[3];
    ix = tile < 0 ? 0 : tile % nx; iy = tile < 0 ? 0 : floor(tile / nx);
    x0 = (tile < 0 || ix == 0) ? -2 : xc[ix - 1]; x1 = (tile < 0 || ix == nx - 1) ? L + 2 : xc[ix];
    y0 = (tile < 0 || iy == 0) ? -2 : yc[iy - 1]; y1 = (tile < 0 || iy == cu[1] - 1) ? H + 2 : yc[iy];
    for (k = [0 : 3]) if (only < 0 || only == k) translate([0, 0, z[k]]) linear_extrude(z[k + 1] - z[k])
        intersection() { i_region2d(r, k, bed); translate([x0, y0]) square([x1 - x0, y1 - y0]); }
}

module interior_splices(n, bed = BED) {
    r = irow(n); m = interior_splice_count(n, bed);
    if (m > 0) for (i = [0 : m - 1]) translate([i * (SPLICE_W + 4), 0, 0]) cube([SPLICE_W, i_splice_len(r), SPLICE_T - 0.1]);
}

module interior_place(n) {
    r = irow(n); d = r[2] - r[1]; a = atan2(d[1], d[0]); T = r[4];
    translate([r[1][0], r[1][1], FLOOR_Z]) rotate([0, 0, a]) rotate([90, 0, 0]) translate([0, 0, -T / 2]) interior_part(n);
}

LAYER = -1;   // cloud export helper
if (VIEW == "placed") for (n = interior_list()) interior_place(n);
else if (VIEW == "splices") interior_splices(INT, BED);
else interior_part(INT, TILE, BED, LAYER);
