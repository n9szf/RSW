// Milwaukee Union Depot (Everett Street), Chicago, Milwaukee & St. Paul Ry.
// As built 1886 - E. Townsend Mix, architect. Full tower (before the 1950s cut-down).
// FULL SIZE (1:1): units are millimetres, real size. Made for the VR headset
// fly-through (GLB), not for printing. Scale a copy for a printed model.
//
// Rib Side Works - TDQ-215. First pass 11/22/2026 from the MPL drawings
// (record 8609): street elevation (sheet #0), end elevation with train shed (#2),
// floor plans (#6-#9), train shed section (#28).
// Calibration: plan corridor marked 10'6" gives 321 ft x 62 ft, which agrees with
// the Milwaukee County Historical Society figure of 321 ft. Heights scaled from the
// elevations. Everything marked (EST) is a best guess - see TDQ list.
//
// Axes: x = along the building, west (0) to east (321 ft)
//       y = 0 at the street face (Everett St / park side), + toward the tracks
//       z = up, 0 = grade.
// PART: "all" or a colour group for per-colour export:
//       "r_brick", "r_stone", "r_roof", "r_metal", "r_glass", "r_ground",
//       "r_wood", "r_plaster", "r_floor", "r_stained", "r_lamp", "r_granite"
// v2 11/22: 1886 interior (Tom: 1886, best guesses after Mix's other work), entrances opened
// for the fly-through, street porch, "18 86" panels.

PART = "all";
SHOW_SHED   = true;   // train shed over the tracks
SHOW_GROUND = true;   // grade slab, platforms and track
SHOW_INTERIOR = true; // 1886 ground-floor interior (v2)
SHED_LEN_FT = 321;    // (EST) shed length - TDQ: check sheet #27
$fn = 24;

function ft(x) = x * 304.8;

// ---------------- colours ----------------
C_BRICK = [0.58, 0.22, 0.16];   // red pressed brick
C_STONE = [0.80, 0.70, 0.55];   // sandstone trim and bands
C_ROOF  = [0.28, 0.30, 0.33];   // slate
C_METAL = [0.18, 0.20, 0.20];   // iron, copper gone dark, cresting
C_GLASS = [0.12, 0.16, 0.20];
C_GRND  = [0.45, 0.45, 0.42];
C_WOOD  = [0.30, 0.17, 0.08];   // dark carved oak / walnut
C_PLAST = [0.82, 0.74, 0.58];   // tinted plaster, stencilled
C_FLOOR = [0.62, 0.55, 0.45];   // encaustic tile / marble
C_STAIN = [0.55, 0.30, 0.12];   // amber stained glass
C_LAMP  = [1.00, 0.92, 0.70];   // gas globes (emissive in Blender)

module grp(name, c) {
    if (PART == "all" || PART == name) color(c) children();
}

// ---------------- main dimensions ----------------
L      = 321;   // length, ft
D      = 62;    // depth, ft
FLOOR1 = 5;     // first floor above grade (EST, basement windows show on street side)
BELT   = 30;    // belt course / second floor line
EAVE   = 47;    // main eaves
RIDGE  = 66;    // main roof ridge
WALL_T = 2;     // wall thickness, ft

// blocks: [x0, x1, eave, ridge]  (ft)  - read off the street elevation
WEST_WING  = [0,   46, 31, 50];
WEST_LINK  = [46,  57, 33, 52];
WEST_GABLE = [57,  97, EAVE, RIDGE];
CTR_WEST   = [97, 144, EAVE, RIDGE];
TOWER      = [144, 178];          // 34 ft square-ish, flush with the street face
CTR_EAST   = [178, 225, EAVE, RIDGE];
EAST_GABLE = [225, 262, EAVE, RIDGE];
EAST_LINK  = [262, 270, 33, 52];
EAST_WING  = [270, 321, 31, 50];
TOWER_D    = 30;  // (EST) tower depth
TOWER_TOP  = 140; // top of masonry, ft (the "140 ft tower")

// ================= building =================
module walls(x0, x1, h) {
    difference() {
        translate([ft(x0), 0, 0]) cube([ft(x1 - x0), ft(D), ft(h)]);
        translate([ft(x0 + WALL_T), ft(WALL_T), ft(FLOOR1)])
            cube([ft(x1 - x0 - 2*WALL_T), ft(D - 2*WALL_T), ft(h)]);
        window_cuts(x0, x1, h);
    }
}

// window openings, both long faces; tall ground-floor windows, upper windows
module window_cuts(x0, x1, h) {
    bay = 11;
    n = floor((x1 - x0 - 4) / bay);
    off = (x1 - x0 - n * bay) / 2;
    if (n > 0) for (i = [0 : n - 1]) {
        cx = x0 + off + bay * (i + 0.5);
        for (y = [-1, D - WALL_T - 1]) {
            // first floor (arched-head look: box + cylinder)
            translate([ft(cx - 2.5), ft(y), ft(FLOOR1 + 4)]) cube([ft(5), ft(WALL_T + 2), ft(12)]);
            translate([ft(cx), ft(y), ft(FLOOR1 + 16)]) rotate([-90, 0, 0])
                cylinder(r = ft(2.5), h = ft(WALL_T + 2));
            if (h > BELT + 8) {
                translate([ft(cx - 2), ft(y), ft(BELT + 3)]) cube([ft(4), ft(WALL_T + 2), ft(9)]);
            }
            // basement windows on the street side
            if (y < 0) translate([ft(cx - 2), ft(y), ft(0.8)]) cube([ft(4), ft(WALL_T + 2), ft(3)]);
        }
    }
}

module glazing(x0, x1, h) {
    // dark panes set back in each opening
    bay = 11;
    n = floor((x1 - x0 - 4) / bay);
    off = (x1 - x0 - n * bay) / 2;
    if (n > 0) for (i = [0 : n - 1]) {
        cx = x0 + off + bay * (i + 0.5);
        for (y = [0.6, D - 0.9]) {
            translate([ft(cx - 2.5), ft(y), ft(FLOOR1 + 4)]) cube([ft(5), ft(0.3), ft(14.5)]);
            if (h > BELT + 8) translate([ft(cx - 2), ft(y), ft(BELT + 3)]) cube([ft(4), ft(0.3), ft(9)]);
        }
    }
}

module stone_bands(x0, x1, h) {
    // water table, belt course, cornice
    for (z = [FLOOR1 - 1, BELT - 1, h - 1.5])
        translate([ft(x0 - 0.3), ft(-0.4), ft(z)]) cube([ft(x1 - x0 + 0.6), ft(D + 0.8), ft(1.2)]);
}

