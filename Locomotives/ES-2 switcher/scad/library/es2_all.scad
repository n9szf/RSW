// =====================================================================
//  es2_all.scad  -  pulls the ES-2 library together: the painted
//  preview, the eight print plates and the report.
// =====================================================================
include <es2_params.scad>
include <es2_bits.scad>
include <es2_body.scad>
include <es2_frame.scad>
include <es2_truck.scad>
include <es2_details.scad>
include <es2_panto.scad>
include <es2_extras.scad>

// ---------------- paint (preview only) ----------------
// ORANGE_BLACK (Tom's HO E83): Milwaukee orange below PAINT_LINE, black above (hood tops, cab top, roof).
// ORANGE_MAROON (E82 colour photo): maroon sides, orange hood tops and cab window band.
C_LOW  = PAINT == "ORANGE_BLACK" ? C_ORANGE : PAINT == "ORANGE_MAROON" ? C_MAROON : PAINT == "ALL_BLACK" ? C_BLACK : C_RAW;
C_HIGH = PAINT == "ORANGE_BLACK" ? C_BLACK  : PAINT == "ORANGE_MAROON" ? C_ORANGE : PAINT == "ALL_BLACK" ? C_BLACK : C_RAW;
assert(len([for (q = ["ALL_BLACK", "ORANGE_BLACK", "ORANGE_MAROON", "NO_PAINT"]) if (q == PAINT) 1]) == 1,
       str("PAINT_SEL must be ALL_BLACK, ORANGE_BLACK, ORANGE_MAROON or NO_PAINT - got ", PAINT));

