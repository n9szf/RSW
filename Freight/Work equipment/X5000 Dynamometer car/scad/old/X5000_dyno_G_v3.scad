// Milwaukee Road X5000 Dynamometer Car - G scale (1:29)
// Rib Side Works - MODEL v3 (10/26/26): sizes from Milwaukee Public Library drawings
//   A-850 floor plan (1934 and 1965/69 revisions), A-911 side frame, A-912 underframe,
//   read from MPL preview scans (small print - check against full-size copies).
//   Outside details from Flickr photos (Shoreham 1980s/1993, IRM 2014).
// Stand-alone: no BOSL2, no includes.
//
// What the photos show:
//  - Rebuilt from a heavyweight passenger car: riveted steel sides, belt rail,
//    plain arched roof that rounds down over enclosed ends (no diaphragms).
//  - A end (instrument end): end door, bay window on each side ~14 ft back,
//    side door with a porthole ~24 ft back.
//  - B end (kitchen): a pair of small windows each side.
//  - Side 1 also has one window mid-car and a long stepped housing on the roof
//    offset to that side. Exhaust stack and roof box near the middle.
//  - Paint (Tom 10/24): Milwaukee Road orange with black roof, black letterboard
//    band and black ends; Roman "THE MILWAUKEE ROAD" lettering, box heralds.
//
// Axes: x = along car from A end (0) to B end; y = across (+y = side 1);
// z = up from rail top. All prototype sizes go through s(ft, in).

/* [Part] */
part = "view";      // [view, body, black, red, white, roof, floor, interior, truck, joiners]  floor = underframe; black/red/white = paint inlays
truck_part = "assembly";  // [assembly, sideframe, bolster, end_beam, spring_plank, wheel, bearing_coupon, section] when part = truck
section_no = 0;     // [0:4] 0 = whole part; 1-4 = print section of body/roof/floor/interior
sections = 4;       // long parts split into this many pieces (about 184 mm each)

/* [Era] */
ERA = 1992;         // [1930:As built (steam testing), 1992:As preserved at IRM]
INTERIOR = true;    // full interior
RIVETS = true;      // rivet rows on sill and belt rail (slower to render)

/* [Blender] */
RENDER = "";        // set by render_x5000.py: one coloured group, in place, car centred on x = 0

/* [Paint and lettering - Milwaukee Road orange and black] */
// decal = plain orange body, lettering shown in the view only (use the decal sheet)
// inlay = body gets 0.4 mm pockets; print black/red/white parts with the body section
//         as one multi-colour object (AMS). Works, but many colour changes on upright walls.
LETTERING = "decal";   // [decal, inlay, none]
INLAY = 0.4;           // pocket depth for inlay paint
LB_TEXT  = "THE MILWAUKEE ROAD";   // letterboard, centred
CAR_NO   = "X5000";
CLASS_TX = "DYNAMOMETER";
FONT_LB  = "Liberation Serif:style=Bold";      // Roman letterboard style
FONT_H   = "Liberation Sans:style=Bold";       // herald

/* [Scale] */
SCALE = 29;
function s(ft=0, inch=0) = (ft*12 + inch) * 25.4 / SCALE;

