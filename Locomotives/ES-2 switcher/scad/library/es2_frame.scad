// =====================================================================
//  es2_frame.scad  -  frame / deck in two halves (403 mm long in G, too
//  long for the P1S), and the underside piece that joins them.
//  v6 (Tom 10/17): side sills are channels with the flanges out, pole-pushing
//  pockets on the four corners, rivets, and diamond-plate walkways as a thin
//  separate print glued on the deck round each hood.
//  v8 (Tom 10/18, after printing the base): pole pockets moved to the end sills; the two
//  halves join on three 2 mm brass rods (100 mm, 50 mm into each half); hoods and cab
//  screwed down (M2.5 up through the deck, as the passenger cars); the steps are printed
//  separately and pinned on (the printed-on ones broke easily).
//  Loco frame: x = 0 middle, z = 0 rail top.
// =====================================================================

res_hx = p(RES_L) / 2; res_hw = p(RES_W) / 2;
// shoulder bolt: the shoulder runs from under the head down through the truck bolster and PIVOT_PLAY past it
pivot_bolt_head_z = pivot_z - 12 - PIVOT_PLAY + PIVOT_BOLT[1];      // underside of the bolt head (truck bolster is 12 mm deep)
assert(pivot_bolt_head_z + PIVOT_BOLT[2 + 1] <= deck_z + 0.01, "pivot bolt head would stand above the deck - use a longer shoulder");
assert(pivot_bolt_head_z > pivot_z + PIVOT_GAP + 1, "pivot bolt shoulder too long for the frame - use a shorter one");
res_bot = deck_bot - p(RES_D);
sill_bot = deck_z - p(SILL_D);
esill_bot = deck_z - p(END_SILL_D);
sill_fw = p(SILL_FLANGE);                 // channel flange width
sill_web_y = frame_hw - sill_fw;          // outer face of the channel web
sill_top_t = 2.0;                         // deck plate + top flange seen from outside (mm)
pp_y = frame_hw - p(13);                  // pole pocket centre, across the loco (on the end sill, clear of the lever)
pp_z = esill_bot + p(4.5);
rod_y = [-(sill_web_y - SILL_T - 2.5), 0, sill_web_y - SILL_T - 2.5];   // the three joining rods
rod_z = [deck_bot - 2.5, deck_bot + 0.5, deck_bot - 2.5];
rod_hx = JOIN_ROD[1] / 2 + 0.5;              // pocket depth in each half
step_y = sill_web_y - SILL_T / 2;            // step legs pin up into the sill web
step_w = p(16); step_zt = p(14);
function step_leg_x(sx) = [sx * (frame_hx - p(END_SILL_T) - 2.2), sx * (frame_hx - p(END_SILL_T) - 2.2 - step_w)];   // just inside the end sill (the end sill hangs lower)

