// ===========================================================================
//  EMD F-UNIT NOSE - clean parametric shape (bulldog nose + cab front)
//  Rib Side Works, 23 Nov 2026.  For the Milwaukee FP7A / F7A.
//  Fitted to a trace of the RamBros "Dragon Railway" F7 A-unit body
//  (Printables 346667, CC BY - credit RamBros). Fit error about 1 in RMS.
//  ESTIMATE until checked against EMD data / photos of IRM 104C and 118C
//  (TDQ-FP7-11, TDQ-FP7-13).
//
//  All sizes are PROTOTYPE INCHES.  Axes: y = back from the nose tip,
//  x = across (0 = centreline), z = up from the bottom of the body shell.
//  Smooth shell only: nose door, headlights, Mars light, numberboards,
//  grabs and windshield frames are added as separate details.
//
//  Use:   include <fp7_nose_clean.scad>
//         fnose_clean(25.4/29);     // G     (25.4/48 = O, 25.4/87.1 = HO)
// ===========================================================================

// ---- plan view: the face is a super-ellipse that leans back going up ----
NOSE_HALF_W  = 59.4;   // half body width (Dragon trace; EMD hood 9 ft 10 in = 59.0)
NOSE_Y0      = 0.0;   // face position at the bottom
NOSE_LEAN    = 0.120;  // face lean back per inch of height (6.8 deg)
NOSE_PLAN_L  = 42.7;  // nose length from the face to full width
NOSE_PLAN_N  = 1.77;   // plan shape: 2 = ellipse, higher = squarer

// ---- top: nose deck, windshield, cab roof ----
NOSE_TOP_H   = 88.0;  // nose top height on the centreline (headlight housing added as a detail)
NOSE_TOP_CROWN = 0.0027; // nose top drop = crown * x^2
NOSE_TOP_RISE  = 0.4;  // nose top rise from front to windshield base
WS_BASE_Y    = 46.6;  // windshield base on the centreline (back from tip)
WS_SWEEP     = 0.228;  // windshield base moves back this much per inch off centre (the V)
WS_RUN       = 33.3;  // windshield + header run, base to roof
ROOF_H       = 118.9;  // cab roof height on the centreline
ROOF_CROWN   = 0.0046; // roof drop = crown * x^2
NOSE_EDGE_R  = 18.0;  // roll-over radius where the face meets the nose top (fit: 16-20)

NOSE_LEN     = 96;    // how far back the piece runs (in); the cab continues behind it
NOSE_RES     = 1.0;   // mesh step in inches (smaller = finer)

// ---------------------------------------------------------------------------
function _f_u(x)      = 1 - pow(1 - pow(min(abs(x)/NOSE_HALF_W, 0.9999), NOSE_PLAN_N), 1/NOSE_PLAN_N);
function nose_face_y(x, z) = NOSE_Y0 + NOSE_LEAN*z + NOSE_PLAN_L*_f_u(x);   // face position
function _smooth(t)   = let(c = min(max(t,0),1)) c*c*c*(c*(6*c-15)+10);
function nose_top_z(x, y) =
  let(hn = NOSE_TOP_H - NOSE_TOP_CROWN*x*x,
      yw = WS_BASE_Y + WS_SWEEP*abs(x),
      hr = ROOF_H - ROOF_CROWN*x*x,
      base = hn + NOSE_TOP_RISE*min(max(y/yw,0),1),
      z = base + (hr - base)*_smooth((y - yw)/WS_RUN),
      R = NOSE_EDGE_R,
      d = y - nose_face_y(x, hn - R),     // roll-over starts where the face reaches hn - R
      drop = d >= R ? 0 : R - sqrt(max(R*R - pow(R - max(d,0), 2), 0)))
  max(z - drop, 0.1);

// plan solid: the face outline, extruded up and sheared back by the lean
module _fnose_plan(s) {
  nu = max(8, ceil(30/NOSE_RES));
  side = [for (i = [0:nu]) let(u = 1 - cos(i/nu*90))
            [NOSE_HALF_W*pow(1 - pow(1-u, NOSE_PLAN_N), 1/NOSE_PLAN_N), NOSE_Y0 + NOSE_PLAN_L*u]];
  half = concat(side, [[NOSE_HALF_W, NOSE_LEN + 20]]);
  outline = concat(half, [for (i = [len(half)-1:-1:1]) [-half[i][0], half[i][1]]]);
  scale(s) multmatrix([[1,0,0,0],[0,1,NOSE_LEAN,0],[0,0,1,0]])
    linear_extrude(ROOF_H + 2) polygon(outline);
}

// top solid: height field. Each column of the grid starts just in front of the face and
// is packed tight through the roll-over, so the edge comes out smooth.
module _fnose_top(s) {
  nx = ceil(2*NOSE_HALF_W/(1.5*NOSE_RES));
  nr = max(6, ceil(16/NOSE_RES));            // rows through the roll-over
  nb = max(10, ceil(70/NOSE_RES));           // rows from the roll-over to the back
  xs = [for (i = [0:nx]) -NOSE_HALF_W - 1 + i*(2*NOSE_HALF_W + 2)/nx];
  col = function(x) let(
      hn = NOSE_TOP_H - NOSE_TOP_CROWN*x*x,
      R = NOSE_EDGE_R, yf = nose_face_y(x, hn - R), y1 = min(yf + R, NOSE_LEN - 1))
    concat([-2],
           [for (i = [0:nr]) min(yf + R*(1 - cos(i/nr*90)), y1 - 0.01*(nr-i))],
           [for (i = [1:nb]) y1 + (NOSE_LEN - y1)*i/nb]);
  ny = nr + nb + 2;  N = (nx+1)*ny;
  T = function(i,j) i*ny+j;
  pts = concat([for (x = xs) for (y = col(x)) [x*s, y*s, nose_top_z(x,y)*s]],
               [for (x = xs) for (y = col(x)) [x*s, y*s, -1]]);
  faces = concat(
    [for (i = [0:nx-1]) for (j = [0:ny-2]) each [[T(i,j), T(i,j+1), T(i+1,j+1)], [T(i,j), T(i+1,j+1), T(i+1,j)]]],
    [for (i = [0:nx-1]) for (j = [0:ny-2]) each [[N+T(i,j), N+T(i+1,j+1), N+T(i,j+1)], [N+T(i,j), N+T(i+1,j), N+T(i+1,j+1)]]],
    [for (i = [0:nx-1]) each [[T(i,0), T(i+1,0), N+T(i+1,0)], [T(i,0), N+T(i+1,0), N+T(i,0)]]],
    [for (i = [0:nx-1]) each [[T(i,ny-1), N+T(i,ny-1), N+T(i+1,ny-1)], [T(i,ny-1), N+T(i+1,ny-1), T(i+1,ny-1)]]],
    [for (j = [0:ny-2]) each [[T(0,j), N+T(0,j), N+T(0,j+1)], [T(0,j), N+T(0,j+1), T(0,j+1)]]],
    [for (j = [0:ny-2]) each [[T(nx,j), T(nx,j+1), N+T(nx,j+1)], [T(nx,j), N+T(nx,j+1), N+T(nx,j)]]]);
  polyhedron(pts, faces, convexity = 6);
}

// the clean nose; s = model mm per prototype inch
module fnose_clean(s = 1) intersection() { _fnose_plan(s); _fnose_top(s); }
