# Edgerton, Wis. passenger depot

Milwaukee Road (C.M.&St.P.) depot, 1906-07. Stands at 20 S. Main St. (NRHP 98000283); now the Edgerton Depot - Chamber of Commerce information center and history museum.

## HAND-BUILT - do not regenerate
OpenSCAD\Edgerton_Depot.scad is hand-built (rev 4, 26 Nov 2026). Do not overwrite it with the album generator.

## Sources
- Album sheet 58, drawing A-7532, Chicago June 19 1906, J. A. Lindstrand architect: track side elevation, pavilion end elevation, floor plan, half sections. Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919 (also in Research Library / RSW / Stations / Wisconsin / Edgerton / MPL drawings).
- NRHP nomination 98000283 (1997): materials and the 1939 alterations. Text + 1891 and 1909 Sanborn maps are in reference / Station photos web / Edgerton (file 01, really a PDF).
- Tom's photos IMG_8914-8924 (Sep 2026): Research Library / RSW / Stations / Wisconsin / Edgerton / Photos (private) - pavilion, soffits, brackets, bay brickwork, colours.
- Wikipedia photos 13 (track side) and 14 (town side), 3840 px.

## Model (rev 4)
- 128 ft overall: building 98 x 24 + pavilion 30. Rooms W to E: baggage 24, smoking 20, office 14 (with the track-side bay), general waiting 36'4.
- Roof from the sheet: one 1/4-pitch hip over the whole 128 ft (eave about 12.5 ft, overhang about 8 ft, ridge 22.5 ft) with a 1/2-pitch hip rising out of it over the smoking room, office and waiting room (ridge 27.7 ft). Flat gray beadboard soffit under the eaves; knee brackets with a long top arm on the piers between openings (Tom's photos).
- Office bay (track side): 14 ft, 3 ft out, cut corners, diamond sash in front and on both cut corners. Lavatory bay (town side): about 15 x 5 ft, under the eave.
- Pavilion: round tapered tan wooden columns on brick piers about 5 ft high (concrete base block, gray-painted moulded cap) - one at the building, a pair midway, three at each outer corner; beams on the post lines, flat beadboard ceiling, curved brackets out to the eave.
- Brick detail: quoins and soldier courses at the openings, rusticated pilasters and bay corners, concrete belt course at the sills; diamond upper sash in the bay windows.
- PRESENT = false gives 1907 as built (default, with the roof semaphore - NRHP, shape ESTIMATE); PRESENT = true gives the building after the 1939 remodel and the museum entrance.
- Colours (Tom's photos): brick #5B3A2E, concrete #B8AB94, gray paint (soffits, brackets, caps) #9A968C, columns #7E6247, sash and doors slate #4C5664, roof dark gray #5A5C5E.
- ESTIMATE: lavatory bay windows, sash detail, semaphore, 1907 colours.

## Files
- OpenSCAD / Edgerton_Depot.scad - the model (shared builder Stations / _common / rsw_depot.scad). SCALE 29 G, 48 O, 87 HO. Not cut into print sections yet.
- Notes / Edgerton_Depot_review.png - sheet elevation vs model, 1907 and present views, pavilion and track side vs Tom's photos.
- Notes / Edgerton_Depot_firstshape.scad.txt - the generated first shape (24 Nov), kept for reference.
- Blender / GLB / stations / Edgerton_Depot.glb - the 3D file ('Make Edgerton GLB.bat' or 'Make station GLBs.bat' in Processed).

## Still to get
- The six 1997 NRHP photos (NPGallery asset c3f8e1a4-736e-47da-9ea0-d35b3bb9b0b7) - east end, waiting room, telegraph window.
- Road trip done Sep 2026 (photos above). Still useful: west end and town side square on, tape measurements, colour card.
