1DEF SEG=100:DEF FNP(X)=ASC(MID$(A$,X))-58:A$="hS:]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^J=:JDFZKOCZLFP]]akSfAs?:A:?s"
3FOR I=0 TO 131:POKE I,FNP(I+1)*4+(INT(FNP(133+(I-1)/3)/(4^(I MOD 3))) AND 3):NEXT:CALL V
