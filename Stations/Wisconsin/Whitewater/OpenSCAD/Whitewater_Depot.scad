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
//  COLOURS: measured from photos 24 Nov 2026 (see below).
//  ESTIMATE: dormer detail.
//  REV 25 Nov 2026: Tom - shape stays on the 1890 plans (bay, chimneys,
//    dormer as scaled off the sheets). Photos used only for colour:
//    - two door colours: street doors dark brown (photos 2013 on); track-side
//      door buff (last seen buff 2012 - ESTIMATE until the road trip).
//    - PAINTS adds "door_track". GLB colours need make_glb.py of 25 Nov 2026
//      (station colours win over the builder defaults).
//  REV 2, 25 Nov 2026 - re-measured off the 1890 sheets (01 N and W elev.,
//    02 S elev., 03 foundation plan; scans 49.8 px/ft both ways - eave
//    underside to platform reads 11'-3").
//    The first model had the chimney and bay mirrored:
//    - ONE chimney, 16.4 ft from the west end, y 12 (plan flue in the
//      interior wall), 2.5 ft square, top 4.7 ft above the roof's flat top.
//    - canted operator's bay on the TRACK side at the WEST end: 15 ft 4 in
//      long (4-6 3/4, 6-2 1/2, 4-6 3/4), projecting 2 ft 8 7/8 in, one window
//      per face (sheet 03 plan, sheet 02 south elev.).
//    - street dormer in two stages: lower 17 ft wide with corner piers and
//      pinnacles, upper tower 10.4 ft wide with pinnacles and a steep stone
//      gable, apex 19.5 ft above the eave. Track dormer is the tower only.
//    - the two dormer towers are JOINED by a cross-gable roof over the main
//      roof, ridge 28.1 ft above the platform (west elevation, photos).
//    - roof flat top 25.9 ft above the platform (RISE 14.05, was 16.3).
//    - track side: bay, window at 20.1, door at 30, windows at 42.3 and 50.7.
//    - end posts at y -2.4, 10.9, 23.7, 6.8 ft out from the ends (sheet 01); no posts along the track
//      side - brackets carry the 12 ft overhang (sheet 05).
//  REV 4, 25 Nov 2026 - brackets from sheet 05 (Details of Brackets, 1 1/2 in
//    = 1 ft): A 8'-10 1/2" reach, arc radius 8'-2" (track side and ends);
//    B 12'-7 3/4" diagonal, radius 15'-7" (track corners); C 5'-10 1/2"
//    diagonal, radius 5'-1 1/2" (street corners); D 4'-1 1/2" reach, radius
//    6'-5" (street side). Truss detail simplified: top beam, lower chord,
//    two posts, wall leg and the curved arm. Positions at the pilasters and
//    mullions - ESTIMATE where the sheets do not place them.
//  REV 5, 25 Nov 2026 - end posts removed (Tom): drawn on sheet 01 but
//    replaced by the sheet 05 corner brackets; no footings, no photos.
//  REV 7, 25 Nov 2026 - ends from the end elevations: west end one door
//    (3'-2 1/4", 10.3 ft from the street face, transom), no windows; east
//    end no door, four small high windows (pair at y 5.0 and 7.2, singles at
//    12.4 and 18.4; sill 6.1 ft, 4 ft tall).
//  REV 6, 25 Nov 2026 - cresting and finials from sheet 10 (wood, Aug 1890):
//    scrolled-leaf crest 1.34 ft tall, repeat 1.53 ft, balls on the top rail;
//    turned finial. Tom: small - sheet 10 at true full size, 15 in base,
//    18 1/2 in tall (FIN_K). Cresting also full size (CR_K): 9 in tall,
//    10 in repeat.
//
//  x along the track from the EAST end (with y = 0 north and z up this is
//  the right way round; positions below were measured from the west end
//  and are entered as L - x); y = 0 north (street) wall,
//  y = 22.2 south (track) wall; z = 0 platform level.
// =====================================================================
SCALE = 29;
// new colour names go ABOVE the include (OpenSCAD evaluates PAINTS where the builder first sets it)
COL_DOOR_TK = "#B8A07A"; // track-side door buff (2012 photos; ESTIMATE for today)
include <../../../_common/rsw_depot.scad>
// COLOURS MEASURED 24 Nov 2026 from photos (reference / Station photos web /
// Whitewater: WHS 222350 sunlit dormer, WHS 222348 track side, HMdb 636760
// street side, Wikipedia 2013). These are the post-2012 restoration colours.
COL_BRICK = "#7E3C2E";   // smooth red ("vermillion") pressed brick, sunlit median
COL_STONE = "#9C866A";   // rock-faced buff sandstone base, quoins, dormer gables
COL_FOUND = "#9C866A";
COL_TRIM  = "#B8A07A";   // brackets, posts, fascia, cresting - buff paint
COL_ROOF  = "#6A5350";   // brown asphalt shingles (2012 re-roof)
COL_SASH  = "#2E1F1A";   // dark brown window sash
COL_DOOR  = "#4B3A33";   // street doors dark brown (photos 2013 on)
// Builder paint list plus the track-side door.
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["door_track", COL_DOOR_TK], ["foundation", COL_FOUND],
          ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH]];

