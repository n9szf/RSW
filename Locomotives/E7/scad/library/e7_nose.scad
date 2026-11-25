// ==========================================================================
//  e7_nose.scad - the E7 "bulldog" nose and cab front (v2, 23 Nov 2026).
//  Built from the clean F-unit nose (export / Locomotives / EMD FP7 / scad /
//  fp7_nose_clean.scad, fitted to the RamBros Dragon F7 trace - CC BY, credit
//  RamBros), stretched to the E7 width and cab height and carried down to the
//  skirt.  The E7 and F-unit noses share the bulldog style but are not the same
//  part, so every value here is ESTIMATE until an E7/E8 drawing or photos of
//  E9 33C/37A are checked (TDQ-610, TDQ-638, TDQ-639).
//  v2.1 (23 Nov 2026): plan shape, windshield and roll-over refitted to Tom's
//  KIRI Engine scan of a MILW E unit model in UP paint (deck 145 in and
//  windshield slope already matched; face lean 0.10-0.15, kept 0.120).
//
//  Inches; local axes: u = across (0 = centre line), v = back from the nose tip,
//  w = height above rail.  Placed on the loco by e7_nose_place().
//  o = inward offset in inches (0 = outside skin; used to hollow the shell).
// ==========================================================================

// ---- shape settings (inches) ----
E7N_HW       = BODY_W_IN / 2 - 0.02;   // half width (E7 body), a hair inside the loft wall so the union has no coplanar side faces
E7N_BASE     = 60;              // height where the F-unit nose starts to lean back
E7N_HS       = (CAB_ROOF_IN - E7N_BASE) / 118.9;   // height stretch from the F-unit shape to the E7 cab
E7N_LEAN     = 0.120;           // face lean back above E7N_BASE (6.8 deg); vertical below it
E7N_PLAN_L   = 42.7 * E7N_HW / 59.45;   // nose length from the face to full width
E7N_PLAN_N   = 1.97;            // plan shape exponent (KIRI scan fit 23 Nov; F-unit 1.77)
E7N_TOP      = E7N_BASE + 88.0 * E7N_HS;    // nose deck height on the centre line
E7N_TOP_CROWN = 0.0027 / pow(E7N_HW / 59.45, 2) * E7N_HS;
E7N_WS_BASE  = 51.0;            // windshield base on the centre line, back from the tip (KIRI scan fit)
E7N_WS_SWEEP = 0.228 * 59.45 / E7N_HW;   // windshield V
E7N_WS_RUN   = 38.0;            // windshield + header run up to the cab roof (KIRI scan fit)
E7N_ROOF     = CAB_ROOF_IN;     // cab roof on the centre line
E7N_ROOF_CROWN = 0.0046 / pow(E7N_HW / 59.45, 2) * E7N_HS;
E7N_EDGE_R   = 8.0;             // roll-over radius, face to nose deck (KIRI scan: 6-8; F-unit 18)
E7N_LEN      = 152;             // the nose piece runs this far back; the loft carries on behind it
E7N_STEP     = 1.0;             // mesh step (inches)

// ---- shape functions ----
function _e7n_u(u, o) = 1 - pow(1 - pow(min(abs(u) / (E7N_HW - o), 0.9999), E7N_PLAN_N), 1 / E7N_PLAN_N);
// where the face is (v back from the tip) at across-position u and height w
function e7n_face_v(u, w, o = 0) = o + E7N_LEAN * max(w - E7N_BASE, 0) + E7N_PLAN_L * _e7n_u(u, o);
function _e7n_s(t) = let (c = min(max(t, 0), 1)) c * c * c * (c * (6 * c - 15) + 10);
// top of the nose / cab at (u, v)
function e7n_top_w(u, v, o = 0) =
  let (hn = E7N_TOP - E7N_TOP_CROWN * u * u - o,
       vw = E7N_WS_BASE + E7N_WS_SWEEP * abs(u),
       hr = E7N_ROOF - E7N_ROOF_CROWN * u * u - o,
       w0 = hn + (hr - hn) * _e7n_s((v - vw) / E7N_WS_RUN),
       R  = max(E7N_EDGE_R - o, 5),
       d  = v - e7n_face_v(u, hn - R, o),
       drop = d >= R ? 0 : R - sqrt(max(R * R - pow(R - max(d, 0), 2), 0)))
  max(w0 - drop, SKIRT_IN);

