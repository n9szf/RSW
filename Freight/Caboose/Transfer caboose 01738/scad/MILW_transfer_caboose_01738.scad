// =====================================================================
// Rib Side Works - Milwaukee Road Terminal (Transfer) Caboose
// Prototype: MILW 01738 (now at East Troy Railroad Museum)
//   built 1956 by the Milwaukee Road on an L-3 (USRA heavy 2-8-2)
//   tender frame, reusing the tender's Andrews trucks.
// Series 01731-01740.
//
// v3 (11/17/2026): proportions from Tom's ETRM photos of 01738 and the Walthers HO
//   model of 01731 (same series; BLT 8-57, LT WT 45700); details from Kehoe
//   "Milwaukee Road's Steel Cabooses" ch.3 and a ctcpix close-up of the end and steps.
//   Not yet checked against a drawing.
// v4 (11/21/2026): Tom - no raised lettering; THE MILWAUKEE ROAD, the road numbers and the
//   sill stencils will be decals. LETTERING = "decal" (default) leaves them off the model and
//   the print parts; "raised" puts the old raised letters back.
//   Verify against Kehoe "Milwaukee Road's Steel Cabooses" (MRHA) and the
//   5/2/1967 drawing "Terminal Caboose 01731-01740", or measure 01738.
//
// Stand-alone kit file: no libraries needed.  OpenSCAD 2021+.
// Contact: ribsideworks@gmail.com
// =====================================================================

/* [Scale and part] */
SCALE = "G";        // [G:G 1:29, O:O 1:48, HO:HO 1:87]
PART  = "assembled"; // [assembled, deck, cab, roof, railings, truck, brake_wheel, lettering]

/* [Options] */
ETRM_TODAY   = true;   // true = as at East Troy now: no roof walk or roof handles
WINDOWS_PLATED = false; // true = later FRA-era plated-over side windows
SHOW_TRUCKS  = true;    // stand-in trucks in the assembled view
ROAD_NO      = "01738";  // road number on the cab sides (decal; drawn only when LETTERING = "raised")
LETTERING    = "decal";  // [decal:Decals - plain sides, raised:Raised printed letters]

/* [Print] */
MIN_WALL = 0.8;     // mm, smallest printable feature

$fn = 32;

// ---------------- scale ----------------
RATIO = SCALE=="G" ? 29 : SCALE=="O" ? 48 : 87.1;
function mm(inch)  = inch*25.4/RATIO;           // prototype inches -> model mm
function mmt(inch) = max(mm(inch), MIN_WALL);   // thin parts never below MIN_WALL
function ft(f, i=0) = f*12 + i;                  // feet + inches -> inches

// ---------------- prototype dimensions (inches) - BEST GUESS ----------------
DECK_L     = ft(26);        // over end sills (photos; forum said 32 ft frame)
DECK_W     = ft(9,8);       // frame width over side sills
DECK_T     = 10;            // deck plate + sill depth shown
SILL_D     = 14;            // side sill (channel) depth below deck
DECK_TOP   = ft(4);         // top of deck above rail (photos)
TRUCK_CTR  = ft(12,10);     // truck centres from photos + Walthers (forum drawing reading 14'4-1/2" - TDQ-537)
WHEEL_D    = 33;            // wheel diameter
WHEELBASE  = ft(5,6);       // Andrews tender truck

CAB_L      = ft(12);        // cab length (forum, MRHA plans; photos agree)
CAB_X      = 0;             // cab centred on the deck (Walthers 01731, Kehoe photo)
CAB_W      = ft(8,8);       // cab width
CAB_WALL_H = ft(6,10);      // deck to eave (photo ratios)
ROOF_RISE  = 4;             // eave to roof center
WALL_T     = 2.5;           // steel sheet + framing, shown thick for printing
OVERALL_H  = ft(14);        // rail to top of signal stands (ETRM page)

