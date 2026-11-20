// =====================================================================
//  lj_frame.scad - Little Joe frame (the deck the body stands on),
//  pilots and coupler pads.
//  The frame prints in NSEC+1 flat pieces, upside down. Its joints sit
//  under the middle of a body section, so body and frame overlap each
//  other's joints. Each joint is a half lap with two screws.
//  SCREW MOUNTS (Tom 10/20): screws go up through countersunk holes in the
//  frame into the bosses inside the body side walls.
// =====================================================================

function frame_cut_x(i) = i == 0 ? -DECK_HL - 50 : i == NFRAME ? DECK_HL + 50 : FRAME_SPLITS[i - 1];   // i = 0..NFRAME
// the deck: full body width, out to DECK_HL past the noses (DWG), small corner radius
module deck_plan() hull() for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (DECK_HL - p(6)), sy * (HW - p(6))]) circle(r = p(6), $fn = 24);
module frame_plate() translate([0, 0, Z_FRAME_BOT]) linear_extrude(height = FRAME_T) deck_plan();

// countersunk hole, opening at the frame bottom, axis up
module csk_hole(sc, depth) {
    translate([0, 0, -1]) cylinder(d = sc[1], h = depth + 2, $fn = 20);
    translate([0, 0, -0.01]) cylinder(d1 = sc[2] + 0.4, d2 = sc[1], h = (sc[2] + 0.4 - sc[1]) / 2 + 0.01, $fn = 24);
}
module frame_holes() {
    // body screws
    for (q = body_screw_pts()) if (!in_door(q[0])) translate([q[0], q[1], Z_FRAME_BOT]) csk_hole(BODY_SCREW, FRAME_T);
    // lap screws: two per joint, near the centre line
    for (xs = FRAME_SPLITS, sy = [-1, 1]) translate([xs, sy * HW * 0.45, Z_FRAME_BOT]) {
        csk_hole(TRUCK_SCREW, FRAME_T / 2 - 1);                                   // clear through the bottom half
        cylinder(d = TRUCK_SCREW[0], h = FRAME_T - 0.6, $fn = 16);               // bites in the top half
    }
    // truck pivots
    for (x = [-GDE_X, -DRV_X, DRV_X, GDE_X]) translate([x, 0, Z_FRAME_BOT - 30]) cylinder(d = PIVOT[0], h = 60, $fn = 20);
    // nose screws (FreeCAD nose print): up into its two bosses
    if (FC_NOSE) for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (HL - p(NOSE_BOSS_D_IN)), sy * (HW - WALL - BOSS[0] / 2), Z_FRAME_BOT]) csk_hole(BODY_SCREW, FRAME_T);
    // end box screws
    for (sx = [-1, 1], q = rail_pts(), sy = [-1, 1]) translate([sx * q[0], sy * q[1], Z_FRAME_BOT - 1]) cylinder(d = RAIL_D + 0.2, h = FRAME_T + 2, $fn = 12);
    // pilot screws
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (DECK_HL - pilot_flange_l() / 2), sy * HW * 0.35, Z_FRAME_BOT]) cylinder(d = TRUCK_SCREW[0], h = FRAME_T - 0.8, $fn = 16);
    // weight pockets from the top (fill with lead shot or steel and seal) between the trucks
    for (sx = [-1, 1]) translate([sx * (DRV_X + GDE_X) / 2, 0, Z_DECK - FRAME_T * 0.5])
        linear_extrude(height = FRAME_T) square([(GDE_X - DRV_X) * 0.35, HW * 0.9], center = true);
}
// pivot pads under the frame, down to the top of each truck
function drv_top() = DRV_D / 2 + T_AXLE / 2 + 1 + T_HT;
function gde_top() = GDE_D / 2 + T_AXLE / 2 + 1 + T_HT;
module frame_pads() for (x = [-GDE_X, -DRV_X, DRV_X, GDE_X]) {
    top = abs(x) == GDE_X ? gde_top() : drv_top();
    translate([x, 0, top + 0.4]) difference() {
        cylinder(d = PIVOT[0] * 3, h = Z_FRAME_BOT - top - 0.4 + 0.01, $fn = 32);
        translate([0, 0, -1]) cylinder(d = PIVOT[0], h = 100, $fn = 20);
    }
}
// the frame pieces (i = 1..NFRAME), in place
module lj_frame_piece(i) {
    xa = frame_cut_x(i - 1); xb = frame_cut_x(i);
    zm = Z_FRAME_BOT + FRAME_T / 2;
    difference() {
        union() {
            intersection() {
                union() { frame_plate(); frame_pads(); }
                union() {
                    // full thickness between the laps
                    zband(Z_FRAME_BOT - 100, Z_DECK + 1, xa + (i > 1 ? LAP / 2 : 0), xb - (i < NFRAME ? LAP / 2 : 0));
                    // left lap: this piece owns the top half
                    if (i > 1) zband(zm, Z_DECK + 1, xa - LAP / 2, xa + LAP / 2 + 0.01);
                    // right lap: this piece owns the bottom half
                    if (i < NFRAME) zband(Z_FRAME_BOT - 100, zm, xb - LAP / 2 - 0.01, xb + LAP / 2);
                }
            }
        }
        frame_holes();
        // lap screw pilot holes in the top half (self-tapping)
    }
}
module lj_frame_full() for (i = [1:NFRAME]) lj_frame_piece(i);

