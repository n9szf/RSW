// ==========================================================================
//  MILW_E7_Main.scad
//  Milwaukee Road EMD E7A passenger diesel - class 20-EP, 16A/B - 20A/B, built 1946.
//  A1A-A1A, 2000 hp. G (1:29), O (1:48) and HO (1:87.1) - Rib Side Works, Locomotives group.
//
//  FOLDER LAYOUT (RSW / export / Locomotives / E7)
//    scad/MILW_E7_Main.scad          - this file: the painted preview, every print by name
//    scad/MILW_E7_G.scad, _O, _HO    - the same, scale fixed (MR Print Files uses these)
//    scad/parts/<scale>/             - ONE FILE PER PRINT: open one, render (F6), export STL, print
//    scad/library/                   - the model; every setting is in e7_params.scad
//    notes/                          - notes, preview pictures, Blender renders
//    print_parts.json                - what MR Print Files makes
//
//  HOW IT GOES TOGETHER
//    The carbody (sides, roof and nose in one shell) prints upright in sections, open at the
//    bottom; each section has a sleeve that slides into the next.  The frame is a flat plate in
//    pieces joined by half laps; its joints fall under the middle of a body section.
//    Self-tapping screws go up through countersunk holes in the frame into bosses inside the
//    body side walls - take them out and the body lifts off (same as the Little Joe).
//    Two A1A trucks pivot on screws through the frame; wheelsets are bought (TDQ).
//    The pilot screws under the front of the frame and carries the front coupler pocket;
//    a small pocket block does the same at the rear.
//
//  v1 (30 Oct 2026): first model from published figures, NO DRAWINGS YET - the nose shape,
//      windows, grilles and paint bands are ESTIMATES, see e7_params.scad and the TDQs.
//  v2 (23 Nov 2026): new nose and cab front (library/e7_nose.scad) from the clean F-unit nose
//      (EMD FP7 folder), stretched to the E7 and carried down to the skirt; default paint UP
//      yellow (Tom). Still ESTIMATE until an E7/E8 drawing or E9 photos are checked (TDQ-610).
//      All 7 body prints (G 4, O 2, HO 1) export as single clean solids.
// ==========================================================================

SCALE_SEL = "G";            // [G, O, HO]
LOCO_SEL  = "16A";          // [16A, 16B, 17A, 17B, 18A, 18B, 19A, 19B, 20A, 20B]
PAINT_SEL = "1956";         // [1946, 1950, 1956] preview / Blender only
part = "preview";           // [preview, body_1, body_2, body_3, body_4, frame_1, frame_2, frame_3, frame_4, frame_5, pilot, pilot_rear, truck] (O: body_1-2, frame_1-3; HO: body_1, frame_1-2)

include <library/e7_all.scad>

if (part == "preview") e7_preview();
else e7_plate(part);

e7_report();
