// =====================================================================
//  lj_body.scad - Little Joe carbody: sides and ends (printed in NSEC
//  sections, upright) and the roof (printed in NSEC sections, upright,
//  hollow). Shape from the Milwaukee Road EF-4 diagram of 4 Aug 1950:
//  a long nose ahead of a raised cab at each end, three cab side windows,
//  a door behind each cab, and a louvre band along the upper body.
//  The body stands on the frame and is held by screws up through the
//  frame into bosses inside the side walls (Tom 10/20: screw mounts).
// =====================================================================

// ---------- the outside shape; off > 0 gives the shape moved in by off ----------
module lj_xsec(off) {            // cross-section, y-z
    hw = HW - off; r = max(ROOF_R - off, 0.2); zt = Z_ROOF - off;
    hull() {
        translate([-hw, Z_DECK - 5]) square([2 * hw, 1]);
        for (s = [-1, 1]) translate([s * (hw - r), zt - r]) circle(r = r, $fn = 48);
    }
}
module lj_plan(off) {            // plan, x-y: straight sides, blunt noses rounded over the last NOSE_PLAN_D (v8)
    if (FC_NOSE) translate([-(HL - NOSE_L), -(HW - off)]) square([2 * (HL - NOSE_L), 2 * (HW - off)]);   // body stops at the cab front; the nose is its own print
    else lj_plan_scad(off);
}
module lj_plan_scad(off) {
    hw = HW - off; a = max(p(NOSE_PLAN_D_IN) - off, 0.2); xc = HL - p(NOSE_PLAN_D_IN); n = NOSE_PLAN_N;
    pts = [for (t = [-90:5:90]) let(c = cos(t), sn = sin(t))
           [xc + a * sign(c) * pow(abs(c), 2 / n), hw * sign(sn) * pow(abs(sn), 2 / n)]];
    union() {
        translate([-xc, -hw]) square([2 * xc, 2 * hw]);
        polygon(pts); mirror([1, 0]) polygon(pts);
    }
}
// side view, x-z: leaning nose front, level nose top, raked windshield, cab roof, step down to the middle roof
function end_prof(hl, off) = [
    [FC_NOSE ? hl - p(WS_D0_IN) : hl, Z_DECK - 6], [FC_NOSE ? hl - p(WS_D0_IN) : hl, Z_DECK],
    [hl - (FC_NOSE ? p(WS_D0_IN) : p(NOSE_LEAN_IN)), p(NOSE_TOP_IN) + (FC_NOSE ? -off : 8)],              // leaning front (FreeCAD nose: cab front wall)
    [hl - p(WS_D0_IN), p(NOSE_TOP_IN) - off],
    [hl - p(WS_D1_IN), Z_ROOF - off], [hl - p(CAB_ROOF_END_IN), Z_ROOF - off], [hl - p(CAB_ROOF_END_IN + 10), Z_MID_ROOF - off]];
// The nose top (v8): drops from NOSE_TOP at the windshield to NOSE_TOP_FRONT at the tip, and rounds over onto the sides
// and the front; the round is big at the tip and dies out toward the windshield. Built from slices across the nose,
// each a hull of inset plan layers (so it rounds in every direction), hulled pair by pair.
function nose_r_in(d) = NOSE_SHOULDER_R_IN[1] + (NOSE_SHOULDER_R_IN[0] - NOSE_SHOULDER_R_IN[1]) * pow(1 - min(1, max(0, d / NOSE_L_IN)), NOSE_SHOULDER_POW);
function nose_r(d) = p(nose_r_in(d));
function nose_lean(z) = p(NOSE_LEAN_IN) * max(0, z - Z_DECK) / (p(NOSE_TOP_IN) + p(8) - Z_DECK);
function nose_top_in(d) = NOSE_TOP_FRONT_IN + (NOSE_TOP_IN - NOSE_TOP_FRONT_IN) * min(1, max(0, d / NOSE_L_IN));
NOSE_DS = [0, 4, 10, 18, 28, 42, 60, NOSE_L_IN];   // slice positions, inches back from the tip
module nose_slice(off, d) let(R = nose_r(d), zt = p(nose_top_in(d)) - off)
    intersection() {
        hull() {
            translate([0, 0, Z_DECK - 8]) linear_extrude(height = 0.01) lj_plan(off);
            // each layer is set back by the lean at its height, so the round wraps the leaning front (v8)
            for (t = [0:15:90]) let(z = zt - R + R * sin(t)) translate([-nose_lean(z), 0, z]) linear_extrude(height = 0.01) lj_plan(off + R * (1 - cos(t)));
        }
        translate([d == 0 ? HL - max(off, 0) - p(1) : HL - p(d) - 0.01, -500, Z_DECK - 10]) cube([d == 0 ? 50 : 0.02, 1000, 1000]);
    }
