// =====================================================================
//  es2_body.scad  -  hoods, cab and cab roof
//  Each module is drawn in its PRINT position: bottom face on z = 0.
//  es2_all.scad moves them onto the loco for the preview.
//  v6 (Tom 10/17): hinged hood doors that can be shown open, hooded louvres and
//  grilles (the slots by the cab on the HO E83), hatches and the ventilator on the
//  hood tops, insulators, hand-hole covers, ladders on the hood ends, railing posts
//  with holes for the wire, rivets, window visors, grab irons, cab door hinges.
// =====================================================================

// ---------------- hoods ----------------
// Local frame: x = 0 at the cab face, + toward the hood end; z = 0 at the deck.
function hood_top(x) = p(HOOD_H_CAB) - (p(HOOD_H_CAB) - p(HOOD_H_END)) * x / hood_l;
hood_slope = atan((p(HOOD_H_CAB) - p(HOOD_H_END)) / hood_l);     // degrees, the top falls toward the end

module hood_side_2d(inset = 0) {          // side view, x along, y = up
    big = 40;
    offset(delta = -inset) offset(r = p(HOOD_R_END)) offset(delta = -p(HOOD_R_END))
        polygon([[-big, -big], [hood_l, -big], [hood_l, p(HOOD_H_END)],
                 [-big, hood_top(-big)]]);
}
module hood_plan_2d(inset = 0) {          // plan view
    big = 40;
    offset(delta = -inset) offset(r = p(HOOD_R_PLAN)) offset(delta = -p(HOOD_R_PLAN))
        translate([-big, -hood_w / 2]) square([hood_l + big, hood_w]);
}
module hood_volume(inset = 0) {
    intersection() {
        rotate([90, 0, 0]) linear_extrude(height = 300, center = true) hood_side_2d(inset);
        translate([0, 0, -100]) linear_extrude(height = 400) hood_plan_2d(inset);
    }
}
module hood_outer() intersection() { hood_volume(0); translate([0, -100, 0]) cube([hood_l + 1, 200, 200]); }
module hood_inner() intersection() { hood_volume(HOOD_WALL); translate([-1, -100, -1]) cube([hood_l + 2, 200, 200]); }
module on_hood_top(x, y) translate([x, y, hood_top(x)]) rotate([0, hood_slope, 0]) children();

// Doors, louvres, grilles, recessed panels (x from the cab face, z above the deck, prototype inches)
// type: "R" hinged door, "I" recessed panel, "L" hooded louvre, "G" grille
// s = side: -1 the drawing's side, +1 the far side (HO model: hood 2 there has five doors, no recess)
function hood_panels(n, s = -1) = n == 1 ?
    concat([for (i = [0:5]) [27.5 + i * 20.6, 27.5 + i * 20.6 + 19.6, 12.7, 42.8, "R"]],
           [for (zc = [17.5, 30.3, 51.5, 65]) [4, 21.7, zc - 2.25, zc + 2.25, "L"]],
           [[63, 77, 50, 60, "G"], [79, 93, 50, 60, "G"]])        // HO E83: two grilles high on hood 1
  : s > 0 ? [for (i = [0:4]) [4 + i * 29.4, 4 + i * 29.4 + 28.4, 4.4, 50, "R"]]
  : concat([[2.5, 57, 3, 50, "I"]],
           [for (i = [0:2]) [59.5 + i * 30.7, 59.5 + i * 30.7 + 29.7, 4.4, 50, "R"]]);

function under_tank(n, s, pn) = HAS_TANK && n == 2 && s == TANK_SIDE && pn[0] < TANK[0] + 2;
function hood_doors(n, s) = [for (pn = hood_panels(n, s)) if (pn[4] == "R" && !under_tank(n, s, pn)) pn];
function door_open(n, s) = DOOR_OPEN > 0 && (DOORS_SHOWN == "ALL" || (DOORS_SHOWN == "HOOD_1" && n == 1) ||
    (DOORS_SHOWN == "HOOD_2" && n == 2) || (DOORS_SHOWN == "TANK_SIDE" && s == TANK_SIDE) || (DOORS_SHOWN == "FAR_SIDE" && s != TANK_SIDE));
yw = hood_w / 2;                          // outer face of the side wall