module hip_roof(x0, x1, eave, ridge, inset = 0) {
    w = x1 - x0;
    run = D / 2;
    ins = min(run, w / 2 - 0.5);
    hull() {
        translate([ft(x0 - 1.5), ft(-1.5), ft(eave)]) cube([ft(w + 3), ft(D + 3), ft(0.5)]);
        translate([ft(x0 + ins), ft(D/2 - 0.25), ft(ridge)]) cube([ft(max(w - 2*ins, 0.5)), ft(0.5), ft(0.5)]);
    }
}

// gable roof across the building (ridge running street-to-track), for the big gable blocks
module cross_gable(x0, x1, eave, peak) {
    w = x1 - x0;
    hull() {
        translate([ft(x0 - 1), ft(-1.5), ft(eave)]) cube([ft(w + 2), ft(D + 3), ft(0.5)]);
        translate([ft(x0 + w/2 - 0.25), ft(-1.5), ft(peak)]) cube([ft(0.5), ft(D + 3), ft(0.5)]);
    }
}

// stepped (Flemish) gable face on the street side
module stepped_gable(x0, x1, eave, peak) {
    w = x1 - x0;
    steps = 5;
    for (i = [0 : steps - 1]) {
        sw = w * (1 - i / steps);
        sh = eave + (peak - eave) * i / steps;
        translate([ft(x0 + (w - sw)/2), ft(-1), ft(sh)])
            cube([ft(sw), ft(3), ft((peak - eave) / steps + 1.5)]);
    }
}

module gable_window(cx, z, w, h) {
    // arched window in a gable (fan light) - cut and glazed
    translate([ft(cx - w/2), ft(-1.6), ft(z)]) cube([ft(w), ft(0.3), ft(h)]);
}

module dormer(cx, y_face, base, peak, w = 6, street = true) {
    // small gabled dormer sitting on the roof slope
    d = 7;
    yy = street ? y_face : y_face - d;
    translate([ft(cx - w/2), ft(yy), ft(base)]) cube([ft(w), ft(d), ft(peak - base - 3)]);
    hull() {
        translate([ft(cx - w/2 - 0.5), ft(yy - 0.5), ft(peak - 3)]) cube([ft(w + 1), ft(d + 1), ft(0.3)]);
        translate([ft(cx - 0.15), ft(yy - 0.5), ft(peak)]) cube([ft(0.3), ft(d + 1), ft(0.3)]);
    }
}

module chimney(cx, cy, top) {
    translate([ft(cx - 1.75), ft(cy - 1.75), ft(40)]) cube([ft(3.5), ft(3.5), ft(top - 40)]);
}

module spire(cx, cy, base, tip, r) {
    // small ventilator lantern + needle spire on the end wings
    translate([ft(cx), ft(cy), ft(base)]) cylinder(r = ft(r), h = ft(6), $fn = 8);
    translate([ft(cx), ft(cy), ft(base + 6)]) cylinder(r1 = ft(r + 0.5), r2 = 0, h = ft(tip - base - 6), $fn = 8);
}

// ----------------- tower -----------------
module tower_masonry() {
    x0 = TOWER[0]; x1 = TOWER[1]; w = x1 - x0;
    difference() {
        translate([ft(x0), ft(-1), 0]) cube([ft(w), ft(TOWER_D), ft(TOWER_TOP)]);
        // main entrance: triple arch at the base (street side)
        for (dx = [-9, 0, 9]) {
            translate([ft(x0 + w/2 + dx - 3.5), ft(-2), ft(FLOOR1)]) cube([ft(7), ft(5), ft(11)]);
            translate([ft(x0 + w/2 + dx), ft(-2), ft(FLOOR1 + 11)]) rotate([-90,0,0]) cylinder(r = ft(3.5), h = ft(5));
        }
        // great arch with balcony (street face), about 60-92 ft
        translate([ft(x0 + w/2 - 9), ft(-2), ft(60)]) cube([ft(18), ft(4), ft(20)]);
        translate([ft(x0 + w/2), ft(-2), ft(80)]) rotate([-90,0,0]) cylinder(r = ft(9), h = ft(4));
        // belfry arcade, all four faces, ~100-106 ft
        for (i = [-2 : 2]) {
            translate([ft(x0 + w/2 + i*5 - 1.6), ft(-2), ft(100)]) cube([ft(3.2), ft(TOWER_D + 2), ft(6)]);
            translate([ft(x0 - 1), ft(TOWER_D/2 - 1 + i*4 - 1.4), ft(100)]) cube([ft(w + 2), ft(2.8), ft(6)]);
        }
        // three-light window under the clock, street and track faces
        translate([ft(x0 + w/2 - 5), ft(-2), ft(110)]) cube([ft(10), ft(TOWER_D + 2), ft(7)]);
    }
}
module tower_glass() {
    x0 = TOWER[0]; w = TOWER[1] - TOWER[0];
    translate([ft(x0 + w/2 - 8), ft(1), ft(61)]) cube([ft(16), ft(0.3), ft(18)]);
    translate([ft(x0 + w/2 - 5), ft(0.5), ft(110)]) cube([ft(10), ft(0.3), ft(7)]);
    translate([ft(x0 + w/2 - 5), ft(TOWER_D - 2.6), ft(110)]) cube([ft(10), ft(0.3), ft(7)]);
}
module tower_stone() {
    x0 = TOWER[0]; x1 = TOWER[1]; w = x1 - x0;
    // banded stonework between 30 and 75 ft (the striped look on the drawings)
    for (z = [30 : 4 : 74])
        translate([ft(x0 - 0.3), ft(-1.3), ft(z)]) cube([ft(w + 0.6), ft(TOWER_D + 0.6), ft(1)]);
    // cornice at the top of masonry and under the clock stage
    for (z = [96, 120, TOWER_TOP - 1.5])
        translate([ft(x0 - 0.8), ft(-1.8), ft(z)]) cube([ft(w + 1.6), ft(TOWER_D + 1.6), ft(1.5)]);
    // balcony in the great arch
    translate([ft(x0 + w/2 - 8), ft(-3.5), ft(60)]) cube([ft(16), ft(3), ft(3.5)]);
    // clock faces on all four sides, ~125 ft
    for (a = [0, 90, 180, 270])
        translate([ft(x0 + w/2), ft(TOWER_D/2 - 1), ft(127)]) rotate([0, 0, a])
            translate([0, -ft(TOWER_D/2 + 0.3), 0]) rotate([90, 0, 0]) cylinder(r = ft(5.5), h = ft(0.4), $fn = 48);
}
module tower_metal() {
    x0 = TOWER[0]; w = TOWER[1] - TOWER[0];
    // clock hands (set to 10 past 10) and dark dial ring
    for (a = [0, 90, 180, 270])
        translate([ft(x0 + w/2), ft(TOWER_D/2 - 1), ft(127)]) rotate([0, 0, a])
            translate([0, -ft(TOWER_D/2 + 0.8), 0]) rotate([90, 0, 0]) {
                rotate([0,0,-60]) translate([-ft(0.2), 0, 0]) cube([ft(0.4), ft(4.5), ft(0.2)]);
                rotate([0,0, 60]) translate([-ft(0.2), 0, 0]) cube([ft(0.4), ft(3.2), ft(0.2)]);
            }
    // finial and weather vane to 189 ft
    translate([ft(x0 + w/2), ft(TOWER_D/2 - 1), ft(166)]) cylinder(r = ft(0.4), h = ft(23));
    translate([ft(x0 + w/2 - 3), ft(TOWER_D/2 - 1), ft(185)]) cube([ft(6), ft(0.2), ft(1.5)]);
    // cresting ring at the top of the pyramid
    translate([ft(x0 + w/2), ft(TOWER_D/2 - 1), ft(163)]) cylinder(r = ft(3), h = ft(3), $fn = 16);
}
module tower_roof() {
    x0 = TOWER[0]; x1 = TOWER[1]; w = x1 - x0;
    // steep pyramid, 140 -> 166 ft
    hull() {
        translate([ft(x0 + 1), ft(0), ft(TOWER_TOP)]) cube([ft(w - 2), ft(TOWER_D - 2), ft(0.5)]);
        translate([ft(x0 + w/2), ft(TOWER_D/2 - 1), ft(166)]) cylinder(r = ft(0.6), h = ft(0.5));
    }
    // corner turrets with conical caps to 150 ft
    for (dx = [1.5, w - 1.5], dy = [0.5, TOWER_D - 2.5])
        translate([ft(x0 + dx), ft(dy), ft(122)]) cylinder(r1 = ft(2.2), r2 = 0, h = ft(28), $fn = 8);
}
module tower_turret_shafts() {
    x0 = TOWER[0]; w = TOWER[1] - TOWER[0];
    for (dx = [1.5, w - 1.5], dy = [0.5, TOWER_D - 2.5])
        translate([ft(x0 + dx), ft(dy), ft(104)]) cylinder(r = ft(2), h = ft(18), $fn = 8);
}

