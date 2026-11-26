# Station data for the RSW shared depot builder (feet). Read off the 1919 Album of Depot Plans and MPL sheets, 24 Nov 2026.
# block: [x0, len, y0, wid, plate, rise, roof(0 hip,1 gable-x,2 gable-y,3 bellcast hip,4 flat), overhang, siding(0 wood,1 stucco,2 brick,3 stone)]
# pav:   [x0, len, y0, wid, plate, rise, roof, overhang, nx, ny]
def row(x0, x1, n, side, w=3, h=6, sill=4.2, blk=None):
    if n <= 0: return []
    step = (x1 - x0) / n
    return [[round(x0 + step * (i + .5), 2), side, w, h, sill] + ([blk] if blk is not None else []) for i in range(n)]
S = {}
def st(key, **k): S[key] = k

st("Columbus", folder="Wisconsin/Columbus", title="Columbus, Wis. passenger depot", src="Album sheet 56, drawing A-7931, Aug 31 1906 (J. A. Lindstrand)",
   miles=28, known="96 x 23 ft; wings 25 ft 6 in, centre 45 ft; general waiting 26x40, smoking 20x22, office 13x16 ft 8, baggage 17 ft 8 x 20; quarter-pitch TILE roof; concrete (rusticated) walls; 2 porches",
   blocks=[[0,96,0,23,13.5,.5,0,4,1],[25.5,45,-2,27,14.5,.5,2,3,1]],
   wins=row(2,24,3,0)+row(72,94,3,0)+row(2,24,3,1)+row(72,94,3,1)+[[8,2,3,6,4.2],[15,2,3,6,4.2],[11.5,3,3,6,4.2]],
   doors=[[35,1,4,8,0,1],[61,1,4,8,0,1],[85,1,5,8,1]], bays=[[48,1,12,3,1]], chims=[[48,11.5,26]], plat=[-15,126,16,1])
st("Edgerton", folder="Wisconsin/Edgerton", title="Edgerton, Wis. passenger depot", src="Album sheet 58, drawing A-7532, June 19 1906 (J. A. Lindstrand)",
   miles=25, known="128 ft overall: building 98 x 24 ft + 30 ft pavilion; baggage 24, smoking 21 ft 10 x 20, office with bay, general waiting 36 ft 4 x 21 ft 10; brick veneer below, stained shingle roof, half pitch",
   blocks=[[0,98,0,24,12.5,.5,0,5,2],[38,34,0,24,14,.55,0,4,2]], pavs=[[98,30,0,24,12.5,.5,0,5,2,2]],
   wins=row(26,44,3,1)+row(62,96,5,1)+row(2,96,10,0),
   doors=[[10,1,5,8,1],[38,1,3.5,7.5,0],[64,1,3.5,7.5,0]], bays=[[51,1,14,3]], chims=[[12,12,25],[60,12,27]], plat=[-6,140,12,.8])
st("Watertown", folder="Wisconsin/Watertown", title="Watertown, Wis. passenger depot (Frost & Granger)", src="Album sheet 48, drawing 6945, Sept 1896 (Frost & Granger)",
   miles=40, known="168 ft overall: depot 88 x 30 ft (women's and men's waiting rooms 36 ft 6, office with bay), 40 ft pavilion, 40 x 30 baggage room; stone base, brick walls, hip roofs, centre gable dormer with lantern",
   blocks=[[0,88,0,30,13,.75,0,5,2],[30.5,27,-3,33,14,.9,1,3,2],[128,40,0,30,13,.75,0,5,2]], pavs=[[88,40,0,30,13,.75,0,5,2,2]],
   wins=row(2,29,3,1)+row(59,86,3,1)+row(2,29,3,0)+row(59,86,3,0)+row(130,166,3,1,blk=2),
   doors=[[22,1,4,8,0],[66,1,4,8,0],[148,1,5,8,1,2]], bays=[[44,1,14,3.5]], chims=[[20,15,29],[68,15,29],[160,15,25]], plat=[-8,184,14,.8])