// one door leaf in the closed position, side s: wall thickness + raised panel, three hinges, latch handle.
// Doors open in pairs from the middle (GE PRACTICE): even doors hinged at the cab end, odd at the far end.
module hood_door(pn, i, s) {
    x0 = p(pn[0]); x1 = p(pn[1]); z0 = p(pn[2]); z1 = p(pn[3]);
    hx = i % 2 == 0 ? x0 : x1; fx = i % 2 == 0 ? x1 : x0; dir = i % 2 == 0 ? 1 : -1;
    scale([1, s, 1]) {
        translate([x0, yw - HOOD_WALL + 0.05, z0]) cube([x1 - x0, HOOD_WALL - 0.05 + PANEL_PROUD, z1 - z0]);
        for (f = [0.12, 0.5, 0.88]) translate([hx, yw + PANEL_PROUD - 0.05, z0 + f * (z1 - z0) - p(2)]) scale([dir, 1, 1]) hinge_butt();
        translate([fx - dir * p(4), yw + PANEL_PROUD - 0.05, z0 + 0.5 * (z1 - z0) - p(3)]) {   // latch handle
            translate([-0.5, 0, 0]) cube([1.0, 0.7, p(6)]);
            translate([0, 0.35, p(3)]) rotate([-90, 0, 0]) cylinder(d = 1.6, h = 0.6, $fn = 12);
        }
    }
}
module hood_door_placed(pn, i, s, n, open) {
    hx = i % 2 == 0 ? p(pn[0]) : p(pn[1]); dir = i % 2 == 0 ? 1 : -1;
    if (open && door_open(n, s))
        translate([hx, s * (yw + PANEL_PROUD + 0.45), 0]) rotate([0, 0, s * dir * DOOR_OPEN]) translate([-hx, -s * (yw + PANEL_PROUD + 0.45), 0]) hood_door(pn, i, s);
    else hood_door(pn, i, s);
}
module hood_door_openings(n) {
    for (s = [-1, 1]) if (door_open(n, s)) for (pn = hood_doors(n, s))
        translate([p(pn[0]) + 0.05, s > 0 ? yw - HOOD_WALL - 0.05 : -yw - 5, p(pn[2]) + 0.05]) cube([p(pn[1] - pn[0]) - 0.1, HOOD_WALL + 5.05, p(pn[3] - pn[2]) - 0.1]);
}

module hood_panel_add(n, open = false) {
    for (s = [-1, 1]) {
        dd = hood_doors(n, s);
        for (i = [0 : len(dd) - 1]) hood_door_placed(dd[i], i, s, n, open);
        for (pn = hood_panels(n, s)) if (pn[4] == "L") scale([1, s, 1])         // the hood over each louvre slot
            translate([p(pn[0]), yw - 0.01, p(pn[3])]) rotate([90, 0, 90]) linear_extrude(p(pn[1] - pn[0]))
                polygon([[0, 0.9], [0.9, 0], [0.9, -0.35], [0, -1.25]]);
    }
}
module hood_panel_cut(n) {
    for (s = [-1, 1]) for (pn = hood_panels(n, s)) if (!under_tank(n, s, pn)) scale([1, s, 1]) {
        x0 = p(pn[0]); x1 = p(pn[1]); z0 = p(pn[2]); z1 = p(pn[3]);
        if (pn[4] == "I") translate([x0, yw - ENGRAVE, z0]) cube([x1 - x0, ENGRAVE + 1, z1 - z0]);
        if (pn[4] == "L") translate([x0, yw - 0.9, z0]) cube([x1 - x0, 0.91, z1 - z0]);
        if (pn[4] == "G") difference() {                   // grille: recess with upright bars
            translate([x0, yw - 0.9, z0]) cube([x1 - x0, 1.9, z1 - z0]);
            for (bx = [x0 + 1.1 : 1.3 : x1 - 0.8]) translate([bx, yw - 1, z0 - 1]) cube([0.55, 3, z1 - z0 + 2]);
        }
    }
}
// what is seen through the open doors (preview / render only): contactor and resistor frames
module es2_hood_inside(n) {
    yi = yw - HOOD_WALL - 2.5;
    for (k = [0 : 3]) let(x0 = p(10) + k * (hood_l - p(24)) / 4, x1 = x0 + (hood_l - p(24)) / 4 - 2) {
        translate([x0, -yi, 0]) cube([x1 - x0, 2 * yi, p(6)]);                                   // base
        for (j = [0 : 4]) translate([x0 + 1, -yi + 1, p(9) + j * p(8)]) cube([x1 - x0 - 2, 2 * yi - 2, p(2)]);   // grid frames
        for (e = [x0 + 1, x1 - 2.5]) translate([e, -yi, 0]) cube([1.5, 2 * yi, min(p(48), hood_top(x1) - HOOD_WALL - 3)]);
    }
}

// level pad for the headlight tower on the sloping hood top, with a 2 mm pin hole
hl_x = hood_l - p(HL_TOWER_IN);
hl_pad = p(15);
hl_pad_top = hood_top(hl_x - hl_pad / 2) + 1.0;
module hood_level_pad(x, w) {          // flat pad on the sloping top, top at pad_top(x, w)
    translate([x - w / 2, -w / 2, hood_top(x + w / 2) - HOOD_WALL])
        cube([w, w, pad_top(x, w) - (hood_top(x + w / 2) - HOOD_WALL)]);
}
function pad_top(x, w) = hood_top(x - w / 2) + 1.0;
module hood_headlight_pad() hood_level_pad(hl_x, hl_pad);
// bell on hood 1 (MPL sheet 06)
bell_x = p(BELL_X); bell_pad = p(9);
bell_pad_top = pad_top(bell_x, bell_pad);
// sandbox filler caps over the sandboxes inside each hood end (MPL sheets 03 / 04)
module hood_sand_caps() {
    x = hood_l - p(SAND_CAP_IN);
    for (s = [-1, 1]) translate([x, s * p(25), hood_top(x) - HOOD_WALL]) {
        cylinder(d = p(7), h = HOOD_WALL + 1.0, $fn = FN);
        cylinder(d = p(4), h = HOOD_WALL + 1.8, $fn = FN);
    }
}