// FreeCAD nose shells (library/nose): outer (with hood and corner boxes), moved in by the groove depth, by the wall
use <nose/lj_nose_import.scad>           // imports the nose STL relative to the nose folder
// the FreeCAD nose print, in place at the +x end (mirror for the other end)
module lj_fc_nose() lj_nose_import(str("lj_nose_", SC, ".stl"));
module lj_fc_noses() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0]) lj_fc_nose();
// sleeve on the cab front: the nose glues over it (its outline is the nose section at the cab: full width, round r, top)
module lj_nose_sleeve_2d(off) let(w = HW - off, r = max(0.2, p(NOSE_SHOULDER_R_IN[1]) + p(1) - off), zt = p(NOSE_TOP_IN) - off - p(0.5))
    hull() { translate([-w, Z_DECK]) square([2 * w, 1]); for (sy = [-1, 1]) translate([sy * (w - r), zt - r]) circle(r = r, $fn = 24); }
module lj_nose_sleeves() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0])
    translate([HL - NOSE_L - 0.01, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = SLEEVE) difference() { lj_nose_sleeve_2d(WALL + FIT); lj_nose_sleeve_2d(2 * WALL + FIT); }
module lj_nose_cap(off) {
    xc = HL - NOSE_L;
    if (FC_NOSE) translate([-1000, -500, Z_DECK - 10]) cube([2000, 1000, 1000]);      // no cap: plan and side already stop at the cab front
    else lj_nose_cap_scad(off);
}
module lj_nose_cap_scad(off) {
    xc = HL - NOSE_L;
    translate([-xc, -500, Z_DECK - 10]) cube([2 * xc, 1000, 1000]);
    for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0])
        for (i = [0:len(NOSE_DS) - 2]) hull() { nose_slice(off, NOSE_DS[i]); nose_slice(off, NOSE_DS[i + 1]); }
}
// the bonnet zone (above the crease) - the FREIGHT scheme paints it black (preview / Blender)
module lj_bonnet_zone() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0])
    for (i = [0:len(NOSE_DS) - 2]) hull() for (d = [NOSE_DS[i], NOSE_DS[i + 1]])
        translate([HL - p(d) - (d == 0 ? -50 : 0.01), -500, p(nose_top_in(d) - nose_r_in(d))]) cube([d == 0 ? 0.02 : 0.02, 1000, 1000]);
// how far the nose tip is set back from the body end at height z (model mm)
function front_d(z) = let(R = nose_r(0), zt = p(NOSE_TOP_FRONT_IN), lean = p(NOSE_LEAN_IN) * max(0, z - Z_DECK) / (p(NOSE_TOP_IN) + p(8) - Z_DECK),
                          sv = (z - (zt - R)) / R) lean + (sv > 0 ? R * (1 - cos(asin(min(1, sv)))) : 0);
