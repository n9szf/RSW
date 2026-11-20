// =====================================================================
//  MILW_LittleJoe_Main.scad
//  Milwaukee Road "Little Joe" 2-D+D-2 electric - GE 1948, bought 1950.
//  EF-4 freight E70-E79 and EP-4 passenger E20-E21.
//  G (1:29), O (1:48) and HO (1:87.1) - Rib Side Works, Locomotives group.
//
//  FOLDER LAYOUT (RSW / export / Locomotives / Little Joe)
//    scad/MILW_LittleJoe_Main.scad - this file: the painted preview, every print by name
//    scad/MILW_LittleJoe_G.scad, _O.scad, _HO.scad - the same, scale fixed (MR Print Files uses these)
//    scad/parts/<scale>/            - ONE FILE PER PRINT: open one, render (F6), export STL, print
//    scad/library/                  - the model; every setting is in lj_params.scad
//    notes/                         - notes, preview pictures, Blender renders
//    print_parts.json               - what MR Print Files makes
//
//  HOW IT GOES TOGETHER
//    The body (sides and ends) prints in sections, upright; each section has a sleeve that
//    slides into the next. The roof prints in matching sections and drops over a lip on the walls.
//    The frame is a flat deck in pieces joined by half laps; its joints fall under the middle of a
//    body section. SCREW MOUNTS (Tom 10/20): self-tapping screws go up through countersunk holes in
//    the frame into bosses inside the body side walls - take them out and the body lifts off.
//    Four trucks (two 4-axle driving, two 2-axle guide) pivot on screws through the frame.
//    Pilots screw under the frame ends and carry the coupler pockets.
//
//  v1 (20 Oct 2026): first model from published figures (no drawings yet) - most shapes are
//      ESTIMATES, see lj_params.scad and the TDQs in RSW / notes / Research_Notes.
// =====================================================================

SCALE_SEL = "G";           // [G, O, HO]
LOCO_SEL  = "E70";         // [E20, E21, E70, E71, E72, E73, E74, E75, E76, E77, E78, E79]
PAINT_SEL = "OLYMPIAN";    // [OLYMPIAN, FREIGHT] preview / Blender only
PAN_RAISE_SEL = 0.25;      // [0:0.05:1] pantographs shown 0 down - 1 up
part = "preview";          // [preview, body_1, body_2, body_3, body_4, roof_1, roof_2, roof_3, roof_4, frame_1, frame_2, frame_3, frame_4, frame_5, nose, pilot, truck_drive, truck_guide, wheels_drive, wheels_guide, bearing_coupon]

RENDER = "";               // used by Blender / render_loco.py only

include <library/lj_all.scad>

if (RENDER != "") lj_render(RENDER);
else if (part == "preview") lj_preview();
else lj_plate(part);

lj_report();