// ---------------- hood-top equipment (HO E83, GE PRACTICE) ----------------
// access hatch: raised plate, rounded corners, two hinges on the cab-side edge, lift handle
module hood_hatch(L, W) {
    translate([0, 0, -HOOD_WALL]) linear_extrude(HOOD_WALL + 0.6) offset(r = 1.5) offset(delta = -1.5) square([L, W], center = true);
    for (e = [-1, 1]) translate([-L / 2 - 0.2, e * W / 4, 0.6]) rotate([90, 0, 0]) cylinder(d = 1.3, h = p(5), center = true, $fn = 16);
    translate([L / 2 - 2.5, -p(3), 0.5]) cube([1.0, p(6), 0.9]);
}
// ventilator over the resistors (HO E83, hood 2 top): frame with six slats along the hood
module hood_ventilator(L, W) {
    translate([0, 0, -HOOD_WALL]) linear_extrude(HOOD_WALL + 0.6) offset(r = 1) offset(delta = -1) square([L, W], center = true);
    for (j = [0 : 5]) translate([-L / 2 + 1.5, -W / 2 + 2 + j * (W - 4) / 5 - 0.7, 0.5]) cube([L - 3, 1.4, 1.3]);
}
// oval hatch near the hood end (HO E83)
module hood_oval_hatch(L, W) {
    translate([0, 0, -HOOD_WALL]) linear_extrude(HOOD_WALL + 0.7) hull() for (e = [-1, 1]) translate([e * (L - W) / 2, 0]) circle(d = W, $fn = FN);
    translate([-L / 2 + 0.3, 0, 0.6]) rotate([90, 0, 0]) cylinder(d = 1.3, h = W * 0.6, center = true, $fn = 16);
}
// insulators on hood 1 by the cab (HO E83: switch / arrester insulators): base plate, three stacks
module hood_insulators() {
    translate([-p(12), -p(13), -HOOD_WALL]) cube([p(24), p(26), HOOD_WALL + 0.8]);
    for (y = [-9, 0, 9]) translate([0, p(y), 0.7]) {
        cylinder(d = p(2.6), h = p(11), $fn = 16);
        for (k = [0 : 3]) translate([0, 0, p(1.5) + k * p(2.4)]) cylinder(d1 = p(5.5), d2 = p(3), h = p(1.2), $fn = FN);
        translate([0, 0, p(11)]) cylinder(d = p(3.4), h = p(1.5), $fn = 16);
    }
}
module hood_top_equipment(n) {
    if (n == 1) {
        on_hood_top(p(95), 0) hood_hatch(p(30), p(24));
        on_hood_top(p(22), 0) hood_insulators();
    } else {
        on_hood_top(p(44), 0) hood_ventilator(p(52), p(30));
        on_hood_top(p(112), 0) hood_oval_hatch(p(22), p(13));
    }
}
// hood end: two round hand-hole covers low down (HO E83), bolted
module hood_end_covers() {
    for (s = [-1, 1]) translate([hood_l - 0.01, s * p(26), p(5)]) rotate([0, 90, 0]) {
        cylinder(d = p(7), h = 0.45, $fn = FN);
        for (a = [0 : 60 : 300]) rotate([0, 0, a]) translate([p(2.6), 0, 0]) cylinder(d = 0.6, h = 0.75, $fn = 8);
    }
}

// ---------------- railings on the hood tops (Tom 10/17) ----------------
// 1 mm brass wire, painted white, threaded through printed posts; the two ends go down into holes
// in the hood top by the cab. Runs along both top edges and across the end.
rail_y  = yw - p(RAIL_IN);
rail_xa = p(4);
rail_xe = hood_l - p(HOOD_R_END) - p(4);
function rail_z(x) = hood_top(x) + p(RAIL_H);
rail_side_posts = [for (x = [rail_xa + p(RAIL_POST_PITCH) : p(RAIL_POST_PITCH) : rail_xe - p(12)]) x];
rail_end_posts  = [-p(12), p(12)];
function hood_rail_pts() = [
    [rail_xa, -rail_y, hood_top(rail_xa) - 3], [rail_xa, -rail_y, rail_z(rail_xa)], [rail_xe, -rail_y, rail_z(rail_xe)],
    [rail_xe, rail_y, rail_z(rail_xe)], [rail_xa, rail_y, rail_z(rail_xa)], [rail_xa, rail_y, hood_top(rail_xa) - 3]];
