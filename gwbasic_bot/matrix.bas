DIM t(80):FOR x=1 TO 80:t(x)=INT(-50*RND):NEXT:CLS:w$="ACCKKLA"
1 FOR x=1 TO 80:IF t(x)>28 THEN t(x)=0
t(x)=t(x)+1
FOR z=0 TO 6:s=-2*(Z=6):COLOR ASC(MID$(w$,z+1,1))-65,s:y=t(x)-6+z
IF y>0 AND y<24 THEN LOCATE y,x: PRINT CHR$(33+(x*y) MOD 200);
NEXT Z,X
GOTO 1
