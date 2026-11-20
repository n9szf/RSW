// =====================================================================
//  PEOPLE - figures from Tom's download "Super Collection of Miniature People - 194 Figures" (Jose Pedro).
//  The original STLs are in metres; they are scaled to the model scale here (1000 / SCALE).
//  Each row: [file, unit factor, centre x, back-or-centre y (m), x ft, y ft, turn, zone ("in" = on the floor,
//  "pl" = on the platform), raise ft].  Figures face -y (the track) at turn 0.  Move people by editing x, y, turn.
//  Print files: STL/Bambu P1S/People/ (already scaled; print standing, paint by hand).
//  Colours: each figure is cut by height into head / top / bottom / shoes (People/bands); change the colours in FIG.
// =====================================================================
include <../janesville_common.scad>
PEOPLE_FL = SCALE > 50 ? 0.6 : 1.0;      // floor overlay thickness (mm)
PEOPLE = [
  ["lowpoly_female_sitting001_lowpoly_female_sitting.stl", 1, 0.109, 0.161, 7.50, 10.50, 0, "in", 0.0],
  ["lowpoly_male_sitting001_lowpoly_male_sitting001.stl", 1, 0.013, 0.097, 12.50, 11.50, 180, "in", 0.0],
  ["lowpoly_female_sitting002_lowpoly_female_sitting001.stl", 1, 0.004, 0.191, 21.50, 10.50, 0, "in", 0.0],
  ["lowpoly_male_sitting002_lowpoly_male_sitting002.stl", 1, 0.035, 0.063, 26.50, 10.50, 0, "in", 0.0],
  ["lowpoly_female_sitting003_lowpoly_female_sitting002.stl", 1, 0.065, 0.194, 24.00, 11.50, 180, "in", 0.0],
  ["lowpoly_male_sitting003_lowpoly_male_sitting.stl", 1, 0.000, 0.139, 7.50, 20.50, 0, "in", 0.0],
  ["lowpoly_female_sitting004_lowpoly_female_sitting.stl", 1, -0.004, 0.248, 10.00, 21.50, 180, "in", 0.0],
  ["lowpoly_male_sitting004_lowpoly_male_sitting001.stl", 1, 0.031, 0.096, 26.50, 21.50, 180, "in", 0.0],
  ["lowpoly_female_sitting007_lowpoly_female_sitting.stl", 1, 0.108, 0.218, 21.50, 20.50, 0, "in", 0.0],
  ["lowpoly_male_sitting008_lowpoly_male_sitting.stl", 1, 0.124, 0.132, 69.50, 10.50, 0, "in", 0.0],
  ["lowpoly_female_sitting008_lowpoly_female_sitting001.stl", 1, 0.042, 0.137, 74.50, 11.50, 180, "in", 0.0],
  ["lowpoly_male_sitting009_lowpoly_male_sitting001.stl", 1, 0.071, 0.095, 72.00, 20.50, 0, "in", 0.0],
  ["lowpoly_female_sitting010_lowpoly_female_sitting.stl", 1, 0.041, 0.166, 74.50, 21.50, 180, "in", 0.0],
  ["lowpoly_male_sitting011_lowpoly_male_sitting.stl", 1, 0.006, 0.150, 1.25, 5.00, 90, "in", 0.0],
  ["lowpoly_female_sitting011_lowpoly_female_sitting.stl", 1, 0.131, 0.309, 1.25, 26.00, 90, "in", 0.0],
  ["lowpoly_male_sitting012_lowpoly_male_sitting001.stl", 1, -0.063, 0.186, 1.25, 28.50, 90, "in", 0.0],
  ["lowpoly_male_sitting010_lowpoly_male_sitting002.stl", 1, -0.001, 0.145, 120.00, 11.90, 180, "in", 0.7],
  ["lowpoly_female_sitting009_lowpoly_female_sitting002.stl", 1, 0.042, -0.062, 124.00, 11.90, 180, "in", 0.7],
  ["lowpoly_male_standing001_lowpoly_male_standing001.stl", 1, -0.049, -0.155, 36.50, 7.00, 90, "in", 0.0],
  ["lowpoly_female_in_coat_lowpoly_female_in_coat.stl", 1, -0.003, -0.060, 34.00, 8.50, 90, "in", 0.0],
  ["lowpoly_male_standing003_lowpoly_male_standing002.stl", 1, -0.002, -0.007, 15.00, 16.00, 200, "in", 0.0],
  ["lowpoly_female_standing001_lowpoly_female_standing001.stl", 1, -0.037, -0.027, 17.00, 16.60, 20, "in", 0.0],
  ["lowpoly_man_adjusting_hat_lowpoly_man_adjusting_hat.stl", 10, 0.017, 0.000, 37.00, 29.00, 90, "in", 0.0],
  ["lowpoly_children_lowpoly_children.stl", 1, 0.010, -0.012, 13.00, 15.50, 150, "in", 0.0],
  ["lowpoly_children001_lowpoly_children.stl", 1, 0.027, 0.028, 14.20, 14.60, 200, "in", 0.0],
  ["lowpoly_woman_holding_a_child_lowpoly_woman_holding_a_child.stl", 1, 0.011, 0.027, 30.00, 16.00, 300, "in", 0.0],
  ["lowpoly_smoking_man_lowpoly_smoking_man.stl", 1, 0.009, -0.092, 80.00, 16.00, 0, "in", 0.0],
  ["lowpoly_male_standing004_lowpoly_male_standing012.stl", 1, -0.016, -0.082, 64.00, 6.00, 270, "in", 0.0],
  ["lowpoly_male_standing005_lowpoly_male_standing003.stl", 1, 0.049, 0.002, 82.00, 17.50, 170, "in", 0.0],
  ["lowpoly_female_standing002_lowpoly_female_standing002.stl", 1, -0.049, -0.053, 108.00, 15.00, 90, "in", 0.0],
  ["lowpoly_male_standing006_lowpoly_male_standing004.stl", 1, -0.040, 0.031, 178.42, 12.00, 0, "in", 0.0],
  ["lowpoly_male_standing007_lowpoly_male_standing005.stl", 1, 0.010, 0.015, 208.42, 14.00, 180, "in", 0.0],
  ["lowpoly_female_in_coat_standing_lowpoly_female_in_coat_standing.stl", 1, 0.013, 0.031, -20.00, -8.00, 0, "pl", 0.0],
  ["lowpoly_male_standing008_lowpoly_male_standing.stl", 1, 0.077, -0.017, -5.00, -11.00, 0, "pl", 0.0],
  ["lowpoly_female_standing003_lowpoly_female_standing003.stl", 1, -0.019, -0.016, 8.00, -9.00, 20, "pl", 0.0],
  ["lowpoly_male_standing009_lowpoly_male_standing001.stl", 1, 0.000, -0.060, 10.50, -9.50, 340, "pl", 0.0],
  ["lowpoly_male_walking001_lowpoly_male_walking.stl", 1, 0.009, -0.037, 30.00, -7.00, 90, "pl", 0.0],
  ["lowpoly_female_walking001_lowpoly_female_walking.stl", 1, 0.013, -0.088, 44.00, -12.00, 270, "pl", 0.0],
  ["lowpoly_male_standing010_lowpoly_male_standing002.stl", 1, 0.008, -0.245, 46.00, -6.00, 0, "pl", 0.0],
  ["lowpoly_female_standing004_lowpoly_female_standing.stl", 1, -0.051, -0.109, 62.00, -10.00, 0, "pl", 0.0],
  ["lowpoly_male_greets_lowpoly_male_greets.stl", 1, -0.220, -0.091, 64.50, -10.50, 300, "pl", 0.0],
  ["lowpoly_male_walking002_lowpoly_male_walking.stl", 1, 0.028, -0.066, 75.00, -6.00, 270, "pl", 0.0],
  ["lowpoly_female_standing005_lowpoly_female_standing001.stl", 1, 0.023, -0.104, 95.00, -12.00, 0, "pl", 0.0],
  ["lowpoly_male_standing011_lowpoly_male_standing003.stl", 1, -0.008, 0.013, 97.00, -11.50, 330, "pl", 0.0],
  ["lowpoly_female_walking002_lowpoly_female_walking.stl", 1, 0.050, -0.116, 110.00, -8.00, 90, "pl", 0.0],
  ["lowpoly_male_walking003_lowpoly_male_walking.stl", 1, -0.008, 0.029, 135.00, -9.00, 90, "pl", 0.0],
  ["lowpoly_male_standing012_lowpoly_male_standing004.stl", 1, 0.021, -0.066, 150.00, -12.00, 0, "pl", 0.0],
  ["lowpoly_female_standing006_lowpoly_female_standing002.stl", 1, 0.021, -0.087, 185.00, -10.00, 0, "pl", 0.0],
  ["lowpoly_male_walking004_lowpoly_male_walking.stl", 1, 0.045, -0.074, 200.00, -7.00, 270, "pl", 0.0],
  ["lowpoly_female_walking003_lowpoly_female_walking.stl", 1, 0.001, -0.025, 215.00, -11.00, 90, "pl", 0.0],
  ["lowpoly_male_walking005_lowpoly_male_walking001.stl", 1, 0.019, -0.025, 232.00, -9.00, 0, "pl", 0.0],
  ["lowpoly_female_standing007_lowpoly_female_standing003.stl", 1, 0.023, 0.020, 234.00, -9.50, 180, "pl", 0.0]
];
// skin, top, bottom and shoe colours of every figure (bands cut by height - see People/bands)
FIG = [
  ["lowpoly_children001_lowpoly_children.stl", "children001", "#E0AC84", "#6E6E72", "#232B45", "#111111"],
  ["lowpoly_children_lowpoly_children.stl", "children", "#F1C9A5", "#E6D9B8", "#9C8A62", "#3E2716"],
  ["lowpoly_female_in_coat_lowpoly_female_in_coat.stl", "female_in_coat", "#4A2C1A", "#2F4A34", "#4A3526", "#111111"],
  ["lowpoly_female_in_coat_standing_lowpoly_female_in_coat_standing.stl", "female_in_coat_standing", "#6B4226", "#ECE8DC", "#18181A", "#3E2716"],
  ["lowpoly_female_sitting001_lowpoly_female_sitting.stl", "female_sitting001", "#9A6340", "#4E6C8C", "#33343A", "#111111"],
  ["lowpoly_female_sitting002_lowpoly_female_sitting001.stl", "female_sitting002", "#C68D5E", "#6B4A2E", "#77777A", "#3E2716"],
  ["lowpoly_female_sitting003_lowpoly_female_sitting002.stl", "female_sitting003", "#E0AC84", "#B58A2A", "#4F5536", "#111111"],
  ["lowpoly_female_sitting004_lowpoly_female_sitting.stl", "female_sitting004", "#F1C9A5", "#6E1F2B", "#232B45", "#3E2716"],
  ["lowpoly_female_sitting005_lowpoly_female_sitting001.stl", "female_sitting005", "#4A2C1A", "#9A4B2A", "#9C8A62", "#111111"],
  ["lowpoly_female_sitting006_lowpoly_female_sitting002.stl", "female_sitting006", "#6B4226", "#B79A6B", "#4A3526", "#3E2716"],
  ["lowpoly_female_sitting007_lowpoly_female_sitting.stl", "female_sitting007", "#9A6340", "#1F2A44", "#18181A", "#111111"],
  ["lowpoly_female_sitting008_lowpoly_female_sitting001.stl", "female_sitting008", "#C68D5E", "#1C1C1E", "#33343A", "#3E2716"],
  ["lowpoly_female_sitting009_lowpoly_female_sitting002.stl", "female_sitting009", "#E0AC84", "#6E6E72", "#77777A", "#111111"],
  ["lowpoly_female_sitting010_lowpoly_female_sitting.stl", "female_sitting010", "#F1C9A5", "#E6D9B8", "#4F5536", "#3E2716"],
  ["lowpoly_female_sitting011_lowpoly_female_sitting.stl", "female_sitting011", "#4A2C1A", "#2F4A34", "#232B45", "#111111"],
  ["lowpoly_female_standing001_lowpoly_female_standing001.stl", "female_standing001", "#6B4226", "#ECE8DC", "#9C8A62", "#3E2716"],
  ["lowpoly_female_standing002_lowpoly_female_standing002.stl", "female_standing002", "#9A6340", "#4E6C8C", "#4A3526", "#111111"],
  ["lowpoly_female_standing003_lowpoly_female_standing003.stl", "female_standing003", "#C68D5E", "#6B4A2E", "#18181A", "#3E2716"],
  ["lowpoly_female_standing004_lowpoly_female_standing.stl", "female_standing004", "#E0AC84", "#B58A2A", "#33343A", "#111111"],
  ["lowpoly_female_standing005_lowpoly_female_standing001.stl", "female_standing005", "#F1C9A5", "#6E1F2B", "#77777A", "#3E2716"],
  ["lowpoly_female_standing006_lowpoly_female_standing002.stl", "female_standing006", "#4A2C1A", "#9A4B2A", "#4F5536", "#111111"],
  ["lowpoly_female_standing007_lowpoly_female_standing003.stl", "female_standing007", "#6B4226", "#B79A6B", "#232B45", "#3E2716"],
  ["lowpoly_female_standing008_lowpoly_female_standing004.stl", "female_standing008", "#9A6340", "#1F2A44", "#9C8A62", "#111111"],
  ["lowpoly_female_walking001_lowpoly_female_walking.stl", "female_walking001", "#C68D5E", "#1C1C1E", "#4A3526", "#3E2716"],
  ["lowpoly_female_walking002_lowpoly_female_walking.stl", "female_walking002", "#E0AC84", "#6E6E72", "#18181A", "#111111"],
  ["lowpoly_female_walking003_lowpoly_female_walking.stl", "female_walking003", "#F1C9A5", "#E6D9B8", "#33343A", "#3E2716"],
  ["lowpoly_female_walking004_lowpoly_female_walking001.stl", "female_walking004", "#4A2C1A", "#2F4A34", "#77777A", "#111111"],
  ["lowpoly_female_walking005_lowpoly_female_walking.stl", "female_walking005", "#6B4226", "#ECE8DC", "#4F5536", "#3E2716"],
  ["lowpoly_male_greets_lowpoly_male_greets.stl", "male_greets", "#9A6340", "#4E6C8C", "#232B45", "#111111"],
  ["lowpoly_male_sitting001_lowpoly_male_sitting001.stl", "male_sitting001", "#C68D5E", "#6B4A2E", "#9C8A62", "#3E2716"],
  ["lowpoly_male_sitting002_lowpoly_male_sitting002.stl", "male_sitting002", "#E0AC84", "#B58A2A", "#4A3526", "#111111"],
  ["lowpoly_male_sitting003_lowpoly_male_sitting.stl", "male_sitting003", "#F1C9A5", "#6E1F2B", "#18181A", "#3E2716"],
  ["lowpoly_male_sitting004_lowpoly_male_sitting001.stl", "male_sitting004", "#4A2C1A", "#9A4B2A", "#33343A", "#111111"],
  ["lowpoly_male_sitting005_lowpoly_male_sitting002.stl", "male_sitting005", "#6B4226", "#B79A6B", "#77777A", "#3E2716"],
  ["lowpoly_male_sitting006_lowpoly_male_sitting003.stl", "male_sitting006", "#9A6340", "#1F2A44", "#4F5536", "#111111"],
  ["lowpoly_male_sitting007_lowpoly_male_sitting004.stl", "male_sitting007", "#C68D5E", "#1C1C1E", "#232B45", "#3E2716"],
  ["lowpoly_male_sitting008_lowpoly_male_sitting.stl", "male_sitting008", "#E0AC84", "#6E6E72", "#9C8A62", "#111111"],
  ["lowpoly_male_sitting009_lowpoly_male_sitting001.stl", "male_sitting009", "#F1C9A5", "#E6D9B8", "#4A3526", "#3E2716"],
  ["lowpoly_male_sitting010_lowpoly_male_sitting002.stl", "male_sitting010", "#4A2C1A", "#2F4A34", "#18181A", "#111111"],
  ["lowpoly_male_sitting011_lowpoly_male_sitting.stl", "male_sitting011", "#6B4226", "#ECE8DC", "#33343A", "#3E2716"],
  ["lowpoly_male_sitting012_lowpoly_male_sitting001.stl", "male_sitting012", "#9A6340", "#4E6C8C", "#77777A", "#111111"],
  ["lowpoly_male_standing001_lowpoly_male_standing001.stl", "male_standing001", "#C68D5E", "#6B4A2E", "#4F5536", "#3E2716"],
  ["lowpoly_male_standing002_lowpoly_male_standing009.stl", "male_standing002", "#E0AC84", "#B58A2A", "#232B45", "#111111"],
  ["lowpoly_male_standing003_lowpoly_male_standing002.stl", "male_standing003", "#F1C9A5", "#6E1F2B", "#9C8A62", "#3E2716"],
  ["lowpoly_male_standing004_lowpoly_male_standing012.stl", "male_standing004", "#4A2C1A", "#9A4B2A", "#4A3526", "#111111"],
  ["lowpoly_male_standing005_lowpoly_male_standing003.stl", "male_standing005", "#6B4226", "#B79A6B", "#18181A", "#3E2716"],
  ["lowpoly_male_standing006_lowpoly_male_standing004.stl", "male_standing006", "#9A6340", "#1F2A44", "#33343A", "#111111"],
  ["lowpoly_male_standing007_lowpoly_male_standing005.stl", "male_standing007", "#C68D5E", "#1C1C1E", "#77777A", "#3E2716"],
  ["lowpoly_male_standing008_lowpoly_male_standing.stl", "male_standing008", "#E0AC84", "#6E6E72", "#4F5536", "#111111"],
  ["lowpoly_male_standing009_lowpoly_male_standing001.stl", "male_standing009", "#F1C9A5", "#E6D9B8", "#232B45", "#3E2716"],
  ["lowpoly_male_standing010_lowpoly_male_standing002.stl", "male_standing010", "#4A2C1A", "#2F4A34", "#9C8A62", "#111111"],
  ["lowpoly_male_standing011_lowpoly_male_standing003.stl", "male_standing011", "#6B4226", "#ECE8DC", "#4A3526", "#3E2716"],
  ["lowpoly_male_standing012_lowpoly_male_standing004.stl", "male_standing012", "#9A6340", "#4E6C8C", "#18181A", "#111111"],
  ["lowpoly_male_walking001_lowpoly_male_walking.stl", "male_walking001", "#C68D5E", "#6B4A2E", "#33343A", "#3E2716"],
  ["lowpoly_male_walking002_lowpoly_male_walking.stl", "male_walking002", "#E0AC84", "#B58A2A", "#77777A", "#111111"],
  ["lowpoly_male_walking003_lowpoly_male_walking.stl", "male_walking003", "#F1C9A5", "#6E1F2B", "#4F5536", "#3E2716"],
  ["lowpoly_male_walking004_lowpoly_male_walking.stl", "male_walking004", "#4A2C1A", "#9A4B2A", "#232B45", "#111111"],
  ["lowpoly_male_walking005_lowpoly_male_walking001.stl", "male_walking005", "#6B4226", "#B79A6B", "#9C8A62", "#3E2716"],
  ["lowpoly_man_adjusting_hat_lowpoly_man_adjusting_hat.stl", "man_adjusting_hat", "#9A6340", "#1F2A44", "#4A3526", "#111111"],
  ["lowpoly_smoking_man_lowpoly_smoking_man.stl", "smoking_man", "#C68D5E", "#1C1C1E", "#18181A", "#3E2716"],
  ["lowpoly_woman_holding_a_child_lowpoly_woman_holding_a_child.stl", "woman_holding_a_child", "#E0AC84", "#6E6E72", "#33343A", "#111111"]
];
function fig(f) = FIG[search([f], FIG)[0]];
BANDS = ["skin", "top", "bottom", "shoes"];
// COLOR_PEOPLE = false shows the plain single-colour figures
COLOR_PEOPLE = true;
module person(p) {
    z = p[7] == "in" ? FLOOR_Z + PEOPLE_FL : FLOOR_Z + ft(-0.5); g = fig(p[0]);
    translate([ft(p[4]), ft(p[5]), z + ft(p[8])]) rotate([0, 0, p[6]]) scale(1000 / SCALE) translate([-p[2], -p[3], 0])
        if (COLOR_PEOPLE) for (i = [0 : 3]) color(g[2 + i]) import(str("bands/", g[1], "_", BANDS[i], ".stl"), convexity = 4);
        else color("#C8B8A0") scale(p[1]) import(str("src/", p[0]), convexity = 4);
}
module people_place() for (p = PEOPLE) person(p);
