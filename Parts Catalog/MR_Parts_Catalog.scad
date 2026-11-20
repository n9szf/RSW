// =====================================================================
//  MR_Parts_Catalog.scad  -  Milwaukee Road passenger fleet: PARTS CATALOG
//  Under-floor equipment, seats, tables and fixtures - one of each, with its part number.
//  Created by Tom Fleming, n9szf@mac.com
//
//  Stand-alone file.  Use the Customizer:
//    TRAIN     show only the parts used by one train set (year)
//    KIND      under-floor / seating / tables
//    PART_NO   show a single part (overrides TRAIN and KIND) - for review or export
//    SCALE     G 1:29, O 1:48, HO 1:87
//    FOR_PRINT lay the parts as they print (equipment top face down) without labels
//  Part numbers are fixed.  List: MR_Parts_List.csv
//  Stand-alone file: everything it needs is inside it.
// =====================================================================

/* [Pick] */
TRAIN   = "All";   // [All, 1935 Hiawatha, 1938 Branch Line, 1937 Hiawatha, 1939 Hiawatha, 1942 Hiawatha, 1947 Olympian Hiawatha, 1948 Twin Cities Hiawatha, 1948 Business Car, 1952 Super Domes]
KIND    = "All";   // [All, Under-floor, Seating, Tables]
PART_NO = "All";   // [All:All parts, ST-001:ST-001 Bedroom sofa / berth 6 ft, ST-002:ST-002 Parlor chair swivel on pedestal, ST-003:ST-003 Coach seat double (reclining), ST-004:ST-004 Dining seat double, ST-005:ST-005 Dome seat double, ST-006:ST-006 Section seat double (Touralux / open section), ST-007:ST-007 Lounge sofa 4 ft module, ST-008:ST-008 Bar stool, TB-001:TB-001 Kitchen range / counter block 4 ft module, TB-002:TB-002 RPO letter case 4 ft module, TB-003:TB-003 Bar counter 30 in module, TB-004:TB-004 Dining table 4 seats, TB-005:TB-005 Lounge table round, TB-006:TB-006 RPO sorting table 4 ft module, UF-001:UF-001 Equipment box 28x20x16 in, UF-002:UF-002 Equipment box 32x30x10 in, UF-003:UF-003 Equipment box 36x22x22 in, UF-004:UF-004 Equipment box 59x70x30 in, UF-005:UF-005 Equipment box 100x50x27 in, UF-006:UF-006 Air reservoir (across the car), UF-007:UF-007 Equipment box 60x40x20 in]

/* [Show] */
LABELS    = true;
FOR_PRINT = false;
SCALE_NAME = "G";  // [G, O, HO]

/* [Hidden] */
SCALE = SCALE_NAME == "O" ? 48 : SCALE_NAME == "HO" ? 87.1 : 29;
function ft(f) = f * 304.8 / SCALE;
function inch(i) = i * 25.4 / SCALE;
YEARS = ["1935 Hiawatha", "1938 Branch Line", "1937 Hiawatha", "1939 Hiawatha", "1942 Hiawatha", "1947 Olympian Hiawatha", "1948 Twin Cities Hiawatha", "1948 Business Car", "1952 Super Domes"];
WALL = 2.4; CLEAR = 0.25; PIN_D = 2.1; PIN_DEPTH = 6;
W  = ft(10);                                 // car width the seats are sized for
IW = W - 2 * (WALL + CLEAR) - 1;             // usable interior width
PART_H = inch(64);
$fn = 40;