DOOR_W = 26; DOOR_H = ft(6,6);  DOOR_WIN_W = 18; DOOR_WIN_H = 18; DOOR_WIN_SILL = 52;   // closed door with window (photos)
END_WIN_W = 24; END_WIN_H = 26; END_WIN_SILL = 38;
SIDE_WIN_W = 27; SIDE_WIN_H = 25; SIDE_WIN_SILL = 32;   // one two-pane window per side (photo)
SIDE_WIN_X = [0];                  // window centred on the side

RAIL_H   = 36;     // platform railing height above deck (Walthers)
RAIL_D   = 1.5;    // pipe railing diameter
STEP_W   = 34; STEP_RISE = 12; STEPS = 3; STEP_D = 11;   // corner stair: 3 grating treads between side plates (C1 / ctcpix photos)

WALK_L = CAB_L - 6; WALK_W = 20; WALK_T = 2;
STAND_H = OVERALL_H - (DECK_TOP + CAB_WALL_H + ROOF_RISE);  // signal stand height above roof

// =====================================================================
// helpers
module box(l,w,h) { translate([-l/2,-w/2,0]) cube([l,w,h]); }
module pipe(p1, p2, d) {   // pipe between two points (mm)
    hull() { translate(p1) sphere(d=d, $fn=12); translate(p2) sphere(d=d, $fn=12); }
}

// =====================================================================
// DECK (tender frame) - origin: deck top center at z = 0
module deck() {
    difference() {
        union() {
            translate([0,0,-mm(DECK_T)]) box(mm(DECK_L), mm(DECK_W), mm(DECK_T));
            // side sills
            for (s=[-1,1]) translate([0, s*(mm(DECK_W)/2 - mmt(3)/2), -mm(SILL_D)])
                box(mm(DECK_L), mmt(3), mm(SILL_D));
            // end sills with coupler pockets
            for (e=[-1,1]) translate([e*(mm(DECK_L)/2 - mmt(6)/2), 0, -mm(SILL_D+4)])
                box(mmt(6), mm(DECK_W), mm(SILL_D+4));
            // center sill
            translate([0,0,-mm(SILL_D+6)]) box(mm(DECK_L)-mm(24), mm(24), mm(SILL_D+6));
            // bolsters
            for (e=[-1,1]) translate([e*mm(TRUCK_CTR)/2,0,-mm(SILL_D+4)])
                box(mm(14), mm(DECK_W)-mm(10), mm(SILL_D+4));
            // tread-plate texture (raised strips) on the open platforms
            for (e=[-1,1]) let(x0 = CAB_X + e*CAB_L/2, x1 = e*(DECK_L/2 - 8))
                for (i=[0:5]) translate([mm(x0 + (i+0.5)*(x1-x0)/6), 0, 0])
                    box(mmt(1), mm(DECK_W)-mm(8), mmt(0.5));
        }
        // coupler pocket openings
        for (e=[-1,1]) translate([e*mm(DECK_L)/2, 0, -mm(SILL_D)])
            box(mm(14), mm(10), mm(8));
        // stair notches: side sill and frame cut away over each corner stair, deck plate kept (990025 / C1 photos)
        for (e=[-1,1]) for (s=[-1,1]) let(xo = step_x(e)[0], xi = step_x(e)[1])
            translate([(xo+xi)/2, s*(mm(DECK_W)/2 - mm(STEP_D)/2 + mm(1)), -mm(SILL_D) - mm(8)])
                box(abs(xo-xi) - 2*mmt(1.2), mm(STEP_D) + mm(2), mm(SILL_D) + mm(8) - mm(2));
        // bolster mounting holes (2 mm screw / pin)
        for (e=[-1,1]) translate([e*mm(TRUCK_CTR)/2,0,-mm(SILL_D+10)]) cylinder(d=2.2, h=mm(SILL_D+20));
    }
    corner_steps();
}

