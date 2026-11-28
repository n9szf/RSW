# Sparta, Wis. passenger station

Milwaukee Road (C.M.&St.P.) depot. Folder made 27 Nov 2026. **HAND-BUILT** - do not let the generator (make_depots.py) overwrite it.
Source drawing: Album sheet 112, built 1916 (drawn Chicago, July 14 1919). Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
Modelled as built, 1916.

## Does it still stand?
Gone today. The station stood into the 1970s at least; the baggage and express wing stood alone for years after (likely the 1989 survey photo) (checked 27 Nov 2026).
- Colour photo Tom found (about 1970s, track side from the west gable, "SPARTA" board in the gable): Research Library / RSW / Stations / Wisconsin / Sparta / Photos (private). Source: Facebook group "Wisconsin Railroad Depots", posted by D Scott Peterson, Aug 28 2024 ("Sparta Wisconsin - Milwaukee Road."); photographer and date not given. Private reference - not for publishing.
- Comments on that post (read 27 Nov 2026; the rest need a Facebook login): Terry M. Warner remembers the "freight section" on the right (the baggage and express wing) outlasting the depot part for many years; Andrew Fosbinder says it is all gone now.
- D Scott Peterson (the poster) built a scale model of Sparta and shows it in the comments (copy in Photos (private)): light siding, white trim, dark gray V-ceiling wainscot, dark shingle roof, two red brick chimneys on the ridge, the dormer over the ticket bay with ribbon windows, two windows and the SPARTA board in the west gable. Agrees with our sheet-based shape. A modeller worth asking about his sources.
- So the WHS 1989 photo below is most likely that retained wing: its open bay at one end matches the 16 ft pavilion, with the baggage and express rooms beyond.
- Wisconsin Historical Society record HI71513, "Milwaukee Railroad Depot", 704 Milwaukee St (Bob Johnson Oil Co.), surveyed 1989: its photo shows a gable-roofed **freight house** with a loading dock, not this station.
- Street View at that spot shows open grass along Milwaukee St.
- The depot that survives in Sparta (bike-trail visitor centre) is the C&NW station, not ours.

## Colours (from Tom's photo)
Pale gray lap siding, light gray-white trim, corner boards and window frames, darker gray V-ceiling wainscot, gray doors, green asphalt-shingle roof (the 1916 roof was wood shingles), red brick chimney. Old-slide blue cast corrected by eye.

## Photo notes for a later revision (shape kept to the sheet for now)
- Gable end at the west (smoking room) end, siding to the peak, two tall windows; a lower-roofed section shows beyond it - addition or the far wing, to check.
- One brick chimney seen beside the dormer; a stove pipe and the ridge ventilator.

## From the drawing
127 ft 8 in overall. Station 57 ft 8 x 27 ft 10: smoking room 17-6 x 26-6, passage with men's and women's toilets, ticket office 15-0 x 16-0 with a 12 ft track-side bay, general waiting room 21-6 x 26-6. Wing 70 ft x 22 ft (set in 2 ft 11 in each side): coal and boiler room 10 ft, open pavilion 16 ft, baggage room 20-8 x 21-0 and express room 20-8 x 21-2. Gable roof of wood shingles with a shed dormer (ribbon windows) over the ticket bay, ridge ventilator, two chimneys; low tar-and-gravel roof on the wing. Lap siding over V-ceiling wainscot, bracketed eaves.

## Files
- OpenSCAD / Sparta_Depot.scad: FIRST SHAPE MODEL on the shared depot builder (Stations / _common / rsw_depot.scad), plus its own shed dormer, bay cap and ventilator. In colour via PAINTS so make_glb.py makes a coloured .glb. SCALE 29 = G, 48 = O, 87 = HO. Not cut into print sections yet.
- Notes / Sparta_Depot_review.png: track side and town side.
- Blender / GLB / stations / Sparta_Depot.glb: the 3D file, made by 'Make station GLBs.bat'.

## Rev 2 (27 Nov 2026): wood siding
- Lap siding (4 1/2 in exposure) on every wall face and up into the gables, and V-ceiling wainscot (3 1/2 in vertical boards) below the belt, as the sheet notes. One shaped piece per face, with the windows and doors cut out. `SIDING = false` gives plain walls.
- Dormer front sided; SPARTA name board in the west gable (photo and Peterson's model).
- Still plain: the sides of the ticket bay.
- 3D export: the V-ceiling is the slowest paint (about a minute in the cloud test; faster on Shops).

## Rev 3 (27 Nov 2026): inside
Switches at the top of the .scad: `INTERIOR = true` (rooms and fittings), `CUTAWAY = true` (no roofs, dormer or ceilings, to look in).
- Room plan from sheet 112: one long room (smoking room, passage, general waiting room - the plan draws no partitions between them); ticket office 15 x 16 with the operator's bay on the track side; men's and women's toilets on the town side; coal room and boiler room; baggage room; express room.
- From the plan: ticket window and counter in the office's passage wall, office door, office flue in its west wall, boiler-room flue in the wall to the waiting room, the boiler, the bench layout (wall bench and double bench in the smoking room, two double benches in the waiting room).
- ESTIMATE: ceilings 11.8 ft (wing 10.6 ft); varnished V-ceiling wainscot to 4 ft, plaster above, V-ceiling ceilings, maple floors; steam radiators; electric pendant lights; office fittings (agent's counter, ticket case, desk, safe, telegraph table in the bay); toilet fixtures; baggage trucks and scale; express counter and shelves; coal pile; inside doors.
- ESTIMATE: the ticket office ceiling is raised into the dormer as a light well, lit by the ribbon windows. Nothing on the sheet shows what the dormer is for.
- Review picture: Notes / Sparta_Depot_interior_review.png.

## Estimates in the model
Heights scaled off the 1/16 in elevations (eave about 13.5 ft, ridge 24 ft, wing eave 12.5 ft), overhangs, window and door sizes, dormer depth, platform. The sheet shows only the track side and one end, so all town-side and end openings are ESTIMATE. Colours: from Tom's photo (see above), matched by eye.

## Photo leads
- WHS record HI71513 (freight house, 1989).
- Still to try: MRHA archives, Monroe County Historical Society (Sparta), John Grube photos, railpictures.net / rrpicturearchives.net for pre-1980 Sparta views.
