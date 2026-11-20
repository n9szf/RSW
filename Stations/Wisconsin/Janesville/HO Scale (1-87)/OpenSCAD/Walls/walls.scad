// =====================================================================
//  Walls  -  every exterior wall as a flat panel, printed exterior-face-up
//  Embossed brick (mortar grooves), rusticated bands, raised stone courses,
//  arched windows with brick arch ring + keystone, NeoPixel wire chases inside,
//  glue-in splice plates across section seams (pockets on the inside face).
//
//  Window / door positions come from the dimension strings on B2077
//  (centers in real feet from the left corner as seen from OUTSIDE the wall).
//  Heights from B2078 / B2079 / B2082.  Items marked APPROX are best reads.
//
//  wall_part(name, tile, bed)   tile -1 = whole panel, 0..n-1 = printable section
//  wall_place(name)             the panel standing in its place on the building
//  WALLS = list of panel names;  wall_count(name, bed) = sections for that bed
// =====================================================================
include <../janesville_common.scad>

// ---- settings when this file is opened directly ----
WALL  = "Main_town";   // one of WALLS
TILE  = -1;            // -1 whole panel (flat), 0..n-1 one section
VIEW  = "flat";        // "flat" = print orientation, "placed" = all walls on the building

// ---------- wall build settings ----------
// wall thicknesses T_MAIN / T_LIGHT are in janesville_common.scad
COURSE  = BX * ft(0, 2.667);   // brick course height (3 courses = 8")
BRICK_L = BX * ft(0, 8);       // brick length
MORTAR  = 0.42;           // groove width
MORTAR_D = 0.3;          // groove depth
RUST_W  = 0.6;  RUST_D = 0.5;  RUST_EVERY = 3;   // rusticated band grooves
STONE_RAISE = 0.4;        // stone courses stand proud of the brick
CHASE   = [2.4, 1.3];       // NeoPixel wire chase (width, depth) on inside face
$fn = 48;

// ---------- heights (real feet above finished floor) ----------
MAIN_H     = 19;          // floor to underside of cornice
SPRING     = 10.25;       // springing line of arched windows = stone belt course
SILL       = 2.75;        // window sill (B2082: floor to top of sill 2'-9")
LUNCH_H    = 10.5;        // lunch wing town side + east end: floor to eave
LUNCH_TRACK_H = 18.5;     // lunch wing TRACK side wall is tall and carries the platform canopy (B2082 / B2079)
BAG_H      = 11;          // APPROX baggage building floor to eave
PORCH_H    = 9;           // APPROX town-side pavilion projection
BAY_H      = 13;          // track-side ticket bay, up to canopy ceiling (13'-0")

// opening = [type, center_ft, width_ft, bottom_ft, top_ft]
//   "arch": rectangle bottom..top(=spring line) + semicircular head of radius width/2
//   "rect": plain rectangle (flat C.I. lintel)
function A(c, w, b = SILL, s = SPRING) = ["arch", c, w, b, s];
function R(c, w, b, t) = ["rect", c, w, b, t];
function D(c, w, t = 7.5) = ["rect", c, w, 0, t];
function V(c, w, b, t) = ["void", c, w, b, t];     // opening with no window/door insert (behind porch, bay, I-beam)

L_MAIN  = 98 + 1/12;            // 38'-9" + 22'-6" + 36'-10"
L_LUNCH = 30 + 4/12;
LUNCH_D = 25 + 4/12;
BAG_L   = 47 + 2/12;  BAG_D = 25 + 4/12;
PAV_W   = 22.5;
BAY_C   = 46 + 11/12;           // ticket-bay center from west end (B2077 track-side chain)

