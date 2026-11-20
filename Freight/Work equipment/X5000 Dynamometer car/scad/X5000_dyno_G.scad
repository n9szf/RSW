// Milwaukee Road X5000 Dynamometer Car - G scale (1:29)
// Rib Side Works - MODEL v4 (10/30/26): from the full-size Milwaukee Public Library scans
//   A-850 rev A floor plan (1934, original 1928 plan retraced) - ERA 1930
//   A-850 rev E floor plan (redrawn 6-9-65, new instruments 12-1-69) - ERA 1992
//   A-911 side frame (heights), B-519 roof frame (carline arch), B-500 end frame.
//   Window, door and post positions are the dimension chains of A-850, taken in inches
//   from the inside face of the A-end wall. Outside details for the IRM era from photos.
// Needs the shared RSW truck library (../../../../Trucks/library).
//
// Main sizes (A-850, both revisions; same as the 1930 Railway Age / RME articles):
//   60'-0" x 9'-1 7/8" inside, end walls 5 1/8", body 60'-10 1/4" over the end walls,
//   end platform castings 17 7/8" beyond each end wall = 63'-10" over castings,
//   pulling faces 6" beyond = 64'-10"; 9'-10 1/2" over side sills; truck centres 47'-1 1/4".
// Axes: x = along car from the outside of the A-end wall (0) to the B end; y = across
// (+y = side 1 = top of the A-850 plan); z = up from rail top. Prototype sizes go through s(ft, in).

/* [Part] */
part = "view";      // [view, body, black, alu, red, white, roof, floor, interior, truck, joiners]  floor = underframe; black/red/white = paint inlays
truck_part = "assembly";  // [assembly, sideframe, bolster, end_beam, spring_plank, wheel, bearing_coupon, section] when part = truck
section_no = 0;     // [0:4] 0 = whole part; 1-4 = print section of body/roof/floor/interior
sections = 4;       // long parts split into this many pieces (about 160 mm each)

/* [Era] */
ERA = 1992;         // [1930:As built (A-850 rev A), 1992:As preserved at IRM (A-850 rev E, 1965-69)]
INTERIOR = true;    // full interior
RIVETS = true;      // rivet rows on sill, belt rail and letterboard (slower to render)

/* [View] */
SHOW_ROOF = true;   // false = roof off, to look at the interior (view and Blender only; print parts are not affected)
ROOF_APART = false; // Blender fly-through: roof as its own piece (render_x5000_fly.py sets this)

/* [Blender] */
RENDER = "";        // set by render_x5000.py: one coloured group, in place, car centred on x = 0

/* [Paint and lettering - Milwaukee Road orange and black] */
// decal = plain orange body, lettering shown in the view only (use the decal sheet)
// inlay = body gets 0.4 mm pockets; print black/red/white parts with the body section
LETTERING = "decal";   // [decal, inlay, none]
INLAY = 0.4;
LB_TEXT  = "THE MILWAUKEE ROAD";
CAR_NO   = "X5000";
CLASS_TX = "DYNAMOMETER";
FONT_LB  = "Liberation Serif:style=Bold";
FONT_H   = "Liberation Sans:style=Bold";

/* [Scale] */
SCALE = 29;
function s(ft=0, inch=0) = (ft*12 + inch) * 25.4 / SCALE;

/* [Body - MPL drawings] */
END_W     = 5.125;                      // end wall, inches (A-850)
INSIDE_IN = 720;                        // 60'-0" inside
L_BODY    = s(0, INSIDE_IN + 2*END_W);  // 60'-10 1/4" over the end walls
L_FT      = (INSIDE_IN + 2*END_W) / 12;
CASTING   = s(0,17.875);                // end platform casting beyond each end wall
L_COUP    = L_BODY + 2*(CASTING + s(0,6));   // 64'-10" over pulling faces
W_BODY    = s(9,10.5);                  // over side sills
W_ROOF    = s(10,1.4375);               // carline over the ends (B-519)
BAY_OUT   = s(0,7.875);                 // bay projection (A-850 rev E)
H_SILL    = s(3,9);                     // rail to bottom of side sill (= truck library 3.75 ft)
H_SIDE    = s(7,8);                     // side frame, sill bottom to top of side plate (A-911)
H_BELT    = H_SILL + s(3,0);            // belt rail / window sills
H_EAVE    = H_SILL + H_SIDE;            // top of side
H_LETTER  = H_EAVE - s(1,9.25);         // bottom of the letterboard zone (A-911)
H_CROWN   = H_EAVE + s(2,1.5);          // carline rise 2'-1 1/2" (B-519)
R_TOP     = s(8,9.5625);                // carline top radius
R_CORNER  = s(0,13.875);                // carline corner radius
END_DROP  = s(0,6);                     // roof rounds down this much over each end
TRUCK_CTR = s(47,1.25);
// Trucks: the RSW passenger truck (Tom 10/26: "use the passenger car trucks").
// The car rode on Commonwealth cast-steel trucks with 33 in wheels in 1930, Nystrom later.
RG_SCALE = "G"; PT_STYLE = "1938"; PT_WB_FT = 8; PT_SPRUNG = true;
PT_RAIL_TO_SILL_FT = 3.75;
PT_PAD_H = 6;
include <../../../../Trucks/library/rsw_trucks.scad>
WB        = PT_WB;
WHEEL_D   = rg_in(36);

/* [Print] */
WALL   = 2.2;
FLOOR  = 3.0;
TOL    = 0.25;
GAUGE  = rg_gauge;
$fn = 40;

// ---------------- side openings (A-850 dimension chains) ----------------
// x in inches from the inside face of the A-end wall.
// window: [x0_in, x1_in, sill_in_above_rail, h_in, shape]  shape: 0 square, 1 round, 2 rounded corners
WS = 82; WH = 30;                       // standard sash: sill 6'-10" above rail, 30 in opening
function pair(a) = [[a + 7.5, a + 35.5, WS, WH, 0], [a + 39.5, a + 67.5, WS, WH, 0]];   // section bay of 6'-3"
WIN_1930_S1 = concat(
  [[71, 99, WS, WH, 0], [103, 131, WS, WH, 0],                  // observers' windows (lift out)
   [145, 173, WS, WH, 0],                                        // dynamometer room
   [264, 292, WS, WH, 0], [296, 324, WS, WH, 0],                 // office: four windows over the computing table
   [342, 370, WS, WH, 0], [374, 402, WS, WH, 0]],
  pair(408), pair(483),                                          // four Pullman sections
  [[585, 609, WS, WH, 0],                                        // toilet
   [623, 651, WS, WH, 0], [655, 683, WS, WH, 0]]);               // porter's room
WIN_1930_S2 = concat(
  [[71, 99, WS, WH, 0], [103, 131, WS, WH, 0],
   [264, 292, WS, WH, 0],                                        // lavatory (prism glass)
   [305.25, 333.25, WS, WH, 0], [358.375, 386.375, WS, WH, 0]],  // desk side of the office
  pair(408), pair(483),
  [[558, 586, WS, WH, 0],
   [612, 660, WS, WH, 0]]);                                      // kitchen, 4'-0"
WIN_1992_S1 = [[297.5, 325.5, WS, WH, 0],                        // office (photos: single window mid-car)
               [565.5, 593.5, WS, WH, 0], [597.5, 625.5, WS, WH, 0]];   // dining room pair
