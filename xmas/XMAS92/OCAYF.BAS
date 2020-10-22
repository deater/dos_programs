DECLARE SUB feet ()
DECLARE SUB manger ()
DECLARE SUB setup ()
DECLARE SUB song ()
DECLARE SUB stars ()
DECLARE SUB wise ()
REM INPUT "Delay(0-1000) to make men go fast are slow"; delays
delays = 50
DIM SHARED sp
DIM SHARED star(100)
DIM SHARED WISE1(100)
DIM SHARED wise2(100)
DIM SHARED WISE3(100)
DIM SHARED foot1(40)
DIM SHARED FOOT2(40)
DIM SHARED FOOT3(40)
DIM SHARED FOOT4(40)
DIM SHARED FOOT5(40)
DIM SHARED FOOT6(40)
DIM SHARED FOOT7(40)
DIM SHARED FOOT8(40)
DIM SHARED temp1(100)
DIM SHARED temp2(40)
setup
feet
wise
stars
REM(star of Bethlehem)
      FOR y = 40 TO 57 STEP 1
        FOR x = 153 TO 165 STEP 1
          READ strdat
          PSET (x, y), strdat
        NEXT x
      NEXT y
        DATA 0,0,0,0,0,0,1,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,1,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,9,0,0,0,0,0,0
        DATA 0,0,0,0,8,9,11,9,8,0,0,0,0
        DATA 0,0,0,8,1,3,11,3,1,8,0,0,0
        DATA 0,0,8,9,3,15,15,15,3,9,8,0,0
        DATA 1,1,9,11,11,15,15,15,11,11,9,1,1
        DATA 0,0,8,9,3,15,15,15,3,9,8,0,0
        DATA 0,0,0,8,1,3,15,3,1,8,0,0,0
        DATA 0,0,0,0,8,9,11,9,8,0,0,0,0
        DATA 0,0,0,0,0,9,11,9,0,0,0,0,0
        DATA 0,0,0,0,0,0,9,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,9,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,9,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,1,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,1,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,8,0,0,0,0,0,0
        DATA 0,0,0,0,0,0,8,0,0,0,0,0,0,0
manger
REM(move)
trip = 0
WHILE trip < 3
wmx = 0
wmy = 175
GET (wmx, wmy)-(wmx + 12, wmy + 20), temp1
IF trip = 0 THEN POT = 140
IF trip = 1 THEN POT = 125
IF trip = 2 THEN POT = 110
WHILE wmx < POT
   FOR FOOT = 1 TO 8
  PUT (ox, wmy), temp1, PSET: GET (wmx, wmy)-(wmx + 11, wmy + 20), temp1
  IF trip = 0 THEN PUT (wmx, wmy), WISE1, XOR
  IF trip = 1 THEN PUT (wmx, wmy), wise2, XOR
  IF trip = 2 THEN PUT (wmx, wmy), WISE3, XOR
  IF FOOT = 1 THEN PUT (wmx + 1, wmy + 17), foot1, PSET
  IF FOOT = 2 THEN PUT (wmx + 1, wmy + 17), FOOT2, PSET
  IF FOOT = 3 THEN PUT (wmx + 1, wmy + 17), FOOT3, PSET
  IF FOOT = 4 THEN PUT (wmx + 1, wmy + 17), FOOT4, PSET
  IF FOOT = 5 THEN PUT (wmx + 1, wmy + 17), FOOT5, PSET
  IF FOOT = 6 THEN PUT (wmx + 1, wmy + 17), FOOT6, PSET
  IF FOOT = 7 THEN PUT (wmx + 1, wmy + 17), FOOT7, PSET
  IF FOOT = 8 THEN PUT (wmx + 1, wmy + 17), FOOT8, PSET
  ox = wmx
  IF FOOT > 5 THEN wmx = wmx + 1
  FOR I = 1 TO delays: NEXT
  NEXT FOOT
 WEND
 IF trip = 0 THEN PUT (wmx, wmy), WISE1, PSET: sp = 1
 IF trip = 1 THEN PUT (wmx, wmy), wise2, PSET: sp = 2
 IF trip = 2 THEN PUT (wmx, wmy), WISE3, PSET: sp = 3
 PUT (wmx + 1, wmy + 17), foot1, PSET
 ox = 0
 trip = trip + 1
 song
 WEND
sp = 4: song
loopest:
I$ = INKEY$: IF I$ = "" THEN GOTO loopest
SYSTEM

SUB feet
  sa = 6
  ft = 13
  LOOPER = 0
toot:
  LINE (101, 103)-(104, 103), sa
  LINE (101, 102)-(104, 102), ft
  PSET (103, 102), sa
  PSET (101, 101), ft