// v9 (Tom 10/20): the railing posts are SEPARATE small prints with a peg into a hole in the hood top.
POST_PEG  = [1.8, 2.5];         // peg dia, length (mm)
POST_HOLE = 2.0;                // hole in the hood for the peg
post_a = p(3);                  // post section
// one post; z = 0 on the hood top at the post centre; eyelet at the rail height.
// end = true: eyelet across the loco (the end posts); false: along the hood, tilted to the slope.
module es2_rail_post(end = false) {
    a = post_a; H = p(RAIL_H);
    difference() {
        union() {
            translate([-a / 2, -a / 2, 0]) cube([a, a, H]);
            translate([0, 0, H]) rotate(end ? [90, 0, 0] : [0, 90, 0]) cylinder(d = a, h = a, center = true, $fn = 20);
            translate([0, 0, -POST_PEG[1]]) cylinder(d = POST_PEG[0], h = POST_PEG[1] + 0.1, $fn = 16);
        }
        translate([0, 0, H]) rotate(end ? [90, 0, 0] : [0, 90 + hood_slope, 0]) cylinder(d = RAIL_HOLE, h = a + 2, center = true, $fn = 12);
    }
}
// lying on a side face so the peg and eyelet print strong
module es2_rail_post_print(end = false) translate([0, 0, post_a / 2]) rotate(end ? [0, 90, 0] : [90, 0, 0]) es2_rail_post(end);
module es2_rail_posts_placed() {            // hood local frame
    for (s = [-1, 1], x = rail_side_posts) translate([x, s * rail_y, hood_top(x)]) es2_rail_post(false);
    for (y = rail_end_posts) translate([rail_xe, y, hood_top(rail_xe)]) es2_rail_post(true);
}
rail_post_count = 2 * len(rail_side_posts) + len(rail_end_posts);
module hood_rail_holes() {
    for (s = [-1, 1], x = rail_side_posts) translate([x, s * rail_y, hood_top(x) - HOOD_WALL - 1]) cylinder(d = POST_HOLE, h = HOOD_WALL + 2, $fn = 16);
    for (y = rail_end_posts) translate([rail_xe, y, hood_top(rail_xe) - HOOD_WALL - 1]) cylinder(d = POST_HOLE, h = HOOD_WALL + 2, $fn = 16);
    for (s = [-1, 1]) translate([rail_xa, s * rail_y, hood_top(rail_xa) - 4]) cylinder(d = RAIL_HOLE, h = 5, $fn = 12);   // wire ends
}
module hood_rail_wire() wire(hood_rail_pts());

// ---------------- ladder on the hood end (Tom 10/17; HO E83) ----------------
// Printed flat (separate piece, on the hood plate), fixed with four 1 mm wire pins into the hood end.
ld_w = p(LADDER[0]); ld_off = p(LADDER[3]); ld_z = [p(4), p(54)];
ld_rungs = [for (k = [0 : LADDER[2] - 1]) p(14) + k * p(LADDER[1])];
ld_legs  = [p(9), p(45)];
module es2_ladder() {          // hood local frame, standing on the deck at the hood end, outer face at x = hood_l + ld_off
    st = [1.4, 1.6];           // stile: along x, across y
    translate([hood_l, p(LADDER_Y), 0]) difference() {
        union() {
            for (e = [-1, 1]) translate([ld_off - st[0], e * ld_w / 2 - st[1] / 2, ld_z[0]]) cube([st[0], st[1], ld_z[1] - ld_z[0]]);
            for (z = ld_rungs) translate([ld_off - st[0] / 2 - 0.6, -ld_w / 2, z - 0.6]) cube([1.2, ld_w, 1.2]);
            for (e = [-1, 1], z = ld_legs) translate([0, e * ld_w / 2 - st[1] / 2, z - 1.2]) cube([ld_off, st[1], 2.4]);
        }
        for (e = [-1, 1], z = ld_legs) translate([-1, e * ld_w / 2, z]) rotate([0, 90, 0]) cylinder(d = RAIL_HOLE, h = ld_off + 2, $fn = 12);
    }
}
module es2_ladder_print() rotate([0, 90, 0]) translate([-hood_l - ld_off, -p(LADDER_Y), 0]) es2_ladder();   // outer face down
module hood_ladder_holes() for (e = [-1, 1], z = ld_legs) translate([hood_l + 0.5, p(LADDER_Y) + e * ld_w / 2, z]) rotate([0, -90, 0]) cylinder(d = RAIL_HOLE, h = 4, $fn = 12);

// ---------------- rivets on the hood (Tom 10/17) ----------------
// rows along the bottom and the top of each side, up each door post (mullion), round the end
function hood_side_keepout(n, s) = concat(
    [for (pn = hood_panels(n, s)) if (!under_tank(n, s, pn)) [p(pn[0]) + 0.5, p(pn[1]) - 0.5, p(pn[2]) + 0.5, p(pn[3]) - 0.5]],
    HAS_TANK && n == 2 && s == TANK_SIDE ? [[p(1), p(TANK[0] + 3), -1, p(TANK[2]) + 1]] : []);
function hood_mullions(n, s) = let(d = hood_doors(n, s)) len(d) == 0 ? [] :
    concat([for (pn = d) p(pn[0]) - p(0.5)], [p(d[len(d) - 1][1]) + p(0.5)]);
