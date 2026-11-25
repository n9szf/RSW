// =====================================================================
//  rsw_depot.scad - shared builder for Milwaukee Road (C.M.&St.P.) depots
//  Rib Side Works, 24 Nov 2026.  First-shape models from the 1919 Album of
//  Depot Plans and the MPL station drawings.  NOT cut into print sections.
//
//  A station file sets SCALE (29 G, 48 O, 87 HO) and calls depot(...) with
//  data in FEET.  x = along the track, y = 0 is the TOWN side, the TRACK
//  side is +y.  z = 0 is grade.
//
//  Colour: PAINTS / paint() follow the RSW convention, so make_glb.py and
//  station_glb.py build the .glb in colour (one piece per paint, exported
//  with -D PAINT="<name>").  PAINT = "" draws everything.
//
//  Data formats
//   blocks : [x0, len, y0, wid, plate_h, rise_per_ft, roof, overhang, siding]
//            roof 0 hip, 1 gable (ridge along x), 2 gable (ridge along y),
//                 3 hip with bell-cast kick at the eave, 4 flat (tar and gravel), 5 none (station file draws its own)
//            siding 0 lap/drop siding, 1 stucco, 2 brick, 3 stone
//   pavs   : [x0, len, y0, wid, plate_h, rise_per_ft, roof, overhang, posts_x, posts_y]
//            open pavilion on posts (roof as blocks)
//   wins   : [x, side, w, h, sill, blk]   side 0 town, 1 track, 2 x-min end, 3 x-max end
//            x is the centre along that wall (for ends: y); blk = block index (default the main block)
//   doors  : [x, side, w, h, type, blk]   type 0 passenger, 1 double/baggage, 2 freight slider
//   bays   : [x, side, w, d, blk]         three-sided operator's bay
//   chims  : [x, y, top_z]
//   plat   : [x0, len, wid, height] platform along the track side (0 = none)
// =====================================================================

PAINT = "";
COL_BODY  = "#B9A36F";   // Milwaukee Road depot body (ESTIMATE - to confirm with MRHA, TDQ)
COL_TRIM  = "#5A3B22";   // trim, brackets, corner boards
COL_ROOF  = "#4E4A46";   // shingles
COL_STUC  = "#D8CDB2";   // stucco / cement plaster
COL_BRICK = "#8E4A36";
COL_STONE = "#9A8F7E";
COL_GLASS = "#3F5866";
COL_DOOR  = "#4A2E1C";
COL_FOUND = "#A8A398";
COL_PLAT  = "#8E8A84";
PAINTS = [["walls", COL_BODY], ["stucco", COL_STUC], ["brick", COL_BRICK], ["stone", COL_STONE], ["trim", COL_TRIM],
          ["roof", COL_ROOF], ["glass", COL_GLASS], ["doors", COL_DOOR], ["foundation", COL_FOUND], ["platform", COL_PLAT], ["chimney", COL_BRICK]];
module paint(n) { if (PAINT == "" || PAINT == n) color([for (p = PAINTS) if (p[0] == n) p[1]][0]) children(); }

function ft(v) = v * 304.8 / SCALE;
module fbox(x, y, z, l, w, h) { translate([ft(x), ft(y), ft(z)]) cube([ft(l), ft(w), ft(h)]); }

FLOOR = 1.5;    // floor above grade (ft) unless a station sets it
WAIN  = 4;      // wainscot / belt height above the floor