// ----------------- whole depot -----------------
BLOCKS = [WEST_WING, WEST_LINK, WEST_GABLE, CTR_WEST, CTR_EAST, EAST_GABLE, EAST_LINK, EAST_WING];
CHIMNEYS = [[56, 20, 82], [119, 20, 82], [201, 20, 82], [230, 42, 82], [265, 20, 82]];

module depot() {
    grp("r_brick", C_BRICK) difference() {
      union() {
        for (b = BLOCKS) walls(b[0], b[1], b[2]);
        walls(TOWER[0], TOWER[1], EAVE);   // main block behind the tower (track side)
        tower_masonry();
        tower_turret_shafts();
        for (c = CHIMNEYS) chimney(c[0], c[1], c[2]);
        stepped_gable(WEST_GABLE[0], WEST_GABLE[1], EAVE, 77);
        stepped_gable(EAST_GABLE[0], EAST_GABLE[1], EAVE, 77);
        // end-wing cross gables on the street face
        stepped_gable(13, 33, 31, 55);
        stepped_gable(285, 305, 31, 55);
        // roof dormers, street and track side
        for (cx = [108, 133, 189, 214]) {
            dormer(cx, 4, EAVE - 2, EAVE + 13, 7, true);
            dormer(cx, D - 4, EAVE - 2, EAVE + 13, 7, false);
        }
        for (cx = [6, 40, 278, 315]) dormer(cx, 4, 29, 41, 5, true);
      }
      entrance_cuts();
      // v2: open the whole ground floor (block end walls and the solid tower base go);
      // the plan's partitions are drawn in interior().
      if (SHOW_INTERIOR) {
        translate([ft(WALL_T), ft(WALL_T), ft(FLOOR1)]) cube([ft(L - 2*WALL_T), ft(D - 2*WALL_T), ft(CEIL - FLOOR1)]);
        // tower vestibule behind the entrance arches
        translate([ft(TOWER[0] + 2.5), ft(1.5), ft(FLOOR1)]) cube([ft(TOWER[1] - TOWER[0] - 5), ft(TOWER_D), ft(CEIL - FLOOR1)]);
      }
    }
    grp("r_stone", C_STONE) {
        for (b = BLOCKS) stone_bands(b[0], b[1], b[2]);
        tower_stone();
        // street entrance steps at the tower
        for (i = [0 : 4]) translate([ft(TOWER[0] + 2), ft(-3 - i), ft(i)]) cube([ft(30), ft(1.2), ft(1)]);
    }
    grp("r_glass", C_GLASS) {
        for (b = BLOCKS) glazing(b[0], b[1], b[2]);
        tower_glass();
        for (g = [[77, 58], [243.5, 58], [23, 38], [295, 38]]) gable_window(g[0], g[1], 8, 7);
    }
    grp("r_roof", C_ROOF) {
        hip_roof(WEST_WING[0], WEST_WING[1], WEST_WING[2], WEST_WING[3]);
        hip_roof(EAST_WING[0], EAST_WING[1], EAST_WING[2], EAST_WING[3]);
        hip_roof(WEST_LINK[0], WEST_LINK[1], WEST_LINK[2], WEST_LINK[3]);
        hip_roof(EAST_LINK[0], EAST_LINK[1], EAST_LINK[2], EAST_LINK[3]);
        // long main roof over the centre, gable blocks carry cross gables
        hull() {
            translate([ft(CTR_WEST[0] - 1.5), ft(-1.5), ft(EAVE)]) cube([ft(CTR_EAST[1] - CTR_WEST[0] + 3), ft(D + 3), ft(0.5)]);
            translate([ft(CTR_WEST[0] + 6), ft(D/2 - 0.25), ft(RIDGE)]) cube([ft(CTR_EAST[1] - CTR_WEST[0] - 12), ft(0.5), ft(0.5)]);
        }
        cross_gable(WEST_GABLE[0], WEST_GABLE[1], EAVE, 77);
        cross_gable(EAST_GABLE[0], EAST_GABLE[1], EAVE, 77);
        tower_roof();
    }
    grp("r_metal", C_METAL) {
        tower_metal();
        spire(23, D/2, 50, 94, 2);
        spire(295, D/2, 50, 94, 2);
        // roof cresting along the main ridge
        translate([ft(CTR_WEST[0] + 6), ft(D/2 - 0.15), ft(RIDGE + 0.5)]) cube([ft(CTR_EAST[1] - CTR_WEST[0] - 12), ft(0.3), ft(1.5)]);
    }
}

// ================= train shed =================
SHED_Y0   = D + 11;   // street edge of the shed (EST gap with a low connecting roof)
SHED_W    = 100;      // over the eaves
POST_IN   = 13;       // cantilever beyond each row of columns
SHED_EAVE = 23;
SHED_RIDGE = 34;
MON_TOP   = 42;
BAY       = 25;       // (EST) column spacing along the shed

