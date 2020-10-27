0 DIM B(200),Q(200),D(200)
1 A$="h>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gS:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<=FkZq=KjXd=n:VJXG::cj:@O_:DkRGHX@akX^Q:V:N^="
2 FOR I=1 TO 127
3 B(I)=(ASC(MID$(A$,I,1))-58)*4
4 Q(I)=((ASC(MID$(A$,128+(I-2)/3,1))-58))
5 D(I)=(4^((I-1) MOD 3))
6 B(I)=B(I)+(INT(Q(I)/D(I)) AND 3)
7 NEXT
10 FOR I=1 TO 127:PRINT B(I);" ";:IF (I MOD 16=0) THEN PRINT
11 NEXT:PRINT
20 CALL VARPTR(B(0))
