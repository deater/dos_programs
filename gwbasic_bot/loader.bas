0 DIM B%(200),Q(200),D(200)
1 A$="h:J]ph>:m>h:b]jFyhl:hJ:\pvdLWwhp:uC<WxuC<Wxi@:]gU:f;eI:W;IjW:wA\je:KyNZx;Y:yfl\puJef;nruLLntuntuJPrryZu;Xktf<:::::I::;<=U::>BFb::;<==HMFrwJ>fat:G:A^N=:JDFZKOCZLFP]]akSfAs?:A:?s"
2 FOR I=1 TO 132
3 B%(I)=(ASC(MID$(A$,I,1))-58)*4
4 Q(I)=((ASC(MID$(A$,133+(I-2)/3,1))-58))
5 D(I)=(4^((I-1) MOD 3))
6 B%(I)=B%(I)+(INT(Q(I)/D(I)) AND 3)
7 NEXT
35 DEF SEG=&h4000
40 for i=0 to 132:poke i+256,B%(i+1):next
70 V=256:CALL V
