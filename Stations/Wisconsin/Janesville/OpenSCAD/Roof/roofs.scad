// =====================================================================
//  Roofs  -  main block (hip, 2 dormers, chimney, cresting), lunch wing (hip, abuts main wall),
//  baggage building (gable, brick gable ends), town-side porch pent roof.
//  Each building's roof is ONE removable assembly built on a cornice ring that sits on the
//  wall tops and locates with a lip just inside the walls.
//
//  Everything prints flat (no supports):
//    Roof_*      slate panels, texture up          Cornice_*   cornice ring, printed upside down
//    RoofFrame_* bulkheads (frames under seams) + splice strips
//    Dormer_*    brick dormer faces/cheeks (+ _mortar inlay), Pullman-green bargeboards & windows
//    Gable_*     brick gable ends (+ _mortar)       Chimney_*   chimney (upright) + stone cap
//    RoofTrim_*  ridge / hip caps, ridge cresting with finials
//
//  Geometry is written in REAL FEET (x along track from the west end, y from the track-side
//  wall line toward town, z above finished floor) and converted with ft().
// =====================================================================
include <../janesville_common.scad>

PART = "Roof_main_track";   // when opened directly
TILE = -1;
LAYER = -1;
VIEW = "flat";              // "flat" or "placed"
$fn = 32;

// ---------- settings ----------
T_SLATE  = 2.4;                    // slate panel thickness (mm)
SLATE_EXP = ft(0, 7);              // slate exposure (course height)
SLATE_W   = ft(0, 10);             // slate width
SG = 0.5; SG_D = 0.4;              // slate joint groove
T_FRAME = 3.0;                     // bulkheads
T_GABLE = T_LIGHT;                 // brick gables / dormer faces
T_CHEEK = 3.0;
MORTAR_W = 0.45; MORTAR_D = 0.35; MORTAR_TOP = 0.12;
COURSE = ft(0, 2.667); BRICK_L = ft(0, 8);
SLATE_GRAY = "#4B5560"; METAL_DARK = "#2E3134"; FRAME_GRAY = "#9A9A9A";

// ---------- building numbers (ft) ----------
LM = 98 + 1/12; D = 32; HW = 19;                 // main block length, depth, wall height
P_MAIN = 42; OV_MAIN = 1.5; CORN_MAIN = 1.25;    // pitch, eave overhang, cornice height above wall top
LX0 = LM; LX1 = LM + 30 + 4/12; LY0 = 1 + 5/12; LY1 = LY0 + 25 + 4/12; LH = 10.5;   // lunch wing
P_LUNCH = 30; OV_L = 1.25; CORN_L = 1.25;   // town-side slope
LTH = 18.5; ZRL = 20.75;                      // lunch wing: tall track-side wall, ridge height (B2082/B2079/B2080)
BX0 = LX1 + 42; BX1 = BX0 + 47 + 2/12; BY0 = LY0; BY1 = LY1; BH = 11;   // baggage building
P_BAG = 37; OV_B = 1.25; CORN_B = 1.25;
PAV0 = 38.75; PAV1 = 61.25; PAVC = 50;          // pavilion
DORM_EAVE = 24.25; DORM_RIDGE = 33.5; DORM_OV = 12.75; DORM_FRONT = 1.0;   // dormer roof
CH = [87, 96.3, 14, 18, 22.5, 41.3];             // chimney x0,x1,y0,y1, bottom z, top z (cap above)

// derived
Z0M = HW + CORN_MAIN; hM = (D + 2 * OV_MAIN) / 2; ZRM = Z0M + hM * tan(P_MAIN);
XA = -OV_MAIN; XB = LM + OV_MAIN; YA = -OV_MAIN; YB = D + OV_MAIN;
RX0 = XA + hM; RX1 = XB - hM; RY = D / 2;
function zM(d) = Z0M + d * tan(P_MAIN);                  // main roof height at distance d in from eave
function yv(z) = (z - Z0M) / tan(P_MAIN) + YA;           // track-side y where main roof reaches z
PD = atan((DORM_RIDGE - DORM_EAVE) / DORM_OV);           // dormer roof pitch
ZCHEEK = DORM_EAVE + (DORM_OV - (PAVC - PAV0)) * tan(PD);    // dormer roof underside at the cheek line
Z0L = LH + CORN_L;
LXA = LX0; LXB = LX1 + 1.0; LYA = LY0; LYB = LY1 + OV_L;
LRY = LYB - (ZRL - Z0L) / tan(P_LUNCH);        // ridge line (gable roof, ridge along the track)
P_LK = atan((ZRL - LTH) / (LRY - LY0));        // shallow track-side slope down to the tall wall
Z0B = BH + CORN_B; hB = (BY1 + OV_B - (BY0 - OV_B)) / 2; ZRB = Z0B + hB * tan(P_BAG);
BXA = BX0; BXB = BX1 + OV_B;     // no rake overhang on the west (the 42 ft shed abuts there)
 BYA = BY0 - OV_B; BYB = BY1 + OV_B; BRY = (BYA + BYB) / 2;

