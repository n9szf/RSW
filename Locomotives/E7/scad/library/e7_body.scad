// ==========================================================================
//  e7_body.scad - carbody shell, frame, pilots and trucks for the MILW E7A.
//  x along the loco (front / A cab at +x), y across, z up from the rail top.
// ==========================================================================

EPS = 0.01;

// ---- carbody cross-section and loft ----
// v3: flat sides up to ze, crowned roof (parabola) from ze at the sides to zt on the centre line,
// side-to-roof corner rounded with radius r.  ze >= zt gives the old flat roof with corner radius r.
module e7_profile2d(hw, zb, zt, r, ze = 1e9) {
  zs = min(ze, zt);
  r2 = max(0.2, min(r, hw / 2, (zs - zb) / 2));
  n = 24;
  offset(r = r2) offset(delta = -r2)
    polygon(concat([[-hw, zb], [hw, zb]],
                   [for (i = [0:n]) let (u = hw - 2 * hw * i / n) [u, zt - (zt - zs) * pow(u / hw, 2)]]));
}
// one thin slab at x: 2D u -> y, v -> z
module e7_slab(x, hw, zb, zt, r, ze = 1e9) {
  translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(EPS) e7_profile2d(hw, zb, zt, r, ze);
}

// stations in model mm: [x, half width, bottom, top, radius, side edge height]
function e7_stations(off = 0) =
  let (
    zb = Z_SKIRT - (off > 0 ? 1 : 0),
    cab_edge = E7N_ROOF - E7N_ROOF_CROWN * E7N_HW * E7N_HW,      // the nose piece's cab roof at the sides
    cab  = [for (d = [CAB_BACK_IN[0], CAB_BACK_IN[1]]) [XF - p(d), HW - off, zb, Z_CAB - off, max(p(1) - off, 0.2), p(cab_edge) - off]],
    eng  = [[XF - p(CAB_BACK_IN[2]), HW - off, zb, Z_ROOF - off, p(ROOF_R_IN) - off, p(ROOF_EDGE_IN) - off]],
    rr = p(REAR_ROUND_IN),
    rear = [[XR + rr, HW - off, zb, Z_ROOF - off, p(ROOF_R_IN) - off, p(ROOF_EDGE_IN) - off],
            [XR + (off > 0 ? off : 0), HW - rr * 0.6 - off, zb, Z_ROOF - rr * 0.3 - off, p(ROOF_R_IN) - off, p(ROOF_EDGE_IN) - rr * 0.3 - off]]
  ) concat(cab, eng, rear);

// zc = [z from, z to]: clip the loft to a height band (used for the paint preview)
module e7_loft(off = 0, zc = [-1000, 1000]) {
  st = e7_stations(off);
  for (i = [0:len(st) - 2]) intersection() {
    hull() {
      e7_slab(st[i][0], st[i][1], st[i][2], st[i][3], st[i][4], st[i][5]);
      e7_slab(st[i + 1][0], st[i + 1][1], st[i + 1][2], st[i + 1][3], st[i + 1][4], st[i + 1][5]);
    }
    if (zc != [-1000, 1000]) translate([-1000, -500, zc[0]]) cube([2000, 1000, zc[1] - zc[0]]);
  }
  // v2: nose and cab front from e7_nose.scad
  intersection() {
    e7_nose_solid(off);
    if (zc != [-1000, 1000]) translate([-1000, -500, zc[0]]) cube([2000, 1000, zc[1] - zc[0]]);
  }
}

// ---- surface details cut into the shell (shallow, printable) ----
DET = max(0.4, WALL * 0.4);       // pocket depth

// v2: the two windshield panes as a recess DET deep in the nose skin; pane outline in plan
// (WS_Y_IN across, WS_D_IN back from the windshield base line), carried straight up through the slope
module e7_windshield_cut() {
  // the pane outline carried up through the slope, less everything inside the skin inset by DET
  difference() {
    e7_nose_place() for (s = [-1, 1]) scale([s, 1, 1])
      translate([0, 0, E7N_TOP - 6]) linear_extrude(E7N_ROOF - E7N_TOP + 20)
        polygon([for (c = [[WS_Y_IN[0], WS_D_IN[0]], [WS_Y_IN[1], WS_D_IN[0]], [WS_Y_IN[1], WS_D_IN[1]], [WS_Y_IN[0], WS_D_IN[1]]])
                   [c[0], E7N_WS_BASE + E7N_WS_SWEEP * c[0] + c[1]]]);
    e7_nose_solid(DET);
  }
}

