// =====================================================================
//  MILWAUKEE ROAD - COLUMBUS, WIS. PASSENGER DEPOT (1906)
//  Source: Album sheet 56, drawing A-7931, Aug 31 1906 (J. A. Lindstrand, architect).
//  Drawings are private reference (in copyright): Research Library / RSW / Stations /
//  Standard depots / Album of Depot Plans 1919.  Rib Side Works, 26 Nov 2026 (rev 4).
//
//  FROM THE SHEET (plan and track elevation share one scale, 11.56 px/ft at full size):
//   - 96 ft long. West part (general waiting room 26x40) is 29 ft deep; east part
//     (smoking room 20x22, baggage 17'8"x20) is 22 ft deep - the step is on the town side.
//   - Centre section 45 ft (wings 25'6" each side) projects 6'10" toward the track and
//     carries a tall gable (pediment) facing the track, with a half-round window, two
//     arched open porches and the office bay between them.
//   - Toilet annex (women, men) on the town side, 3'8" beyond the waiting room wall.
//   - 1/4-pitch TILE roof, wide eaves (about 6 ft), concrete walls on a concrete base,
//     rusticated (banded) concrete on the centre section.
//   - Measured: wing eave 13.4 ft (the eave LINE; rev 4 raises the wing plate to 16.4 ft so the
//     6 ft eave lands at 13.4 - before it sat 3 ft low and cut off the window heads), wing ridge about 24.6 ft, centre cornice 16 ft,
//     pediment apex 29 ft, chimney top 31 ft, window sills 4.3 ft, heads 11 ft.
//  FROM TOM'S PHOTOS (the sheet does not show the town side): centre roof is gabled to
//   the track and HIPPED on the town side; big fieldstone chimney on the town side;
//   smooth concrete base under rough (pebble-dash) walls.
//  FROM TOM'S PHOTOS 25-26 Nov (IMG_9945-9951, IMG_0849-0852, rev 4): the wing eaves have a
//   white beadboard soffit that SLOPES with the roof, carried on long flat white timbers
//   (lookouts) running from the wall nearly to the fascia, about 3 ft apart (no knee braces).
//   Upper sashes of the old town-side windows have a big diamond (lozenge) muntin pattern;
//   the track-side west triplet with fluted mullions has plain (replacement) sashes today.
//   East end (IMG_2917, 2932-2936, 0849): two small plain single-light windows high in the wall.
//  Town side (rev 4b, IMG_2918-2923, 2938): two short diamond lights, red door with diamond
//   transom and sidelight, annex with two diamond windows, office door, diamond triplet with fluted
//   mullions, one more diamond window. The overhead door at the east end is a later change - left out.
//  ESTIMATE: toilet annex height, porch ceiling, exact window spacing on the town side,
//   lookout size (4x7 in) and spacing (3 ft), diamond sashes only where photographed (town side).
//  COLOURS: Tom's own photos (Research Library / RSW / Stations / Wisconsin / Columbus /
//   Photos (private), IMG_2917-2941). The tile roof is gone today; the model shows the
//   present dark gray shingles (set TILE_ROOF = true for the 1906 red tile).
//  x along the track, y = 0 town-side face of the waiting room, track side +y, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
TILE_ROOF = false;       // true = the 1906 red tile roof (sheet 56); false = today's dark gray shingles
include <../../../_common/rsw_depot.scad>
COL_STUC  = "#A59C8E";   // warm gray-taupe concrete
COL_FOUND = "#A09B8F";   // concrete base
COL_TRIM  = "#E8E6DF";   // white soffits, brackets, fascia
COL_SASH  = "#E8E6DF";   // white window frames
COL_ROOF  = TILE_ROOF ? "#9C4A32" : "#5A5B5F";
COL_DOOR  = "#A8322C";   // red doors
COL_BRICK = "#6A4A3E";   // brick inside the porch arches
FLOOR = 1.5;