st("Stoughton", folder="Wisconsin/Stoughton", title="Stoughton, Wis. passenger station", src="Album sheet 106, built 1913 (drawn Apr 11 1919)",
   miles=17, known="129 ft 5 in incl. 27 ft 5 in pavilion; 27 ft 6 in wide; general waiting 26 x 36 ft 6, ticket office 18 ft 6 x 17, smoking 20 x 26, baggage 23 ft 6 x 26; cement plaster, brick base, shingle-tile roof, composition-roof pavilion",
   blocks=[[27.4,102,0,27.5,12,.55,1,3,1],[64.4,19,0,27.5,13,.6,2,3,1]], pavs=[[0,27.4,0,27.5,10,.15,4,2,2,2]],
   wins=row(30,62,4,1)+row(84,104,3,1)+row(30,126,10,0),
   doors=[[60,1,4,8,0],[86,1,4,8,0],[112,1,5,8,1]], bays=[[73.8,1,14,3]], chims=[[45,14,26],[100,14,26]], plat=[-5,140,14,.8])
st("Milton", folder="Wisconsin/Milton", title="Milton, Wis. passenger station", src="Album sheet 99, built 1914",
   miles=33, known="101 ft 6 in: freight and baggage 49 ft 6 x 18 (tar and gravel roof), station 52 x 28 (shingle gable roof); waiting 24 x 25, ticket office 14 x 14, smoking 12 ft 6 x 25 ft 6; brick; pavilion at the waiting-room end",
   blocks=[[49.5,52,0,28,11,.6,1,3,2],[0,49.5,5,18,11,0,4,3,2]], pavs=[[101.5,16,0,28,10,.1,4,2,2,2]],
   wins=row(52,99,5,1)+row(52,99,5,0)+row(3,47,3,1,blk=1),
   doors=[[60,1,3.5,7.5,0],[92,1,3.5,7.5,0],[25,1,5,8,1,1]], bays=[[76,1,13,3]], chims=[[60,14,25],[90,14,25]], plat=[-5,125,12,.8])
st("Monroe", folder="Wisconsin/Monroe", title="Monroe, Wis. passenger depot (J. T. W. Jennings)", src="Album sheet 144 (marked 14), drawing 2005, July 1888 (J. T. W. Jennings)",
   miles=45, known="62 ft 6 in x 20 ft; two waiting rooms 24 ft 3, octagonal office bay 11 ft, baggage 12 ft; steep hipped roof with flared eaves, gabled dormer, iron cresting; lap siding with vertical boards below",
   blocks=[[0,62.5,0,20,13,1.0,3,4.5,0]],
   wins=row(2,62,6,1)+row(2,60,6,0),
   doors=[[16,1,3.5,8,0],[37,1,3.5,8,0],[56,1,5,8,1]], bays=[[25,1,11,3.5]], chims=[[25,10,29]], plat=[-6,75,12,.8])
st("Delavan", folder="Wisconsin/Delavan", title="Delavan, Wis. passenger depot", src="Album sheet 76, drawing B-950, Oct 10 1911",
   miles=55, known="136 ft: baggage 24 x 25, 24 ft open pavilion, depot 88 x 25 (men's waiting 24 ft 6 x 25, ticket office 16 ft 6 x 13 ft 11, general waiting 34 ft 7 x 25); asbestos shingle roof, lap siding, centre gable over the office",
   blocks=[[48,88,0,25,12,.55,1,3,0],[0,24,0,25,12,.55,1,3,0],[83,18,0,25,13,.7,2,3,0]], pavs=[[24,24,0,25,12,.55,1,3,2,2]],
   wins=row(50,82,4,1)+row(102,134,4,1)+row(50,134,10,0),
   doors=[[12,1,5,8,1,1],[79,1,3.5,7.5,0],[106,1,3.5,7.5,0]], bays=[[92,1,16,3]], chims=[[70,12.5,25]], plat=[-5,146,12,.8])
st("Elkhorn", folder="Wisconsin/Elkhorn", title="Elkhorn, Wis. passenger station", src="Album sheet 96, built 1914 (drawn Mar 11 1916); unbuilt 1913 design on sheet 127",
   miles=55, known="110 x 20 ft + 30 ft pavilion (tar and gravel roof); baggage 21 x 24 ft 6, smoking 22 ft 6 x 24 ft 4, ticket office 15 ft 5 x 17 ft 2, general waiting 26 ft 4 x 36 ft 8; stucco, slate roof, centre gable",
   blocks=[[0,110,0,20,12,.6,1,2.5,1],[53,19,0,22,13,.6,2,2.5,1]], pavs=[[110,30,0,20,10,.1,4,2,2,2]],
   wins=row(20,52,4,1)+row(73,108,4,1)+row(15,105,12,0),
   doors=[[8,1,5,8,1],[48,1,4,8,0],[78,1,4,8,0]], bays=[[62.5,1,14,3,1]], chims=[[40,10,24],[85,10,24]], plat=[-5,150,12,.8])