// ---- side details (v3, 23 Nov 2026): layout from the Southern Ry E7 diagram, see e7_params ----
// 2D outline in the side plane: x = model mm along the loco, y = model mm up
module e7_side_rect2d(b, r = [0, 0]) {     // b = [v0, v1, z0, z1] inches; r = [front, back] corner radius
  x0 = XF - p(b[1]); x1 = XF - p(b[0]); z0 = p(b[2]); z1 = p(b[3]);
  rb = max(min(p(r[1]), (x1 - x0) / 2 - 0.05, (z1 - z0) / 2 - 0.05), 0.01);
  rf = max(min(p(r[0]), (x1 - x0) / 2 - 0.05, (z1 - z0) / 2 - 0.05), 0.01);
  hull() {
    translate([x0 + rb, z0 + rb]) circle(rb, $fn = 16); translate([x0 + rb, z1 - rb]) circle(rb, $fn = 16);
    translate([x1 - rf, z0 + rf]) circle(rf, $fn = 16); translate([x1 - rf, z1 - rf]) circle(rf, $fn = 16);
  }
}
// cut a 2D side shape into both side walls, depth d (mm) in from the outside face
module e7_side_pocket(d) {
  for (m = [0, 1]) mirror([0, m, 0])
    translate([0, HW + 2, 0]) rotate([90, 0, 0]) linear_extrude(d + 2) children();
}
// a groove outline (doors): ring of width t
module e7_side_outline2d(b, t) {
  difference() {
    e7_side_rect2d(b, [1.5, 1.5]);
    offset(delta = -t) e7_side_rect2d(b, [1.5, 1.5]);
  }
}
// diamond mesh: the pocket outline less a lattice of ribs
module e7_screen2d(b) {
  pitch = max(p(SCREEN_PITCH), 1.0); rib = max(p(0.8), 0.35);
  x0 = XF - p(b[1]); z0 = p(b[2]); w = p(b[1] - b[0]); h = p(b[3] - b[2]);
  n = ceil((w + h) / pitch) + 2;
  difference() {
    e7_side_rect2d(b, [1, 1]);
    intersection() {
      offset(delta = -rib) e7_side_rect2d(b, [1, 1]);
      translate([x0, z0]) for (a = [45, -45]) rotate(a)
        for (k = [-n:n]) translate([-2 * (w + h), k * pitch]) square([4 * (w + h), rib]);
    }
  }
}
module e7_side_windows2d() {
  for (w = CAB_WIN) e7_side_rect2d(w, CAB_WIN_R);
  e7_side_rect2d(DOOR_WIN, [WIN_R, WIN_R]);
  for (w = SIDE_WIN) e7_side_rect2d(w, [WIN_R, WIN_R]);
}
module e7_side_cuts() {
  gr = max(0.5, p(0.75));     // door groove width
  // windows: pockets DET deep (glass sits in them in the preview)
  e7_side_pocket(DET) e7_side_windows2d();
  // doors: outline grooves
  e7_side_pocket(DET * 0.6) { e7_side_outline2d(CAB_DOOR, gr); e7_side_outline2d(ENG_DOOR, gr); }
  // screened intakes
  e7_side_pocket(DET) for (b = SCREENS) e7_screen2d(b);
  // step well under the crew door: deeper pocket, two treads left standing
  e7_side_pocket(max(DET, WALL - 0.5)) difference() {
    e7_side_rect2d([STEP_WELL[0], STEP_WELL[1], SKIRT_IN - 2, STEP_WELL[2]], [0, 0]);
    for (k = [1, 2]) let (zt = SKIRT_IN + k * (STEP_WELL[2] - SKIRT_IN) / 3)
      translate([XF - p(STEP_WELL[1]) - 1, p(zt) - p(1.5)]) square([p(STEP_WELL[1] - STEP_WELL[0]) + 2, p(1.5)]);
  }
}