// ---------- wall table ----------
// [name, length_ft, height_ft, thickness, inset_ends(true = fits between long walls),
//  style ("main" / "plain"), openings, world origin [x_mm, y_mm], angle]
// Lengths are exterior-face lengths; inset walls are shortened by the long walls' thickness.
WALL_TABLE = [
  ["Main_track", L_MAIN, MAIN_H, T_MAIN, false, "main",
     [A(8.25, 7.5), A(20.25, 6, 0), A(32.25, 7.5),
      V(47.56, 14.22, 0, 11),                         // opening behind the ticket bay: from the east face of the
                                                      // waiting-room partition (40'-5") to the bay's east jamb (54'-8")
      A(57.75, 3, 0), A(68.08, 5.33, 0), A(79.67, 5.83), R(91.25, 4, 4.5, 9)],
     [0, 0], 0],
  ["Main_town", L_MAIN, MAIN_H, T_MAIN, false, "main",
     // seen from town: west is on the right, so centers are measured from the EAST end
     [R(L_MAIN - 91.25, 4, 4.5, 9), A(L_MAIN - 79.67, 5.83), A(L_MAIN - 68.08, 5.83),
      V(L_MAIN - 57.75, 5.5, 0, 8.5),                 // behind east porch block (vestibule)
      D(L_MAIN - 50, 5.67, 8),                        // vestibule doors in the recessed porch
      V(L_MAIN - 42.25, 5.5, 0, 8.5),                 // behind west porch block (women's toilet)
      A(L_MAIN - 32.25, 7.5), A(L_MAIN - 20.25, 7.5), A(L_MAIN - 8.25, 7.5)],
     [ft(L_MAIN), MAIN_DEPTH], 180],
  ["Main_west", 32, MAIN_H, T_MAIN, true, "main",
     [A(16, 7.5)],
     [0, MAIN_DEPTH], 270],
  ["Main_east", 32, MAIN_H, T_MAIN, true, "main",
     [V(8, 12, 0, 10)],                                // I-beam opening into the lunch room (B2077)
     [ft(L_MAIN), 0], 90],
  ["Lunch_track", L_LUNCH, LUNCH_TRACK_H, T_LIGHT, false, "plain",
     [R(6.75, 6, 2.5, 8.5), D(15.17, 5.67), R(23.58, 6, 2.5, 8.5)],
     [ft(L_MAIN), LUNCH_Y0], 0],
  ["Lunch_town", L_LUNCH, LUNCH_H, T_LIGHT, false, "plain",
     // from the east end
     [R(L_LUNCH - 23.58, 6, 2.5, 8.5), R(L_LUNCH - 15.17, 6, 2.5, 8.5),
      R(L_LUNCH - 8.08, 3, 3.5, 8.5), D(L_LUNCH - 3.08, 2.83)],
     [ft(L_MAIN + L_LUNCH), LUNCH_Y1], 180],
  ["Lunch_east", LUNCH_D, LUNCH_H, T_LIGHT, true, "plain",
     [R(7.17, 6, 2.5, 8.5), R(18.17, 6, 2.5, 8.5)],
     [ft(L_MAIN + L_LUNCH), LUNCH_Y0], 90],
  // town-side porch: two 6'-9" blocks projecting 3'-6", 9'-0" recessed porch between (B2077)
  ["Porch_block_E", 6.75, PORCH_H, T_LIGHT, false, "plain", [],
     [X_PAV_E, MAIN_DEPTH + PORCH_PROJ], 180],
  ["Porch_block_W", 6.75, PORCH_H, T_LIGHT, false, "plain",
     [R(3.375, 3, 2.75, 7.75)],                       // women's toilet window, APPROX size
     [X_PAV_W + ft(6.75), MAIN_DEPTH + PORCH_PROJ], 180],
  ["Porch_west", 3.5, PORCH_H, T_LIGHT, true, "plain", [],
     [X_PAV_W, MAIN_DEPTH + PORCH_PROJ], 270],
  ["Porch_east", 3.5, PORCH_H, T_LIGHT, true, "plain", [],
     [X_PAV_E, MAIN_DEPTH], 90],
  ["Porch_recess_W", 3.5, PORCH_H, T_LIGHT, true, "plain", [],          // recess side walls
     [X_PAV_W + ft(6.75), MAIN_DEPTH], 90],
  ["Porch_recess_E", 3.5, PORCH_H, T_LIGHT, true, "plain", [],
     [X_PAV_E - ft(6.75), MAIN_DEPTH + PORCH_PROJ], 270],
  // track-side canted ticket bay: front + two 45-degree sides
  ["Bay_front", 9.5, BAY_H, T_LIGHT, false, "plain",
     [R(4.75, 6, 2.75, 10)],
     [BAY_CX - BAY_W_FRONT / 2, -BAY_PROJ], 0],
  ["Bay_side_W", 4.24, BAY_H, T_LIGHT, false, "plain",
     [R(2.12, 1.5, 2.75, 10)],
     [BAY_CX - BAY_W_WALL / 2, 0], -45],
  ["Bay_side_E", 4.24, BAY_H, T_LIGHT, false, "plain",
     [R(2.12, 1.5, 2.75, 10)],
     [BAY_CX + BAY_W_FRONT / 2, -BAY_PROJ], 45],
  ["Baggage_track", BAG_L, BAG_H, T_LIGHT, false, "plain",
     [D(11.5, 6, 9), R(21.17, 4, 3, 8), D(36.83, 6, 9)],
     [X_BAG_W, BAG_Y0], 0],
  ["Baggage_town", BAG_L, BAG_H, T_LIGHT, false, "plain",
     [D(BAG_L - 36.83, 6, 9), R(BAG_L - 21.17, 4, 3, 8), D(BAG_L - 11.5, 6, 9)],
     [X_BAG_E, BAG_Y1], 180],
  ["Baggage_west", BAG_D, BAG_H, T_LIGHT, true, "plain",
     [R(BAG_D / 2, 3.5, 3, 8)],
     [X_BAG_W, BAG_Y1], 270],
  ["Baggage_east", BAG_D, BAG_H, T_LIGHT, true, "plain",
     [R(BAG_D / 2, 3.5, 3, 8)],
     [X_BAG_E, BAG_Y0], 90]
];