// ---------------- what the preview shows (Tom 10/20: toggle each part) ----------------
S_FRAME = (is_undef(SHOW_FRAME) ? true : SHOW_FRAME);  S_WALK = (is_undef(SHOW_WALKWAYS) ? true : SHOW_WALKWAYS); S_UNDER = (is_undef(SHOW_UNDERSIDE) ? true : SHOW_UNDERSIDE);
S_CAB = (is_undef(SHOW_CAB) ? true : SHOW_CAB);      S_ROOF = (is_undef(SHOW_ROOF) ? true : SHOW_ROOF);     S_HOOD1 = (is_undef(SHOW_HOOD_1) ? true : SHOW_HOOD_1);  S_HOOD2 = (is_undef(SHOW_HOOD_2) ? true : SHOW_HOOD_2);
S_RAILS = (is_undef(SHOW_RAILINGS) ? true : SHOW_RAILINGS); S_PANTO = (is_undef(SHOW_PANTOGRAPH) ? true : SHOW_PANTOGRAPH); S_POLE = (is_undef(SHOW_TROLLEY_POLE) ? true : SHOW_TROLLEY_POLE);
S_TRUCKS = (is_undef(SHOW_TRUCKS) ? true : SHOW_TRUCKS); S_WHEELS = (is_undef(SHOW_WHEELS) ? true : SHOW_WHEELS); S_CPL = (is_undef(SHOW_COUPLERS) ? true : SHOW_COUPLERS);
S_GLASS = (is_undef(SHOW_GLASS) ? true : SHOW_GLASS);
S_HL = (is_undef(SHOW_HEADLIGHTS) ? true : SHOW_HEADLIGHTS); S_BELL = (is_undef(SHOW_BELL) ? true : SHOW_BELL);
S_LADDER = (is_undef(SHOW_LADDERS) ? true : SHOW_LADDERS);  S_STEPS = (is_undef(SHOW_STEPS) ? true : SHOW_STEPS);  S_MAST = (is_undef(SHOW_POLE_MAST) ? true : SHOW_POLE_MAST);  S_TRACK = (is_undef(SHOW_TRACK) ? true : SHOW_TRACK);
module below_line(z) translate([-300, -300, -1]) cube([600, 600, z + 1]);
module hood_low_zone() {
    if (PAINT != "ORANGE_MAROON") below_line(p(PAINT_LINE));
    else union() { translate([0, 0, -p(5)]) hood_volume(-1); below_line(p(45)); }
}
cab_line = PAINT == "ORANGE_MAROON" ? p(49) : p(PAINT_LINE);
module paint_hood(n) {
    color(C_HIGH) render(convexity = 6) difference() { es2_hood(n, false, false, true); hood_low_zone(); }
    color(C_LOW)  render(convexity = 6) intersection() { es2_hood(n, false, false, true); hood_low_zone(); }
    color(C_RIVET) hood_rivets(n);
    if (S_RAILS) color(C_RAIL) es2_rail_posts_placed();
    if (n == 2 && S_MAST) color(C_BLACK) es2_pole_mast_placed();
    if (S_LADDER) color(C_LOW) es2_ladder();
    if (DOOR_OPEN > 0) color(C_INSIDE) es2_hood_inside(n);
}
module paint_cab() {
    color(C_LOW)  render(convexity = 6) intersection() { es2_cab(false); below_line(cab_line); }
    color(C_HIGH) render(convexity = 6) difference() { es2_cab(false); below_line(cab_line); }
    color(C_RIVET) cab_rivets();
}
// the white wire: hood railings and cab grab irons (loco position)
module es2_handrails() {
    translate([cab_hx, 0, deck_z]) hood_rail_wire();
    translate([-cab_hx, 0, deck_z]) mirror([1, 0, 0]) hood_rail_wire();
    translate([0, 0, deck_z]) cab_grab_wire();
}
module hood_place(n) if (n == 2) translate([cab_hx, 0, deck_z]) children(); else translate([-cab_hx, 0, deck_z]) mirror([1, 0, 0]) children();
module es2_lettering() {
    if (SHOW_LETTERING && !NOPAINT) color("#F2E6C0") {
        for (s = [-1, 1]) if (s > 0 ? S_HOOD2 : S_HOOD1) translate([s * (cab_hx + hood_l + 0.05), 0, deck_z + p(32)])
            rotate([90, 0, s > 0 ? 90 : -90]) linear_extrude(0.3) text(ROAD_NO, size = p(9), halign = "center", font = "Liberation Serif:style=Bold");
        if (S_CAB) for (s = [-1, 1]) translate([0, s * (cab_hw + 0.05), deck_z + p(40)])
            rotate([90, 0, s > 0 ? 180 : 0]) linear_extrude(0.3) text("ES-2", size = p(5), halign = "center", font = "Liberation Serif:style=Bold");
        if (S_ROOF) for (s = [-1, 1]) translate([0, s * (roof_w / 2 - p(4) + 0.05), deck_z + eave_z + roof_z(roof_w / 2 - p(4)) + p(4.5)])
            rotate([90, 0, s > 0 ? 180 : 0]) linear_extrude(0.3) text(ROAD_NO, size = p(6), halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
    }
}

module es2_preview(rails = true) {
    if (S_FRAME) {
        color(C_BLACK) es2_frame_full(false);
        color(RG_PAINT_AXLE) es2_join_rods();
        color(C_STEEL) es2_pivot_hardware();
        color(C_RIVET) es2_frame_rivets();
    }
    if (S_STEPS) color(C_BLACK) es2_steps_placed();       // separate prints, pinned on
    if (S_WALK)  color(C_WALK) for (s = [-1, 1]) es2_walkway(s);
    if (S_UNDER) color(C_BLACK) es2_underside();
    if (S_CAB) {
        translate([0, 0, deck_z]) paint_cab();
        if (S_RAILS) color(C_RAIL) translate([0, 0, deck_z]) cab_grab_wire();
        if (S_GLASS) color(C_GLASS) for (w = CAB_WIN)
            translate([p(w[4]) - p(w[1]) / 2, w[0] * (cab_hw - CAB_WALL - 0.5) - 0.25, deck_z + p(w[3])]) cube([p(w[1]), 0.5, p(w[2])]);
    }
    if (S_ROOF) color(C_BLACK) translate([0, 0, deck_z + eave_z]) es2_roof();
    for (n = [1, 2]) if (n == 1 ? S_HOOD1 : S_HOOD2) {
        s = n == 2 ? 1 : -1;
        hood_place(n) { paint_hood(n); if (S_RAILS) color(C_RAIL) hood_rail_wire(); }
        if (S_HL) translate([s * (cab_hx + hl_x), 0, deck_z + hl_pad_top]) mirror([s > 0 ? 0 : 1, 0, 0]) {
            color(HL_STYLE == "tower" ? C_HIGH : C_BLACK) es2_headlight_tower();
            color(C_LENS) es2_headlight_lens_placed();
        }
        if (n == 1 && S_BELL) color(C_BLACK) translate([-(cab_hx + bell_x), 0, deck_z + bell_pad_top]) es2_bell();
    }
    if (S_PANTO) color(C_PANTO) es2_pantograph_placed();
    if (S_POLE)  color(C_WIRE) { es2_trolley_pole(); es2_slider_placed(); }
    if (S_CPL) {
        for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) color(C_BLACK) es2_coupler();
        color(C_BLACK) es2_air_hose_placed();
        color(C_WIRE) es2_uncoupling_levers();
    }
    for (s = [-1, 1]) translate([s * truck_x, 0, 0]) {
        if (S_TRUCKS) { color(C_BLACK) es2_truck(false); color(C_WIRE) truck_sand_pipes(); }
        if (S_WHEELS) for (a = [-1, 1]) translate([a * tk_ax, 0, axle_z]) es2_wheelset(wheel_d, tk_yi);
    }
    es2_lettering();
    if (rails && S_TRACK) rg_track(p(OVER_COUPLERS) + 40);
}