// nose side surface: half-width and its angle at d back from the tip (for decals on the curve)
function nose_u(d) = max(0, (p(NOSE_PLAN_D_IN) - p(d)) / p(NOSE_PLAN_D_IN));
function nose_y(d) = HW * pow(max(0, 1 - pow(nose_u(d), NOSE_PLAN_N)), 1 / NOSE_PLAN_N);
function nose_ang(d) = let(e = 0.5, y1 = nose_y(d - e), y2 = nose_y(d + e)) atan((y2 - y1) / p(2 * e));
module lj_side(off) {
    hl = HL - off; rr = NOSE_ROUND; e = end_prof(hl, off);
    offset(r = rr, $fn = 32) offset(delta = -rr)
        polygon(concat(e, [for (i = [len(e) - 1:-1:0]) [-e[i][0], e[i][1]]]));
}
module lj_outer(off = 0) {
    intersection() {
        rotate([90, 0, 90]) linear_extrude(height = BL + 20, center = true) lj_xsec(off);
        translate([0, 0, Z_DECK - 6]) linear_extrude(height = Z_ROOF + 12) lj_plan(off);
        rotate([90, 0, 0]) linear_extrude(height = BW + 20, center = true) lj_side(off);
        if (is_undef($nose) || $nose) lj_nose_cap(off);           // sections with no nose skip it ($nose = false) - much faster
        else translate([-1000, -500, -10]) cube([2000, 1000, 1000]);
    }
}
module zband(z0, z1, x0 = -1000, x1 = 1000) translate([x0, -500, z0]) cube([x1 - x0, 1000, z1 - z0]);

// d (inches back from the nose front) -> x, both ends
function ends_d(d) = [HL - p(d), -(HL - p(d))];
WS_RAKE = atan((Z_ROOF - p(NOSE_TOP_BACK_IN)) / p(WS_D1_IN - WS_D0_IN));   // windshield slope up from horizontal

