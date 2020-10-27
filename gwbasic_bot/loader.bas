1DEF SEG=100:DEF FNP(X)=ASC(MID$(A$,X))-58:A$="hS:]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^J=:JDFZKOCZLFP]]akSfAs?:A:?s"
3FOR I=1 TO 132:POKE I-1,FNP(I)*4+(INT(FNP(133+(I-2)/3)/(4^((I-1) MOD 3))) AND 3):NEXT:CALL V
