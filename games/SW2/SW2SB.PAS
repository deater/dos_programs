program Space_War_II_The_Fight_For_Earth;
uses cmftool,graph,loadsav,crt;

{$I c:\pascal\sw2close.pas}
{$M 16384,0,65535}

type screentype = array [0..3999] of byte;

var i,ix,gd,gm,ship1x,ship2x,ship2y,ship1y,oldship10x,oldship10y,
    oldship11x,oldship11y:integer;
    oldship20x,oldship21y,oldship21x,oldship20y:integer;
    pagehidden,pageshown,sh1rotation,sh2rotation:byte;

    star,tempswap:pointer;
    soundblasterinuse,stardefinedyet,cloakon,tempcondition:boolean;
    tempch,command:char;
    screen:screentype absolute $B800:0000;
    ship1:    array[0..15] of pointer;
    ship1rev: array[0..15] of pointer;
    ship2:    array[0..15] of pointer;
    ship2rev: array[0..15] of pointer;
    p0ship1background:pointer;
    p1ship1background:pointer;
    p0ship2Background:pointer;
    p1ship2background:pointer;
    sh1xspeed,sh1yspeed,sh2xspeed,sh2yspeed:real;

   Check      : BOOLEAN;
   SongName   : String;
   SongBuffer : CMFDataTyp;

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

PROCEDURE TextNumError;
{* INPUT   : None; data comes from CMFErrStat global variable
 * OUTPUT  : None
 * PURPOSE : Displays SB error as text, including error number. }
BEGIN
   Write(' Error #',CMFErrStat:3,': ');
   PrintCMFErrMessage;
   WriteLn;
   Halt(CMFErrStat);
   END;

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
procedure HelpScreen;
begin
  clearviewport;
  setcolor(4);
  settextstyle(0,0,0);
  outtextxy(0,0,'               S   P   A   C   E   W   A   R       I   I   I');
  {outtext('');
  outtext('');}
  setcolor(15);
  outtextxy(0,32,'  Player 1 Controls:                           Player 2 Controls:');
  {outtext('');}
  outtextxy(0,48,'  ษอออออออออหอออออออออหอออออออออป              ษอออออออออหอออออออออหอออออออออป');
  outtextxy(0,56,'  บ    Q    บ    W    บ    E    บ              บ    7    บ    8    บ    9    บ');
  outtextxy(0,64,'  บ         บ         บ         บ              บ         บ         บ         บ');
  outtextxy(0,72,'  บ  Laser  บ  Cloak  บ Missile บ              บ  Laser  บ  Cloak  บ Missile บ');
  outtextxy(0,80,'  ฬอออออออออฮอออออออออฮอออออออออน              ฬอออออออออฮอออออออออฮอออออออออน');
  outtextxy(0,88,'  บ    A    บ    S    บ    D    บ              บ    4    บ    5    บ    6    บ');
  outtextxy(0,96,'  บ      <ฤฟบ         บฺฤ>      บ              บ      <ฤฟบ         บฺฤ>      บ');
  outtextxy(0,104,'  บ Rotateฤูบ Forward บภฤRotate บ              บ Rotateฤูบ Forward บภฤRotate บ');
  outtextxy(0,112,'  ฬอออออออออฮอออออออออฮอออออออออน              ฬอออออออออฮอออออออออฮอออออออออน');
  outtextxy(0,120,'  บ    Z    บ    X    บ    C    บ              บ    1    บ    2    บ    3    บ');
  outtextxy(0,128,'  บ         บ         บ         บ              บ         บ         บ         บ');
  outtextxy(0,136,'  บ Energy  บ  Warp   บ Shields บ              บ Energy  บ  Warp   บ Shields บ');
  outtextxy(0,144,'  ศอออออออออสอออออออออสอออออออออผ              ศอออออออออสอออออออออสอออออออออผ');
  readln;






end;



begin
   soundblasterinuse:=false;
   clrscr;  writeln('Press Enter to Play With SoundBlaster music');
            writeln('Press any other key for regular startup');
            writeln;
            repeat until keypressed;
            tempch:=readkey;
            if tempch=#13 then begin;
               soundblasterinuse:=true;
               writeln;
               writeln('Please Enter name of CMF file...Enter="SOUND1.cmf"');
               readln(songname);
               if songname='' then songname:='SOUND1.cmf';
{ Displays error if SBFMDRV driver has not been installed }
   IF Not (CMFDriverInstalled) THEN TextNumError;
{ If no song name is included with command line parameters,
  program searches for the default name (here STARFM.CMF). }