L = 96;  DW = 29;  DE = 22;  YT = 29;          // length, west depth, east depth, track face
CX0 = 25.5;  CL = 45;  CP = 6.83;              // centre section start, length, projection
EAVE = 16.4;  CEAVE = 16;  PRISE = 0.58;       // wing plate (eave line 13.4 on the sheet), centre plate, pediment pitch

BLOCKS = [
    [0,        40,       0,       DW,      EAVE,  0.5,   5, 6, 1],   // 0 west: general waiting room (roof drawn below)
    [40,       L - 40,   YT - DE, DE,      EAVE,  0.5,   5, 6, 1],   // 1 east: smoking room, baggage (roof drawn below)
    [CX0,      CL,       0,       YT + CP, CEAVE, PRISE, 5, 2, 1],   // 2 centre section (roof drawn below)
    [31,       30,      -3.67,    4.6,     11,    0.5,   0, 1, 1]];  // 3 toilet annex (town side)

// porch voids: open porches each side of the office bay, arched opening to the track
PORCHES = [[CX0 + 1, 13.2], [56.3, 13.2]];     // [x start, length]
module porch_voids() for (p = PORCHES) {
    translate([ft(p[0]), ft(YT + 0.01), ft(0.6)]) cube([ft(p[1]), ft(CP - 1.2), ft(12)]);
    xc = p[0] + p[1] / 2;
    translate([ft(xc), ft(YT + CP - 1.4), 0]) rotate([-90, 0, 0]) linear_extrude(ft(1.6)) hull() {
        translate([-ft(AR), -ft(AZ)]) square([ft(2 * AR), ft(AZ - 0.6)]);
        translate([0, -ft(AZ)]) circle(ft(AR), $fn = 48);
    }
}

// ---- front of the centre section (Tom's photos IMG_2925, 2926, 2930) ----
YF = YT + CP;                         // track face of the centre section
ARCH = [for (p = PORCHES) p[0] + p[1] / 2];   // arch centres; springing at 9 ft, radius 4.2
AZ = 8.3;  AR = 4.2;  VR = 7.4;        // springing (arch top 12.5 ft on the sheet), arch radius, outer edge of the voussoirs
GZ = [for (z = [5.0 : 1.12 : 14.6]) z];  // incised horizontal grooves
// flat 2D child on the track face, reading correctly from the track: from y = YF + y0 outward by d
module on_front(x, z, d = 0.15, y0 = -0.01) translate([ft(x), ft(YF + y0), ft(z)]) rotate([90, 0, 180]) linear_extrude(ft(d)) children();
module front_grooves() {
    difference() {
        for (z = GZ) translate([ft(CX0 - 0.5), ft(YF - 0.12), ft(z)]) cube([ft(CL + 1), ft(0.6), ft(0.13)]);
        for (xc = ARCH) translate([ft(xc), ft(YF - 1), ft(AZ)]) rotate([-90, 0, 0])
            linear_extrude(ft(2)) intersection() { circle(ft(VR), $fn = 64); translate([-ft(VR), -ft(VR)]) square([ft(2 * VR), ft(VR)]); }
        translate([ft(42.3), ft(YF - 1), ft(4.0)]) cube([ft(11.4), ft(2), ft(10.2)]);          // windows and name panel
    }
    for (xc = ARCH, z = GZ) if (z > AZ && z < AZ + VR) let (a = asin((z - AZ) / VR)) for (s = [-1, 1])   // voussoir joints
        translate([ft(xc), ft(YF - 0.12), ft(AZ)]) rotate([0, -(s > 0 ? a : 180 - a), 0])
            translate([ft(AR), 0, -ft(0.065)]) cube([ft(VR - AR), ft(0.6), ft(0.13)]);
    for (xc = ARCH) translate([ft(xc), ft(YF - 0.12), ft(AZ)]) rotate([-90, 0, 0]) linear_extrude(ft(0.6))   // groove round the arch edge
        intersection() { difference() { circle(ft(AR + 0.75), $fn = 64); circle(ft(AR + 0.62), $fn = 64); } translate([-ft(6), -ft(6)]) square([ft(12), ft(6)]); }
}
module name_panel_recess() translate([ft(XM - 6.2), ft(YF - 0.25), ft(11.55)]) cube([ft(12.4), ft(1), ft(2.3)]);