// ---------------- one piece on its own (Tom 10/20: "select each part to view") ----------------
// show_piece in MILW_ES2_Main.scad. Each piece in its own position (most as it prints), painted.
PIECES = ["frame_A", "frame_B", "walkway_A", "walkway_B", "hood_1", "hood_2", "cab", "roof",
          "headlight", "lens", "bell", "ladder", "slider", "truck", "sideframe", "bolster", "wheel",
          "underside", "coupler", "coupler_gauge", "air_hose", "step", "pantograph", "pivot_bolt"];
module es2_piece(n) {
    if      (n == "frame_A")   color(C_BLACK) es2_frame_half(1);
    else if (n == "frame_B")   color(C_BLACK) es2_frame_half(-1);
    else if (n == "walkway_A") color("#2A2A2A") es2_walkway(1);
    else if (n == "walkway_B") color("#2A2A2A") es2_walkway(-1);
    else if (n == "hood_1" || n == "hood_2") let(h = n == "hood_1" ? 1 : 2) {
        paint_hood(h);
    }
    else if (n == "cab")       paint_cab();
    else if (n == "roof")      color(C_BLACK) es2_roof();
    else if (n == "headlight") { color(HL_STYLE == "tower" ? C_HIGH : C_BLACK) es2_headlight_tower(); color(C_LENS) es2_headlight_lens_placed(); }
    else if (n == "lens")      color(C_LENS) es2_headlight_lens();
    else if (n == "bell")      color(C_BLACK) es2_bell();
    else if (n == "ladder")    color(C_LOW) es2_ladder_print();
    else if (n == "slider")    color("#2E2E2E") es2_slider();
    else if (n == "truck")     { color(C_BLACK) es2_truck(false); for (a = [-1, 1]) translate([a * tk_ax, 0, axle_z]) es2_wheelset(wheel_d, tk_yi); }
    else if (n == "sideframe") color(C_BLACK) es2_sideframe();
    else if (n == "bolster")   color(C_BLACK) es2_bolster();
    else if (n == "wheel")     color(RG_PAINT_WHEEL) es2_wheel(wheel_d);
    else if (n == "underside") color(C_BLACK) es2_underside();
    else if (n == "coupler")   color(C_BLACK) es2_coupler();
    else if (n == "coupler_gauge") color("#888") es2_coupler_gauge();
    else if (n == "air_hose")  color(C_BLACK) es2_air_hose();
    else if (n == "step")      color(C_BLACK) es2_step();
    else if (n == "pantograph") color("#4A4A4A") es2_pantograph();
    else if (n == "pivot_bolt") color("#9A9A9A") es2_pivot_hardware();
    else assert(false, str("unknown piece: ", n));
}