// ---------- windows: cut through ----------
module lj_cuts() {
    d = WALL * 3;
    for (sy = [-1, 1]) for (w = CAB_WINS) for (x = ends_d(w[0]))
        translate([x - p(w[1]) / 2, sy * HW - d / 2, p(CAB_WIN_SILL_IN)]) cube([p(w[1]), d, p(CAB_WIN_H_IN)]);
    // windshields: two panes on the raked face of each cab, none at the B (+x) end of an EP-4
    // (v10) each pane is a curved outline seen from the front, pushed along the body and kept to a thin slab on the raked face
    wsx = p(WS_D0_IN + WS_D1_IN) / 2; wsz = (p(NOSE_TOP_BACK_IN) + Z_ROOF) / 2;
    wsl = sqrt(pow(p(WS_D1_IN - WS_D0_IN), 2) + pow(Z_ROOF - p(NOSE_TOP_BACK_IN), 2));
    for (sx = STEAM_GEN ? [-1] : [-1, 1]) for (sy = [-1, 1]) intersection() {
        translate([sx * (HL - wsx), 0, 0]) rotate([90, 0, 90]) translate([0, 0, -p(20)]) linear_extrude(p(40)) ws_pane_2d(sy);
        translate([sx * (HL - wsx), sy * p(WS_Y_IN), wsz]) rotate([0, sx * WS_RAKE, 0])
            cube([wsl * 2, p(WS_W_IN) * 1.5, WALL * 3], center = true);
    }
}
// roof line seen from the front: flat top, ROOF_R round onto the sides
function ws_roof_z(y) = let(a = abs(y) - (HW - ROOF_R)) a <= 0 ? Z_ROOF : Z_ROOF - ROOF_R + sqrt(max(0, ROOF_R * ROOF_R - a * a));
// one windshield outline in y-z: top follows the roof line, bottom follows it at WS_SAG, rounded corners
module ws_pane_2d(sy) {
    y0 = p(WS_Y_IN - WS_W_IN / 2); y1 = p(WS_Y_IN + WS_W_IN / 2); rc = p(WS_CORNER_R_IN); n = 24;
    gap = max(p(WS_TOP_GAP_IN), WALL);
    top = [for (i = [0:n]) let(y = y0 + (y1 - y0) * i / n) [y, ws_roof_z(y) - gap]];
    bot = [for (i = [n:-1:0]) let(y = y0 + (y1 - y0) * i / n) [y, max(p(NOSE_TOP_IN + 1.5), p(WS_BOT_IN) - WS_SAG * (Z_ROOF - ws_roof_z(y)))]];
    mirror([sy < 0 ? 1 : 0, 0]) offset(r = rc, $fn = 16) offset(delta = -rc) polygon(concat(top, bot));
}
// recessed panels: door outlines, nose-side panels, the louvre band
module lj_recesses() {
    dep = WALL * 0.45; gap = max(0.35, p(0.75));
    for (sy = [-1, 1]) {
        for (x = ends_d(CAB_DOOR_D_IN)) translate([x, sy * HW, Z_DECK + p(3)]) difference() {
            translate([-p(CAB_DOOR_W_IN) / 2, -dep, 0]) cube([p(CAB_DOOR_W_IN), 2 * dep, p(CAB_DOOR_H_IN)]);
            translate([-p(CAB_DOOR_W_IN) / 2 + gap, -dep - 1, gap]) cube([p(CAB_DOOR_W_IN) - 2 * gap, 2 * dep + 2, p(CAB_DOOR_H_IN) - 2 * gap]);
        }
        if (!FC_NOSE) skin_recess(dep) for (sx = [-1, 1]) translate([sx * (HL - p(NOSE_PANEL[0] + NOSE_PANEL[1]) / 2) - p(NOSE_PANEL[1] - NOSE_PANEL[0]) / 2, sy > 0 ? 0 : -HW - 1, p(NOSE_PANEL[2])])
            cube([p(NOSE_PANEL[1] - NOSE_PANEL[0]), HW + 1, p(NOSE_PANEL[3] - NOSE_PANEL[2])]);   // number board on the curved nose side
        // louvre band: panels each side of the centre, horizontal slats left standing
        pw = p(LOUVRE_X_IN) / LOUVRE_PANELS; zl = p(LOUVRE_Z_IN[0]); hl = p(LOUVRE_Z_IN[1] - LOUVRE_Z_IN[0]);
        for (i = [0:2 * LOUVRE_PANELS - 1]) translate([-p(LOUVRE_X_IN) + i * pw + max(0.4, p(1.5)), sy * HW - dep, zl])
            difference() {
                cube([pw - 2 * max(0.4, p(1.5)), 2 * dep, hl]);
                n = 7; for (j = [1:n - 1]) translate([-1, -1, j * hl / n - p(0.6)]) cube([pw + 2, sy > 0 ? dep + 1 : 2 * dep + 2, p(1.2)]);
            }
    }
}
// a recess of even depth on the skin, inside a cutting box (works on the curved nose)
module skin_recess(dep) intersection() { difference() { lj_outer(-0.01); lj_outer(dep); } children(); }
// door in the middle of each nose front: an outline groove (MPL end view shows the front; size ESTIMATE)
// raised box on each front corner of the nose (classification lights / number box)
function nose_d_at_y(y) = let(r = min(0.999, abs(y) / HW)) NOSE_PLAN_D_IN * (1 - pow(1 - pow(r, NOSE_PLAN_N), 1 / NOSE_PLAN_N));
module lj_class_boxes() for (sx = [-1, 1], sy = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0]) {
    w = p(CLASS_BOX_IN[0]); h = p(CLASS_BOX_IN[1]); y = p(CLASS_BOX_IN[3]); z0 = p(CLASS_BOX_IN[4]); f = max(0.4, p(1.5));
    xf = HL - p(nose_d_at_y(CLASS_BOX_IN[3] - CLASS_BOX_IN[0] / 2)) - front_d(z0 + h / 2) + p(CLASS_BOX_IN[2]);   // front face, facing forward
    translate([xf - p(24), sy * y - w / 2, z0]) difference() {
        cube([p(24), w, h]);
        translate([p(24) - max(0.4, p(1)), f, f]) cube([p(2), w - 2 * f, h - 2 * f]);      // lens recess
    }
}
module lj_nose_doors() {
    dep = WALL * 0.45; gap = max(0.35, p(0.75)); w = p(NOSE_DOOR_IN[0]); h = p(NOSE_DOOR_IN[1]); z0 = p(NOSE_DOOR_IN[2]);
    skin_recess(dep) for (sx = [-1, 1]) translate([sx > 0 ? HL - p(20) : -HL - 1, 0, 0]) difference() {
        translate([0, -w / 2, z0]) cube([p(20) + 1, w, h]);
        translate([-1, -w / 2 + gap, z0 + gap]) cube([p(20) + 3, w - 2 * gap, h - 2 * gap]);
    }
}
// grab-iron holes for wire (1 mm G and O, 0.5 mm HO) beside the cab doors
GRAB_D = SC == "HO" ? 0.5 : 1.0;
function grab_xs() = [for (x = ends_d(CAB_DOOR_D_IN), sx = [-1, 1]) x + sx * (p(CAB_DOOR_W_IN) / 2 + p(5))];
module lj_grab_holes() for (sy = [-1, 1], gx = grab_xs())
    for (z = [Z_DECK + p(14), Z_DECK + p(60)]) translate([gx, sy * HW, z]) rotate([90, 0, 0]) cylinder(d = GRAB_D + 0.15, h = WALL * 3, center = true, $fn = 12);