IF LOOPER = 0 THEN GET (101, 101)-(104, 103), temp1
IF LOOPER = 1 THEN GET (101, 101)-(104, 103), temp2
LINE (100, 100)-(104, 104), 0, BF
  sa = 8
  ft = 5
IF LOOPER = 0 THEN LOOPER = 1: GOTO toot
   REM(Foot1)
     PUT (200, 101), temp2, PSET
     PUT (201, 101), temp1, PSET
     GET (200, 101)-(204, 103), foot1
     LINE (200, 101)-(220, 103), 0, BF
   REM(foot2)
     PUT (201, 100), temp2, PSET
     PUT (201, 101), temp1, PSET
     GET (200, 101)-(204, 103), FOOT2
     LINE (200, 100)-(220, 103), 0, BF
   REM(foot3)
     PUT (202, 99), temp2, PSET
     PUT (201, 101), temp1, PSET
     GET (200, 101)-(205, 103), FOOT3
     LINE (200, 99)-(220, 103), 0, BF
   REM(foot4)
     PUT (203, 100), temp2, PSET
     PUT (201, 101), temp1, PSET
     GET (200, 101)-(206, 103), FOOT4
     LINE (200, 99)-(220, 103), 0, BF
   REM(foot5)
     PUT (204, 101), temp2, PSET
     PUT (201, 101), temp1, PSET
     GET (200, 101)-(207, 103), FOOT5
     LINE (200, 99)-(220, 103), 0, BF
   REM(foot6)
     PUT (203, 101), temp2, PSET
     PUT (201, 100), temp1, PSET
     GET (200, 101)-(206, 103), FOOT6
     LINE (200, 99)-(220, 103), 0, BF
   REM(foot7)
     PUT (202, 101), temp2, PSET
     PUT (201, 99), temp1, PSET
     GET (200, 101)-(205, 103), FOOT7
     LINE (200, 99)-(220, 103), 0, BF
   REM(foot8)
     PUT (201, 101), temp2, PSET
     PUT (201, 100), temp1, PSET
     GET (200, 101)-(204, 103), FOOT8
     LINE (200, 99)-(220, 103), 0, BF

END SUB

SUB manger
REM(roof)
  LINE (120, 125)-(197, 128), 14, BF
    FOR I = 1 TO 35
      rf1 = INT(RND * 4)
      rf2 = INT(RND * 77)
      PSET (120 + rf2, 125 + rf1), 6
    NEXT I
REM(lwall)
  LINE (122, 129)-(124, 172), 6, BF
  LINE (125, 129)-(126, 170), 8, BF
  PSET (125, 171), 8
  LINE (140, 129)-(140, 155), 8
  LINE -(126, 169), 8
  LINE (125, 129)-(190, 129), 8
REM(lwindow)
  LINE (128, 144)-(129, 158), 8, BF
  LINE (137, 135)-(138, 149), 8, BF
  LINE (128, 144)-(137, 135), 8
  LINE (129, 144)-(138, 135), 8
  LINE (129, 158)-(138, 149), 8
  LINE (128, 158)-(137, 149), 8
  PAINT (130, 130), 4, 8
  LINE (135, 139)-(136, 149), 7, BF
  LINE (130, 155)-(136, 149), 7
  LINE (130, 154)-(135, 149), 7
  PSET (136, 138), 7
  LINE (135, 149)-(136, 149), 8
REM(center wall)
  LINE (178, 129)-(178, 155), 8
  LINE (140, 155)-(178, 155), 8
  LINE (141, 130)-(177, 154), 6, BF
  LINE (145, 135)-(172, 149), 8, BF
  LINE (148, 137)-(170, 147), 0, BF
  LINE (149, 147)-(169, 147), 7
  LINE (150, 146)-(168, 146), 7
  LINE (148, 137)-(148, 146), 7
  LINE (149, 137)-(149, 145), 7
  LINE (170, 137)-(170, 146), 7
  LINE (169, 137)-(169, 145), 7
REM(rwall)
  LINE (195, 129)-(193, 172), 6, BF
  LINE (191, 129)-(192, 170), 8, BF
  PSET (192, 171), 8
  LINE (190, 167)-(178, 155), 8
REM(rwindow)
  LINE (180, 135)-(181, 149), 8, BF
  LINE (188, 143)-(189, 157), 8, BF
  LINE (181, 135)-(189, 143), 8
  LINE (180, 135)-(188, 143), 8
  LINE (180, 149)-(188, 157), 8
  LINE (181, 149)-(189, 157), 8
  LINE (182, 139)-(183, 148), 7, BF
  PSET (182, 138), 7
  LINE (183, 150)-(188, 155), 7
  LINE (184, 150)-(187, 153), 7
  PAINT (185, 130), 4, 8