WALLS = [for (w = WALL_TABLE) w[0]];
function walls_list() = [for (w = WALL_TABLE) w[0]];   // for files that 'use' this one
function wrow(name) = WALL_TABLE[search([name], WALL_TABLE)[0]];
function w_len(r)   = ft(r[1]) - (r[4] ? 2 * r[3] : 0);     // mm, along the panel
function w_off(r)   = r[4] ? r[3] : 0;                       // mm, start inset
function w_h(r)     = ft(r[2]);
function wall_count(name, bed) = let(c = w_cuts(wrow(name), bed)) c[0] * c[1];

// ---------- 2D pieces (u = along wall from panel start, v = up from floor), mm ----------
module opening2d(o, off) {
    c = ft(o[1]) - off; w = ft(o[2]); b = ft(o[3]); t = ft(o[4]);
    translate([c - w / 2, b - (b == 0 ? 1 : 0)]) square([w, t - b + (b == 0 ? 1 : 0)]);
    if (o[0] == "arch") translate([c, t]) circle(d = w);
}
module openings2d(r) for (o = r[6]) opening2d(o, w_off(r));

module brick2d(L, H, v0, v1) {             // mortar joints between v0 and v1
    n0 = floor(v0 / COURSE); n1 = ceil(v1 / COURSE);
    intersection() {
        translate([0, v0]) square([L, v1 - v0]);
        union() for (i = [n0 : n1]) {
            translate([-1, i * COURSE - MORTAR / 2]) square([L + 2, MORTAR]);
            for (u = [(i % 2) * BRICK_L / 2 - BRICK_L : BRICK_L : L + BRICK_L])
                translate([u - MORTAR / 2, i * COURSE]) square([MORTAR, COURSE]);
        }
    }
}
module rust2d(L, v0, v1)                     // deep horizontal bands (rusticated brick)
    for (i = [ceil(v0 / COURSE / RUST_EVERY) : floor(v1 / COURSE / RUST_EVERY)])
        translate([-1, i * COURSE * RUST_EVERY - RUST_W / 2]) square([L + 2, RUST_W]);

