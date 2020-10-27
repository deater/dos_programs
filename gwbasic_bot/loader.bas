0 DIM Q(200),D(200)
1 DEF SEG=&h4000
5 DEF FN P(X)=ASC(MID$(A$,X,1))-58
10 A$="h:J]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^N=:JDFZKOCZLFP]]akSfAs?:A:?s"
20 FOR I=1 TO 132
30 Q(I)=FNP(133+(I-2)/3)
40 D(I)=(4^((I-1) MOD 3))
50 POKE I+255,FNP(I)*4+(INT(Q(I)/D(I)) AND 3)
60 NEXT
80 V=256:CALL V
