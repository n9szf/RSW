// ==========================================================================
//  e7_body.scad - carbody shell, frame, pilots and trucks for the MILW E7A.
//  x along the loco (front / A cab at +x), y across, z up from the rail top.
// ==========================================================================

EPS = 0.01;

// ---- carbody cross-section and loft ----
module e7_profile2d(hw, zb, zt, r) {
  r2 = max(0.3, min(r, hw - 0.3, zt - zb - 0.3));
  hull() {
    translate([-hw, zb]) square([2 * hw, max(0.3, zt - zb - r2)]);
    translate([-hw + r2, zt - r2]) circle(r = r2, $fn = 32);
    translate([ hw - r2, zt - r2]) circle(r = r2, $fn = 32);
  }
}
// one thin slab at x: 2D u -> y, v -> z
module e7_slab(x, hw, zb, zt, r) {
  translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(EPS) e7_profile2d(hw, zb, zt, r);
}

// stations in model mm: [x, half width, bottom, top, radius]
function e7_stations(off = 0) =
  let (
    nose = [for (i = [0:len(NOSE) - 1]) let (n = NOSE[i])
             [XF - p(n[0]) - (i == 0 ? 1.5 * off : 0), p(n[1]) - off, Z_SKIRT - (off > 0 ? 1 : 0), p(n[2]) - off, p(n[3]) - off]],
    rr = p(REAR_ROUND_IN),
    rear = [[XR + rr, HW - off, Z_SKIRT - (off > 0 ? 1 : 0), Z_ROOF - off, p(ROOF_R_IN) - off],
            [XR + (off > 0 ? off : 0), HW - rr * 0.6 - off, Z_SKIRT - (off > 0 ? 1 : 0), Z_ROOF - rr * 0.3 - off, p(ROOF_R_IN) - off]]
  ) concat(nose, rear);

// zc = [z from, z to]: clip the loft to a height band (used for the paint preview)
module e7_loft(off = 0, zc = [-1000, 1000]) {
  st = e7_stations(off);
  for (i = [0:len(st) - 2]) intersection() {
    hull() {
      e7_slab(st[i][0], st[i][1], st[i][2], st[i][3], st[i][4]);
      e7_slab(st[i + 1][0], st[i + 1][1], st[i + 1][2], st[i + 1][3], st[i + 1][4]);
    }
    if (zc != [-1000, 1000]) translate([-1000, -500, zc[0]]) cube([2000, 1000, zc[1] - zc[0]]);
  }
}

// ---- surface details cut into the shell (shallow, printable) ----
DET = max(0.4, WALL * 0.4);       // pocket depth
function nose_z(d) =              // centre-line top height at d inches back from the tip (linear between stations)
  let (i = max([for (k = [0:len(NOSE) - 2]) if (NOSE[k][0] <= d) k]))
  NOSE[i][2] + (NOSE[i + 1][2] - NOSE[i][2]) * (d - NOSE[i][0]) / (NOSE[i + 1][0] - NOSE[i][0]);

module e7_windshield_cut() {
  d0 = WS_D_IN[0]; d1 = WS_D_IN[1];
  z0 = nose_z(d0); z1 = nose_z(d1);
  run = p(d1 - d0); rise = p(z1 - z0);
  ang = atan2(rise, run);
  for (s = [-1, 1])
    translate([XF - p(d0), 0, p(z0)]) rotate([0, ang, 0])
      translate([-sqrt(run * run + rise * rise) + 0.4, s > 0 ? p(WS_Y_IN[0]) : -p(WS_Y_IN[1]), -DET])
        cube([sqrt(run * run + rise * rise) - 0.8, p(WS_Y_IN[1] - WS_Y_IN[0]), DET + 3]);
}

module e7_side_cuts() {
  for (s = [-1, 1]) {
    // cab window(s)
    for (w = CAB_WIN)
      translate([XF - p(w[1]), s * HW - (s > 0 ? DET : 3 - DET) , p(w[2])]) cube([p(w[1] - w[0]), 3, p(w[3] - w[2])]);
    // crew door outline (a groove)
    translate([XF - p(CAB_DOOR[1]), s * HW - (s > 0 ? DET * 0.6 : 3 - DET * 0.6), p(CAB_DOOR[2])])
      difference() {
        cube([p(CAB_DOOR[1] - CAB_DOOR[0]), 3, p(CAB_DOOR[3] - CAB_DOOR[2])]);
        translate([0.5, -1, 0.5]) cube([p(CAB_DOOR[1] - CAB_DOOR[0]) - 1, 5, p(CAB_DOOR[3] - CAB_DOOR[2]) - 1]);
      }
    // portholes
    for (ph = PORTHOLES)
      translate([XF - p(ph[0]), s * HW, p(ph[1])]) rotate([90, 0, 0])
        cylinder(d = p(ph[2]), h = 2 * DET, center = true, $fn = 32);
    // louvre grilles
    gl = p(GRILLE_D_IN[1] - GRILLE_D_IN[0]) / GRILLE_N;
    for (g = [0:GRILLE_N - 1])
      translate([XF - p(GRILLE_D_IN[0]) - (g + 1) * gl + 0.6, s * HW - (s > 0 ? DET : 3 - DET), p(GRILLE_Z_IN[0])])
        difference() {
          cube([gl - 1.2, 3, p(GRILLE_Z_IN[1] - GRILLE_Z_IN[0])]);
          for (k = [1:5]) translate([-1, s > 0 ? -1 : 3 - DET * 0.5, k * p(GRILLE_Z_IN[1] - GRILLE_Z_IN[0]) / 6 - 0.2])
            cube([gl + 2, 1 + DET * 0.5, 0.4]);
        }
  }
}

module e7_nose_front_cuts() {
  // nose door outline groove
  w = p(NOSE_DOOR[0]); h = p(NOSE_DOOR[1]); z = p(NOSE_DOOR[2]);
  translate([XF - p(4), -w / 2, z]) difference() {
    cube([p(12), w, h]);
    translate([-1, 0.5, 0.5]) cube([p(14), w - 1, h - 1]);
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
function nose_d_at_z(z) = let (c = [for (n = NOSE) if (n[2] >= z) n[0]]) len(c) > 0 ? c[0] : 0;

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
module e7_pilot() {
  pw = 2 * p(52);
  difference() {
    translate([0, pw / 2, 0]) rotate([90, 0, 0]) linear_extrude(pw)
      polygon([
        [FRAME_X1 - p(26), Z_FRAME_BOT], [XF - p(4), Z_FRAME_BOT], [XF + p(2), Z_SKIRT],
        [XF + p(22), p(10)], [XF + p(18), p(5)], [XF - p(6), p(5)],
        [XF - p(6), Z_FRAME_BOT - FRAME_T], [FRAME_X1 - p(26), Z_FRAME_BOT - FRAME_T]]);
    // coupler pocket
    translate([XF - p(20), -CPL_W / 2, CPL_Z - CPL_H / 2]) cube([p(60), CPL_W, CPL_H]);
    // screws into the frame
    for (s = [-1, 1]) translate([FRAME_X1 - p(14), s * p(18), -1]) cylinder(d = BODY_SCREW[0], h = 100, $fn = 16);
    // hollow behind the plow
    translate([XF - p(6) + WALL, -pw / 2 + WALL, p(5) + WALL]) cube([p(8), pw - 2 * WALL, Z_FRAME_BOT - FRAME_T - p(5) - 2 * WALL]);
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
