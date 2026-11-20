// ==========================================================================
//  e7_all.scad - include this one file. Preview, print plates and the report.
// ==========================================================================
include <e7_params.scad>
include <e7_body.scad>

// whole painted loco
module e7_preview() {
  // carbody in its paint bands
  for (i = [0:len(PAINT_BANDS) - 1]) {
    z0 = i == 0 ? -1 : p(PAINT_BANDS[i - 1][0]);
    z1 = i == len(PAINT_BANDS) - 1 ? 1000 : p(PAINT_BANDS[i][0]);
    color(PAINT_BANDS[i][1]) render(convexity = 8) e7_shell_solid([z0, z1]);
  }
  color(C_GLASS) e7_glass();
  color(C_LENS) let (d = nose_d_at_z(HEADLIGHT[0]))
    translate([XF - p(d) + p(HEADLIGHT[2]) + p(1.5), 0, p(HEADLIGHT[0])]) rotate([0, 90, 0]) cylinder(d = p(HEADLIGHT[1]) - 0.8, h = 0.5, $fn = 32);
  color(C_FRAME) { for (j = [1:NFRAME]) e7_frame_piece(j); e7_pilot(); e7_pilot_rear(); }
  for (tx = [TRK_X, -TRK_X]) translate([tx, 0, 0]) { color(C_TRUCK) e7_truck_frame(); color(C_WHEEL) e7_wheels(); }
}
// thin glass panes sitting in the window pockets (preview only)
module e7_glass() {
  intersection() { e7_loft(DET * 0.6); union() { e7_windshield_cut(); e7_side_cuts_windows_only(); } }
}
module e7_side_cuts_windows_only() {
  for (s = [-1, 1], w = CAB_WIN)
    translate([XF - p(w[1]), s * HW - (s > 0 ? DET : 3 - DET), p(w[2])]) cube([p(w[1] - w[0]), 3, p(w[3] - w[2])]);
}

// one print, laid out for the printer
module e7_plate(part) {
  sec = [for (k = [1:NSEC]) str("body_", k)];
  frm = [for (j = [1:NFRAME]) str("frame_", j)];
  if (is_num(search([part], sec)[0])) {
    k = search([part], sec)[0] + 1;
    // stand the section on its open bottom (skirt edge on the bed)
    translate([-sec_x0(k) - SEC_L / 2, 0, -Z_SKIRT]) e7_body_section(k);
  } else if (is_num(search([part], frm)[0])) {
    j = search([part], frm)[0] + 1;
    xs = concat([FRAME_X0], FRAME_SPLITS, [FRAME_X1]);
    translate([-(xs[j - 1] + xs[j]) / 2, 0, -Z_FRAME_BOT]) e7_frame_piece(j);
  } else if (part == "pilot") {
    translate([-XF, 0, 0]) rotate([0, 0, 0]) translate([0, 0, -p(5)]) e7_pilot();
  } else if (part == "pilot_rear") {
    translate([-XR, 0, 0]) translate([0, 0, -(CPL_Z - CPL_H / 2 - WALL)]) e7_pilot_rear();
  } else if (part == "truck") {
    // upside down, bolster on the bed
    translate([0, 0, Z_FRAME_BOT - 0.3]) rotate([180, 0, 0]) e7_truck_frame();
  } else {
    assert(false, str("unknown part '", part, "'"));
  }
}

module e7_report() {
  echo(str("MILW E7A ", ROAD_NO, " class ", CLASS, " - ", SC, " scale 1:", RATIO, ", paint ", PAINT));
  echo(str("  carbody ", round(BL), " mm long, ", round(2 * HW), " mm wide, roof ", round(Z_ROOF), " mm, cab ", round(Z_CAB), " mm above rail"));
  echo(str("  ", NSEC, " body sections of ", round(SEC_L), " mm; ", NFRAME, " frame pieces; trucks at +/- ", round(TRK_X), " mm"));
  echo(str("  body screws ", SCREW_BODY_NAME, " x ", 2 * len(BOSS_X), "; truck pivots ", PIVOT[1], "; wheels ", round(WHEEL_D * 10) / 10, " mm (bought)"));
}
