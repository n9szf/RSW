// =====================================================================
//  Windows and doors  -  one Pullman-green insert per opening in walls.scad
//  Each insert: a plug that fits the opening (set back 1.5 mm from the brick face),
//  a frame, sash or door leaves with muntins, and a thin flange on the inside face.
//  Glazing: cut clear acetate / PETG sheet to the recess on the inside and glue it in.
//  Printed flat, outside face up.  Openings marked "void" in walls.scad get no insert.
//
//  window_list()  -> ["<wall>|<index>", ...]      window_part(id)   window_place(id)
// =====================================================================
include <../janesville_common.scad>
use <walls.scad>

WIN  = "Main_town|0";   // when opened directly
VIEW = "flat";          // "flat" or "placed"

CLEAR   = 0.15;          // fit clearance per side
REVEAL  = 1.5;           // insert sits this far back from the brick face
FLANGE  = 2.0;           // inside flange, beyond the opening
FLANGE_T = 0.8;          // flange / glazing recess depth
FRAME   = ft(0, 4);      // window/door frame
SASH    = ft(0, 2.5);    // sash stiles and rails
MUNTIN  = 1.0;           // glazing bars (printable minimum)
SASH_SET = 0.6;          // sash face sits back from the frame face
LEAF_SET = 0.9;          // door leaf face sits back from the frame face
GROOVE  = 0.45;          // panel / board grooves
$fn = 64;

// ---------- which openings get inserts ----------
function w_open(name) = wrow(name)[6];
function window_part_name(id) = str("Window_", wid_wall(id), "_", wid_index(id));
function window_list() = [for (n = walls_list()) let(o = w_open(n))
    for (i = [0 : len(o) - 1]) if (len(o) > 0 && o[i][0] != "void") str(n, "|", i)];
function wid_wall(id) = let(p = search("|", id)[0]) substr(id, 0, p);
function wid_index(id) = let(p = search("|", id)[0]) parse_int(substr(id, p + 1));
function substr(s, a, n = -1) = let(e = n < 0 ? len(s) : a + n) str_join([for (i = [a : e - 1]) s[i]]);
function str_join(v, i = 0) = i >= len(v) ? "" : str(v[i], str_join(v, i + 1));
function parse_int(s, i = 0, acc = 0) = i >= len(s) ? acc : parse_int(s, i + 1, acc * 10 + (ord(s[i]) - 48));
function w_style(name) = substr(name, 0, 7) == "Baggage" ? "board" : "panel";

// ---------- 2D shapes, local coords: u = 0 at opening center, v = height above floor (mm) ----------
module open2d(o, d = 0) {       // the opening, grown (+) or shrunk (-) by d
    w = ft(o[2]); b = ft(o[3]); t = ft(o[4]);
    offset(delta = d) {
        translate([-w / 2, b - (b == 0 ? 2 : 0)]) square([w, t - b + (b == 0 ? 2 : 0)]);
        if (o[0] == "arch") translate([0, t]) circle(d = w);
    }
}
module frame2d(o) difference() { open2d(o, -CLEAR); open2d(o, -FRAME); }
module glass2d(o) open2d(o, -FRAME);

// window sash lattice (double-hung; paired with a mullion when wide; arched fanlight)
module sash2d(o) intersection() {
    glass2d(o);
    w = ft(o[2]); b = ft(o[3]); t = ft(o[4]);
    gb = b + FRAME; gt = t - (o[0] == "arch" ? 0 : FRAME);
    pair = o[2] >= 5;
    mid = (gb + gt) / 2;
    union() {
        difference() { glass2d(o); offset(delta = -SASH) glass2d(o); }      // sash perimeter
        translate([-w, mid - SASH * 0.75]) square([2 * w, SASH * 1.5]);       // meeting rail
        if (pair) translate([-FRAME / 2, 0]) square([FRAME, t + w]);          // center mullion
        // upper-sash muntins: two lights per sash
        for (s = pair ? [-1, 1] : [0]) let(cx = s * w / 4)
            translate([cx - MUNTIN / 2, mid]) square([MUNTIN, gt - mid]);
        if (o[0] == "arch") {
            translate([-w, t - FRAME / 2]) square([2 * w, FRAME]);           // transom bar at springing
            translate([0, t]) intersection() {
                translate([-w, 0]) square([2 * w, w]);                               // fanlight only above springing
                union() {
                    for (a = [30 : 30 : 150]) rotate(a) translate([0, -MUNTIN / 2]) square([w, MUNTIN]);
                    difference() { circle(r = w * 0.16 + MUNTIN); circle(r = w * 0.16); }   // fan hub
                }
            }
        }
    }
}