// [part number, kind, name, shape, dims (prototype inches), train indices]
PARTS = [
    ["ST-001", "ST", "Bedroom sofa / berth, 6 ft", "berth_room", [], [2, 3, 5, 7]],
    ["ST-002", "ST", "Parlor chair, swivel on pedestal", "chair_parlor", [], [0, 2, 3, 6]],
    ["ST-003", "ST", "Coach seat, double (reclining)", "seat_coach", [], [0, 1, 2, 3, 4, 5, 6]],
    ["ST-004", "ST", "Dining seat, double", "seat_diner", [], [2, 3, 4, 5, 6, 7]],
    ["ST-005", "ST", "Dome seat, double", "seat_dome", [], [8]],
    ["ST-006", "ST", "Section seat, double (Touralux / open section)", "seat_section", [], [5]],
    ["ST-007", "ST", "Lounge sofa, 4 ft module", "sofa_lounge", [], [0, 2, 3, 4, 5, 6, 7, 8]],
    ["ST-008", "ST", "Bar stool", "stool_bar", [], [0, 2, 3, 4, 5, 6]],
    ["TB-001", "TB", "Kitchen range / counter block, 4 ft module", "block_kitchen", [], [2, 3, 4, 5, 6, 7]],
    ["TB-002", "TB", "RPO letter case, 4 ft module", "case_rpo", [], [1, 2, 3, 5, 6]],
    ["TB-003", "TB", "Bar counter, 30 in module", "counter_bar", [], [0, 2, 3, 4, 5, 6]],
    ["TB-004", "TB", "Dining table, 4 seats", "table_diner", [], [2, 3, 4, 5, 6, 7]],
    ["TB-005", "TB", "Lounge table, round", "table_lounge", [], [0, 2, 3, 4, 5, 6, 7, 8]],
    ["TB-006", "TB", "RPO sorting table, 4 ft module", "table_rpo", [], [1, 2, 3, 5, 6]],
    ["UF-001", "UF", "Equipment box", "box", [28, 20, 16], [0, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-002", "UF", "Equipment box", "box", [32, 30, 10], [0, 1, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-003", "UF", "Equipment box", "box", [36, 22, 22], [0, 1, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-004", "UF", "Equipment box", "box", [59, 70, 30], [0, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-005", "UF", "Equipment box", "box", [100, 50, 27], [0, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-006", "UF", "Air reservoir (across the car)", "tankx", [16, 44], [0, 1, 2, 3, 4, 5, 6, 7, 8]],
    ["UF-007", "UF", "Equipment box", "box", [60, 40, 20], [1]]
];

function kind_ok(p) = KIND == "All" || (KIND == "Under-floor" && p[1] == "UF") || (KIND == "Seating" && p[1] == "ST") || (KIND == "Tables" && p[1] == "TB");
function year_ok(p) = TRAIN == "All" || len([for (i = p[5]) if (YEARS[i] == TRAIN) 1]) > 0;
SEL = PART_NO != "All" ? [for (p = PARTS) if (p[0] == PART_NO) p] : [for (p = PARTS) if (kind_ok(p) && year_ok(p)) p];

module seat(w, facing = 1) {
    d = inch(20); sh = inch(17); bh = inch(38); bt = inch(4);
    translate([-d/2, -w/2, 0]) cube([d, w, sh]);
    translate([facing > 0 ? -d/2 - bt * 0.2 : d/2 - bt * 0.8, -w/2, 0]) cube([bt, w, bh]);
}
module pinholes(pts, top) { for (p = pts) translate([p[0], p[1], top - PIN_DEPTH]) cylinder(d = PIN_D, h = PIN_DEPTH + 1, $fn = 16); }

// each part sits on z = 0, centred on x / y, top face up (as fitted: equipment hangs from its top face)
module shape(p) {
    s = p[3]; d = p[4];
    if (s == "box") difference() {
        translate([-inch(d[0])/2, -inch(d[1])/2, 0]) cube([inch(d[0]), inch(d[1]), inch(d[2])]);
        pinholes(d[0] >= d[1] ? [[-inch(d[0]) * 0.3, 0], [inch(d[0]) * 0.3, 0]] : [[0, -inch(d[1]) * 0.3], [0, inch(d[1]) * 0.3]], inch(d[2]));
    }
    else if (s == "tank") { dia = inch(d[1]); l = inch(d[0]); h = dia + inch(3);
        difference() {
            union() {
                translate([-l/2, 0, dia/2]) rotate([0, 90, 0]) cylinder(d = dia, h = l);
                for (k = [-1, 1]) translate([k * l * 0.3 - (PIN_D + 3.2)/2, -dia/2, dia/2]) cube([PIN_D + 3.2, dia, h - dia/2]);
            }
            pinholes([[-l * 0.3, 0], [l * 0.3, 0]], h);
        }
    }
    else if (s == "tankx") { dia = inch(d[0]); l = inch(d[1]); h = dia + inch(2);
        difference() {
            union() {
                translate([0, -l/2, dia/2]) rotate([-90, 0, 0]) cylinder(d = dia, h = l);
                translate([-dia * 0.3, -l/2, dia/2]) cube([dia * 0.6, l, h - dia/2]);
            }
            pinholes([[0, -l * 0.3], [0, l * 0.3]], h);
        }
    }
    else if (s == "seat_coach" || s == "seat_diner") seat((IW - inch(s == "seat_diner" ? 28 : 24)) / 2 - 0.6);
    else if (s == "seat_section") seat((IW - inch(24)) / 2 - 0.6);
    else if (s == "seat_dome") seat((W * 0.88 - 2 * (WALL + CLEAR) - 2 - inch(20)) / 2 - 0.6);
    else if (s == "chair_parlor") { cylinder(d = inch(10), h = inch(6)); seat(inch(24)); }
    else if (s == "table_diner") translate([-inch(18), -(IW - inch(28)) / 4 + 0.3, 0]) cube([inch(36), (IW - inch(28)) / 2 - 0.6, inch(29)]);
    else if (s == "sofa_lounge") translate([-ft(2), -inch(12), 0]) { cube([ft(4), inch(24), inch(16)]); translate([0, inch(19), 0]) cube([ft(4), inch(5), inch(32)]); }
    else if (s == "table_lounge") cylinder(d = inch(20), h = inch(20));
    else if (s == "stool_bar") cylinder(d = inch(14), h = inch(28));
    else if (s == "counter_bar") translate([-inch(15), -inch(15), 0]) cube([inch(30), inch(30), inch(42)]);
    else if (s == "berth_room") translate([-ft(3), -inch(15), 0]) cube([ft(6), inch(30), inch(18)]);
    else if (s == "case_rpo") translate([-ft(2), -inch(8), 0]) difference() {
        cube([ft(4), inch(16), PART_H]);
        for (k = [1:1:4]) translate([inch(6), -1, inch(30) + k * inch(7)]) cube([ft(4) - inch(12), 1.4, 0.6]);
    }
    else if (s == "table_rpo") translate([-ft(2), -inch(12), 0]) cube([ft(4), inch(24), inch(36)]);
    else if (s == "block_kitchen") translate([-ft(2), -(IW - inch(28)) / 2, 0]) cube([ft(4), IW - inch(28), PART_H]);
}

function part_col(p) = p[1] == "UF" ? "#6F7478" : p[1] == "ST" ? "#7A3B2E" : "#B08D57";
CELL_X = ft(11);  CELL_Y = ft(11);
COLS = max(1, ceil(sqrt(len(SEL) * 1.6)));
if (len(SEL) == 0) echo("No parts match - change TRAIN / KIND / PART_NO");
for (i = [0:1:len(SEL) - 1]) let(p = SEL[i])
    translate([(i % COLS) * CELL_X, -floor(i / COLS) * CELL_Y, 0]) {
        color(part_col(p))
            if (FOR_PRINT && p[1] == "UF") translate([0, 0, 0]) mirror([0, 0, 1]) translate([0, 0, -200]) intersection() { translate([0, 0, 200]) mirror([0, 0, 1]) shape(p); translate([-500, -500, 0]) cube(1000); }
            else shape(p);
        if (LABELS && !FOR_PRINT) color("#202020") translate([0, -CELL_Y * 0.42, 0]) linear_extrude(0.4) {
            text(p[0], size = ft(0.9), halign = "center", font = "Liberation Sans:style=Bold");
            translate([0, -ft(0.75)]) text(p[2], size = ft(0.42), halign = "center");
        }
    }
echo(str("PARTS CATALOG: ", len(SEL), " part(s) shown of ", len(PARTS), "  (train ", TRAIN, ", kind ", KIND, ", part ", PART_NO, ", 1:", SCALE, ")"));
for (p = SEL) echo(str("  ", p[0], "  ", p[2]));