L = 60.2; W = 22.2; EAVE = 11.25;
ovN = 5; ovS = 12; ovE = 12;                    // overhangs
RISE = 14.05;                                   // sheet 01 re-measured 25 Nov: flat top 25.9 ft above the platform (was 16.3)
ex0 = -ovE; ex1 = L + ovE; ey0 = -ovN; ey1 = W + ovS;
ry = (ey0 + ey1) / 2; slope = RISE / ((ey1 - ey0) / 2);
rx0 = ex0 + (ey1 - ey0) / 2; rx1 = ex1 - (ey1 - ey0) / 2;   // ridge (flat top) ends
DX = 30.1;                                       // dormer and centre doors (sheets 01, 02)
function roof_z(y) = EAVE + slope * min(y - ey0, ey1 - y);   // roof surface height at y

// windows [x, side, w, h, sill]: street side (0) as before; track side (1) from sheet 02
wins = [for (x = [8.8, 13.0, 17.1, 42.5, 46.6, 50.7]) [L - x, 0, 2.8, 6.9, 3.8],   // sheet 01, from the west end
        for (x = [20.1, 42.3, 50.7]) [L - x, 1, 2.9, 6.9, 3.8],                      // sheet 02, from the west end
        // east end (side 2, x = 0): four small high windows, sill 6.1, 4 ft tall (sheet 02 east elev.)
        [5.0, 2, 1.4, 4.0, 6.1], [7.2, 2, 1.4, 4.0, 6.1], [12.4, 2, 1.7, 4.0, 6.1], [18.4, 2, 2.1, 4.0, 6.1]];
doors = [[DX, 0, 5, 8.5, 1], [10.3, 3, 3.2, 8, 0]];   // west end (side 3): one door, no windows (sheet 01 west elev.)   // track-side door drawn below (own colour)
BLK = [0, L, 0, W, EAVE, 0, 5, 0, 2];
module door_track(w, h) {                        // the builder's door, painted "door_track"
    translate([-ft(w) / 2, ft(FLOOR), 0]) {
        paint("door_track") cube([ft(w), ft(h), ft(0.15)]);
        paint("door_track") translate([ft(w) / 2 - ft(0.07), 0, 0]) cube([ft(0.14), ft(h), ft(0.25)]);
        paint("trim") {
            for (x = [-ft(0.35), ft(w)]) translate([x, 0, 0]) cube([ft(0.35), ft(h + 1.4), ft(0.25)]);
            translate([-ft(0.35), ft(h + 1.3), 0]) cube([ft(w + 0.7), ft(0.35), ft(0.3)]);
        }
        paint("glass") translate([0, ft(h + 0.2), 0]) cube([ft(w), ft(1), ft(0.08)]);
    }
}