// door leaves: glazed upper panel, two raised lower panels (or vertical boards for baggage doors)
LEAF_TOP = 8;      // ft, top of door leaves; anything above is transom / fanlight
module leaves2d(o) intersection() {
    glass2d(o);
    w = ft(o[2]); lt = min(ft(o[4]) - FRAME, ft(LEAF_TOP));
    translate([-w, -5]) square([2 * w, lt + 5]);
}
module leaf_glass2d(o, style) if (style == "panel") {
    w = ft(o[2]); n = o[2] >= 4.5 ? 2 : 1; lw = (w - 2 * FRAME) / n; lt = min(ft(o[4]) - FRAME, ft(LEAF_TOP));
    for (i = [0 : n - 1]) translate([-w / 2 + FRAME + i * lw + SASH, ft(4)]) square([lw - 2 * SASH, lt - ft(4) - SASH]);
}
module leaf_detail2d(o, style) {           // grooves on the leaf face
    w = ft(o[2]); n = o[2] >= 4.5 ? 2 : 1; lw = (w - 2 * FRAME) / n; lt = min(ft(o[4]) - FRAME, ft(LEAF_TOP));
    if (style == "panel") for (i = [0 : n - 1]) {
        x0 = -w / 2 + FRAME + i * lw;
        translate([x0 - GROOVE / 2 + (i > 0 ? 0 : lw), 0]) square([GROOVE, lt]);               // meeting stile
        for (p = [[ft(0.75), ft(1.75)], [ft(2.1), ft(3.6)]])                                    // two raised panels
            translate([x0 + SASH, p[0]]) difference() {
                square([lw - 2 * SASH, p[1] - p[0]]);
                translate([GROOVE, GROOVE]) square([lw - 2 * SASH - 2 * GROOVE, p[1] - p[0] - 2 * GROOVE]);
            }
    } else {
        for (u = [-w / 2 + ft(0, 6) : ft(0, 6) : w / 2]) translate([u - GROOVE / 2, 0]) square([GROOVE, lt]);   // boards
        translate([-w, ft(2) - GROOVE / 2]) square([2 * w, GROOVE]);                                       // ledgers
        translate([-w, lt - ft(2) - GROOVE / 2]) square([2 * w, GROOVE]);
    }
}
// transom / fanlight above a door
module transom2d(o) {
    w = ft(o[2]); t = ft(o[4]); lt = min(t - FRAME, ft(LEAF_TOP));
    if (t - lt > ft(1)) intersection() {
        glass2d(o);
        difference() {
            translate([-w, lt]) square([2 * w, t + w]);
            translate([0, 0]) offset(delta = -SASH) intersection() { glass2d(o); translate([-w, lt + SASH]) square([2 * w, t + w]); }
        }
    }
    if (o[0] == "arch") translate([0, t]) intersection() {
        circle(d = w - 2 * FRAME);
        union() { for (a = [30 : 30 : 150]) rotate(a) translate([0, -MUNTIN / 2]) square([w, MUNTIN]);
                  translate([-w, -FRAME / 2]) square([2 * w, FRAME]); }
    }
}

// ---------- the insert, flat: inside face at z = 0, outside face up ----------
module window_flat(id, only = -1) {
    n = wid_wall(id); o = w_open(n)[wid_index(id)]; T = wrow(n)[3]; D = T - REVEAL;
    door = o[3] == 0; style = w_style(n);
    module L(k, z0, z1) if (only < 0 || only == k) translate([0, 0, z0]) linear_extrude(z1 - z0) children();
    // flange + glazing recess
    L(0, 0, FLANGE_T) difference() { open2d(o, FLANGE); if (door) leaves2d(o); open2d(o, -1.2);
                                     if (door) translate([-ft(o[2]), -10]) square([2 * ft(o[2]), 10 + 0.01]); }
    // frame, full depth
    L(1, FLANGE_T, D) difference() { frame2d(o); if (door) translate([-ft(o[2]), -10]) square([2 * ft(o[2]), 10]); }
    if (!door) L(2, FLANGE_T, D - SASH_SET) sash2d(o);
    if (door) {
        L(3, 0, D - LEAF_SET - 0.5) difference() { leaves2d(o); leaf_glass2d(o, style); }
        L(4, D - LEAF_SET - 0.5, D - LEAF_SET) difference() { leaves2d(o); leaf_glass2d(o, style); leaf_detail2d(o, style); }
        L(5, FLANGE_T, D - SASH_SET) transom2d(o);
    }
}

module window_part(id) color(PULLMAN_GREEN) window_flat(id);

// glass for pictures and the 3D viewer only (the printed model uses acetate cut to the recess)
module window_glass_flat(id) {
    n = wid_wall(id); o = w_open(n)[wid_index(id)]; T = wrow(n)[3]; D = T - REVEAL; door = o[3] == 0; style = w_style(n);
    if (!door) translate([0, 0, FLANGE_T + 0.4]) linear_extrude(0.3) glass2d(o);
    else {
        translate([0, 0, D - LEAF_SET - 1.0]) linear_extrude(0.3) leaf_glass2d(o, style);
        translate([0, 0, FLANGE_T + 0.4]) linear_extrude(0.3) intersection() { glass2d(o); translate([-ft(20), ft(LEAF_TOP)]) square([ft(40), ft(40)]); }
    }
}
module window_glass_place(id) {
    n = wid_wall(id); r = wrow(n); o = w_open(n)[wid_index(id)]; T = r[3]; org = r[7]; a = r[8];
    off = r[4] ? T : 0;
    translate([org[0], org[1], FLOOR_Z]) rotate([0, 0, a]) translate([off, 0, 0])
        rotate([90, 0, 0]) translate([0, 0, -T]) translate([ft(o[1]) - off, 0, 0]) window_glass_flat(id);
}

// standing in its opening on the building (same transform as wall_place)
module window_place(id) {
    n = wid_wall(id); r = wrow(n); o = w_open(n)[wid_index(id)]; T = r[3]; org = r[7]; a = r[8];
    off = r[4] ? T : 0;
    translate([org[0], org[1], FLOOR_Z]) rotate([0, 0, a]) translate([off, 0, 0])
        rotate([90, 0, 0]) translate([0, 0, -T]) translate([ft(o[1]) - off, 0, 0]) color(PULLMAN_GREEN) window_flat(id);
}

LAYER = -1;   // cloud export helper
if (VIEW == "placed") for (id = window_list()) window_place(id);
else if (LAYER >= 0) window_flat(WIN, LAYER);
else window_part(WIN);
