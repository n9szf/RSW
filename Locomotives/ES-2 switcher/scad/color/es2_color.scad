// one colour of one print, maroon scheme (E82), for the AMS colour 3MF
PIECE = "hood_1";   // hood_1, hood_2, cab
COL   = "maroon";   // maroon, orange, black, white
LOCO_SEL = "E82"; PAINT_SEL = "ORANGE_MAROON"; FN_SEL = 100;
include <../library/es2_all.scad>
if (PIECE == "hood_1" || PIECE == "hood_2") {
    n = PIECE == "hood_1" ? 1 : 2;
    if (COL == "maroon") { translate([-hood_l / 2, 12, 0]) intersection() { es2_hood(n); hood_low_zone(); }
                           translate([12, -hood_w / 2 - 14, 0]) rotate([0, 0, -90]) es2_ladder_print(); }
    if (COL == "orange") translate([-hood_l / 2, 12, 0]) difference() { es2_hood(n); hood_low_zone(); }
    if (COL == "black") { translate([-hood_l / 2 + 25, -hood_w / 2 - 12, 0]) es2_headlight_tower();
                          if (n == 1) translate([-hood_l / 2 + 55, -hood_w / 2 - 12, 0]) es2_bell();
                          if (n == 2) translate([45, -100, 0]) es2_pole_mast(); }
    if (COL == "white") { translate([-hood_l / 2 + 2, -hood_w / 2 - 12, 0]) es2_headlight_lens();
                          for (i = [0 : rail_post_count - 1]) translate([-68 + i * 10, -118, 0]) es2_rail_post_print(i >= 2 * len(rail_side_posts)); }
}
if (PIECE == "cab") {
    if (COL == "maroon") translate([-cab_hx - 4, 0, 0]) intersection() { es2_cab(); below_line(cab_line); }
    if (COL == "orange") translate([-cab_hx - 4, 0, 0]) difference() { es2_cab(); below_line(cab_line); }
    if (COL == "black") { translate([roof_l / 2 + 4, 0, 0]) es2_roof(); translate([0, 72, 0]) es2_slider(); }
}
