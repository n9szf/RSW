# Whitewater, Wisconsin - Milwaukee Road passenger station (1890-91)

HAND-BUILT - do not overwrite with the album generator.

C.M.&St.P. Ry. depot by J. T. W. Jennings, drawn July 14 1890 (drawings 2675-2677, 2742, 5167; ICC 16-1146-1 to -12).
Still standing at 301 W. Whitewater St.; city-owned since 1973, Whitewater Historical Society depot museum since 1974. State Register 2012, National Register 2013 (13000376).
About 45 miles from Madison. Drawings (private, in copyright, full size): Research Library / RSW / Stations / Wisconsin / Whitewater / MPL drawings 1890 (all 12 sheets).

## From the drawings (re-measured 25 Nov 2026 - see the end of this file)
Foundation 60 ft 2 in x 22 ft 2 in; walls 11 ft 3 in from platform to eave (16 ft above the rail on the track side); platform 12 in above the rail; 12 ft roof overhang at the ends and track side on posts and brackets; hipped roof about 16 ft rise with a flat top, iron cresting and finials; a stone gabled dormer with corner pinnacles on each long side; groups of three tall windows each side of the centre doors; canted bay at the east end; tall brick chimneys capped with stone.

## Materials (research 24 Nov)
Smooth red ("vermilion") pressed brick over a rock-faced stone foundation, rough stone quoins and trim. Stone colour: sources disagree - buff/tan (WHS, marker) or grey limestone (historical society). Roof material as built not found (new roof 1982). Cresting was lost and replicated in the 2012-13 renovation - photos 1973-2012 show no cresting.

## Files
- OpenSCAD / Whitewater_Depot.scad: shape model from the 1890 plans (shared builder plus its own roof, dormers, cresting, chimneys, track-side door). SCALE 29 G, 48 O, 87 HO.
- Notes / Whitewater_Depot_review.png
- Blender / GLB / stations / Whitewater_Depot.glb

## Photo sources
- WHS property record with labelled survey photos (east, east and south, west, interior): https://wisconsinhistory.org/Records/Property/HI10468
- WHS National Register record (5 photos): https://www.wisconsinhistory.org/Records/NationalRegister/NR2376
- NRHP nomination (18.8 MB PDF - photo log and probably historic figures; open in a browser): https://npgallery.nps.gov/AssetDetail/NRIS/13000376
- Historical marker 68446 (street side and track side, 2013): https://www.hmdb.org/m.asp?m=68446
- Historical marker 191295 (the sign reproduces a c.1900 trackside postcard, the last passenger train 1951, the freight house c.1970 and a plan detail): https://www.hmdb.org/m.asp?m=191295
- Whitewater Historical Society: https://whitewaterhistoricalsociety.org/post/the-whitewater-depot
- SAH Archipedia: https://sah-archipedia.org/node/21874
Best next step: ask the Whitewater Historical Society for scans of their historic photos and the c.1900 postcard.

## Colours (photos, 24 Nov 2026)
Measured from WHS 222350 (sunlit dormer), WHS 222348 (track side), HMdb 636760 (street side) and the 2013 Wikipedia photo. These are the colours after the 2012 restoration.
- Brick: smooth red pressed brick #7E3C2E
- Stone: rock-faced buff sandstone #9C866A (base to sill height, quoins and pilasters, dormer gables and bands, chimney cap). Sources call it "buff", "tan" or "grey limestone"; the photos show buff.
- Brackets, posts, fascia, cresting: buff paint #B8A07A
- Roof: brown asphalt shingles #6A5350 (2012 re-roof)
- Window sash: dark brown #2E1F1A
- Doors: street side dark brown #4B3A33 (paint "doors"); track-side door buff #B8A07A (paint "door_track", ESTIMATE - last seen buff in 2012)
Model changes from the photos: dormers are brick with stone bands and gables (they were all stone); stone base raised to 3.6 ft; stone pilasters added; window sills raised onto the stone base.
Photos: RSW/reference/Station photos web/Whitewater/ (index.csv lists the source of each).