/* [Body - best guesses from photos] */
L_BODY    = s(65,10);   // over end castings - MPL drawing A-850 (65'-10")
L_COUP    = s(73,10);   // over couplers (IRM roster)
W_BODY    = s(9,10.5);  // over side sills - A-850 (9'-10 1/2"); IRM 11'2" is over the bays
BAY_OUT   = s(0,7.75);  // bay projection: (11'2" - 9'10 1/2") / 2
H_SILL    = s(3,9);     // rail to bottom of side sill
H_BELT    = s(7,3);     // belt rail / window sills
H_LETTER  = s(12,0);    // bottom of black letterboard band
H_EAVE    = s(12,9);    // top of side
H_CROWN   = s(14,4);    // roof crown
H_HOUSING = s(15,4);    // top of roof housing (IRM 15'4")
END_DROP  = s(0,10);    // roof rounds down this much over each end
TRUCK_CTR = s(47,6);    // truck centres - A-850 (47'-6", last digit hard to read)
// Trucks: the RSW passenger truck (Tom 10/26: "use the passenger car trucks") - the 1938 Hiawatha-style
// four-wheel truck, 8 ft wheelbase, sprung bolster, from the shared library
// RSW / export / Trucks / library (same as "Passenger four-wheel 8 ft (1935-1942 cars)").
RG_SCALE = "G"; PT_STYLE = "1938"; PT_WB_FT = 8; PT_SPRUNG = true;
PT_RAIL_TO_SILL_FT = 3.75;   // = H_SILL: the bolster top sits PT_PAD_H below the car's sill
PT_PAD_H = 6;
include <../../../../Trucks/library/rsw_trucks.scad>
WB        = PT_WB;      // 8 ft
WHEEL_D   = rg_in(36);  // 36 in wheels

/* [Print] */
WALL   = 2.2;           // side and end walls
FLOOR  = 3.0;           // floor plate
TOL    = 0.25;          // fit clearance
GAUGE  = rg_gauge;      // 45 mm G track (wheels, axles and bearings: see the truck library)
$fn = 40;

// ---------------- side openings ----------------
// [x_ft centre from A end, w_in, h_in, sill_in_above_rail, shape]
// shape: 0 square, 1 round (porthole), 2 rounded-corner
SIDE_COMMON = [
  [14.0, 14, 14, 84, 1],          // porthole in side door
  [57.8, 18, 30, 87, 2],          // B end pair (kitchen)
  [59.7, 18, 30, 87, 2]
];
SIDE1_EXTRA = [ [41.4, 24, 30, 87, 2] ];   // single mid window, side 1 only
SIDE2_EXTRA = [];
DOOR = [14.0, 28, 78];            // side door [x_ft, w_in, h_in] - outline only; A-911 door opening ~13.5 ft
BAY  = [9.5, 54, 40, 84];         // bay [x_ft, w_in, h_in, sill_in] - A-850 1965 plan; no bays on the 1934 plan
BAYS = ERA >= 1992;               // 1930: flat instrument-room windows instead
FLAT_1930 = [ [8.0, 26, 30, 87, 0], [11.0, 26, 30, 87, 0] ];
// bay front windows per side: [offset_in from bay centre, w_in, h_in, shape]
BAY1_WIN = [ [-10, 16, 16, 1], [10, 18, 22, 0] ];  // side 1: round + square
BAY2_WIN = [ [0, 30, 26, 2] ];                     // side 2: one big rounded
BAY_SIDE_WIN = [8, 26];           // narrow windows in bay ends [w_in, h_in]
END_DOOR = [28, 78];              // end door [w_in, h_in]

// ---------------- helpers ----------------
function sd(side) = side > 0 ? 1 : -1;

module window_hole(w, h, shape, depth) {
  if (shape == 1) rotate([90,0,0]) cylinder(d=w, h=depth, center=true);
  else if (shape == 2) {
    r = min(w,h)*0.2;
    rotate([90,0,0]) linear_extrude(depth, center=true)
      offset(r) square([w-2*r, h-2*r], center=true);
  }
  else cube([w, depth, h], center=true);
}

// arched roof cross-section (2D in y,z), from z0 up to the crown
module roof_profile(w, z0, eave, crown) {
  rise = crown - eave;
  r = (w*w/4 + rise*rise) / (2*rise);
  intersection() {
    translate([0, crown - r]) circle(r=r, $fn=180);
    translate([-w/2, z0]) square([w, crown - z0 + 1]);
  }
}

// ---------------- body shell (sides + ends + floor deck) ----------------
module body_shell() {
  if (LETTERING == "inlay") difference() { body_raw(); paint_all(-INLAY, 0.01); }
  else body_raw();
}