module shed() {
    y_a = SHED_Y0 + POST_IN;
    y_b = SHED_Y0 + SHED_W - POST_IN;
    ym  = SHED_Y0 + SHED_W/2;
    nb  = floor(SHED_LEN_FT / BAY);
    grp("r_metal", C_METAL) {
        // columns and arched trusses
        for (i = [0 : nb]) {
            x = i * BAY;
            for (y = [y_a, y_b]) translate([ft(x), ft(y), 0]) cylinder(r = ft(0.6), h = ft(SHED_EAVE));
            // truss: bottom chord as a shallow arch from post to post + rafters
            for (k = [0 : 7]) {
                t0 = k / 8; t1 = (k + 1) / 8;
                hull() {
                    translate([ft(x), ft(y_a + (y_b - y_a) * t0), ft(SHED_EAVE - 2 + 7 * sin(180 * t0))]) sphere(r = ft(0.35), $fn = 8);
                    translate([ft(x), ft(y_a + (y_b - y_a) * t1), ft(SHED_EAVE - 2 + 7 * sin(180 * t1))]) sphere(r = ft(0.35), $fn = 8);
                }
            }
            // curved brackets at each column
            for (y = [y_a, y_b], s = [-1, 1])
                hull() {
                    translate([ft(x), ft(y), ft(SHED_EAVE - 6)]) sphere(r = ft(0.3), $fn = 8);
                    translate([ft(x), ft(y + s * 6), ft(SHED_EAVE)]) sphere(r = ft(0.3), $fn = 8);
                }
        }
    }
    grp("r_roof", C_ROOF) {
        // two roof slopes and the monitor (clerestory) on top
        for (s = [0, 1]) {
            y0 = s == 0 ? SHED_Y0 : ym;
            y1 = s == 0 ? ym : SHED_Y0 + SHED_W;
            z0 = s == 0 ? SHED_EAVE : SHED_RIDGE;
            z1 = s == 0 ? SHED_RIDGE : SHED_EAVE;
            hull() {
                translate([0, ft(y0), ft(z0)]) cube([ft(SHED_LEN_FT), ft(0.1), ft(0.6)]);
                translate([0, ft(y1), ft(z1)]) cube([ft(SHED_LEN_FT), ft(0.1), ft(0.6)]);
            }
        }
        hull() {
            translate([0, ft(ym - 6), ft(MON_TOP - 1)]) cube([ft(SHED_LEN_FT), ft(12), ft(0.5)]);
            translate([0, ft(ym - 0.2), ft(MON_TOP)]) cube([ft(SHED_LEN_FT), ft(0.4), ft(0.5)]);
        }
        // low connecting roof between the depot and the shed
        translate([0, ft(D), ft(SHED_EAVE - 1)]) cube([ft(SHED_LEN_FT), ft(SHED_Y0 - D + 1), ft(0.6)]);
    }
    grp("r_glass", C_GLASS) {
        // monitor side glazing
        for (y = [ym - 6, ym + 5.7]) translate([0, ft(y), ft(SHED_RIDGE)]) cube([ft(SHED_LEN_FT), ft(0.3), ft(MON_TOP - SHED_RIDGE - 1)]);
    }
    grp("r_brick", C_BRICK) {
        // monitor end posts
        for (i = [0 : nb]) for (y = [ym - 6, ym + 6])
            translate([ft(i * BAY), ft(y), ft(SHED_RIDGE - 1)]) cylinder(r = ft(0.4), h = ft(MON_TOP - SHED_RIDGE));
    }
}

// ================= ground, platforms, track =================
TRACKS = 5;   // five tracks under the shed on the end elevation (#2)
module ground() {
    ym = SHED_Y0 + SHED_W/2;
    grp("r_ground", C_GRND) {
        translate([ft(-40), ft(-60), ft(-1)]) cube([ft(L + 80), ft(SHED_Y0 + SHED_W + 100), ft(1)]);
        // platforms between tracks (EST spacing, 18 ft track centres)
        for (i = [0 : TRACKS]) {
            y = ym + (i - TRACKS/2) * 18;
            translate([0, ft(y - 4), 0]) cube([ft(SHED_LEN_FT), ft(8), ft(1)]);
        }
    }
    grp("r_metal", C_METAL) {
        for (i = [0 : TRACKS - 1]) {
            yc = ym + (i - (TRACKS - 1)/2) * 18;
            for (r = [-2.35, 2.35])
                translate([ft(-40), ft(yc + r - 0.12), 0]) cube([ft(SHED_LEN_FT + 80), ft(0.24), ft(0.5)]);
        }
    }
}

depot();
porch();
tower_entrance();
if (SHOW_INTERIOR) interior();
if (SHOW_SHED) shed();
if (SHOW_GROUND) ground();

// ================= v2: entrances, porch, date panels =================
// Openings from the first floor plan (sheet 06). x in ft from the west end.
STREET_DOORS = [[183, 195], [285, 293], [300, 308]];   // ladies' entrance (EST), baggage doors (sheet 07)
TRACK_DOORS  = [[150, 172], [285, 293], [300, 308]];   // open vestibule, baggage doors (sheet 07)
TCX = (TOWER[0] + TOWER[1]) / 2;     // tower centre line, ft
ARCH_X = [-9, 0, 9]; ARCH_W = 7; ARCH_H = 14.5;   // triple entrance arches (sheet 10, EST sizes)
VEST_Y = 8;                                        // inner (waiting-room) wall of the tower vestibule
module tri_arch_cut(y0, depth) {
    for (dx = ARCH_X) {
        translate([ft(TCX + dx - ARCH_W/2), ft(y0), ft(FLOOR1)]) cube([ft(ARCH_W), ft(depth), ft(ARCH_H - ARCH_W/2)]);
        translate([ft(TCX + dx), ft(y0 + depth), ft(FLOOR1 + ARCH_H - ARCH_W/2)]) rotate([90, 0, 0]) cylinder(r = ft(ARCH_W/2), h = ft(depth), $fn = 40);
    }
}
module entrance_cuts() {
    tri_arch_cut(-4, 7);       // through the tower front and the main wall behind it
    // twin round-arched windows under the "18 86" tympana (1942-07-14 photo)
    for (dx = [-5, 5]) {
        translate([ft(TCX + dx - 2.6), ft(-3), ft(34)]) cube([ft(5.2), ft(6), ft(8)]);
    }
    for (d = STREET_DOORS) translate([ft(d[0]), ft(-3), ft(FLOOR1)]) cube([ft(d[1]-d[0]), ft(6), ft(14)]);
    for (d = TRACK_DOORS)  translate([ft(d[0]), ft(D - 3), ft(FLOOR1)]) cube([ft(d[1]-d[0]), ft(6), ft(14)]);
}