// Corner stairs (photos of C1, 01738 and the ctcpix close-up): at each deck corner, flush
// with the car side, two solid black side plates hang from the deck down to the bottom
// tread; the end-side plate tapers in toward the bottom. Three open-grating treads
// (light galvanised in the photos) sit between them; the front is open.
function step_x(e) = [e*(mm(DECK_L)/2 - mm(3)), e*(mm(DECK_L)/2 - mm(3) - mm(STEP_W))];  // [end plate, inner plate]
module corner_steps() {          // black side plates and back
    pl = mmt(1.2);
    for (e=[-1,1]) for (s=[-1,1]) {
        xo = step_x(e)[0]; xi = step_x(e)[1];
        yf = s*(mm(DECK_W)/2);                   // front (car side)
        yb = yf - s*mm(STEP_D);                  // back
        bot = -STEPS*mm(STEP_RISE) - mmt(1.5);
        // inner plate: full depth, deck to bottom tread
        translate([xi, (yf+yb)/2, bot]) box(pl, mm(STEP_D), -bot);
        // end plate: full depth at the top, tapering in toward the bottom
        hull() {
            translate([xo, (yf+yb)/2, -0.01]) box(pl, mm(STEP_D), 0.01);
            translate([xo - e*mm(6), (yf+yb)/2, bot]) box(pl, mm(STEP_D), mmt(1.5));
        }
        // back plate behind the lower treads
        translate([(xo+xi)/2, yb + s*pl/2, bot]) box(abs(xo-xi), pl, -bot - mm(SILL_D));
        // tread supports (angles on the side plates)
        for (k=[1:STEPS]) for (x=[xi + e*pl, xo - e*mm(6)*k/STEPS - e*pl])
            translate([x, (yf+yb)/2, -k*mm(STEP_RISE) - mmt(1.5)]) box(pl, mm(STEP_D), mmt(1.5));
    }
}
module corner_treads() {         // open grating treads (render colour: galvanised)
    for (e=[-1,1]) for (s=[-1,1]) {
        xo = step_x(e)[0]; xi = step_x(e)[1];
        yf = s*(mm(DECK_W)/2);
        for (k=[1:STEPS]) {
            x0 = xi + e*mmt(1.2); x1 = xo - e*mm(6)*k/STEPS - e*mmt(1.2);
            translate([(x0+x1)/2, yf - s*mm(STEP_D)/2, -k*mm(STEP_RISE)])
            difference() {
                box(abs(x1-x0), mm(STEP_D), mmt(1.5));
                // grating slots
                for (n=[-3:3]) translate([n*abs(x1-x0)/8, 0, -0.1]) box(mmt(1), mm(STEP_D) - mmt(2.5), mmt(1.5) + 0.2);
            }
        }
    }
}