st("Horicon", folder="Wisconsin/Horicon", title="Horicon, Wis. passenger station", src="Album sheet 86, built 1914 (drawn Apr 10 1917)",
   miles=50, known="110 ft overall: 86 ft 6 building + 24 ft pavilion; freight room 20 ft 6 x 18; general waiting, ticket office, smoking room; enlarged from a 42 ft old building; lap siding, shingle hip roofs",
   blocks=[[20.5,66,0,24,12,.55,0,3,0],[0,20.5,3,18,11,.55,0,3,0]], pavs=[[86.5,24,0,24,12,.55,0,3,2,2]],
   wins=row(24,84,8,1)+row(24,84,7,0),
   doors=[[5,1,5,8,1,1],[42,1,3.5,7.5,0]], bays=[[62,1,12,2.5]], chims=[[35,12,24],[70,12,24]], plat=[-5,120,12,.8])
st("Mayville", folder="Wisconsin/Mayville", title="Mayville, Wis. passenger and freight depot", src="Album sheet 140, drawing 7418, July 25 1897 (J. U. Nettenstrom)",
   miles=55, known="24 x 100 ft passenger and freight depot; freight room, smoking 9 x 20, office 14 x 20 with bay, waiting room 23 x 24; board-and-batten gables, lap siding",
   blocks=[[0,100,0,24,12,.55,1,3,0]],
   wins=row(46,100,5,1)+row(46,100,4,0),
   doors=[[6,1,6,8,2],[30,1,6,8,2],[80,1,3.5,7.5,0]], bays=[[60,1,11,2.5]], chims=[[62,12,24]], plat=[-5,110,12,.8])
st("Hartland", folder="Wisconsin/Hartland", title="Hartland, Wis. passenger station", src="Album sheet 111, built 1917 (drawn Aug 26 1919)",
   miles=45, known="63 ft 4 in station + pavilions (15 ft 4 in and 60 ft, tar and gravel roofs); baggage 19 x 27, smoking 16 ft 6 x 27, ticket office 15 ft 8 x 17 ft 10, general waiting 24 ft 10 x 37 ft 4; stucco, red asphalt shingles, half-timbered gable",
   blocks=[[15.4,63.3,0,33.5,11,.55,0,3,1]], pavs=[[0,15.4,4,25,9.5,.1,4,1.5,2,2],[78.7,60,4,25,9.5,.1,4,1.5,4,2]],
   wins=row(18,76,5,1)+row(18,76,5,0),
   doors=[[20,1,5,8,1],[52,1,3.5,7.5,0]], bays=[[44,1,12,3]], chims=[[40,17,24]], plat=[-5,150,10,.8])
st("Nashotah", folder="Wisconsin/Nashotah", title="Nashotah, Wis. passenger station", src="Album sheet 94, built 1915",
   miles=40, known="50 x 24 ft, waiting room 22 ft 6 x 40, ticket office 9 x 16 ft 6; stucco, asbestos shingles; built on a slope with a lower storey and grand stair on the track side (lower storey NOT modelled yet)",
   blocks=[[0,50,0,24,11,.6,1,3,1]], pavs=[[50,24,0,24,10,.1,4,2,2,2]],
   wins=row(2,48,4,1)+row(2,48,4,0),
   doors=[[25,0,5,8,1],[25,1,4,8,0]], bays=[[44,1,9,2.5]], chims=[[5,12,24]], plat=0)
st("Fond_du_Lac", folder="Wisconsin/Fond du Lac", title="Fond du Lac, Wis. passenger depot (1898)", src="Album sheet 132, Nov 1898 (J. U. Nettenstrom)",
   miles=65, known="24 x 60 ft; women's waiting 16 ft 6 x 22, office 12 x 15 with bay, men's waiting 17 x 22, baggage 11 x 22; brick veneer, stone trim, flared hip roof with hipped dormer, cresting",
   blocks=[[0,60,0,24,12,.9,3,4.5,2]],
   wins=row(2,58,5,1)+row(2,58,5,0),
   doors=[[16,1,3.5,8,0],[36,1,3.5,8,0],[54,1,5,8,1]], bays=[[25,1,11,3]], chims=[[30,12,28]], plat=[-5,70,12,.8])