module body_raw() {
  z0 = H_SILL + FLOOR;                     // floor deck is part of the body: each section is one U-channel
  difference() {
    union() {
      translate([0, -W_BODY/2, H_SILL]) cube([L_BODY, W_BODY, H_EAVE - H_SILL]);
      if (BAYS) for (side=[-1,1]) bay_box(side);
    }
    // hollow
    translate([WALL, -W_BODY/2 + WALL, z0])
      cube([L_BODY - 2*WALL, W_BODY - 2*WALL, H_EAVE]);
    for (side=[-1,1]) {
      if (BAYS) bay_hollow(side);
      for (o = concat(SIDE_COMMON, side > 0 ? SIDE1_EXTRA : SIDE2_EXTRA, BAYS ? [] : FLAT_1930))
        translate([s(o[0]), side*W_BODY/2, s(0,o[3]) + s(0,o[2])/2])
          window_hole(s(0,o[1]), s(0,o[2]), o[4], WALL*3);
      // door outline groove (door is closed; groove shows it)
      translate([s(DOOR[0]), side*(W_BODY/2), z0 + s(0,DOOR[2])/2])
        difference() {
          cube([s(0,DOOR[1]) + 0.8, 1.0, s(0,DOOR[2]) + 0.8], center=true);
          cube([s(0,DOOR[1]), 2, s(0,DOOR[2])], center=true);
        }
    }
    // end doors (open doorways, both ends)
    for (x=[0, L_BODY]) translate([x, 0, z0 + s(0,END_DOOR[1])/2])
      cube([WALL*3, s(0,END_DOOR[0]), s(0,END_DOOR[1])], center=true);
  }
  if (RIVETS) rivets();
}

module bay_box(side) {
  bw = s(0,BAY[1]); bh = s(0,BAY[2]); z = s(0,BAY[3]);
  translate([s(BAY[0]) - bw/2, side > 0 ? W_BODY/2 - WALL : -W_BODY/2 - BAY_OUT, 0])
    hull() {                                   // chamfered bottom for printing
      translate([0, 0, z]) cube([bw, BAY_OUT + WALL, bh]);
      translate([0, side > 0 ? 0 : BAY_OUT, z - BAY_OUT]) cube([bw, WALL, 0.1]);
    }
}

module bay_hollow(side) {
  bw = s(0,BAY[1]); bh = s(0,BAY[2]); z = s(0,BAY[3]);
  y_face = side*(W_BODY/2 + BAY_OUT);
  // inside of the bay open to the car
  translate([s(BAY[0]) - bw/2 + WALL, side > 0 ? W_BODY/2 - WALL - 1 : -W_BODY/2 - BAY_OUT + WALL, z + 1.2])
    cube([bw - 2*WALL, BAY_OUT + 1, bh - 2.4]);
  // front windows
  for (w = side > 0 ? BAY1_WIN : BAY2_WIN)
    translate([s(BAY[0]) + s(0,w[0]), y_face, z + bh/2])
      window_hole(s(0,w[1]), s(0,w[2]), w[3], WALL*3);
  // narrow end windows of the bay (look fore and aft)
  for (e=[-1,1]) translate([s(BAY[0]) + e*bw/2, side*(W_BODY/2 + BAY_OUT/2), z + bh/2])
    cube([WALL*3, s(0,BAY_SIDE_WIN[0]), s(0,BAY_SIDE_WIN[1])], center=true);
}

module rivets() {
  sp = s(0,6);
  for (side=[-1,1], zr=[H_SILL + FLOOR + 1.2, H_BELT - 1.0, H_LETTER - 0.8])
    for (x=[2:sp:L_BODY-2])
      if ((!BAYS || abs(x - s(BAY[0])) > s(0,BAY[1])/2 + 1 || zr < s(0,BAY[3]) - BAY_OUT)
          && abs(x - s(DOOR[0])) > s(0,DOOR[1])/2 + 1.5
          && abs(x - round(x / (L_BODY/sections)) * (L_BODY/sections)) > 1    // clear of section cuts
          && min([for (h = HERALDS) abs(x - s(h))]) > s(1,8))                // clear of the heralds
        translate([x, side*(W_BODY/2 - 0.25), zr]) rotate([-side*90,0,0])
          cylinder(d=0.6, h=0.6, $fn=6);          // 0.35 mm proud, 0.25 mm buried
}