// =====================================================================
// CAB - sits on deck at z = 0
module cab_shell() {
    h = mm(CAB_WALL_H);
    t = mmt(WALL_T);
    difference() {
        box(mm(CAB_L), mm(CAB_W), h);
        translate([0,0,-0.1]) box(mm(CAB_L)-2*t, mm(CAB_W)-2*t, h+0.2);
        // end doors (offset toward the left side as seen from the platform) and end windows
        for (e=[-1,1]) {
            translate([e*mm(CAB_L)/2, e*mm(16), mm(DOOR_WIN_SILL)]) box(4*t, mm(DOOR_WIN_W), mm(DOOR_WIN_H));
            translate([e*mm(CAB_L)/2, -e*mm(22), mm(END_WIN_SILL)]) box(4*t, mm(END_WIN_W), mm(END_WIN_H));
        }
        // side windows
        if (!WINDOWS_PLATED)
            for (s=[-1,1]) for (x=SIDE_WIN_X)
                translate([x, s*mm(CAB_W)/2, mm(SIDE_WIN_SILL)]) box(mm(SIDE_WIN_W), 4*t, mm(SIDE_WIN_H));
    }
    // window frames / plates
    for (s=[-1,1]) for (x=SIDE_WIN_X)
        translate([x, s*(mm(CAB_W)/2), mm(SIDE_WIN_SILL)-mmt(1.5)])
            difference() {
                box(mm(SIDE_WIN_W)+2*mmt(1.5), mmt(0.8)*2, mm(SIDE_WIN_H)+2*mmt(1.5));
                if (!WINDOWS_PLATED) translate([0,0,mmt(1.5)]) box(mm(SIDE_WIN_W), mmt(0.8)*4, mm(SIDE_WIN_H));
            }
    // drip header over the side window
    for (s=[-1,1]) for (x=SIDE_WIN_X)
        translate([mm(x), s*(mm(CAB_W)/2 + mmt(1)/2), mm(SIDE_WIN_SILL + SIDE_WIN_H + 3)]) box(mm(SIDE_WIN_W + 10), mmt(1)*2, mmt(1.5));
    // centre mullion: two-pane sash
    if (!WINDOWS_PLATED) for (s=[-1,1]) for (x=SIDE_WIN_X)
        translate([x*25.4/RATIO, s*(mm(CAB_W)/2 - mmt(WALL_T)/2), mm(SIDE_WIN_SILL)]) box(mmt(2), mmt(WALL_T), mm(SIDE_WIN_H));
    // door frames
    for (e=[-1,1]) translate([e*mm(CAB_L)/2, e*mm(16), 0])
        difference() {   // door outline (raised frame) with its window left open
            box(mmt(0.8)*2, mm(DOOR_W)+2*mmt(1.5), mm(DOOR_H)+mmt(1.5));
            translate([0,0,-0.1]) box(mmt(0.8)*4, mm(DOOR_W), mm(DOOR_H));
        }
    for (e=[-1,1]) translate([e*(mm(CAB_L)/2 + mmt(0.6)), e*mm(16), mm(DOOR_H)/2])
        box(mmt(0.6), mmt(1.5), mmt(1.5)*2);   // door knob
    // vertical corner posts (angle iron)
    for (e=[-1,1]) for (s=[-1,1])
        translate([e*(mm(CAB_L)/2), s*(mm(CAB_W)/2), 0]) box(mmt(2), mmt(2), h);
    // ladders on each end (right side of door)
    if (!ETRM_TODAY) for (e=[-1,1]) cab_ladder(e);
    // grab irons beside doors
    for (e=[-1,1]) for (k=[-1,1])
        translate([e*(mm(CAB_L)/2 + mmt(2)), e*mm(16) + k*(mm(DOOR_W)/2 + mm(4)), mm(30)])
            box(mmt(RAIL_D), mmt(RAIL_D), mm(36));
}

module cab_ladder(e) {
    y = e*mm(26);
    x = e*(mm(CAB_L)/2 + mm(5));
    top = mm(CAB_WALL_H + ROOF_RISE) + mm(4);
    for (k=[-1,1]) translate([x, y + k*mm(8), 0]) box(mmt(1.5), mmt(1.5), top);
    for (z=[mm(16): mm(16): top-0.1]) translate([x, y, z]) box(mmt(1.2), mm(18), mmt(1.2));
    for (k=[-1,1]) translate([e*(mm(CAB_L)/2 + mm(2.5)), y + k*mm(8), mm(12)]) box(mm(5), mmt(1.2), mmt(1.2));
}

