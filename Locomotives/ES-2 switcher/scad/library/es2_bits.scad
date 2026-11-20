// =====================================================================
//  es2_bits.scad  -  small shared detail parts (v6, Tom 10/17):
//  rivets, wire (railings, grab irons), wire posts and holes, hinges.
// =====================================================================

// ---------------- rivets ----------------
// One rivet head, axis +z, base at z = 0 (sunk 0.1 so it fuses with the face).
module rivet() translate([0, 0, -0.1]) cylinder(d1 = RIVET_D, d2 = RIVET_D * 0.45, h = RIVET_H + 0.1, $fn = 8);
// rivet on a face whose outward normal is n = "+x", "-x", "+y", "-y", "+z"
module rivet_on(pt, n) translate(pt)
    rotate(n == "+x" ? [0, 90, 0] : n == "-x" ? [0, -90, 0] : n == "+y" ? [-90, 0, 0] : n == "-y" ? [90, 0, 0] : [0, 0, 0]) rivet();
// points from a to b at the rivet pitch (both ends included)
function rivet_line(a, b, pitch = p(RIVET_PITCH)) =
    let(L = norm(b - a), n = max(1, round(L / pitch))) [for (i = [0 : n]) a + (b - a) * i / n];
// keep the points that are outside every rectangle [x0, x1, z0, z1] (in the face's own x / z)
function outside_all(pts, rects, ix = 0, iz = 2) =
    [for (q = pts) if (len([for (r = rects) if (q[ix] > r[0] && q[ix] < r[1] && q[iz] > r[2] && q[iz] < r[3]) 1]) == 0) q];

// ---------------- wire ----------------
// a bent wire through the points (preview / render only - it is bought brass wire)
module wire(pts, d = RAIL_WIRE) {
    for (i = [0 : len(pts) - 2]) hull() {
        translate(pts[i]) sphere(d = d, $fn = 10);
        translate(pts[i + 1]) sphere(d = d, $fn = 10);
    }
}
// a staple-shaped grab iron: legs into the face at a and b, standing off `off` along normal n3
module grab_iron(a, b, n3, off) wire([a - n3 * 1.5, a + n3 * off, b + n3 * off, b - n3 * 1.5]);
// hole for a wire end, going into the face along -n3
module wire_hole(pt, n3, depth = 3.5)
    translate(pt + n3 * 0.5) rotate(n3 == [0, 0, 1] ? [0, 0, 0] : n3 == [1, 0, 0] || n3 == [-1, 0, 0] ? [0, n3[0] * 90, 0] : [-n3[1] * 90, 0, 0])
        translate([0, 0, -depth - 0.5]) cylinder(d = RAIL_HOLE, h = depth + 0.6, $fn = 12);

// ---------------- hinges ----------------
// butt hinge on a vertical edge: knuckle axis along z, leaf toward +x (mirror for the other hand). Face is z-x plane, out = +y.
module hinge_butt(h = p(4)) {
    translate([0, 0.45, 0]) cylinder(d = 1.3, h = h, $fn = 16);
    cube([p(2.2), 0.3, h]);
}
