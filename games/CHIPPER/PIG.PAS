uses Graph,CRT;
var
   pig,carrot:pointer;
   x,y,x1,y1,grdrive,marker,grmode,color:integer;
   info,keyno:string;
   ch:char;
   ulx,uly,lrx,lry,size,I,j,k:word;
begin
   randomize;
   writeln('Which do you want to do');
   writeln('A. Demo');
   writeln('B. Random Pig Walk');
   readln(info);
   grdrive:=ega;
   grmode:=egahi;
   initgraph(grdrive,grmode,'');
   marker:=0;

{draw pig}
      setfillstyle(solidfill,6);
        bar(0,0,9,7);
      setfillstyle(solidfill,15);
        bar(10,0,19,7);
      setfillstyle(solidfill,6);
        bar(20,0,28,7);
      setfillstyle(solidfill,13);
        setcolor(13);
        bar(18,0,21,4);
        bar(3,7,6,7);
        bar(17,7,20,7);
        line(29,4,29,5);
      setfillstyle(solidfill,0);
        setcolor(0);
        line(26,0,29,3);
        line(27,0,29,2);
        line(28,0,29,1);
        putpixel(29,0,0);
        bar(24,1,25,2);
        putpixel(27,5,0);
        putpixel(28,6,0);
        putpixel(29,6,6);
        putpixel(0,0,0);
        putpixel(0,7,0);
        putpixel(29,5,0);
{getpig}
       ulx:=0;
       uly:=0;
       lrx:=30;
       lry:=8;
       size:=imagesize(ulx,uly,lrx,lry);
       getmem(pig,size);
       getimage(ulx,uly,lrx,lry,pig^);
       putimage(ulx,uly,pig^,xorput);
{draw carrot}
       setfillstyle(solidfill,12);
       bar(2,5,7,8);
       bar(3,9,6,12);
       bar(4,13,5,16);
       setcolor(6);
       line(2,7,7,7);
       line(3,10,6,10);
       line(4,13,5,13);
       line(4,16,5,16);
       setcolor(2);
       line(3,4,6,4);
       setcolor(10);
       line(2,1,4,3);
       line(7,1,5,3);
       putpixel(1,1,2);
       putpixel(8,1,2);
{getcarrot}
       ulx:=0;
       uly:=0;
       lrx:=9;
       lry:=17;
       size:=imagesize(ulx,uly,lrx,lry);
       getmem(carrot,size);
       getimage(ulx,uly,lrx,lry,carrot^);
       putimage(ulx,uly,carrot^,xorput);

{demo}
   if info ='a' then begin
       putimage(325,90,carrot^,xorput);
       for i:=200 to 600 do begin
          j:=i div 2;
          putimage(j,100,pig^,xorput);
          for k:=1 to 11500 do begin
          end;
          putimage(j,100,pig^,xorput);
       end;
          putimage(j,100,pig^,xorput);
          readln;
          end;
   if info='b' then begin
      repeat
      x:=random(600);
      y:=random(300);
      x1:=random(600);
      y1:=random(300);
      putimage(x,y,pig^,xorput);
      putimage(x1,y1,carrot^,xorput);
      delay(500);
      putimage(x,y,pig^,xorput);
      putimage(x1,y1,carrot^,xorput);
      until keypressed;
      end;
end.