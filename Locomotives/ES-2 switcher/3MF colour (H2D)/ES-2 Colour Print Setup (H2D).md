# ES-2 Colour Print Setup - Bambu H2D Pro with AMS Pro

Rib Side Works. Printing the Milwaukee Road ES-2 in the maroon scheme (E82: maroon with orange hood tops and cab band) in four colours, G scale 1:29. 15 Nov 2026.

![The E82 in the maroon scheme (RSW Blender picture)](E82_render_34.png)

## 1. The files

In RSW / export / Locomotives / ES-2 switcher / 3MF colour (H2D):

- **ES2_03_hood_1_E82_maroon.3mf** - hood 1 (maroon, orange top) and its small parts. 143 x 170 x 80 mm.
- **ES2_04_hood_2_E82_maroon.3mf** - hood 2 with the side tank, and its small parts. 143 x 170 x 71 mm.
- **ES2_05_cab_E82_maroon.3mf** - the cab (maroon below the windows, orange above), the roof and the slider. 211 x 133 x 87 mm.

The other five prints are all black and do not need the AMS: use the STLs in ES-2 switcher / notes / STL v9 (frame A and B, trucks A and B, underside).

The hoods and cab cannot be one piece: together they are about 378 x 106 mm, longer than the H2D bed (350 x 320 mm) at any angle.

These files have not yet been opened in Bambu Studio - check the first one carefully (step 4).

## 2. Filament

Each part in the files is already assigned to a filament number:

- **1 - Maroon**: Bambu PLA Basic Maroon Red (or Polymaker Panchroma PLA Matte Wine Burgundy for a darker, browner maroon).
- **2 - Orange**: Bambu PLA Basic Orange.
- **3 - Black**: Bambu PLA Basic Black (or PLA Matte Charcoal).
- **4 - White**: Bambu PLA Basic Jade White (or PLA Matte Ivory White).

Load the four spools in the AMS Pro, one per slot. Use the same material type (all PLA) so they print at the same temperature.

![Hood 1 as it will print: maroon, orange top, black tower and bell, white lens and railing posts](plate_hood_1.png)

## 3. Open the file

1. In Bambu Studio choose the printer preset **Bambu Lab H2D Pro** with the 0.4 mm nozzles.
2. File > Open, pick one of the three 3MF files. If it asks whether to load the file as a project or geometry only, either works; "Load geometry" keeps your own printer settings.
3. In the object list on the left you should see the hood (or cab) as one object made of two parts - **maroon** and **orange** - and one or two other objects for the small parts.

## 4. Check the colours

1. The Filament list (Prepare tab, left) must have **four** filaments. If it shows fewer, press + until there are four.
2. Set each filament to its colour and type: 1 maroon, 2 orange, 3 black, 4 white - click the colour square and the type box beside each.
3. Look at the model: the hood sides maroon, the top orange, the tower black, the posts white. If a part shows the wrong colour, select it in the object list and change its filament number in the right-click menu or the filament column.
4. Click the AMS sync button (the AMS icon next to the filament list) so Bambu Studio matches each filament to the AMS Pro slot that holds that colour; check each one is mapped to the right spool.

## 5. Two nozzles

The H2D has two nozzles. Bambu Studio decides which filaments go to which nozzle (filament grouping).

- Simplest: let it put all four on the nozzle your AMS Pro feeds. Every colour change then uses one nozzle and is purged into the prime tower.
- With a second AMS on the other nozzle, Bambu Studio can split the colours between the nozzles, which saves purge waste.
- The area both nozzles can reach is a little smaller than the bed. All three prints are well inside it.

## 6. Print settings

- Layer height **0.12 mm** for the detail (rivets, louvres, railing post eyelets); 0.16 mm is quicker and still good.
- **No supports** - every part was designed to print without them.
- **Prime tower on** (Bambu Studio adds it for multi-colour). Place it in a free corner of the plate.
- Flushing volumes: the default is fine; the dark-to-white change (black to white) needs the most, which Bambu Studio already allows for.
- Brim: add a small brim (3 mm) to the railing posts and the lens if they lift; the hoods and cab do not need one.
- Most colour changes on a hood happen in its top 10 mm (the orange top) and on the small parts near the bed, so the print is mostly single-colour through the middle.

## 7. Slice and look

1. Slice the plate.
2. In the Preview tab choose the colour view by filament and step through the layers: maroon sides, an orange band starting about 39-44 mm up on each hood, black and white small parts at the start.
3. Check the estimated filament per colour; one 1 kg spool each of maroon, orange and black does the whole loco.

![The cab plate: cab maroon and orange, roof and slider black](plate_cab.png)

## 8. After printing

- The rivets print in the body colour. Dry-brush them grey if you want them grey.
- The 1 mm brass railing wire and the grab irons are painted white.
- The cream lettering (E82 on the hood ends and roof boards, ES-2 on the cab sides) is decals or paint.
- Then build as in ES-2 Build Instructions.pdf.

## 9. Other paint schemes

The files are made by ES-2 switcher / scad / color / es2_color.scad and make_3mf.py. Claude can rerun them for the orange-and-black or all-black schemes, or for E80, E81 or E83.