// ---------------- roof (solid, flat underside, prints flat side down) ----------------
module roof_shell() {
  lip = 3;                                    // locating lip inside the walls
  e = s(1,6);                                 // length of the rounded end hood
  difference() {
    union() {
      hull() {
        translate([e, 0, 0]) rotate([90,0,90]) linear_extrude(L_BODY - 2*e)
          roof_profile(W_BODY, H_EAVE, H_EAVE, H_CROWN);
        for (x=[0, L_BODY - 0.1]) translate([x, 0, 0]) rotate([90,0,90]) linear_extrude(0.1)
          roof_profile(W_BODY - 2, H_EAVE, H_EAVE, H_CROWN - END_DROP);
      }
      translate([WALL + TOL, -W_BODY/2 + WALL + TOL, H_EAVE - lip])
        cube([L_BODY - 2*(WALL + TOL), W_BODY - 2*(WALL + TOL), lip + 0.1]);
      roof_details();
    }
    // lighten: hollow out the lip area so interior walls clear
    translate([WALL + 3, -W_BODY/2 + WALL + 3, H_EAVE - lip - 1])
      cube([L_BODY - 2*(WALL + 3), W_BODY - 2*(WALL + 3), lip]);
  }
}

module roof_details() {
  // exhaust stack (Enginator) and roof box near middle - both eras guessed for IRM
  if (ERA >= 1992) {
    translate([s(29), s(0,-10), H_CROWN - 1]) cylinder(d=s(0,9), h=s(1,8));
    translate([s(36), -s(1,9), H_CROWN - 2]) cube([s(7), s(3,6), s(1,4)]);
    // long stepped housing offset to side 1 (seen only from side 1)
    for (seg = [[10, 18, 14], [18, 34, 16], [34, 46, 14], [46, 60, 12]])
      translate([s(seg[0]), s(1,2), H_CROWN - s(0,10)])
        cube([s(seg[1] - seg[0]) - 0.6, s(3,0), s(0,seg[2]) + s(0,10)]);
    // antenna mast at A end
    translate([s(1,6), 0, H_CROWN - END_DROP]) cylinder(d=1.2, h=s(2,6));
  }
  // roof vents
  for (x=[6, 50, 61]) translate([s(x), 0, H_CROWN - 1]) cylinder(d=s(1,0), h=s(0,10));
}

// ---------------- floor and underframe ----------------
module floor_frame() {
  difference() {
    union() {
      // thin mounting plate glued under the body deck; everything below hangs from it
      translate([0, -W_BODY/2 + s(0,6), H_SILL - 1]) cube([L_BODY, W_BODY - s(1,0), 1.01]);
      // end platforms / buffer beams carry the coupler pockets
      for (x=[-(L_COUP - L_BODY)/2 + s(1,0), L_BODY])
        translate([x, -s(1,6), H_SILL - s(0,10)]) cube([(L_COUP - L_BODY)/2 - s(1,0) + 0.01, s(3,0), s(0,10)]);
      // centre sill, broken over the trucks so they can swing
      difference() {
        translate([0, -s(0,10), H_SILL - s(1,6)]) cube([L_BODY, s(1,8), s(1,6) + 0.1]);
        for (x = truck_x()) translate([x - TRUCK_CLEAR, -50, 0]) cube([2*TRUCK_CLEAR, 100, H_SILL - 1]);
      }
      // body bolsters (shallow, clear of the sideframe tops) with the pivot pad the truck bolster bears on
      for (x = truck_x()) {
        translate([x - s(1,0), -W_BODY/2 + s(1,0), H_SILL - s(0,4)]) cube([s(2,0), W_BODY - s(2,0), s(0,4) + 0.1]);
        translate([x, 0, bolster_pad_z()]) cylinder(d=14, h=H_SILL - bolster_pad_z() + 0.1);
      }
      underbody_gear();
    }
    for (x = truck_x()) translate([x, 0, 0]) cylinder(d=2.6, h=H_SILL - 0.6);  // M3 self-tap, blind
    // coupler pockets: open box at each end, 12 mm wide, 8 mm tall - adjust to your coupler
    for (e=[0,1]) translate([e ? L_BODY + s(0,2) : -(L_COUP - L_BODY)/2, -6, H_SILL - s(0,10) + 1])
      cube([(L_COUP - L_BODY)/2 + 1, 12, 8]);
  }
}

