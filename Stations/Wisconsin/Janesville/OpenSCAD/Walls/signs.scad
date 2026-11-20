// =====================================================================
//  Station name board  "JANESVILLE"
//  Mounted on the WEST END wall of the main block, centered above the arched window,
//  below the cornice (the end the trains and the town approach from).
//  Period style (valuation photos / postcards): long dark board, light Roman capitals,
//  raised border molding with notched corners.
//
//  Two bodies for the AMS (load together as one object):
//    Sign_janesville          board            Pullman green
//    Sign_janesville_letters  letters + border white / cream
//  Printed flat, face up.  Glue to the brick (or pin with two 1.75 mm filament stubs).
// =====================================================================
include <../janesville_common.scad>

SIGN_TEXT = "JANESVILLE";
SIGN_FONT = "Liberation Serif:style=Bold";    // bundled with OpenSCAD on every platform
SIGN_L = ft(16);         // 16'-0" long
SIGN_H = ft(2.25);       // 2'-3" high
LETTER_H = ft(1.25);     // 1'-3" capitals
BOARD_T = 1.6;           // board thickness (mm)
RAISE   = 0.8;           // letters and border stand proud
BORDER  = ft(0, 3);      // border molding width
NOTCH   = ft(0, 5);      // notched corners
SIGN_Z  = 15.5;          // bottom of the board, ft above the floor
SIGN_Y  = 16;            // centered on the west end wall (ft from the track-side wall line)
CREAM   = "#F1EAD7";
PART    = "Sign_janesville";
$fn = 48;

module board2d() difference() {
    square([SIGN_L, SIGN_H]);
    for (x = [0, SIGN_L]) for (y = [0, SIGN_H]) translate([x, y]) circle(r = NOTCH);
}
module border2d() difference() { board2d(); offset(delta = -BORDER) board2d(); }
module letters2d() translate([SIGN_L / 2, SIGN_H / 2])
    resize([SIGN_L - 2 * BORDER - ft(1.25), 0], auto = [false, false])
        text(SIGN_TEXT, size = LETTER_H, font = SIGN_FONT, halign = "center", valign = "center", spacing = 1.08);

module sign_board()   linear_extrude(BOARD_T) board2d();
module sign_letters() translate([0, 0, BOARD_T]) linear_extrude(RAISE) union() { border2d(); letters2d(); }

// ---------- oval boards hung under the canopy ends (c.1910 photo) ----------
// Two-sided: each sign = two halves glued back to back, so the name reads from both directions.
// One STL holds all 4 halves (2 signs).  Sign_oval = board + hanger straps (WHITE, Tom Oct 2026),
// Sign_oval_letters = letters + rim (black).  Glue the strap tops to the underside of the hip-end roof.
// (Was Pullman green with cream letters; painted white so the name reads from the platform.)
OV_L = ft(7); OV_H = ft(2.5); OV_T = 1.2; OV_RIM = ft(0, 2.5);
OV_STRAP = 1.0;                       // hanger length (ft)
OV_BOARD = "#F4F2EC"; OV_LETTER = "#161616";   // white board, black letters
OV_SX = ft(2.2);                      // strap spacing from center
module oval2d() scale([OV_L / 2, OV_H / 2]) circle(r = 1, $fn = 96);
module ovboard2d() { oval2d(); for (s = [-1, 1]) translate([s * OV_SX - ft(0, 1.5), 0]) square([ft(0, 3), OV_H / 2 + ft(OV_STRAP)]); }
module ovletters2d() {
    difference() { oval2d(); offset(delta = -OV_RIM) oval2d(); }
    resize([OV_L * 0.74, 0], auto = [false, false])
        text(SIGN_TEXT, size = ft(0.85), font = SIGN_FONT, halign = "center", valign = "center", spacing = 1.08);
}
module oval_board()   linear_extrude(OV_T) ovboard2d();
module oval_letters() translate([0, 0, OV_T]) linear_extrude(RAISE) ovletters2d();
module oval_grid() for (i = [0, 1]) for (j = [0, 1]) translate([i * (OV_L + 4), j * (OV_H / 2 + ft(OV_STRAP) + OV_H / 2 + 4), 0]) children();

function sign_parts() = ["Sign_janesville", "Sign_janesville_letters", "Sign_oval", "Sign_oval_letters"];
module sign_part(n) {
    if (n == "Sign_janesville") sign_board();
    if (n == "Sign_janesville_letters") sign_letters();
    if (n == "Sign_oval") oval_grid() oval_board();
    if (n == "Sign_oval_letters") oval_grid() oval_letters();
}

// canopy ends (numbers match Canopy/canopy.scad): [x, y on the shelter ridge line, underside of roof (ft above floor)]
OV_BX1 = 98 + 1/12 + 30 + 4/12 + 42 + 47 + 2/12;
OV_ENDS = [[-43.5 + 1.0, (-17.5 + 9.7) / 2, 11.5 + 0.15], [OV_BX1 + 40 - 1.0, (-17.5 + 22.5) / 2, 11.5 + 0.15]];
module sign_oval_place() for (e = OV_ENDS) translate([ft(e[0]), ft(e[1]), FLOOR_Z + ft(e[2] - OV_STRAP) - OV_H / 2]) {
    for (m = [[[0, 0, -1, 0], [-1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]], [[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]])
        multmatrix(m) { color(OV_BOARD) oval_board(); color(OV_LETTER) oval_letters(); }
}
// one body at a time, uncoloured (for the 3D-viewer export): k = 0 board, 1 letters
module sign_oval_place_part(k) for (e = OV_ENDS) translate([ft(e[0]), ft(e[1]), FLOOR_Z + ft(e[2] - OV_STRAP) - OV_H / 2]) {
    for (m = [[[0, 0, -1, 0], [-1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]], [[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]])
        multmatrix(m) if (k == 0) oval_board(); else oval_letters();
}
module sign_place_part(k)
    multmatrix([[0, 0, -1, 0], [-1, 0, 0, ft(SIGN_Y) + SIGN_L / 2], [0, 1, 0, FLOOR_Z + ft(SIGN_Z)], [0, 0, 0, 1]])
        if (k == 0) sign_board(); else sign_letters();

// on the building: west face is x = 0, facing -x; text reads north -> south
module sign_place() {
    multmatrix([[0, 0, -1, 0], [-1, 0, 0, ft(SIGN_Y) + SIGN_L / 2], [0, 1, 0, FLOOR_Z + ft(SIGN_Z)], [0, 0, 0, 1]]) {
        color(PULLMAN_GREEN) sign_board();
        color(CREAM) sign_letters();
    }
}

VIEW = "flat";
if (VIEW == "placed") { sign_place(); sign_oval_place(); } else if (VIEW == "oval") { color(OV_BOARD) oval_board(); color(OV_LETTER) oval_letters(); } else { color(PULLMAN_GREEN) sign_board(); color(CREAM) sign_letters(); }