// one side sill, s = +1 / -1: a channel, web inside, flanges pointing out
module es2_side_sill(s) {
    ch = sill_fw - 0.8;                   // 45 degree root under the bottom flange (prints deck-down)
    scale([1, s, 1]) {
        translate([-frame_hx, sill_web_y - SILL_T, sill_bot]) cube([2 * frame_hx, SILL_T, deck_z - sill_bot]);   // web
        translate([-frame_hx, sill_web_y - 0.01, deck_z - sill_top_t]) cube([2 * frame_hx, sill_fw + 0.01, sill_top_t]);   // top flange
        translate([-frame_hx, sill_web_y - 0.01, sill_bot]) cube([2 * frame_hx, sill_fw + 0.01, SILL_FLANGE_T]);           // bottom flange
        translate([-frame_hx, sill_web_y, sill_bot + SILL_FLANGE_T - 0.01]) rotate([90, 0, 90])
            linear_extrude(2 * frame_hx) polygon([[0, 0], [ch, 0], [0, ch]]);                                        // flange root
    }
}
// pole-pushing pocket (Tom 10/18: on the END of the frame): a cast cup on the end sill near each corner,
// socket facing out along the loco
module es2_pole_pocket(sx, sy) {
    b = p(POLE_POCKET[0]); d = p(POLE_POCKET[1]);
    translate([sx * frame_hx, sy * pp_y, pp_z]) scale([sx, 1, 1]) difference() {
        hull() {
            translate([-0.01, -b / 2, -b / 2]) cube([0.01, b, b]);
            translate([d - 0.01, -b / 2 + 1, -b / 2 + 1]) cube([0.01, b - 2, b - 2]);
        }
        translate([d + 0.1 - 1.4, 0, 0]) rotate([0, 90, 0]) cylinder(d = p(POLE_POCKET[2]), h = 1.6, $fn = FN);
        translate([d - 0.9, 0, 0]) sphere(d = p(POLE_POCKET[2]), $fn = FN);
    }
}
// truck pivot hardware for the preview: shoulder bolt and nylon lock nut
module es2_pivot_hardware() for (s = [-1, 1]) translate([s * truck_x, 0, 0]) {
    translate([0, 0, pivot_bolt_head_z]) cylinder(d = PIVOT_BOLT[2], h = PIVOT_BOLT[3], $fn = FN);
    translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1]]) cylinder(d = PIVOT_BOLT[0], h = PIVOT_BOLT[1], $fn = 20);
    translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1] - 4.5]) cylinder(d = 3, h = 4.5, $fn = 16);          // thread
    translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1] - PIVOT_NUT[1]]) cylinder(d = PIVOT_NUT[0] / cos(30), h = PIVOT_NUT[1], $fn = 6);
}
// three 2 mm brass rods join the halves: a rib under the deck for each side rod, the middle one in a shallow rib
module frame_rod_ribs() {
    for (s = [-1, 1]) translate([-rod_hx - 2, s > 0 ? rod_y[2] - 2.5 : rod_y[0] - 2.5, deck_bot - 5]) cube([2 * rod_hx + 4, 5.01 + (SILL_T > 0 ? 0 : 0), 5.01]);
    translate([-rod_hx - 2, -3, deck_bot - 3]) cube([2 * rod_hx + 4, 6, 3.01]);
}
module frame_rod_holes() for (i = [0 : 2]) translate([0, rod_y[i], rod_z[i]]) rotate([0, 90, 0]) cylinder(d = JOIN_ROD[2], h = 2 * rod_hx, center = true, $fn = 16);
module es2_join_rods() for (i = [0 : 2]) translate([0, rod_y[i], rod_z[i]]) rotate([0, 90, 0]) cylinder(d = JOIN_ROD[0], h = JOIN_ROD[1], center = true, $fn = 16);
// screws up through the deck into the hood and cab bosses (passenger-car style)
module frame_body_screw_holes() for (q = body_screw_pts()) translate([q[0], q[1], 0]) {
    translate([0, 0, deck_bot - 1]) cylinder(d = BODY_CLEAR_D, h = DECK_T + 2, $fn = 16);
    translate([0, 0, deck_bot - 20]) cylinder(d = BODY_HEAD_D, h = 20 + DECK_T - 1.6, $fn = 20);
}
// pin holes for the separate steps, up into the sill webs
module frame_step_holes() for (sx = [-1, 1], sy = [-1, 1], x = step_leg_x(sx))
    translate([x, sy * step_y, sill_bot - 0.5]) cylinder(d = STEP_PIN, h = 6, $fn = 12);
// rivets: end sill (two rows), side sill web at the bolsters, cross-bearers and hood ends
module es2_frame_rivets() {
    rz = [esill_bot + 1.6, deck_z - 1.6];
    for (s = [-1, 1], z = rz) for (q = rivet_line([s * frame_hx, -frame_hw + 2, z], [s * frame_hx, frame_hw - 2, z]))
        if ((abs(q[1]) > COUPLER_PAD[1] / 2 + 3 || z > rz[0]) && (z > rz[0] || abs(abs(q[1]) - pp_y) > p(POLE_POCKET[0]) / 2 + 0.6))
            rivet_on(q, s > 0 ? "+x" : "-x");
    xs = [0, cab_hx, -cab_hx, truck_x - p(5), truck_x + p(5), -truck_x - p(5), -truck_x + p(5), cab_hx + hood_l, -cab_hx - hood_l];
    for (s = [-1, 1], x = xs, z = rivet_line([0, 0, sill_bot + SILL_FLANGE_T + 2.2], [0, 0, deck_z - sill_top_t - 1.2], p(3.2)))
        rivet_on([x, s * sill_web_y, z[2]], s > 0 ? "+y" : "-y");
}