function truck_x() = [ (L_BODY - TRUCK_CTR)/2, (L_BODY + TRUCK_CTR)/2 ];
function bolster_pad_z() = PT_ZTOP;                // top of the truck bolster (library)
TRUCK_CLEAR = pt_truck_half(PT_WB) + 5;            // half length of the truck plus swing room

module underbody_gear() {
  // dynamometer unit in the centre sill at the A end (hydraulic cylinder)
  translate([s(0,4), 0, H_SILL - s(1,3)]) rotate([0,90,0]) cylinder(d=s(1,6), h=s(3,0));   // clear of the A-end truck
  // battery boxes (seen both sides, mid-car)
  for (side=[-1,1]) translate([s(30), side > 0 ? W_BODY/2 - s(2,6) : -W_BODY/2, H_SILL - s(2,3)])
    cube([s(8,0), s(2,6), s(2,3) + 0.1]);
  // Enginator / generator box (side 2) and air reservoirs (side 1)
  translate([s(41), -W_BODY/2 + s(0,6), H_SILL - s(2,6)]) cube([s(6,0), s(3,0), s(2,6) + 0.1]);
  for (x=[18, 41]) translate([s(x), W_BODY/2 - s(1,8), H_SILL - s(0,10) + 0.4])   // hung from the plate
    rotate([0,90,0]) cylinder(d=s(1,8), h=s(6,0));
}

// ---------------- interior (MPL floor plans A-850: 1934 and 1965/69 revisions) ----------------
// x in feet from the inside face of the A-end wall. Inside length 64'-6".
INSIDE = s(64,6);
WALLS_1992 = [17.5, 22.5, 30, 43, 51];   // instrument | lockers, heater | wash room | 2 sections | dining | kitchen
WALLS_1930 = [21.5, 34, 47];             // instrument | calculating room | sections | pantry, kitchen
AISLE = s(2,6);
module interior() {
  x0 = (L_BODY - INSIDE)/2;
  z0 = H_SILL + FLOOR;
  h  = H_EAVE - z0 - 4;
  wi = W_BODY/2 - WALL - TOL;
  new = ERA >= 1992;
  walls = new ? WALLS_1992 : WALLS_1930;
  berth = new ? [30.3, 42.7] : [34.3, 46.7];
  function X(ft) = x0 + s(ft);
  translate([x0, -wi, z0 - 0.01]) cube([INSIDE, 2*wi, 1.0]);              // base plate: one print
  for (xw = walls, sg=[-1,1]) translate([X(xw), sg > 0 ? AISLE/2 : -wi, z0]) cube([1.2, wi - AISLE/2, h]);
  // instrument room: dynamometer cabinet at the A end, recording table, chair
  translate([X(1.5), -s(2,0), z0]) cube([s(4,6), s(4,0), s(3,0)]);
  translate([X(7.5), -s(1,9), z0]) cube([s(3,0), s(3,6), s(2,6)]);
  translate([X(11.5), -s(0,9), z0]) cube([s(1,6), s(1,6), s(1,6)]);
  translate([X(1), wi - s(1,10), z0]) cube([s(new ? 15 : 19, 0), s(1,10), s(1,4)]);     // seat box / lockers along side 1
  // second room
  if (new) { translate([X(23), wi - s(1,8), z0]) cube([s(6,0), s(1,8), s(6,0)]);         // lockers
             translate([X(18), -wi, z0]) cube([s(3,6), s(2,6), s(3,0)]); }               // water heater, toilet
  else     { translate([X(23), wi - s(2,0), z0]) cube([s(9,0), s(2,0), s(2,6)]);         // calculating table
             translate([X(28), -wi, z0]) cube([s(5,0), s(3,0), s(3,0)]); }               // lavatory
  // sections: lower and upper berths both sides, end posts carry the uppers
  for (sg=[-1,1]) {
    for (z=[s(1,6), s(4,6)]) translate([X(berth[0]), sg > 0 ? AISLE/2 : -wi, z0 + z])
      cube([s(berth[1] - berth[0]), wi - AISLE/2, 1.5]);
    for (xb = [berth[0], berth[1] - 0.15]) translate([X(xb), sg > 0 ? AISLE/2 : -wi, z0])
      cube([1.5, wi - AISLE/2, s(4,6) + 1.5]);
  }
  // dining table (1965) and kitchen: range, counter and refrigerator at the B end
  if (new) { translate([X(43.6), -wi + s(0,6), z0 + s(2,4)]) cube([s(4,0), s(2,6), 1.5]);
             translate([X(45.6), -wi + s(1,6), z0]) cylinder(d=2, h=s(2,4)); }
  translate([X(new ? 52 : 50), wi - s(2,0), z0]) cube([s(new ? 7 : 9, 0), s(2,0), s(3,0)]);
  translate([X(61.5), -wi, z0]) cube([s(2,6), s(3,0), s(5,6)]);
}