// ---- operator's bay: track side, west end (sheet 03 plan) --------------------
BAY_L = 15.35; BAY_RUN = 4.56; BAY_D = 2.74;     // along the wall, each cant, projection
BX = L - BAY_L;                                  // bay runs from here to the west corner (x = L)
BAY_PTS = [[BX, W], [L, W], [L - BAY_RUN, W + BAY_D], [BX + BAY_RUN, W + BAY_D]];
module bay_track() {
    hz = EAVE - 0.8;
    paint("brick") translate([0, 0, ft(0.5)]) linear_extrude(ft(hz - 0.5)) polygon([for (p = BAY_PTS) [ft(p[0]), ft(p[1])]]);
    paint("stone") translate([0, 0, 0]) linear_extrude(ft(3.6)) offset(delta = ft(0.25)) polygon([for (p = BAY_PTS) [ft(p[0]), ft(p[1])]]);
    // one window per face: centre of face, face angle
    faces = [[BAY_PTS[0], BAY_PTS[3]], [BAY_PTS[3], BAY_PTS[2]], [BAY_PTS[2], BAY_PTS[1]]];
    for (f = faces) let (a = f[0], b = f[1], m = (a + b) / 2, ang = atan2(b[1] - a[1], b[0] - a[0]),
                         len = norm(b - a), ww = min(2.6, len - 1.6))
        translate([ft(m[0]), ft(m[1]), 0]) rotate([0, 0, ang]) translate([0, 0.05, 0]) rotate([90, 0, 180]) window(ww, 6.9, 3.8);
}

// ---- cresting and finial (sheet 10, full size; scaled so the finial base = 2.3 ft as on sheet 01) ----
CR_REP = 1.53;                                   // pattern repeat along the ridge (ft)
CR_T = 0.15;                                     // thickness
CR_K = 0.557;                                    // Tom 25 Nov: sheet 10 at true full size - crest 9 in tall, repeat 10 in
module crest_motif() {                           // one breaking-wave leaf with its inner curl, 0..CR_REP x 0..0.67
    polygon([[0, 0], [0.22, 0.12], [0.45, 0.3], [0.75, 0.5], [1.05, 0.64], [1.47, 0.71],
             [1.22, 0.58], [0.98, 0.46], [0.86, 0.32], [0.88, 0.14], [1.0, 0]]);
    polygon([[0.42, 0], [0.55, 0.16], [0.72, 0.27], [0.62, 0.12], [0.6, 0]]);          // inner curl
    translate([CR_REP, 0.05]) circle(r = 0.07, $fn = 12);                                // small ball (overlaps the moulding)
}
module crest2d(len) {
    n = floor(len / CR_REP);
    translate([0, 0]) square([len, 0.3]);                                                // bottom moulding
    translate([0, 0.97]) square([len, 0.22]);                                            // top rail
    intersection() { translate([0, 0.28]) square([len, 0.71]);                          // overlaps both rails
                     for (i = [0 : n]) translate([i * CR_REP, 0.28]) crest_motif(); }
    for (i = [0 : n]) if (i * CR_REP + 0.55 < len - 0.1) translate([i * CR_REP + 0.55, 1.24]) circle(r = 0.07, $fn = 12);   // balls on the top rail (overlap it)
}
module cresting(x0, x1) {
    if (x1 > x0) paint("trim") translate([ft(x0), ft(ry), ft(EAVE + RISE + 0.6)]) rotate([90, 0, 0])
        linear_extrude(ft(CR_T), center = true) scale(ft(CR_K)) crest2d((x1 - x0) / CR_K);
}
FIN_K = 0.557;                                   // Tom 25 Nov: small - sheet 10 at true full size (base 15 in, 18 1/2 in tall)
module finial(x, y, z) {                         // turned wood finial: flange, torus, bell, ring, onion
    paint("trim") translate([ft(x), ft(y), ft(z)]) scale(ft(FIN_K)) rotate_extrude($fn = 32)
        polygon([[0, 0], [1.15, 0], [1.15, 0.04], [1.05, 0.1], [1.08, 0.18], [1.02, 0.3], [0.98, 0.32],
                 [0.8, 0.45], [0.6, 0.65], [0.42, 0.95], [0.3, 1.3], [0.2, 1.7], [0.155, 1.97],
                 [0.2, 2.0], [0.2, 2.24], [0.25, 2.28], [0.32, 2.38], [0.34, 2.46], [0.3, 2.56],
                 [0.18, 2.68], [0, 2.77]]);
}

