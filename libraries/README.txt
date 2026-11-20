RSW / libraries  -  shared OpenSCAD libraries for Rib Side Works (added 15 Oct 2026)

BOSL2  version v2.0.760 (25 Sep 2026), from github.com/BelfrySCAD/BOSL2, BSD 2-clause licence (see BOSL2/LICENSE).
  Only the .scad library files are kept here (no docs or tests). Do not edit them; to update, replace the
  whole BOSL2 folder with a newer release and note the version above.

Use it in a .scad file with:
    include <BOSL2/std.scad>
    include <BOSL2/gears.scad>      (gears, racks)     include <BOSL2/threading.scad>  (threads)
Good for: rounded / filleted bodies (cuboid rounding=, prismoid), attaching parts (attach, position),
gears, threads, springs, hinges, text on curves. Planned first for the Boxcab, Little Joe and ES-2.

So OpenSCAD can find it:
  Blender scripts (render_car.py, render_loco.py) set this up for themselves - nothing to do.
  Shops (Windows), once, in a cmd window:
      setx OPENSCADPATH "G:\My Drive\AI Cad\ClaudeProjects\RSW\libraries"
      then close and reopen OpenSCAD.
  Mac, once, in Terminal:
      mkdir -p ~/Documents/OpenSCAD/libraries
      ln -s "$HOME/Library/CloudStorage/GoogleDrive-tomflemin@gmail.com/My Drive/AI Cad/ClaudeProjects/RSW/libraries/BOSL2" ~/Documents/OpenSCAD/libraries/BOSL2
  Use OpenSCAD Nightly (Manifold on) - BOSL2 models are slow in OpenSCAD 2021.

Kits rule: the Fleet export kit files must stay stand-alone (one file, opens anywhere). A car or loco
that uses BOSL2 must not need it in its kit: make_release.py has to bake the shapes in, or the kit
ships its own copy. Passenger cars do not use BOSL2.