WIN_1992_S2 = [[565.5, 593.5, WS, WH, 0], [597.5, 625.5, WS, WH, 0]];
// side doors [x0_in, x1_in]; 1930 doors have a drop window, IRM doors a porthole (photos)
DOOR_1930 = [[197, 223], [154, 180]];   // [side 1, side 2]
DOOR_1992 = [[155, 181], [155, 181]];
DOOR_H    = 76;                         // door height above the floor, inches
// bay (rev E, "3 observation windows"): [x0, x_front0, x_front1, x1] in inches, per side
BAY_S1 = [58.5, 83.9, 121.9, 132.5];
BAY_S2 = [71, 91.25, 123.5, 131];
BAY_Z  = [76, 115];                     // bay bottom and top above rail (inches), under the letterboard
BAY1_WIN = [ [-8, 14, 14, 1], [9, 16, 20, 0] ];   // side 1 front: round + square (photos)
BAY2_WIN = [ [0, 26, 24, 2] ];                    // side 2 front: one big rounded
END_DOOR = [28, 72];                    // end doors [w_in, h_in]

BAYS  = ERA >= 1992;
function wins(side) = ERA >= 1992 ? (side > 0 ? WIN_1992_S1 : WIN_1992_S2)
                                  : (side > 0 ? WIN_1930_S1 : WIN_1930_S2);
function door(side) = (ERA >= 1992 ? DOOR_1992 : DOOR_1930)[side > 0 ? 0 : 1];
function bay(side)  = side > 0 ? BAY_S1 : BAY_S2;
function XI(i) = s(0, i + END_W);       // inside inches -> model x
function door_win(side) = let(d = door(side), c = (d[0] + d[1])/2)
  ERA >= 1992 ? [c - 7, c + 7, 84, 14, 1] : [c - 9, c + 9, 84, 24, 0];

// ---------------- helpers ----------------
module window_hole(w, h, shape, depth) {
  if (shape == 1) rotate([90,0,0]) cylinder(d=w, h=depth, center=true);
  else if (shape == 2) {
    r = min(w,h)*0.2;
    rotate([90,0,0]) linear_extrude(depth, center=true)
      offset(r) square([w-2*r, h-2*r], center=true);
  }
  else cube([w, depth, h], center=true);
}

module opening(o, side, depth) {       // o = [x0_in, x1_in, sill, h, shape]
  w = s(0, o[1] - o[0]); h = s(0, o[3]);
  translate([XI((o[0] + o[1])/2), side*W_BODY/2, s(0, o[2]) + h/2])
    window_hole(o[4] == 1 ? h : w, h, o[4], depth);
}

// B-519 carline: vertical sides, 13 7/8" corner radius, 8'-9 9/16" top radius (2D in y,z)
module roof_profile(w, z0, crown) {
  hw = w/2; rc = R_CORNER; R = R_TOP;
  zc = crown - R;                                  // centre of the top arc
  intersection() {
    offset(r=rc) intersection() {
      translate([0, zc]) circle(r=R - rc, $fn=240);
      translate([-(hw - rc), z0 - rc - 1]) square([2*(hw - rc), crown]);
    }
    translate([-hw - 1, z0]) square([w + 2, crown - z0 + 1]);
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
    translate([WALL, -W_BODY/2 + WALL, z0])
      cube([L_BODY - 2*WALL, W_BODY - 2*WALL, H_EAVE]);
    for (side=[-1,1]) {
      if (BAYS) bay_hollow(side);
      for (o = wins(side)) opening(o, side, WALL*3);
      opening(door_win(side), side, WALL*3);
      // door outline groove (door is closed; groove shows it)
      d = door(side);
      translate([XI((d[0] + d[1])/2), side*(W_BODY/2), z0 + s(0,DOOR_H)/2])
        difference() {
          cube([s(0, d[1] - d[0]) + 0.8, 1.0, s(0,DOOR_H) + 0.8], center=true);
          cube([s(0, d[1] - d[0]), 2, s(0,DOOR_H)], center=true);
        }
    }
    // end doors (open doorways, both ends)
    for (x=[0, L_BODY]) translate([x, 0, z0 + s(0,END_DOOR[1])/2])
      cube([WALL*3, s(0,END_DOOR[0]), s(0,END_DOOR[1])], center=true);
  }
  if (RIVETS) rivets();
}

// bay plan: trapezoid against the side, y measured outward from the side face
module bay_plan(side, inset=0) {
  b = bay(side);
  yb = inset > 0 ? -WALL - 1 : -WALL - 0.01;
  polygon([[XI(b[0]) + inset, yb], [XI(b[0]) + inset, 0], [XI(b[1]) + inset*0.4, BAY_OUT - inset],
           [XI(b[2]) - inset*0.4, BAY_OUT - inset], [XI(b[3]) - inset, 0], [XI(b[3]) - inset, yb]]);
}
module to_side(side) translate([0, side*W_BODY/2, 0]) { if (side > 0) children(); else mirror([0,1,0]) children(); }

module bay_box(side) {
  z1 = s(0,BAY_Z[0]); z2 = s(0,BAY_Z[1]);
  to_side(side) hull() {                                    // chamfered bottom for printing
    translate([0, 0, z1]) linear_extrude(z2 - z1) bay_plan(side);
    translate([0, 0, z1 - BAY_OUT]) linear_extrude(0.1) intersection() { bay_plan(side); translate([0, -WALL]) square([L_BODY, WALL]); }
  }
}

module bay_hollow(side) {
  b = bay(side);
  z1 = s(0,BAY_Z[0]); z2 = s(0,BAY_Z[1]); zm = (z1 + z2)/2;
  to_side(side) {
    translate([0, 0, z1 + 1.2]) linear_extrude(z2 - z1 - 2.4)
      bay_plan(side, WALL);
    // front windows
    for (w = side > 0 ? BAY1_WIN : BAY2_WIN)
      translate([XI((b[1] + b[2])/2) + s(0,w[0]), BAY_OUT, zm])
        window_hole(s(0,w[1]), s(0,w[2]), w[3], WALL*3);
    // windows in the two angled faces (look fore and aft along the train)
    for (f = [[b[0], b[1]], [b[3], b[2]]]) {
      xa = XI(f[0]); xb = XI(f[1]); ang = atan2(BAY_OUT, xb - xa);
      translate([(xa + xb)/2, BAY_OUT/2, zm]) rotate([0, 0, ang])
        cube([norm([xb - xa, BAY_OUT])*0.55, WALL*3, s(0,22)], center=true);
    }
  }
}

function in_bay(x) = BAYS && min([for (side=[-1,1]) let(b = bay(side)) (x > XI(b[0]) - 1 && x < XI(b[3]) + 1) ? 0 : 1]) == 0;
function in_door(x) = min([for (side=[-1,1]) let(d = door(side)) (x > XI(d[0]) - 1.5 && x < XI(d[1]) + 1.5) ? 0 : 1]) == 0;

module rivets() {
  sp = s(0,6);
  for (side=[-1,1], row=[[H_SILL + FLOOR + 1.2, 0], [H_SILL + FLOOR + 2.3, 0.5], [H_BELT - 0.9, 0], [H_BELT - 1.8, 0.5], [H_BELT - 2.7, 0], [H_LETTER - 0.8, 0]])
    let(zr = row[0])
    for (x=[2 + row[1]*sp:sp:L_BODY-2])
      if ((!in_bay(x) || zr < s(0,BAY_Z[0]) - BAY_OUT)
          && !in_door(x)
          && abs(x - round(x / (L_BODY/sections)) * (L_BODY/sections)) > 1    // clear of section cuts
          && min([for (h = HERALDS) abs(x - s(h))]) > s(1,8))                // clear of the heralds
        translate([x, side*(W_BODY/2 - 0.25), zr]) rotate([-side*90,0,0])
          cylinder(d=0.6, h=0.6, $fn=6);          // 0.35 mm proud, 0.25 mm buried
}

