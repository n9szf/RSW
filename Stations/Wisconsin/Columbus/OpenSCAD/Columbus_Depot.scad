// =====================================================================
//  MILWAUKEE ROAD - COLUMBUS, WIS. PASSENGER DEPOT (1906)
//  Source: Album sheet 56, drawing A-7931, Aug 31 1906 (J. A. Lindstrand, architect).
//  Drawings are private reference (in copyright): Research Library / RSW / Stations /
//  Standard depots / Album of Depot Plans 1919.  Rib Side Works, 25 Nov 2026 (rev 2).
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
//   - Measured: wing eave 13.4 ft, wing ridge about 24.6 ft, centre cornice 16 ft,
//     pediment apex 29 ft, chimney top 31 ft, window sills 4.3 ft, heads 11 ft.
//  FROM TOM'S PHOTOS (the sheet does not show the town side): centre roof is gabled to
//   the track and HIPPED on the town side; big fieldstone chimney on the town side;
//   white soffits with knee braces under the wide eaves; smooth concrete base under
//   rough (pebble-dash) walls.
//  ESTIMATE: toilet annex height, porch ceiling, exact window spacing on the town side.
//  COLOURS: Tom's own photos (Research Library / RSW / Stations / Wisconsin / Columbus /
//   Photos (private), IMG_2917-2941). The tile roof is gone today; the model shows the
//   present dark gray shingles (change COL_ROOF for the 1906 tile).
//  x along the track, y = 0 town-side face of the waiting room, track side +y, feet.
//  SCALE: 29 = G, 48 = O, 87 = HO.
// =====================================================================
SCALE = 29;
include <../../../_common/rsw_depot.scad>
COL_STUC  = "#A59C8E";   // warm gray-taupe concrete
COL_FOUND = "#A09B8F";   // concrete base
COL_TRIM  = "#E8E6DF";   // white soffits, brackets, fascia
COL_SASH  = "#E8E6DF";   // white window frames
COL_ROOF  = "#5A5B5F";   // dark gray shingles (1906: red tile)
COL_DOOR  = "#A8322C";   // red doors
COL_BRICK = "#6A4A3E";   // brick inside the porch arches
FLOOR = 1.5;

L = 96;  DW = 29;  DE = 22;  YT = 29;          // length, west depth, east depth, track face
CX0 = 25.5;  CL = 45;  CP = 6.83;              // centre section start, length, projection
EAVE = 13.4;  CEAVE = 16;  PRISE = 0.58;       // wing plate, centre plate, pediment pitch

BLOCKS = [
    [0,        40,       0,       DW,      EAVE,  0.5,   0, 6, 1],   // 0 west: general waiting room
    [40,       L - 40,   YT - DE, DE,      EAVE,  0.5,   0, 6, 1],   // 1 east: smoking room, baggage
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

difference() {
    depot(blocks = BLOCKS,
        wins = [
            // track side: west triplet, east single, office bay triplet
            for (x = [8.3, 12.5, 16.7]) [x, 1, 3.3, 6.7, 4.3, 0],
            [74, 1, 3, 6.7, 4.3, 1],
            for (x = [44.3, 48, 51.7]) [x, 1, 3, 6.9, 4.3, 2],
            // town side
            [7.5, 0, 3, 6.7, 4.3, 0], [12, 0, 3, 6.7, 4.3, 0], [27, 0, 3, 6.7, 4.3, 3],
            [66.5, 0, 3, 6.7, 4.3, 1], [80, 0, 3, 6.7, 4.3, 1], [90, 0, 3, 6.7, 4.3, 1],
            // ends
            [9, 2, 3, 6.7, 4.3, 0], [18, 2, 3, 6.7, 4.3, 0], [12, 3, 3, 6.7, 4.3, 1], [20.6, 3, 3, 6.7, 4.3, 1]],
        doors = [[30.3, 1, 3.5, 7.5, 0, 0], [58.6, 1, 3.5, 7.5, 0, 1],      // into the porches
                 [90.5, 1, 6.5, 8.5, 1, 1], [35, 0, 3.5, 7.5, 0, 3]],       // baggage double door, town door
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

// fieldstone chimney on the town side (photos)
COL_FSTONE = "#8C877F";
color(COL_FSTONE) if (PAINT == "" || PAINT == "chimney") {
    fbox(45.5, -5.2, 0, 3.6, 3.2, 31);
    fbox(45.2, -5.5, 30.4, 4.2, 3.8, 0.8);
}

// knee braces under the wide wing eaves (white, photos)
paint("trim") for (k = [0, 1]) let (b = BLOCKS[k])
    for (x = [b[0] + 2 : 5 : b[0] + b[1] - 1], s = [0, 1])
        if (!(s == 1 && x > CX0 - 1 && x < CX0 + CL + 1) && !(s == 0 && x > 30 && x < 62))
            translate([ft(x), s ? ft(b[2] + b[3]) : ft(b[2]), ft(b[4] - 3.4)]) rotate([0, 0, s ? 0 : 180]) rotate([90, 0, 90])
                linear_extrude(ft(0.35)) polygon([[0, 0], [0, ft(3)], [ft(b[7] * 0.75), ft(3 - b[7] * 0.75 * b[5])], [ft(0.4), ft(0.3)]]);
