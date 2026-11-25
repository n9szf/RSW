// Milwaukee Road E7A - HO scale 1:87. Same as MILW_E7_Main.scad with the scale fixed.
// MR Print Files makes the prints from this file (part = each name in print_parts.json).
SCALE_SEL = "HO";
LOCO_SEL  = "16A";          // [16A, 16B, 17A, 17B, 18A, 18B, 19A, 19B, 20A, 20B]
PAINT_SEL = "1956";         // [1946, 1950, 1956] preview only
part = "preview";           // [preview, body_1, frame_1, frame_2, pilot, pilot_rear, truck]
include <library/e7_all.scad>
if (part == "preview") e7_preview(); else e7_plate(part);
e7_report();