## Photo check 25 Nov 2026 (TDQ-652) - decision: keep the 1890 plans
Tom 25 Nov: the shape stays on the 1890 plans. Photos are used only for colour.
- Today the depot shows one chimney west of the dormers, no east-end bay, and a second track-side door near the west end (WHS 222348, 222349, HMdb 636759-61, Wikipedia 2013, SAH Archipedia). The model keeps the plan. (Superseded by Rev 2 below: the sheets themselves show one chimney west of the dormers and the bay on the track side at the west end - the first model had them mirrored.)
- Doors: in 2012 both doors were buff; from 2013 the street door is dark brown. The model has two door paints: "doors" (street, dark brown) and "door_track" (buff, ESTIMATE).
- GLB colours: make_glb.py (25 Nov 2026) now takes each station's own colours; the builder defaults are used only for colours a station does not set. Before this the GLB came out in the builder's gray.

## Rev 2, 25 Nov 2026 - re-measured off the 1890 sheets
The first model had the chimney and the bay mirrored. From sheets 01 (north and west elevations), 02 (south elevation) and 03 (foundation plan):
- ONE chimney, 16.2 ft from the west end, in the interior wall (y 12), 2.7 ft square, top about 4 ft above the roof's flat top. The photos agree.
- Canted operator's bay on the TRACK side at the WEST end: 15 ft 4 in along the wall (4-6 3/4, 6-2 1/2, 4-6 3/4), projecting 2 ft 8 7/8 in, one window per face. Not there today (photos).
- Street dormer in two stages: a lower stage 17 ft wide with corner piers and pinnacles, then a tower 10.4 ft wide with pinnacles and a steep stone gable (apex about 20 ft above the eave). The track dormer is the tower only, higher on the roof.
- Track side: bay, window at 20.1 ft, door at 30 ft, windows at 42.3 and 50.7 ft (from the west end).
- Posts only at the two ends (west elevation): y -0.2, 12.7, 25.6 ft. The 12 ft track overhang is on brackets (sheet 05) - still to model.
- The model's x runs from the EAST end (y = 0 is the street side); the header explains.