REM(ceiling)
  LINE (140, 129)-(177, 132), 14, BF
  LINE (127, 129)-(190, 129), 8
  LINE (127, 129)-(140, 132), 8
  LINE (190, 129)-(178, 132), 8
  LINE (140, 132)-(178, 132), 8
  PAINT (181, 130), 14, 8
  PAINT (136, 130), 14, 8
  LINE (178, 130)-(178, 131), 14
REM(baby)
  LINE (153, 155)-(163, 169), 4, BF
  LINE (154, 156)-(162, 168), 14, BF
  LINE (156, 155)-(160, 159), 13, BF
  LINE (156, 160)-(160, 167), 7, BF
  PSET (157, 156), 1
  PSET (159, 156), 1
  PSET (158, 159), 5
  LINE (156, 153)-(160, 153), 14
  LINE (153, 170)-(154, 171), 4, BF
  PSET (155, 171), 4
  LINE (163, 170)-(162, 171), 4, BF
  PSET (161, 171), 4
  LINE (157, 160)-(158, 166), 15, BF
  LINE (158, 161)-(158, 164), 8
  PSET (158, 162), 7
  PSET (157, 165), 7
  LINE (159, 162)-(159, 163), 15
  PSET (159, 165), 8
  PSET (155, 157), 6: PSET (154, 161), 6: PSET (154, 167), 6
  PSET (154, 159), 8: PSET (155, 163), 8: PSET (154, 167), 8
  PSET (162, 157), 6: PSET (161, 165), 6
  PSET (161, 161), 8: PSET (162, 164), 8: PSET (161, 167), 8

  





END SUB

SUB setup
KEY OFF
RANDOMIZE TIMER
SCREEN 7
CLS
LINE (0, 150)-(320, 174), 2, BF
END SUB

SUB song
I$ = INKEY$: IF I$ = "q" OR I$ = "Q" THEN SYSTEM
SO1$ = "o3 l4 fl2fl4cfl2gc"
SO2$ = "l4agab-l2al4g"
so3$ = "l4fl2fl4el4defgal2el"
so4$ = "4ddl3cp4"
so5$ = "l2>c<l4b-al2b-a"
so6$ = "l4gafgl2el4c"
so7$ = "l4ffefgl2fl4c"
so8$ = "l4aagab-l2al4gab-agfl2e"
so9$ = "l4fb-l2al4ggl3f"
IF sp = 1 THEN PLAY SO1$ + SO2$
IF sp = 2 THEN PLAY so3$ + so4$
IF sp = 3 THEN PLAY so5$ + so6$
IF sp = 4 THEN PLAY so7$ + so8$ + so9$
I$ = INKEY$: IF I$ = "q" OR I$ = "Q" THEN SYSTEM
END SUB

SUB stars
PSET (101, 100), 7: PSET (100, 101), 7: PSET (101, 101), 15: PSET (102, 101), 7: PSET (101, 102), 7
GET (100, 100)-(102, 102), star
FOR I = 1 TO 100
x = INT(RND * 318): y = INT(RND * 148)
PUT (x, y), star, XOR
NEXT I
END SUB

SUB wise
  skn = 13
  hr = 6
  rob1 = 9
  rob2 = 1
  box1 = 10
  box2 = 2
  LOOPER = 0
  REM (crown)
   LINE (0, 0)-(4, 1), 14, BF
   PSET (1, 0), 0
   PSET (3, 0), 0
   PSET (1, 1), 12
   PSET (3, 1), 12
head:
   LINE (0, 2)-(4, 5), hr, BF
   LINE (2, 3)-(4, 6), skn, BF
   PSET (3, 3), 8
   PSET (5, 4), skn
   PSET (1, 4), skn
   PSET (4, 6), 0
robe:
   LINE (1, 8)-(5, 17), rob1, BF
   LINE (1, 7)-(4, 7), rob2
   LINE (2, 7)-(2, 17), rob2
   LINE (4, 7)-(4, 10), rob2
   LINE (4, 12)-(4, 17), rob2
   LINE (4, 10)-(7, 10), rob2
   LINE (2, 12)-(7, 12), rob2
   LINE (3, 11)-(7, 11), rob1
box:
   LINE (8, 11)-(10, 11), skn
   LINE (9, 9)-(11, 10), box1, BF
   LINE (9, 8)-(11, 8), box2
  IF LOOPER = 0 THEN GET (0, 0)-(11, 20), WISE1
   rob1 = 10
   rob2 = 2
   box1 = 9
   box2 = 1
   LOOPER = LOOPER + 1
   IF LOOPER = 1 THEN GOTO head
   IF LOOPER = 2 THEN GET (0, 0)-(11, 20), wise2
   skn = 6
   hr = 8
   rob1 = 12
   rob2 = 4
   box1 = 11
   box2 = 3
   IF LOOPER = 2 THEN GOTO head
   GET (0, 0)-(11, 20), WISE3
   LINE (0, 0)-(11, 20), 0, BF
END SUB

