// =====================================================================
//  rsw_trucks.scad  -  RSW shared truck library (TDQ-266)
//  Include THIS file. Set the scale first:
//      RG_SCALE = "G";     // "G" = 1:29 on 45 mm track, "O" = 1:48 two-rail
//      include <.../Trucks/library/rsw_trucks.scad>
//
//  Files:
//    rsw_running_gear.scad      wheels, axles, bearings, bearing pocket,
//                               fit coupon, the per-scale standards table
//    rsw_truck_bettendorf.scad  Bettendorf freight / caboose truck (bt_*)
//    rsw_truck_passenger.scad   four-wheel passenger trucks, A-4778 7 ft and 1938 8 ft (pt_*),
//                               sprung bolster on steel springs (TDQ-268)
//  Still to move in: the six-wheel passenger truck (Passenger cars/common/mr_truck.scad).
// =====================================================================
include <rsw_running_gear.scad>
include <rsw_truck_bettendorf.scad>
include <rsw_truck_passenger.scad>