{ Load song file }
   Check := CMFGetSongBuffer(SongBuffer,SongName);
   IF NOT(Check) THEN TextNumError;
{ CMFSetTransposeOfs() controls transposition down or up of the loaded song
  (positive values transpose up, negative values transpose down). The value
  0 plays the loaded song in its original key. }
   CMFSetTransposeOfs(0); { Experiment with this value }
{ Play song }
   Check := CMFPlaySong(SongBuffer);
   IF NOT(Check) THEN TextNumError;

   end;

  stardefinedyet:=false;
  sh1rotation:=0;
  sh2rotation:=0;
  sh1xspeed:=0;
  sh2xspeed:=0;
  sh2yspeed:=0;
  sh1yspeed:=0;
  randomize;
  gd:=ega; gm:=egahi;
  initgraph(gd,gm,'');
  getmem(star,imagesize(0,0,4,4));
  getmem(p0ship1background,imagesize(0,0,23,21));
  getmem(p1ship1background,imagesize(0,0,23,21));
  getmem(p0ship2background,imagesize(0,0,23,21));
  getmem(p1ship2background,imagesize(0,0,23,21));
  getmem(tempswap,imagesize(0,0,9,9));
  for i:=0 to 15 do getmem(ship1[i],imagesize(0,0,23,21));
  for i:=0 to 15 do getmem(ship1rev[i],imagesize(0,0,23,21));
  for i:=0 to 15 do getmem(ship2[i],imagesize(0,0,23,21));
  for i:=0 to 15 do getmem(ship2rev[i],imagesize(0,0,23,21));
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
    loadpicat('BUCKETS.SW3',51,80,1);
    for iX:=0 to 7 do begin
        I:=ix+8;
        getimage(76+(ix*35)-1,97,76+(ix*35)+22,118,ship2[i]^);
    end;
    for ix:=8 to 15 do begin
        i:=ix-8;
        getimage(76+(ix*35)-1,97,76+(ix*35)+22,118,ship2[i]^);
    end;

    loadpicat('BUCKETr.SW3',51,80,1);
    for iX:=0 to 7 do begin
        I:=ix+8;
        getimage(76+(ix*35)-1,97,76+(ix*35)+22,118,ship2rev[i]^);
    end;
    for ix:=8 to 15 do begin
        i:=ix-8;
        getimage(76+(ix*35)-1,97,76+(ix*35)+22,118,ship2rev[i]^);
    end;

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
  {shadowwriteat('Special Birthday Edition',6,14,10,150,2);
  shadowwriteat('For Jeff Warwick',6,14,50,175,2);}
  readln;
  helpscreen;