module steep_roof() {
    paint("roof") hull() {
        fbox(ex0, ey0, EAVE, ex1 - ex0, ey1 - ey0, 0.6);
        fbox(rx0, ry - 0.5, EAVE + RISE, rx1 - rx0, 1, 0.6);
    }
    paint("trim") fbox(ex0, ey0, EAVE - 0.8, ex1 - ex0, ey1 - ey0, 0.8);                      // deep fascia
    // cresting and finials: sheet 10 (Chicago, 20 Aug 1890, "change to wood")
    cresting(rx0 + 0.75, DX - 5.6); cresting(DX + 5.6, rx1 - 0.75);      // the cross roof cuts through the middle
    for (x = [rx0, rx1]) finial(x, ry, EAVE + RISE + 0.6);
    // no posts: sheet 01 draws end posts, but sheet 05 (a day later) carries the ends and corners on
    // brackets, sheet 03 shows no post footings and no photo shows posts. Removed 25 Nov 2026 (Tom) - ESTIMATE.
}

// ---- dormers (sheets 01, 02, 03) ------------------------------------------------
// pier with a stone pyramid cap
module pier(x, y, z0, z1, s = 1.8) {
    paint("brick") fbox(x - s / 2, y - s / 2, z0, s, s, z1 - z0);
    paint("stone") { fbox(x - s / 2 - 0.15, y - s / 2 - 0.15, z1, s + 0.3, s + 0.3, 0.5);
                     translate([ft(x), ft(y), ft(z1 + 0.5)]) rotate([0, 0, 45]) cylinder(h = ft(2.2), r1 = ft(s * 0.72), r2 = 0, $fn = 4); }
}
// tower: front face on yf, s = +1 (street, back is +y) or -1 (track, back is -y)
module dormer_tower(yf, s, zb) {
    tw = 10.4; zt = EAVE + 12.2; zap = EAVE + 19.5; d = 9; gw = 7.6;
    y0 = s > 0 ? yf : yf - d;
    paint("brick") fbox(DX - tw / 2, y0, zb, tw, d, zt - zb);
    paint("stone") for (z = [zb, zt - 1.2]) fbox(DX - tw / 2 - 0.1, y0 - (s > 0 ? 0.1 : 0), z, tw + 0.2, d + 0.1, 0.7);
    paint("stone") translate([ft(DX - gw / 2), ft(y0 + d), ft(zt)]) rotate([90, 0, 0]) linear_extrude(ft(d))
        polygon([[0, 0], [ft(gw), 0], [ft(gw / 2), ft(zap - zt)]]);                               // steep stone gable
    paint("roof") for (k = [-1, 1]) hull() { fbox(DX + k * gw / 2 - 0.25, y0, zt - 0.1, 0.5, d, 0.4);
                                           fbox(DX - 0.25, y0, zap - 0.2, 0.5, d, 0.4); }
    for (x = [DX - tw / 2 + 0.9, DX + tw / 2 - 0.9]) pier(x, yf - s * 0.1 + s * 0.9, zb, zt);
    paint("glass") for (k = [-1, 1]) fbox(DX + k * 0.85 - 0.7, yf - s * 0.08, zb + 1.2, 1.4, 0.06, 3.6);     // centre pair
    paint("glass") translate([ft(DX), ft(yf - s * 0.08), ft(zt + 2.2)]) rotate([90, 0, 0]) cylinder(h = 0.3, r = ft(1.1), center = true, $fn = 24);   // trefoil light
}
module dormer_street() {                         // lower stage 17 ft wide, then the tower
    lw = 17; zb = EAVE + 4.5; zl = EAVE + 9.5; yf = -1.0; d = 10;
    paint("brick") fbox(DX - lw / 2, yf, zb, lw, d, zl - zb);
    paint("stone") { fbox(DX - lw / 2 - 0.1, yf - 0.1, zb, lw + 0.2, d + 0.1, 0.7);
                     fbox(DX - lw / 2 - 0.15, yf - 0.15, zl - 0.6, lw + 0.3, d + 0.15, 0.6); }
    paint("roof") hull() { fbox(DX - lw / 2, yf - 0.3, zl, lw, d, 0.3); fbox(DX - 5.2, yf + 1.2, zl + 1.6, 10.4, d - 1.2, 0.2); }
    for (x = [DX - lw / 2 + 0.9, DX + lw / 2 - 0.9]) pier(x, yf + 0.8, zb, zl);
    paint("glass") { for (k = [-1, 1]) fbox(DX + k * 0.85 - 0.7, yf - 0.08, zb + 1.0, 1.4, 0.06, 3.4);
                     for (k = [-1, 1]) fbox(DX + k * 5.6 - 0.6, yf - 0.08, zb + 1.0, 1.2, 0.06, 3.0); }
    dormer_tower(yf + 1.2, 1, zl);
}
module dormer_track() dormer_tower(23.1, -1, EAVE + 8);      // tower only, higher on the roof (west elev.)
// the cross-gable roof joining the two towers (west elevation: ridge 28.1 ft above the platform)
XR = 28.1; module dormer_link() {
    y0 = 0.2; y1 = 23.1; tw = 10.4; zt = EAVE + 12.2;
    paint("brick") fbox(DX - tw / 2 + 0.2, y0, EAVE + 8, tw - 0.4, y1 - y0, zt - EAVE - 8);
    paint("roof") hull() { fbox(DX - tw / 2 - 0.4, y0, zt - 0.1, tw + 0.8, y1 - y0, 0.3);
                           fbox(DX - 0.25, y0, XR - 0.4, 0.5, y1 - y0, 0.4); }
}