// ---------- screw bosses inside the side walls ----------
// per section per side: one near each end, one each side of the frame joint under the middle
function boss_xs(k) = let(x0 = sec_x0(k), x1 = x0 + SEC_L, m = x0 + SEC_L / 2, e = SLEEVE + BOSS[0] / 2 + 1,
                          lo = k == 1 ? -HL + NOSE_L + BOSS[0] : x0 + e, hi = k == NSEC ? HL - NOSE_L - BOSS[0] : x1 - e)
                      [lo, m - LAP / 2 - BOSS[0] / 2 - 1, m + LAP / 2 + BOSS[0] / 2 + 1, hi];
function boss_y() = HW - WALL - BOSS[0] / 2 + 0.01;
function body_screw_pts() = [for (k = [1:NSEC], x = boss_xs(k), sy = [-1, 1]) [x, sy * boss_y()]];
// keep bosses clear of the doors
function in_door(x) = len([for (d = ends_d(CAB_DOOR_D_IN)) if (abs(x - d) < p(CAB_DOOR_W_IN) / 2 + BOSS[0] / 2 + p(6)) 1]) > 0;
module lj_bosses(k) for (x = boss_xs(k), sy = [-1, 1]) if (!in_door(x)) translate([x, sy * boss_y(), Z_DECK]) {
    b = BOSS[0]; h = BOSS[1];
    difference() {
        hull() {
            translate([-b / 2, -b / 2, 0]) cube([b, b, h]);
            translate([-b / 2, sy > 0 ? b / 2 : -b / 2 - 0.01, 0]) cube([b, 0.01, h + b]);   // 45 degree top into the wall
        }
        translate([0, 0, -1]) cylinder(d = BODY_SCREW[0], h = h + 0.5, $fn = 20);
    }
}

// ---------- body (walls) section k, in place ----------
STRAP_T = SC == "G" ? 2.0 : SC == "O" ? 1.6 : 1.0;    // floor strap thickness
module lj_shell() difference() { lj_outer(0); lj_outer(WALL); }
module lj_wall_section(k, cut = true) let($nose = (k == 1 || k == NSEC)) {
    x0 = sec_x0(k); x1 = x0 + SEC_L;
    difference() {
        union() {
            intersection() { lj_shell(); zband(Z_DECK, Z_EAVE, x0, x1); }
            // sleeve at the +x end: slides inside the next section (thickened inside this section so it is joined on)
            if (k < NSEC) intersection() {
                union() {
                    intersection() { difference() { lj_outer(WALL + FIT); lj_outer(2 * WALL + FIT); } zband(Z_DECK, Z_EAVE, x1 - 0.01, x1 + SLEEVE); }
                    intersection() { difference() { lj_outer(WALL - 0.01); lj_outer(2 * WALL + FIT); } zband(Z_DECK, Z_EAVE, x1 - SLEEVE, x1); }
                }
                zband(Z_DECK, Z_EAVE, -1000, 1000);
            }
            // lip on top: the roof section drops over it. A stepped ledge below joins it to the wall (steps < 1 mm, no supports)
            intersection() {
                union() {
                    difference() { lj_outer(WALL + FIT); lj_outer(2 * WALL + FIT); }
                    for (i = [0:2]) intersection() {
                        difference() { lj_outer(WALL - 0.01); lj_outer(2 * WALL + FIT - (WALL + FIT) * i / 3); }
                        zband(Z_EAVE - (WALL + FIT) * (i + 1), Z_EAVE);
                    }
                }
                zband(Z_EAVE - 3 * (WALL + FIT), Z_EAVE + WALL, x0 + (k > 1 ? FIT : 0), x1 - FIT);
            }
            // floor straps tie the two sides together: one in the middle, one at the +x end
            intersection() {
                lj_outer(WALL / 2);
                for (x = [x0 + SEC_L / 2, x1 - 4]) translate([x - 3, -HW, Z_DECK]) cube([6, BW, STRAP_T]);
            }
            intersection() { lj_bosses(k); lj_outer(WALL / 2); }
            if (!FC_NOSE && (k == 1 || k == NSEC)) intersection() { difference() { union() { lj_hl_hood(); lj_class_boxes(); } lj_outer(WALL); } zband(Z_DECK, Z_EAVE, x0, x1); }
            if (FC_NOSE && (k == 1 || k == NSEC)) intersection() { lj_nose_sleeves(); zband(Z_DECK, Z_EAVE, x0 - SLEEVE - 1, x1 + SLEEVE + 1); }
        }
        if (cut) { lj_cuts(); lj_recesses(); lj_grab_holes(); if (!FC_NOSE) lj_nose_doors(); }
        if (!FC_NOSE && (k == 1 || k == NSEC)) lj_hl_lamp_hole();
    }
}

