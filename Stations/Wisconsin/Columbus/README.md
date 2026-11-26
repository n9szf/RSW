# Columbus, Wis. passenger depot

Milwaukee Road (C.M.&St.P.) depot. Folder made 24 Nov 2026.
Source drawing: Album sheet 56, drawing A-7931, Aug 31 1906 (J. A. Lindstrand). Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
About 28 miles from Madison.

## From the drawing
96 x 23 ft; wings 25 ft 6 in, centre 45 ft; general waiting 26x40, smoking 20x22, office 13x16 ft 8, baggage 17 ft 8 x 20; quarter-pitch TILE roof; concrete (rusticated) walls; 2 porches.

## Files
- OpenSCAD / Columbus_Depot.scad: FIRST SHAPE MODEL. Built with the shared depot builder (Stations / _common / rsw_depot.scad), in colour via PAINTS so make_glb.py makes a coloured .glb. SCALE 29 = G, 48 = O, 87 = HO. Not cut into print sections yet.
- Notes / Columbus_Depot_review.png: track side and town side.
- Blender / GLB / stations / Columbus_Depot.glb: the 3D file, made by 'Make station GLBs.bat'.
- Reference: photos (links below - Claude cannot download them; save any you want into this folder).

## Estimates in the model
Wall and ridge heights where not written on the sheet, window count and spacing, door panels, colours (Milwaukee Road depot colours still to confirm).

## Photo leads
- Still in use as the Amtrak station, 359 N. Ludington St.; rusticated concrete, originally a TILE roof. WHS record: https://wisconsinhistory.org/Records/Property/HI3493
- Great American Stations: https://www.greatamericanstations.com/stations/CBS
- 2021 photos: https://cahancock.rrpicturearchives.net/archiveThumbs.aspx?id=142215
- The 1871 depot (later freight depot) still stands nearby: https://wisconsinhistory.org/Records/Property/HI3468


## Colours (photos, 24 Nov 2026)
From Tom's own photos: Research Library / RSW / Stations / Wisconsin / Columbus / Photos (private), IMG_2917 to IMG_2941 (all four sides, sunny day).
- Walls: warm gray-taupe rusticated concrete #A59C8E; smoother base course #A09B8F
- Soffits, brackets, fascia, window frames: white #E8E6DF
- Roof: dark gray asphalt shingles #5A5B5F (the original tile roof is gone)
- Doors: red #A8322C
- Brick inside the entrance arches #6A4A3E

## Rev 2 (25 Nov 2026) - rebuilt to the sheet
- West part 29 ft deep (general waiting room), east part 22 ft deep (smoking room, baggage); step on the town side.
- Centre section 45 ft, projects 6'10" to the track: pediment gable with half-round window and cornice, two open arched porches, office bay with three windows, COLUMBUS sign, banded (rusticated) concrete on a smooth base.
- Toilet annex on the town side; wide (6 ft) eaves with white knee braces; concrete base to sill height.
- From Tom's photos (town side not on the sheet): centre roof hipped toward the town side; fieldstone chimney on the town side.
- The file is now hand-built (no longer written by the generator).

## Rev 4 (26 Nov 2026) - eaves and windows from Tom's photos
Photos: IMG_9949-9951 (Research Library) and IMG_0849-0852 (sent in chat 26 Nov).
- Wing eave fixed: the 13.4 ft on the sheet is the eave line, so the wing plate is now 16.4 ft (the eave had been 3 ft low and hid the window heads).
- Wing roofs drawn in the station file: the white beadboard soffit slopes with the roof and rests on long flat white lookouts (about 4x7 in, every 3 ft) running from the wall nearly to the fascia. The knee braces are gone.
- Town-side upper sashes have the big diamond (lozenge) muntin pattern, two diamonds across (DIA_SIDES = [0]; add other walls when photos show them).
- Still to do: the town-side triplet with white fluted mullions (plain replacement sashes today); exact window spacing is an ESTIMATE.
- The file is HAND-BUILT - do not regenerate.

## Rev 4b / 4c (26 Nov 2026)
- Town side rebuilt from IMG_2918-2923 and 2938 (window spacing ESTIMATE): short diamond lights, red door with diamond transom and sidelight, annex with two diamond windows, dark office door, diamond window, diamond triplet with fluted mullions, one more diamond window. Overhead door at the east end left out (later change).
- East end: two small plain windows high in the wall. Chimney rises out of the roof.
- East porch entrance (IMG_2926): white frame, red door, diamond sidelights and transom. West porch lined with brick (IMG_2925, 2929).
- Leaf ornaments along the pediment's raking cornice and small blocks in the frieze (IMG_2930).
- TILE_ROOF = true at the top of the file gives the 1906 red tile roof.
