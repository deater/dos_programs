program christmas;
uses crt,graph,picload;
var gd,gm,santax,delayspeed:integer;
    santa,block:pointer;
    ds:string[5];
begin
  delayspeed:=50;
  if paramcount>0 then begin
     ds:=paramstr(1);
     val(ds,delayspeed,delayspeed);
  end;
  santax:=3;
  gd:=ega;
  gm:=egahi;
  initgraph(gd,gm,'');
  loadpic('night.pro',0);
  loadpicat('santa.pro',0,275,0);
  getmem(santa,imagesize(10,275,80,300));
  getimage(10,275,80,300,santa^);

  setfillstyle(solidfill,15);
  bar(0,275,80,300);
  getmem(block,imagesize(10,275,80,300));
  getimage(10,275,80,300,block^);
  setfillstyle(solidfill,0);
  bar(0,275,80,300);
  putimage(3,50,block^,andput);
  putimage(3,50,santa^,xorput);
  repeat
    if santax<520 then begin
      putimage(santax,50,santa^,xorput);
      santax:=santax+10;
      putimage(santax,50,block^,andput);
      putimage(santax,50,santa^,xorput);
    end;
    if santax=523 then begin
        putimage(santax,50,santa^,xorput);
        settextstyle(3,0,5);
        setcolor(12);
        outtextxy(5,199,'Happy Holidays');
        santax:=534;
    end;


    setpalette(1,15);
    delay(delayspeed);
    setpalette(1,7);
    delay(delayspeed);
    setpalette(1,8);
    delay(delayspeed);
    setpalette(1,0);
    delay(delayspeed);
  until keypressed;
  closegraph;
end.