// stone courses for the "main" style: [bottom_ft, top_ft]
STONES_MAIN  = [[0, 0.5], [SILL - 0.25, SILL + 0.25], [SPRING - 0.17, SPRING + 0.17]];
STONES_PLAIN = [[0, 0.5]];

module arch_ring2d(r) for (o = r[6]) if (o[0] == "arch") {      // raised brick arch ring
    c = ft(o[1]) - w_off(r); w = ft(o[2]); t = ft(o[4]);
    translate([c, t]) difference() { circle(d = w + 2 * ft(1)); circle(d = w); translate([-w, -w * 2]) square([w * 2, w * 2]); }
}
module keystone2d(r) for (o = r[6]) if (o[0] == "arch") {       // stone keystone
    c = ft(o[1]) - w_off(r); w = ft(o[2]); t = ft(o[4]);
    translate([c, t + w / 2 - ft(0, 2)]) polygon([[-ft(0, 7), 0], [ft(0, 7), 0], [ft(0, 9), ft(1, 6)], [-ft(0, 9), ft(1, 6)]]);
}
module arch_trim2d(r) { arch_ring2d(r); keystone2d(r); }

// ---------- the panel, flat: u -> x, v -> y, exterior face at z = T ----------
// Built as stacked 2D layers (fast in any OpenSCAD; the union is instant with Manifold).
SPLICE_W = 10; SPLICE_T = 0.8; SPLICE_CLEAR = 0.3;   // glue-in splice plates across seams

function w_cuts(r, bed) = let(L = w_len(r), H = w_h(r), nx = ceil(L / (bed[0] - 2)), ny = ceil(H / (bed[1] - 2)))
    [nx, ny, [for (i = [1 : max(1, nx - 1)]) if (nx > 1) i * L / nx], [for (j = [1 : max(1, ny - 1)]) if (ny > 1) j * H / ny]];
// Three printable bodies per wall so the mortar and stone can be a different filament (AMS):
//   brick  : layers 0-5   (wall body, raised brick arch rings)
//   mortar : layers 6-7   (white inlay in the bottom of every joint and rusticated band)
//   stone  : layer  8     (raised stone courses + keystones)
// Printed flat, brick face up, the colors only change in the top ~1 mm.
MORTAR_TOP = 0.12;          // mortar sits this far below the brick face
function w_zr(r, k) = let(T = r[3]) [
    [0, SPLICE_T], [SPLICE_T, CHASE[1]], [CHASE[1], T - RUST_D], [T - RUST_D, T - MORTAR_D],
    [T - MORTAR_D, T], [T, T + STONE_RAISE],
    [T - RUST_D, T - RUST_D + 0.2], [T - MORTAR_D, T - MORTAR_TOP],
    [T, T + STONE_RAISE]][k];
BODY_LAYERS = [["brick", [0, 1, 2, 3, 4, 5]], ["mortar", [6, 7]], ["stone", [8]]];
function body_layers(b) = BODY_LAYERS[search([b], BODY_LAYERS)[0]][1];
function splice_len(r) = w_h(r) - 10;

module stones2d(r, L) {
    stones = r[5] == "main" ? STONES_MAIN : STONES_PLAIN;
    for (s = stones) translate([-1, ft(s[0])]) square([L + 2, ft(s[1] - s[0])]);
}
module mortar_joints2d(r, L, H) difference() {                  // brick joints, not on stone/trim
    brick2d(L, H, 0, H);
    stones2d(r, L);
    if (r[5] == "main") arch_trim2d(r);
}

