# Waukesha, Wis. passenger depot

Milwaukee Road (C.M.&St.P.) brick passenger depot on Madison St, Waukesha, beside the 1851 stone freight house. WHS gives it as built 1890, Italianate. **Razed** (WHS: "not extant as of February 2020"; empty and boarded by about 1979). Model is the depot as altered in 1906.

## HAND-BUILT - do not regenerate
OpenSCAD\Waukesha_Depot.scad is hand-built (rev 3, 27 Nov 2026: rev 2 + colours and track-side details from colour photo 05). It is not in the album generator (stations.py); keep it that way.

## Sources
- Album sheet 143, drawing A-7509, Chicago May 24 1906, J. U. Nettenstrom architect: floor plan only (alterations). Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
- Web photos (reference / Station photos web / Waukesha, index.csv; run "Get Waukesha photos.bat" there to download):
  - 01 WHS survey c.1979 (AHI HI94592): west end and track side.
  - 02 WHS IM123287, Waukesha Daily Freeman 24 May 1952: east end in service, name board, pavilion.
  - 03 W. S. O'Brien 23 Mar 1922 (UWDC): pavilion at the edge of the freight-house view.
  - 05 colour, about 1970 (Facebook group Wisconsin Railroad Depots, Galman Freelancer Img): west end and track side.
- Notes / Photo research.md - what each photo shows, leads still open.

## Model (rev 1)
- 86 x 26 ft, scaled off the sheet. Rooms W to E: baggage, smoking room + toilets, general waiting (track-side bay 16 ft x 4.6 ft), office and telegraph.
- Doors and windows where the sheet puts them after the 1906 changes; segmental brick arches over all openings; one tall opening in the west end, two windows and a WAUKESHA name board on the east end (1952 photo).
- Gable roof along the track: wall plate 13 ft, about 6.6/12, ridge about 20 ft, 3 ft eaves and 2.5 ft rakes on diagonal brackets; round louvered vent in each gable; brick chimneys at the baggage/smoking flue and the office flue.
- Open pavilion east of the depot: hip roof on 3 x 2 posts with knee braces, 30 x 18 ft, 6 ft clear of the building.
- Brick platform on the track side.
- Colours from photo 05 (rev 3): red brick painted pale gray #B8B5A0 (modelled freshly painted; by 1970 the lower walls had weathered back to red brick), bare red-brown brick arches #8A4B38, dark brown trim and brackets #4A3628, dark red-brown frames #4E2A22, brown roof #5A3E34 (ESTIMATE), purple-red brick platform #5B4246, limestone base.
- Rev 3 details from photo 05: long diagonal eave struts, name boards on both ends, west-end window sill 3 ft, round gable windows with radial bars, reflector lamp on the west gable, two-arm train-order signal at the east end of the track side (position and height ESTIMATE).
- ESTIMATE: all heights, overhangs, bracket spacing, window and door sizes, bay roof, pavilion size, gap and posts, colours.

## Interior (rev 2, best guess for 1906)
- INTERIOR = true (default) cuts the rooms out of the shell and opens the windows and doors; CUTAWAY = true leaves off the roof and ceilings (and opens the rooms to the sky) to look in.
- Room plan from sheet 143 as altered: baggage room (flue in the partition), smoking room, men's and women's toilets on its town side (closets, urinal, basins, slop sink), general waiting room with the track bay, office with the 1906 new counter, telegraph table in the NE corner, ticket window, drawer and 12 x 12 flue in the partition. The baggage-room door to the smoking room is closed up (sheet).
- Fittings styled on WHS photo W013ISJ (1915, "the company's Waukesha office" - which building is not certain): varnished beadboard walls and ceilings, plank floors, coal base-burner stoves on long pipes to the flues, pendant lamps, wall clocks, train board, benches, spittoons, roll-top desk, safe, ticket case, telegraph sounder; platform scale, baggage truck and trunks.
- Ceiling 12.8 ft above grade (ESTIMATE).
- Notes / Waukesha_Interior_review.jpg - cutaway from the town side, office end and baggage end (cloud test renders).

## Files
- OpenSCAD / Waukesha_Depot.scad - the model (shared builder Stations / _common / rsw_depot.scad). SCALE 29 G, 48 O, 87 HO. Not cut into print sections.
- Notes / Waukesha_rev3_vs_photo05.jpg - rev 3 beside photo 05.
- Notes / Waukesha_Depot_review.jpg - cloud test views: east end (1952 angle), west end + town side (1979 angle), track side.
- Blender / GLB / stations / Waukesha_Depot.glb - 3D file ('Make Waukesha GLB.bat' in Processed).

## Still to get
- The track-side bay: not seen in photo 05.
- Confirm whether WHS W013ISJ (1915 office photo) is this depot.
- Sanborn maps of Waukesha (footprint, pavilion size, brick or frame).
- Tschudy, Milwaukee Road Depots 1856-1954 Photo Archive; Waukesha County Historical Society (O'Brien albums, Freeman photos); MPL Milwaukee Road drawings.
- Find the original of photo 05 (photographer, date).