// ---------------- roof (solid, flat underside, prints flat side down) ----------------
module roof_shell() {
  lip = 3;
  e = s(1,6);                                 // length of the rounded end hood
  difference() {
    union() {
      hull() {
        translate([e, 0, 0]) rotate([90,0,90]) linear_extrude(L_BODY - 2*e)
          roof_profile(W_ROOF, H_EAVE, H_CROWN);
        for (x=[0, L_BODY - 0.1]) translate([x, 0, 0]) rotate([90,0,90]) linear_extrude(0.1)
          roof_profile(W_BODY - 2, H_EAVE, H_CROWN - END_DROP);
      }
      translate([WALL + TOL, -W_BODY/2 + WALL + TOL, H_EAVE - lip])
        cube([L_BODY - 2*(WALL + TOL), W_BODY - 2*(WALL + TOL), lip + 0.1]);
      roof_details();
    }
    translate([WALL + 3, -W_BODY/2 + WALL + 3, H_EAVE - lip - 1])
      cube([L_BODY - 2*(WALL + 3), W_BODY - 2*(WALL + 3), lip]);
  }
}

module roof_details() {
  if (ERA >= 1992) {                          // IRM era (photos), positions scaled to the drawing length
    translate([s(26.8), s(0,-10), H_CROWN - 1]) cylinder(d=s(0,9), h=s(1,8));            // Enginator exhaust
    translate([s(33.3), -s(1,9), H_CROWN - 2]) cube([s(6,6), s(3,6), s(1,4)]);            // roof box
    for (seg = [[9.2, 16.6, 14], [16.6, 31.4, 16], [31.4, 42.5, 14], [42.5, 55.5, 12]])  // stepped housing, side 1
      translate([s(seg[0]), s(1,2), H_CROWN - s(0,10)])
        cube([s(seg[1] - seg[0]) - 0.6, s(3,0), s(0,seg[2]) + s(0,10)]);
    translate([s(1,6), 0, H_CROWN - END_DROP]) cylinder(d=1.2, h=s(2,6));                // antenna mast
  } else {                                    // 1930: running board (B-519 brackets) and kitchen smoke jack
    translate([s(1,0), -s(0,10), H_CROWN - 1]) cube([L_BODY - s(2,0), s(1,8), s(0,4) + 1]);
    translate([L_BODY - s(4,0), s(2,6), H_CROWN - s(0,6)]) cylinder(d=s(0,10), h=s(1,8));
  }
  for (x=[6, 46, 57]) translate([s(x), 0, H_CROWN - 1]) cylinder(d=s(1,0), h=s(0,10));    // roof vents
}

// ---------------- floor and underframe ----------------
module floor_frame() {
  plat = (L_COUP - L_BODY)/2;                 // casting + coupler, each end
  difference() {
    union() {
      translate([0, -W_BODY/2 + s(0,6), H_SILL - 1]) cube([L_BODY, W_BODY - s(1,0), 1.01]);
      // end platform castings (17 7/8" beyond the end walls) carry the coupler pockets
      for (x=[-CASTING, L_BODY]) translate([x, -s(2,6), H_SILL - s(0,10)]) cube([CASTING + 0.01, s(5,0), s(0,10)]);
      // centre sill, broken over the trucks so they can swing
      difference() {
        translate([0, -s(0,10), H_SILL - s(1,6)]) cube([L_BODY, s(1,8), s(1,6) + 0.1]);
        for (x = truck_x()) translate([x - TRUCK_CLEAR, -50, 0]) cube([2*TRUCK_CLEAR, 100, H_SILL - 1]);
      }
      for (x = truck_x()) {
        translate([x - s(1,0), -W_BODY/2 + s(1,0), H_SILL - s(0,4)]) cube([s(2,0), W_BODY - s(2,0), s(0,4) + 0.1]);
        translate([x, 0, bolster_pad_z()]) cylinder(d=14, h=H_SILL - bolster_pad_z() + 0.1);
      }
      underbody_gear();
    }
    for (x = truck_x()) translate([x, 0, 0]) cylinder(d=2.6, h=H_SILL - 0.6);  // M3 self-tap, blind
    // coupler pockets: open box at each end, 12 mm wide, 8 mm tall - adjust to your coupler
    for (e=[0,1]) translate([e ? L_BODY + CASTING - s(1,0) : -CASTING - 1, -6, H_SILL - s(0,10) + 1])
      cube([s(1,0) + 1, 12, 8]);
  }
}

function truck_x() = [ (L_BODY - TRUCK_CTR)/2, (L_BODY + TRUCK_CTR)/2 ];   // 6'-10 1/2" from the end walls
function bolster_pad_z() = PT_ZTOP;
TRUCK_CLEAR = pt_truck_half(PT_WB) + 5;

module underbody_gear() {
  // draft gear yoke to the weighing head, under the A-end platform (the head itself is inside the car)
  translate([-s(0,10), 0, H_SILL - s(0,12)]) rotate([0,90,0]) cylinder(d=s(1,0), h=s(1,8));
  // battery boxes (two 32 V sets in one box, both sides mid-car)
  for (side=[-1,1]) translate([s(26), side > 0 ? W_BODY/2 - s(2,6) : -W_BODY/2, H_SILL - s(2,3)])
    cube([s(8,0), s(2,6), s(2,3) + 0.1]);
  // generator box (side 2) and air reservoirs (side 1)
  translate([s(37), -W_BODY/2 + s(0,6), H_SILL - s(2,6)]) cube([s(6,0), s(3,0), s(2,6) + 0.1]);
  for (x=[17, 37]) translate([s(x), W_BODY/2 - s(1,8), H_SILL - s(0,10) + 0.4])
    rotate([0,90,0]) cylinder(d=s(1,8), h=s(6,0));
}

// ---------------- interior (A-850: rev A 1934 and rev E 1965/69) ----------------
// x in feet from the inside face of the A-end wall. Inside length 60'-0".
INSIDE = s(0, INSIDE_IN);
WALLS_1992 = [17.42, 20.42, 34.0, 46.5, 52.75];   // dynamometer | switch locker, heater | office | 2 sections | dining | kitchen
WALLS_1930 = [21.5, 34.0, 46.5, 48.33];           // dynamometer | office | 4 sections | toilet, porter | kitchen
AISLE = s(2,6);
// sel = "" for everything; for Blender one material at a time: wood (mahogany), oak, leather, iron, monel
module interior(sel="") {
  if (ERA >= 1992) interior_1992(sel);
  else interior_1930(sel);
}
// ---------------- IRM-era interior (A-850 rev E 1965/69 rooms; Tom's photos at IRM, 11/04/26) ----------------
// Materials (Blender groups): wood = cream painted lockers and partitions, oak = pale green desk and cabinets,
// leather = brown leatherette, fabric = green (berth curtains and mattresses, chair seats), iron = machinery and
// the recorder rack, monel = stainless and porcelain, panel = the white gauge panel, gold = harvest-gold refrigerator.
module interior_1992(sel="") {
  x0 = s(0, END_W);
  z0 = H_SILL + FLOOR;
  h  = H_EAVE - z0 - 4;
  wi = W_BODY/2 - WALL - TOL;
  ya = s(0,15);                                     // aisle edge (aisle 2'-6")
  function X(ft) = x0 + s(ft);
  module M(tag) if (sel == "" || sel == tag) children();
  module wb(xa, xb, side, d, zb, hh) translate([X(xa), side > 0 ? wi - s(0,d) : -wi, z0 + s(0,zb)])
    cube([s(xb - xa), s(0,d), hh == "full" ? h - s(0,zb) : s(0,hh)]);
  module cb(xa, xb, y0, y1, zb, hh) translate([X(xa), s(0,y0), z0 + s(0,zb)]) cube([s(xb - xa), s(0, y1 - y0), s(0,hh)]);
  module back(xa, xb, side, zt) wb(xa, xb, side, 1, 0, zt);       // back board to the floor: holds wall-hung items in one print
  module chair(xc, yc, rot=0, tag="fabric") {        // chrome-frame chair, seat and back
    translate([X(xc), s(0,yc), z0]) rotate(rot) {
      M("monel") for (a = [-1,1], b = [-1,1]) translate([a*s(0,7), b*s(0,7), 0]) cylinder(d=0.9, h=s(0,17), $fn=8);
      M(tag) { translate([-s(0,9), -s(0,9), s(0,17)]) cube([s(0,18), s(0,18), s(0,3)]);
               translate([s(0,7), -s(0,9), s(0,17)]) cube([s(0,2), s(0,18), s(0,16)]); }
    }
  }