// ---------- roof section k, in place ----------
module lj_roof_cavity() {
    rise = Z_ROOF - WALL - Z_EAVE;
    intersection() {
        lj_outer(WALL);
        union() {
            translate([0, 0, Z_EAVE - 1]) linear_extrude(height = WALL + 1.3) lj_plan(WALL);           // clears the wall lip
            translate([0, 0, Z_EAVE + WALL + 0.29]) hull() {                                        // 45 degree inside
                linear_extrude(height = 0.01) lj_plan(WALL);
                translate([0, 0, rise]) linear_extrude(height = 0.01) offset(delta = -rise) lj_plan(WALL);
            }
        }
    }
}
module lj_roof_section(k, cut = true) let($nose = (k == 1 || k == NSEC)) {
    x0 = sec_x0(k); x1 = x0 + SEC_L;
    difference() {
        union() {
            intersection() { lj_outer(0); zband(Z_EAVE, Z_ROOF + 1, x0, x1); }
            intersection() { lj_roof_details(); zband(Z_EAVE, Z_ROOF + 100, x0, x1); }
        }
        lj_roof_cavity();
        if (cut) lj_cuts();
    }
}
// raised hatch, pantograph insulator pads, (EP-4) steam generator stack
module lj_roof_details() {
    t = max(0.5, p(3));
    for (x = HATCH_X_IN) translate([p(x), 0, Z_MID_ROOF - 0.2]) linear_extrude(height = t + 0.2)
        square([p(HATCH_L_IN), p(HATCH_W_IN)], center = true);
    for (sx = [-1, 1], ix = [-1, 1], iy = [-1, 1])
        translate([sx * p(PAN_X_IN) + ix * p(30), iy * p(24), Z_MID_ROOF - 0.2]) cylinder(d1 = p(10), d2 = p(7), h = p(8) + 0.2, $fn = 20);
    if (STEAM_GEN) translate([HL - p(140), 0, Z_ROOF - 0.2]) cylinder(d = p(14), h = p(14), $fn = 24);
}

// headlight in each nose front (ESTIMATE) - part of the end body prints
// headlight hood (MPL): a round hood along the top of each nose front, top flush with the nose top, front proud of the nose
include <nose/lj_nose_values.scad>       // written by lj_nose_freecad.py: where the hood front is in each scale
function hl_front_x() = FC_NOSE ? [for (r = FC_HOOD_X) if (r[0] == SC) r[1]][0] : HL - front_d(p(HEADLIGHT_Z_IN)) + p(HL_HOOD_IN[2]);   // front of the hood
module lj_hl_hood() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0]) intersection() {
    translate([hl_front_x(), 0, p(HEADLIGHT_Z_IN)]) rotate([0, -90, 0]) cylinder(d = p(HL_HOOD_IN[0]), h = p(HL_HOOD_IN[1]), $fn = 48);
    translate([0, -500, 0]) cube([1000, 1000, p(NOSE_TOP_FRONT_IN + 2)]);      // no taller than just over the nose top
}
module lj_hl_lamp_hole() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0])
    translate([hl_front_x() + 1, 0, p(HEADLIGHT_Z_IN)]) rotate([0, -90, 0]) cylinder(d = p(12), h = p(4) + 1, $fn = 40);
