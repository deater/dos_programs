1 DEF SEG=16384:DEF FN P(X)=ASC(MID$(A$,X,1))-58
2 A$="h:J]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^J=:JDFZKOCZLFP]]akSfAs?:A:?s"
3 FOR I=1 TO 132
4 POKE I-1,FNP(I)*4+(INT( FNP(133+(I-2)/3) / (4^((I-1) MOD 3)) ) AND 3)
5 NEXT:CALL V