st("Kiel", folder="Wisconsin/Kiel", title="Kiel, Wis. passenger station", src="Album sheet 93, built 1916 (drawn Aug 9 1916)",
   miles=95, known="113 ft 8 in + 28 ft pavilion; station 53 ft 8 x 26 (general waiting 19 ft 6 x 24 ft 8, ticket office 12 ft 2 x 15 ft 2, smoking 11 ft 6 x 24 ft 8), freight and baggage 62 x 24 (tar and gravel); stucco, asbestos shingles, clerestory dormer",
   blocks=[[28,53.6,0,26,12,.6,1,3,1],[81.6,62,1,24,11,0,4,2,1]], pavs=[[0,28,0,26,10,.1,4,2,2,2]],
   wins=row(30,80,5,1)+row(30,80,5,0)+row(85,140,3,1,blk=1),
   doors=[[45,1,3.5,7.5,0],[65,1,3.5,7.5,0],[112,1,6,8,2,1]], bays=[[55,1,14,3]], chims=[[40,13,25],[70,13,25]], plat=[-5,155,12,.8])
st("Juda", folder="Wisconsin/Juda", title="Juda, Wis. passenger station", src="Album sheet 124, drawing B-?, June 1 1928",
   miles=40, known="44 x 24 ft depot + 24 ft exterior high platform; baggage and freight room, waiting room, ticket office with bay; drop siding, gable roof",
   blocks=[[24,44,0,24,11,.55,1,2,0]],
   wins=row(46,68,3,1)+row(46,68,2,0),
   doors=[[36,1,5,8,1],[64,1,3.5,7.5,0]], bays=[[55,1,9,2.5]], chims=[[50,12,23]], plat=[0,24,24,3.5])
st("Walworth_freight", folder="Wisconsin/Walworth", title="Walworth, Wis. 24 x 48 ft freight house", src="Album sheet 125, drawing B-755, Sept 16 1910 (also used at Mobridge, S.D. 1912)",
   miles=60, known="24 x 48 ft, floor 3 ft 6 above rail on posts, 6 ft platform track side; 14 ft walls, 1/3 pitch shingle roof, drop siding, class B rolling doors",
   blocks=[[0,48,0,24,17.5,.66,1,2,0]],
   doors=[[12,1,6,8,2],[36,1,6,8,2],[24,0,6,8,2]], plat=[-6,60,6,3.5])
st("Richland_Center", folder="Wisconsin/Richland Center", title="Richland Center, Wis. passenger depot", src="Album sheet 67, drawing B-616, Nov 3 1909",
   miles=55, known="64 x 20 ft; baggage 12 ft 6 x 19, smoking 16 x 19, ticket office 11 ft 10 x 9 with bay, women's waiting 16 x 19; hipped shingle roof with flared eaves, diamond-pane upper sash",
   blocks=[[0,64,0,20,12,.75,3,4,0]],
   wins=row(14,62,6,1)+row(14,62,6,0),
   doors=[[6,1,5,8,1],[24,1,3.5,7.5,0],[48,1,3.5,7.5,0]], bays=[[38,1,10,2.5]], chims=[[30,10,24]], plat=[-5,74,12,.8])
st("Muscoda", folder="Wisconsin/Muscoda", title="Muscoda, Wis. passenger station", src="Album sheet 118, drawing B-3261, July 26 1927",
   miles=55, known="78 ft 6 in x about 24 ft; waiting 20 x 23, ticket office 10 x 13 with bay, freight and baggage 32 ft 3 x 39?; high platforms; brick, hipped shingle roof",
   blocks=[[0,78.5,0,24,12,.55,0,3,2]],
   wins=row(2,36,4,1)+row(2,76,6,0),
   doors=[[16,1,3.5,7.5,0],[46,1,5,8,1],[66,1,5,8,1]], bays=[[30,1,11,3]], chims=[[30,12,24]], plat=[40,38,10,3.5])