{*****End Opening*********************}
  setactivepage(0);
  setvisualpage(0);
  clearviewport;
  fillwithstars(150);
  ship1x:=100;
  ship2x:=540;
  sh1xspeed:=0;
  sh1yspeed:=0;
  sh2xspeed:=0;
  sh2yspeed:=0;
  ship1y:=100;
  ship2y:=250;
  sh1rotation:=0;
  sh2rotation:=7;
  pcopy(0,1);
  pagehidden:=0;
  pageshown:=1;
  setactivepage(1);
  setvisualpage(1);
  oldship10x:=100; oldship10y:=100;
  oldship11x:=100; oldship11y:=100;
  oldship20x:=540; oldship20y:=250;
  oldship21x:=540; oldship21y:=250;
  getimage(100,100,123,121,p1ship1background^);
  getimage(100,100,123,121,p0ship1background^);
  getimage(540,250,563,271,p1ship2background^);
  getimage(540,250,563,271,p0ship2background^);

  putimage(100,100,ship1[sh1rotation]^,orput);
  putimage(100,100,ship1rev[sh1rotation]^,andput);
  putimage(100,100,ship1[sh1rotation]^,xorput);
  putimage(100,100,ship1[sh1rotation]^,orput);
  putimage(540,250,ship2[sh2rotation]^,orput);
  putimage(540,250,ship2rev[sh2rotation]^,andput);
  putimage(540,250,ship2[sh2rotation]^,xorput);
  putimage(540,250,ship2[sh2rotation]^,orput);
  setactivepage(pagehidden);
  setvisualpage(pageshown);
  repeat
    if keypressed then command:=readkey
                  else command:='@';
    if pagehidden=0 then begin
           putimage(oldship10x,oldship10y,p1ship1background^,normalput);
           putimage(oldship20x,oldship20y,p1ship2background^,normalput);
           end
       else begin
           putimage(oldship11x,oldship11y,p0ship1background^,normalput);
           putimage(oldship21x,oldship21y,p0ship2background^,normalput);
       end;
    if upcase(command)='S' then begin
      sh1xspeed:=sh1xspeed+sin((sh1rotation/8)*pi);
      sh1yspeed:=sh1yspeed-cos((sh1rotation/8)*pi);
    end;
    if command='5' then begin
      sh2xspeed:=sh2xspeed+sin((sh2rotation/8)*pi);
      sh2yspeed:=sh2yspeed-cos((sh2rotation/8)*pi);
    end;
    if upcase(command)='D' then begin
       inc(sh1rotation); if sh1rotation>15 then sh1rotation:=0;
    end;
    if upcase(command)='6' then begin
       inc(sh2rotation); if sh2rotation>15 then sh2rotation:=0;
    end;
    if upcase(command)='A' then begin
       dec(sh1rotation); if sh1rotation>254 then sh1rotation:=15;
    end;
    if upcase(command)='4' then begin
       dec(sh2rotation); if sh2rotation>254 then sh2rotation:=15;
    end;

    ship1x:=ship1x+round(sh1xspeed); ship1y:=ship1y+round(sh1yspeed);
    if ship1y<0 then ship1y:=325; if ship1y>325 then ship1y:=0;
    if ship1x<0 then ship1x:=615;  if ship1x>615 then ship1x:=0;

    ship2x:=ship2x+round(sh2xspeed); ship2y:=ship2y+round(sh2yspeed);
    if ship2y<0 then ship2y:=325; if ship2y>325 then ship2y:=0;
    if ship2x<0 then ship2x:=615;  if ship2x>615 then ship2x:=0;


    if pagehidden=0 then begin
           getimage(ship1x,ship1y,ship1x+20,ship1y+20,p1ship1background^);
           getimage(ship2x,ship2y,ship2x+20,ship2y+20,p1ship2background^);
           end
           else begin
            getimage(ship1x,ship1y,ship1x+20,ship1y+20,p0ship1background^);
            getimage(ship2x,ship2y,ship2x+20,ship2y+20,p0ship2background^);
           end;
    putimage(ship1x,ship1y,ship1[sh1rotation]^,orput);
    putimage(ship1x,ship1y,ship1rev[sh1rotation]^,andput);
    putimage(ship1x,ship1y,ship1[sh1rotation]^,xorput);
    putimage(ship1x,ship1y,ship1[sh1rotation]^,orput);

    putimage(ship2x,ship2y,ship2[sh2rotation]^,orput);
    putimage(ship2x,ship2y,ship2rev[sh2rotation]^,andput);
    putimage(ship2x,ship2y,ship2[sh2rotation]^,xorput);
    putimage(ship2x,ship2y,ship2[sh2rotation]^,orput);
    if pagehidden=1 then begin
       pagehidden:=0;
       oldship11x:=ship1x;
       oldship11y:=ship1y;
       oldship21x:=ship2x;
       oldship21y:=ship2y;
    end
    else begin
       pagehidden:=1;
       oldship10x:=ship1x;
       oldship10y:=ship1y;
       oldship20x:=ship2x;
       oldship20y:=ship2y;
    end;
    if pageshown=1 then pageshown:=0
        else pageshown:=1;
    setactivepage(pagehidden);
    setvisualpage(pageshown);





  until upcase(command)='Q';
  closegraph;
  if soundblasterinuse=true then begin
     { Re-initialize driver }
      Check := CMFResetDriver;
      IF NOT(Check) THEN TextNumError;
      { Free song file memory }
      Check := CMFFreeSongBuffer(SongBuffer);
      IF NOT(Check) THEN TextNumError;
  end;


  move(imagedata,screen,4000);
  gotoxy(1,23);
end.