  M("wood") translate([x0, -wi, z0 - 0.01]) cube([INSIDE, 2*wi, 1.0]);           // base plate: one print
  M("wood") for (xw = [17.42, 20.42, 34.0, 46.5, 52.75], sg = [-1,1]) translate([X(xw) - 0.6, sg > 0 ? ya : -wi, z0]) cube([1.2, wi - ya, h]);

  // ---- instrument (dynamometer) room 0 - 17.42 ft
  M("iron") {
    cb(1.4, 5.6, -22, 22, 0, 20);                                     // dynamometer weighing head
    translate([X(3.5), 0, z0 + s(0,20)]) rotate([0,90,0]) cylinder(d=s(0,16), h=s(3,0), center=true);
    for (v = [2.2, 4.8]) translate([X(v), s(0,-14), z0 + s(0,20)]) cylinder(d=s(0,3), h=s(0,10));   // valves
    wb(0.05, 1.0, 1, 30, 50, 22); back(0.05, 1.0, 1, 50);             // 600 V DC meters and breaker boxes on the A-end wall
    wb(12.6, 16.8, 1, 26, 0, 30);                                     // Brush amplifier rack (below the gauge panel)
    wb(12.6, 16.8, 1, 26, 30, 2);
  }
  M("panel") wb(12.6, 16.8, 1, 8, 32, 40);                            // white gauge panel: drawbar pull, speed, brakes, lights
  M("oak") {
    wb(7.0, 12.4, 1, 30, 0, 26);                                      // recorder desk, slanted top
    translate([X(7.0), wi - s(0,30), z0 + s(0,26)]) rotate([-12,0,0]) cube([s(5.4), s(0,31), s(0,2)]);
    wb(0.05, 4.2, -1, 18, 0, "full");                                 // lockers, side 2 at the A end
  }
  chair(9.6, 12, 270, "leather");                                    // operator's chair at the recorder desk
  M("wood") cb(5.9, 9.0, -50, -26, 0, 8);                             // raised observer's platform in the side-2 bay
  chair(7.4, -36, 90, "leather");                                    // observer's chair, looking out of the bay
  chair(1.3, 30, 90, "leather");                                      // observer's chair at the A end

  // ---- switch locker (side 1) and heater room (side 2) 17.42 - 20.42
  M("iron") wb(17.5, 20.35, 1, 20, 0, "full");                        // switch locker: Enginator panel, breakers
  M("wood") translate([X(17.42), -ya - 1.2, z0]) cube([s(3.0), 1.2, h]);   // heater room wall on the aisle (closed door)
  M("iron") translate([X(18.9), -wi + s(0,14), z0]) cylinder(d=s(0,20), h=s(0,40));          // oil-fired boiler
  M("monel") translate([X(18.9), -wi + s(0,14), z0]) cylinder(d=s(0,7), h=h);              // galvanized flue

  // ---- office 20.42 - 34.0: green desk with pigeonholes under the side-1 window; wash room on side 2
  M("oak") {
    wb(20.5, 28.5, 1, 26, 0, 30);                                     // desk
    wb(28.5, 30.2, 1, 22, 0, 30); wb(28.5, 30.2, 1, 12, 30, 20); back(28.5, 30.2, 1, 30);   // pigeonholes beside the window
  }
  M("wood") { wb(20.5, 28.5, 1, 14, 66, "full"); back(20.5, 28.5, 1, 66);   // lockers over the desk
              wb(30.2, 33.95, 1, 22, 0, "full"); }                    // full-height lockers
  chair(24.2, 13, 270, "leather");
  M("wood") {                                                        // wash room: wall on the aisle with a door
    difference() { translate([X(20.42), -ya - 1.2, z0]) cube([s(5.6), 1.2, h]);
                   translate([X(22.6), -ya - 2, z0]) cube([s(2.0), 3, s(0,72)]); }
    translate([X(26.0), -wi, z0]) cube([1.2, wi - ya, h]);
    wb(26.1, 33.95, -1, 22, 0, "full");                               // lockers, side 2
  }
  M("monel") for (xb = [21.0, 25.2]) {                                // two corner basins, on pedestals
    translate([X(xb), -wi + s(0,9), z0 + s(0,28)]) cylinder(d=s(0,16), h=s(0,5));
    translate([X(xb), -wi + s(0,6), z0]) cylinder(d=s(0,4), h=s(0,28));
  }

  // ---- four sections 34.0 - 46.5: brown leatherette seats, green berth curtains and striped mattresses
  for (a = [34.0, 40.25], sg = [-1,1]) {
    M("leather") { wb(a + 0.1, a + 2.0, sg, 40, 0, 18); wb(a + 0.1, a + 0.6, sg, 40, 18, 22);
                   wb(a + 4.25, a + 6.15, sg, 40, 0, 18); wb(a + 5.65, a + 6.15, sg, 40, 18, 22); }
    M("fabric") wb(a + 0.6, a + 5.65, sg, 38, 18, 4);                 // made-up lower berth: green striped mattress
    M("wood") { wb(a + 0.1, a + 6.15, sg, 24, 62, 16); back(a + 0.1, a + 6.15, sg, 62); }   // upper berth, closed
    M("fabric") wb(a + 0.1, a + 6.15, sg, 41, 22, 1.0);               // green curtain, pulled to one side
  }

  // ---- dining room 46.5 - 52.75: a table for four each side under the window pairs, lockers above
  for (sg = [-1,1]) {
    M("monel") wb(48.2, 50.9, sg, 30, 28, 1.5);                       // speckled formica top, chrome edge
    M("monel") translate([X(49.55), sg*(wi - s(0,15)), z0]) cylinder(d=s(0,3), h=s(0,28));
    chair(47.6, sg*(wi/s(0,1) - 15), 180);
    chair(51.5, sg*(wi/s(0,1) - 15), 0);
    M("wood") { wb(46.6, 52.65, sg, 14, 68, "full"); back(46.6, 52.65, sg, 68); }   // lockers over the windows
  }

  // ---- kitchen 52.75 - 60: refrigerator, sink, range and hood, water heater, overhead water tanks
  M("gold") wb(52.85, 55.3, -1, 30, 0, 64);                           // harvest-gold Westinghouse refrigerator
  M("wood") { wb(55.4, 58.4, -1, 24, 0, 34); }                        // cream sink cabinet
  M("monel") { wb(55.4, 58.4, -1, 24, 34, 1.5); translate([X(56.9), -wi + s(0,12), z0 + s(0,30)]) cylinder(d=s(0,13), h=s(0,5.6)); }
  M("iron") wb(55.0, 57.6, 1, 26, 0, 36);                             // gas range with griddle
  M("monel") { wb(55.0, 57.6, 1, 20, 62, 12); back(55.0, 57.6, 1, 62); }     // Broan stainless hood
  M("wood") { wb(52.85, 55.0, 1, 18, 0, "full"); wb(57.6, 58.2, 1, 24, 0, 36); }
  M("monel") translate([X(59.0), wi - s(0,11), z0]) cylinder(d=s(0,20), h=s(5,0));           // water heater
  M("wood") { wb(58.45, 59.95, -1, 18, 0, "full"); }                  // lockers in the side-2 corner
  M("gold") for (sg = [-1,1]) translate([X(57.0), sg*(wi - s(0,9)), z0 + s(0,82)]) rotate([0,90,0]) cylinder(d=s(0,16), h=s(3,0));   // two 55 gal copper water tanks
  M("wood") for (sg = [-1,1]) wb(57.9, 58.05, sg, 18, 0, "full");     // tank hanger boards
}