module hood_rivets(n) {
    xe = hood_l - p(HOOD_R_PLAN) - p(1.5);
    for (s = [-1, 1]) {
        ko = hood_side_keepout(n, s); nn = s > 0 ? "+y" : "-y";
        pts = concat(
            rivet_line([p(2.5), s * yw, p(2.5)], [xe, s * yw, p(2.5)]),
            [for (q = rivet_line([p(2.5), 0, 0], [hood_l - p(HOOD_R_END) - p(2), 0, 0])) [q[0], s * yw, hood_top(q[0]) - p(2.5)]],
            [for (x = hood_mullions(n, s)) for (q = rivet_line([x, s * yw, p(6)], [x, s * yw, min(p(50), hood_top(x) - p(6))])) q],
            rivet_line([xe, s * yw, p(6)], [xe, s * yw, p(HOOD_H_END - HOOD_R_END - 2)]));
        for (q = outside_all(pts, ko)) rivet_on(q, nn);
    }
    ye = yw - p(HOOD_R_PLAN) - p(2);
    lad = [p(LADDER_Y) - ld_w / 2 - 1.5, p(LADDER_Y) + ld_w / 2 + 1.5];
    for (q = concat(rivet_line([hood_l, -ye, p(2.5)], [hood_l, ye, p(2.5)]),
                    rivet_line([hood_l, -ye, p(9)], [hood_l, -ye, p(HOOD_H_END - HOOD_R_END - 2)]),
                    rivet_line([hood_l, ye, p(9)], [hood_l, ye, p(HOOD_H_END - HOOD_R_END - 2)])))
        if (!(q[1] > lad[0] && q[1] < lad[1] && q[2] < p(56)) && !(abs(abs(q[1]) - p(26)) < p(5) && q[2] < p(10))) rivet_on(q, "+x");
}

// ---------------- screw fixing (v8, Tom 10/18: as on the passenger cars) ----------------
// Hood to deck: four bosses on the hood side walls, M2.5 screws up through the deck.
// Cab to hood: a boss each side in the hood's cab end, M2.5 screw from inside the cab through the end wall.
hood_screw_x = [p(23), hood_l - p(23)];
hood_screw_y = yw - HOOD_WALL - BODY_BOSS / 2 - 0.5;
ch_y = yw - HOOD_WALL - 3.5;                 // cab-to-hood screw, across
module body_boss(h = BODY_BOSS_H) {           // on a wall at +y, centre at the origin, 45 degree top
    hull() {
        translate([-BODY_BOSS / 2, -BODY_BOSS / 2, 0]) cube([BODY_BOSS, BODY_BOSS + 0.6, h - BODY_BOSS - 1]);
        translate([-BODY_BOSS / 2, BODY_BOSS / 2, h - 0.1]) cube([BODY_BOSS, 0.6, 0.1]);
    }
}
module hood_screw_bosses() {
    for (x = hood_screw_x, s = [-1, 1]) translate([x, s * hood_screw_y, 0]) scale([1, s, 1]) body_boss();
    for (s = [-1, 1]) scale([1, s, 1]) hull() {                       // cab-end block for the cab screw
        translate([0, ch_y - 3.5, 0]) cube([8, yw - HOOD_WALL - ch_y + 3.5 + 0.01, CAB_HOOD_Z + 4]);
        translate([0, yw - HOOD_WALL - 0.6, CAB_HOOD_Z + 11]) cube([8, 0.61, 0.1]);
    }
}
module hood_screw_holes() {
    for (x = hood_screw_x, s = [-1, 1]) translate([x, s * hood_screw_y, -1]) cylinder(d = BODY_PILOT, h = BODY_BOSS_H - 1, $fn = 16);
    for (s = [-1, 1]) translate([-0.1, s * ch_y, CAB_HOOD_Z]) rotate([0, 90, 0]) cylinder(d = BODY_PILOT, h = 8, $fn = 16);
}
// cab to deck: four bosses inside the cab end walls, clear of the reservoirs and rods under the deck
cab_screw_x = cab_hx - CAB_WALL - BODY_BOSS / 2 + 0.6;
cab_screw_y = p(40.5);
module cab_screw_bosses() for (sx = [-1, 1], sy = [-1, 1]) translate([sx * cab_screw_x, sy * cab_screw_y, 0]) rotate([0, 0, sx > 0 ? -90 : 90]) body_boss();
module cab_screw_holes() {
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * cab_screw_x, sy * cab_screw_y, -1]) cylinder(d = BODY_PILOT, h = BODY_BOSS_H - 1, $fn = 16);
    for (sx = [-1, 1], s = [-1, 1]) translate([sx > 0 ? cab_hx - CAB_WALL - 1 : -cab_hx - 1, s * ch_y, CAB_HOOD_Z]) rotate([0, 90, 0]) cylinder(d = BODY_CLEAR_D, h = CAB_WALL + 2, $fn = 16);
}
// every screw up through the deck, loco position (used by the frame)
function body_screw_pts() = concat(
    [for (n = [-1, 1], x = hood_screw_x, s = [-1, 1]) [n * (cab_hx + x), s * hood_screw_y]],
    [for (sx = [-1, 1], sy = [-1, 1]) [sx * cab_screw_x, sy * cab_screw_y]]);

