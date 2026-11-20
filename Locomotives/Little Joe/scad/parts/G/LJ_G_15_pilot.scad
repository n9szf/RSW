// Milwaukee Road Little Joe, G scale 1-29 - print 15 of 20: pilot - pilot with coupler pocket - print 2
// Render (F6), export STL, print. Settings: ../../library/lj_params.scad
// Whole loco preview and notes: ../../MILW_LittleJoe_Main.scad
SCALE_SEL = "G";
LOCO_SEL = "E70";   // [E20, E21, E70, E71, E72, E73, E74, E75, E76, E77, E78, E79] the body and roof change for E20 / E21
include <../../library/lj_all.scad>
lj_plate("pilot");