module es2_frame_full(rivets = true) {
    difference() {
        union() {
            translate([-frame_hx, -sill_web_y, deck_bot]) cube([2 * frame_hx, 2 * sill_web_y, DECK_T]);
            for (s = [-1, 1]) es2_side_sill(s);
            for (s = [-1, 1]) translate([s > 0 ? frame_hx - p(END_SILL_T) : -frame_hx, -frame_hw, esill_bot])
                cube([p(END_SILL_T), 2 * frame_hw, deck_z - esill_bot]);
            // frame bolster over each truck, with a centre plate
            for (s = [-1, 1]) translate([s * truck_x - 8, -sill_web_y, pivot_z + PIVOT_GAP])
                cube([16, 2 * sill_web_y, deck_bot - pivot_z - PIVOT_GAP + 0.01]);
            // coupler pads
            for (s = [-1, 1]) translate([s > 0 ? frame_hx - COUPLER_PAD[0] : -frame_hx, -COUPLER_PAD[1] / 2, esill_bot - 2.5])
                cube([COUPLER_PAD[0], COUPLER_PAD[1], 2.51]);
            for (sx = [-1, 1], sy = [-1, 1]) es2_pole_pocket(sx, sy);
            frame_rod_ribs();
            if (rivets) es2_frame_rivets();
            frame_lever_brackets();
        }
        frame_lever_holes();
        frame_air_hose_holes();
        frame_rod_holes();
        frame_body_screw_holes();
        frame_step_holes();
        // truck pivot (Tom 10/18): shoulder bolt dropped in from the deck top (under the hood), head in a counterbore
        for (s = [-1, 1]) translate([s * truck_x, 0, 0]) {
            translate([0, 0, pivot_z - 1]) cylinder(d = PIVOT_FIT[0], h = deck_z - pivot_z + 2, $fn = FN);
            translate([0, 0, pivot_bolt_head_z]) cylinder(d = PIVOT_FIT[2], h = deck_z - pivot_bolt_head_z + 1, $fn = FN);
        }
        // coupler screw holes
        for (s = [-1, 1]) translate([s * (frame_hx - COUPLER_PAD[0] / 2), 0, esill_bot - 4]) cylinder(d = COUPLER_SCREW * 0.85, h = 10, $fn = 16);
    }
}
// step (stirrup) under each frame corner, printed SEPARATELY flat (Tom 10/18) and pinned up into the
// sill web with two 1 mm wire pins. Tread 14 in above the rail (ESTIMATE). Local frame: legs at x = 0
// and x = step_w, top of the legs at z = 0 (against the sill), tread down at -(sill_bot - step_zt).
module es2_step() {
    H = sill_bot - step_zt; t = 2.0; th = 2.4;
    difference() {
        union() {
            for (x = [0, step_w]) translate([x - t / 2, -th / 2, -H]) cube([t, th, H]);                  // legs
            for (x = [0, step_w]) translate([x - 2, -th / 2, -3]) cube([4, th, 3]);                      // pin tabs
            translate([-t / 2 - 0.6, -th / 2, -H]) cube([step_w + t + 1.2, th, 2.2]);                     // tread
            translate([-t / 2, -th / 2, -H + 2.2]) cube([step_w + t, th, 0.8]);                           // tread lip
        }
        for (x = [0, step_w]) translate([x, 0, -4]) cylinder(d = STEP_PIN, h = 5, $fn = 12);
    }
}
module es2_steps_placed() for (sx = [-1, 1], sy = [-1, 1]) translate([step_leg_x(sx)[0], sy * step_y, sill_bot]) scale([-sx, 1, 1]) es2_step();
module es2_step_print() rotate([90, 0, 0]) translate([0, 1.2, 0]) es2_step();     // flat, legs up the bed
module es2_frame_half(s = 1, rivets = true) {    // s = +1: x >= 0 (frame A, hood 2 end); -1: x <= 0 (frame B, hood 1 end)
    intersection() { es2_frame_full(rivets); translate([s > 0 ? 0 : -frame_hx - 1, -100, 0]) cube([frame_hx + 1, 200, 100]); }
}

