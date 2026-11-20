// =====================================================================
//  MILW_ES2_Main.scad
//  Milwaukee Road class ES-2 electric switcher (GE steeplecab, 1916/1919)
//  as E80-E83 after the March 1939 renumbering - the later version.
//  G scale (1:29) only - Rib Side Works, Locomotives group.
//
//  FOLDER LAYOUT (RSW / export / Locomotives / ES-2 switcher)
//    scad/MILW_ES2_Main.scad  - this file: the painted preview, and every
//                               print plate by name (MR Print Files uses it)
//    scad/parts/              - ONE FILE PER PRINT (Tom 10/13): open one,
//                               render (F6), export STL, print.
//        ES2_01_frame_A.scad    frame, hood 2 half + its walkway   (print 1)
//        ES2_02_frame_B.scad    frame, hood 1 half + its walkway   (print 2)
//        ES2_03_hood_1.scad     hood 1 + headlight tower, lens, bell, ladder
//        ES2_04_hood_2.scad     hood 2 (with the side tank) + headlight tower, lens, ladder
//        ES2_05_cab.scad        cab + roof
//        ES2_06_truck_A.scad    truck A: 2 sideframes, bolster with motors, 4 wheels
//        ES2_07_truck_B.scad    truck B: the same
//        ES2_08_underside.scad  underside box + 2 couplers + height gauge + 2 air hoses + 4 steps
//    scad/library/            - the model; every setting is in es2_params.scad
//    notes/                   - notes PDF, preview pictures
//    print_parts.json         - what MR Print Files makes
//  Bought: a pantograph; brass axles, F683ZZ bearings, screws, magnets (see the report).
//  Drawings and photos: RSW / reference / Locomotives / ES-2 switcher.
//
//  v10 (18 Nov 2026, Tom): truck bolster joined to the sideframes by dovetails and a 1 mm brass pin
//      each side (no glue); dovetail test coupon (part dovetail_coupon). Only the truck prints changed.
//  v9 (20 Oct 2026) - DESIGN FROZEN (Tom, TDQ-367): Customizer pull-downs (scale, loco, paint) and a
//      tick box per part; $fn 100; railing posts and the pole hook mast are separate prints.
//      Pictures, GLB files and STLs: RSW / Blender / Render ES-2 switcher.bat.
//  v8 (18 Oct 2026, Tom after printing the base, TDQ-349): pole pockets on the end sills;
//      frame halves joined by three 2 mm brass rods (100 mm); hoods and cab screwed down with
//      M2.5 screws as on the passenger cars, cab screwed to each hood; steps printed separately; truck pivots are a shoulder bolt (4 x 16, M3) and a nylon nut.
//  v7 (17 Oct 2026, TDQ-342): US 13-B trolley base on the roof and a 2 mm brass pole to a hook mast
//      on hood 2, slider trolley (small print on the cab plate), sand pipes on the trucks, air hoses
//      (two small prints on the underside plate), uncoupling levers. Doors stay closed on the print.
//  v6 (17 Oct 2026, Tom: "as much detail as possible, focus G scale"): channel side sills,
//      pole-pushing pockets, diamond-plate walkways (thin separate print on each frame plate),
//      hinged hood doors that open in the preview (DOOR_OPEN_SEL), hooded louvres and grilles
//      by the cab (the HO E83 slots), hood-top hatches, ventilator and insulators, hand-hole
//      covers, ladders on the hood ends, railings of 1 mm wire through printed posts (white),
//      cab grab irons, rivets (grey in the preview), window visors, cab door hinges, white
//      headlight lenses and lamp visors, spoked wheels, the pantograph (shown, not printed).
//  v5 (17 Oct 2026): checked against the MPL ES-2 drawing set (record 9267, 11 sheets in
//      reference / ... / MPL drawings): hood length 13 ft 5 1/16 in; truck to drawing 18524-A
//      (frame centres 6 ft 6 in, spring centres 4 ft 2 in, frame ends, one brake cylinder);
//      sandbox caps on the hoods; headlight 19 1/2 in from the hood end; bell on hood 1;
//      pantograph base 92 x 63 in; lightning arrester and whistle on the roof; side sash 31 3/8 in.
//  v4 (13 Oct 2026): trucks printed and unpowered again (Tom: "non power, best looking") - GE
//      equalized bar-frame truck with journal boxes, equalizers and springs, sandboxes, brake
//      cylinders and traction motors; 35 mm wheels, brass axles, F683 bearings. Blender render pieces.
//  v3 (13 Oct 2026): selector for E80-E83 (LOCO_SEL), orange and black paint, sides from Tom's
//      HO E83: side tank on the drawing's side, one window each cab side, number boards on the
//      roof sides, five doors on hood 2's far side, short headlight stands (E82: tall tower).
//  v2 (13 Oct 2026, Tom's answers to TDQ-293 to 301): G only, later version,
//      bought motor blocks, printed coupler, bought pantograph, 8 prints.
//  v1 (13 Oct 2026): first model, from the GE drawing of 10050 as built.
//  Open questions: TDQ-293, 299-308, 337-338, 341, 349-350 in RSW / notes / Research_Notes.
// =====================================================================