// Street porch over the passage entrance: turned wood posts, iron brackets, flat roof
// (1941-10-20 A photo). Size and post spacing are best guesses.
module porch() {
    x0 = 176; x1 = 246; dep = 14; h = 17;   // longer, per the 1941 photo (EST)
    grp("r_metal", C_METAL) {
        for (x = [x0 + 1 : 5 : x1 - 1]) {
            translate([ft(x), ft(-dep + 1), ft(FLOOR1)]) {
                cylinder(r = ft(0.45), h = ft(h - FLOOR1));
                for (z = [3, 6, 9]) translate([0, 0, ft(z)]) sphere(r = ft(0.6), $fn = 12);   // turnings
            }
            // curved iron bracket under the roof edge
            hull() {
                translate([ft(x), ft(-dep + 1), ft(h - 4)]) sphere(r = ft(0.15), $fn = 6);
                translate([ft(x), ft(-dep + 4), ft(h - 0.3)]) sphere(r = ft(0.15), $fn = 6);
            }
        }
        // cresting rail on the porch roof
        translate([ft(x0), ft(-dep), ft(h + 0.8)]) cube([ft(x1 - x0), ft(0.2), ft(1.2)]);
    }
    grp("r_roof", C_ROOF) hull() {   // shallow lean-to roof sloping to the street
        translate([ft(x0 - 1), ft(-0.5), ft(h + 3)]) cube([ft(x1 - x0 + 2), ft(0.5), ft(0.6)]);
        translate([ft(x0 - 1), ft(-dep - 0.5), ft(h)]) cube([ft(x1 - x0 + 2), ft(0.5), ft(0.6)]);
    }
    // iron fretwork gable at the west end (photo): a pierced triangle
    grp("r_metal", C_METAL) translate([ft(x0 - 0.8), 0, 0]) rotate([90, 0, 90]) linear_extrude(ft(0.15)) difference() {
        polygon([[ft(-dep - 0.5), ft(h - 3)], [ft(-0.5), ft(h - 3)], [ft(-0.5), ft(h + 3)], [ft(-dep - 0.5), ft(h)]]);
        for (i = [0 : 5]) translate([ft(-dep + 1 + i * 2.2), ft(h - 1.4)]) circle(r = ft(0.75), $fn = 12);
        for (i = [0 : 5]) translate([ft(-dep + 2.1 + i * 2.2), ft(h - 2.6)]) circle(r = ft(0.35), $fn = 8);
    }
    grp("r_stone", C_STONE) for (i = [0 : 4]) translate([ft(x0), ft(-dep - 4 + i), ft(i)]) cube([ft(x1 - x0), ft(4.5 - i), ft(1)]);
}

// "18" and "86" tympana over the twin windows of the tower front (1942-07-14 B photo)
module date_panels() {
    cx = (TOWER[0] + TOWER[1]) / 2;
    for (s = [[-5, "18"], [5, "86"]]) {
        translate([ft(cx + s[0]), ft(-1.4), ft(44)]) rotate([90, 0, 0]) {
            difference() { circle(r = ft(3.6)); translate([-ft(4), -ft(4)]) square([ft(8), ft(4)]); }
        }
    }
}
module date_panels_3d() {
    cx = (TOWER[0] + TOWER[1]) / 2;
    grp("r_stone", C_STONE) for (s = [-5, 5]) translate([ft(cx + s), ft(-1.0), ft(44)]) rotate([90, 0, 0])
        linear_extrude(ft(0.6)) difference() { circle(r = ft(3.6)); translate([-ft(4), -ft(4)]) square([ft(8), ft(4)]); }
    grp("r_metal", C_METAL) for (s = [[-5, "18"], [5, "86"]]) translate([ft(cx + s[0]), ft(-1.6), ft(45.2)]) rotate([90, 0, 0])
        linear_extrude(ft(0.3)) text(s[1], size = ft(2.2), halign = "center", font = "Liberation Serif:style=Bold");
}

// ================= v4: 1886 ground floor from SHEET 07 (the 1886 "First Story Plan") =================
// v2/v3 used sheet 06, a later re-plan; v4 follows sheet 07. Plan y is measured from the track
// wall; model y = D - plan y. Finishes are best guesses after Mix's other work (carved woodwork,
// stained glass, inlaid tile, frescoed ceilings) and Tom's pre-1940 photos.
CEIL  = FLOOR1 + 21;     // ground-floor ceiling (EST)
CEIL2 = 44;              // second-floor ceiling over the grand hall (EST)
WAIN  = 5;
function py(v) = D - v;  // plan y (from track wall) -> model y
// cross walls [x, y0, y1] (model y)
XWALLS = [[50.5, 2, 60], [70, 2, 60], [90, 2, 60], [145.5, 2, 60], [176.5, 2, 60],
          [199, 2, 22], [199, 40, 60], [257.5, 2, 60], [270, 2, 60]];
// arched doorways through them [x, y0, y1]
XDOORS = [[50.5, 26, 36], [70, 28, 34], [90, 26, 36], [145.5, 24, 30], [145.5, 40, 46],
          [176.5, 24, 30], [176.5, 40, 46], [257.5, 44, 50], [270, 27, 35]];
// longitudinal walls [x0, x1, y]
YWALLS = [[50.5, 70, py(17)], [50.5, 70, py(45)], [199, 257.5, py(28)], [90, 133, py(16)], [257.5, 270, py(37)]];
YDOORS = [[60, py(17)], [60, py(45)], [228, py(28)], [112, py(16)], [264, py(37)]];
// grand hall: open to the second floor, balcony round the well (sheets 07 and 08)
HALL  = [146, 176];
WELL  = [150, 172, py(31), py(8)];   // x0, x1, y0, y1 of the opening in the second floor

