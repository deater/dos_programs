5 CLS:SCREEN 8
10 A$="sample.ppo":GOSUB 10000
15 LOCATE 20,1
100 REM ************ This Loads Paintpro Pictures ********
110 REM * Lines 10000-10080 are the critical ones        *
120 REM * As long as a$ = a filename it can be loaded    *
130 REM * You can use other graphics modes (7,8,9)  also *
140 REM * To use for CGA draw the picture in EGA but use *
150 REM * Colors 0,1,2 and 3 only                        *
160 REM *                                                *
170 REM *Vince Weaver 21085-4706                         *
180 REM **************************************************
9999 END
10000 OPEN A$ FOR INPUT AS #1
10005 INPUT #1,PART$
10007 INPUT #1,MAXCOL
10010 INPUT #1, XSIZE: INPUT #1,YSIZE
10020 IF EOF(1) THEN GOTO 10080
10030 INPUT #1,TEMP1:C=TEMP1/1000:C=INT(C):NA=TEMP1-(C*1000)
10040 LINE(X,Y)-(X+NA,Y),C
10050 IF X+NA+1>XSIZE THEN Y=Y+1:X=0:NA=0
10060 X=X+NA
10070 GOTO 10020
10080 CLOSE #1:RETURN
