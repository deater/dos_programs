1 DIM A%(16):SCREEN 9
2 FOR I=0 TO 6:READ C:A%(I)=C:NEXT:DATA 32,52,38,46,38,52,32
3 FOR Y=0 TO 350:LINE (0,Y)-(639,Y),FIX((Y MOD 14)/2):NEXT
4 PALETTE USING A%(0)
5 A%(7)=A%(0):FOR I=0 to 7:A%(I)=A%(I+1):NEXT
6 FOR I=0 TO 1000:NEXT:GOTO 4