module arch_hole(w, h) {
    translate([-w/2, -1, 0]) cube([w, 2, h - w/2]);
    translate([0, 1, h - w/2]) rotate([90, 0, 0]) cylinder(r = w/2, h = 2, $fn = 32);
}
module interior() {
    grp("r_floor", C_FLOOR) {
        translate([ft(2), ft(2), ft(FLOOR1 - 0.6)]) cube([ft(L - 4), ft(D - 4), ft(0.6)]);
        for (r = [[2, 50], [146, 176], [199, 257]]) for (y = [4, D - 6])
            translate([ft(r[0]), ft(y), ft(FLOOR1)]) cube([ft(r[1] - r[0]), ft(1.5), ft(0.04)]);
        // grand hall: inlaid star in the floor (Mitchell-house style inlay, EST)
        translate([ft(161), ft(31), ft(FLOOR1)]) cylinder(r = ft(7), h = ft(0.05), $fn = 8);
        // balcony floor at the second floor
        translate([ft(HALL[0]), ft(py(36)), ft(CEIL)]) difference() {
            cube([ft(HALL[1] - HALL[0]), ft(36 - 2), ft(0.3)]);
            translate([ft(WELL[0] - HALL[0]), ft(WELL[2] - py(36)), -1]) cube([ft(WELL[1] - WELL[0]), ft(WELL[3] - WELL[2]), ft(1) + 2]);
        }
    }
    grp("r_plaster", C_PLAST) {
        // ground-floor ceiling, with the grand-hall well left open
        difference() {
            translate([ft(2), ft(2), ft(CEIL)]) cube([ft(L - 4), ft(D - 4), ft(1)]);
            translate([ft(WELL[0]), ft(WELL[2]), ft(CEIL) - 1]) cube([ft(WELL[1] - WELL[0]), ft(WELL[3] - WELL[2]), ft(1) + 2]);
        }
        difference() {
            union() {
                for (w = XWALLS) translate([ft(w[0] - 0.6), ft(w[1]), ft(FLOOR1)]) cube([ft(1.2), ft(w[2] - w[1]), ft(CEIL - FLOOR1)]);
                for (w = YWALLS) translate([ft(w[0]), ft(w[2] - 0.5), ft(FLOOR1)]) cube([ft(w[1] - w[0]), ft(1), ft(w[0] == 90 ? 9 : CEIL - FLOOR1)]);   // lunch-room screen is low
                // ticket office island (plan x 178-198, plan y 22-38)
                translate([ft(178), ft(py(38)), ft(FLOOR1)]) difference() {
                    cube([ft(20), ft(16), ft(12)]);
                    translate([ft(0.8), ft(0.8), -1]) cube([ft(18.4), ft(14.4), ft(14)]);
                    for (y = [3, 9]) translate([ft(-1), ft(y), ft(3.5)]) cube([ft(22), ft(3), ft(3.5)]);   // windows both ends
                }
                // grand hall upper walls round the balcony, up to the hall ceiling
                for (x = [HALL[0] - 0.6, HALL[1] - 0.6]) translate([ft(x), ft(py(36)), ft(CEIL)]) cube([ft(1.2), ft(36 - 2), ft(CEIL2 - CEIL)]);
                translate([ft(HALL[0]), ft(py(36) - 0.6), ft(CEIL)]) cube([ft(HALL[1] - HALL[0]), ft(1.2), ft(CEIL2 - CEIL)]);
                // hall ceiling with a lay-light
                difference() {
                    translate([ft(HALL[0]), ft(py(36)), ft(CEIL2)]) cube([ft(HALL[1] - HALL[0]), ft(36 - 2), ft(1)]);
                    translate([ft(WELL[0] + 3), ft(WELL[2] + 3), ft(CEIL2) - 1]) cube([ft(WELL[1] - WELL[0] - 6), ft(WELL[3] - WELL[2] - 6), ft(1) + 2]);
                }
            }
            for (d = XDOORS) translate([ft(d[0]), ft((d[1] + d[2]) / 2), ft(FLOOR1)]) rotate([0, 0, 90]) arch_hole(ft(d[2] - d[1]), ft(12));
            for (d = YDOORS) translate([ft(d[0]), ft(d[1]), ft(FLOOR1)]) arch_hole(ft(6), ft(10));
        }
    }
    grp("r_stained", C_STAIN) {
        // lay-light over the grand hall (EST)
        translate([ft(WELL[0] + 3), ft(WELL[2] + 3), ft(CEIL2 + 0.4)]) cube([ft(WELL[1] - WELL[0] - 6), ft(WELL[3] - WELL[2] - 6), ft(0.1)]);
        // stained-glass transoms over the ground-floor windows
        for (bk = concat(BLOCKS, [[TOWER[0], TOWER[1], EAVE, 0]])) {
            bay = 11; n = floor((bk[1] - bk[0] - 4) / bay); off = (bk[1] - bk[0] - n * bay) / 2;
            if (n > 0) for (i = [0 : n - 1]) for (y = [1.2, D - 1.5]) {
                cx = bk[0] + off + bay * (i + 0.5);
                translate([ft(cx), ft(y), ft(FLOOR1 + 16)]) rotate([90, 0, 0]) cylinder(r = ft(2.4), h = ft(0.15), $fn = 24);
            }
        }
    }
    grp("r_wood", C_WOOD) {
        for (r = [[2, 50], [90, 145], [146, 176], [199, 257], [270, 317]]) for (y = [2, D - 2.4])
            translate([ft(r[0]), ft(y), ft(FLOOR1)]) cube([ft(r[1] - r[0]), ft(0.4), ft(WAIN)]);
        for (r = [[2, 50], [90, 145], [199, 257]]) for (y = [2.2, D - 2.6])
            translate([ft(r[0]), ft(y), ft(FLOOR1 + 15.8)]) cube([ft(r[1] - r[0]), ft(0.4), ft(0.5)]);
        // balcony rail round the well, carved balusters as a solid band with piercings (EST)
        translate([ft(WELL[0]), ft(WELL[2]), ft(CEIL + 0.3)]) difference() {
            cube([ft(WELL[1] - WELL[0]), ft(WELL[3] - WELL[2]), ft(3.4)]);
            translate([ft(0.5), ft(0.5), -1]) cube([ft(WELL[1] - WELL[0] - 1), ft(WELL[3] - WELL[2] - 1), ft(6)]);
            for (x = [WELL[0] + 1 : 1.2 : WELL[1] - 1]) translate([ft(x - WELL[0]), -1, ft(0.6)]) cube([ft(0.6), ft(40), ft(2.3)]);
            for (y = [WELL[2] + 1 : 1.2 : WELL[3] - 1]) translate([-1, ft(y - WELL[2]), ft(0.6)]) cube([ft(40), ft(0.6), ft(2.3)]);
        }
        // balcony edge fascia
        translate([ft(WELL[0] - 0.3), ft(WELL[2] - 0.3), ft(CEIL - 1.4)]) difference() {
            cube([ft(WELL[1] - WELL[0] + 0.6), ft(WELL[3] - WELL[2] + 0.6), ft(1.4)]);
            translate([ft(0.6), ft(0.6), -1]) cube([ft(WELL[1] - WELL[0] - 0.6), ft(WELL[3] - WELL[2] - 0.6), ft(4)]);
        }
        // grand stair (plan x 178-188, plan y 1-17, track side), up to the balcony level
        for (i = [0 : 13]) translate([ft(179), ft(py(16) + i * 0.9), ft(FLOOR1 + i * 0.72)]) cube([ft(5), ft(0.9), ft(0.72)]);
        for (i = [0 : 13]) translate([ft(185), ft(D - 3 - i * 0.9), ft(FLOOR1 + 10.1 + i * 0.72)]) cube([ft(5), ft(0.9), ft(0.72)]);
        translate([ft(179), ft(D - 3), ft(FLOOR1 + 10.1)]) cube([ft(11), ft(1.5), ft(0.6)]);
        // news and cigar counter
        translate([ft(190), ft(py(12)), ft(FLOOR1)]) cube([ft(8), ft(2.5), ft(3.6)]);
        // ticket counter
        translate([ft(177.5), ft(py(38) - 0.5), ft(FLOOR1)]) difference() { cube([ft(21), ft(17), ft(3.6)]); translate([ft(1.2), ft(1.2), -1]) cube([ft(18.6), ft(14.6), ft(6)]); }
        // lunch counter (plan y 8-12, x 95-140) with stools on the track side
        translate([ft(95), ft(py(11)), ft(FLOOR1)]) cube([ft(44), ft(2.5), ft(3.4)]);
        for (x = [97 : 3 : 137]) translate([ft(x), ft(py(6)), ft(FLOOR1)]) { cylinder(r = ft(0.15), h = ft(2.2)); translate([0, 0, ft(2.2)]) cylinder(r = ft(0.7), h = ft(0.25)); }
        // dining room: round tables, four chairs each
        for (x = [100 : 11 : 136]) for (y = [12, 22, 32]) translate([ft(x), ft(y), ft(FLOOR1)]) {
            cylinder(r = ft(0.25), h = ft(2.4)); translate([0, 0, ft(2.4)]) cylinder(r = ft(2.2), h = ft(0.15), $fn = 32);
            for (a = [0 : 90 : 270]) rotate([0, 0, a]) translate([ft(3), -ft(0.7), 0]) { cube([ft(1.4), ft(1.4), ft(1.5)]); translate([ft(1.2), 0, 0]) cube([ft(0.2), ft(1.4), ft(3.2)]); }
        }
        // checking-baggage counter and baggage trucks
        translate([ft(258.5), ft(py(25)), ft(FLOOR1)]) cube([ft(2.5), ft(14), ft(3.6)]);
        for (b = [[280, 20], [292, 34], [305, 18], [300, 46]]) translate([ft(b[0]), ft(b[1]), ft(FLOOR1)]) {
            translate([0, 0, ft(1.4)]) cube([ft(9), ft(3), ft(0.3)]);
            for (x = [1.5, 7.5]) for (y = [0, 3]) translate([ft(x), ft(y), ft(0.8)]) rotate([90, 0, 0]) cylinder(r = ft(0.8), h = ft(0.25), center = true);
            translate([ft(-2.5), ft(1.5), ft(1.6)]) rotate([0, 70, 0]) cylinder(r = ft(0.08), h = ft(3));
        }
        for (b = BENCHES) bench(b[0], b[1], b[2]);
    }
    grp("r_metal", C_METAL) {
        for (c = COLUMNS) translate([ft(c[0]), ft(c[1]), ft(FLOOR1)]) {
            cylinder(r1 = ft(1.0), r2 = ft(0.75), h = ft(2.2), $fn = 16);
            for (a = [0 : 30 : 330]) rotate([0, 0, a]) translate([ft(0.5), 0, 0]) cylinder(r = ft(0.12), h = ft(CEIL - FLOOR1 - 2), $fn = 6);
            cylinder(r = ft(0.5), h = ft(CEIL - FLOOR1 - 2), $fn = 16);
            translate([0, 0, ft(CEIL - FLOOR1 - 2.6)]) cylinder(r1 = ft(0.6), r2 = ft(1.4), h = ft(2.6), $fn = 16);
        }
        for (c = LAMPS) translate([ft(c[0]), ft(c[1]), ft(CEIL - 7)]) cylinder(r = ft(0.06), h = ft(7), $fn = 6);
        // grand-hall chandelier on a long drop from the lay-light
        translate([ft(161), ft(31), ft(CEIL - 2)]) { cylinder(r = ft(0.1), h = ft(CEIL2 - CEIL + 2)); for (a = [0 : 45 : 315]) rotate([0, 0, a]) translate([0, 0, 0]) rotate([0, 80, 0]) cylinder(r = ft(0.08), h = ft(4)); }
        for (x = [179 : 4 : 197]) translate([ft(x), ft(py(38) - 0.6), ft(FLOOR1 + 3.6)]) for (g = [0 : 0.5 : 3]) translate([ft(g), 0, 0]) cube([ft(0.05), ft(0.1), ft(3.5)]);
    }
    grp("r_lamp", C_LAMP) {
        for (c = LAMPS) translate([ft(c[0]), ft(c[1]), ft(CEIL - 7.6)]) sphere(r = ft(0.9), $fn = 16);
        for (a = [0 : 45 : 315]) rotate([0, 0, 0]) translate([ft(161 + 3.9 * cos(a)), ft(31 + 3.9 * sin(a)), ft(CEIL - 1.4)]) sphere(r = ft(0.6), $fn = 12);
    }
    grp("r_wood", C_WOOD) for (r = [[90, 145], [199, 257], [2, 50]]) {
        for (x = [r[0] + 6 : 8 : r[1] - 2]) translate([ft(x), ft(2), ft(CEIL - 1.4)]) cube([ft(0.9), ft(D - 4), ft(1.4)]);
        for (y = [12 : 12 : D - 8]) translate([ft(r[0]), ft(y), ft(CEIL - 1)]) cube([ft(r[1] - r[0]), ft(0.6), ft(1)]);
    }
    date_panels_3d();
}
// columns from sheet 07 (circles on the plan)
COLUMNS = [for (x = [20, 37]) for (v = [20, 42]) [x, py(v)],
           for (x = [117]) for (v = [24, 44]) [x, py(v)],
           for (x = [205, 222, 240]) for (v = [14, 46]) [x, py(v)],
           for (x = [287, 307]) for (v = [20, 42]) [x, py(v)]];
