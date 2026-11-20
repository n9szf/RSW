// Milwaukee Road Little Joe - HO scale 1-87. Same as MILW_LittleJoe_Main.scad with the scale fixed.
// MR Print Files makes the prints from this file (part = each name in print_parts.json).
SCALE_SEL = "HO";
LOCO_SEL  = "E70";         // [E20, E21, E70, E71, E72, E73, E74, E75, E76, E77, E78, E79]
PAINT_SEL = "OLYMPIAN";    // [OLYMPIAN, FREIGHT] preview only
part = "preview";          // [preview, body_1, body_2, roof_1, roof_2, frame_1, frame_2, frame_3, nose, pilot, truck_drive, truck_guide]
RENDER = "";
include <library/lj_all.scad>
if (RENDER != "") lj_render(RENDER); else if (part == "preview") lj_preview(); else lj_plate(part);
lj_report();
