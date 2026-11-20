// =====================================================================
//  lj_all.scad - Little Joe: includes, print plates, preview, Blender
//  pieces and the report. Set SCALE_SEL / LOCO_SEL / PAINT_SEL / part
//  before including (the Main file and the part files do).
// =====================================================================
include <lj_params.scad>
include <lj_body.scad>
include <lj_frame.scad>
include <lj_truck.scad>

// ---------------- parts list per scale (MR Print Files reads print_parts.json - keep it the same) ----------------
function lj_parts() = concat(
    [for (k = [1:NSEC]) [str("body_", k), 1]],
    [for (k = [1:NSEC]) [str("roof_", k), 1]],
    [for (i = [1:NFRAME]) [str("frame_", i), 1]],
    (FC_NOSE ? [["nose", 2]] : []), [["pilot", 2], ["truck_drive", 2], ["truck_guide", 2]],
    SC == "HO" ? [] : [["wheels_drive", 2], ["wheels_guide", 1], ["bearing_coupon", 1]]);

function num_after(s, pre) = let(n = len(pre)) len(s) > n && [for (i = [0:n - 1]) s[i]] == [for (i = [0:n - 1]) pre[i]]
    ? let(d = ord(s[n]) - 48) d : 0;

// ---------------- print plates (each sits on the bed at z = 0) ----------------
module lj_plate(name) {
    kb = num_after(name, "body_"); kr = num_after(name, "roof_"); kf = num_after(name, "frame_");
    if (kb > 0)       // sides and ends, upright as on the loco
        translate([-(sec_x0(kb) + SEC_L / 2), 0, -Z_DECK]) lj_wall_section(kb);
    else if (kr > 0)  // roof, upright
        translate([-(sec_x0(kr) + SEC_L / 2), 0, -Z_EAVE]) lj_roof_section(kr);
    else if (kf > 0)  // frame piece, upside down (top on the bed)
        rotate([180, 0, 0]) translate([-(max(frame_cut_x(kf - 1), -HL) + min(frame_cut_x(kf), HL)) / 2, 0, -Z_DECK]) lj_frame_piece(kf);
    else if (name == "nose") translate([-(HL - NOSE_L), 0, -Z_DECK]) lj_fc_nose();      // FreeCAD print, upright, joint face at x = 0
    else if (name == "pilot") rotate([180, 0, 0]) translate([-HL, 0, -Z_FRAME_BOT]) lj_pilot(1);
    else if (name == "truck_drive" || name == "truck_guide") truck_plate(name == "truck_drive" ? "drive" : "guide");
    else if (name == "wheels_drive") wheel_grid(DRV_D, 8, BLIND_MIDDLE ? 4 : 0);      // one plate per driving truck: 8 wheels, 4 of them blind
    else if (name == "wheels_guide") wheel_grid(GDE_D, 8, 0);
    else if (name == "bearing_coupon") rg_bearing_coupon();
    else assert(false, str("unknown part ", name, " - parts: ", lj_parts()));
}
module truck_plate(kind) {
    t = tk(kind); R = t[2] / 2; hgt = (R + p(13)) - (R - p(9)) + max(0.8, p(3)) + 3;
    for (i = [0, 1]) translate([0, i * (hgt + 2), 0])
        translate([0, R + p(13), -T_YI]) rotate([90, 0, 0]) lj_sideframe(kind, 1);          // inner face down
    translate([0, 2 * (hgt + 2) + T_YI + 2, -h_z0(kind)]) lj_hframe(kind);
}
module wheel_grid(d, n, nblind) {
    pitch = d + 6; cols = ceil(sqrt(n));
    for (i = [0:n - 1]) translate([(i % cols) * pitch, floor(i / cols) * pitch, 0]) lj_wheel(d, i < nblind);
}

// ---------------- pantograph (shown only - TDQ: bought or printed) ----------------
module lj_pantograph(raise = 0.25) {
    t = max(0.6, p(2)); base = [p(60), p(48)]; lo = p(60); hi = p(62);
    a1 = 12 + raise * 40;                                 // lower arm angle up from the roof
    h1 = lo * sin(a1); x1 = lo * cos(a1);
    h2 = sqrt(max(hi * hi - x1 * x1, 1));
    top = p(10) + h1 + h2 * (0.25 + raise * 0.75);
    for (sy = [-1, 1]) translate([0, sy * base[1] / 2, p(10)]) {
        for (sx = [-1, 1]) hull() { translate([sx * base[0] / 2, 0, 0]) sphere(d = t, $fn = 8); translate([sx * (base[0] / 2 - x1), 0, h1]) sphere(d = t, $fn = 8); }
        for (sx = [-1, 1]) hull() { translate([sx * (base[0] / 2 - x1), 0, h1]) sphere(d = t, $fn = 8); translate([0, 0, top - p(10)]) sphere(d = t, $fn = 8); }
    }
    translate([-base[0] / 2, -base[1] / 2, p(8)]) cube([base[0], t, t]);
    translate([-base[0] / 2, base[1] / 2 - t, p(8)]) cube([base[0], t, t]);
    translate([0, 0, top]) rotate([90, 0, 0]) cylinder(d = t * 1.5, h = p(70), center = true, $fn = 12);      // pan head
    for (sx = [-1, 1]) translate([sx * p(5), 0, top]) rotate([90, 0, 0]) cylinder(d = t, h = p(84), center = true, $fn = 8);
}
module lj_pantos() for (sx = [-1, 1]) translate([sx * p(PAN_X_IN), 0, Z_MID_ROOF]) lj_pantograph(is_undef(PAN_RAISE_SEL) ? 0.25 : PAN_RAISE_SEL);