// ---------------- the eight print plates (Tom 10/13) ----------------
// Each sits on z = 0, everything on it the way it should print, inside 256 x 256 mm.
PLATES = ["frame_A", "frame_B", "hood_1", "hood_2", "cab", "truck_A", "truck_B", "underside"];
module es2_plate(name) {
    if (name == "frame_A" || name == "frame_B") {   // frame half deck down, and its diamond-plate walkway tread up
        s = name == "frame_A" ? 1 : -1;
        translate([s * frame_hx / 2, -58, deck_z]) rotate([0, 180, 0]) es2_frame_half(s);
        translate([-s * (frame_hx + cab_hx) / 2, 58, -deck_z]) es2_walkway(s);
    }
    else if (name == "hood_1" || name == "hood_2") {
        n = name == "hood_1" ? 1 : 2;
        translate([-hood_l / 2, 12, 0]) es2_hood(n);
        translate([-hood_l / 2 + 25, -hood_w / 2 - 12, 0]) es2_headlight_tower();
        if (n == 1) translate([-hood_l / 2 + 55, -hood_w / 2 - 12, 0]) es2_bell();
        translate([-hood_l / 2 + 2, -hood_w / 2 - 12, 0]) es2_headlight_lens();
        translate([12, -hood_w / 2 - 14, 0]) rotate([0, 0, -90]) es2_ladder_print();
        // v9: the railing posts (8) and, on hood 2, the pole hook mast - separate small prints
        for (i = [0 : rail_post_count - 1]) translate([-68 + i * 10, -118, 0]) es2_rail_post_print(i >= 2 * len(rail_side_posts));
        if (n == 2) translate([45, -100, 0]) es2_pole_mast();
    }
    else if (name == "cab") {
        translate([-cab_hx - 4, 0, 0]) es2_cab();
        translate([roof_l / 2 + 4, 0, 0]) es2_roof();
        translate([0, 72, 0]) es2_slider();
    }
    else if (name == "truck_A" || name == "truck_B") es2_truck_plate();
    else if (name == "dovetail_coupon") es2_dovetail_coupon();
    else if (name == "underside") {
        es2_underside_print();
        for (i = [0, 1]) translate([-frame_hx - 8, 50 + i * 16, cpl_pad_bot]) rotate([180, 0, 0]) es2_coupler();
        translate([-6, -62, 0]) es2_coupler_gauge();
        for (i = [0, 1]) translate([58 + i * 16, 10, 0]) es2_air_hose_print();
        for (i = [0 : 3]) translate([-118, -50 + i * 30, 0]) es2_step_print();       // v8: the four steps, printed flat
    }
    else assert(false, str("unknown plate: ", name));
}
module es2_underside_print() translate([0, 0, -res_bot]) es2_underside();

module es2_report() {
    echo(str("ES-2 ", ES2_SCALE, " (1:", rg_scale, "), ", ROAD_NO, " (built ", LOCO_ROW[1], ", headlight ", HL_STYLE, HAS_TANK ? ", side tank" : "", "), paint ", PAINT, " - ", LOCO_ROW[4]));
    echo(str("  over couplers ", round(2 * cpl_face), " mm; frame ", round(2 * frame_hx), " x ", round(2 * frame_hw),
             " mm (two halves of ", round(frame_hx), " mm, joined by three 2 mm brass rods)"));
    echo(str("  hood ", round(hood_l), " x ", round(hood_w), " x ", round(p(HOOD_H_CAB)), " mm; cab ", round(2 * cab_hx), " x ",
             round(2 * cab_hw), " x ", round(eave_z), " mm; roof ", round(roof_l), " x ", round(roof_w), " mm"));
    echo(str("  deck ", round(deck_z * 10) / 10, " mm above the rail; coupler centre ", round(cz * 10) / 10,
             " mm; wheels ", round(wheel_d * 10) / 10, " mm; truck centres ", round(2 * truck_x), " mm"));
    echo(str("  BUY: 4 axles: ", rg_axle_d, " mm brass rod cut to ", round(tk_axle_len * 10) / 10, " mm; 8 ", rg_bearing, "ZZ bearings; 4 pins of 1 mm brass wire cut to ", round(tk_pin_len * 10) / 10, " mm (truck bolsters to sideframes); 2 shoulder bolts 4 mm x 16 mm, M3 thread (ISO 7379) and 2 M3 nylon lock nuts for the truck pivots; a pantograph; 8 disc magnets 6 x 3 mm; 2 M2 coupler screws; clear sheet; weight for the underside box; 3 x 2 mm brass rod 100 mm (joins the frame halves); 20 M2.5 x 8 mm self-tapping screws (hoods 8, cab 4 down through the deck, 4 cab to hood) - as the passenger cars; 1 mm brass wire about 2 m (railings, grab irons, ladder pins, step pins, sand pipes, uncoupling levers, hose pins); 2 mm brass rod about 15 cm for the trolley pole; white paint"));
}