LAMPS   = [for (x = [8 : 12 : 46]) for (y = [14, 31, 48]) [x, y],
           for (x = [100 : 11 : 140]) for (y = [16, 36, 54]) [x, y],
           for (x = [206 : 12 : 252]) for (y = [12, 22, 40, 52]) [x, y],
           for (x = [280 : 14 : 312]) for (y = [16, 46]) [x, y]];
BENCHES = [for (y = [10, 16, 26, 36, 46, 52]) for (x = [6, 26]) [x, y, 15],               // emigrants' room
           for (y = [37, 43, 49, 55]) for (x = [203, 216, 232]) [x, y, 11],            // gentlemen's (track side)
           for (y = [7, 13, 19, 25]) for (x = [203, 216, 232]) [x, y, 11],             // ladies' (street side)
           [150, 20, 8], [164, 20, 8], [150, 44, 8], [164, 44, 8]];                    // grand hall
module bench(x0, y, len) {
    translate([ft(x0), ft(y), ft(FLOOR1)]) {
        translate([0, ft(-0.9), ft(1.4)]) cube([ft(len), ft(1.8), ft(0.15)]);
        translate([0, ft(-0.1), ft(1.4)]) cube([ft(len), ft(0.2), ft(2.4)]);
        for (x = [0, len / 2, len - 0.3]) translate([ft(x), ft(-1), 0]) cube([ft(0.3), ft(2), ft(3.6)]);
    }
}