/* [Model] */
// model scale (Tom 10/20)
SCALE_SEL = "G"; // [G:G scale 1-29, O:O scale 1-48]
// which loco (Tom 10/13: selector E80 - E83)
LOCO_SEL  = "E83"; // [E80, E81, E82, E83]
// preview only
PAINT_SEL = "ORANGE_BLACK"; // [ALL_BLACK:All black, ORANGE_BLACK:Orange and black, ORANGE_MAROON:Maroon, NO_PAINT:No paint]
// hood doors shown open, degrees (preview / pictures only - prints are closed)
DOOR_OPEN_SEL = 0; // [0:5:110]
// which doors open
DOORS_SEL = "ALL"; // [ALL, HOOD_1, HOOD_2, TANK_SIDE, FAR_SIDE]
// pantograph: 0 locked down, 1 up (shown only - it is bought)
PAN_RAISE_SEL = 0.25; // [0:0.05:1]
// curve smoothness ($fn); 100 = Tom 10/20
FN_SEL = 100; // [24:4:200]
// a whole print plate
part = "preview"; // [preview, frame_A, frame_B, hood_1, hood_2, cab, truck_A, truck_B, underside, dovetail_coupon]

/* [Show in the preview] */
SHOW_FRAME        = true;    // frame halves, joining rods, pivot bolts
SHOW_STEPS        = true;    // the four steps under the frame corners (separate prints, pinned on)
SHOW_WALKWAYS     = true;    // diamond-plate walkways
SHOW_UNDERSIDE    = true;    // reservoir / weight box
SHOW_CAB          = true;    // cab (with grab irons and glass)
SHOW_ROOF         = true;    // cab roof (with the trolley base)
SHOW_HOOD_1       = true;    // hood 1 with its headlight, bell and ladder
SHOW_HOOD_2       = true;    // hood 2 with its side tank, headlight, pole mast and ladder
SHOW_HEADLIGHTS   = true;    // headlight towers and lenses (separate prints)
SHOW_BELL         = true;    // bell on hood 1 (separate print)
SHOW_LADDERS      = true;    // ladders on the hood ends (separate prints)
SHOW_POLE_MAST    = true;    // trolley pole hook mast on hood 2 (separate print)
SHOW_RAILINGS     = true;    // white railings, their posts (separate prints) and grab irons
SHOW_PANTOGRAPH   = true;    // pantograph (bought, not printed)
SHOW_TROLLEY_POLE = true;    // trolley pole and slider
SHOW_TRUCKS       = true;    // truck frames, motors, sand pipes
SHOW_WHEELS       = true;    // wheelsets
SHOW_COUPLERS     = true;    // couplers, air hoses, uncoupling levers
SHOW_GLASS        = true;    // cab window glass
SHOW_TRACK        = true;    // the rails under the loco

/* [Hidden] */
show_piece = "none";        // one piece on its own (es2_piece in es2_all.scad); set e.g. "wheel" to use it

RENDER = "";                 // used by Blender / render_loco.py only

include <../library/es2_all.scad>  // run from scad/tools
PIECE = "sideframe";
// truck coordinates: x = 0 truck centre, z = 0 rail top
if (PIECE == "sideframe")  es2_sideframe();
if (PIECE == "sideframe2") mirror([0, 1, 0]) es2_sideframe();
if (PIECE == "bolster")    es2_bolster();
if (PIECE == "wheels")     for (s = [-1, 1], t = [1, -1]) translate([s * tk_ax, 0, axle_z]) scale([1, t, 1]) translate([0, rg_b2b / 2, 0]) rotate([-90, 0, 0]) es2_wheel(wheel_d);
if (PIECE == "axles")      for (s = [-1, 1]) translate([s * tk_ax, 0, axle_z]) rotate([90, 0, 0]) cylinder(d = rg_axle_d, h = tk_axle_len, center = true, $fn = 24);
if (PIECE == "bearings")   for (s = [-1, 1], t = [1, -1]) translate([s * tk_ax, 0, axle_z]) scale([1, t, 1]) translate([0, tk_yi, 0]) rotate([-90, 0, 0]) rg_bearing_part();
if (PIECE == "bolt")       translate([-truck_x, 0, 0]) es2_pivot_hardware_one();
module es2_pivot_hardware_one() translate([truck_x, 0, 0]) {
    translate([0, 0, pivot_bolt_head_z]) cylinder(d = PIVOT_BOLT[2], h = PIVOT_BOLT[3], $fn = FN);
    translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1]]) cylinder(d = PIVOT_BOLT[0], h = PIVOT_BOLT[1], $fn = 24);
    translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1] - 4.5]) cylinder(d = 3, h = 4.5, $fn = 16);
}
if (PIECE == "nut")        translate([0, 0, pivot_bolt_head_z - PIVOT_BOLT[1] - PIVOT_NUT[1]]) difference() { cylinder(d = PIVOT_NUT[0] / cos(30), h = PIVOT_NUT[1], $fn = 6); translate([0,0,-1]) cylinder(d = 2.6, h = 9, $fn = 16); }
if (PIECE == "framepad")   translate([-truck_x, 0, 0]) intersection() { es2_frame_full(rivets = false); translate([truck_x - 22, -60, pivot_z]) cube([44, 120, 30]); }
if (PIECE == "pins") for (m = [0, 1]) mirror([0, m, 0]) translate([0, tk_yi - tk_pin_in, tk_pin_z]) rotate([-90, 0, 0]) cylinder(d = TK_PIN[0], h = tk_pin_len, $fn = 16);