module e7_nose_front_cuts() {
  // nose door outline groove, following the face (vertical to E7N_BASE, leaning back above it)
  w = p(NOSE_DOOR[0]); h = p(NOSE_DOOR[1]); z = p(NOSE_DOOR[2]);
  translate([XF, 0, p(E7N_BASE)]) multmatrix([[1, 0, -E7N_LEAN, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) translate([0, 0, -p(E7N_BASE)])
    translate([-DET, -w / 2, z]) difference() {
      cube([DET + 3, w, h]);
      translate([-1, 0.5, 0.5]) cube([DET + 5, w - 1, h - 1]);
    }
}

// headlight boss on the nose (added)
module e7_headlight() {
  d = nose_d_at_z(HEADLIGHT[0]);
  translate([XF - p(d) - p(2), 0, p(HEADLIGHT[0])]) rotate([0, 90, 0]) {
    cylinder(d = p(HEADLIGHT[1]) + 1.2, h = p(HEADLIGHT[2]) + p(3), $fn = 32);
  }
}
// how far back from the tip the nose front reaches at a height (search the stations)
function nose_d_at_z(z) = e7n_face_d(z);    // v2: from the nose shape

// skirt cut-outs over the trucks
module e7_truck_openings() {
  for (tx = [TRK_X, -TRK_X])
    translate([tx - AX_SP - p(26), -HW - 5, -1]) cube([2 * AX_SP + p(52), 2 * HW + 10, Z_DECK + 1]);
}

module e7_shell_solid(zc = [-1000, 1000]) {
  difference() {
    union() { e7_loft(0, zc); if (p(HEADLIGHT[0]) > zc[0] && p(HEADLIGHT[0]) < zc[1]) e7_headlight(); }
    e7_loft(WALL);
    e7_windshield_cut();
    e7_side_cuts();
    e7_nose_front_cuts();
    e7_truck_openings();
    // lamp lens recess
    d = nose_d_at_z(HEADLIGHT[0]);
    translate([XF - p(d) + p(HEADLIGHT[2]) + p(1), 0, p(HEADLIGHT[0])]) rotate([0, 90, 0]) cylinder(d = p(HEADLIGHT[1]) - 0.6, h = 3, $fn = 32);
  }
}

// screw bosses inside the side walls (body screws come up through the frame)
module e7_bosses() {
  for (x = BOSS_X, s = [-1, 1])
    translate([x, s * (HW - WALL - BOSS[0] / 2 + 0.4), Z_DECK + BOSS[1] / 2])
      difference() {
        cube([BOSS[0], BOSS[0], BOSS[1]], center = true);
        cylinder(d = BODY_SCREW[0], h = BOSS[1] + 1, center = true, $fn = 16);
      }
}

// sleeve on the front edge of section k (reaches into section k+1)
module e7_sleeve(x) {
  // inside its own section the sleeve is fused to the wall; ahead of the joint it stands in by FIT
  intersection() {
    difference() { e7_loft(WALL - 0.2); e7_loft(2 * WALL + FIT); }
    translate([x - SLEEVE, -HW, Z_DECK + 1]) cube([SLEEVE + 0.05, 2 * HW, Z_CAB]);
  }
  intersection() {
    difference() { e7_loft(WALL + FIT); e7_loft(2 * WALL + FIT); }
    translate([x, -HW, Z_DECK + 1]) cube([SLEEVE, 2 * HW, Z_CAB]);
  }
}

module e7_body_section(k) {
  x0 = sec_x0(k); x1 = x0 + SEC_L;
  union() {
    intersection() {
      union() { e7_shell_solid(); e7_bosses(); }
      translate([k == 1 ? x0 - 20 : x0, -HW - 10, -1]) cube([x1 - x0 + (k == 1 || k == NSEC ? 20 : 0), 2 * HW + 20, Z_CAB + 20]);
    }
    if (k < NSEC) e7_sleeve(x1);
  }
}

// ---- frame plate in pieces with half laps ----
module e7_frame_plate() {
  difference() {
    translate([FRAME_X0, -FRAME_HW, Z_FRAME_BOT]) cube([FRAME_X1 - FRAME_X0, 2 * FRAME_HW, FRAME_T]);
    // body screw holes, countersunk from below
    for (x = BOSS_X, s = [-1, 1]) translate([x, s * (HW - WALL - BOSS[0] / 2 + 0.4), Z_FRAME_BOT - EPS]) {
      cylinder(d = BODY_SCREW[1], h = FRAME_T + 1, $fn = 16);
      cylinder(d1 = BODY_SCREW[2], d2 = BODY_SCREW[1], h = (BODY_SCREW[2] - BODY_SCREW[1]) / 2, $fn = 16);
    }
    // truck pivots
    for (tx = [TRK_X, -TRK_X]) translate([tx, 0, Z_FRAME_BOT - 1]) cylinder(d = PIVOT[0], h = FRAME_T + 2, $fn = 20);
    // pilot screws (front) and rear pocket screws
    for (x = [FRAME_X1 - p(14), FRAME_X0 + p(10)], s = [-1, 1])
      translate([x, s * p(18), Z_FRAME_BOT - 1]) cylinder(d = BODY_SCREW[1], h = FRAME_T + 2, $fn = 16);
    // wiring hole between the trucks
    translate([0, 0, Z_FRAME_BOT - 1]) cylinder(d = p(20), h = FRAME_T + 2, $fn = 24);
  }
}
// piece j = 1..NFRAME, rear to front; laps: the piece on the rear side keeps the bottom half
module e7_frame_piece(j) {
  xs = concat([FRAME_X0 - 1], FRAME_SPLITS, [FRAME_X1 + 1]);
  a = xs[j - 1]; b = xs[j];
  intersection() {
    e7_frame_plate();
    union() {
      translate([a + (j > 1 ? LAP / 2 : 0), -FRAME_HW - 1, Z_FRAME_BOT - 1]) cube([b - a - (j > 1 ? LAP / 2 : 0) - (j < NFRAME ? LAP / 2 : 0), 2 * FRAME_HW + 2, FRAME_T + 2]);
      if (j > 1)       translate([a - LAP / 2, -FRAME_HW - 1, Z_FRAME_BOT + FRAME_T / 2]) cube([LAP, 2 * FRAME_HW + 2, FRAME_T]);   // top half reaching back
      if (j < NFRAME)  translate([b - LAP / 2 - EPS, -FRAME_HW - 1, Z_FRAME_BOT - 1]) cube([LAP, 2 * FRAME_HW + 2, FRAME_T / 2 + 1]);  // bottom half reaching forward
    }
  }
}

// ---- pilot (front) and rear coupler pocket ----
CPL_W = SC == "G" ? 14 : SC == "O" ? 8 : 5;    // coupler pocket opening, mm (Kadee-style, TDQ)
CPL_H = SC == "G" ? 8 : SC == "O" ? 5 : 3.2;
// ---- passenger pilot (v3, from the Southern Ry E7 diagram) ----
// built in nose-local inches (u across, v back from the nose face, w up) and placed with e7_nose_place()
// one plan slice: front v = -f on the centre line, rounded back to setback k at half width hw, open to v = vb
module _e7p_slice(w, f, hw, k, vb) {
  n = 16;
  translate([0, 0, w]) linear_extrude(0.01)
    polygon(concat([for (i = [0:n]) let (u = -hw + 2 * hw * i / n, t = min(abs(u) / hw, 0.9999))
                      [u, -f + k * (1 - pow(1 - pow(t, E7N_PLAN_N), 1 / E7N_PLAN_N))]],
                   [[hw, vb], [-hw, vb]]));
}
module _e7p_loft(L, vb) {
  for (i = [0:len(L) - 2]) hull() {
    _e7p_slice(L[i][0], L[i][1], L[i][2], L[i][3], vb);
    _e7p_slice(L[i + 1][0], L[i + 1][1], L[i + 1][2], L[i + 1][3], vb);
  }
}
// nose plan outline at the bumper (the face is vertical below E7N_BASE)
module _e7p_nose_plan2d() {
  nu = 30;
  side = [for (i = [0:nu]) let (t = 1 - cos(i / nu * 90))
            [E7N_HW * pow(1 - pow(1 - t, E7N_PLAN_N), 1 / E7N_PLAN_N), E7N_PLAN_L * t]];
  half = concat(side, [[E7N_HW, E7N_LEN]]);
  polygon(concat(half, [for (i = [len(half) - 1:-1:1]) [-half[i][0], half[i][1]]]));
}
module e7_pilot_local() {
  A = ANTICLIMBER; hwi = BODY_W_IN / 2;
  intersection() {
    union() {
      _e7p_loft(PILOT_LEVELS, PILOT_BACK);
      _e7p_loft(PILOT_PLOW, PILOT_BACK);
      translate([0, 0, A[0] - 1.5]) linear_extrude(A[1] - A[0] + 1.5) offset(r = A[2]) _e7p_nose_plan2d();   // anticlimber (overlaps the pilot top)
    }
    union() {
      // below the skirt: all of it
      translate([-hwi - 10, -50, -10]) cube([2 * hwi + 20, 200, SKIRT_IN + 10]);
      // above the skirt: only inside the anticlimber outline, flush with the body sides, back to A[3]
      intersection() {
        translate([0, 0, SKIRT_IN - 1]) linear_extrude(A[1] - SKIRT_IN + 2) offset(r = A[2]) _e7p_nose_plan2d();
        translate([-hwi, -A[2] - 1, SKIRT_IN - 2]) cube([2 * hwi, A[3] + A[2] + 1, A[1] - SKIRT_IN + 4]);
      }
    }
  }
}
module e7_pilot() {
  pw = 2 * p(52);
  difference() {
    union() {
      e7_nose_place() e7_pilot_local();
      // flange under the frame plate (screws come down through the frame) and a riser down to the pilot,
      // kept inside the nose above the skirt
      intersection() {
        union() {
          translate([FRAME_X1 - p(26), -pw / 2, Z_FRAME_BOT - FRAME_T]) cube([XF - p(6) - FRAME_X1 + p(26), pw, FRAME_T]);
          translate([XF - p(PILOT_BACK), -pw / 2, p(30)]) cube([p(PILOT_BACK - 6), pw, Z_FRAME_BOT - p(30)]);
        }
        union() {
          e7_nose_solid(WALL + FIT);
          translate([XF - p(200), -500, -1]) cube([p(300), 1000, Z_SKIRT + 1]);
        }
      }
    }
    // slot for the nose wall (the pilot slides up onto it), with a fit gap each side
    difference() { e7_nose_solid(-FIT); e7_nose_solid(WALL + FIT); }
    // nothing above the anticlimber
    translate([XF - p(200), -500, p(ANTICLIMBER[1])]) cube([p(300), 1000, 1000]);
    // coupler pocket
    translate([XF - p(20), -CPL_W / 2, CPL_Z - CPL_H / 2]) cube([p(60), CPL_W, CPL_H]);
    // screws into the frame
    for (s = [-1, 1]) translate([FRAME_X1 - p(14), s * p(18), -1]) cylinder(d = BODY_SCREW[0], h = 100, $fn = 16);
  }
}
module e7_pilot_rear() {
  pw = 2 * p(40);
  difference() {
    translate([XR - p(6), -pw / 2, CPL_Z - CPL_H / 2 - WALL]) cube([FRAME_X0 + p(22) - XR + p(6), pw, Z_FRAME_BOT - CPL_Z + CPL_H / 2 + WALL]);
    translate([XR - p(10), -CPL_W / 2, CPL_Z - CPL_H / 2]) cube([p(40), CPL_W, CPL_H]);
    for (s = [-1, 1]) translate([FRAME_X0 + p(10), s * p(18), -1]) cylinder(d = BODY_SCREW[0], h = 100, $fn = 16);
  }
}

// ---- A1A truck (printed frame; wheels bought - TDQ) ----
module e7_truck_frame() {
  r = WHEEL_D / 2;
  bol_bot = WHEEL_D + 0.6; bol_top = Z_FRAME_BOT - 0.3;
  sf_len = 2 * AX_SP + p(40); sf_h = p(26);
  difference() {
    union() {
      // bolster across the top
      translate([-p(30), -(T_YI + T_SF), bol_bot]) cube([p(60), 2 * (T_YI + T_SF), bol_top - bol_bot]);
      for (s = [-1, 1]) {
        // sideframe, with journal boxes at each axle
        translate([-sf_len / 2, s > 0 ? T_YI : -T_YI - T_SF, r - sf_h / 2]) cube([sf_len, T_SF, sf_h]);
        translate([-p(30), s > 0 ? T_YI : -T_YI - T_SF, r]) cube([p(60), T_SF, bol_bot - r + 0.5]);
        for (ax = [-AX_SP, 0, AX_SP])
          translate([ax - p(7), s > 0 ? T_YI + T_SF - EPS : -T_YI - T_SF - p(3), r - p(8)]) cube([p(14), p(3), p(16)]);
      }
    }
    for (ax = [-AX_SP, 0, AX_SP]) translate([ax, 0, r]) rotate([90, 0, 0]) cylinder(d = T_AXLE, h = 2 * (T_YI + T_SF + p(5)), center = true, $fn = 16);
    // lighten the sideframes between the axles
    for (s = [-1, 1], ax = [-AX_SP / 2, AX_SP / 2])
      translate([ax, s * (T_YI + T_SF / 2), r]) cube([AX_SP - p(22), T_SF + 2, sf_h * 0.45], center = true);
    // pivot screw (pilot hole) through the bolster
    cylinder(d = PIVOT[0] * 0.8, h = 200, $fn = 16);
  }
}
module e7_wheels() {    // preview only - bought wheelsets
  for (ax = [-AX_SP, 0, AX_SP]) translate([ax, 0, WHEEL_D / 2]) rotate([90, 0, 0]) {
    cylinder(d = T_AXLE, h = 2 * T_YI, center = true, $fn = 12);
    for (s = [-1, 1]) translate([0, 0, s * (GAUGE / 2 + p(2))]) cylinder(d = WHEEL_D, h = p(5), center = true, $fn = 32);
  }
}