// ---------------- trucks (shared RSW passenger truck library) ----------------
module trucks_view(wheels=true) for (x = truck_x()) translate([x, 0, 0]) pt_assembly(wheels);
module wheelsets_view() for (x = truck_x(), a = pt_axles(PT_WB)) translate([x + a, 0, PT_ZC]) rg_wheelset(rg_in(pt_wheel_in));

// ---------------- joiners for the section cuts ----------------
module joiners() {
  // 2 per cut for the body sides; glue inside the walls across each joint
  for (i=[0:2*(sections-1)-1]) translate([i*24, 0, 0]) cube([20, 30, 1.2]);
}

// ---------------- paint and lettering ----------------
ORANGE = [0.90, 0.42, 0.08];   // Milwaukee Road orange
BLACK  = [0.10, 0.10, 0.10];
RED    = [0.78, 0.10, 0.10];
WHITE  = [0.97, 0.97, 0.95];

// place 2D artwork on a face. f: "s1" (+y), "s2" (-y), "A" (x=0 end), "B" (x=L end).
// a = position along the face (x for sides, y for ends), zc = height. Extrudes from
// d0 (negative = into the wall) to d1 (outward).
module on_face(f, a, zc, d0, d1) {
  m = f == "s2" ? [a, -W_BODY/2, zc] : f == "s1" ? [a, W_BODY/2, zc] : f == "A" ? [0, a, zc] : [L_BODY, a, zc];
  rz = f == "s2" ? 0 : f == "s1" ? 180 : f == "A" ? -90 : 90;
  translate(m) rotate([90, 0, rz]) translate([0, 0, d0]) linear_extrude(d1 - d0) children();
}
// local 2D x of global position x on a side band centred at L/2
function lx(f, x) = f == "s2" ? x - L_BODY/2 : L_BODY/2 - x;
function tsize(cap_in) = s(0, cap_in) / 0.72;      // text() size for a cap height

LB_ITEMS = [ [32.9, LB_TEXT, 6], [5.5, CAR_NO, 6], [60.3, CAR_NO, 6] ];   // [x_ft, text, cap_in]
HERALDS  = [ 8.5, 61.0 ];                                                // x_ft of herald centres
H_HERALD = s(5,3);