TRIP = [74.5, 78.6, 82.7];                     // town-side triplet centres (east part)
WINS = [
    // track side: west triplet, east single, office bay triplet
    for (x = [8.3, 12.5, 16.7]) [x, 1, 3.3, 6.7, 4.3, 0],
    [74, 1, 3, 6.7, 4.3, 1],
    for (x = [44.3, 48, 51.7]) [x, 1, 3, 6.9, 4.3, 2],
    // town side, west to east (Tom's photos IMG_2918-2923, 2938; spacing ESTIMATE)
    [9, 0, 3.6, 2.8, 8, 0], [17, 0, 3.6, 2.8, 8, 0], [24.6, 0, 1.6, 4.5, 4.3, 0],   // two short diamond lights, sidelight by the red door
    [40.5, 0, 3, 5.5, 4.3, 3], [51.5, 0, 3, 5.5, 4.3, 3],                          // toilet annex: two diamond double-hung
    [68, 0, 3, 6.7, 4.3, 2],                                                       // centre section, east of the annex
    for (x = TRIP) [x, 0, 3.2, 6.7, 4.3, 1],                                        // diamond triplet with fluted mullions (IMG_2922)
    [91.5, 0, 3, 6.7, 4.3, 1],
    // ends
    [9, 2, 3, 6.7, 4.3, 0], [18, 2, 3, 6.7, 4.3, 0]];   // east end windows drawn below (single lights, no meeting rail)

difference() {
    depot(blocks = BLOCKS,
        wins = WINS,
        doors = [[30.3, 1, 3.5, 7.5, 0, 0],                                   // west porch door (brick infill, IMG_2925, 2929)
                 [90.5, 1, 6.5, 8.5, 1, 1],                                   // baggage double door
                 [27.3, 0, 3.3, 7.5, 0, 0], [64, 0, 3, 7.5, 0, 2]],          // town side: red door (diamond transom), office door
        plat = [-15, 126, 16, 1]);
    color("#5E5850") porch_voids();                  // these colours only show in the OpenSCAD preview
    color("#6F685E") front_grooves();
    color(COL_STUC) name_panel_recess();
}

// concrete base (battered plinth) to sill height, and the banded centre front
paint("foundation") {
    fbox(-0.35, -0.35, 0, 40.7, DW + 0.7, 4.2);
    fbox(39.6, YT - DE - 0.35, 0, L - 39.25, DE + 0.7, 4.2);
    for (x = [CX0 - 0.25, PORCHES[0][0] + PORCHES[0][1] - 0.3, PORCHES[1][0] - 1.0, CX0 + CL - 0.95])   // porch piers
        fbox(x, YT + CP - 1.2, 0, 1.25, 1.55, 4.6);
    BANDX = [[CX0 - 0.1, PORCHES[0][0]], [PORCHES[0][0] + PORCHES[0][1], PORCHES[1][0]], [PORCHES[1][0] + PORCHES[1][1], CX0 + CL + 0.1]];
    for (b = BANDX) fbox(b[0], YT + CP - 0.05, 0, b[1] - b[0], 0.3, 4.4);                        // smooth battered base
}
paint("trim") fbox(CX0 - 1.2, YT + CP, CEAVE - 0.9, CL + 2.4, 0.9, 0.9);          // cornice under the pediment

