// Milwaukee Road Little Joe, HO scale 1-87 - print 8 of 11: nose - NOSE (FreeCAD) - print 2, upright; glues over the sleeve on the cab front, 2 screws up through the frame
// Render (F6), export STL, print. Settings: ../../library/lj_params.scad
// Whole loco preview and notes: ../../MILW_LittleJoe_Main.scad
SCALE_SEL = "HO";
LOCO_SEL = "E70";   // [E20, E21, E70, E71, E72, E73, E74, E75, E76, E77, E78, E79] the body and roof change for E20 / E21
include <../../library/lj_all.scad>
lj_plate("nose");