// ---- roofs -----------------------------------------------------------
// solid roof shell: hull of the eave outline and the ridge
module roof_solid(x0, l, y0, w, eave, rise, kind, t = 0.6) {
    run = (kind == 2 ? l : w) / 2;
    ridge = eave + rise * run;
    if (kind == 4) fbox(x0, y0, eave, l, w, t * 1.5);
    else if (kind == 1) for (s = [0, 1]) hull() {          // two slopes, open gable ends
        fbox(x0, s ? y0 + w - 0.1 : y0, eave, l, 0.1, t); fbox(x0, y0 + w / 2 - 0.05, ridge, l, 0.1, t); }
    else if (kind == 2) for (s = [0, 1]) hull() {
        fbox(s ? x0 + l - 0.1 : x0, y0, eave, 0.1, w, t); fbox(x0 + l / 2 - 0.05, y0, ridge, 0.1, w, t); }
    else hull() {
        fbox(x0, y0, eave, l, w, t);
        if (l >= w) fbox(x0 + w / 2, y0 + w / 2 - 0.05, ridge, max(l - w, 0.1), 0.1, t);
        else fbox(x0 + l / 2 - 0.05, y0 + l / 2, ridge, 0.1, max(w - l, 0.1), t);
    }
}
module roof(x0, l, y0, w, plate, rise, kind, ov) {
  if (kind != 5) {
    // eave line sits ov*rise below the plate; kind 3 adds a flatter kick
    eave = plate - (kind == 4 ? 0 : ov * rise);
    paint("roof") {
        if (kind == 3) {
            roof_solid(x0 - ov, l + 2 * ov, y0 - ov, w + 2 * ov, eave + ov * rise * 0.45, rise * 1.25, 0);
            hull() { fbox(x0 - ov, y0 - ov, eave, l + 2 * ov, w + 2 * ov, 0.4);
                     fbox(x0 - ov * 0.4, y0 - ov * 0.4, eave + ov * rise * 0.6, l + ov * 0.8, w + ov * 0.8, 0.4); }
        } else if (kind == 1) roof_solid(x0 - 1, l + 2, y0 - ov, w + 2 * ov, eave, rise, 1);
        else if (kind == 2) roof_solid(x0 - ov, l + 2 * ov, y0 - 1, w + 2, eave, rise, 2);
        else roof_solid(x0 - ov, l + 2 * ov, y0 - ov, w + 2 * ov, eave, rise, kind);
    }
    if (kind != 4) paint("trim") fbox(x0 - ov, y0 - ov, eave - 0.6, l + 2 * ov, w + 2 * ov, 0.6);   // fascia / gutter
  }
}
// gable infill walls for gable roofs
module gable_ends(x0, l, y0, w, plate, rise, kind, sid) {
    if (kind == 1) for (x = [x0, x0 + l - 0.5]) wall_paint(sid)
        translate([ft(x), ft(y0), ft(plate)]) rotate([90, 0, 90]) linear_extrude(ft(0.5)) polygon([[0, 0], [ft(w), 0], [ft(w / 2), ft(rise * w / 2)]]);
    if (kind == 2) for (y = [y0, y0 + w - 0.5]) wall_paint(sid)
        translate([ft(x0), ft(y + 0.5), ft(plate)]) rotate([90, 0, 0]) linear_extrude(ft(0.5)) polygon([[0, 0], [ft(l), 0], [ft(l / 2), ft(rise * l / 2)]]);
}
module wall_paint(s) { paint(s == 1 ? "stucco" : s == 2 ? "brick" : s == 3 ? "stone" : "walls") children(); }

// ---- the building blocks -------------------------------------------------
module block(b) {
    x0 = b[0]; l = b[1]; y0 = b[2]; w = b[3]; plate = b[4]; rise = b[5]; kind = b[6]; ov = b[7]; sid = b[8];
    wall_paint(sid) fbox(x0, y0, 0.5, l, w, plate - 0.5);
    if (sid == 0) paint("trim") {                                   // belt course, water table, corner boards
        fbox(x0 - 0.15, y0 - 0.15, FLOOR + WAIN - 0.2, l + 0.3, w + 0.3, 0.35);
        fbox(x0 - 0.15, y0 - 0.15, 0.5, l + 0.3, w + 0.3, 0.4);
        for (x = [x0 - 0.25, x0 + l - 0.15], y = [y0 - 0.25, y0 + w - 0.15]) fbox(x, y, 0.5, 0.4, 0.4, plate - 0.5);
    }
    if (sid == 0 && ov >= 2) paint("trim")                           // knee braces under wide eaves
        for (x = [x0 + 2 : 6 : x0 + l - 1], s = [0, 1])
            translate([ft(x), s ? ft(y0 + w) : ft(y0), ft(plate - 2.4)]) rotate([0, 0, s ? 0 : 180]) rotate([90, 0, 90])
                linear_extrude(ft(0.3)) polygon([[0, 0], [0, ft(2.4)], [ft(ov * 0.75), ft(2.4)], [ft(0.4), ft(0.3)]]);
    paint("foundation") fbox(x0, y0, 0, l, w, 0.5);
    roof(x0, l, y0, w, plate, rise, kind, ov);
    gable_ends(x0, l, y0, w, plate, rise, kind, sid);
}
module pavilion(p) {
    x0 = p[0]; l = p[1]; y0 = p[2]; w = p[3]; plate = p[4]; nx = p[8]; ny = p[9];
    paint("trim") for (i = [0 : nx - 1], j = [0 : ny - 1])
        fbox(x0 + 0.3 + i * (l - 1.6) / max(nx - 1, 1), y0 + 0.3 + j * (w - 1.6) / max(ny - 1, 1), 0, 1, 1, plate);
    paint("trim") { fbox(x0, y0, plate - 1, l, 0.8, 1); fbox(x0, y0 + w - 0.8, plate - 1, l, 0.8, 1); }
    roof(x0, l, y0, w, plate, p[5], p[6], p[7]);
}

