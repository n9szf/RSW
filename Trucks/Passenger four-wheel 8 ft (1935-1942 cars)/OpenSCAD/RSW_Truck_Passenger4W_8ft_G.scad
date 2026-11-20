// =====================================================================
//  RSW_Truck_Passenger4W_8ft_G.scad  -  G scale (1:29)
//  Milwaukee Road four-wheel passenger truck, 8 ft wheelbase (1938 Hiawatha style), 1935-1942 cars
//  Made from the shared truck library: RSW / export / Trucks / library.
//  SPRUNG BOLSTER (TDQ-268): the bolster is not glued - its ends ride in
//  windows in the sideframes on 4 steel springs standing on the spring plank.
//
//  part = "assembly"       whole truck on the rail, to look at
//         "sideframe"      print 2 per truck (4 per car), inner face down
//         "bolster"        print 1 per truck, flat (bottom down)
//         "end_beam"       print 2 per truck, flat; glue into the sideframe slots
//                          (on this truck they sit between the bolster and the wheels)
//         "spring_plank"   print 1 per truck, flat; glue into the low slots
//         "wheel"          print 4 per truck, flange face down; paint light silver
//         "bearing_coupon" print 1 first: bearing press-fit test (-, 0, +)
//         "section"        a cut through the truck centre, to see the springs
//  Set SPRUNG = false for the old glued bolster.
//  Render (F6), then File > Export > STL.  The echo lists what to buy.
// =====================================================================
part   = "assembly";
SPRUNG = true;
RG_SCALE  = "G";
PT_STYLE  = "1938";
PT_WB_FT  = 8;
PT_SPRUNG = SPRUNG;
include <../../library/rsw_trucks.scad>
pt_part(part);