// ================= v3: tower entrance (room 5) =================
// Outside: paired short polished-granite columns with carved capitals on the piers between
// the three arches (sheet 10). Inside: a shallow vestibule, then the waiting-room wall with
// three round-arched door openings, glazed door pairs, half-round stained fanlights, carved
// archivolts with rosette panels, flanked by tall polished granite columns (1942-03-12 photos,
// which show the 1886 work before the remodel). Sizes are best guesses.
C_GRAN = [0.36, 0.26, 0.24];   // polished red-brown granite
module column(h, r, cap = true) {
    cylinder(r = ft(r * 1.3), h = ft(0.8), $fn = 24);                  // base
    cylinder(r = ft(r), h = ft(h), $fn = 32);                          // polished shaft
    if (cap) translate([0, 0, ft(h - 0.2)]) {
        cylinder(r1 = ft(r), r2 = ft(r * 1.8), h = ft(r * 1.6), $fn = 24);   // carved bell (leaves EST)
        translate([-ft(r * 1.9), -ft(r * 1.9), ft(r * 1.6)]) cube([ft(r * 3.8), ft(r * 3.8), ft(0.6)]);
    }
}
module archivolt(cx, y, zc, r_in, w, t) {     // carved half-ring around an arch, rosettes on its face
    translate([ft(cx), ft(y), ft(zc)]) rotate([90, 0, 0]) difference() {
        cylinder(r = ft(r_in + w), h = ft(t), $fn = 48);
        translate([0, 0, -1]) cylinder(r = ft(r_in), h = ft(t) + 2, $fn = 48);
        translate([-ft(40), -ft(80), -1]) cube([ft(80), ft(80), ft(t) + 2]);
    }
}
module rosettes(cx, y, zc, r, n) {
    for (i = [0 : n]) { a = 180 * i / n;
        translate([ft(cx + r * cos(a)), ft(y), ft(zc + r * sin(a))]) rotate([90, 0, 0]) cylinder(r = ft(0.45), h = ft(0.25), $fn = 10);
    }
}
module tower_entrance() {
    zc = FLOOR1 + ARCH_H - ARCH_W/2;
    // outside piers: paired columns between and beside the arches
    grp("r_granite", C_GRAN) for (px = [-13, -4.5, 4.5, 13]) for (dx = [-0.9, 0.9])
        translate([ft(TCX + px + dx), ft(-2.2), ft(FLOOR1)]) column(9.6, 0.55);
    grp("r_stone", C_STONE) {
        for (px = [-13, -4.5, 4.5, 13]) translate([ft(TCX + px - 2), ft(-3.2), ft(FLOOR1 - 0.5)]) cube([ft(4), ft(2.4), ft(0.5)]);   // plinths
        for (dx = ARCH_X) archivolt(TCX + dx, -1.2, zc, ARCH_W/2, 1.2, 0.6);                                                       // outer arch rings
        for (px = [-13, -4.5, 4.5, 13]) translate([ft(TCX + px - 2), ft(-3.2), ft(FLOOR1 + 10.9)]) cube([ft(4), ft(2.4), ft(0.8)]);   // impost block on each pier
    }
    // inner waiting-room wall of the vestibule, with the three arched door openings
    grp("r_plaster", C_PLAST) difference() {
        translate([ft(TOWER[0] + 2.5), ft(VEST_Y), ft(FLOOR1)]) cube([ft(TOWER[1] - TOWER[0] - 5), ft(1.2), ft(CEIL - FLOOR1)]);
        tri_arch_cut(VEST_Y - 1, 3.5);
    }
    grp("r_stone", C_STONE) {
        for (dx = ARCH_X) archivolt(TCX + dx, VEST_Y + 1.9, zc, ARCH_W/2, 1.6, 0.7);   // carved archivolts, waiting-room face
        translate([ft(TOWER[0] + 2.5), ft(VEST_Y + 1.2), ft(CEIL - 2.2)]) cube([ft(TOWER[1] - TOWER[0] - 5), ft(0.6), ft(1.4)]);   // frieze
        for (x = [TOWER[0] + 3.5 : 1.5 : TOWER[1] - 3.5]) translate([ft(x), ft(VEST_Y + 2.0), ft(CEIL - 1.5)]) rotate([90, 0, 0]) cylinder(r = ft(0.4), h = ft(0.2), $fn = 10);
    }
    grp("r_metal", C_METAL) for (dx = ARCH_X) rosettes(TCX + dx, VEST_Y + 2.05, zc, ARCH_W/2 + 0.8, 8);
    // tall polished granite columns flanking the arch wall (photo), waiting-room side
    grp("r_granite", C_GRAN) for (x = [TOWER[0] + 1.2, TOWER[1] - 1.2]) translate([ft(x), ft(VEST_Y + 3), ft(FLOOR1)]) column(CEIL - FLOOR1 - 2.8, 1.1);
    // glazed door pairs and fanlights in each inner arch
    for (dx = ARCH_X) {
        grp("r_wood", C_WOOD) translate([ft(TCX + dx - ARCH_W/2), ft(VEST_Y + 0.4), ft(FLOOR1)]) difference() {
            cube([ft(ARCH_W), ft(0.4), ft(ARCH_H - ARCH_W/2)]);
            for (sx = [0.5, ARCH_W/2 + 0.25]) for (z = [3.5, 6.5]) translate([ft(sx), -1, ft(z)]) cube([ft(ARCH_W/2 - 0.75), ft(1) + 2, ft(2.6)]);   // glazed panels
            translate([ft(ARCH_W/2 - 0.05), -1, 0]) cube([ft(0.1), ft(1) + 2, ft(ARCH_H)]);   // meeting stiles gap
        }
        grp("r_glass", C_GLASS) for (sx = [0.5, ARCH_W/2 + 0.25]) for (z = [3.5, 6.5])
            translate([ft(TCX + dx - ARCH_W/2 + sx), ft(VEST_Y + 0.55), ft(FLOOR1 + z)]) cube([ft(ARCH_W/2 - 0.75), ft(0.05), ft(2.6)]);
        grp("r_stained", C_STAIN) translate([ft(TCX + dx), ft(VEST_Y + 0.6), ft(zc)]) rotate([90, 0, 0]) difference() {
            cylinder(r = ft(ARCH_W/2), h = ft(0.1), $fn = 40);
            translate([-ft(5), -ft(10), -1]) cube([ft(10), ft(10), ft(0.1) + 2]);
        }
        grp("r_wood", C_WOOD) translate([ft(TCX + dx - ARCH_W/2), ft(VEST_Y + 0.4), ft(zc - 0.3)]) cube([ft(ARCH_W), ft(0.5), ft(0.6)]);   // transom bar
    }
    // vestibule floor mat area: marble threshold
    grp("r_floor", C_FLOOR) translate([ft(TCX - 14), ft(-1), ft(FLOOR1)]) cube([ft(28), ft(VEST_Y + 1), ft(0.05)]);
}
