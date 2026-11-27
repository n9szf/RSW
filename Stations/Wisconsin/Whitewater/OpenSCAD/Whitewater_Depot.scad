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
//  REV 8, 25 Nov 2026 - dormer sash from sheet 11 (14 Nov 1890): main lights
//    2'-8 1/2" tall: 3'-9 1/4" in the track tower and the street lower-stage
//    centre, 30 1/4" either side; the street tower has a 22 1/2" x 14 3/4".
//    The other 14 3/4" sash (3'-9 1/4", 30 1/4"), a 22 1/2" and the 12 3/8"
//    do not fit the dormer bodies as modelled - not placed (ESTIMATE).
//  REV 9, 25 Nov 2026 - dormer piers set 1 in proud of the stone bands: the
//    shared faces rendered black in Blender.
//  REV 11, 26 Nov 2026 - waiting-room FIREPLACE replaces the pot-belly stove: the
//    Whitewater Historical Society says the fireplace is in Jennings' plans and the
//    walls and ceiling had wide boxcar siding. Brick breast on the chimney's east
//    face, oak mantel, stone hearth, fire. Centre benches shortened to clear it.
//    Ladies' room stove kept (ESTIMATE). Details of the fireplace are a guess.
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
          ["platform", COL_PLAT], ["chimney", COL_BRICK], ["sash", COL_SASH],
          // 1890 interior (best guess, REV 10): varnished pine and oak, plaster, cast iron, brass, lamp glass
          ["embers", "#E0501A"], ["floor", "#B08A5A"], ["ceiling", "#A87C4C"], ["plaster", "#D9CBA6"], ["wainscot", "#6B4426"], ["woodwork", "#4A2E1A"],
          ["oak", "#9A6B3A"], ["iron", "#242424"], ["brass", "#B8923A"], ["lamp", "#FFE6B0"], ["clock", "#F2EDE0"], ["board", "#1C1C1C"]];

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
// dormer sash (sheet 11, Chicago 14 Nov 1890): main light 2'-8 1/2" with a 14 3/4" transom above
DW_H = 2.71; DW_T = 1.23;
module dwin(x, yf, s, z, w, h = DW_H) {         // s = +1 street face (looks -y), -1 track face (looks +y)
    translate([ft(x), ft(yf) - s * 0.06, 0]) rotate([90, 0, s > 0 ? 0 : 180]) window(w, h, z);
}
// tower: front face on yf, s = +1 (street, back is +y) or -1 (track, back is -y); ww = main window width
module dormer_tower(yf, s, zb, ww = 3.77, wh = DW_H, wz = 0.75) {
    tw = 10.4; zt = EAVE + 12.2; zap = EAVE + 19.5; d = 9; gw = 7.6;
    y0 = s > 0 ? yf : yf - d;
    paint("brick") fbox(DX - tw / 2, y0, zb, tw, d, zt - zb);
    paint("stone") for (z = [zb, zt - 0.7]) fbox(DX - tw / 2 - 0.1, y0 - (s > 0 ? 0.05 : 0), z, tw + 0.2, d + 0.05, 0.7);   // band face 0.05 behind the piers (no shared faces - they render black)
    // steep stone gable: a parapet 1 ft thick on the face, standing above the shared cross roof (dormer_link)
    gy = s > 0 ? yf : yf - 1.0;
    paint("stone") translate([ft(DX - gw / 2), ft(gy + 1.0), ft(zt)]) rotate([90, 0, 0]) linear_extrude(ft(1.0))
        polygon([[0, 0], [ft(gw), 0], [ft(gw / 2), ft(zap - zt)]]);
    for (x = [DX - tw / 2 + 0.9, DX + tw / 2 - 0.9]) pier(x, yf - s * 0.1 + s * 0.9, zb, zt);   // pier face at yf - 0.1
    dwin(DX, yf, s, zb + wz, ww, wh);                                                // sheet 11 sash
    paint("glass") translate([ft(DX), ft(yf - s * 0.08), ft(zt + 2.2)]) rotate([90, 0, 0]) cylinder(h = 0.3, r = ft(1.1), center = true, $fn = 24);   // trefoil light
}
module dormer_street() {                         // lower stage 17 ft wide, then the tower
    lw = 17; zb = EAVE + 4.5; zl = EAVE + 9.5; yf = -1.0; d = 10;
    paint("brick") fbox(DX - lw / 2, yf, zb, lw, d, zl - zb);
    paint("stone") { fbox(DX - lw / 2 - 0.1, yf - 0.1, zb, lw + 0.2, d + 0.1, 0.7);
                     fbox(DX - lw / 2 - 0.15, yf - 0.15, zl - 0.6, lw + 0.3, d + 0.15, 0.6); }
    paint("roof") hull() { fbox(DX - lw / 2, yf - 0.3, zl, lw, d, 0.3); fbox(DX - 5.2, yf + 1.2, zl + 0.6, 10.4, d - 1.2, 0.2); }
    for (x = [DX - lw / 2 + 0.9, DX + lw / 2 - 0.9]) pier(x, yf + 0.7, zb, zl);                  // pier face 0.05 in front of the bands
    dwin(DX, yf, 1, zb + 0.9, 3.77);                                                 // centre 3'-9 1/4" (sheet 11)
    for (k = [-1, 1]) dwin(DX + k * 5.2, yf, 1, zb + 0.9, 2.52);                     // sides 30 1/4"
    dormer_tower(yf + 1.2, 1, zl, 1.88, DW_T, 0.75);                                  // tower 22 1/2" x 14 3/4"
}
module dormer_track() dormer_tower(23.1, -1, EAVE + 8);      // tower only, higher on the roof (west elev.)
// the cross-gable roof joining the two towers (west elevation: ridge 28.1 ft above the platform)
XR = 28.1; module dormer_link() {             // Tom: the dormer roofs connect - one cross roof over both towers
    y0 = 0.2 + 0.9; y1 = 23.1 - 0.9; tw = 10.4; zt = EAVE + 12.2;   // one roof from parapet to parapet
    paint("brick") fbox(DX - tw / 2 + 0.2, y0, EAVE + 8, tw - 0.4, y1 - y0, zt - EAVE - 8);
    paint("roof") hull() { fbox(DX - tw / 2 - 0.4, y0, zt - 0.1, tw + 0.8, y1 - y0, 0.3);
                           fbox(DX - 0.25, y0, XR - 0.4, 0.5, y1 - y0, 0.4); }
}