// ---------------- preview: the whole loco, painted ----------------
module lj_body_all(z0, z1) for (k = [1:NSEC]) intersection() { lj_wall_section(k); zband(z0, z1); }
// FREIGHT: black above the paint line AND over the nose bonnet; OLYMPIAN: split at the paint line
module lj_paint_high_zone() { zband(Z_PAINT, 1000); if (PAINT == "FREIGHT") lj_bonnet_zone(); }
module lj_body_high() for (k = [1:NSEC]) intersection() { lj_wall_section(k); lj_paint_high_zone(); }
module lj_body_low()  for (k = [1:NSEC]) difference() { lj_wall_section(k); lj_paint_high_zone(); }
module lj_preview() {
    color(C_LOW)  lj_body_low();
    if (FC_NOSE) color(C_LOW) lj_fc_noses();
    color(C_HIGH) lj_body_high();
    color(C_ROOF) for (k = [1:NSEC]) lj_roof_section(k);
    color(C_FRAME) { lj_frame_full(); for (sx = [-1, 1]) { lj_pilot(sx); lj_coupler(sx); } }
    color(C_TRUCK) lj_trucks_placed("frames");
    color(RG_PAINT_WHEEL) lj_trucks_placed("wheels");
    color(RG_PAINT_AXLE) lj_trucks_placed("axles");
    color(C_GLASS, 0.5) lj_glass();
    color(C_LENS) lj_headlights(true);
    color(C_LETTER) lj_letters();
    color(C_RAIL) { lj_grabs(); lj_railings(); }
    color("#3E4042") lj_pantos();
    color("#8C8C8C") for (s = [-1, 1]) translate([-L_OA / 2 - 20, s * GAUGE / 2 - 1, -3]) cube([L_OA + 40, 2, 3]);
}

// ---------------- pieces for Blender (Blender / render_loco.py) ----------------
module lj_render(g) {
    if (g == "info") echo(str("LOCORENDER|", L_OA, "|", BW, "|", p(PAN_TOP_IN) + p(20), "|0|", GAUGE, "|",
                              C_LOW, "|", C_HIGH, "|", C_BLACK, "|", ROAD_NO, "|", PAINT));
    else if (g == "low")       lj_body_low();
    else if (g == "nose")      { if (FC_NOSE) lj_fc_noses(); }
    else if (g == "high")      lj_body_high();
    else if (g == "roof")      for (k = [1:NSEC]) lj_roof_section(k);
    else if (g == "frame")     { lj_frame_full(); for (sx = [-1, 1]) { lj_pilot(sx); lj_coupler(sx); } }
    else if (g == "trucks")    lj_trucks_placed("frames");
    else if (g == "wheels")    lj_trucks_placed("wheels");
    else if (g == "axles")     lj_trucks_placed("axles");
    else if (g == "glass")     lj_glass();
    else if (g == "lens")      lj_headlights(true);
    else if (g == "letter")    lj_letters();
    else if (g == "handrails") { lj_grabs(); lj_railings(); }
    else if (g == "panto")     lj_pantos();
    // other groups (lights, rails, rivets, inside, walk, wire) are empty on the Little Joe
}

// ---------------- report ----------------
function n_body_screws() = len([for (q = body_screw_pts()) if (!in_door(q[0])) 1]);
module lj_report() {
    echo(str("LITTLE JOE ", SC, " (1:", RATIO, "), ", ROAD_NO, " class ", CLASS, ", paint ", PAINT, " - ", LOCO_ROW[3]));
    echo(str("  over couplers ", round(L_OA), " mm; body ", round(BL), " x ", round(BW), " mm, roof ", round(Z_ROOF), " mm above rail; deck ", round(Z_DECK * 10) / 10, " mm"));
    echo(str("  body and roof each in ", NSEC, " prints of ", round(SEC_L), " mm; frame in ", NFRAME, " prints (joints under the middle of the body prints)"));
    echo(str("  drivers ", round(DRV_D * 10) / 10, " mm, guide wheels ", round(GDE_D * 10) / 10, " mm; truck centres ", round(2 * DRV_X), " mm (driving) and ", round(2 * GDE_X), " mm (guide)"));
    echo(str("  PARTS: ", lj_parts()));
    echo(str("  BUY: ", n_body_screws(), " ", SCREW_BODY_NAME, " x ", SC == "HO" ? 6 : SC == "O" ? 8 : 10, " mm self-tapping screws (frame up into the body bosses); ",
             2 * NSEC, " ", TRUCK_SCREW[3], " screws for the frame laps; 4 ", TRUCK_SCREW[3], " for the pilots and 2 for the couplers; ",
             2 * (2 * 3) + 2 * (2 * 2), " ", TRUCK_SCREW[3], " screws for the trucks; 4 ", PIVOT[2], " pivot screws ~", round(Z_DECK - h_z0("guide") + 4), " mm and nuts; ",
             SC == "HO" ? str("12 bought HO wheelsets (8 x ", HO_DRIVER_IN, " in, 4 x ", HO_GUIDE_IN, " in, ", HO_AXLE_LEN, " mm pinpoint axles); ")
                        : str("12 axles: ", rg_axle_d, " mm brass rod cut to ", round(rg_axle_len * 10) / 10, " mm; 24 ", rg_bearing, "ZZ bearings; "),
             "2 couplers (Kadee, TDQ); 2 pantographs (TDQ); ", GRAB_D, " mm brass wire for grab irons and the end railings; weight for the frame pockets"));
}
