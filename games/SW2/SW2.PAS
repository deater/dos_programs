program Space_War_II_The_Fight_For_Earth;
uses graph,loadsav,crt;
{$I c:\pascal\sw2close.pas}

type screentype = array [0..3999] of byte;

var i,gd,gm,ship1x,ship1y:integer;
    rotation:byte;
    star,tempswap:pointer;
    stardefinedyet,cloakon,tempcondition,page0active:boolean;
    tempch,command:char;
    screen:screentype absolute $B800:0000;
    ship1:    array[0..15] of pointer;
    ship1rev: array[0..15] of pointer;
    ship2:    array[0..15] of pointer;
    ship2rev: array[0..15] of pointer;
    ship1background:pointer;
    xspeed,yspeed:real;
procedure FillWithStars(howmany:integer);
var starx,stary,counter:integer;
begin
  if not(stardefinedyet) then begin
     starx:=random(635);
     stary:=random(344);
     putpixel(starx+2,stary,8);   putpixel(starx,stary+2,8);
     putpixel(starx+2,stary+4,8); putpixel(starx+4,stary+2,8);
     putpixel(starx+2,stary+1,7); putpixel(starx+1,stary+2,7);
     putpixel(starx+2,stary+3,7); putpixel(starx+3,stary+2,7);
     putpixel(starx+2,stary+2,15);
     getimage(starx,stary,starx+4,stary+4,star^);
     stardefinedyet:=true;
  end;
  for counter:=1 to howmany do begin
      starx:=random(634);
      stary:=random(344);
      putimage(starx,stary,star^,normalput);
  end;
end;

Procedure pcopy(page1,page2:word);
var xtemp,ytemp:integer;
begin
  for xtemp:=0 to 63 do begin
      for ytemp:=0 to 34 do begin
          setactivepage(page1);
          getimage(xtemp*10,ytemp*10,(xtemp*10)+9,(ytemp*10)+9,tempswap^);
          setactivepage(page2);
          putimage(xtemp*10,ytemp*10,tempswap^,normalput);
      end;
  end;
end;
procedure shadowWriteat(wstring:string;forecol,backcol,wx,wy,size:word);
var bcolor:integer;
begin
  setcolor(forecol);
  settextstyle(0,0,size);
  bcolor:=backcol-8;
  if bcolor<0 then bcolor:=8;
  setfillstyle(solidfill,bcolor);
  bar(wx+3,wy+3,(textwidth(wstring)+4)+wx,(textheight(wstring)+4)+wy);
  setfillstyle(solidfill,backcol);
  bar(wx-1,wy-1,textwidth(wstring)+wx,(textheight(wstring))+wy);
  outtextxy(wx,wy,wstring);
end;




begin
  page0active:=true;
  stardefinedyet:=false;
  rotation:=0;
  xspeed:=0;
  yspeed:=0;
  randomize;
  gd:=ega; gm:=egahi;
  initgraph(gd,gm,'');
  getmem(star,imagesize(0,0,4,4));
  getmem(ship1background,imagesize(0,0,23,21));
  getmem(tempswap,imagesize(0,0,9,9));
  for i:=0 to 15 do getmem(ship1[i],imagesize(0,0,23,21));
  for i:=0 to 15 do getmem(ship1rev[i],imagesize(0,0,23,21));
{********Do Opening*******}
  setactivepage(0);
  clearviewport;
  setvisualpage(0);
  setactivepage(1);
  loadpicat('SW3SHP1.SW3',51,80,1);
    for i:=0 to 15 do
        getimage(58+(i*35)-1,85,58+(i*35)+22,106,ship1[i]^);
    loadpicat('SW3sHP1r.SW3',51,80,1);
    for i:=0 to 15 do
                getimage(58+(i*35)-1,85,58+(i*35)+22,106,ship1rev[i]^);
  setactivepage(1);
  clearviewport;
  fillwithstars(100);
  loadpicat('EARTHPIC.SW3',100,60,1);
  setcolor(4); settextstyle(0,0,5);
    outtextxy(10,10,'SPACEWAR III:');
    setcolor(12); outtextxy(15,15,'SPACEWAR III:');
  setcolor(1); settextstyle(0,0,3);
    outtextxy(30,75,'The Fight For Earth');
    setcolor(9); outtextxy(32,77,'The Fight For Earth');
  setcolor(2); settextstyle(0,0,2);
    outtextxy(160,275,'By Vincent Weaver');
    setcolor(10); outtextxy(162,277,'By Vincent Weaver');
  setcolor(5); settextstyle(0,0,2);
    outtextxy(60,300,'Based On The MIT Game SPACEWAR');
    setcolor(13); outtextxy(62,302,'Based On The MIT Game SPACEWAR');
  setvisualpage(0);
  pcopy(1,0);
  repeat until keypressed;
  tempch:=readkey;
  clearviewport;
  fillwithstars(200);
  shadowwriteat('SPACEWAR III',12,15,20,20,4);
  shadowwriteat('Version 0.05',12,15,420,20,1);
  shadowwriteat('F1 - Help',12,9,20,320,1);
  shadowwriteat('F2 - Play Game',12,9,110,320,1);
  shadowwriteat('F3 - Options Menu',12,9,240,320,1);
  shadowwriteat('F4 - Toggle Sound',12,9,395,320,1);
  shadowwriteat('F5 - Quit',12,9,550,320,1);
  readln;




{*****End Opening*********************}
  page0active:=true;
  setactivepage(0);
  setvisualpage(0);
  clearviewport;
  fillwithstars(150);
  ship1x:=100;
  ship1y:=100;
  rotation:=0;
  pcopy(0,1);
  for i:=0 to 1 do begin
      setactivepage(i);
     getimage(100,100,123,121,ship1background^);
     putimage(100,100,ship1[rotation]^,orput);
     putimage(100,100,ship1rev[rotation]^,andput);
     putimage(100,100,ship1[rotation]^,xorput);
     putimage(100,100,ship1[rotation]^,orput);
  end;
  setactivepage(1);
  putimage(ship1x,ship1y,ship1background^,normalput);
  setactivepage(0);

  repeat
    if keypressed then command:=readkey
                  else command:='@';
                  if page0active=true then begin
       setactivepage(1);
       setvisualpage(0);
    end
    else begin
       setactivepage(0);
       setvisualpage(1);
    end;

    putimage(ship1x,ship1y,ship1background^,normalput);
    
    if upcase(command)='S' then begin
      xspeed:=xspeed+sin((rotation/8)*pi);
      yspeed:=yspeed-cos((rotation/8)*pi);
    end;
    if upcase(command)='D' then begin
       inc(rotation); if rotation>15 then rotation:=0;
    end;
    if upcase(command)='A' then begin
       dec(rotation); if rotation>254 then rotation:=15;
    end;

    ship1x:=ship1x+round(xspeed); ship1y:=ship1y+round(yspeed);
    if ship1y<0 then ship1y:=325; if ship1y>325 then ship1y:=0;
    if ship1x<0 then ship1x:=615;  if ship1x>615 then ship1x:=0;
    getimage(ship1x,ship1y,ship1x+20,ship1y+20,ship1background^);
    putimage(ship1x,ship1y,ship1[rotation]^,orput);
    putimage(ship1x,ship1y,ship1rev[rotation]^,andput);
    putimage(ship1x,ship1y,ship1[rotation]^,xorput);
    putimage(ship1x,ship1y,ship1[rotation]^,orput);
    page0active:=not(page0active);

  until upcase(command)='Q';
  closegraph;
  move(imagedata,screen,4000);
  gotoxy(1,23);
end.