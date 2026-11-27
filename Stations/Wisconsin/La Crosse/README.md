# La Crosse, Wis. passenger station, breezeway and baggage & express building

Milwaukee Road (C.M.&St.P.) depot at 601 St. Andrew St, North La Crosse. Architect A. O. Lagerstrom; opened 31 Jan 1927; the last passenger depot the Milwaukee Road built. **Stands** - still the Amtrak station (LSE). NRHP 97001512 (1997). Renovated 2001.
Folder made 26 Nov 2026. **HAND-BUILT** - not made by the generator; do not add it to stations.py without adding it to CUSTOM.

Source drawings: Album sheet 119 (passenger station, June 21 1926) and sheet 120 (baggage and express building, B-3191, June 21 1926). Private reference (in copyright): Research Library / RSW / Stations / Standard depots / Album of Depot Plans 1919.
Colours and materials: NRHP nomination (brown brick, dark brown quoins and panels, Bedford limestone base, water table and sills, red clay tile roof).

## Era
1927 as built: red clay tile roofs, open breezeway, town-side entrance awning, track-side canopy hung from the wall.
Later changes (not modelled): roof re-covered in red asphalt shingle; entrance awning removed; breezeway closed in with clapboard and garage doors early 1970s; some west-half baggage openings made into windows; 2001 renovation added a NEW platform canopy (not the original).

## From the drawings (scaled, 1/16 in = 1 ft) and photos
- Station about 104 x 33.4 ft, 2 storeys, 7 bays; eave about 33 ft, ridge about 46 ft, 4.5 ft overhang; limestone base about 4.5 ft with a stone band at the 1st floor sills (rev 2: heights checked against photo 05, straight-on town side).
- Rooms: general waiting 31'6 x 46'0, ticket office 13'10 x 18'0 (in a 17 x 6 ft track-side bay), smoking 14'0 x 14'1, women's rest 14'0 x 19'1, lunch 20'1 x 25'7, kitchen 11'10 x 25'7.
- Baggage & express about 115 x 37.2 ft, east of the station: check room 7'8 x 23, baggage 28'6 x 35'7, express office 19'6 x 26'6, express room 35'7 x 54'9; eave about 15.5 ft, ridge about 28 ft; 11 rolling doors.

## From the photos (reference / Station photos web / La Crosse, 01-08)
- Colours: orange-brown brick, darker brown brick quoins, light limestone base, sill band and sills, white soffit, fascia and downspouts with goosenecks. Station roof dark gray by 1974 (photo 03), red asphalt now; baggage roof still red in 1974 - the model uses red tile for 1927.
- Sash white/pale in 1974; stained red-brown today. Town-side entrance now has a small copper-green awning.
- Ticket bay is one storey with a flat roof and stone cap (photo 03). West end: 3 tripartite windows upstairs, 3 tall windows downstairs (photo 04).
- 1974: a long canopy hung along the baggage building's track side (yellow fascia) - not on the 1926 sheet, so not in the 1927 model. Today's platform canopy on curved steel posts is from 2001.
- Photo 02 (1982) shows the old water tower with CMStP&P lettering near the depot - a possible extra model.

## Switches in the .scad (Rev 3, 26 Nov)
- CANOPY_1927 (on): canopy hung from the station's track wall, from the sheet 119 plan outline. Height ESTIMATE; not seen in the 1974 photo.
- CANOPY_1974 (off): flat canopy on curved brackets along the baggage building and breezeway (photo 03).
- CANOPY_2001 (off): today's platform canopy on curved steel posts (photos 04, 07). ESTIMATE spacing, width and length.
- INTERIOR (on): general waiting room 31'6 x 46'0 hollowed out - oval wooden ticket counter on a cream marble base with a black kick plate, ticket windows and bulletin board, cornice and clock (photos 06, 09); marble wainscot, stone pilasters, plaster walls and ceiling beams, marble floor with a dark ring, four double benches (layout ESTIMATE, ceiling 18 ft ESTIMATE). Window and door openings cut through into the room.
- CUTAWAY (off): cuts everything above 16.4 ft to look into the waiting room (Notes / La_Crosse_Depot_cutaway.png).
- Baggage building: roll-up (slatted) doors as on sheet 120.
- The NRHP's five-car-length train canopy is still not modelled - no drawing or photo of it found. The old water tower (photo 02) is skipped.

## Files
- OpenSCAD / La_Crosse_Depot.scad: FIRST SHAPE MODEL on the shared depot builder (Stations / _common / rsw_depot.scad), in colour via PAINTS. SCALE 29 = G, 48 = O, 87 = HO. Not cut into print sections yet.
- Notes / La_Crosse_Depot_review.png: track side (top) and town side (bottom), rev 3.
- OpenSCAD / La_Crosse_Depot_1974.scad: the 1974 canopy version (includes the main file, CANOPY_1974 on, CANOPY_1927 off) -> La_Crosse_Depot_1974.glb. Station roof and breezeway still as 1927.
- Notes / La_Crosse_Depot_1974_review.png: track side of the 1974 version.
- Notes / La_Crosse_Depot_cutaway.png: waiting room with CUTAWAY on; Notes / La_Crosse_Depot_canopies.png: CANOPY_1974 and CANOPY_2001 on.
- Blender / GLB / stations / La_Crosse_Depot.glb: made by 'Make station GLBs.bat'.
- Photos and sources: reference / Station photos web / La Crosse / (index.csv, La Crosse photo sources.md).

## Estimates in the model (marked ESTIMATE in the .scad)
Breezeway length (24 ft) and height; how the buildings line up (track faces in line); second-floor track-side windows; east-end openings; floor height; canopy and awning heights; 1927 sash colour; platform. Quoins use the 'doors' paint (dark brown) because 'trim' is the white soffit here. The separate five-car-length train canopy is not on the album sheets and is not modelled.

## Best next sources
- La Crosse Public Library Archives, MISC MSS 254: the 1926 Engineering Dept drawings of this station and baggage room (not online). archives@lacrosselibrary.org, 608-789-7136. Also their 1931 depot photo.
- Bill Pasewaldt photo, 23 Nov 1930 (rrpicturearchives.net) - as built.
- Road trip: all four sides, a colour card on brick, stone and roof; breezeway length; window sash colour.