// bulkhead with a pointed-arch opening (prints without support)
module hood_bulkhead(xb) {
    wa = hood_w - 2 * HOOD_WALL - 8;
    hs = hood_top(xb) - HOOD_WALL - 5 - wa / 2;
    difference() {
        intersection() { hood_inner(); translate([xb - 0.8, -100, 0]) cube([1.6, 200, 200]); }
        translate([xb, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 4, center = true)
            polygon([[-wa / 2, -1], [wa / 2, -1], [wa / 2, hs], [0, hs + wa / 2], [-wa / 2, hs]]);
    }
}

// side tank on hood 2 (later years; E81 / E82 photos), on one side only
module hood_tank() {
    L = p(TANK[0]); D = p(TANK[1]); H = p(TANK[2]); r = p(TANK[3]);
    y0 = hood_w / 2 - 0.5;
    scale([1, TANK_SIDE, 1]) {
        hull() {
            translate([p(2), y0, 0]) cube([L, D + 0.5 - r, H]);
            translate([p(2), y0, 0]) cube([L, D + 0.5, H - r]);
            translate([p(2), y0 + D + 0.5 - r, H - r]) rotate([0, 90, 0]) cylinder(r = r, h = L, $fn = FN);
        }
        for (f = [0.2, 0.8]) translate([p(2) + f * L - 0.8, y0, 0]) cube([1.6, D + 0.9, H - r + 0.6]);   // straps (GE PRACTICE)
        translate([p(2) + L * 0.5, y0 + D + 0.5 - r, H]) cylinder(d = p(4), h = 1.2, $fn = 20);         // filler
    }
}

// n = 1 or 2 (the drawing's "1" end is the hood with six doors).
// rivets / posts: false for the painted preview, which draws them grey / white separately.
// open: show the doors open (DOOR_OPEN, DOORS_SEL); prints are always closed.
module es2_hood(n = 1, rivets = true, posts = true, open = false) {
    difference() {
        union() {
            difference() { hood_outer(); hood_inner(); if (open) hood_door_openings(n); }
            if (n == 2 && HAS_TANK) hood_tank();
            for (i = [1:BULKHEADS]) hood_bulkhead(hood_l * i / (BULKHEADS + 1));
            hood_panel_add(n, open);
            hood_headlight_pad();
            hood_sand_caps();
            hood_top_equipment(n);
            hood_end_covers();
            if (n == 1) hood_level_pad(bell_x, bell_pad);
            if (n == 2) hood_mast_pad();
            if (rivets) hood_rivets(n);
            hood_screw_bosses();
        }
        hood_panel_cut(n);
        hood_screw_holes();
        hood_rail_holes();
        if (n == 2) hood_mast_hole();
        hood_ladder_holes();
        translate([hl_x, 0, hl_pad_top - 6]) cylinder(d = 2.1, h = 10, $fn = 16);
        if (n == 1) translate([bell_x, 0, bell_pad_top - 6]) cylinder(d = 2.1, h = 10, $fn = 16);
    }
}

// ---------------- cab ----------------
// Local frame: x = 0 cab middle, z = 0 at the deck. Print upright, open top and bottom.
module cut_y(xa, xb, za, zb, sides = [-1, 1]) {     // window through the side wall(s)
    for (s = sides) translate([xa, s > 0 ? cab_hw - CAB_WALL - 1 : -cab_hw - 1, za])
        cube([xb - xa, CAB_WALL + 2, zb - za]);
}
// one later cab-side window: rows 2 = 2 x 2 panes, rows 1 = two panes side by side
module cab_side_window(w) {
    s = w[0]; W = p(w[1]); H = p(w[2]); z0 = p(w[3]); xc = p(w[4]); rows = w[5]; bar = p(2);
    pw = (W - bar) / 2; ph = rows == 2 ? (H - bar) / 2 : H;
    for (i = [0, 1], j = [0 : rows - 1]) cut_y(xc - W / 2 + i * (pw + bar), xc - W / 2 + i * (pw + bar) + pw,
                                              z0 + j * (ph + bar), z0 + j * (ph + bar) + ph, [s]);
}
module cut_x(sx, ya, yb, za, zb, depth = 0) {   // through (or into, depth > 0) one end wall
    d = depth > 0 ? depth : CAB_WALL + 2;
    x0 = depth > 0 ? (sx > 0 ? cab_hx - depth : -cab_hx - 0.01) : (sx > 0 ? cab_hx - CAB_WALL - 1 : -cab_hx - 1);
    translate([x0, ya, za]) cube([d + 0.01, yb - ya, zb - za]);
}
module sash_y(xc, w, h, z0, bar) {          // 2 x 2 panes
    pw = (w - bar) / 2; ph = (h - bar) / 2;
    for (i = [0, 1], j = [0, 1]) cut_y(xc - w / 2 + i * (pw + bar), xc - w / 2 + i * (pw + bar) + pw,
                                     z0 + j * (ph + bar), z0 + j * (ph + bar) + ph);
}
// one end wall, as in the drawing's end view; the far end is the same turned 180 degrees
module cab_end_cuts(sx) {
    m = sx > 0 ? 1 : -1;                        // y as drawn (from the +x end)
    function yy(a, b) = m > 0 ? [a, b] : [-b, -a];
    // opening into the hood: pointed arch, same width as the hood's inside
    wa = hood_w - 2 * HOOD_WALL - 2 * CAB_ARCH_IN; hs = hood_top(0) - HOOD_WALL - wa / 2 - 3;   // v8: narrower, leaves wall for the cab-hood screws
    translate([sx * cab_hx, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = 2 * CAB_WALL + 2, center = true)
        polygon([[-wa / 2, -1], [wa / 2, -1], [wa / 2, hs], [0, hs + wa / 2], [-wa / 2, hs]]);
    // two windows over the hood
    for (yc = [-18.5, 18.5]) { y = yy(p(yc - 11.85), p(yc + 11.85)); cut_x(sx, y[0], y[1], p(86), p(96.5)); }
    // tall window, one side of the hood
    y1 = yy(p(-55), p(-38.2)); cut_x(sx, y1[0], y1[1], p(70), p(96.5));
    // door onto the walkway, other side: recessed outline + two windows
    yd = yy(p(39.1), p(56.4)); cut_x(sx, yd[0], yd[1], p(3), p(96.5), ENGRAVE);
    yw = yy(p(41.8), p(53.6));
    cut_x(sx, yw[0], yw[1], p(76), p(94.5));
    cut_x(sx, yw[0], yw[1], p(55), p(74));
}
mag_x = p(42);                          // magnet bosses on the side walls
mag_y = cab_hw - CAB_WALL - 4.5;

// weather visor over each cab side window (Tom 10/17: "I like the weather protector on the windows").
// 45 degree underside so it prints on the upright cab without support.
module cab_visor(w) {
    s = w[0]; W = p(w[1]) + p(4); xc = p(w[4]); d = p(3); zt = p(w[3] + w[2]) + d + 0.8;
    translate([xc - W / 2, 0, 0]) scale([1, s, 1]) translate([0, cab_hw - 0.01, zt]) rotate([90, 0, 90]) linear_extrude(W)
        polygon([[0, 1.0], [d, 0.2], [d, -0.4], [0, -0.4 - d]]);
}
// grab irons at the four cab corners, on the sides (GE PRACTICE; HO E83 has them by the doors)
cab_grab_z = [p(16), p(62)];
function cab_grabs() = [for (sx = [-1, 1], sy = [-1, 1]) [sx * (cab_hx - p(6)), sy]];
module cab_grab_holes() for (g = cab_grabs(), z = cab_grab_z) wire_hole([g[0], g[1] * cab_hw, z], [0, g[1], 0], 3);
module cab_grab_wire() for (g = cab_grabs()) grab_iron([g[0], g[1] * cab_hw, cab_grab_z[0]], [g[0], g[1] * cab_hw, cab_grab_z[1]], [0, g[1], 0], p(3.5));
// cab end doors: three hinges on the outer edge, latch handle on the inner edge (drawn for the +x end)
module cab_door_hardware() {
    for (sx = [-1, 1]) rotate([0, 0, sx > 0 ? 0 : 180]) {
        for (f = [0.12, 0.5, 0.88]) translate([cab_hx - ENGRAVE - 0.05, p(56.4), p(3) + f * p(93.5) - p(2)]) rotate([0, 0, -90]) hinge_butt();
        translate([cab_hx - ENGRAVE - 0.05, p(42.5), p(44)]) { cube([0.75, 1.0, p(6)]); translate([0, 0.5, p(3)]) rotate([0, 90, 0]) cylinder(d = 1.6, h = 0.7, $fn = 12); }
    }
}
// rivets: the corners (both faces), along the bottom, under the eave
module cab_rivets() {
    ko_side = [for (w = CAB_WIN) [p(w[4]) - p(w[1]) / 2 - 1, p(w[4]) + p(w[1]) / 2 + 1, p(w[3]) - 1, p(w[3] + w[2]) + p(4)]];
    for (sy = [-1, 1]) {
        pts = concat(rivet_line([-cab_hx + p(2), sy * cab_hw, p(2.5)], [cab_hx - p(2), sy * cab_hw, p(2.5)]),
                     rivet_line([-cab_hx + p(2), sy * cab_hw, eave_z - p(2.5)], [cab_hx - p(2), sy * cab_hw, eave_z - p(2.5)]),
                     [for (sx = [-1, 1]) for (q = rivet_line([sx * (cab_hx - p(2)), sy * cab_hw, p(6)], [sx * (cab_hx - p(2)), sy * cab_hw, eave_z - p(6)])) q]);
        for (q = outside_all(pts, ko_side)) if (abs(abs(q[0]) - (cab_hx - p(6))) > 1.2) rivet_on(q, sy > 0 ? "+y" : "-y");
    }
    // ends: corner rows clear of the hood and the door
    for (sx = [-1, 1]) rotate([0, 0, sx > 0 ? 0 : 180]) {
        pts = concat(rivet_line([cab_hx, -cab_hw + p(2), p(3)], [cab_hx, -cab_hw + p(2), eave_z - p(3)]),
                     rivet_line([cab_hx, p(58), p(3)], [cab_hx, p(58), eave_z - p(3)]));
        for (q = pts) rivet_on(q, "+x");
    }
}
module es2_cab(rivets = true) {
    difference() {
        union() {
            difference() {
                translate([-cab_hx, -cab_hw, 0]) cube([2 * cab_hx, 2 * cab_hw, eave_z]);
                translate([-cab_hx + CAB_WALL, -cab_hw + CAB_WALL, -1]) cube([2 * cab_hx - 2 * CAB_WALL, 2 * cab_hw - 2 * CAB_WALL, eave_z + 2]);
            }
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx * mag_x - 4.5, sy > 0 ? mag_y - 4.5 : -mag_y - 4.5, 0])
                cube([9, 9, eave_z]);
            for (w = CAB_WIN) cab_visor(w);
            if (rivets) cab_rivets();
            cab_screw_bosses();
        }
        cab_screw_holes();
        for (w = CAB_WIN) cab_side_window(w);
        for (sx = [-1, 1]) cab_end_cuts(sx);
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * mag_x, sy * mag_y, eave_z - MAGNET[1]]) cylinder(d = MAGNET[0], h = MAGNET[1] + 1, $fn = FN);
        cab_grab_holes();
    }
    cab_door_hardware();
}