module lj_headlights(lens = true) for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0])
    translate([hl_front_x() - p(3.5), 0, p(HEADLIGHT_Z_IN)]) rotate([0, 90, 0]) cylinder(d = p(11), h = 0.4, $fn = 40);

// end platform railings (wire, preview only; the posts go into holes in the deck)
RAIL_D = SC == "HO" ? 0.5 : 1.0;
function rail_pts() = [for (q = RAIL_POSTS_IN) [HL + p(q[0]), p(q[1])]];
module lj_railings() for (sx = [-1, 1]) mirror([sx > 0 ? 0 : 1, 0, 0]) {
    pts = rail_pts(); top = Z_DECK + p(RAIL_TOP_IN); mid = Z_DECK + p(RAIL_MID_IN);
    for (q = pts, sy = [-1, 1]) translate([q[0], sy * q[1], Z_DECK - 1]) cylinder(d = RAIL_D, h = top - Z_DECK + 1, $fn = 10);
    for (sy = [-1, 1], z = [top, mid]) {
        hull() { translate([pts[0][0], sy * pts[0][1], z]) sphere(d = RAIL_D, $fn = 8); translate([pts[1][0], sy * pts[1][1], z]) sphere(d = RAIL_D, $fn = 8); }
        hull() { translate([pts[1][0], sy * pts[1][1], z]) sphere(d = RAIL_D, $fn = 8); translate([pts[2][0], sy * pts[2][1], z]) sphere(d = RAIL_D, $fn = 8); }
    }
}

// glass panes (preview only)
module lj_glass() intersection() { lj_cuts(); difference() { lj_outer(WALL * 0.4); lj_outer(WALL * 0.6); } }

// grab irons (wire, preview only)
module lj_grabs() for (sy = [-1, 1], gx = grab_xs()) {
    translate([gx, sy * (HW + p(2.5)), Z_DECK + p(14)]) cylinder(d = GRAB_D, h = p(46), $fn = 10);
    for (z = [Z_DECK + p(14), Z_DECK + p(60)]) translate([gx, sy * (HW + p(1.25)), z]) rotate([90, 0, 0]) cylinder(d = GRAB_D, h = p(2.5) + 0.1, center = true, $fn = 10);
}

// lettering (preview / Blender only - decals on the model): number boards on the nose sides,
// herald behind the cab door, number on the nose front
module lj_letters() {
    th = 0.3; f = "Liberation Sans:style=Bold";
    for (sy = [-1, 1]) {
        dn = (NOSE_PANEL[0] + NOSE_PANEL[1]) / 2;
        for (sx = [-1, 1]) translate([sx * (HL - p(dn)), sy * (nose_y(dn) + th / 2), p((NOSE_PANEL[2] + NOSE_PANEL[3]) / 2)])
            rotate([0, 0, -sx * sy * nose_ang(dn)]) rotate([90, 0, sy > 0 ? 180 : 0])
            linear_extrude(height = th, center = true) text(ROAD_NO, size = p(7), halign = "center", valign = "center", font = f);
        for (x = ends_d(HERALD_D_IN)) translate([x, sy * (HW + th / 2), p(HERALD_Z_IN)]) rotate([90, 0, sy > 0 ? 180 : 0])
            linear_extrude(height = th, center = true) {
                difference() { square(p(HERALD_IN), center = true); square(p(HERALD_IN) - 2 * max(0.3, p(1.2)), center = true); }
                translate([0, p(3)]) text("MILWAUKEE", size = p(3), halign = "center", valign = "center", font = f);
                translate([0, -p(3)]) text("ROAD", size = p(4), halign = "center", valign = "center", font = f);
            }
    }
    for (sx = [-1, 1]) translate([sx * (HL - front_d(p(118)) + th / 2), 0, p(118)]) rotate([90, 0, sx * 90])
        linear_extrude(height = th, center = true) text(ROAD_NO, size = p(7), halign = "center", valign = "center", font = f);
}