// ---- openings ------------------------------------------------------------
// place a child drawn in the x-z plane (x along the wall, z up) on a wall face
module on_face(B, x, side) {
    x0 = B[0]; l = B[1]; y0 = B[2]; w = B[3];
    if (side == 0) translate([ft(x), ft(y0) - 0.01, 0]) rotate([90, 0, 0]) children();
    if (side == 1) translate([ft(x), ft(y0 + w) + 0.01, 0]) rotate([90, 0, 180]) children();
    if (side == 2) translate([ft(x0) - 0.01, ft(x), 0]) rotate([90, 0, -90]) children();
    if (side == 3) translate([ft(x0 + l) + 0.01, ft(x), 0]) rotate([90, 0, 90]) children();
}
module window(w, h, sill) {
    translate([-ft(w) / 2, ft(sill), 0]) {
        paint("glass") cube([ft(w), ft(h), ft(0.08)]);
        paint("trim") {
            translate([-ft(0.35), -ft(0.35), 0]) cube([ft(w + 0.7), ft(0.35), ft(0.35)]);
            translate([-ft(0.35), ft(h), 0]) cube([ft(w + 0.7), ft(0.5), ft(0.3)]);
            for (x = [-ft(0.3), ft(w)]) translate([x, 0, 0]) cube([ft(0.3), ft(h), ft(0.25)]);
            translate([0, ft(h) / 2 - ft(0.08), 0]) cube([ft(w), ft(0.16), ft(0.2)]);
        }
    }
}
module door(w, h, type) {
    translate([-ft(w) / 2, ft(FLOOR), 0]) {
        paint("doors") cube([ft(w), ft(h), ft(0.15)]);
        paint("trim") {
            for (x = [-ft(0.35), ft(w)]) translate([x, 0, 0]) cube([ft(0.35), ft(h + (type == 2 ? 0 : 1.4)), ft(0.25)]);
            translate([-ft(0.35), ft(h + (type == 2 ? 0 : 1.3)), 0]) cube([ft(w + 0.7), ft(0.35), ft(0.3)]);
            if (type == 1) translate([ft(w) / 2 - ft(0.07), 0, 0]) cube([ft(0.14), ft(h), ft(0.25)]);
            if (type == 2) for (k = [0, 1]) hull() { translate([k ? ft(w - 0.3) : 0, 0, ft(0.15)]) cube([ft(0.3), ft(0.3), ft(0.06)]);
                                                        translate([k ? 0 : ft(w - 0.3), ft(h - 0.3), ft(0.15)]) cube([ft(0.3), ft(0.3), ft(0.06)]); }
        }
        if (type != 2) paint("glass") translate([0, ft(h + 0.2), 0]) cube([ft(w), ft(1), ft(0.08)]);
    }
}
module bay(B, x, side, w, d, plate, sid) {
    yb = side == 1 ? B[2] + B[3] : B[2];
    s = side == 1 ? 1 : -1;
    pts = [[-w / 2, 0], [w / 2, 0], [w / 2 - d * 0.7, s * d], [-w / 2 + d * 0.7, s * d]];
    wall_paint(sid) translate([ft(x), ft(yb), ft(0.5)]) linear_extrude(ft(plate - 0.8)) polygon([for (p = pts) [ft(p[0]), ft(p[1])]]);
    paint("glass") translate([ft(x), ft(yb + s * d) + s * 0.02, 0]) rotate([90, 0, side == 1 ? 180 : 0]) translate([-ft(w - 2 * d * 0.7) / 2 + ft(0.3), ft(FLOOR + 2.8), 0]) cube([ft(w - 2 * d * 0.7 - 0.6), ft(5.5), ft(0.08)]);
}

// ---- the whole depot -------------------------------------------------------
module depot(blocks, pavs = [], wins = [], doors = [], bays = [], chims = [], plat = 0, main = 0) {
    B = blocks[main];
    for (b = blocks) block(b);
    for (p = pavs) pavilion(p);
    for (o = wins)  on_face(blocks[o[5] == undef ? main : o[5]], o[0], o[1]) window(o[2], o[3], o[4]);
    for (o = doors) on_face(blocks[o[5] == undef ? main : o[5]], o[0], o[1]) door(o[2], o[3], o[4]);
    for (o = bays)  let (K = blocks[o[4] == undef ? main : o[4]]) bay(K, o[0], o[1], o[2], o[3], K[4], K[8]);
    for (c = chims) paint("chimney") { fbox(c[0] - 0.8, c[1] - 0.8, 4, 1.6, 1.6, c[2] - 4); fbox(c[0] - 1, c[1] - 1, c[2] - 0.5, 2, 2, 0.5); }
    if (plat != 0) paint("platform") fbox(plat[0], B[2] + B[3], 0, plat[1], plat[2], plat[3]);
}