// centre roof: gable facing the track, hipped toward the town side (photos)
CRIDGE = CEAVE + PRISE * CL / 2;
COV = 2;
YEND = YT + CP + COV;  YR0 = CL / 2 - COV;  E0 = CEAVE - COV * PRISE;  XM = CX0 + CL / 2;
paint("roof") {
    for (s = [0, 1]) hull() {                                                    // two long slopes
        fbox(s ? CX0 + CL + COV - 0.1 : CX0 - COV, -COV, E0, 0.1, YEND + COV, 0.6);
        fbox(XM - 0.05, YR0, CRIDGE, 0.1, YEND - YR0, 0.6);
    }
    hull() { fbox(CX0 - COV, -COV, E0, CL + 2 * COV, 0.1, 0.6); fbox(XM - 0.05, YR0, CRIDGE, 0.1, 0.1, 0.6); }   // hip, town side
}
paint("trim") fbox(CX0 - COV, -COV, CEAVE - COV * PRISE - 0.6, CL + 2 * COV, YT + CP + 2 * COV, 0.6);
paint("stucco") difference() {                                                   // pediment wall
    translate([ft(CX0), ft(YT + CP), ft(CEAVE)]) rotate([90, 0, 0]) linear_extrude(ft(0.5))
        polygon([[0, 0], [ft(CL), 0], [ft(CL / 2), ft(CRIDGE - CEAVE)]]);
    for (a = [20 : 16 : 160]) on_front(XM, CEAVE + 0.2, 0.6, -0.12) rotate([0, 0, a]) translate([ft(5), -ft(0.06)]) square([ft(16), ft(0.12)]);   // sunburst lines
}
paint("stucco") {                                                                 // cast half-round with spokes
    on_front(XM, CEAVE + 0.2, 0.18) difference() { circle(ft(4.3), $fn = 64); circle(ft(3.7), $fn = 64); translate([-ft(5), -ft(10)]) square(ft(10)); }
    on_front(XM, CEAVE + 0.2, 0.18) difference() { circle(ft(2.1), $fn = 48); circle(ft(1.6), $fn = 48); translate([-ft(5), -ft(10)]) square(ft(10)); }
    for (a = [0 : 22.5 : 180]) on_front(XM, CEAVE + 0.2, 0.18) rotate([0, 0, a]) translate([0, -ft(0.12)]) square([ft(4), ft(0.24)]);
}
paint("trim") for (k = [0, 1]) let (x = 44.3 + 3.7 * k + 1.85)                     // white fluted pilasters between the centre windows
    fbox(x - 0.55, YT + CP - 0.05, 4.0, 1.1, 0.25, 7.4);
paint("stucco") on_front(XM, 11.95, 0.24, -0.25) text("COLUMBUS.", size = ft(1.25), font = "Liberation Sans:style=Bold", halign = "center", spacing = 1.15);   // raised letters in the panel

// fieldstone chimney on the town side (photos: it comes up through the roof, not down the wall)
COL_FSTONE = "#8C877F";
color(COL_FSTONE) if (PAINT == "" || PAINT == "chimney") {
    fbox(45.5, -1.8, 9, 3.6, 3.2, 22);        // rises out of the roof behind the annex (IMG_2920, 2939)
    fbox(45.2, -2.1, 30.4, 4.2, 3.8, 0.8);
}

// ---- wing roofs: hip roofs with a sloped beadboard soffit on flat lookouts (photos 25-26 Nov) ----
SKIN = 0.6;  SOFF = 0.12;                       // roof thickness, white soffit boards
LK_W = 0.33;  LK_D = 0.6;  LK_SP = 3;           // lookout width, depth below the soffit, spacing (ft)
module wing_roof_solid(b) let (ov = b[7], eave = b[4] - ov * b[5])
    roof_solid(b[0] - ov, b[1] + 2 * ov, b[2] - ov, b[3] + 2 * ov, eave, b[5], 0, SKIN);