// ---------------- roof (separate print) ----------------
module roof() {
    over = mm(4);
    L = mm(CAB_L) + 2*over; W = mm(CAB_W) + 2*over;
    rise = mm(ROOF_RISE); t = mmt(2);
    // shallow arched roof from a scaled cylinder segment
    r = (pow(W/2,2) + rise*rise)/(2*rise);
    intersection() {
        translate([0,0,-(r-rise)]) rotate([0,90,0]) difference() {
            cylinder(r=r, h=L, center=true, $fn=180);
            cylinder(r=r-t, h=L+1, center=true, $fn=180);
        }
        translate([0,0,-t]) box(L, W, rise + 2*t);
    }
    // roof walk on stand-offs (gone at ETRM today)
    if (!ETRM_TODAY) {
    translate([0,0,rise + mm(3)]) box(mm(WALK_L), mm(WALK_W), mmt(WALK_T));
    for (x=[-1,0,1]) translate([x*mm(WALK_L)/2.4, 0, rise - t]) box(mmt(3), mm(WALK_W)-mm(4), mm(3)+t);
    }
    // smoke jack (stove stack), offset to one side
    stack_h = OVERALL_H - (DECK_TOP + CAB_WALL_H + ROOF_RISE) - 9;
    translate([mm(CAB_L)/2 - mm(16), -mm(CAB_W)/4, rise - mm(2)]) {
        cylinder(d=mm(8), h=mm(stack_h));
        translate([0,0,mm(stack_h)]) cylinder(d1=mm(8), d2=mm(13), h=mm(5));
        translate([0,0,mm(stack_h+5)]) cylinder(d=mm(13), h=mm(4));
    }
    // signal stands at each end of the roof walk + loop handles
    if (!ETRM_TODAY) for (e=[-1,1]) {
        sx = e*(mm(WALK_L)/2 - mm(2));
        for (k=[-1,1]) translate([sx, k*mm(WALK_W)/2, rise + mm(3)])
            cylinder(d=mmt(RAIL_D), h=mm(STAND_H) - mm(3));
        translate([sx, 0, rise + mm(STAND_H) - mmt(RAIL_D)/2])
            rotate([90,0,0]) cylinder(d=mmt(RAIL_D), h=mm(WALK_W), center=true);
        for (k=[-1,1]) translate([sx - e*mm(18), k*(mm(WALK_W)/2 + mm(4)), rise + mm(3)]) {
                cylinder(d=mmt(RAIL_D), h=mm(16));
                translate([e*mm(9),0,mm(16)]) rotate([0,90,0]) cylinder(d=mmt(RAIL_D), h=mm(18), center=true);
                translate([e*mm(18),0,0]) cylinder(d=mmt(RAIL_D), h=mm(16));
            }
    }
}

// =====================================================================
// PLATFORM RAILINGS - around the open deck at each end
module railings() {   // white pipe rails; the posts are black (rail_posts)
    d = mmt(RAIL_D);
    function xc(e) = mm(CAB_X) + e*mm(CAB_L)/2;   // cab face toward end e
    xe = mm(DECK_L)/2 - mm(5);                 // end frame
    ys = mm(DECK_W)/2 - mm(3);                 // near deck side
    gap = mm(STEP_W) + mm(6);                  // opening over corner steps
    h1 = mm(RAIL_H); h2 = mm(RAIL_H*0.45);
    for (e=[-1,1]) for (s=[-1,1]) {
        // rails stop at the post beside the step opening - the corner is open to step onto the deck
        xh = e*(xe - gap);
        pipe([xc(e), s*ys, h1], [xh, s*ys, h1], d);
        pipe([xc(e), s*ys, h2], [xh, s*ys, h2], d);
        // hand-hold: the top rail sweeps down from the post to the sill at the step (Walthers 01731)
        R = gap*0.55;
        for (a=[0:10:80]) pipe([xh + e*R*sin(a),    s*(ys + mm(2)*a/90),      h1*cos(a)],
                               [xh + e*R*sin(a+10), s*(ys + mm(2)*(a+10)/90), h1*cos(a+10)], d);
        // vertical grab on the end-frame side of the opening
        pipe([e*(xe - mm(4)), s*(ys + mm(1)), mm(4)], [e*(xe - mm(4)), s*(ys + mm(1)), h1], d);
        // grab beside each cab corner
        pipe([xc(e) + e*mm(3), s*(ys - mm(2)), mm(10)], [xc(e) + e*mm(3), s*(ys - mm(2)), h1], d);
    }
    // end rail between the end-frame posts
    for (e=[-1,1]) pipe([e*xe, -(ys - mm(4)), h1*0.7], [e*xe, ys - mm(4), h1*0.7], d);
}

module rail_posts() {   // black square posts carrying the white rails
    ys = mm(DECK_W)/2 - mm(3); gap = mm(STEP_W) + mm(6); xe = mm(DECK_L)/2 - mm(5);
    for (e=[-1,1]) for (s=[-1,1]) for (x=[mm(CAB_L)/2 + mm(14), xe - gap])
        translate([e*x, s*ys, 0]) box(mmt(2.5), mmt(2.5), mm(RAIL_H) + mm(2));
}

