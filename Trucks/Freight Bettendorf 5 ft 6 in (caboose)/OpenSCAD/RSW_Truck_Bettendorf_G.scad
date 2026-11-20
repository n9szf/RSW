// =====================================================================
//  Bettendorf-style freight / caboose truck - G scale (1:29 on 45 mm track)
//  5'-6" wheelbase, 33" wheels. Drawn by eye - not verified (TDQ-192/193).
//  Made from the shared truck library: RSW / export / Trucks / library.
//
//  part = "truck"           whole truck on the rail, to look at
//         "truck_sideframe" print 4 per car, inner face down
//         "truck_bolster"   print 2 per car, flat
//         "truck_wheel"     print 8 per car, flange face down; paint light silver
//         "bearing_coupon"  print 1 first: bearing press-fit test (-, 0, +)
//  Render (F6), then File > Export > STL.  The echo lists what to buy.
// =====================================================================
part = "truck";
RG_SCALE = "G";
include <../../library/rsw_trucks.scad>
bt_part(part);
