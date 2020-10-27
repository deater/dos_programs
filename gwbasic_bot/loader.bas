0 DIM B%(200),Q(200),D(200)
5 DEF FN P(X)=ASC(MID$(A$,X,1))-58
10 A$="h:J]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^N=:JDFZKOCZLFP]]akSfAs?:A:?s"
20 FOR I=1 TO 132
30 B%(I)=FNP(I)*4
40 Q(I)=FNP(133+(I-2)/3)
50 D(I)=(4^((I-1) MOD 3))
60 B%(I)=B%(I)+(INT(Q(I)/D(I)) AND 3)
70 NEXT
80 DEF SEG=&h4000
90 for i=0 to 132:poke i+256,B%(i+1):next
100 V=256:CALL V