// ---- the one chimney (sheets 01, 02, 03) -----------------------------------
CHX = L - 16.4; CHY = 12; CHS = 2.5; CHTOP = EAVE + RISE + 0.6 + 4.7;
module chimneys() {
    paint("chimney") { fbox(CHX - CHS / 2, CHY - CHS / 2, FLOOR, CHS, CHS, CHTOP - FLOOR - 1.7);   // from the floor (fireplace on its east face)
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

// ======================================================================
//  REV 10, 25 Nov 2026 - the 1890 INTERIOR (Tom: best guess, go over the top)
//  Room layout from sheet 06 (Plan of Ceiling showing paneling of the
//  waiting rooms, 3/4 in = 1 ft) and sheet 03 (foundation plan): general
//  waiting room 44 ft long (east part), then the chimney in the partition;
//  at the west end the ladies' waiting room on the street side and the
//  agent's office on the track side with the bay. Ceilings panelled boards
//  with coffers (sheet 06). Furnishing ESTIMATE (typical C.M.&St.P. 1890):
//  beadboard wainscot, plaster above, oak benches with iron ends, two
//  pot-belly stoves, brass kerosene lamps, clock, schedule board, ticket
//  windows, agent's desk and telegraph in the bay. Street doors open.
// ======================================================================
T = 1.1;                                          // brick wall thickness (13 in + plaster)
FLZ = FLOOR;                                      // floor top = door sill (1.5 ft above the platform)
CEIL = EAVE - 0.3;                                // ceiling underside
PX = L - 14.6;                                    // partition: general waiting room | west rooms (sheet 06)
OY = W - T - 6.0;                                 // partition: ladies' room | office (office 6 ft + bay)
WAIN = 4.0;                                       // wainscot height above the floor
module cutbox(x0, y0, z0, l, w, h) fbox(x0, y0, z0, l, w, h);
// openings through the outer walls for every window and door
module openings() {
    for (o = wins) let (x = o[0], s = o[1], w = o[2], h = o[3], z = o[4]) {
        if (s == 0) cutbox(x - w / 2, -1, z, w, T + 2, h);
        if (s == 1) cutbox(x - w / 2, W - T - 1, z, w, T + 2, h);
        if (s == 2) cutbox(-1, x - w / 2, z, T + 2, w, h);
        if (s == 3) cutbox(L - T - 1, x - w / 2, z, T + 2, w, h);
    }
    cutbox(DX - 2.5, -1, FLZ, 5, T + 2, 8.5 + 1.5);                  // street doors + transom
    cutbox(DX - 2.5, W - T - 1, FLZ, 5, T + 2, 8.5 + 1.5);           // track door + transom
    cutbox(L - T - 1, 10.3 - 1.6, FLZ, T + 2, 3.2, 8 + 1.5);         // west end door
    cutbox(BX + 0.7, W - T - 1, FLZ, L - T - BX - 0.7, T + 2, EAVE - 1.6 - FLZ);   // into the bay
}
module bay_inner() offset(delta = -ft(0.9)) polygon([for (p = BAY_PTS) [ft(p[0]), ft(p[1])]]);
module bay_cuts() {                               // the three bay windows, through the wall
    faces = [[BAY_PTS[0], BAY_PTS[3]], [BAY_PTS[3], BAY_PTS[2]], [BAY_PTS[2], BAY_PTS[1]]];
    for (f = faces) let (a = f[0], b = f[1], m = (a + b) / 2, ang = atan2(b[1] - a[1], b[0] - a[0]),
                         len = norm(b - a), ww = min(2.6, len - 1.6))
        translate([ft(m[0]), ft(m[1]), ft(3.8)]) rotate([0, 0, ang]) translate([-ft(ww / 2), -ft(2), 0]) cube([ft(ww), ft(4), ft(6.9)]);
}
module shell() {
    paint("brick") difference() {
        union() {
            fbox(0, 0, 0.5, L, W, EAVE - 0.5);
            translate([0, 0, ft(0.5)]) linear_extrude(ft(EAVE - 1.3)) polygon([for (p = BAY_PTS) [ft(p[0]), ft(p[1])]]);
        }
        fbox(T, T, 0.4, L - 2 * T, W - 2 * T, EAVE);
        translate([0, 0, ft(0.4)]) linear_extrude(ft(EAVE)) bay_inner();
        openings(); bay_cuts();
    }
    paint("foundation") fbox(0, 0, 0, L, W, 0.5);
    paint("stone") difference() {                                     // rock-faced base, now a ring
        union() { fbox(-0.3, -0.3, 0, L + 0.6, W + 0.6, 3.6);
                  linear_extrude(ft(3.6)) offset(delta = ft(0.25)) polygon([for (p = BAY_PTS) [ft(p[0]), ft(p[1])]]); }
        fbox(T, T, -0.1, L - 2 * T, W - 2 * T, 4);
        translate([0, 0, -ft(0.1)]) linear_extrude(ft(4)) bay_inner();
        openings(); bay_cuts();
    }
    // glass and sash on the outside faces (the builder's window), bay windows as before
    for (o = wins) on_face(BLK, o[0], o[1]) window(o[2], o[3], o[4]);
    faces = [[BAY_PTS[0], BAY_PTS[3]], [BAY_PTS[3], BAY_PTS[2]], [BAY_PTS[2], BAY_PTS[1]]];
    for (f = faces) let (a = f[0], b = f[1], m = (a + b) / 2, ang = atan2(b[1] - a[1], b[0] - a[0]),
                         len = norm(b - a), ww = min(2.6, len - 1.6))
        translate([ft(m[0]), ft(m[1]), 0]) rotate([0, 0, ang]) translate([0, 0.05, 0]) rotate([90, 0, 180]) window(ww, 6.9, 3.8);
    on_face(BLK, 10.3, 3) door(3.2, 8, 0);                          // west door, closed
    on_face(BLK, DX, 1) door_track(5, 8.5);                         // track door, closed
    on_face(BLK, DX, 0) translate([-ft(2.5), ft(FLZ), 0]) {         // street doors: frame and transom only - leaves open
        paint("trim") { for (x = [-ft(0.35), ft(5)]) translate([x, 0, 0]) cube([ft(0.35), ft(9.9), ft(0.25)]);
                        translate([-ft(0.35), ft(9.8), 0]) cube([ft(5.7), ft(0.35), ft(0.3)]); }
        paint("glass") translate([0, ft(8.7), 0]) cube([ft(5), ft(1), ft(0.08)]);
    }
    paint("doors") { fbox(DX - 2.5, T, FLZ, 0.17, 2.45, 8.5); fbox(DX + 2.33, T, FLZ, 0.17, 2.45, 8.5); }   // leaves swung in
}
// ---- interior ------------------------------------------------------------------
module room_ring(z0, z1, d = 0.06) difference() {        // a lining on the ROOM side of the outer walls (d thick)
    union() { fbox(T, T, z0, L - 2 * T, W - 2 * T, z1 - z0);
              translate([0, 0, ft(z0)]) linear_extrude(ft(z1 - z0)) bay_inner(); }
    fbox(T + d, T + d, z0 - 1, L - 2 * T - 2 * d, W - 2 * T - 2 * d, z1 - z0 + 2);
    translate([0, 0, ft(z0 - 1)]) linear_extrude(ft(z1 - z0 + 2)) offset(delta = -ft(d)) bay_inner();
    openings(); bay_cuts();
    fbox(BX + 0.7, W - T - 0.2, z0 - 1, L - T - BX - 0.7, 0.4, z1 - z0 + 2);     // no lining across the bay mouth
}
// partitions with their openings: [x0, y0, l, w] and cuts
module partitions_raw(th) {
    difference() {
        union() { fbox(PX - th / 2, T, FLZ, th, W - 2 * T, CEIL - FLZ);          // big room | west rooms
                  fbox(PX, OY - th / 2, FLZ, L - T - PX, th, CEIL - FLZ); }      // ladies' room | office
        fbox(PX - 1, 3.0, FLZ, 2, 3.2, 7.6);                                       // door, waiting room -> ladies' room
        fbox(PX - 1, 18.3, FLZ, 2, 2.7, 7.6);                                      // door, waiting room -> office
        fbox(PX - 1, 15.9, FLZ + 3.3, 2, 2.0, 2.2);                                // ticket window into the waiting room
        fbox(51.0, OY - 1, FLZ + 3.3, 2.0, 2, 2.2);                                // ticket window into the ladies' room
        fbox(CHX - CHS / 2 - 0.05, CHY - CHS / 2 - 0.05, 0, CHS + 0.1, CHS + 0.1, 40);   // chimney passes
    }
}
module interior() {
    // floors and ceilings
    paint("floor") { fbox(T, T, FLZ - 0.15, L - 2 * T, W - 2 * T, 0.15);
                     translate([0, 0, ft(FLZ - 0.15)]) linear_extrude(ft(0.15)) bay_inner();
                     fbox(BX + 0.7, W - T - 0.1, FLZ - 0.15, L - T - BX - 0.7, T + 0.2, 0.15); }
    paint("ceiling") { fbox(T, T, CEIL, L - 2 * T, W - 2 * T, 0.25);
                       translate([0, 0, ft(CEIL)]) linear_extrude(ft(0.25)) bay_inner(); }
    // ceiling panelling: border beams and coffer frames (sheet 06)
    paint("woodwork") {
        for (c = [[6.6, 21.6], [25.4, 40.7]]) difference() {                      // the two big coffers
            fbox(c[0] - 0.6, 5.0, CEIL - 0.45, c[1] - c[0] + 1.2, 12.2, 0.45);
            fbox(c[0], 5.6, CEIL - 1, c[1] - c[0], 11.0, 2); }
        difference() { fbox(PX + 2.6, 2.4, CEIL - 0.45, 8.6, 9.2, 0.45); fbox(PX + 3.2, 3.0, CEIL - 1, 7.4, 8.0, 2); }   // ladies' room coffer
        for (x = [T, PX - 0.25]) fbox(x, T, CEIL - 0.35, 0.3, W - 2 * T, 0.35);  // cornice beams
        fbox(T, T, CEIL - 0.35, L - 2 * T, 0.3, 0.35); fbox(T, W - T - 0.3, CEIL - 0.35, L - 2 * T, 0.3, 0.35);
        fbox(PX, OY - 0.35, CEIL - 0.35, L - T - PX, 0.7, 0.35);
    }
    // wall finish: dark beadboard wainscot with a cap rail, plaster above
    paint("wainscot") room_ring(FLZ, FLZ + WAIN, 0.08);
    paint("plaster") room_ring(FLZ + WAIN, CEIL, 0.06);
    paint("woodwork") { room_ring(FLZ + WAIN, FLZ + WAIN + 0.25, 0.14); room_ring(FLZ, FLZ + 0.5, 0.12); }   // cap rail, base board
    paint("plaster") partitions_raw(0.4);
    paint("wainscot") intersection() { partitions_raw(0.52); fbox(0, 0, FLZ, L, W, WAIN); }
    paint("woodwork") intersection() { partitions_raw(0.6); fbox(0, 0, FLZ + WAIN, L, W, 0.25); }
    // ticket windows: shelf on a bracket (sheet 08) and a brass grille
    for (tw = [[PX, 16.9, 0], [52.0, OY, 1]]) {
        if (tw[2] == 0) { paint("oak") fbox(PX - 1.2, 15.8, FLZ + 3.25, 2.4, 2.2, 0.12);
                          paint("brass") for (k = [0 : 6]) fbox(PX - 0.05, 16.0 + k * 0.3, FLZ + 3.4, 0.06, 0.04, 2.0); }
        else { paint("oak") fbox(50.9, OY - 1.2, FLZ + 3.25, 2.2, 2.4, 0.12);
               paint("brass") for (k = [0 : 6]) fbox(51.1 + k * 0.3, OY - 0.05, FLZ + 3.4, 0.04, 0.06, 2.0); }
    }
    // furniture
    for (b = [[4, 9.6, 21, 0], [4, 12.6, 21, 1], [31.5, 9.6, 6, 0], [31.5, 12.6, 6, 1]]) bench(b[0], b[1], b[2], b[3]);  // centre, back to back (REV 11: clear of the hearth)
    bench(T + 0.1, 4.5, 13, 3);                        // along the east wall
    for (x = [21.5, 36.5]) bench(x, T + 0.1, 5.5, 1);  // street wall between the window groups
    bench(L - T - 0.1, 2.0, 6.5, 2); bench(PX + 1.2, T + 0.1, 3.4, 1);   // ladies' room
    fireplace();                                       // REV 11: waiting-room fireplace (Jennings' plans)
    stove(PX + 3.0, 9.0, false);                       // ladies' room (ESTIMATE)
    for (lp = LAMPS) lamp(lp[0], lp[1]);
    // clock and schedule board on the partition, waiting-room side
    paint("woodwork") translate([ft(PX - 0.25), ft(8.5), ft(FLZ + 6.8)]) rotate([0, 90, 0]) cylinder(h = ft(0.15), r = ft(1.05), $fn = 32);
    paint("clock") translate([ft(PX - 0.32), ft(8.5), ft(FLZ + 6.8)]) rotate([0, 90, 0]) cylinder(h = ft(0.08), r = ft(0.9), $fn = 32);
    paint("board") fbox(PX - 0.3, 11.2 - 2.4, FLZ + 4.6, 0.1, 1.6, 1.8);
    paint("woodwork") fbox(PX - 0.27, 11.2 - 2.6, FLZ + 4.4, 0.06, 2.0, 2.2);
    // agent's office: desk in the bay with the telegraph, chair, cabinet
    paint("oak") { fbox(L - 9.0, W + 0.6, FLZ, 5.0, 1.8, 2.5); fbox(L - 9.0, W + 0.6, FLZ + 2.5, 5.0, 1.9, 0.12); }
    paint("brass") { fbox(L - 7.2, W + 0.9, FLZ + 2.62, 0.5, 0.3, 0.25); fbox(L - 6.3, W + 1.0, FLZ + 2.62, 0.35, 0.2, 0.12); }
    paint("oak") { fbox(L - 7.0, W - 1.4, FLZ, 1.5, 1.5, 1.5); fbox(L - 7.0, W - 1.5, FLZ + 1.5, 1.5, 0.15, 1.6); }
    paint("oak") fbox(L - T - 2.0, OY + 0.3, FLZ, 1.8, 3.0, 6.5);                // cabinet / ticket case
}
module bench(x, y, len, dir) {    // dir 0: along x, back on +y side; 1: along x, back on -y; 2: along y, back +x; 3: along y, back -x
    rot = dir == 0 ? 0 : dir == 1 ? 180 : dir == 2 ? 90 : -90;
    x0 = dir == 1 ? x + len : dir == 3 ? x : x; y0 = dir == 1 ? y : dir == 2 ? y : dir == 3 ? y + len : y;
    translate([ft(dir == 1 ? x + len : x), ft(dir == 3 ? y + len : y), ft(FLZ)]) rotate([0, 0, rot]) {
        paint("oak") { translate([0, -ft(1.55), ft(1.45)]) cube([ft(len), ft(1.5), ft(0.12)]);          // seat
                       translate([0, -ft(0.12), ft(1.7)]) rotate([-12, 0, 0]) cube([ft(len), ft(0.1), ft(1.3)]); }   // back
        paint("iron") for (k = [0 : max(1, floor(len / 5))]) let (u = min(k * 5, len - 0.15))
            translate([ft(u), -ft(1.6), 0]) cube([ft(0.15), ft(1.6), ft(1.45)]);                       // cast ends / legs
        paint("iron") for (k = [0 : max(1, floor(len / 5))]) let (u = min(k * 5, len - 0.15))
            translate([ft(u), -ft(1.6), ft(2.0)]) cube([ft(0.15), ft(1.5), ft(0.12)]);                  // arm rests
    }
}
module fireplace() {             // on the east face of the chimney, facing the general waiting room
    x0 = CHX - CHS / 2;                                                   // chimney east face
    paint("chimney") difference() {
        fbox(x0 - 1.25, CHY - 2.5, FLZ, 1.3, 5.0, 5.0);                  // brick breast 5 ft wide
        fbox(x0 - 1.4, CHY - 1.3, FLZ - 0.1, 1.2, 2.6, 2.8);             // fire opening 2'-7" x 2'-8"
    }
    paint("iron") { fbox(x0 - 0.25, CHY - 1.3, FLZ, 0.1, 2.6, 2.7);       // fire back
                    fbox(x0 - 1.3, CHY - 1.4, FLZ + 2.65, 0.08, 2.8, 0.2);   // iron lintel
                    for (y = [CHY - 0.9, CHY + 0.9]) fbox(x0 - 0.9, y - 0.05, FLZ, 0.5, 0.1, 0.4); }   // andirons
    paint("oak") { fbox(x0 - 1.55, CHY - 2.8, FLZ + 5.0, 1.6, 5.6, 0.22);                    // mantel shelf
                   fbox(x0 - 1.45, CHY - 2.6, FLZ + 4.45, 0.2, 5.2, 0.55);                   // frieze
                   for (y = [CHY - 2.6, CHY + 2.15]) fbox(x0 - 1.45, y, FLZ, 0.2, 0.45, 4.45);   // pilasters
                   fbox(x0 - 1.4, CHY - 2.3, FLZ + 5.22, 0.15, 4.6, 2.2); }                  // overmantel board
    paint("stone") fbox(x0 - 3.0, CHY - 2.8, FLZ, 1.75, 5.6, 0.08);       // hearth
    paint("woodwork") for (y = [CHY - 0.6, CHY + 0.1]) translate([ft(x0 - 0.75), ft(y), ft(FLZ + 0.55)]) rotate([-90, 0, 0]) cylinder(h = ft(0.6), r = ft(0.18), $fn = 10);   // logs
    paint("embers") fbox(x0 - 0.85, CHY - 0.8, FLZ + 0.42, 0.5, 1.6, 0.16);  // glowing embers under the logs (the movie adds flames)
}
module stove(x, y, big) {
    r = big ? 1.1 : 0.85; h = big ? 3.4 : 2.9;
    paint("iron") translate([ft(x), ft(y), ft(FLZ)]) {
        for (a = [45 : 90 : 315]) rotate([0, 0, a]) translate([ft(r * 0.7), 0, 0]) cylinder(h = ft(0.6), r = ft(0.1), $fn = 8);   // legs
        translate([0, 0, ft(0.6)]) cylinder(h = ft(0.3), r = ft(r * 0.9), $fn = 32);
        translate([0, 0, ft(0.9)]) cylinder(h = ft(h * 0.55), r1 = ft(r * 0.85), r2 = ft(r), $fn = 32);   // pot belly
        translate([0, 0, ft(0.9 + h * 0.55)]) cylinder(h = ft(h * 0.3), r1 = ft(r), r2 = ft(r * 0.7), $fn = 32);
        translate([0, 0, ft(0.9 + h * 0.85)]) cylinder(h = ft(0.25), r = ft(r * 0.8), $fn = 32);        // top
        translate([0, 0, ft(0.9 + h * 0.85)]) cylinder(h = ft(big ? 0.1 : CEIL - FLZ - 1.2 - h * 0.85), r = ft(0.25), $fn = 16);   // pipe
    }
    paint("iron") translate([ft(x - 1.8), ft(y - 1.8), ft(FLZ)]) cube([ft(3.6), ft(3.6), ft(0.03)]);       // stove board
}
// hanging brass kerosene lamps: [x, y] (lights in Blender at the same places)
LAMPS = [[9, 11.1], [20, 11.1], [31, 11.1], [40, 11.1], [PX + 6.9, 7.0], [L - 6.5, 19.0]];
module lamp(x, y) {
    translate([ft(x), ft(y), 0]) {
        paint("brass") { translate([0, 0, ft(CEIL - 3.2)]) cylinder(h = ft(3.2), r = ft(0.04), $fn = 8);          // rod
                         translate([0, 0, ft(CEIL - 3.9)]) cylinder(h = ft(0.6), r1 = ft(0.15), r2 = ft(0.45), $fn = 24);   // font
                         translate([0, 0, ft(CEIL - 3.25)]) cylinder(h = ft(0.08), r = ft(0.9), $fn = 32); }      // smoke bell rim
        paint("lamp") translate([0, 0, ft(CEIL - 3.3)]) cylinder(h = ft(0.6), r1 = ft(0.35), r2 = ft(0.25), $fn = 24);   // lit chimney / shade
    }
}
shell(); interior();
QX = [0, 5.2, 18.6, 25.4, 32.2, 39.6, L - 1.4];   // symmetric
QXT = [for (x = [15.4, 22.4, 24.9, 33.6, 39.4, 46.0, 52.4, 58.8]) L - x - 1.4];   // from the west end
paint("stone") for (x = QX) fbox(x, -0.25, 3.6, 1.4, 0.3, EAVE - 3.6 - 0.8);
paint("stone") for (x = QXT) fbox(x, W - 0.05, 3.6, 1.4, 0.3, EAVE - 3.6 - 0.8);
paint("stone") for (y = [0, W - 1.4], x = [-0.25, L - 0.05]) fbox(x, y, 3.6, 0.3, 1.4, EAVE - 3.6 - 0.8);
paint("platform") { fbox(-15, -8, 0, 90, 8, 0.3); fbox(-15, W, 0, 90, 14, 0.4); }   // street-side walk, track platform
steep_roof(); dormer_street(); dormer_track(); dormer_link(); chimneys(); brackets();