module brake_gear() {   // tall black end frames, rail posts, and an upright brake wheel on each end frame
    xe = mm(DECK_L)/2 - mm(5); ys = mm(DECK_W)/2 - mm(5);
    fh = mm(RAIL_H + 12);                     // end frame height
    for (e=[-1,1]) {
        for (s=[-1,1]) translate([e*xe, s*ys, 0]) box(mm(6), mm(8), fh);         // corner uprights
        translate([e*xe, 0, fh - mm(4)]) box(mm(4), 2*ys + mm(8), mm(4));         // top bar
        translate([e*xe, ys*0.45, 0]) box(mm(3), mm(3), fh);                      // brake post
        // brake wheel, upright, facing outboard
        translate([e*(xe + mm(4)), ys*0.45, fh - mm(14)]) rotate([0,90,0]) brake_wheel();
        translate([e*(xe + mm(2)), ys*0.45, fh - mm(14)]) rotate([0,90,0]) cylinder(d=mmt(1.5), h=mm(6), center=true);
    }
    rail_posts();
}

module brake_wheel() {
    rotate_extrude($fn=36) translate([mm(8),0]) circle(d=mmt(1.5), $fn=10);
    for (a=[0:60:300]) rotate([0,0,a]) translate([mm(4),0,0]) box(mm(8), mmt(1), mmt(1));
    cylinder(d=mmt(3), h=mmt(1.5), center=true);
}

// =====================================================================
// STAND-IN ANDREWS TRUCK (display only - use the RSW truck library for printing,
// or bought trucks in HO: Kadee / Tichy Andrews, Cal Scale brass)
module truck() {
    wr = mm(WHEEL_D)/2;
    gauge = SCALE=="G" ? 45 : SCALE=="O" ? 31.75 : 16.5;
    for (x=[-1,1]) translate([x*mm(WHEELBASE)/2,0,wr]) rotate([90,0,0]) {
        for (s=[-1,1]) translate([0,0,s*gauge/2]) cylinder(r=wr, h=mmt(5), center=true, $fn=48);
        cylinder(d=mmt(5), h=gauge+mm(8), center=true);
    }
    // side frames (Andrews: straight top bar, arched bottom bar, journal boxes)
    for (s=[-1,1]) translate([0, s*(gauge/2 + mm(6)), 0]) {
        translate([0,0,wr + mm(6)]) box(mm(WHEELBASE)+mm(20), mmt(4), mm(5));
        hull() { translate([-mm(WHEELBASE)/2,0,wr]) box(mm(6),mmt(4),mm(4));
                 translate([0,0,wr-mm(8)]) box(mm(20),mmt(4),mm(4)); }
        hull() { translate([ mm(WHEELBASE)/2,0,wr]) box(mm(6),mmt(4),mm(4));
                 translate([0,0,wr-mm(8)]) box(mm(20),mmt(4),mm(4)); }
        for (x=[-1,1]) translate([x*mm(WHEELBASE)/2,0,wr-mm(5)]) box(mm(12),mmt(6),mm(11));
        translate([0,0,wr-mm(8)]) box(mm(16),mmt(4),mm(16));   // spring nest (3 springs)
    }
    translate([0,0,wr + mm(4)]) box(mm(12), gauge + mm(10), mm(6)); // bolster
}

// =====================================================================
// LAYOUT
module assembled() {
    deck_z = mm(DECK_TOP);
    translate([0,0,deck_z]) {
        color("Black") deck();
        color("Silver") corner_treads();
        translate([mm(CAB_X),0,0]) color("DarkOrange") cab_shell();
        if (LETTERING == "raised") color("DarkRed") lettering();
        color("Black") translate([mm(CAB_X),0,mm(CAB_WALL_H)]) roof();
        color("WhiteSmoke") { railings(); if (LETTERING == "raised") stencils(); }
        color("Black") brake_gear();
    }
    if (SHOW_TRUCKS) color("DimGray") for (e=[-1,1]) translate([e*mm(TRUCK_CTR)/2,0,0]) truck();
}