st("Springfield", folder="Wisconsin/Springfield", title="Springfield, Wis. passenger depot", src="Album sheet 82, drawing B-943, May 29 1912",
   miles=60, known="80 x 24 ft; waiting 18 ft 3, office 12 ft 6 with bay, smoking 12 ft 6, freight room 36 ft 9; hipped shingle roof, lap siding",
   blocks=[[0,80,0,24,11.5,.5,0,3,0]],
   wins=row(1,43,5,1)+row(1,43,5,0)+row(45,79,2,1),
   doors=[[19,1,3.5,7.5,0],[37,1,3.5,7.5,0],[62,1,6,8,2]], bays=[[25,1,12,2.5]], chims=[[18,12,23],[38,12,23]], plat=[-5,90,12,.8])
st("Slinger", folder="Wisconsin/Slinger", title="Schleisingerville (Slinger), Wis. passenger depot", src="Album sheet 74, drawing B-1026, Oct 30 1911",
   miles=65, known="70 ft 6 in x 24 ft + 32 ft pavilion; freight and baggage 24 ft 3 x 23 ft 6, smoking 11 ft 11 x 23, office 12 ft 6 x 17, general waiting 19 ft 4 x 23 ft 6; hipped shingle roof, lap siding",
   blocks=[[0,70.5,0,24,12,.5,0,3.5,0]], pavs=[[70.5,32,0,24,12,.5,0,3.5,2,2]],
   wins=row(40,70,4,1)+row(26,70,5,0),
   doors=[[8,1,5,8,1],[30,1,3.5,7.5,0],[56,1,3.5,7.5,0]], bays=[[44,1,12,2.5]], chims=[[20,12,24],[45,12,24]], plat=[-5,112,12,.8])
st("Stowell", folder="Wisconsin/Stowell", title="Stowell, Wis. passenger depot", src="Album sheet 69, drawing B-586, Sept 14 1909",
   miles=None, known="56 x 20 ft; general waiting 16 x 19, office 11 ft 6 x 9 with bay, smoking 10 x 19, baggage and express 16 x 19; flared hipped shingle roof, diamond-pane upper sash, lap siding",
   blocks=[[0,56,0,20,12,.8,3,4,0]],
   wins=row(2,54,6,1)+row(2,54,6,0),
   doors=[[11,1,3.5,7.5,0],[34,1,3.5,7.5,0],[48,1,5,8,1]], bays=[[22.75,1,12,3]], chims=[[22,10,25]], plat=[-5,66,12,.8])
st("Racine_Junction", folder="Wisconsin/Racine Junction", title="Racine Junction, Wis. union depot (C.M.&St.P. and C.&N.W.)", src="Album sheets 141-142, drawing 9804, Apr 6 1900 (J. U. Nettenstrom)",
   miles=70, known="63 ft 10 in x 24 ft (35 ft 9 at the octagon); octagonal centre with back-to-back C.&N.W. and C.M.&St.P. waiting rooms 17 x 22, two offices 10 x 15, baggage 15 x 22; stone base, bell-cast hip roofs, cresting. Octagon shown as a square block for now",
   blocks=[[0,63.8,0,24,12,.9,3,4,3],[24,24,-6,35.8,13,1.0,3,4,3]],
   wins=row(2,22,2,1)+row(2,22,2,0)+row(50,62,1,1)+row(50,62,1,0),
   doors=[[36,1,4,8,0,1],[36,0,4,8,0,1],[56,1,5,8,1]], chims=[[30,12,30],[42,12,30]], plat=[-5,74,12,.8])
st("Corliss", folder="Wisconsin/Corliss (Sturtevant)", title="Corliss (Sturtevant), Wis. junction depot", src="Album sheet 39, drawing A-725, May 16 1901 (J. U. Nettenstrom)",
   miles=70, known="68 x 68 ft L at the junction of two lines: smoking 15 x 19, general waiting 27 x 27 with octagonal office bay 15 x 15, two 24 and 20 ft pavilions, baggage 15 x 19; tall conical turret over the office, cresting",
   blocks=[[0,40,0,20,13,.6,0,4,0],[0,20,20,48,13,.6,0,4,0],[64,16,0,20,13,.6,0,4,0]], pavs=[[40,24,0,20,13,.6,0,4,2,2]],
   wins=row(2,38,4,1)+row(2,38,4,0),
   doors=[[30,1,3.5,8,0],[72,1,5,8,1,2]], chims=[[30,10,26]], plat=[-5,90,10,.8])
