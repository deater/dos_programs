5 DIM SA(10),SB(10),BA(10),BB(10),PA(15),PB(15),BM(10)
7 SND=1:VEL=10
10 SCREEN 0,0,0:WIDTH 40:CLS:COLOR 15
12 DEF SEG=0
14 POKE 1047,112
16 DEF SEG
20 LOCATE 1,10:PRINT"S T A R     F I G H T"
30 LOCATE 2,18:PRINT"B Y"
40 LOCATE 3,12:PRINT"Vincent Weaver"
50 LOCATE 23,10:PRINT"Press A Key To Play"
99 I$=INKEY$:IF I$="" THEN 99
100 DEF SEG=&HB800
110 CLS:SCREEN 1:KEY OFF
120 BLOAD"SFIGHT.PIC",0
130 GET (100,100)-(109,105),SA
140 GET(200,100)-(209,105),SB
150 LINE(100,100)-(109,105),0,BF
155 LINE(200,100)-(209,105),0,BF
160 GET(100,100)-(109,105),BA
170 GET(200,100)-(209,105),BB
180 PUT(30,155),SA
182 GET(140,100)-(144,105),BM
184 LINE(140,100)-(144,105),0,BF
185 PUT(280,155),SB
190 AX=30:AY=155:BX=280:BY=155
195 SAX=AX:SAY=AY:SBX=BX:SBY=BY
1000 I$=INKEY$:IF I$="" THEN 1000
1002 IF I$="8" THEN SBY=SBY-5:IF SBY<0 THEN SBY=0
1004 IF I$="2" THEN SBY=SBY+5:IF SBY>194 THEN SBY=1
1006 IF I$="6" THEN SBX=SBX+5:IF SBX>309 THEN SBX=0
1008 IF I$="4" THEN SBX=SBX-5:IF SBX<4 THEN SBX=309
1010 IF I$="W" THEN SAY=SAY-5:IF SAY<0 THEN SAY=0
1012 IF I$="Q"THEN END
1013 IF I$="C" THEN PUT(SAX,SAY+10),BM
1014 IF I$="3" THEN PUT(SBX,SBY+10),BM
1015 IF I$="X" THEN SAY=SAY+5:IF SAY>194 THEN SAY=1
1017 IF I$="D" THEN SAX=SAX+5:IF SAX>309 THEN SAX=0
1018 IF I$="P" THEN SND=-SND
1019 IF I$="A" THEN SAX=SAX-5:IF SAX<4 THEN SAX=309
1020 PUT(AX,AY),BA,PSET
1025 PUT(BX,BY),BB,PSET
1030 GET(SAX,SAY)-(SAX+9,SAY+5),BA
1035 GET(SBX,SBY)-(SBX+9,SBY+5),BB
1040 AX=SAX:AY=SAY:PUT(AX,AY),SA
1045 BX=SBX:BY=SBY:PUT(BX,BY),SB
1047 PA(1)= POINT(SAX+3,SAY+6)
1050 PB(1)= POINT(SBX+3,SBY+6)
1055 PA(2)= POINT(SAX+3,SAY-1)
1060 PB(2)= POINT(SBX+3,SBY-1)
1065 PA(3)= POINT(SAX-1,SAY+2)
1070 PB(3)= POINT(SBX-1,SBY+2)
1075 PA(4)= POINT(SAX+10,SAY+3)
1080 PB(4)= POINT(SBX+9,SBY+3)
1083 GOSUB 1120
1085 I$="":ZEN=ZEN+1:IF ZEN>1 THEN ZEN=0
1094 IF SBX<1 THEN SBX=309
1095 IF SBX>309 THEN SBX=1
1096 IF SAX>309 THEN SAX=1
1097 IF SAX<0 THEN SAX=309
1098 IF SAY>189 THEN SAY=1
1099 IF SBY>189 THEN SBY=1
1100 IF ZEN>=1 THEN GOTO 1020
1110 GOTO 1000
1120 REM POINT ROUTINE
1130 FOR I=1 TO 4
1140 PBN=PBN+PA(I)+PB(I)
1150 IF PB(I)=3 THEN BOOM=1:GOTO 1200
1160 IF PA(I)=3 THEN BOOM=2:GOTO 1200
1170 NEXT I
1180 IF PBN=0 THEN RETURN
1187 PBN=0
1188 IF PA(1)<>0 THEN SAY=SAY-10
1189 IF PB(1)<>0 THEN SBY=SBY-10
1190 IF PA(2)<>0 THEN SAY=SAY+10
1191 IF PB(2)<>0 THEN SBY=SBY+10
1192 IF PA(3)<>0 THEN SAX=SAX+VEL
1193 IF PB(3)<>0 THEN SBX=SBX+VEL
1194 IF PA(4)<>0 THEN SAX=SAX-VEL
1195 IF PB(4)<>0 THEN SBX=SBX-VEL
1197 IF SND>0 THEN SOUND 47,.2
1199 RETURN
1200 IF BOOM=1 THEN SQX=SBX:SQY=SBY
1205 IF BOOM=2 THEN SQX=SAX:SQY=SAY
1210 LINE(SQX,SQY)-(SQX+10,SQY+5),2,BF
1220 BEEP:SOUND 47,2
1230 IF BOOM=1 THEN WFA=WFA+1
1235 IF BOOM=2 THEN WFB=WFB+1
1240 CLS:PUT(1,1),SA
1245 LOCATE 1,3:PRINT"=";WFA
1250 PUT(1,30),SB
1255 LOCATE 5,3:PRINT"=";WFB
1260 LOCATE 10,3:PRINT"Play Again?"
1270 JU$=INKEY$:IF JU$="" THEN 1270
1280 IF JU$="Y" OR JU$="y" THEN GOTO 100
1285 IF JU$="N" OR JU$="n" THEN END
1290 GOTO 1270