// ---------------- 1930 interior (A-850 rev A floor plan; Railway Age / RME, June-July 1930) ----------------
// Dynamometer room 21'-6": weighing head, chronograph table, oak lockers floor to ceiling, observers' seats and
// drop-leaf tables, work bench with the Kohler plant under it, Baker heater. Office 12'-6": 13 ft computing
// table under four windows, flat-top desk and glass bookcases, lavatory. Four Pullman sections (brown imitation
// leather seats, removable tables, upper berths closed). Toilet, porter's room, kitchen with coal range,
// sink, roof-iced refrigerator. Mahogany stain in the office, sections and porter's room; oak in the dynamometer room.
module interior_1930(sel="") {
  x0 = s(0, END_W);
  z0 = H_SILL + FLOOR;
  h  = H_EAVE - z0 - 4;
  wi = W_BODY/2 - WALL - TOL;
  ya = s(0,15);                                     // aisle edge (aisle 2'-6")
  function X(ft) = x0 + s(ft);
  module M(tag) if (sel == "" || sel == tag) children();
  // box against a side wall: x in feet, depth / z / height in inches; side +1 = side 1
  module wb(xa, xb, side, d, zb, hh) translate([X(xa), side > 0 ? wi - s(0,d) : -wi, z0 + s(0,zb)])
    cube([s(xb - xa), s(0,d), hh == "full" ? h - s(0,zb) : s(0,hh)]);
  // box across the car: y in inches from the centre line
  module cb(xa, xb, y0, y1, zb, hh) translate([X(xa), s(0,y0), z0 + s(0,zb)]) cube([s(xb - xa), s(0, y1 - y0), s(0,hh)]);
  module seat(xa, xb, side, d=22, back_at=0) {      // leather seat box, back against the wall or a bay end
    M("leather") { wb(xa, xb, side, d, 0, 18); wb(xa, xb, side, 5, 18, 16); }
  }

  M("wood") translate([x0, -wi, z0 - 0.01]) cube([INSIDE, 2*wi, 1.0]);           // base plate: one print
  // partitions (full height, aisle open)
  M("wood") for (xw = [21.5, 34.0, 40.25, 46.5], sg = [-1,1]) translate([X(xw) - 0.6, sg > 0 ? ya : -wi, z0]) cube([1.2, wi - ya, h]);

  // ---- dynamometer room (0 - 21.5 ft)
  M("oak") {
    wb(0.05, 6.0, 1, 18, 0, "full");                                  // oak lockers, side 1 (gauges, overalls, recorders)
    wb(0.05, 4.3, -1, 19, 0, "full");                                 // oak lockers, side 2 (paper rolls, lanterns, flags)
    cb(0.05, 1.4, -40, 40, 76, h/s(0,1) - 76);                         // lockers over the sliding end door
    cb(7.0, 12.5, -20, 20, 28, 2);                                    // chronograph table top
    cb(7.2, 7.8, -18, 18, 0, 28); cb(11.7, 12.3, -18, 18, 0, 28);     // table pedestals
    cb(7.0, 7.3, -16, 16, 30, 14);                                    // gauge board at the front of the table
    wb(7.7, 9.5, 1, 14, 0, 2); wb(7.7, 9.5, 1, 14, 27, 2);            // drop-leaf table, side 1 (shelf + leg panel)
    wb(8.5, 8.7, 1, 12, 0, 28);
    wb(4.4, 8.3, -1, 22, 32, 2); wb(4.4, 4.7, -1, 22, 0, 32); wb(8.0, 8.3, -1, 22, 0, 32);   // work bench, side 2
    wb(8.6, 9.6, -1, 14, 0, 2); wb(8.6, 9.6, -1, 14, 27, 2); wb(9.0, 9.2, -1, 12, 0, 28);    // drop-leaf table, side 2
    wb(19.4, 21.5, 1, 39, 0, "full");                                 // clothes locker
  }
  M("iron") {
    cb(1.9, 5.9, -22, 22, 0, 22);                                     // weighing head (dynamometer) on its bed
    translate([X(3.9), 0, z0 + s(0,22)]) rotate([0,90,0]) cylinder(d=s(0,20), h=s(3,0), center=true);   // diaphragm cylinder
    translate([X(9.0), 0, z0 + s(0,32)]) rotate([90,0,0]) cylinder(d=s(0,5), h=s(0,22), center=true);   // 22 in paper roll
    cb(12.6, 13.6, 8, 20, 0, 24);                                     // speed-change gear box
    wb(4.7, 6.7, -1, 18, 0, 24);                                      // Kohler lighting plant under the bench
    translate([X(18.6), -wi + s(0,17), z0]) cylinder(d=s(0,30), h=s(5,0));                // Baker heater
    translate([X(18.6), -wi + s(0,17), z0]) cylinder(d=s(0,6), h=h);                      // its flue
    wb(17.0, 18.0, -1, 13, 0, 30);                                    // coal box
  }
  seat(6.3, 7.6, 1); seat(9.6, 10.9, 1); seat(9.8, 11.1, -1);         // observers' and visitors' seats
  seat(11.6, 16.0, 1, 24); seat(12.2, 16.6, -1, 22);                  // long seats, boxes below

  // ---- office (21.5 - 34.0 ft)
  M("wood") {
    wb(22.0, 33.6, 1, 30, 28, 2);                                     // computing table 30 in x 13 ft 9 in
    wb(22.0, 24.2, 1, 30, 0, 28); wb(31.4, 33.6, 1, 30, 0, 28);       // drawers and lockers below each end
    wb(21.5, 29.0, 1, 17, 62, "full");                                // four lockers above the windows
    wb(29.0, 34.0, 1, 30, 62, 12);                                    // emergency upper berth over the table
    wb(33.6, 34.0, 1, 30, 0, "full");                                 // end post carrying it
    // side 2: lavatory enclosure, then the flat-top desk between two glass bookcases
    // lavatory wall on the aisle, with its door
    difference() { translate([X(21.5), -ya - 1.2, z0]) cube([s(7.2), 1.2, h]); translate([X(26.6), -ya - 2, z0]) cube([s(2.0), 3, s(0,72)]); }
    translate([X(28.6), -wi, z0]) cube([1.2, wi - ya, h]);            // lavatory end wall
    wb(29.6, 33.0, -1, 36, 28, 2); wb(29.6, 30.8, -1, 36, 0, 28); wb(31.8, 33.0, -1, 36, 0, 28);   // flat-top desk
    wb(28.7, 29.6, -1, 11, 0, 84); wb(33.0, 34.0, -1, 11, 0, 84);     // bookcases (glass doors)
    wb(28.7, 34.0, -1, 11, 72, 12);                                   // bookcase over the windows
    wb(21.6, 25.4, -1, 18, 0, 30);                                    // washstand cabinet
  }
  M("leather") { cb(24.4, 25.6, 14, 30, 0, 18); cb(24.4, 24.8, 14, 30, 18, 16); cb(27.6, 28.8, 14, 30, 0, 18); cb(27.6, 28.0, 14, 30, 18, 16); }   // two chairs
  M("monel") { wb(22.0, 23.2, -1, 18, 30, 4); wb(24.0, 25.2, -1, 18, 30, 4); translate([X(27.4), -wi + s(0,14), z0]) cylinder(d=s(0,16), h=s(0,16)); }   // washstands, hopper

