// =====================================================================
//  TRUCK  -  printed Bettendorf-style freight / caboose truck
//  Milwaukee Road 1939 rib side bay window caboose - G scale (1:29)
//  Library file - do not open on its own. It is pulled in by
//  library/caboose_all.scad.
//
//  13 Oct 2026 (TDQ-266): the truck itself now lives in the shared RSW
//  truck library, RSW / export / Trucks / library / rsw_trucks.scad,
//  so a fix there reaches every car that rides on this truck, in every
//  scale. This file only hands the library the caboose's own numbers
//  (from caboose_params.scad) and keeps the names the rest of the
//  caboose files use.
//
//  Bought parts, per car: 4 axles cut from 3 mm brass rod, 8 F683ZZ
//  flanged ball bearings (3 x 7 x 3), 2 pivot screws (~3 mm).
//  Wheel, bearing and fit settings: Trucks / library / rsw_running_gear.scad
//  Frame shape: Trucks / library / rsw_truck_bettendorf.scad
// =====================================================================

RG_SCALE       = "G";
BT_WB_IN       = truck_wb / S;          // 66 in, from caboose_params
BT_WHEEL_D     = wheel_dia;             // 29 mm
BT_BOLSTER_TOP = truck_bolster_h;       // 22 mm
include <../../../../../Trucks/library/rsw_trucks.scad>

// names the caboose files use
truck_axle_d   = rg_axle_d;
truck_axle_len = rg_axle_len;
t_zc           = bt_zc;
t_yi           = rg_yi;

module truck_wheel()            { bt_wheel_print(); }
module truck_sideframe()        { bt_sideframe(); }
module truck_bolster()          { bt_bolster(); }
module truck_frame()            { bt_frame(); }
module truck_assembly(wheels = true) { bt_assembly(wheels); }
module truck_sideframe_print()  { bt_sideframe_print(); }
module truck_bolster_print()    { bt_bolster_print(); }

// both trucks in place under the car (car z = 0 is the bottom of the body)
module placed_trucks(wheels = true) {
    for (x = [-p(truck_centers) / 2, p(truck_centers) / 2])
        translate([x, 0, -floor_above_rail]) truck_assembly(wheels);
}