// ---- the one chimney (sheets 01, 02, 03) -----------------------------------
CHX = L - 16.4; CHY = 12; CHS = 2.5; CHTOP = EAVE + RISE + 0.6 + 4.7;
module chimneys() {
    paint("chimney") { fbox(CHX - CHS / 2, CHY - CHS / 2, 6, CHS, CHS, CHTOP - 6 - 1.7);
                       fbox(CHX - CHS / 2 - 0.25, CHY - CHS / 2 - 0.25, CHTOP - 3.0, CHS + 0.5, CHS + 0.5, 0.5); }   // corbel
    paint("stone") { fbox(CHX - CHS / 2 - 0.1, CHY - CHS / 2 - 0.1, CHTOP - 1.7, CHS + 0.2, CHS + 0.2, 1.2);      // stone cap
                     fbox(CHX - CHS / 2 - 0.3, CHY - CHS / 2 - 0.3, CHTOP - 0.5, CHS + 0.6, CHS + 0.6, 0.5); }
}

// ---- brackets (sheet 05) ------------------------------------------------------
// drawn in the x-z plane: x out from the wall, z down from the soffit (0); thickness along y
BT = 0.33;                                       // bracket timber thickness (4 in)
function arc_c(p1, p2, r) = let (m = (p1 + p2) / 2, d = p2 - p1, c = norm(d), rr = max(r, c / 2 * 1.02),
                                  n = [d[1], -d[0]] / c, h = sqrt(rr * rr - c * c / 4)) [m + n * h, rr];