## Rev 3, 25 Nov 2026 - dormers joined; heights re-measured
- Tom: the two dormers are connected. Sheet 01 west elevation shows a cross-gable roof joining the two dormer towers, ridge 28.1 ft above the platform, about 2.3 ft above the main roof's flat top. The photos show it as a hump behind the track dormer.
- Sheet 01 re-measured at 49.8 px/ft both ways (eave underside to platform reads 11'-3"). Main roof flat top 25.9 ft above the platform (RISE 14.05, was 16.3). Dormer apex 19.5 ft above the eave; street lower stage EAVE+4.5 to EAVE+9.5; tower top EAVE+12.2.
- Chimney 2.5 ft square, 16.4 ft from the west end, top 4.7 ft above the flat top. End posts 6.8 ft out from the ends at y -2.4, 10.9, 23.7.

## Rev 4, 25 Nov 2026 - brackets (sheet 05)
Four bracket types from sheet 05 (Details of Brackets, 1 1/2 in = 1 ft):
- A (18): 8'-10 1/2" reach, curved arm radius 8'-2" - track side and ends. Two sit on the bay's front face.
- B (2): 12'-7 3/4" diagonal, radius 15'-7" - track-side corners.
- C (2): 5'-10 1/2" diagonal, radius 5'-1 1/2" - street-side corners.
- D (12): 4'-1 1/2" reach, radius 6'-5" - street side.
The truss is simplified (top beam, lower chord, two posts, wall leg, curved arm). Positions at the pilasters and mullions are ESTIMATE where the sheets do not place them.

## Rev 5, 25 Nov 2026 - end posts removed (Tom)
Sheet 01 (14 Jul 1890) draws slender posts at the ends, but sheet 05 (15 Jul 1890) carries the ends and corners on brackets, including long diagonal brackets at the track-side corners where the posts would stand. Sheet 03 shows no post footings, and no photo (pre-2012 to 2021) shows posts. The model has no posts - ESTIMATE until the c.1900 postcard (on the HMdb 191295 marker) or a Historical Society photo shows the ends.

## Rev 6, 25 Nov 2026 - cresting and finials (sheet 10)
Sheet 10 (Chicago, 20 Aug 1890, drawn full size, note "Change to wood, and include in mill work"). Scaled to sheet 01 (finial base 2.3 ft wide):
- Cresting: scrolled-leaf ("breaking wave") pattern between a bottom moulding and a top rail, small balls along the top. Tom: full size as drawn - 9 in tall, 10 in repeat. It stops either side of the cross roof over the dormers.
- Finials at both ends of the flat top: turned wood - flange, torus, flared bell, ring and onion. Tom: small - sheet 10 at true full size, 15 in base, 18 1/2 in tall.

## Rev 7, 25 Nov 2026 - end walls (sheet 01 west, sheet 02 east elevations)
- West end: one door 3'-2 1/4" wide with a transom, 10.3 ft from the street face; no windows (the window beside it on the drawing is the side of the bay).
- East end: no door; four small high windows - a pair at 5.0 and 7.2 ft from the street face, singles at 12.4 and 18.4 ft; sills 6.1 ft, 4 ft tall.

## Rev 8, 25 Nov 2026 - dormer windows (sheet 11) and one roof over both dormers
- Sheet 11 (Chicago, 14 Nov 1890) sash: main lights 2'-8 1/2" tall - 3'-9 1/4" in the track tower and the street lower-stage centre, 30 1/4" either side; the street tower has a 22 1/2" x 14 3/4". The other 14 3/4" sash and the 12 3/8" do not fit the dormer bodies as modelled - not placed (ESTIMATE).
- Tom: the dormer roof lines connect. The two towers now share one cross-gable roof (ridge 28.1 ft above the platform) running from gable to gable; the steep stone gables are parapets 1 ft thick on the faces, rising above that roof (west elevation, sheet 01).

## Rev 9, 25 Nov 2026 - render fix
Dormer piers now stand 1 in proud of the stone bands. Where a brick face and a stone face shared the same plane, Blender rendered them black (seen in the first Whitewater renders).
Renders: RSW\Blender\Renders\Stations\Whitewater\ - "v2" (25 Nov evening, six views, contact sheet); "v3" after this fix. Script RSW\Blender\render_whitewater.py, run with Render Whitewater v2.bat (uses the GLB paint pieces - run Make station GLBs.bat first).

## Rev 10, 25 Nov 2026 - the 1890 interior (best guess) and the movie
Tom: build the 1890 interior, best guess, and make a movie.
- Walls now a hollow brick shell 1.1 ft thick with real window and door openings (the shared builder's solid block is no longer used for Whitewater); stone base is a ring; the bay opens into the office. Street doors stand open (for the fly-in); track and west doors closed.
- Rooms from sheet 06 (ceiling plan of the waiting rooms, 3/4 in = 1 ft) and sheet 03: general waiting room about 44 ft long (east part); partition at 14.6 ft from the west end with the chimney beside it; at the west end the ladies' waiting room (street side) and the agent's office (track side, 6 ft + the bay).
- Finish (ESTIMATE): pine board floor; panelled board ceiling with coffers as sheet 06 (two in the big room, one in the ladies' room); dark beadboard wainscot 4 ft with cap rail and base; plaster above.
- Furnishing (ESTIMATE, typical 1890): oak benches with iron ends (back-to-back in the big room, along the walls), two pot-belly stoves piped to the chimney, six brass kerosene lamps (paint "lamp" glows), wall clock and schedule board on the partition, ticket windows into both waiting rooms with shelf and brass grille, agent's desk with telegraph in the bay, chair, cabinet.
- New paints: floor, ceiling, plaster, wainscot, woodwork, oak, iron, brass, lamp, clock, board.
- Movie: RSW\Blender\render_whitewater_movie.py (76 s, 24 fps, 1920x1080, EEVEE). Title fade-in, 360 fly-around, in through the street doors, look round the waiting room, out and back to the start, end card. "Whitewater movie TEST.bat" renders 8 check frames; "Whitewater movie.bat" does the full run and joins the .mp4 (Movies\Whitewater 1890\). Run Processed\Make station GLBs.bat first.
