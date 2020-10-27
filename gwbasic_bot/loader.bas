1 DEF SEG=&h4000:DEF FN P(X)=ASC(MID$(A$,X,1))-58
10 A$="h:J]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^N=:JDFZKOCZLFP]]akSfAs?:A:?s"
20 FOR I=1 TO 132
40 POKE I+255,FNP(I)*4+(INT( FNP(133+(I-2)/3) / (4^((I-1) MOD 3)) ) AND 3)
50 NEXT
60 V=256:CALL V