  // ---- four Pullman sections (34.0 - 46.5 ft): facing seats, removable table, upper berth closed
  for (a = [34.0, 40.25], sg = [-1,1]) {
    seat(a, a + 2.0, sg, 41); seat(a + 4.25, a + 6.25, sg, 41);
    M("leather") { wb(a, a + 0.5, sg, 41, 18, 22); wb(a + 5.75, a + 6.25, sg, 41, 18, 22); }   // high seat backs
    M("wood") {
      wb(a + 2.2, a + 4.05, sg, 24, 28, 2); wb(a + 3.0, a + 3.25, sg, 20, 0, 28);              // table and leg
      wb(a, a + 6.25, sg, 22, 62, 18);                                                         // upper berth, closed
    }
  }

  // ---- lockers 46.5 - 48.33, toilet and porter's room (side 1), kitchen (side 2 and the B end)
  M("wood") {
    wb(46.5, 48.33, 1, 21, 0, "full"); wb(46.5, 48.33, -1, 21, 0, "full");
    difference() {                                                    // toilet and porter's room wall on the aisle
      translate([X(48.33), ya, z0]) cube([s(9.0), 1.2, h]);
      for (d = [[49.3, 51.1], [52.2, 54.0]]) translate([X(d[0]), ya - 1, z0]) cube([s(d[1] - d[0]), 3.5, s(0,72)]);
    }
    translate([X(51.3), ya, z0]) cube([1.2, wi - ya, h]);             // toilet | porter's room
    translate([X(57.33), ya, z0]) cube([1.2, wi - ya, h]);            // porter's room | refrigerator
    wb(51.4, 57.3, 1, 24, 0, 18); wb(51.4, 57.3, 1, 15, 60, "full");  // porter's berth, lockers above
    wb(48.4, 50.3, -1, 21, 0, "full");                                // provision locker
    wb(50.4, 55.6, -1, 24, 0, 36); wb(50.25, 55.6, -1, 14, 60, "full");   // shelves, coal box, sink counter; lockers above
  }
  M("monel") {
    wb(53.0, 54.8, -1, 20, 36, 1);                                    // Monel-metal sink top
    wb(57.4, 60.0, 1, 30, 0, "full");                                 // refrigerator, iced from the roof
    translate([X(49.6), wi - s(0,14), z0]) cylinder(d=s(0,16), h=s(0,16));   // toilet hopper
    wb(50.3, 51.35, 1, 16, 30, 4);                                    // folding washstand (on the partition)
  }
  M("iron") {
    wb(55.8, 59.9, -1, 27, 0, 32);                                    // coal range
    translate([X(59.3), -wi + s(0,8), z0]) cylinder(d=s(0,6), h=h);   // smoke pipe to the roof jack
  }
}

// ---------------- trucks (shared RSW passenger truck library) ----------------
module trucks_view(wheels=true) for (x = truck_x()) translate([x, 0, 0]) pt_assembly(wheels);
module wheelsets_view() for (x = truck_x(), a = pt_axles(PT_WB)) translate([x + a, 0, PT_ZC]) rg_wheelset(rg_in(pt_wheel_in));

// ---------------- joiners for the section cuts ----------------
module joiners() {
  for (i=[0:2*(sections-1)-1]) translate([i*24, 0, 0]) cube([20, 30, 1.2]);
}

// ---------------- paint and lettering ----------------
ORANGE = [0.90, 0.42, 0.08];
BLACK  = [0.10, 0.10, 0.10];
RED    = [0.78, 0.10, 0.10];
WHITE  = [0.97, 0.97, 0.95];

module on_face(f, a, zc, d0, d1) {
  m = f == "s2" ? [a, -W_BODY/2, zc] : f == "s1" ? [a, W_BODY/2, zc] : f == "A" ? [0, a, zc] : [L_BODY, a, zc];
  rz = f == "s2" ? 0 : f == "s1" ? 180 : f == "A" ? -90 : 90;
  translate(m) rotate([90, 0, rz]) translate([0, 0, d0]) linear_extrude(d1 - d0) children();
}
function lx(f, x) = f == "s2" ? x - L_BODY/2 : L_BODY/2 - x;
function tsize(cap_in) = s(0, cap_in) / 0.72;

LB_ITEMS = [ [L_FT/2, LB_TEXT, 6], [5.0, CAR_NO, 6], [L_FT - 5.0, CAR_NO, 6] ];   // [x_ft, text, cap_in]
// IRM era: heralds near each end below the windows. 1930 (builder's photo): one herald a side in the window
// band just past the side door.
HERALDS  = ERA >= 1992 ? [ 3.9, L_FT - 4.5 ] : [ 20.7 ];
H_HERALD = ERA >= 1992 ? s(4,11) : s(8,1);
HER_ANG  = ERA >= 1992 ? 28 : 18;              // IRM: enamel plates tilted about 28 degrees (photos)
HER_WH   = ERA >= 1992 ? [s(2,3), s(1,5)] : [s(2,6), s(1,8)];
// IRM era lettering (Tom's photos 11/04/26): letterboard black with only X5000 in white Roman; DYNAMOMETER in
// red, widely spaced plain capitals, low on the side sheet; red stencils near the ends.
DYN_1992 = L_FT*0.44;                           // centre of DYNAMOMETER, ft from the A end
FONT_S   = "Liberation Sans:style=Bold";
// [x_ft, z_in above rail, cap_in, side ("s1", "s2" or "both"), text]
STENCILS_1992 = [
  [1.5, 50, 4,   "both", "FRONT"],
  [1.6, 71, 1.6, "both", "A END 73000"], [1.6, 68.5, 1.6, "both", "B END 82300"], [1.6, 66, 1.6, "both", "TOTAL 155300"],
  [L_FT - 8.0, 54, 2.2, "s1", "WATER FILL"], [L_FT - 8.0, 51, 2.2, "s1", "OTHER SIDE"],
  [16.6, 58, 1.8, "s2", "HEAT OIL FILLER"], [16.6, 55.5, 1.8, "s2", "DIESEL FUEL ONLY"],
  [16.6, 76, 1.8, "s2", "HEAT OIL GAUGE"],
  [11.6, 56, 2.2, "s2", "BRK RELEASE"], [11.6, 53, 2.2, "s2", "OTHER SIDE"]];
// 1930 paint (Railway Age / RME, 1930): black, two 1 1/2 in aluminum stripes, aluminum lettering,
// like the tenders of the new passenger engines. Lettering placed from the builder's photo.
LB_1930  = [ [33.0, LB_TEXT, 6], [8.5, "C M St P & P", 5] ];
STRIPES_1930 = [ s(0,79.5), s(0,114.25) ];   // centre heights: under the window sills and over the windows

module lb_text2d(f) for (it = LB_ITEMS)
  translate([lx(f, s(it[0])), 0]) text(it[1], size=tsize(it[2]), font=FONT_LB, halign="center", valign="center");