if      (PART=="assembled")   assembled();
else if (PART=="deck")        translate([0,0,mm(SILL_D+6)]) { deck(); corner_treads(); }
else if (PART=="cab")         cab_shell();
else if (PART=="roof")        roof();
else if (PART=="railings")    railings();
else if (PART=="brake_gear")  brake_gear();
else if (PART=="truck")       truck();
else if (PART=="lettering")   { if (LETTERING == "raised") lettering(); else echo("LETTERING is decal: no lettering part"); }
else if (PART=="brake_wheel") brake_wheel();
// render groups (assembled position, one colour each) - used by the Blender job
else if (PART=="r_orange")    translate([mm(CAB_X),0,mm(DECK_TOP)]) cab_shell();
else if (PART=="r_black")     translate([0,0,mm(DECK_TOP)]) { deck(); translate([mm(CAB_X),0,mm(CAB_WALL_H)]) roof(); brake_gear(); }
else if (PART=="r_tread")     translate([0,0,mm(DECK_TOP)]) corner_treads();
else if (PART=="r_rail")      translate([0,0,mm(DECK_TOP)]) { railings(); if (LETTERING == "raised") stencils(); }
else if (PART=="r_trucks")    for (e=[-1,1]) translate([e*mm(TRUCK_CTR)/2,0,0]) truck();
else if (PART=="r_white")     { if (LETTERING == "raised") translate([0,0,mm(DECK_TOP)]) lettering(); }

// road number on both cab sides, below the windows
module lettering() {   // 01731 (Walthers) / 01738 (ETRM): THE / MILWAUKEE / ROAD stepped across the top,
                       // all one letter size; number under the window; small number above each end door
    F = "Liberation Serif";
    cap = 6;           // letter height, inches
    for (s=[-1,1]) translate([mm(CAB_X), s*(mm(CAB_W)/2 + mmt(0.4)/2), 0])
        rotate([90,0,s>0?180:0]) linear_extrude(mmt(0.4), center=true) {
            translate([-mm(63), mm(70)]) resize([mm(29), mm(cap)]) text("THE", size=10, spacing=1.2, font=F);
            translate([-mm(47), mm(61)]) resize([mm(99), mm(cap)]) text("MILWAUKEE", size=10, spacing=1.2, font=F);
            translate([ mm(26), mm(53)]) resize([mm(38), mm(cap)]) text("ROAD", size=10, spacing=1.2, font=F);
            translate([-mm(17), mm(12)]) resize([mm(34), mm(7)]) text(ROAD_NO, size=10, font=F);
        }
    for (e=[-1,1]) translate([mm(CAB_X) + e*(mm(CAB_L)/2 + mmt(0.4)/2), e*mm(16), mm(DOOR_H) + mm(4)])
        rotate([90,0,e>0?90:-90]) linear_extrude(mmt(0.4), center=true)
            resize([mm(16), mm(3.5)]) text(ROAD_NO, size=10, halign="center", font=F);
}

module stencils() {   // white side-sill stencils (Walthers 01731)
    F = "Liberation Sans";
    for (s=[-1,1]) translate([0, s*(mm(DECK_W)/2 + mmt(0.4)/2), -mm(9)])
        rotate([90,0,s>0?180:0]) linear_extrude(mmt(0.4), center=true) {
            translate([-mm(88), 0]) resize([mm(22), mm(2.5)]) text("BLT 8-57", size=10, font=F);
            translate([-mm(12), 0]) resize([mm(30), mm(2.5)]) text("LT WT 45700", size=10, font=F);
        }
}

echo(str("RSW transfer caboose 01738 - ", SCALE, " 1:", RATIO,
         "  deck ", mm(DECK_L), " x ", mm(DECK_W), " mm, overall height ",
         mm(OVERALL_H), " mm"));
