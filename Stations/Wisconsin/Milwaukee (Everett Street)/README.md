# Milwaukee Road Union Depot, Everett Street, Milwaukee (1886)

The Milwaukee Road's Union Depot on Everett Street in Milwaukee, Wisconsin, as built in 1886 (architect E. Townsend Mix), with the 1889 power house and the train shed.

## What's here

| Folder | What it holds |
|---|---|
| `OpenSCAD/MILW_Everett_Street_1886_full_size.scad` | The model. It is generated, so edit the scripts below rather than this file. |
| `OpenSCAD/gen_everett_3d.py`, `gen_interior.py`, `gen_site.py` | The Python scripts that write the `.scad` (building, interior, and site with power house and train shed). |
| `Drawings 2D/Everett_1886_drawing_set.pdf` | The 14-sheet drawing set. |
| `Drawings 2D/*.pdf`, `*.dxf`, `*.py` | The single sheets as PDF and DXF, and the scripts that draw them. |
| `Drawings 2D/Everett_2D_decisions.md` | The best-guess decisions made where the drawings are missing. |
| `3D/make_everett_glb.py` | The Blender script that makes the 3D file. |

The 3D file itself, `Everett_Street_1886_full_size.glb`, is on the [3d-models release](https://github.com/n9szf/RSW/releases/tag/3d-models) with the other 3D files. You can also see it in the [3D viewer](https://n9szf.github.io/RSW/) under Stations, Wisconsin.

## Using the model

- **Full size:** 1 unit = 1 foot. Set `U = 304.8` to work in millimetres.
- **For renders and VR, not printing.** This is a full-size building with its interior, not a kit.
- **Parts:** the `PART` variable picks one material group, for example `PART = "r_brick";`. Leave it empty (`PART = "";`) for everything.

## Where the drawings run out

Where original drawings were missing, the model uses best guesses based on the station drawings and the 1894 Sanborn map. Each guess is listed in `Drawings 2D/Everett_2D_decisions.md`. Corrections and photos are welcome.

## No build book

This is an OpenSCAD model, not a kit, so there is no "How to build" book.

## Questions

[ribsideworks@gmail.com](mailto:ribsideworks@gmail.com)