// ---------- vector helpers ----------
function v3(p) = [ft(p[0]), ft(p[1]), ft(p[2])];
function dotp(a, b) = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
function crossp(a, b) = [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
function slope_dir(n, p) = [n[0] * cos(p), n[1] * cos(p), sin(p)];

// ---------- roof planes ----------
// [name, E0 (ft), e, n, pitch, polygon (ft, 3D on the plane), holes, cuts {P1S, GIGA} as x (ft) or "auto"]
function mz(x, y) = [x, y, 0];   // placeholder, z filled by plane
function onM_track(x, y) = [x, y, zM(y - YA)];
function onM_town(x, y)  = [x, y, zM(YB - y)];
function onM_east(x, y)  = [x, y, zM(XB - x)];
DH = [yv(ZCHEEK), yv(DORM_RIDGE)];          // dormer hole: y at the cheek, y at the ridge (track side)
MAIN_CUTS_P1S = [19.5, PAV0 - 0.3, PAV1 + 0.3, 80];
MAIN_CUTS_GIGA = [PAV1 + 0.3];
PLANES = [
  ["Roof_main_track", [XA, YA, Z0M], [1, 0, 0], [0, 1, 0], P_MAIN,
     [[XA, YA, Z0M], [XB, YA, Z0M], [RX1, RY, ZRM], [RX0, RY, ZRM]],
     [[onM_track(PAV0, YA), onM_track(PAV1, YA), onM_track(PAV1, DH[0]), onM_track(PAVC, DH[1]), onM_track(PAV0, DH[0])]],
     ["x", MAIN_CUTS_P1S, MAIN_CUTS_GIGA]],
  ["Roof_main_town", [XB, YB, Z0M], [-1, 0, 0], [0, -1, 0], P_MAIN,
     [[XB, YB, Z0M], [XA, YB, Z0M], [RX0, RY, ZRM], [RX1, RY, ZRM]],
     [[onM_town(PAV1, YB), onM_town(PAV0, YB), onM_town(PAV0, D - DH[0]), onM_town(PAVC, D - DH[1]), onM_town(PAV1, D - DH[0])]],
     ["x", MAIN_CUTS_P1S, MAIN_CUTS_GIGA]],
  ["Roof_main_west", [XA, YB, Z0M], [0, -1, 0], [1, 0, 0], P_MAIN,
     [[XA, YB, Z0M], [XA, YA, Z0M], [RX0, RY, ZRM]], [], ["auto"]],
  ["Roof_main_east", [XB, YA, Z0M], [0, 1, 0], [-1, 0, 0], P_MAIN,
     [[XB, YA, Z0M], [XB, YB, Z0M], [RX1, RY, ZRM]],
     [[onM_east(CH[0], CH[2]), onM_east(CH[1], CH[2]), onM_east(CH[1], CH[3]), onM_east(CH[0], CH[3])]], ["auto"]],
  ["Roof_lunch_track", [LXA, LY0, LTH], [1, 0, 0], [0, 1, 0], P_LK,
     [[LXA, LY0, LTH], [LXB, LY0, LTH], [LXB, LRY, ZRL], [LXA, LRY, ZRL]], [], ["x", [LXA + (LXB - LXA) / 2], []]],
  ["Roof_lunch_town", [LXB, LYB, Z0L], [-1, 0, 0], [0, -1, 0], P_LUNCH,
     [[LXB, LYB, Z0L], [LXA, LYB, Z0L], [LXA, LRY, ZRL], [LXB, LRY, ZRL]], [], ["x", [LXA + (LXB - LXA) / 2], []]],
  ["Roof_baggage_track", [BXA, BYA, Z0B], [1, 0, 0], [0, 1, 0], P_BAG,
     [[BXA, BYA, Z0B], [BXB, BYA, Z0B], [BXB, BRY, ZRB], [BXA, BRY, ZRB]], [],
     ["x", [BXA + (BXB - BXA) / 3, BXA + 2 * (BXB - BXA) / 3], []]],
  ["Roof_baggage_town", [BXB, BYB, Z0B], [-1, 0, 0], [0, -1, 0], P_BAG,
     [[BXB, BYB, Z0B], [BXA, BYB, Z0B], [BXA, BRY, ZRB], [BXB, BRY, ZRB]], [],
     ["x", [BXA + (BXB - BXA) / 3, BXA + 2 * (BXB - BXA) / 3], []]],
  // town-side porch pent roof: from the porch face (9 ft) up to the main wall at the dormer (19 ft)
  ["Roof_porch_pent", [PAV1, D + 4, 9], [-1, 0, 0], [0, -1, 0], atan(10 / 4),
     [[PAV1, D + 4, 9], [PAV0, D + 4, 9], [PAV0, D, 19], [PAV1, D, 19]], [], ["auto"]],
  // dormer roofs (track side, then town side)
  ["Roof_dormer_track_W", [PAVC - DORM_OV, 0, DORM_EAVE], [0, -1, 0], [1, 0, 0], PD,
     [[PAVC - DORM_OV, -DORM_FRONT, DORM_EAVE], [PAVC - DORM_OV, yv(DORM_EAVE), DORM_EAVE], [PAVC, DH[1], DORM_RIDGE], [PAVC, -DORM_FRONT, DORM_RIDGE]], [], ["auto"]],
  ["Roof_dormer_track_E", [PAVC + DORM_OV, 0, DORM_EAVE], [0, 1, 0], [-1, 0, 0], PD,
     [[PAVC + DORM_OV, -DORM_FRONT, DORM_EAVE], [PAVC + DORM_OV, yv(DORM_EAVE), DORM_EAVE], [PAVC, DH[1], DORM_RIDGE], [PAVC, -DORM_FRONT, DORM_RIDGE]], [], ["auto"]],
  ["Roof_dormer_town_W", [PAVC - DORM_OV, D, DORM_EAVE], [0, -1, 0], [1, 0, 0], PD,
     [[PAVC - DORM_OV, D + DORM_FRONT, DORM_EAVE], [PAVC - DORM_OV, D - yv(DORM_EAVE), DORM_EAVE], [PAVC, D - DH[1], DORM_RIDGE], [PAVC, D + DORM_FRONT, DORM_RIDGE]], [], ["auto"]],
  ["Roof_dormer_town_E", [PAVC + DORM_OV, D, DORM_EAVE], [0, 1, 0], [-1, 0, 0], PD,
     [[PAVC + DORM_OV, D + DORM_FRONT, DORM_EAVE], [PAVC + DORM_OV, D - yv(DORM_EAVE), DORM_EAVE], [PAVC, D - DH[1], DORM_RIDGE], [PAVC, D + DORM_FRONT, DORM_RIDGE]], [], ["auto"]]
];
function prow(n) = PLANES[search([n], PLANES)[0]];
function plane_list() = [for (p = PLANES) p[0]];
function p_s(r) = slope_dir(r[3], r[4]);
function p_uv(r, P) = let(E = v3(r[1]), d = v3(P) - E) [dotp(d, r[2]), dotp(d, p_s(r))];
function p_poly(r) = [for (P = r[5]) p_uv(r, P)];
function p_holes(r) = [for (h = r[6]) [for (P = h) p_uv(r, P)]];
function bbox2(pts) = [[min([for (p = pts) p[0]]), min([for (p = pts) p[1]])], [max([for (p = pts) p[0]]), max([for (p = pts) p[1]])]];
// section cuts along u (mm, raw plane coords)
function p_ucuts(r, bed) = let(bb = bbox2(p_poly(r)), c = r[7], E = v3(r[1]))
    c[0] == "x" ? [for (x = (bed[0] > 500 ? c[2] : c[1])) (ft(x) - E[0]) * r[2][0]] :
    let(n = ceil((bb[1][0] - bb[0][0]) / (bed[0] - 2))) [for (i = [1 : max(1, n - 1)]) if (n > 1) bb[0][0] + i * (bb[1][0] - bb[0][0]) / n];
function sortv(v) = len(v) <= 1 ? v : let(p = v[0]) concat(sortv([for (x = v) if (x < p) x]), [for (x = v) if (x == p) x], sortv([for (x = v) if (x > p) x]));
function p_vcuts(r, bed) = let(bb = bbox2(p_poly(r)), n = ceil((bb[1][1] - bb[0][1]) / (bed[1] - 2)))
    [for (j = [1 : max(1, n - 1)]) if (n > 1) bb[0][1] + j * (bb[1][1] - bb[0][1]) / n];
function plane_count(n, bed) = let(r = prow(n)) (len(p_ucuts(r, bed)) + 1) * (len(p_vcuts(r, bed)) + 1);

module slate2d(bb) {                    // slate joints (courses parallel to the eave, staggered heads)
    for (i = [0 : ceil((bb[1][1] - bb[0][1]) / SLATE_EXP)]) {
        v = bb[0][1] + i * SLATE_EXP;
        translate([bb[0][0] - 1, v - SG / 2]) square([bb[1][0] - bb[0][0] + 2, SG]);
        for (u = [bb[0][0] + (i % 2) * SLATE_W / 2 : SLATE_W : bb[1][0]])
            translate([u - SG / 2, v]) square([SG, SLATE_EXP]);
    }
}
module plane2d(r) difference() { polygon(p_poly(r)); for (h = p_holes(r)) polygon(h); }
function tile_box(lo, hi, cu, cv, tile) = let(nu = len(cu) + 1, iu = tile % nu, iv = floor(tile / nu),
    xs = concat([lo[0] - 1], sortv(cu), [hi[0] + 1]), ys = concat([lo[1] - 1], cv, [hi[1] + 1]))
    [[xs[iu], ys[iv]], [xs[iu + 1], ys[iv + 1]]];
module plane_layer(n, k, tile = -1, bed = BED) {
    r = prow(n); bb = bbox2(p_poly(r));
    tb = tile < 0 ? [bb[0] - [5, 5], bb[1] + [5, 5]] : tile_box(bb[0], bb[1], p_ucuts(r, bed), p_vcuts(r, bed), tile);
    z = [[0, T_SLATE - SG_D], [T_SLATE - SG_D, T_SLATE]][k];
    translate([0, 0, z[0]]) linear_extrude(z[1] - z[0]) intersection() {
        translate(tb[0]) square(tb[1] - tb[0]);
        difference() { plane2d(r); if (k == 1) slate2d(bb); }
    }
}
module plane_place(n) {
    r = prow(n); e = r[2]; s = p_s(r); N = crossp(e, s); E = v3(r[1]) + [0, 0, FLOOR_Z];
    multmatrix([[e[0], s[0], N[0], E[0]], [e[1], s[1], N[1], E[1]], [e[2], s[2], N[2], E[2]], [0, 0, 0, 1]])
        for (k = [0, 1]) plane_layer(n, k);
}

// ---------- cornice rings (installed coords, z relative to wall top; printed upside down) ----------
// [name, wall-top z (ft), wall thickness (mm), footprint rect ft, outer profile rect ft (corona outline),
//  bed-mould growth (ft), height (ft), masks to remove outer parts [[x0,y0,x1,y1] ft], lip? , cuts x (ft) {P1S, GIGA}, cut y]
RINGS = [
  ["Cornice_main", HW, T_MAIN, [0, 0, LM, D], [XA, YA, XB, YB], 0.5, CORN_MAIN,
     [[LM, LYA, LM + 5, LYB]],
     [MAIN_CUTS_P1S, MAIN_CUTS_GIGA], D / 2, [[PAV0, -5, PAV1, 0.85], [PAV0, D - 0.85, PAV1, D + 5]]],
  // lunch wing: cornice on the low TOWN side only (the track side is the tall canopy wall)
  ["Cornice_lunch", LH, T_LIGHT, [LX0, LY0, LX1, LY1], [LX0, LY1 - 0.75, LXB, LYB], 0.4, CORN_L,
     [], [[LX0 + (LX1 - LX0) / 2], []], (LY0 + LY1) / 2, []],
  ["Cornice_baggage", BH, T_LIGHT, [BX0, BY0, BX1, BY1], [BX0 - 0.08, BYA, BX1 + 0.08, BYB], 0.4, CORN_B,
     [], [[BXA + (BXB - BXA) / 3, BXA + 2 * (BXB - BXA) / 3], []], (BY0 + BY1) / 2, []]
];
function rrow(n) = RINGS[search([n], RINGS)[0]];
function ring_list() = [for (r = RINGS) r[0]];
function rect2(q, g = 0) = [[ft(q[0]) - g, ft(q[1]) - g], [ft(q[2]) + g, ft(q[3]) + g]];
module rsq(b) translate(b[0]) square(b[1] - b[0]);
function ring_cuts(r, bed) = [[for (x = (bed[0] > 500 ? r[8][1] : r[8][0])) ft(x)],
                              (ft(r[4][3] - r[4][1]) > bed[1] - 2) ? [ft(r[9])] : []];
function ring_count(n, bed) = let(c = ring_cuts(rrow(n), bed)) (len(c[0]) + 1) * (len(c[1]) + 1);
// layers: 0 lip (inside walls), 1 frieze skirt (outside the wall face), 2 bed mould, 3 corona
function ring_z(r, k) = [[-2, 0], [-ft(1), 0], [0, ft(r[5])], [ft(r[5]), ft(r[6])]][k];
module ring2d(r, k) {
    T = r[2]; fp = rect2(r[3]); inner = rect2(r[3], -(T + 3));
    lunchW = r[0] == "Cornice_lunch";
    module outside() difference() { children(); rsq(fp); for (m = r[7]) rsq(rect2(m)); if (lunchW) translate([ft(LX0) - 50, -500]) square([50, 2000]); }
    if (lunchW) {
        if (k == 1) rsq(rect2([LX0, LY1, LX1, LY1 + 0.08]));
        if (k == 2) rsq(rect2([LX0, LY1 - 0.75, LX1 + 0.4, LY1 + 0.4]));
        if (k == 3) rsq(rect2([LX0, LY1 - 0.75, LXB, LYB]));
    }
    else difference() { union() {
        if (k == 0) difference() { rsq(rect2(r[3], -(T + 0.3))); rsq(rect2(r[3], -(T + 2.3))); }
        if (k == 1) outside() rsq(rect2(r[3], 0.8));
        if (k == 2) difference() { union() { rsq(fp); outside() intersection() { rsq(rect2(r[3], ft(r[5]))); rsq(rect2(r[4])); } } rsq(inner); }
        if (k == 3) difference() { union() { rsq(fp); outside() rsq(rect2(r[4])); } rsq(inner); }
    }
    for (g = r[10]) rsq(rect2(g));                      // gaps where the dormer faces stand on the wall
    }
}
module ring_layer(n, k, tile = -1, bed = BED, print = false) {
    r = rrow(n); c = ring_cuts(r, bed); z = ring_z(r, k);
    o = rect2(r[4], 20);
    tb = tile < 0 ? o : tile_box(o[0], o[1], c[0], c[1], tile);
    // printed upside down: z -> (top - z)
    top = ft(r[6]);
    translate([0, 0, print ? top - z[1] : z[0]]) linear_extrude(z[1] - z[0])
        intersection() { rsq(tb); ring2d(r, k); }
}
module ring_place(n) { r = rrow(n); translate([0, 0, FLOOR_Z + ft(r[1])]) for (k = [0 : 3]) ring_layer(n, k); }

// ---------- brick panels: dormer faces, dormer cheeks, gable ends ----------
// [name, polygon (u,v ft), openings [[u0,v0,u1,v1,archrise]], thickness, origin (ft), angle, base z (ft), print bed split]
BRICKS = [
  ["Dormer_face_track", [[0, 0], [22.5, 0], [22.5, ZCHEEK - HW], [11.25, DORM_RIDGE - HW], [0, ZCHEEK - HW]],
     [[7.25, 0.25, 15.25, 6.25, 1.0]], T_GABLE, [PAV0, 0], 0, HW],
  ["Dormer_face_town", [[0, 0], [22.5, 0], [22.5, ZCHEEK - HW], [11.25, DORM_RIDGE - HW], [0, ZCHEEK - HW]],
     [[7.25, 0.25, 15.25, 6.25, 1.0]], T_GABLE, [PAV1, D], 180, HW],
  // dormer cheeks: small brick triangles between the main roof and the dormer eave (u from the wall line inward)
  ["Dormer_cheek_track_W", [[yv(ZCHEEK), zM(OV_MAIN) - HW], [yv(ZCHEEK), ZCHEEK - HW], [0, ZCHEEK - HW]], [], T_CHEEK, [PAV0, yv(ZCHEEK)], 270, HW],
  ["Dormer_cheek_track_E", [[0, zM(OV_MAIN) - HW], [0, ZCHEEK - HW], [yv(ZCHEEK), ZCHEEK - HW]], [], T_CHEEK, [PAV1, 0], 90, HW],
  ["Dormer_cheek_town_W", [[0, zM(OV_MAIN) - HW], [0, ZCHEEK - HW], [yv(ZCHEEK), ZCHEEK - HW]], [], T_CHEEK, [PAV0, D], 270, HW],
  ["Dormer_cheek_town_E", [[yv(ZCHEEK), zM(OV_MAIN) - HW], [yv(ZCHEEK), ZCHEEK - HW], [0, ZCHEEK - HW]], [], T_CHEEK, [PAV1, D - yv(ZCHEEK)], 90, HW],
  ["Gable_baggage_west", [[0, 0], [BY1 - BY0, 0], [BY1 - BY0, OV_B * tan(P_BAG)], [(BY1 - BY0) / 2, ZRB - Z0B], [0, OV_B * tan(P_BAG)]],
     [], T_GABLE, [BX0, BY1], 270, Z0B],
  ["Gable_baggage_east", [[0, 0], [BY1 - BY0, 0], [BY1 - BY0, OV_B * tan(P_BAG)], [(BY1 - BY0) / 2, ZRB - Z0B], [0, OV_B * tan(P_BAG)]],
     [], T_GABLE, [BX1, BY0], 90, Z0B],
  // lunch wing east end: brick gable above the 10'-6" wall (tall on the track side, low on the town side)
  ["Gable_lunch_east", [[0.48, 0], [LY1 - LY0 - 0.75, 0], [LY1 - LY0 - 0.75, CORN_L], [LY1 - LY0, CORN_L],
                        [LY1 - LY0, Z0L + OV_L * tan(P_LUNCH) - LH], [LRY - LY0, ZRL - LH], [0.48, LTH - LH]],
     [], T_GABLE, [LX1, LY0], 90, LH],
  ["Porch_cheek_W", [[0, 0], [3.5, 0], [3.5, 10], [0, 1.25]], [], T_LIGHT, [PAV0, D + 3.5], 270, 9],
  ["Porch_cheek_E", [[0, 0], [3.5, 0], [3.5, 1.25], [0, 10]], [], T_LIGHT, [PAV1, D], 90, 9]
];
// note: cheek polygons are drawn with u = distance from the wall line (cheeks of the town dormer mirror it)
function brow(n) = BRICKS[search([n], BRICKS)[0]];
function brick_list() = [for (b = BRICKS) b[0]];
function bpoly(b) = [for (p = b[1]) [ft(p[0]), ft(p[1])]];
module bopen2d(b) for (o = b[2]) {
    translate([ft(o[0]), ft(o[1])]) square([ft(o[2] - o[0]), ft(o[3] - o[1])]);
    if (o[4] > 0) let(w = ft(o[2] - o[0]), h = ft(o[4]), R = (w * w / 4 + h * h) / (2 * h))
        translate([ft(o[0]) + w / 2, ft(o[3]) + h - R]) intersection() { circle(r = R, $fn = 96); translate([-w / 2, R - h]) square([w, h]); }
}
module barch2d(b) for (o = b[2]) if (o[4] > 0) {    // raised brick arch ring over a segmental head
    w = ft(o[2] - o[0]); h = ft(o[4]); R = (w * w / 4 + h * h) / (2 * h); ring = ft(1);
    translate([ft(o[0]) + w / 2, ft(o[3]) + h - R]) intersection() {
        difference() { circle(r = R + ring, $fn = 96); circle(r = R, $fn = 96); }
        translate([-w / 2 - ring, R - h - 0.01]) square([w + 2 * ring, h + ring + 1]);
    }
}
module bjoints2d(L, H) for (i = [0 : ceil(H / COURSE)]) {
    translate([-1, i * COURSE - MORTAR_W / 2]) square([L + 2, MORTAR_W]);
    for (u = [(i % 2) * BRICK_L / 2 - BRICK_L : BRICK_L : L + BRICK_L]) translate([u - MORTAR_W / 2, i * COURSE]) square([MORTAR_W, COURSE]);
}
function b_cuts(b, bed) = let(W = bbox2(bpoly(b))[1][0], n = ceil(W / (bed[0] - 2))) [for (i = [1 : max(1, n - 1)]) if (n > 1) i * W / n];
function brick_count(n, bed) = len(b_cuts(brow(n), bed)) + 1;
function bz(b, k) = let(T = b[3]) [[0, T - MORTAR_D], [T - MORTAR_D, T], [T - MORTAR_D, T - MORTAR_TOP], [T, T + 0.6]][k];
module brick_layer(n, k, tile = -1, bed = BED) {
    b = brow(n); bb = bbox2(bpoly(b)); L = bb[1][0]; H = bb[1][1];
    z = bz(b, k); cu = concat([-5], b_cuts(b, bed), [L + 5]);
    a = tile < 0 ? -5 : cu[tile]; c = tile < 0 ? L + 5 : cu[tile + 1];
    translate([0, 0, z[0]]) linear_extrude(z[1] - z[0]) intersection() { translate([a, -5]) square([c - a, H + 10]); union() {
        if (k == 0) difference() { polygon(bpoly(b)); bopen2d(b); }
        if (k == 1) difference() { polygon(bpoly(b)); bopen2d(b); difference() { bjoints2d(L, H); barch2d(b); } }
        if (k == 2) intersection() { difference() { polygon(bpoly(b)); bopen2d(b); barch2d(b); } bjoints2d(L, H); }
        if (k == 3) intersection() { polygon(bpoly(b)); barch2d(b); }
    } }
}
module brick_place(n, ks = [0, 1, 2, 3]) {
    b = brow(n); T = b[3];
    translate([ft(b[4][0]), ft(b[4][1]), FLOOR_Z + ft(b[6])]) rotate([0, 0, b[5]])
        rotate([90, 0, 0]) translate([0, 0, -T]) for (k = ks) brick_layer(n, k);
}

// ---------- bulkheads (frames under the panel seams) ----------
// [name, x (ft), cross-section polygon (y,z ft)]
function truss(y0, y1, z0, yr, zr) = [[y0, z0], [y1, z0], [yr, zr]];
FRAMES = concat(
  [for (x = MAIN_CUTS_P1S) [str("RoofFrame_main_", round(x)), x, truss(YA + 0.2, YB - 0.2, Z0M, RY, ZRM - 0.25)]],
  [["RoofFrame_lunch_1", LXA + (LXB - LXA) / 2, [[LY0 + 0.6, LTH - 0.05], [LYB - 0.2, Z0L], [LRY, ZRL - 0.25]]]],
  [for (i = [1, 2]) [str("RoofFrame_baggage_", i), BXA + i * (BXB - BXA) / 3, truss(BYA + 0.2, BYB - 0.2, Z0B, BRY, ZRB - 0.25)]]
);
function frow(n) = FRAMES[search([n], FRAMES)[0]];
function frame_list() = [for (f = FRAMES) f[0]];
module frame2d(f) {
    P = [for (p = f[2]) [ft(p[0]), ft(p[1])]];
    difference() {
        polygon(P);
        offset(delta = -6) polygon(P);                      // open truss
    }
    // king post + two struts
    c = (P[0] + P[1]) / 2;
    lop = abs(P[0][1] - P[1][1]) > 0.01;                   // lopsided truss (lunch wing): king post only
    zb = lop ? P[0][1] + (P[1][1] - P[0][1]) * (P[2][0] - P[0][0]) / (P[1][0] - P[0][0]) : P[0][1];
    translate([P[2][0] - 2, zb]) square([4, P[2][1] - zb]);
    if (!lop) for (s = [-1, 1]) hull() { translate([P[2][0] - 2, P[0][1]]) square([4, 4]); translate([P[2][0] + s * (P[1][0] - P[0][0]) / 4 - 2, P[0][1] + (P[2][1] - P[0][1]) / 2 - 2]) square([4, 4]); }
}
function f_cuts(f, bed) = let(P = [for (p = f[2]) ft(p[0])], W = max(P) - min(P)) W > bed[0] - 2 ? [ft(f[2][2][0])] : [];
function frame_count(n, bed) = len(f_cuts(frow(n), bed)) + 1;
module frame_part(n, tile = -1, bed = BED) {
    f = frow(n); cu = concat([-1e4], f_cuts(f, bed), [1e4]);
    linear_extrude(T_FRAME) intersection() {
        frame2d(f);
        if (tile >= 0) translate([cu[tile] + (tile > 0 ? 0.15 : 0), -1e4]) square([cu[tile + 1] - cu[tile] - 0.15, 2e4]);
        else translate([-1e4, -1e4]) square([2e4, 2e4]);
    }
}
module frame_place(n) { f = frow(n); translate([ft(f[1]) - T_FRAME / 2, 0, FLOOR_Z]) rotate([90, 0, 90]) frame_part(n); }

// ---------- chimney (printed upright, brick courses all round) + stone cap ----------
// Per the c.1910 photo ("Chimney detail"): a tall narrow recessed brick panel on each face, a corbelled
// brick lip under a projecting cap, and an open flue.  Hollow all the way through (2.4 mm walls) so a
// flicker LED can sit inside and the light shows at the top.
CH_WALL = 2.4;            // chimney wall thickness (mm)
CH_IND = [1.2, 1.4];      // indent width (ft), depth (mm)
CH_CORBEL = 3;            // number of stepped-out courses under the cap
CH_STEP = 0.7;            // each steps out this far (mm)
module chimney_layer(i) {
    W = ft(CH[1] - CH[0]); Dp = ft(CH[3] - CH[2]); Hc = ft(CH[5] - CH[4]);
    n = floor(Hc / COURSE);
    module core() offset(delta = -CH_WALL) square([W, Dp]);
    if (i < n) {
        z0 = i * COURSE; panel = (z0 > ft(4) && z0 < Hc - ft(3.2));
        out = max(0, i - (n - 1 - CH_CORBEL)) * CH_STEP;                 // corbelled lip
        translate([0, 0, z0]) {
            // mortar joint (inset) then brick course with head joints notched in
            linear_extrude(MORTAR_W) difference() { offset(delta = out - MORTAR_D) square([W, Dp]); core(); }
            translate([0, 0, MORTAR_W]) linear_extrude(COURSE - MORTAR_W) difference() {
                offset(delta = out) square([W, Dp]);
                for (u = [(i % 2) * BRICK_L / 2 : BRICK_L : W]) {
                    translate([u - MORTAR_W / 2, -1 - out]) square([MORTAR_W, MORTAR_D + 1]);
                    translate([u - MORTAR_W / 2, Dp + out - MORTAR_D]) square([MORTAR_W, MORTAR_D + 1]);
                }
                for (u = [(i % 2) * BRICK_L / 2 : BRICK_L : Dp]) {
                    translate([-1 - out, u - MORTAR_W / 2]) square([MORTAR_D + 1, MORTAR_W]);
                    translate([W + out - MORTAR_D, u - MORTAR_W / 2]) square([MORTAR_D + 1, MORTAR_W]);
                }
                if (panel) {                                             // tall narrow recessed panel, one per face
                    for (yy = [-1, Dp - CH_IND[1]]) translate([W / 2 - ft(CH_IND[0]) / 2, yy]) square([ft(CH_IND[0]), CH_IND[1] + 1]);
                    for (xx = [-1, W - CH_IND[1]]) translate([xx, Dp / 2 - ft(CH_IND[0]) / 2]) square([CH_IND[1] + 1, ft(CH_IND[0])]);
                }
                core();                                                  // open flue
            }
        }
    }
}
function chimney_layers() = floor(ft(CH[5] - CH[4]) / COURSE);
module chimney_part(only = -1) for (i = [0 : chimney_layers() - 1]) if (only < 0 || only == i) chimney_layer(i);
module chimney_cap() {   // projecting stone lip, open in the middle (flue)
    W = ft(CH[1] - CH[0]); Dp = ft(CH[3] - CH[2]); o = CH_CORBEL * CH_STEP;
    difference() {
        union() { linear_extrude(ft(0, 3)) offset(delta = o + 0.6) square([W, Dp]);
                  translate([0, 0, ft(0, 3)]) linear_extrude(ft(0, 4)) offset(delta = o + 1.6) square([W, Dp]); }
        translate([0, 0, -1]) linear_extrude(ft(1)) offset(delta = -CH_WALL) square([W, Dp]);
    }
}
// ---------- chimney base: the stack from the floor up to the roof (stays in the building; the roof chimney sits on it) ----------
// Hollow (same 2.4 mm walls), so lighting wires can come up from the foundation to a flicker LED near the top.
// It stands on the finished floor against the smoking-room partition, on the line between the annex and the men's toilet.
CHB_X0 = 87.62;                 // west face clear of the partition and its wall liner (ft)
CHB_FLOOR = 1.0;                // floor overlay thickness (mm)
function chb_h() = ft(CH[4]) - CHB_FLOOR;
function chimney_base_layers() = floor(chb_h() / COURSE);
module chimney_base_layer(i) {
    W = ft(CH[1] - CHB_X0); Dp = ft(CH[3] - CH[2]);
    module core() offset(delta = -CH_WALL) square([W, Dp]);
    translate([0, 0, i * COURSE * chb_h() / (chimney_base_layers() * COURSE)]) scale([1, 1, chb_h() / (chimney_base_layers() * COURSE)]) {
        linear_extrude(MORTAR_W) difference() { offset(delta = -MORTAR_D) square([W, Dp]); core(); }
        translate([0, 0, MORTAR_W]) linear_extrude(COURSE - MORTAR_W) difference() {
            square([W, Dp]);
            for (u = [(i % 2) * BRICK_L / 2 : BRICK_L : W]) {
                translate([u - MORTAR_W / 2, -1]) square([MORTAR_W, MORTAR_D + 1]);
                translate([u - MORTAR_W / 2, Dp - MORTAR_D]) square([MORTAR_W, MORTAR_D + 1]);
            }
            for (u = [(i % 2) * BRICK_L / 2 : BRICK_L : Dp]) {
                translate([-1, u - MORTAR_W / 2]) square([MORTAR_D + 1, MORTAR_W]);
                translate([W - MORTAR_D, u - MORTAR_W / 2]) square([MORTAR_D + 1, MORTAR_W]);
            }
            core();
        }
    }
}
module chimney_base_part(only = -1) for (i = [0 : chimney_base_layers() - 1]) if (only < 0 || only == i) chimney_base_layer(i);
module chimney_base_place() color(BRICK_RED) translate([ft(CHB_X0), ft(CH[2]), FLOOR_Z + CHB_FLOOR]) chimney_base_part();
module chimney_place() {
    translate([ft(CH[0]), ft(CH[2]), FLOOR_Z + ft(CH[4])]) {
        color(BRICK_RED) chimney_part();
        color(STONE_BUFF) translate([0, 0, ft(CH[5] - CH[4])]) chimney_cap();
    }
}

// ---------- trim: ridge / hip caps, ridge cresting with finials, dormer bargeboards ----------
function seg_len(a, b) = norm(v3(b) - v3(a));
CAPS = [
  ["main_ridge", [RX0, RY, ZRM], [RX1, RY, ZRM]],
  ["main_hip_SW", [XA, YA, Z0M], [RX0, RY, ZRM]], ["main_hip_NW", [XA, YB, Z0M], [RX0, RY, ZRM]],
  ["main_hip_SE", [XB, YA, Z0M], [RX1, RY, ZRM]], ["main_hip_NE", [XB, YB, Z0M], [RX1, RY, ZRM]],
  ["lunch_ridge", [LXA, LRY, ZRL], [LXB, LRY, ZRL]],
  ["baggage_ridge", [BXA, BRY, ZRB], [BXB, BRY, ZRB]],
  ["dormer_track_ridge", [PAVC, -DORM_FRONT, DORM_RIDGE], [PAVC, DH[1], DORM_RIDGE]],
  ["dormer_town_ridge", [PAVC, D + DORM_FRONT, DORM_RIDGE], [PAVC, D - DH[1], DORM_RIDGE]]
];
function crow(n) = CAPS[search([n], CAPS)[0]];
function cap_list() = [for (c = CAPS) c[0]];
function cap_len(c) = seg_len(c[1], c[2]) + 4;
function cap_cuts(c, bed) = let(L = cap_len(c), m = ceil(L / (bed[0] - 2))) [for (i = [1 : max(1, m - 1)]) if (m > 1) i * L / m];
function cap_count(n, bed) = len(cap_cuts(crow(n), bed)) + 1;
module cap_part(n, tile = -1, bed = BED) {      // half-round metal roll on a flat flange, printed flat side down
    c = crow(n); L = cap_len(c); cu = concat([-1], cap_cuts(c, bed), [L + 1]);
    a = tile < 0 ? -1 : cu[tile]; b = tile < 0 ? L + 1 : cu[tile + 1];
    intersection() {
        translate([max(a, 0), -10, -1]) cube([min(b, L) - max(a, 0), 20, 10]);
        union() {
            translate([0, -2.5, 0]) cube([L, 5, 0.6]);
            translate([0, 0, 0.6]) rotate([0, 90, 0]) scale([1, 1, 1]) intersection() { cylinder(r = 1.5, h = L, $fn = 16); translate([-2, -2, 0]) cube([2, 4, L]); }
        }
    }
}
module cap_place(n) {
    c = crow(n); A = v3(c[1]) + [0, 0, FLOOR_Z]; B = v3(c[2]) + [0, 0, FLOOR_Z]; d = (B - A) / norm(B - A);
    yaw = atan2(d[1], d[0]); pit = -asin(d[2]);
    translate(A + [0, 0, T_SLATE * 0.6]) rotate([0, 0, yaw]) rotate([0, pit, 0]) translate([-2, 0, 0]) color(METAL_DARK) cap_part(n);
}
// cresting: rail + posts every 2 ft with ball tops, tall finials at both ends (flat, 1.2 mm)
CREST_H = ft(1); CREST_SP = ft(2);
module cresting2d(L) {
    square([L, 1.2]);
    for (u = [0 : CREST_SP : L]) { translate([u - 0.6, 0]) square([1.2, CREST_H]); translate([u, CREST_H]) circle(r = 1.1, $fn = 16); }
    translate([0, CREST_H * 0.6]) square([L, 0.8]);
    for (u = [0, L]) { translate([u - 1, 0]) square([2, ft(2.5)]); translate([u, ft(2.5)]) circle(r = 1.8, $fn = 20);
                       translate([u, ft(1.8)]) circle(r = 1.4, $fn = 20); }
}
function crest_len() = seg_len(crow("main_ridge")[1], crow("main_ridge")[2]);
function crest_count(bed) = ceil((crest_len() + 4) / (bed[0] - 4));
module crest_part(tile = -1, bed = BED) {
    L = crest_len(); m = crest_count(bed); a = tile < 0 ? -5 : tile * L / m - (tile == 0 ? 5 : 0); b = tile < 0 ? L + 5 : (tile + 1) * L / m + (tile == m - 1 ? 5 : 0);
    linear_extrude(1.2) intersection() { translate([a, -5]) square([b - a, 100]); cresting2d(L); }
}
module crest_place() {
    c = crow("main_ridge"); A = v3(c[1]) + [0, 0, FLOOR_Z + T_SLATE * 0.6 + 2];
    translate(A) rotate([90, 0, 0]) translate([0, 0, -0.6]) color(METAL_DARK) crest_part();
}
// dormer bargeboards (wood, Pullman green): along the front rake of each dormer roof
BARGE_W = ft(0, 10);
function barge_len() = DORM_OV / cos(PD) + 0.5;
module barge_part() linear_extrude(1.2) difference() {
    square([ft(barge_len()), BARGE_W]);
    for (u = [ft(1) : ft(1.5) : ft(barge_len()) - ft(0.5)]) translate([u, BARGE_W / 2]) circle(r = 1.0, $fn = 12);   // pierced pattern
}
module barge_place(side, s) {   // side: 0 track, 1 town; s: -1 west, +1 east
    yf = side == 0 ? -DORM_FRONT - 0.05 : D + DORM_FRONT + 0.05;
    translate([ft(PAVC), ft(yf), FLOOR_Z]) mirror([s > 0 ? 1 : 0, 0, 0])
        translate([-ft(DORM_OV), 0, ft(DORM_EAVE) + T_SLATE]) rotate([0, -PD, 0]) rotate([90, 0, 0])
            translate([0, -BARGE_W, 0]) color(PULLMAN_GREEN) barge_part();
}

// ---------- dormer windows (triple, segmental head) ----------
module dormer_window2d_open() { b = brow("Dormer_face_track"); bopen2d([0, 0, b[2]]); }
module dormer_window_part() {
    b = brow("Dormer_face_track"); o = b[2][0]; Dd = T_GABLE - 1.5;
    w = ft(o[2] - o[0]); x0 = ft(o[0]); y0 = ft(o[1]); y1 = ft(o[3]);
    module open2d(d = 0) offset(delta = d) translate([-x0, -y0]) bopen2d([0, 0, [o]]);
    color(PULLMAN_GREEN) {
        linear_extrude(0.8) difference() { open2d(2); open2d(-1.2); }                       // flange
        translate([0, 0, 0.8]) linear_extrude(Dd - 0.8) difference() { open2d(-0.15); open2d(-ft(0, 4)); }   // frame
        translate([0, 0, 0.8]) linear_extrude(Dd - 1.4) intersection() {                    // sashes
            open2d(-ft(0, 4));
            union() {
                for (i = [1, 2]) translate([i * w / 3 - ft(0, 2), -10]) square([ft(0, 4), 200]);   // mullions
                translate([0, (y1 - y0) * 0.55 - 1]) square([w, 2]);                                   // meeting rail
                for (i = [0 : 2]) translate([i * w / 3 + w / 6 - 0.5, (y1 - y0) * 0.55]) square([1, 200]);   // upper muntins
                difference() { open2d(-ft(0, 4)); open2d(-ft(0, 4) - ft(0, 2.5)); }
            }
        }
    }
}

// ---------- parts registry ----------
function roof_parts(bed) = concat(
  [for (p = plane_list()) [p, plane_count(p, bed), 2]],
  [for (r = ring_list()) [r, ring_count(r, bed), 4]],
  [for (b = brick_list()) [b, brick_count(b, bed), 3]],
  [for (b = brick_list()) [str(b, "_mortar"), brick_count(b, bed), 1]],
  [for (f = frame_list()) [f, frame_count(f, bed), 1]],
  [["Chimney_body", 1, chimney_layers()], ["Chimney_cap", 1, 1], ["Chimney_base", 1, chimney_base_layers()]],
  [for (c = cap_list()) [str("RoofTrim_cap_", c), cap_count(c, bed), 1]],
  [["RoofTrim_cresting", crest_count(bed), 1], ["Dormer_bargeboards", 1, 1], ["Dormer_windows", 1, 1]]
);
function in_list(n, L) = len([for (x = L) if (x == n) 1]) > 0;
function strip_suffix(n, s) = let(a = len(n), b = len(s)) a > b && (str_tail(n, a - b) == s) ? str_head(n, a - b) : "";
function str_tail(s, i) = i >= len(s) ? "" : str(s[i], str_tail(s, i + 1));
function str_head(s, n, i = 0) = i >= n ? "" : str(s[i], str_head(s, n, i + 1));

// one layer (k) of one printable section (tile), in PRINT orientation
module roof_part_layer(n, tile, k, bed = BED) {
    if (in_list(n, plane_list())) {
        r = prow(n); bb = bbox2(p_poly(r));
        translate([-bb[0][0], -bb[0][1], 0]) plane_layer(n, k, tile, bed);
    }
    if (in_list(n, ring_list())) { r = rrow(n); o = rect2(r[4], 20); translate([-o[0][0], -o[0][1], 0]) ring_layer(n, k, tile, bed, true); }
    if (in_list(n, brick_list())) brick_layer(n, [0, 1, 3][k], tile, bed);
    if (in_list(strip_suffix(n, "_mortar"), brick_list())) brick_layer(strip_suffix(n, "_mortar"), 2, tile, bed);
    if (in_list(n, frame_list())) { f = frow(n); bb = bbox2([for (p = f[2]) [ft(p[0]), ft(p[1])]]); translate([-bb[0][0], -bb[0][1], 0]) frame_part(n, tile, bed); }
    if (n == "Chimney_body") chimney_part(k);
    if (n == "Chimney_cap") chimney_cap();
    if (n == "Chimney_base") chimney_base_part(k);
    for (c = cap_list()) if (n == str("RoofTrim_cap_", c)) cap_part(c, tile, bed);
    if (n == "RoofTrim_cresting") crest_part(tile, bed);
    if (n == "Dormer_bargeboards") for (i = [0 : 3]) translate([0, i * (BARGE_W + 3), 0]) barge_part();
    if (n == "Dormer_windows") for (i = [0, 1]) translate([i * 90, 0, 0]) dormer_window_part();
}
function part_layers(n, bed) = let(m = [for (p = roof_parts(bed)) if (p[0] == n) p[2]]) len(m) ? m[0] : 1;
module roof_part(n, tile = -1, bed = BED) {
    nl = part_layers(n, bed);
    if (nl == 1 || n == "Chimney_body" || n == "Chimney_base") { if (n == "Chimney_body") chimney_part(); else if (n == "Chimney_base") chimney_base_part(); else roof_part_layer(n, tile, 0, bed); }
    else for (k = [0 : nl - 1]) roof_part_layer(n, tile, k, bed);
}

// ---------- everything in place ----------
module roofs_place() {
    color(SLATE_GRAY) for (p = plane_list()) plane_place(p);
    color(PULLMAN_GREEN) for (r = ring_list()) ring_place(r);
    for (b = brick_list()) { color(BRICK_RED) brick_place(b, [0, 1, 3]); color(MORTAR_WHITE) brick_place(b, [2]); }
    color(FRAME_GRAY) for (f = frame_list()) frame_place(f);
    chimney_place();
    for (c = cap_list()) cap_place(c);
    crest_place();
    for (side = [0, 1]) for (s = [-1, 1]) barge_place(side, s);
    for (n = ["Dormer_face_track", "Dormer_face_town"]) {
        b = brow(n); o = b[2][0];
        translate([ft(b[4][0]), ft(b[4][1]), FLOOR_Z + ft(b[6])]) rotate([0, 0, b[5]]) rotate([90, 0, 0])
            translate([ft(o[0]), ft(o[1]), -b[3]]) dormer_window_part();
    }
}
LIST = false;
if (LIST) for (p = roof_parts(BED)) echo(str("RPART|", p[0], "|", p[1], "|", p[2]));

if (VIEW == "placed") roofs_place();
else if (LAYER >= 0) roof_part_layer(PART, TILE, LAYER, BED);
else roof_part(PART, TILE, BED);
