1 CLS : SCREEN 9: KEY OFF
15 LINE (6, 1)-(17, 30), 15, BF: REM white body
20 LINE (4, 39)-(23, 42), 2, BF: REM green main skateboard
25 LINE (6, 43)-(9, 46), 14, BF: REM one wheel
30 LINE (18, 43)-(21, 46), 14, BF: REM other wheel
35 LINE (6, 1)-(13, 6), 13, BF: REM ear
40 LINE (6, 23)-(17, 30), 6, BF: REM BROWN BOTTOM
45 LINE (14, 1)-(22, 14), 6, BF: REM face
50 LINE (16, 3)-(19, 6), 0, BF: REM eye
55 LINE (14, 35)-(17, 38), 13, BF: REM Foot
60 LINE (10, 31)-(13, 38), 13, BF: REM leg
65 LINE (9, 31)-(9, 38), 5: REM back foot
70 LINE (23, 14)-(23, 3), 6: REM part of face
71 FOR QWE = 24 TO 26: SAS = 13: CMP = 4: LINE (QWE, SAS - (QWE - 24))-(QWE, CMP + (QWE - 24)), 6
72 NEXT QWE: REM Rest of Face
75 LINE (26, 7)-(27, 10), 13, BF: REM Nose
76 LINE (0, 35)-(1, 38), 2, BF: LINE (1, 36)-(2, 39), 2, BF: REM part of board
77 LINE (2, 37)-(3, 40), 2, BF: REM in between
78 LINE (3, 38)-(4, 41), 2, BF: LINE (24, 39)-(25, 40), 2, BF: REM rest of board
80 LINE (10, 7)-(13, 10), 6, BF: REM by EAR
85 LINE (18, 19)-(21, 22), 13, BF: REM arms
200 PSET (6, 1), 0: PSET (13, 1), 6: PSET (6, 6), 15: PSET (13, 6), 6: REM fix ear
205 LINE (7, 44)-(8, 45), 4, BF: LINE (19, 44)-(20, 45), 4, BF: REM wheel cap
210 PSET (17, 29), 0: PSET (17, 30), 0: PSET (16, 30), 0
215 PSET (16, 3), 6: PSET (19, 3), 6: PSET (16, 6), 6: PSET (19, 6), 6: REM fix eye
220 PSET (16, 35), 0: PSET (17, 35), 0: PSET (17, 36), 0: PSET (16, 36), 5: REM fix foot
225 PSET (22, 1), 0: REM fix face
230 PSET (6, 29), 0: PSET (6, 30), 0: PSET (7, 30), 0: REM fixBottom
235 PSET (12, 11), 6: PSET (13, 11), 6: PSET (13, 12), 6: REM touchup by ear
240 PSET (10, 10), 15: PSET (14, 14), 15: REM touch up "" ""
245 PSET (18, 20), 5: PSET (19, 20), 5: PSET (20, 18), 5: PSET (21, 18), 5: REM back arm
250 PSET (18, 19), 0: PSET (19, 19), 0: REM touch up arm
255 DIM BACK(2000)
260 DIM CHIP(2000)
265 DIM FRON(2000)
270 GET (0, 0)-(27, 46), CHIP
280 CLS
281 Y = 252: Y1 = Y
285 LINE (0, 300)-(639, 310), 2, BF
286 FOR QQQ = 7 TO 640 STEP 14
287 LINE (QQQ, 302)-(QQQ + 5, 308), 14, BF: NEXT QQQ
288 GOSUB 1080
1000 X$ = INKEY$
1005 PN = POINT(X + 8, Y + 48): IF PN = 0 THEN GOSUB 1200
1007 LOCATE 23, 1: PRINT POINT(X + 8, Y + 48), FALL, J, JUM: IF PN <> 0 AND FALL = 1 THEN FALL = 0: JUM = 0: J = 0
1008 IF J = 1 THEN GOSUB 1310
1009 IF X$ = "" THEN 1000
1010 IF X$ = "K" THEN X1 = X1 - 5: GOSUB 1050
1020 IF X$ = "L" THEN X1 = X1 + 5: GOSUB 1050
1030 IF X$ = "Q" THEN END
1035 IF X$ = "J" AND J = 0 AND FALL = 0 THEN J = 1: GOSUB 1300
1040 GOTO 1000
1050 IF X1 < 0 THEN X1 = X1 + 5
1053 IF X1 > 610 THEN X1 = X1 - 5
1055 PUT (X, Y), BACK, PSET
1060 X = X1: Y = Y1
1070 FOR TTT = 1 TO 1000: NEXT TTT
1080 GET (X, Y)-(X + 27, Y + 46), BACK
1090 FGR$ = INKEY$: IF FGR$ = "Q" THEN END
1100 PUT (X, Y), CHIP, PSET
1110 RETURN
1120 I$ = INKEY$: IF I$ = "" THEN 1120
1130 END
1200 IF J = 0 THEN Y1 = Y1 + 5: FOR I = 1 TO 500: NEXT: GOSUB 1050
1210 RETURN
1300 JUM = 0
1310 JUM = JUM + 1: Y1 = Y1 - 5: GOSUB 1050: IF JUM >= 5 THEN FALL = 1: J = 0
1320 RETURN