module herald2d(which) {
  w = HER_WH[0]; h = HER_WH[1];
  rotate(HER_ANG) {
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

module end_panel2d() difference() {
  if (ERA >= 1992) translate([0, (H_SILL - s(0,10) + H_EAVE)/2]) square([W_BODY - 2*s(0,5), H_EAVE - H_SILL + s(0,10)], center=true);   // IRM: whole end black, orange corner posts
  else translate([0, (H_SILL + FLOOR + H_EAVE)/2]) square([W_BODY, H_EAVE - H_SILL - FLOOR], center=true);
  translate([0, H_SILL + FLOOR + s(0,END_DOOR[1])/2]) square([s(0,END_DOOR[0]), s(0,END_DOOR[1])], center=true);
  translate([0, H_EAVE - s(0,8)]) text(CAR_NO, size=tsize(4), font=FONT_LB, halign="center", valign="center");
}

module lb_irm2d(f) translate([lx(f, s(DYN_1992 - 2.5)), 0]) text(CAR_NO, size=tsize(7), font=FONT_LB, halign="center", valign="center");
module paint_black(d0, d1) {
  zb = (H_LETTER + H_EAVE)/2;
  for (f = ["s1", "s2"]) {
    on_face(f, L_BODY/2, zb, d0, d1) difference() {
      square([L_BODY, H_EAVE - H_LETTER], center=true);
      if (ERA >= 1992) lb_irm2d(f); else lb_text2d(f);
    }
    if (ERA < 1992) on_face(f, s(30), s(5,0), d0, d1)
      text(CLASS_TX, size=tsize(4), font=FONT_LB, halign="center", valign="center");
  }
  for (f = ["A", "B"]) on_face(f, 0, 0, d0, d1) end_panel2d();
}
module irm_red2d(f) {                              // DYNAMOMETER and the stencils (IRM era)
  translate([lx(f, s(DYN_1992)), s(4,7)]) text(CLASS_TX, size=tsize(5), font=FONT_S, spacing=2.1, halign="center", valign="center");
  for (st = STENCILS_1992) if (st[3] == "both" || st[3] == f)
    translate([lx(f, s(st[0])), s(0, st[1])]) text(st[4], size=tsize(st[2]), font=FONT_S, halign="center", valign="center");
}
module paint_alu(d0, d1) {                      // 1930: aluminum stripes and lettering on black
  zb = (H_LETTER + H_EAVE)/2;
  for (f = ["s1", "s2"]) {
    for (z = STRIPES_1930) on_face(f, L_BODY/2, z, d0, d1) square([L_BODY - 2, s(0,1.5)], center=true);
    for (it = LB_1930) on_face(f, s(it[0]), zb, d0, d1) text(it[1], size=tsize(it[2]), font=FONT_LB, halign="center", valign="center");
    on_face(f, s(40), s(5,6), d0, d1) text(CLASS_TX, size=tsize(4), font=FONT_LB, halign="center", valign="center");
  }
}
module paint_red(d0, d1) {
  for (f = ["s1","s2"], x = HERALDS) on_face(f, s(x), H_HERALD, d0, d1) herald2d("red");
  if (ERA >= 1992) for (f = ["s1","s2"]) on_face(f, L_BODY/2, 0, d0, d1) irm_red2d(f);
}
module paint_white(d0, d1) {
  for (f = ["s1","s2"], x = HERALDS) on_face(f, s(x), H_HERALD, d0, d1) herald2d("white");
  if (ERA >= 1992) {                                // X5000 in white on the black letterboard and the ends
    for (f = ["s1","s2"]) on_face(f, L_BODY/2, (H_LETTER + H_EAVE)/2, d0, d1) lb_irm2d(f);
    for (f = ["A", "B"]) on_face(f, 0, H_EAVE - s(0,8), d0, d1) text(CAR_NO, size=tsize(4), font=FONT_LB, halign="center", valign="center");
  }
}
module paint_all(d0, d1) { if (ERA >= 1992) paint_black(d0, d1); else paint_alu(d0, d1); paint_red(d0, d1); paint_white(d0, d1); }

// details for the views and Blender (too fine to print): end ladders, door grab irons, door steps
module details() {
  for (e = [0, 1]) {                                            // end ladder near the side-1 corner (1930 photo)
    xf = e ? L_BODY + s(0,3) : -s(0,3);
    for (y = [s(2,6), s(3,10)]) translate([xf - 0.5, y - 0.5, H_SILL + s(0,4)]) cube([1.0, 1.0, H_EAVE - H_SILL - s(0,10)]);
    for (z = [H_SILL + s(1,6) : s(0,15) : H_EAVE - s(0,8)]) translate([xf, s(2,6), z]) rotate([-90,0,0]) cylinder(d=0.7, h=s(1,4), $fn=8);
    for (y = [s(2,6), s(3,10)], z = [H_SILL + s(0,6), H_EAVE - s(0,10)])
      translate([e ? L_BODY : xf - 0.35, y - 0.35, z]) cube([s(0,3) + 0.35, 0.7, 0.7]);
  }
  for (side = [-1, 1]) {
    d = door(side); xa = XI(d[0]); xb = XI(d[1]); yf = side*(W_BODY/2 + s(0,2.5));
    for (x = [xa - s(0,4), xb + s(0,4)]) {                       // grab irons beside the door
      translate([x, yf, H_SILL + s(0,62)]) cylinder(d=0.8, h=s(0,40), $fn=8);
      for (z = [H_SILL + s(0,64), H_SILL + s(0,100)]) translate([x - 0.35, side > 0 ? W_BODY/2 : yf, z]) cube([0.7, s(0,2.5), 0.7]);
    }
    translate([(xa + xb)/2 - s(0,9), side > 0 ? W_BODY/2 - s(0,2) : -W_BODY/2 - s(0,6), H_SILL - s(0,14)]) cube([s(0,18), s(0,8), 0.8]);   // door step
    for (x = [(xa + xb)/2 - s(0,9), (xa + xb)/2 + s(0,9) - 0.8])
      translate([x, side > 0 ? W_BODY/2 + s(0,4) : -W_BODY/2 - s(0,6), H_SILL - s(0,14)]) cube([0.8, s(0,2), s(0,14) + 0.5]);
  }
  if (ERA >= 1992) for (side = [-1, 1], e = [0, 1]) {
    xc = e ? L_BODY - s(0,9) : s(0,9);                           // four grab irons on each corner post
    for (z = [H_SILL + s(0,14), H_SILL + s(0,34), H_SILL + s(0,58), H_SILL + s(0,80)])
      translate([xc - s(0,8), side*(W_BODY/2 + s(0,2.5)) - 0.35, z]) cube([s(1,4), 0.7, 0.7]);
    for (x = [xc - s(0,8), xc + s(0,8) - 0.7]) translate([x, side > 0 ? W_BODY/2 : side*(W_BODY/2 + s(0,2.5)), H_SILL + s(0,14)])
      cube([0.7, s(0,2.5), s(0,66)]);
    translate([xc - s(0,8), side > 0 ? W_BODY/2 - s(0,1) : -W_BODY/2 - s(0,5), H_SILL - s(0,14)]) cube([s(1,4), s(0,6), 0.8]);   // end-sill stirrup
    for (x = [xc - s(0,8), xc + s(0,8) - 0.8]) translate([x, side > 0 ? W_BODY/2 + s(0,4) : -W_BODY/2 - s(0,5), H_SILL - s(0,14)]) cube([0.8, s(0,1), s(0,14) + 0.5]);
  }
  if (BAYS) for (side = [-1, 1]) {                                // windshield wiper on the forward bay window
    b = bay(side); xa = XI(b[0]); xb = XI(b[1]);
    to_side(side) translate([xa + (xb - xa)*0.55, BAY_OUT*0.55 + 0.4, s(0, BAY_Z[0] + 30)]) rotate([0, -35, atan2(BAY_OUT, xb - xa)]) cube([s(1,2), 0.4, 0.5]);
  }
}

module car() {
  color(ERA >= 1992 ? ORANGE : BLACK) body_shell();
  if (LETTERING != "none") {
    d0 = LETTERING == "inlay" ? -INLAY : 0;
    if (ERA >= 1992) color(BLACK) paint_black(d0, 0.03); else color([0.80,0.81,0.82]) paint_alu(d0, 0.03);
    color(RED)   paint_red(d0, 0.03);
    color(WHITE) paint_white(d0, 0.04);
  }
  if (SHOW_ROOF) color(BLACK) roof_shell();
  color([0.2,0.2,0.2]) floor_frame();
  if (INTERIOR) {
    if (ERA >= 1992) { color([0.89,0.86,0.76]) interior("wood"); color([0.72,0.78,0.62]) interior("oak"); color([0.36,0.22,0.14]) interior("leather");
                       color([0.31,0.42,0.27]) interior("fabric"); color([0.25,0.25,0.27]) interior("iron"); color([0.78,0.79,0.78]) interior("monel");
                       color([0.94,0.93,0.90]) interior("panel"); color([0.80,0.62,0.22]) interior("gold"); }
    else { color([0.48,0.29,0.18]) interior("wood"); color([0.72,0.55,0.33]) interior("oak");
           color([0.36,0.22,0.14]) interior("leather"); color([0.25,0.25,0.27]) interior("iron"); color([0.75,0.76,0.74]) interior("monel"); }
  }
  trucks_view();
  color(ERA >= 1992 ? WHITE : BLACK) details();
  if (ERA >= 1992) color("red") lights();
}
module lights() {
  translate([L_BODY + 0.5, -s(3,0), H_EAVE - s(1,6)]) rotate([0,90,0]) cylinder(d=s(0,10), h=s(0,6));   // Mars light, B end
  for (x=[-1.8, L_BODY + 1.8]) translate([x, s(3,6), H_EAVE - s(1,6)]) sphere(d=s(0,7));              // jelly-jar lights
}

// ---------------- groups for Blender (render_x5000.py) ----------------
module render_group(g) {
  if (g == "orange") body_shell();
  else if (g == "black") { if (ERA >= 1992) paint_black(-0.01, 0.12); if (SHOW_ROOF && !ROOF_APART) roof_shell(); }
  else if (g == "alu")   { if (ERA < 1992) paint_alu(-0.01, 0.12); }   // 1930 aluminum stripes and lettering
  else if (g == "details") details();
  else if (g == "roof")  { if (ROOF_APART) roof_shell(); }        // separate roof for the fly-through (it lifts off)
  else if (g == "lining") { if (INTERIOR) { if (ERA >= 1992) lining(); else difference() { lining(); translate([s(0, END_W) + s(21.5), -100, 0]) cube([s(48.33 - 21.5), 200, 300]); } } }
  else if (g == "lining_wood") { if (INTERIOR && ERA < 1992) intersection() { lining(); translate([s(0, END_W) + s(21.5), -100, 0]) cube([s(48.33 - 21.5), 200, 300]); } }               // painted inside of the walls (Blender only)
  else if (g == "linoleum") { if (INTERIOR) translate([s(0,END_W), -(W_BODY/2 - WALL - TOL), H_SILL + FLOOR + 0.99]) cube([INSIDE, 2*(W_BODY/2 - WALL - TOL), 0.15]); }
  else if (g == "red")   paint_red(-0.01, 0.12);
  else if (g == "white") paint_white(-0.01, 0.16);
  else if (g == "frame") floor_frame();
  else if (g == "trucks") for (x = truck_x()) translate([x, 0, 0]) pt_frame_parts();
  else if (g == "wheels") wheelsets_view();
  else if (g == "inside") { if (INTERIOR) interior("wood"); }
  else if (g == "oak" || g == "leather" || g == "iron" || g == "monel" || g == "fabric" || g == "panel" || g == "gold") { if (INTERIOR) interior(g); }
  else if (g == "glass") glass_panes();
  else if (g == "lens") { if (ERA >= 1992) lights(); }
  else if (g == "rails") for (sg=[-1,1])
    translate([-250, sg*GAUGE/2 - 1, -8]) cube([L_BODY + 500, 2, 8]);
}

// thin lining just inside the walls, with the window and door openings, so the inside can have its own colour
module lining() {
  z0 = H_SILL + FLOOR + 1.0; t = 0.3;
  difference() {
    union() {
      for (sd=[-1,1]) translate([WALL, sd > 0 ? W_BODY/2 - WALL - t : -W_BODY/2 + WALL, z0]) cube([L_BODY - 2*WALL, t, H_EAVE - z0]);
      for (x=[WALL, L_BODY - WALL - t]) translate([x, -W_BODY/2 + WALL, z0]) cube([t, W_BODY - 2*WALL, H_EAVE - z0]);
    }
    for (side=[-1,1]) {
      if (BAYS) bay_hollow(side);
      for (o = concat(wins(side), [door_win(side)])) opening(o, side, WALL*4);
    }
    for (x=[0, L_BODY]) translate([x, 0, H_SILL + FLOOR + s(0,END_DOOR[1])/2])
      cube([WALL*4, s(0,END_DOOR[0]), s(0,END_DOOR[1])], center=true);
  }
}

module glass_panes() {
  for (side=[-1,1]) {
    for (o = concat(wins(side), [door_win(side)]))
      translate([0, -side*WALL/2, 0]) opening([o[0] - 0.4, o[1] + 0.4, o[2] - 0.4, o[3] + 0.8, o[4]], side, 0.4);
    if (BAYS) { b = bay(side);
      to_side(side) for (w = side > 0 ? BAY1_WIN : BAY2_WIN)
        translate([XI((b[1] + b[2])/2) + s(0,w[0]), BAY_OUT - WALL/2, s(0,(BAY_Z[0] + BAY_Z[1])/2)])
          window_hole(s(0,w[1]) + 0.6, s(0,w[2]) + 0.6, w[3], 0.4); }
  }
}

// ---------------- sections and print orientation ----------------
module cut(n, lo=-50, hi=400) {
  len = L_BODY / sections;
  a = n == 1 ? -50 : (n-1)*len;
  b = n == sections ? L_BODY + 50 : n*len;
  intersection() { children(); translate([a, -200, lo]) cube([b - a, 400, hi - lo]); }
}

module laid(z) translate([0, 0, -z]) children();

if (RENDER != "") translate([-L_BODY/2, 0, 0]) render_group(RENDER);
else if (part == "view") car();
else if (part == "body")  laid(H_SILL) if (section_no == 0) body_shell(); else cut(section_no) body_shell();
else if (part == "black") laid(H_SILL)   if (section_no == 0) paint_black(-INLAY, 0); else cut(section_no) paint_black(-INLAY, 0);   // 1930: use part = "alu"
else if (part == "alu")   laid(H_SILL)   if (section_no == 0) paint_alu(-INLAY, 0);   else cut(section_no) paint_alu(-INLAY, 0);
else if (part == "red")   laid(H_SILL)   if (section_no == 0) paint_red(-INLAY, 0);   else cut(section_no) paint_red(-INLAY, 0);
else if (part == "white") laid(H_SILL)   if (section_no == 0) paint_white(-INLAY, 0); else cut(section_no) paint_white(-INLAY, 0);
else if (part == "roof")  laid(H_EAVE - 3)     if (section_no == 0) roof_shell(); else cut(section_no) roof_shell();
else if (part == "floor") translate([0,0,H_SILL]) mirror([0,0,1])
                            if (section_no == 0) floor_frame(); else cut(section_no) floor_frame();
else if (part == "interior") laid(H_SILL + FLOOR) if (section_no == 0) interior(); else cut(section_no) interior();
else if (part == "truck") pt_part(truck_part);
else if (part == "joiners") joiners();

echo(str("X5000 G v4: body ", L_BODY, " x ", W_BODY, " mm; over castings ", L_BODY + 2*CASTING,
         "; over bays ", W_BODY + 2*BAY_OUT, " mm; rail to crown ", H_CROWN, " mm; section ", L_BODY/sections, " mm"));