// plan solid: face outline, vertical up to E7N_BASE then leaning back
module _e7n_plan(o) {
  nu = 30;
  side = [for (i = [0:nu]) let (t = 1 - cos(i / nu * 90))
            [(E7N_HW - o) * pow(1 - pow(1 - t, E7N_PLAN_N), 1 / E7N_PLAN_N), o + E7N_PLAN_L * t]];
  half = concat(side, [[E7N_HW - o, E7N_LEN + 30]]);
  outline = concat(half, [for (i = [len(half) - 1:-1:1]) [-half[i][0], half[i][1]]]);
  zb = SKIRT_IN - 30;
  union() {
    translate([0, 0, zb]) linear_extrude(E7N_BASE - zb + 0.01) polygon(outline);
    translate([0, 0, E7N_BASE]) multmatrix([[1, 0, 0, 0], [0, 1, E7N_LEAN, 0], [0, 0, 1, 0]])
      linear_extrude(E7N_ROOF - E7N_BASE + 30) polygon(outline);
  }
}

// top solid: height field, columns packed through the roll-over so the edge is smooth
module _e7n_top(o) {
  // nx odd: no column on the centre line (avoids CGAL slivers)
  nx = 2 * ceil(E7N_HW / (1.5 * E7N_STEP)) + 1; nr = 16; nb = ceil(100 / E7N_STEP);
  us = [for (i = [0:nx]) -E7N_HW - 1 + i * (2 * E7N_HW + 2) / nx];
  col = function(u) let (
      hn = E7N_TOP - E7N_TOP_CROWN * u * u - o, R = max(E7N_EDGE_R - o, 5),
      vf = e7n_face_v(u, hn - R, o), v1 = min(vf + R, E7N_LEN - 1))
    concat([-2], [for (i = [0:nr]) min(vf + R * (1 - cos(i / nr * 90)), v1 - 0.01 * (nr - i))],
           [for (i = [1:nb]) v1 + (E7N_LEN - v1) * i / nb]);
  ny = nr + nb + 2; N = (nx + 1) * ny; zb = SKIRT_IN - 40;
  T = function(i, j) i * ny + j;
  pts = concat([for (u = us) for (v = col(u)) [u, v, e7n_top_w(u, v, o)]],
               [for (u = us) for (v = col(u)) [u, v, zb]]);
  faces = concat(
    [for (i = [0:nx - 1]) for (j = [0:ny - 2]) each [[T(i, j), T(i, j + 1), T(i + 1, j + 1)], [T(i, j), T(i + 1, j + 1), T(i + 1, j)]]],
    [for (i = [0:nx - 1]) for (j = [0:ny - 2]) each [[N + T(i, j), N + T(i + 1, j + 1), N + T(i, j + 1)], [N + T(i, j), N + T(i + 1, j), N + T(i + 1, j + 1)]]],
    [for (i = [0:nx - 1]) each [[T(i, 0), T(i + 1, 0), N + T(i + 1, 0)], [T(i, 0), N + T(i + 1, 0), N + T(i, 0)]]],
    [for (i = [0:nx - 1]) each [[T(i, ny - 1), N + T(i, ny - 1), N + T(i + 1, ny - 1)], [T(i, ny - 1), N + T(i + 1, ny - 1), T(i + 1, ny - 1)]]],
    [for (j = [0:ny - 2]) each [[T(0, j), N + T(0, j), N + T(0, j + 1)], [T(0, j), N + T(0, j + 1), T(0, j + 1)]]],
    [for (j = [0:ny - 2]) each [[T(nx, j), T(nx, j + 1), N + T(nx, j + 1)], [T(nx, j), N + T(nx, j + 1), N + T(nx, j)]]]);
  polyhedron(pts, faces, convexity = 6);
}

// nose in local inches, cut off at v = E7N_LEN and at the skirt
module e7n_local(o = 0) {
  intersection() {
    _e7n_plan(o); _e7n_top(o);
    translate([-E7N_HW - 5, -5, SKIRT_IN - (o > 0 ? 2 : 0)]) cube([2 * E7N_HW + 10, E7N_LEN + 5, 400]);
  }
}
// place local inches on the loco: v back from the tip -> -x from XF, u -> y, w -> z
module e7_nose_place() { translate([XF, 0, 0]) scale(p(1)) rotate([0, 0, 90]) children(); }
// the nose as a solid in model mm; off = inward offset in mm (as e7_loft)
module e7_nose_solid(off = 0) { e7_nose_place() e7n_local(off / p(1)); }

// helpers for cuts and details (inches)
function e7n_face_d(w) = e7n_face_v(0, w);     // nose front at the centre line, at height w