module lb_text2d(f) for (it = LB_ITEMS)
  translate([lx(f, s(it[0])), 0]) text(it[1], size=tsize(it[2]), font=FONT_LB, halign="center", valign="center");

module herald2d(which) {           // which: "red" or "white"
  w = s(2,6); h = s(1,8);
  rotate(18) {
    if (which == "red") difference() { square([w, h], center=true); herald2d_white(w, h); }
    else herald2d_white(w, h);
  }
}
module herald2d_white(w, h) {
  difference() { offset(delta=-s(0,1.5)) square([w, h], center=true); offset(delta=-s(0,2.5)) square([w, h], center=true); }
  translate([0,  h*0.27]) resize([w*0.30, 0], auto=true) text("THE", font=FONT_H, halign="center", valign="center");
  translate([0,  0     ]) resize([w*0.78, 0], auto=true) text("MILWAUKEE", font=FONT_H, halign="center", valign="center");
  translate([0, -h*0.27]) resize([w*0.42, 0], auto=true) text("ROAD", font=FONT_H, halign="center", valign="center");
}

module end_panel2d() difference() {               // whole end below the roof, less the door
  translate([0, (H_SILL + FLOOR + H_EAVE)/2]) square([W_BODY, H_EAVE - H_SILL - FLOOR], center=true);
  translate([0, H_SILL + FLOOR + s(0,END_DOOR[1])/2]) square([s(0,END_DOOR[0]), s(0,END_DOOR[1])], center=true);
  translate([0, H_EAVE - s(1,4)]) text(CAR_NO, size=tsize(5), font=FONT_LB, halign="center", valign="center");
}

module paint_black(d0, d1) {
  zb = (H_LETTER + H_EAVE)/2;
  for (f = ["s1", "s2"]) {
    on_face(f, L_BODY/2, zb, d0, d1) difference() {        // letterboard band, lettering left orange
      square([L_BODY, H_EAVE - H_LETTER], center=true);
      lb_text2d(f);
    }
    on_face(f, s(34), s(5,0), d0, d1)                       // class lettering
      text(CLASS_TX, size=tsize(4), font=FONT_LB, halign="center", valign="center");
  }
  for (f = ["A", "B"]) on_face(f, 0, 0, d0, d1) end_panel2d();
}
module paint_red(d0, d1)   for (f = ["s1","s2"], x = HERALDS) on_face(f, s(x), H_HERALD, d0, d1) herald2d("red");
module paint_white(d0, d1) for (f = ["s1","s2"], x = HERALDS) on_face(f, s(x), H_HERALD, d0, d1) herald2d("white");
module paint_all(d0, d1) { paint_black(d0, d1); paint_red(d0, d1); paint_white(d0, d1); }

module car() {
  color(ORANGE) body_shell();
  if (LETTERING != "none") {
    d0 = LETTERING == "inlay" ? -INLAY : 0;
    color(BLACK) paint_black(d0, 0.03);
    color(RED)   paint_red(d0, 0.03);
    color(WHITE) paint_white(d0, 0.04);
  }
  color(BLACK) roof_shell();
  color([0.2,0.2,0.2]) floor_frame();
  if (INTERIOR) color("tan") interior();
  trucks_view();
  if (ERA >= 1992) {                                       // IRM-era lights
    translate([L_BODY + 0.5, 0, H_EAVE - s(0,8)]) rotate([0,90,0]) color("red") cylinder(d=s(0,12), h=s(0,6));
    for (x=[-0.5, L_BODY + 0.5]) translate([x, s(3,6), H_EAVE - s(1,4)]) color("white") sphere(d=s(0,7));
  }
}