// ---------------- pilot (cowcatcher) with coupler pad, one per end ----------------
function pilot_flange_l() = p(24);
PILOT_RUN = p(7);            // ESTIMATE how far the pilot reaches past the deck end (couplers 11 in beyond the deck, DWG)
PILOT_T = max(1.2, WALL);
module lj_pilot(sx = 1) mirror([sx > 0 ? 0 : 1, 0, 0]) {
    zt = Z_FRAME_BOT; zb = p(4); w = BW * 0.86; fl = pilot_flange_l();
    difference() {
        union() {
            // flange under the frame end
            translate([DECK_HL - fl, -w / 2, zt - PILOT_T]) cube([fl, w, PILOT_T]);
            // sloped face plate
            hull() {
                translate([DECK_HL - PILOT_T, -w / 2, zt - 0.01]) cube([PILOT_T, w, 0.01]);
                translate([DECK_HL + PILOT_RUN - PILOT_T, -w * 0.42, zb]) cube([PILOT_T, w * 0.84, 0.01]);
            }
            // side cheeks
            for (sy = [-1, 1]) hull() {
                translate([DECK_HL - fl * 0.5, sy * w / 2 - (sy > 0 ? PILOT_T : 0), zt - 0.01]) cube([fl * 0.5, PILOT_T, 0.01]);
                translate([DECK_HL - PILOT_T, sy * w / 2 - (sy > 0 ? PILOT_T : 0), zb + (zt - zb) * 0.5]) cube([PILOT_T, PILOT_T, 0.01]);
            }
            // coupler box: from the flange down to below the coupler
            cb = coupler_box();
            translate([DECK_HL - cb[0] * 0.3, -cb[1] / 2, CPL_Z - cb[2] / 2 - PILOT_T]) cube([PILOT_RUN * 0.55 + cb[0] * 0.3, cb[1], zt - (CPL_Z - cb[2] / 2 - PILOT_T)]);
            // footboards at the corners
            for (sy = [-1, 1]) translate([DECK_HL + PILOT_RUN * 0.15, sy * (w / 2 - p(14)) - p(9), zb + (zt - zb) * 0.35]) cube([PILOT_RUN * 0.55, p(18), PILOT_T]);
        }
        // coupler pocket and screw
        cb = coupler_box();
        translate([DECK_HL - cb[0], -cb[1] / 2 + PILOT_T, CPL_Z - cb[2] / 2]) cube([PILOT_RUN + cb[0] * 2, cb[1] - 2 * PILOT_T, cb[2]]);
        translate([DECK_HL + PILOT_RUN * 0.15, 0, zt - 20]) cylinder(d = TRUCK_SCREW[0], h = 40, $fn = 16);
        // flange screws (clearance)
        for (sy = [-1, 1]) translate([DECK_HL - fl / 2, sy * HW * 0.35, zt - 10]) cylinder(d = TRUCK_SCREW[1], h = 20, $fn = 16);
    }
}
// coupler pocket size [length, width, height]: Kadee-style draft gear boxes (ESTIMATE, TDQ)
function coupler_box() = SC == "G" ? [30, 18, 9] : SC == "O" ? [20, 12, 6] : [8, 6.5, 3.2];

// ---------------- coupler (preview only: knuckle shape) ----------------
module lj_coupler(sx = 1) mirror([sx > 0 ? 0 : 1, 0, 0]) {
    cb = coupler_box();
    translate([DECK_HL + PILOT_RUN * 0.2, -cb[1] * 0.2, CPL_Z - cb[2] * 0.4]) cube([CPL_X - DECK_HL - PILOT_RUN * 0.2 - cb[1] * 0.5, cb[1] * 0.4, cb[2] * 0.8]);
    translate([CPL_X - cb[1] * 0.5, -cb[1] * 0.55, CPL_Z - cb[2] * 0.6]) cube([cb[1] * 0.5, cb[1] * 1.1, cb[2] * 1.2]);
}