// ---------------- cab roof ----------------
// Solid curved roof, flat underside (prints upright, no support). Magnet pockets
// line up with the cab's; four insulator posts carry the pantograph.
roof_w = p(ROOF_W); roof_l = p(ROOF_L);
roof_e = p(ROOF_EDGE); roof_r = p(ROOF_RISE) - roof_e;
roof_R = (roof_w * roof_w / 4 + roof_r * roof_r) / (2 * roof_r);
function roof_z(y) = roof_e + roof_r - roof_R + sqrt(roof_R * roof_R - y * y);   // top surface
module roof_2d() {
    intersection() {
        union() {
            translate([-roof_w / 2, 0]) square([roof_w, roof_e]);
            translate([0, roof_e + roof_r - roof_R]) circle(r = roof_R, $fn = 360);
        }
        translate([-roof_w / 2, 0]) square([roof_w, roof_e + roof_r]);
    }
}
ins_d = p(7); ins_h = p(7);
pan_l = PAN_MODEL_L > 0 ? PAN_MODEL_L : p(PAN_BASE_L);
pan_w = PAN_MODEL_W > 0 ? PAN_MODEL_W : p(PAN_BASE_W);
ins_top = roof_z(pan_w / 2) + ins_h;
nb_y = roof_w / 2 - p(4);                      // board outer face, in from the roof edge
module es2_roof() {
    difference() {
        union() {
            rotate([90, 0, 90]) linear_extrude(height = roof_l, center = true) roof_2d();
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx * pan_l / 2, sy * pan_w / 2, roof_e])
                cylinder(d = ins_d, h = ins_top - roof_e, $fn = FN);
            // lightning arrester and whistle (MPL sheet 08, Roof Plan)
            arr_y = ARRESTER[4] * (nb_y - p(NUMBER_BOARD[1]) - 2 - p(ARRESTER[1]) / 2);
            translate([p(ARRESTER[3]) - p(ARRESTER[0]) / 2, arr_y - p(ARRESTER[1]) / 2, roof_e])
                cube([p(ARRESTER[0]), p(ARRESTER[1]), roof_z(abs(arr_y) - p(ARRESTER[1]) / 2) - roof_e + p(ARRESTER[2])]);
            translate([-p(34), ARRESTER[4] * (roof_w / 2 - p(16)), roof_e]) {
                cylinder(d = p(3), h = roof_z(roof_w / 2 - p(16)) - roof_e + p(9), $fn = 20);
                translate([0, 0, roof_z(roof_w / 2 - p(16)) - roof_e + p(7)]) cylinder(d1 = p(3), d2 = p(5), h = p(3), $fn = FN);
            }
            roof_trolley_base();         // US 13-B trolley base (MPL sheet 08), v7
            // number boards on each roof side, facing out (HO E83; E81 / E82 photos)
            for (sy = [-1, 1]) translate([-p(NUMBER_BOARD[0]) / 2, sy > 0 ? nb_y - p(NUMBER_BOARD[1]) : -nb_y, roof_e])
                cube([p(NUMBER_BOARD[0]), p(NUMBER_BOARD[1]), roof_z(nb_y) - roof_e + p(NUMBER_BOARD[2])]);
        }
        for (sy = [-1, 1]) translate([-p(NUMBER_BOARD[0]) / 2 + 1, sy > 0 ? nb_y - 0.4 : -nb_y - 0.6, roof_z(nb_y) + 1])
            cube([p(NUMBER_BOARD[0]) - 2, 1, p(NUMBER_BOARD[2]) - 2]);    // decal recess
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * mag_x, sy * mag_y, -1]) cylinder(d = MAGNET[0], h = MAGNET[1] + 1, $fn = FN);
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * pan_l / 2, sy * pan_w / 2, ins_top - 4]) cylinder(d = PAN_HOLE, h = 5, $fn = 12);
        roof_trolley_hole();
    }
}