// ---------------- groups for Blender (render_x5000.py) ----------------
module render_group(g) {
  if (g == "orange") body_shell();
  else if (g == "black") { paint_black(-0.01, 0.12); roof_shell(); }
  else if (g == "red")   paint_red(-0.01, 0.12);
  else if (g == "white") paint_white(-0.01, 0.16);
  else if (g == "frame") floor_frame();
  else if (g == "trucks") for (x = truck_x()) translate([x, 0, 0]) pt_frame_parts();
  else if (g == "wheels") wheelsets_view();
  else if (g == "inside") { if (INTERIOR) interior(); }
  else if (g == "glass") glass_panes();
  else if (g == "lens") { if (ERA >= 1992) {
    translate([L_BODY + 0.5, 0, H_EAVE - s(0,8)]) rotate([0,90,0]) cylinder(d=s(0,12), h=s(0,6));
    for (x=[-0.5, L_BODY + 0.5]) translate([x, s(3,6), H_EAVE - s(1,4)]) sphere(d=s(0,7)); } }
  else if (g == "rails") for (sg=[-1,1])
    translate([-250, sg*GAUGE/2 - 1, -8]) cube([L_BODY + 500, 2, 8]);       // code 332 rail, top at z = 0
}

module glass_panes() {
  for (side=[-1,1]) {
    for (o = concat(SIDE_COMMON, side > 0 ? SIDE1_EXTRA : SIDE2_EXTRA, BAYS ? [] : FLAT_1930))
      translate([s(o[0]), side*(W_BODY/2 - WALL/2), s(0,o[3]) + s(0,o[2])/2])
        window_hole(s(0,o[1]) + 0.6, s(0,o[2]) + 0.6, o[4], 0.4);
    if (BAYS) for (w = side > 0 ? BAY1_WIN : BAY2_WIN)
      translate([s(BAY[0]) + s(0,w[0]), side*(W_BODY/2 + BAY_OUT - WALL/2), s(0,BAY[3]) + s(0,BAY[2])/2])
        window_hole(s(0,w[1]) + 0.6, s(0,w[2]) + 0.6, w[3], 0.4);
  }
}

// ---------------- sections and print orientation ----------------
module cut(n, lo=-50, hi=400) {
  len = L_BODY / sections;
  a = n == 1 ? -50 : (n-1)*len;
  b = n == sections ? L_BODY + 50 : n*len;
  intersection() { children(); translate([a, -200, lo]) cube([b - a, 400, hi - lo]); }
}

module laid(z) translate([0, 0, -z]) children();    // drop a part to the bed

if (RENDER != "") translate([-L_BODY/2, 0, 0]) render_group(RENDER);
else if (part == "view") car();
else if (part == "body")  laid(H_SILL) if (section_no == 0) body_shell(); else cut(section_no) body_shell();
else if (part == "black") laid(H_SILL)   if (section_no == 0) paint_black(-INLAY, 0); else cut(section_no) paint_black(-INLAY, 0);
else if (part == "red")   laid(H_SILL)   if (section_no == 0) paint_red(-INLAY, 0);   else cut(section_no) paint_red(-INLAY, 0);
else if (part == "white") laid(H_SILL)   if (section_no == 0) paint_white(-INLAY, 0); else cut(section_no) paint_white(-INLAY, 0);
else if (part == "roof")  laid(H_EAVE - 3)     if (section_no == 0) roof_shell(); else cut(section_no) roof_shell();
else if (part == "floor") translate([0,0,H_SILL]) mirror([0,0,1])   // underframe, print upside down, plate on the bed
                            if (section_no == 0) floor_frame(); else cut(section_no) floor_frame();
else if (part == "interior") laid(H_SILL + FLOOR) if (section_no == 0) interior(); else cut(section_no) interior();
else if (part == "truck") pt_part(truck_part);    // print list: 4 sideframe, 2 bolster, 4 end_beam, 2 spring_plank, 8 wheel (+ coupon)
else if (part == "joiners") joiners();

echo(str("X5000 G v3: body ", L_BODY, " x ", W_BODY, " mm; over bays ", W_BODY + 2*BAY_OUT,
         " mm; rail to crown ", H_CROWN, " mm; section length ", L_BODY/sections, " mm"));
