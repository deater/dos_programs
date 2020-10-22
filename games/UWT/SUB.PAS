unit sub;
interface
uses Fishes,Graph,Crt;
var
   x,y,size,counter,movedir,x1,y1,x2,x3,y2,y3,li:integer;
   sub1,sub2:pointer;
   ke:char;
procedure initsub;
implementation
procedure initsub;
var
 sub1,sub2:pointer;
begin
       setfillstyle(solidfill,8);
       setlinestyle(solidln,0,normwidth);
       setcolor(8);
       bar(115,106,144,115);
       bar(101,108,148,113);
       bar(101,104,102,117);
       bar(103,106,104,115);
       bar(127,100,138,105);
       setfillstyle(solidfill,12);
       setcolor(4);
       line(129,103,136,103);
       bar(142,111,143,112);
     counter:=0;
     li:=0;
       setlinestyle(solidln,0,normwidth);
     repeat
       setcolor(0);
         line(101,117+li,102,117+li);
         line(103,115+li,104,115+li);
         line(105,113+li,114,113+li);
         line(115,115+li,144,115+li);
         line(145,113+li,148,113+li);
         setlinestyle(userbitln,$AAAA,normwidth);
       li:=li-1;
       if li<-1 then setlinestyle(userbitln,$4444,normwidth);
         until li<-2;
     setlinestyle(userbitln,$AAAA,normwidth);
     li:=0;
     repeat
       setcolor(0);
         line(101,104+li,102,104+li);
         line(103,106+li,104,106+li);
         line(105,108+li,114,108+li);
         line(115,106+li,126,106+li);
         line(127,100+li,138,100+li);
         line(139,106+li,144,106+li);
         line(145,108+li,148,108+li);
         setlinestyle(userbitln,$4444,normwidth);
         li:=li+1;
         until li>1;
         setlinestyle(solidln,0,normwidth);
         line(101,104,101,117);
         line(127,100,127,105);
         line(138,100,138,105);
         setfillstyle(solidfill,1);
{sub 2}
       setfillstyle(solidfill,7);
       setlinestyle(solidln,0,normwidth);
       setcolor(1);
       bar(234,106,205,115);
       bar(248,108,201,113);
       bar(248,104,247,117);
       bar(246,106,245,115);
       bar(222,100,211,105);
       setfillstyle(solidfill,12);
       setcolor(4);
       line(220,103,213,103);
       bar(207,111,206,112);
     counter:=0;
     li:=0;
       setlinestyle(solidln,0,normwidth);
     repeat
       setcolor(8);
         line(248,117+li,247,117+li);
         line(246,115+li,245,115+li);
         line(244,113+li,235,113+li);
         line(234,115+li,205,115+li);
         line(204,113+li,201,113+li);
         setlinestyle(userbitln,$AAAA,normwidth);
       li:=li-1;
       if li<-1 then setlinestyle(userbitln,$4444,normwidth);
     until li<-2;
     setlinestyle(userbitln,$AAAA,normwidth);
     li:=0;
     repeat
       setcolor(8);
         line(248,104+li,247,104+li);
         line(246,106+li,245,106+li);
         line(244,108+li,235,108+li);
         line(234,106+li,223,106+li);
         line(222,100+li,211,100+li);
         line(210,106+li,205,106+li);
         line(204,108+li,201,108+li);
         setlinestyle(userbitln,$4444,normwidth);
         li:=li+1;
         until li>1;
         setlinestyle(solidln,0,normwidth);
         line(248,104,248,117);
         line(222,100,222,105);
         line(211,100,211,105);
         setfillstyle(solidfill,1);
         end;
       end.
