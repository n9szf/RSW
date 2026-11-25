// =====================================================================
//  MILWAUKEE ROAD - WHITEWATER, WISCONSIN, PASSENGER STATION (1890-91)
//  C.M.&St.P. Ry. B.&B. Dept., Milwaukee, July 14 1890, J. T. W. Jennings,
//  architect. Drawings 2675-2677 and details (16-1146-1 to -12).
//  Now the Whitewater Historical Society depot museum, 301 W. Whitewater St.
//  Rib Side Works, 24 Nov 2026. FIRST SHAPE MODEL for review - not cut
//  into print sections.
//  Sources (private, in copyright): Research Library / RSW / Stations /
//  Wisconsin / Whitewater / MPL drawings 1890.
//
//  KNOWN (written): foundation 60 ft 2 in x 22 ft 2 in; walls 11 ft 3 in
//    platform to eave (16 ft above the rail on the track side); platform
//    12 in above the rail; 12 ft roof overhang; doors 3 ft 2 1/4 wide.
//  MEASURED (scaled off the 1/4 in elevations, +/- 1 ft): hipped roof,
//    about 16 ft rise, flat top about 45 ft long with iron cresting and
//    finials; 12 ft overhang at both ends and the track (south) side on posts
//    and brackets, about 5 ft on the street (north) side; a stone gabled
//    dormer with corner pinnacles centred on each long side; tall
//    chimneys; groups of three tall windows each side of the centre doors;
//    canted bay at the east end of the north wall.
//  ESTIMATE: brick colour (red pressed brick - the plan lists 'red brick'
//    and 'pressed brick'), stone colour, roof colour, dormer detail.
//
//  x along the track from the west end; y = 0 north (street) wall,
//  y = 22.2 south (track) wall; z = 0 platform level.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
COL_BRICK = "#8E3B2C";

L = 60.2; W = 22.2; EAVE = 11.25;
ovN = 5; ovS = 12; ovE = 12;                    // overhangs
RISE = 16.3;                                    // MEASURED (sheets 1 and 2 agree)
ex0 = -ovE; ex1 = L + ovE; ey0 = -ovN; ey1 = W + ovS;
ry = (ey0 + ey1) / 2; slope = RISE / ((ey1 - ey0) / 2);
rx0 = ex0 + (ey1 - ey0) / 2; rx1 = ex1 - (ey1 - ey0) / 2;   // ridge (flat top) ends
DX = 29.5;                                       // dormer centre

wins = [for (x = [8.1, 12.2, 16.3, 42.5, 46.6, 50.7], s = [0, 1]) [x, s, 2.8, 8.5, 2.2],
        [7, 2, 2.8, 8.5, 2.2], [15, 2, 2.8, 8.5, 2.2], [7, 3, 2.8, 8.5, 2.2], [15, 3, 2.8, 8.5, 2.2]];
doors = [[DX, 0, 5, 8.5, 1], [DX, 1, 5, 8.5, 1], [11, 2, 3.2, 8, 0], [11, 3, 3.2, 8, 0]];

module steep_roof() {
    paint("roof") hull() {
        fbox(ex0, ey0, EAVE, ex1 - ex0, ey1 - ey0, 0.6);
        fbox(rx0, ry - 0.5, EAVE + RISE, rx1 - rx0, 1, 0.6);
    }
    paint("trim") fbox(ex0, ey0, EAVE - 0.8, ex1 - ex0, ey1 - ey0, 0.8);                      // deep fascia
    paint("trim") for (x = [rx0 : 1.2 : rx1]) fbox(x, ry - 0.1, EAVE + RISE + 0.6, 0.2, 0.2, 1.6);   // cresting
    paint("trim") fbox(rx0, ry - 0.1, EAVE + RISE + 2.1, rx1 - rx0, 0.2, 0.25);
    for (x = [rx0, rx1]) paint("trim") { translate([ft(x), ft(ry), ft(EAVE + RISE)]) cylinder(h = ft(2.5), r1 = ft(1.4), r2 = ft(0.3), $fn = 16);
                                       fbox(x - 0.1, ry - 0.1, EAVE + RISE + 2.5, 0.2, 0.2, 3); }
    // posts: ends and track side
    paint("trim") for (x = [ex0 + 4, ex1 - 4], y = [-1, W + 8]) fbox(x - 0.4, y - 0.4, 0, 0.8, 0.8, EAVE - 0.8);
    paint("trim") for (x = [ex0 + 4, ex1 - 4], y = [6, 15]) fbox(x - 0.4, y - 0.4, 0, 0.8, 0.8, EAVE - 0.8);
}
module dormer(side) {                            // stone gabled dormer with corner pinnacles (sheets 1-3)
    dw = 15; zb = EAVE + (side ? 6 : 4); zw = EAVE + 11; zt = EAVE + 18.7;
    yf = side ? 27 : 0; d = 12; s = side ? -1 : 1;           // face line, depth back into the roof
    y0 = side ? yf - d : yf;
    paint("stone") fbox(DX - dw / 2, y0, zb, dw, d, zw - zb);                                   // dormer walls
    paint("stone") translate([ft(DX - dw / 2), ft(y0 + d), ft(zw)]) rotate([90, 0, 0]) linear_extrude(ft(d))
        polygon([[0, 0], [ft(dw), 0], [ft(dw / 2), ft(zt - zw)]]);                               // gable
    paint("roof") for (k = [0, 1]) hull() { fbox(k ? DX + dw / 2 - 0.1 : DX - dw / 2 - 0.4, y0 - (side ? 0 : 0.6), zw - 0.3, 0.5, d + 0.6, 0.4);
                                         fbox(DX - 0.25, y0 - (side ? 0 : 0.6), zt - 0.2, 0.5, d + 0.6, 0.5); }
    for (x = [DX - dw / 2 - 0.4, DX + dw / 2 - 1.2]) paint("stone") {                         // corner pinnacles
        fbox(x, side ? yf - 1.6 : yf - 0.4, zb, 1.6, 1.6, zw - zb + 1);
        translate([ft(x + 0.8), ft(side ? yf - 0.8 : yf + 0.4), ft(zw + 1)]) cylinder(h = ft(3), r1 = ft(1), r2 = 0, $fn = 4); }
    paint("glass") for (k = [-1, 0, 1]) fbox(DX + k * 3 - 1.1, side ? yf + 0.02 : yf - 0.08, zb + 1.5, 2.2, 0.06, 5);
    paint("glass") translate([ft(DX), side ? ft(yf) + 0.05 : ft(yf) - 0.05, ft(zw + 3)]) rotate([90, 0, 0]) cylinder(h = 0.3, r = ft(1.6), center = true, $fn = 24);   // trefoil / round light
}
module chimneys() { paint("chimney") for (y = [4, 18]) { fbox(43, y - 1, 6, 2.2, 2.2, EAVE + RISE - 2); fbox(42.7, y - 1.3, EAVE + RISE + 3.5, 2.8, 2.8, 0.8); } }

depot(blocks = [[0, L, 0, W, EAVE, 0, 5, 0, 2]], wins = wins, doors = doors,
      bays = [[55, 0, 9, 3]], plat = [-15, 90, 14, 0.4]);
paint("stone") fbox(-0.3, -0.3, 0, L + 0.6, W + 0.6, 2.2);          // stone base course
paint("platform") fbox(-15, -8, 0, 90, 8, 0.3);                      // street-side walk
steep_roof(); dormer(0); dormer(1); chimneys();