module region2d(name, k, bed) {
    r = wrow(name); L = w_len(r); H = w_h(r); main = r[5] == "main";
    cu = w_cuts(r, bed);
    module rust() if (main) rust2d(L, ft(SILL + 0.25), ft(SPRING - 0.17));
    intersection() {
        square([L, H]);
        difference() {
            union() {
                if (k <= 4 || k == 6 || k == 7) square([L, H]);
                if (k == 5 && main) difference() { arch_ring2d(r); keystone2d(r); }
                if (k == 8) { stones2d(r, L); if (main) keystone2d(r); }
            }
            openings2d(r);
            if (k <= 1) {                                        // wire chases (inside face)
                translate([1.5, -1]) square([CHASE[0], H + 2]);
                translate([L - 1.5 - CHASE[0], -1]) square([CHASE[0], H + 2]);
                translate([-1, H - 1.5 - CHASE[0]]) square([L + 2, CHASE[0]]);
            }
            if (k == 0) for (c = cu[2])                          // splice-plate pockets across seams
                translate([c - (SPLICE_W + SPLICE_CLEAR) / 2, 4]) square([SPLICE_W + SPLICE_CLEAR, splice_len(r) + SPLICE_CLEAR]);
            if (k == 3 || k == 4) rust();
            if (k == 4) mortar_joints2d(r, L, H);
            if (k == 6) difference() { square([L + 2, H + 2]); rust(); }      // mortar: rust bands only
            if (k == 7) difference() { square([L + 2, H + 2]); difference() { mortar_joints2d(r, L, H); rust(); } }
        }
    }
}

module wall_layer(name, k, tile = -1, bed = BED) {
    r = wrow(name); L = w_len(r); H = w_h(r); z = w_zr(r, k); cu = w_cuts(r, bed);
    nx = cu[0]; ny = cu[1]; xc = cu[2]; yc = cu[3];
    ix = tile < 0 ? 0 : tile % nx; iy = tile < 0 ? 0 : floor(tile / nx);
    x0 = (tile < 0 || ix == 0) ? -2 : xc[ix - 1]; x1 = (tile < 0 || ix == nx - 1) ? L + 2 : xc[ix];
    y0 = (tile < 0 || iy == 0) ? -2 : yc[iy - 1]; y1 = (tile < 0 || iy == ny - 1) ? H + 2 : yc[iy];
    translate([0, 0, z[0]]) linear_extrude(z[1] - z[0])
        intersection() { region2d(name, k, bed); translate([x0, y0]) square([x1 - x0, y1 - y0]); }
}

module wall_flat(name, bed = BED, body = "all")
    for (k = body == "all" ? [0 : 8] : body_layers(body)) wall_layer(name, k, -1, bed);

// ---------- printable sections ----------
module wall_part(name, tile = -1, bed = BED, body = "brick")
    for (k = body_layers(body)) wall_layer(name, k, tile, bed);

// splice plates for one wall, laid out side by side (glue across each vertical seam, inside face)
function splice_count(name, bed) = len(w_cuts(wrow(name), bed)[2]) * w_cuts(wrow(name), bed)[1];
module wall_splices(name, bed = BED) {
    r = wrow(name); n = splice_count(name, bed);
    for (i = [0 : max(0, n - 1)]) if (n > 0)
        translate([i * (SPLICE_W + 3), 0, 0]) cube([SPLICE_W, splice_len(r), SPLICE_T - 0.1]);
}

// ---------- the panel standing in place on the building ----------
module wall_place(name, body = "all") {
    r = wrow(name); T = r[3]; o = r[7]; a = r[8];
    translate([o[0], o[1], FLOOR_Z]) rotate([0, 0, a]) translate([w_off(r), 0, 0])
        rotate([90, 0, 0]) translate([0, 0, -T]) wall_flat(name, BED, body);
}

// runs only when this file is opened directly
LAYER = -1;            // cloud export helper: one layer only
if (VIEW == "placed") for (n = WALLS) { color(BRICK_RED) wall_place(n, "brick"); color(MORTAR_WHITE) wall_place(n, "mortar"); color(STONE_BUFF) wall_place(n, "stone"); }
else if (VIEW == "splices") wall_splices(WALL, BED);
else if (LAYER >= 0) wall_layer(WALL, LAYER, TILE, BED);
else { color(BRICK_RED) wall_part(WALL, TILE, BED, "brick");
       color(MORTAR_WHITE) wall_part(WALL, TILE, BED, "mortar");
       color(STONE_BUFF) wall_part(WALL, TILE, BED, "stone"); }