module bracket2d(R, H, r) {
    p1 = [0.25, -H]; p2 = [R - 0.2, -0.45];
    cr = arc_c(p1, p2, r); c = cr[0]; rr = cr[1];
    a1 = atan2(p1[1] - c[1], p1[0] - c[0]); a2 = atan2(p2[1] - c[1], p2[0] - c[0]);
    da = (a2 - a1 + 540) % 360 - 180;            // shortest way round
    union() {
        translate([0, -0.55]) square([R, 0.55]);                         // top beam under the rafters
        translate([0, -1.95]) square([R * 0.62, 0.45]);                  // lower chord
        for (u = [R * 0.22, R * 0.45]) translate([u, -1.95]) square([0.3, 1.5]);   // posts
        translate([0, -H]) square([0.5, H]);                             // wall leg
        polygon(concat([for (i = [0 : 24]) let (a = a1 + da * i / 24) c + [cos(a), sin(a)] * (rr + 0.17)],
                       [for (i = [24 : -1 : 0]) let (a = a1 + da * i / 24) c + [cos(a), sin(a)] * (rr - 0.17)]));
    }
}
module bracket(x, y, ang, R, H, r) {               // wall point (x, y), outward direction ang
    paint("trim") translate([ft(x), ft(y), ft(EAVE - 0.8)]) rotate([0, 0, ang]) rotate([90, 0, 0])
        linear_extrude(ft(BT), center = true) scale(ft(1)) bracket2d(R, H, r);
}
BR_A = [8.9, 7.5, 8.17]; BR_B = [12.65, 7.6, 15.6]; BR_C = [5.9, 7.1, 5.13]; BR_D = [4.1, 6.5, 6.4];
// track side (y = W): pilasters (from QXT) and on the bay front; ends: three per end; street: pilasters and mullions
TRACK_X = [7.1, 13.5, 20.1, 25.9, 34.6, 37.1, 44.1];
BAYF_X = [L - 6.5, L - 9.6];                     // on the bay's front face (2 ft 9 in out)
STREET_X = [5.9, 9.5 + 2.05, 13.6 + 2.05, 19.3, 26.1, 32.9, 40.3, 43.1 + 2.05, 47.2 + 2.05, 54.5];
END_Y = [2.6, 11.1, 19.6];
module brackets() {
    for (x = TRACK_X) bracket(x, W, 90, BR_A[0], BR_A[1], BR_A[2]);
    for (x = BAYF_X) bracket(x, W + BAY_D, 90, BR_A[0] - BAY_D, BR_A[1], BR_A[2] - BAY_D);
    for (y = END_Y) { bracket(0, y, 180, BR_A[0], BR_A[1], BR_A[2]); bracket(L, y, 0, BR_A[0], BR_A[1], BR_A[2]); }
    for (x = STREET_X) bracket(x, 0, -90, BR_D[0], BR_D[1], BR_D[2]);
    bracket(0, W, 135, BR_B[0], BR_B[1], BR_B[2]); bracket(L, W, 45, BR_B[0], BR_B[1], BR_B[2]);
    bracket(0, 0, -135, BR_C[0], BR_C[1], BR_C[2]); bracket(L, 0, -45, BR_C[0], BR_C[1], BR_C[2]);
}

depot(blocks = [[0, L, 0, W, EAVE, 0, 5, 0, 2]], wins = wins, doors = doors, plat = [-15, 90, 14, 0.4]);
bay_track();
paint("stone") fbox(-0.3, -0.3, 0, L + 0.6, W + 0.6, 3.6);          // rock-faced stone base to sill height (photos)
// rock-faced stone quoins / pilasters (street side as photos; track side from sheet 02)
QX = [0, 5.2, 18.6, 25.4, 32.2, 39.6, L - 1.4];   // symmetric
QXT = [for (x = [15.4, 22.4, 24.9, 33.6, 39.4, 46.0, 52.4, 58.8]) L - x - 1.4];   // from the west end
paint("stone") for (x = QX) fbox(x, -0.25, 3.6, 1.4, 0.3, EAVE - 3.6 - 0.8);
paint("stone") for (x = QXT) fbox(x, W - 0.05, 3.6, 1.4, 0.3, EAVE - 3.6 - 0.8);
paint("stone") for (y = [0, W - 1.4], x = [-0.25, L - 0.05]) fbox(x, y, 3.6, 0.3, 1.4, EAVE - 3.6 - 0.8);
paint("platform") fbox(-15, -8, 0, 90, 8, 0.3);                      // street-side walk
on_face(BLK, DX, 1) door_track(5, 8.5);
steep_roof(); dormer_street(); dormer_track(); dormer_link(); chimneys(); brackets();