for (k = [0, 1]) let (b = BLOCKS[k], ov = b[7], eave = b[4] - ov * b[5]) {
    paint("roof") difference() { wing_roof_solid(b); translate([0, 0, -ft(SKIN)]) wing_roof_solid(b); }
    paint("trim") {
        difference() { translate([0, 0, -ft(SKIN)]) wing_roof_solid(b); translate([0, 0, -ft(SKIN + SOFF)]) wing_roof_solid(b); }   // sloped soffit
        difference() { fbox(b[0] - ov - 0.05, b[2] - ov - 0.05, eave - 0.05, b[1] + 2 * ov + 0.1, b[3] + 2 * ov + 0.1, SKIN);         // fascia band
                       fbox(b[0] - ov + 0.1, b[2] - ov + 0.1, eave - 1, b[1] + 2 * ov - 0.2, b[3] + 2 * ov - 0.2, SKIN + 2); }
    }
}
// one lookout: from the wall (u = ov) out to u = 0.5 ft from the fascia, hanging under the sloped soffit
module lookout(ov, eave, rise) let (z0 = eave - SOFF, z1 = eave + (ov - 0.5) * rise - SOFF) hull() {
    translate([-ft(LK_W) / 2, 0, ft(eave + ov * rise - SOFF - LK_D)]) cube([ft(LK_W), ft(0.01), ft(LK_D)]);          // at the wall
    translate([-ft(LK_W) / 2, -ft(ov - 0.5), ft(eave + 0.5 * rise - SOFF - LK_D)]) cube([ft(LK_W), ft(0.01), ft(LK_D)]);   // outer end
}
paint("trim") for (k = [0, 1]) let (b = BLOCKS[k], ov = b[7], eave = b[4] - ov * b[5]) {
    for (x = [b[0] + 1.5 : LK_SP : b[0] + b[1] - 1], s = [0, 1])     // long sides, clear of the centre section
        if (!(x > CX0 - 1 && x < CX0 + CL + 1))
            translate([ft(x), s ? ft(b[2] + b[3]) : ft(b[2]), 0]) rotate([0, 0, s ? 180 : 0]) lookout(ov, eave, b[5]);
    for (y = [b[2] + 1.5 : LK_SP : b[2] + b[3] - 1])                 // outer end (west end of 0, east end of 1)
        translate([k ? ft(b[0] + b[1]) : ft(b[0]), ft(y), 0]) rotate([0, 0, k ? 90 : -90]) lookout(ov, eave, b[5]);
}

// white fluted mullions between the town-side triplet (IMG_2922)
paint("trim") for (k = [0, 1]) let (x = (TRIP[k] + TRIP[k + 1]) / 2)
    fbox(x - 0.45, YT - DE - 0.25, 4.0, 0.9, 0.25, 7.3);

// ---- diamond-pane (lozenge) upper sashes, town side (Tom's photos 25 Nov) ----
DIA_SIDES = [0];                                // add 1, 2, 3 if road-trip photos show them on other walls
DIA_ACROSS = 2;  DIA_TALL = 2.15;               // diamonds across one sash; height / width of a diamond (IMG_9949)
MUNTIN = 0.12;                                  // muntin width, ft (about 1 in)
module diamond_upper(w, h, sill) {
    full = h < 4;                               // short single lights: diamonds fill the whole light
    uh = full ? h : h / 2 - 0.08;  cw = w / (full ? 2 : DIA_ACROSS);  a = atan(DIA_TALL);   // lines meet so a diamond is cw wide, DIA_TALL*cw tall
    translate([-ft(w) / 2, ft(full ? sill : sill + h / 2 + 0.08), 0]) linear_extrude(ft(0.18)) intersection() {
        square([ft(w), ft(uh)]);
        for (i = [-2 * DIA_ACROSS - 6 : 2 * DIA_ACROSS + 6], m = [-1, 1])
            translate([ft(i * cw), 0]) rotate(m > 0 ? a : 180 - a) translate([-ft(3 * h), -ft(MUNTIN) / 2]) square([ft(6 * h), ft(MUNTIN)]);
    }
}
paint("sash") for (o = WINS) if (len([for (d = DIA_SIDES) if (d == o[1]) 1]) > 0)
    on_face(BLOCKS[o[5] == undef ? 0 : o[5]], o[0], o[1]) diamond_upper(o[2], o[3], o[4]);

// ---- diamond lattice, w x h ft, n diamonds across, diamond height / width = tall ----
module lattice(w, h, n, tall, t = MUNTIN) let (cw = w / n, a = atan(tall)) intersection() {
    square([ft(w), ft(h)]);
    for (i = [-2 * n - 8 : 2 * n + 8], m = [-1, 1])
        translate([ft(i * cw), 0]) rotate(m > 0 ? a : 180 - a) translate([-ft(3 * (w + h)), -ft(t) / 2]) square([ft(6 * (w + h)), ft(t)]);
}
// flat 2D child on the porch back wall (y = YT), seen from the track; z up
module on_back(x, z, y0, d) translate([ft(x), ft(YT + y0), ft(z)]) rotate([90, 0, 180]) translate([0, 0, -ft(d)]) linear_extrude(ft(d)) children();