// ---------------- pieces for the Blender render (Blender / render_loco.py) ----------------
// RENDER = "<group>" (set in the Main file) makes one coloured group in place on the loco; "info" echoes the colours.
RENDER_GROUPS = ["low", "high", "roof", "frame", "trucks", "wheels", "axles", "lights", "glass", "letter", "rails", "rivets", "handrails", "lens", "panto", "inside", "walk", "wire"];
module es2_render(g) {
    if (g == "info") echo(str("ES2RENDER|", 2 * cpl_face, "|", 2 * frame_hw, "|", deck_z + eave_z + ins_top, "|0|", rg_gauge, "|",
                              C_LOW, "|", C_HIGH, "|", C_BLACK, "|", ROAD_NO, "|", PAINT));
    else if (g == "low") {
        translate([0, 0, deck_z]) intersection() { es2_cab(false); below_line(cab_line); }
        for (n = [1, 2]) hood_place(n) { intersection() { es2_hood(n, false, false, true); hood_low_zone(); } es2_ladder(); }
    }
    else if (g == "high") {
        translate([0, 0, deck_z]) difference() { es2_cab(false); below_line(cab_line); }
        for (n = [1, 2]) hood_place(n) difference() { es2_hood(n, false, false, true); hood_low_zone(); }
    }
    else if (g == "roof")   translate([0, 0, deck_z + eave_z]) es2_roof();
    else if (g == "frame")  { es2_frame_full(false); es2_steps_placed(); es2_underside(); es2_air_hose_placed(); for (s = [-1, 1]) mirror([s > 0 ? 0 : 1, 0, 0]) es2_coupler(); }
    else if (g == "trucks") for (s = [-1, 1]) translate([s * truck_x, 0, 0]) es2_truck(false);
    else if (g == "wheels") for (s = [-1, 1], a = [-1, 1]) translate([s * truck_x + a * tk_ax, 0, axle_z]) for (m = [0, 1]) mirror([0, m, 0])
                                translate([0, rg_b2b / 2, 0]) rotate([-90, 0, 0]) es2_wheel(wheel_d);
    else if (g == "axles")  for (s = [-1, 1], a = [-1, 1]) translate([s * truck_x + a * tk_ax, 0, axle_z]) rotate([90, 0, 0]) cylinder(d = rg_axle_d, h = tk_axle_len, center = true, $fn = 20);
    else if (g == "lights") { for (s = [-1, 1]) translate([s * (cab_hx + hl_x), 0, deck_z + hl_pad_top]) mirror([s > 0 ? 0 : 1, 0, 0]) es2_headlight_tower();
                              translate([-(cab_hx + bell_x), 0, deck_z + bell_pad_top]) es2_bell();
                              hood_place(2) es2_pole_mast_placed(); }
    else if (g == "glass")  for (w = CAB_WIN) translate([p(w[4]) - p(w[1]) / 2, w[0] * (cab_hw - CAB_WALL - 0.6) - 0.3, deck_z + p(w[3])]) cube([p(w[1]), 0.6, p(w[2])]);
    else if (g == "letter") es2_lettering();
    else if (g == "rails")  rg_track(p(OVER_COUPLERS) + 120);
    else if (g == "rivets") { es2_frame_rivets(); translate([0, 0, deck_z]) cab_rivets(); for (n = [1, 2]) hood_place(n) hood_rivets(n); }
    else if (g == "handrails") { es2_handrails(); for (n = [1, 2]) hood_place(n) es2_rail_posts_placed(); }
    else if (g == "lens")   for (s = [-1, 1]) translate([s * (cab_hx + hl_x), 0, deck_z + hl_pad_top]) mirror([s > 0 ? 0 : 1, 0, 0]) es2_headlight_lens_placed();
    else if (g == "panto")  es2_pantograph_placed();
    else if (g == "inside") { if (DOOR_OPEN > 0) for (n = [1, 2]) hood_place(n) es2_hood_inside(n); }
    else if (g == "walk")   for (s = [-1, 1]) es2_walkway(s);
    else if (g == "wire")   { es2_black_wire(); es2_slider_placed(); }
}