// ---------------- diamond-plate walkways (Tom 10/17) ----------------
// The deck round each hood: both sides and the end platform. A thin plate, printed flat with
// the tread up, glued on the deck. s = +1 hood 2 end, -1 hood 1 end. Loco position, on the deck.
module walk_2d(s) {
    difference() {
        translate([cab_hx + 0.4, -frame_hw + 0.3]) square([frame_hx - cab_hx - 0.7, 2 * frame_hw - 0.6]);
        translate([cab_hx, 0]) offset(delta = 0.5) hood_plan_2d();
        if (s > 0 && HAS_TANK) translate([cab_hx + p(2) - 0.5, TANK_SIDE > 0 ? hood_w / 2 - 1 : -hood_w / 2 - p(TANK[1]) - 1.5])
            square([p(TANK[0]) + 1, p(TANK[1]) + 2.5]);
        // ladder feet stand on the deck at the hood end
        translate([cab_hx + hood_l - 0.1, p(LADDER_Y) - p(LADDER[0]) / 2 - 1.5]) square([p(LADDER[3]) + 2.5, p(LADDER[0]) + 3]);
    }
}
module lugs_2d(s) {
    L = WALK_LUG[0]; W = WALK_LUG[1]; P = WALK_LUG[3];
    intersection() {
        offset(delta = -0.9) walk_2d(s);
        for (i = [0 : floor((frame_hx - cab_hx) / P)], j = [-floor(frame_hw / P) : floor(frame_hw / P)])
            translate([cab_hx + i * P + P / 2, j * P]) rotate((i + j) % 2 == 0 ? 45 : -45) square([L, W], center = true);
    }
}
module es2_walkway(s = 1) {
    mirror([s > 0 ? 0 : 1, 0, 0]) translate([0, 0, deck_z]) {
        linear_extrude(WALK_T) walk_2d(s);
        translate([0, 0, WALK_T - 0.01]) linear_extrude(WALK_LUG[2] + 0.01) lugs_2d(s);
    }
}

// Underside: the box between the trucks (reservoirs / weight). It is glued under the
// deck ACROSS the joint, so it is also what holds the two frame halves together.
// Open on top (the deck closes it): a pocket for lead or steel weight.
// Print position: bottom face down, open side up.
module es2_underside() {
    w = HOOD_WALL;
    difference() {
        union() {
            translate([-res_hx, -res_hw, res_bot]) cube([2 * res_hx, 2 * res_hw, deck_bot - res_bot]);
            // air reservoirs along each side (detail), with end heads and hanger straps
            for (s = [-1, 1]) translate([-res_hx + 3, s * (res_hw + p(6) - 1.2), res_bot + p(6)]) rotate([0, 90, 0]) {
                cylinder(r = p(6), h = 2 * res_hx - 6, $fn = FN);
                for (e = [0, 1]) translate([0, 0, e * (2 * res_hx - 6)]) scale([1, 1, 0.35]) sphere(r = p(6), $fn = FN);
                for (e = [0.22, 0.78]) translate([0, 0, e * (2 * res_hx - 6) - 0.8]) cylinder(r = p(6) + 0.4, h = 1.6, $fn = FN);
            }
        }
        translate([-res_hx + w, -res_hw + w, res_bot + w]) cube([2 * res_hx - 2 * w, 2 * res_hw - 2 * w, 50]);
        translate([-100, -100, deck_bot]) cube([200, 200, 50]);
        translate([-100, -100, res_bot - 50]) cube([200, 200, 50]);     // reservoirs flush with the bottom
        translate([-100, -3.4, deck_bot - 3.4]) cube([200, 6.8, 3.5]);  // v8: slot for the rib over the middle joining rod
    }
}