// ---- east porch entrance (IMG_2926): white frame, red door, diamond sidelights and transom ----
module porch_entry(xc) {
    W = 7.6;  Z0 = 0.8;
    paint("trim")  fbox(xc - W / 2, YT, Z0, W, 0.15, 9.4);
    paint("glass") { for (s = [-1, 1]) fbox(xc + s * 2.75 - 0.7, YT + 0.15, 3.9, 1.4, 0.04, 4.2);
                     fbox(xc - 3.5, YT + 0.15, 8.6, 7.0, 0.04, 1.4); }
    paint("doors") fbox(xc - 1.65, YT + 0.15, Z0, 3.3, 0.15, 7.4);
    paint("sash") {
        for (s = [-1, 1]) on_back(xc + s * 2.75 + 0.7, 3.9, 0.19, 0.1) lattice(1.4, 4.2, 1, 2.0);
        on_back(xc + 3.5, 8.6, 0.19, 0.1) lattice(7.0, 1.4, 5, 1.0);
        fbox(xc - 3.5, YT + 0.15, 8.45, 7.0, 0.12, 0.15);           // transom bar
    }
}
porch_entry(PORCHES[1][0] + PORCHES[1][1] / 2);

// ---- brick lining in the west porch (Tom's photos IMG_2925, 2929) ----
paint("brick") let (p = PORCHES[0]) difference() {
    union() {
        fbox(p[0], YT + 0.01, 0.6, p[1], 0.1, 11.4);                                   // back wall
        for (x = [p[0] + 0.01, p[0] + p[1] - 0.11]) fbox(x, YT, 0.6, 0.1, CP - 1.3, 11.4);   // side walls
    }
    fbox(30.3 - 2.2, YT - 1, 0.5, 4.4, 2, 9.5);                                        // door opening
}

// ---- leaf ornaments (IMG_2930): cast leaves along the raking cornice, blocks in the frieze ----
LEAF_SP = 1.6;
module leaf() hull() { translate([-ft(0.35), 0]) circle(ft(0.18), $fn = 12); translate([ft(0.35), 0]) circle(ft(0.1), $fn = 10); }
paint("stucco") {
    for (s = [-1, 1]) let (ang = atan(PRISE), run = CL / 2 - 1.5)
        for (d = [1.2 : LEAF_SP : run])
            on_front(XM + s * (CL / 2 - d), CEAVE + 0.2 + (d) * PRISE - 0.75, 0.16) rotate([0, 0, s > 0 ? ang : -ang]) leaf();
    for (x = [CX0 + 0.3 : 1.25 : CX0 + CL - 0.3])                                          // frieze blocks under the main cornice
        on_front(x, CEAVE - 1.6, 0.2) translate([-ft(0.25), 0]) square([ft(0.5), ft(0.65)]);
}
// office door: dark-stained (IMG_9947) - a thin dark panel over the red door
paint("brick") fbox(64 - 1.5, -0.2, FLOOR, 3, 0.05, 7.5);

// ---- east end: two small single-light windows, no meeting rail (IMG_2932-2936; size ESTIMATE) ----
EAST_LIGHTS = [14.8, 22.9];     // y centres on the east end wall
module single_light(w, h, sill) translate([-ft(w) / 2, ft(sill), 0]) {
    paint("glass") cube([ft(w), ft(h), ft(0.08)]);
    paint("sash") difference() {
        translate([-ft(0.35), -ft(0.35), 0]) cube([ft(w + 0.7), ft(h + 0.7), ft(0.3)]);
        translate([ft(0.05), ft(0.05), -1]) cube([ft(w - 0.1), ft(h - 0.1), ft(1) + 2]);
    }
}
for (y = EAST_LIGHTS) on_face(BLOCKS[1], y, 3) single_light(3.4, 2.7, 7.1);
