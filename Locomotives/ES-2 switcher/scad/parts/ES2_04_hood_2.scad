// Milwaukee Road ES-2 switcher, G scale - print 4 of 8: hood_2
// Render (F6), export STL, print. Settings: ../library/es2_params.scad
// Whole loco preview and notes: ../MILW_ES2_Main.scad
// model scale
SCALE_SEL = "G"; // [G:G scale 1-29, O:O scale 1-48]
// which loco - the hood prints change with it
LOCO_SEL = "E83"; // [E80, E81, E82, E83]
// curve smoothness ($fn)
FN_SEL = 100; // [24:4:200]
include <../library/es2_all.scad>
es2_plate("hood_2");
