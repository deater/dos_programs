program Space_War_II_The_Fight_For_Earth;
uses graph,loadsav,crt;

{$I c:\pascal\sw3close.pas}

type screentype = array [0..3999] of byte;

const maxspeed = 11;

var i,ix,gd,gm,ship1x,ship2x,ship2y,ship1y,oldship10x,oldship10y,
    oldship11x,oldship11y,owarpx,owarpy:integer;
    oldship20x,oldship21y,oldship21x,oldship20y:integer;
    laser1tox,laser1toy,laser2tox,laser2toy:integer;
    pagehidden,pageshown,sh1rotation,sh2rotation:byte;
    sh1shield,sh1energy,sh2shield,sh2energy:integer;
    tempxspeed,tempyspeed:real;

    star,tempswap,ship1torp,ship2torp:pointer;

    p1torp1back: array[0..7] of pointer;
    p0torp1back: array[0..7] of pointer;
    torp1out:    array[0..8] of boolean;
    torp1x:      array[0..7] of integer;
    torp1y:      array[0..7] of integer;
    torp1ticks:  array[0..7] of integer;
    oldtorp11x:  array[0..7] of integer;
    oldtorp11y:  array[0..7] of integer;
    oldtorp10x:  array[0..7] of integer;
    oldtorp10y:  array[0..7] of integer;
    p1torp2back: array[0..7] of pointer;
    p0torp2back: array[0..7] of pointer;
    explosion:   array[0..3] of pointer;
    torp2out:    array[0..8] of boolean;
    torp2x:      array[0..7] of integer;
    torp2y:      array[0..7] of integer;
    torp2ticks:  array[0..7] of integer;
    oldtorp21x:  array[0..7] of integer;
    oldtorp21y:  array[0..7] of integer;
    oldtorp20x:  array[0..7] of integer;
    oldtorp20y:  array[0..7] of integer;
    torp1pointer,torp2pointer,temptorp:word;
    soundblasterinuse,stardefinedyet,cloakon,tempcondition:boolean;
    tempch,command,titlech,titlech2:char;
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
    torp1xspeed:array[0..7] of real;
    torp1yspeed:array[0..7] of real;
    torp2xspeed:array[0..7] of real;
    torp2yspeed:array[0..7] of real;


label 100,200;

procedure numon(no,co:boolean);
  const
    capson=$40;
    numon=$20;
  var keyflag1:byte absolute $0040:$0017;
  begin
    if no=false then keyflag1:=keyflag1 and (not numon);
    if no=true then keyflag1:=keyflag1 or numon;
    if co=false then keyflag1:=keyflag1 and (not capson);
    if co=true then keyflag1:=keyflag1 or capson;
  end;

procedure doTorpedoes;
begin
  setcolor(15);
    line(3,2,3,4); line(2,3,4,3);
  setcolor(9);
    line(3,1,1,3); line(3,1,5,3);
    line(1,3,3,5); line(3,5,5,3);
  setcolor(1);
    line(3,0,0,3); line(3,0,6,3);
    line(0,3,3,6); line(6,3,3,6);
  getmem(ship1torp,imagesize(0,0,6,6));
  getmem(ship2torp,imagesize(0,0,6,6));
  for i:=0 to 7 do begin
      getmem(p0torp1back[i],imagesize(0,0,6,6));
      getmem(p1torp1back[i],imagesize(0,0,6,6));
      getmem(p0torp2back[i],imagesize(0,0,6,6));
      getmem(p1torp2back[i],imagesize(0,0,6,6));
  end;
  getimage(0,0,6,6,ship1torp^);
  setcolor(15);
    line(3,2,3,4); line(2,3,4,3);
  setcolor(12);
    line(3,1,1,3); line(3,1,5,3);
    line(1,3,3,5); line(3,5,5,3);
  setcolor(4);
    line(3,0,0,3); line(3,0,6,3);
    line(0,3,3,6); line(6,3,3,6);
  getmem(ship2torp,imagesize(0,0,6,6));
  getimage(0,0,6,6,ship2torp^);

end;
procedure FillWithStars(howmany:integer;fillbothpages:boolean);
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
      if fillbothpages then begin
         setactivepage(0);
         putimage(starx,stary,star^,normalput);
         setactivepage(1);
         putimage(starx,stary,star^,normalput);
      end
      else putimage(starx,stary,star^,normalput);
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

procedure DoStatusBar(setup:boolean);
begin
  if setup then begin
     setcolor(9);
    rectangle(0,319,639,349);
    line(208,319,208,349);
    line(432,319,432,349);
    line(320,319,320,329);
    rectangle(287,329,353,349);
      setcolor(15);
    settextstyle(0,0,1);
    outtextxy(5,323,'SHIELD:');
    outtextxy(5,335,'ENERGY:');
    outtextxy(437,323,'SHIELD:');
    outtextxy(437,335,'ENERGY:');
    setcolor(12);
    outtextxy(289,331,'Press F5');
    outtextxy(293,340,'To Quit');
  end;
    setcolor(0);
      line(64,327,204,327);
      line(64,339,204,339);
      line(490,327,630,327);
      line(490,339,630,339);
    setcolor(15);
      line(64,327,64+(sh1shield div 2),327);
      line(64,339,64+(sh1energy div 2),339);
      line(490,327,490+(sh2shield div 2),327);
      line(490,339,490+(sh2energy div 2),339);
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

procedure options_menu;
var optch:char;
begin
  clearviewport;
  setcolor(12);
  outtextxy(10,10,'Not many options yet avaiable');
  outtextxy(10,20,'I did have a CMF file playing in the background');
  outtextxy(10,30,'But it did not work too well.....');
  outtextxy(10,110,'More sound blaster stuff coming soon....');

  setcolor(11);
  outtextxy(12,130,'Due to lack of time and monetary support');
  outtextxy(12,140,'The completion of this prgram will be ');
  outtextxy(12,150,'delayed to maybe October or until I finish it.');
  outtextxy(12,170,'To see an explosion during the game type "T".');
  outtextxy(12,190,'Remember...I am 23-4108%oznet@tweekco.ness.com');
  outtextxy(12,210,'I''d appreciate any comments....Vince Weaver');
  outtextxy(12,220,'      Thanks....June 23, 1994  Age 16y 4m 10d');
  optch:='!';
  repeat
     optch:=readkey;
  until optch<>'!';


end;
procedure HelpScreen;
   procedure donames(st1,st2:string);
   begin
     textcolor(3);
     write(st1);
     textcolor(11);
     writeln(st2);
   end;
begin
  clearviewport;
  fillwithstars(200,false);
  setcolor(4);
  settextstyle(0,0,0);
  outtextxy(0,0,'               S   P   A   C   E   W   A   R       I   I   I');
  {outtext('');
  outtext('');}
  setcolor(7);
  outtextxy(0,32,'  Player 1 Controls:                           Player 2 Controls:');
  setcolor(15);
  {outtext('');}
  outtextxy(0,48,'  ษอออออออออหอออออออออหอออออออออป              ษอออออออออหอออออออออหอออออออออป');
  outtextxy(0,56,'  บ    Q    บ    W    บ    E    บ   Remember   บ    7    บ    8    บ    9    บ');
  outtextxy(0,64,'  บ         บ         บ         บ  Always Use  บ         บ         บ         บ');
  outtextxy(0,72,'  บ  Laser  บ  Cloak  บ Missile บ "F5" to Quit บ  Laser  บ  Cloak  บ Missile บ');
  outtextxy(0,80,'  ฬอออออออออฮอออออออออฮอออออออออน              ฬอออออออออฮอออออออออฮอออออออออน');
  outtextxy(0,88,'  บ    A    บ    S    บ    D    บ              บ    4    บ    5    บ    6    บ');
  outtextxy(0,96,'  บ      <ฤฟบ         บฺฤ>      บ              บ      <ฤฟบ         บฺฤ>      บ');
  outtextxy(0,104,'  บ Rotateฤูบ Forward บภฤRotate บ              บ Rotateฤูบ Forward บภฤRotate บ');
  outtextxy(0,112,'  ฬอออออออออฮอออออออออฮอออออออออน              ฬอออออออออฮอออออออออฮอออออออออน');
  outtextxy(0,120,'  บ    Z    บ    X    บ    C    บ              บ    1    บ    2    บ    3    บ');
  outtextxy(0,128,'  บ         บ         บ         บ              บ         บ         บ         บ');
  outtextxy(0,136,'  บ Energy  บ  Warp   บ Shields บ              บ Energy  บ  Warp   บ Shields บ');
  outtextxy(0,144,'  ศอออออออออสอออออออออสอออออออออผ              ศอออออออออสอออออออออสอออออออออผ');
  setcolor(12);
  outtextxy(0,176,'Your Mission:');
  setcolor(9);
  outtextxy(0,184,'     Use Your Lasers and Missiles to Destroy Your Opponent.');
  outtextxy(0,192,'     Use Your Manuevering and Warp Capabilities to Dodge Attack.');
  outtextxy(0,200,'     And Most Of All, Transfer Your Energy To Shields and Back wisely.');
  setcolor(12);
  outtextxy(0,216,'Energy Considerations:');
  setcolor(9);
  outtextxy(0,224,'     Missiles:    Consume 1 Unit Of Energy, But Cause 4 Units of Damage');
  outtextxy(0,232,'     Lasers:      Consume 1 Unit Of Energy, But Cause 2 Units of Damage');
  outtextxy(0,240,'     Engines:     Consume 1 Unit Of Energy every Rocket Burn');
  outtextxy(0,248,'     Cloak:       Consume 1 Unit Of Energy Per Second While Engaged');
  outtextxy(0,256,'     Warp:        Consume 8 Units Of Energy To Randomly Relocate Yourself');
  setcolor(10);
  outtextxy(0,272,'Have Fun....Play Fair....And Don''t Forget To Register Your Favorite Game...Spacewar!!');
  setcolor(7);
  outtextxy(0,300,'Press Enter To Continue');

  readln;
  clearviewport;
  directvideo:=false;
  textcolor(9);
  gotoxy(1,1);
  writeln('              S   P   A   C   E   W   A   R        I   I   I');
  writeln;
  textcolor(11);
  write('                     A ');
  textcolor(4); write('฿Û');
  textbackground(1); write('฿ ');
  textcolor(2); write('฿Û฿ ฿Û');
  textbackground(0); write('฿ ');
  textcolor(11); writeln('Software Production');
  writeln;
  writeln;
  writeln('             Written, Coded, Graphics And Sound by Vincent Weaver');
  writeln;
  textcolor(12);
  writeln('Special Thanks To The Following:');
  donames('   Nick Attansio    ','For His Amazing Sense Of Humor');
  donames('   Douglas Adams    ','For His Most Inspiring Books (THGTTG: All 5 in Trilogy)');
  donames('   Jeff Warwick     ','For His Graphics Expertise');
  donames('   Axel Stolz       ','For His Very Good Sound Blaster Book');
  donames('   Tom Swan         ','For His Masterfull Book On Turbo Pascal');
  donames('   Jason Grimm      ','For His Wonderfull BBS (UTOPIA 410-557-0868)');
  donames('   Paul Stone       ','For The General Concept of the Game');
  donames('   John Clemens     ','For His C Knowledge');
  donames('   Steve Dorsch     ','For His Understanding Nature');
  donames('   Bill Seiler      ','For The Original Shareware Spacewar');
  donames('   Gene Rodenbury   ','For Star Trek And STTNG');
  donames('   Anyone I Missed  ','For The Best Are Sometimes Overlooked');
  donames('   Others At JC     ','For Their Understanding and Support');
  writeln;
  textcolor(10);
  writeln('For Registering Info See The Closing Screen After You Quit The Game!!!!!!!!!!');
  directvideo:=true;
  readln;
end;

procedure explode(ship:integer;endgame:boolean);
begin
  for i:=0 to 3 do begin
    putimage(ship1x,ship1y,explosion[i]^,orput);
    putimage(ship1x,ship1y,explosion[i]^,andput);
    putimage(ship1x,ship1y,explosion[i]^,xorput);
    putimage(ship1x,ship1y,explosion[i]^,orput);
    delay(50);
  end;
  outtextxy(20,20,'Wow...soon you can blow up after being hit too..press enter');
  readln;
end;



begin
 {*******SET UP VARIABLES+GRAPHICS*******}
  stardefinedyet:=false;
  randomize;
  numon(true,false);
  gd:=ega; gm:=egahi;
  initgraph(gd,gm,'');
  cleardevice;
  settextstyle(1,0,0);
  setcolor(1);
  outtextxy(10,10,'Spacewar v1.35  FIRST WORKING VERSION');
  setcolor(9);
  outtextxy(12,12,'Spacewar v1.35  FIRST WORKING VERSION');
  setcolor(4);
  outtextxy(10,50,'Loading PaintPro Graphics...Please Stand By');
  setcolor(12);
  outtextxy(12,52,'Loading PaintPro Graphics...Please Stand By');
  setcolor(11);
  outtextxy(12,100,'Due to lack of time and monetary support');
  outtextxy(12,110,'The completion of this prgram will be ');
  outtextxy(12,120,'delayed to maybe October or until I finish it.');
  outtextxy(12,140,'To see an explosion during the game type "T".');
  outtextxy(12,160,'Remember...I am 23-4108%oznet@tweekco.ness.com');
  outtextxy(12,180,'I''d appreciate any comments....Vince Weaver');
  outtextxy(12,190,'      Thanks....June 23, 1994  Age 16y 4m 10d');

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
  for i:=0 to 4 do getmem(explosion[i],imagesize(59,109,78,124));
{********Do Opening*******}
  setactivepage(0);
  {clearviewport;}
  setvisualpage(0);
  setactivepage(1);
  dotorpedoes;
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
    loadpicat('explos.sw3',50,100,1);
    getimage(59,109,78,124,explosion[0]^);
    getimage(85,109,104,124,explosion[1]^);
    getimage(116,109,135,124,explosion[2]^);
    getimage(146,109,165,124,explosion[3]^);

    setactivepage(1);
  clearviewport;
  fillwithstars(100,false);
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
  {*****Command Menu*****}
100:
  setvisualpage(0);
  setactivepage(0);
  clearviewport;
  fillwithstars(200,false);
  shadowwriteat('SPACEWAR III',12,15,20,20,4);
  shadowwriteat('Version 1.00',12,15,420,20,1);
  shadowwriteat('F1 - Help',12,9,20,320,1);
  shadowwriteat('F2 - Play Game',12,9,110,320,1);
  shadowwriteat('F3 - Options Menu',12,9,240,320,1);
  shadowwriteat('F4 - Toggle Sound',12,9,395,320,1);
  shadowwriteat('F5 - Quit',12,9,550,320,1);
  {shadowwriteat('Special Birthday Edition',6,14,10,150,2);
  shadowwriteat('For Jeff Warwick',6,14,50,175,2);}
  titlech:='“';
  titlech2:='“';
  repeat
    repeat until keypressed;
    titlech:=readkey;
    if titlech=chr(0) then titlech2:=readkey;
  until (ord(titlech2)>58) and (ord(titlech2)<64);
  if titlech2=chr(59) then helpscreen;
  if titlech2=chr(59) then goto 100;
  if titlech2=chr(61) then options_menu;
  if titlech2=chr(61) then goto 100;
  if titlech2=chr(63) then goto 200;



{*****End Opening*********************}
{*****Begin Actual Game***************}
  setactivepage(0);
  setvisualpage(0);
  sh1shield:=100;
  sh1energy:=250;
  sh2shield:=100;
  sh2energy:=250;
  clearviewport;
  setactivepage(1);
  clearviewport;
  setactivepage(1);
  fillwithstars(150,true);
  dostatusbar(true);
  setactivepage(0);
  dostatusbar(true);
  setactivepage(1);
{****Re-Initialize Variables so no garbage assigned*****}
  sh1rotation:=0;
  torp1pointer:=0;
  torp2pointer:=0;
  for i:=0 to 8 do torp1out[i]:=false;
  for i:=0 to 8 do torp2out[i]:=false;

  sh1xspeed:=0;
  sh2xspeed:=0;
  sh2yspeed:=0;
  sh1yspeed:=0;
  ship1x:=100;
  ship2x:=540;
  ship1y:=100;
  ship2y:=250;
  sh2rotation:=8;
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
{*****Done Setup.....Main Game Loop*********}
  repeat
    titlech2:='@';
    if keypressed then command:=readkey
                  else command:='@';
    if command=chr(0) then titlech2:=readkey;

    if pagehidden=0 then begin
           putimage(oldship10x,oldship10y,p1ship1background^,normalput);
           putimage(oldship20x,oldship20y,p1ship2background^,normalput);
           for i:=0 to 7 do if torp1out[i] then
               putimage(oldtorp10x[i],oldtorp10y[i],p1torp1back[i]^,normalput);
           for i:=0 to 7 do if torp2out[i] then
               putimage(oldtorp20x[i],oldtorp20y[i],p1torp2back[i]^,normalput);
           end
       else begin
           putimage(oldship11x,oldship11y,p0ship1background^,normalput);
           putimage(oldship21x,oldship21y,p0ship2background^,normalput);
           for i:=0 to 7 do if torp1out[i] then
               putimage(oldtorp11x[i],oldtorp11y[i],p0torp1back[i]^,normalput);
           for i:=0 to 7 do if torp2out[i] then
               putimage(oldtorp21x[i],oldtorp21y[i],p0torp2back[i]^,normalput);
       end;
    dostatusbar(false);
    if upcase(command)='S' then begin
       if (sh1energy>0)  then begin
          tempxspeed:=sh1xspeed+sin((sh1rotation/8)*pi);
          tempyspeed:=sh1yspeed-cos((sh1rotation/8)*pi);
          if (abs(tempxspeed)<maxspeed) then sh1xspeed:=tempxspeed;
          if (abs(tempyspeed)<maxspeed) then sh1yspeed:=tempyspeed;
          if (tempxspeed=sh1xspeed) and (tempyspeed=sh1yspeed) then dec(sh1energy,1);
       end;
    end;
    if command='5' then begin
      if sh2energy>0 then begin
          tempxspeed:=sh2xspeed+sin((sh2rotation/8)*pi);
          tempyspeed:=sh2yspeed-cos((sh2rotation/8)*pi);
          if (abs(tempxspeed)<maxspeed) then sh2xspeed:=tempxspeed;
          if (abs(tempyspeed)<maxspeed) then sh2yspeed:=tempyspeed;
          if (tempxspeed=sh2xspeed) and (tempyspeed=sh2yspeed) then dec(sh2energy,1);
       end;
    end;
    if upcase(command)='D' then begin
       inc(sh1rotation); if sh1rotation>15 then sh1rotation:=0;
    end;
    if upcase(command)='Z' then begin {Shield>energy}
       if sh1energy<120 then begin
          if sh1shield<5 then begin
             sh1energy:=sh1energy+sh1shield;
          end
          else begin
             inc(sh1energy,5);
             dec(sh1shield,5);
          end;
       end;
    end;
    if upcase(command)='C' then begin {Energy>Shield}
       if sh1shield<120 then begin
          if sh1energy<5 then begin
             sh1shield:=sh1shield+sh1energy;
          end
          else begin
             dec(sh1energy,5);
             inc(sh1shield,5);
          end;
       end;
    end;
    if upcase(command)='E' then begin
       if not(torp1pointer=8) then begin
          temptorp:=torp1pointer;
          torp1out[torp1pointer]:=true;
          torp1pointer:=0;
          repeat inc(torp1pointer) until torp1out[torp1pointer]=false;
             torp1x[temptorp]:=ship1x+9;
             torp1y[temptorp]:=ship1y;
             oldtorp10x[temptorp]:=torp1x[temptorp];
             oldtorp10y[temptorp]:=torp1y[temptorp];
             oldtorp11x[temptorp]:=torp1x[temptorp];
             oldtorp11y[temptorp]:=torp1y[temptorp];
             torp1xspeed[temptorp]:=0;
             torp1yspeed[temptorp]:=0;
          torp1xspeed[temptorp]:=1.5*((sh1xspeed)+sin((sh1rotation/8)*pi));
          torp1yspeed[temptorp]:=1.5*((sh1yspeed)-cos((sh1rotation/8)*pi));
           if pagehidden=1 then
              getimage(torp1x[temptorp],torp1y[temptorp],torp1x[temptorp]+6,torp1y[temptorp]+6,p0torp1back[temptorp]^)
           else
              getimage(torp1x[temptorp],torp1y[temptorp],torp1x[temptorp]+6,torp1y[temptorp]+6,p1torp1back[temptorp]^);

      end;

    end;

    if command='9' then begin
       if not(torp2pointer=8) then begin
          temptorp:=torp2pointer;
          torp2out[torp2pointer]:=true;
          torp2pointer:=0;
          repeat inc(torp2pointer) until torp2out[torp2pointer]=false;
             torp2x[temptorp]:=ship2x+9;
             torp2y[temptorp]:=ship2y;
             oldtorp20x[temptorp]:=torp2x[temptorp];
             oldtorp20y[temptorp]:=torp2y[temptorp];
             oldtorp21x[temptorp]:=torp2x[temptorp];
             oldtorp21y[temptorp]:=torp2y[temptorp];
             torp2xspeed[temptorp]:=0;
             torp2yspeed[temptorp]:=0;
          torp2xspeed[temptorp]:=1.5*((sh2xspeed)+sin((sh2rotation/8)*pi));
          torp2yspeed[temptorp]:=1.5*((sh2yspeed)-cos((sh2rotation/8)*pi));
           if pagehidden=1 then
              getimage(torp2x[temptorp],torp2y[temptorp],torp2x[temptorp]+6,torp2y[temptorp]+6,p0torp2back[temptorp]^)
           else
              getimage(torp2x[temptorp],torp2y[temptorp],torp2x[temptorp]+6,torp2y[temptorp]+6,p1torp2back[temptorp]^);

      end;

    end;
    if upcase(command)='Q' then begin
       if sh1energy>0 then begin
          laser1tox:=ship1x+round((50*sin((sh1rotation/8)*pi)));
          laser1toy:=ship1y-round((50*cos((sh1rotation/8)*pi)));
          setwritemode(xorput);
          setcolor(2);
          line(ship1x+10,ship1y+10,laser1tox+10,laser1toy+10);
          setwritemode(normalput);

        dec(sh1energy,1);
      end;

    end;
    if command='7' then begin
       if sh2energy>0 then begin
          laser2tox:=ship2x+round((50*sin((sh2rotation/8)*pi)));
          laser2toy:=ship2y-round((50*cos((sh2rotation/8)*pi)));
          setwritemode(xorput);
          setcolor(4);
          line(ship2x+10,ship2y+10,laser2tox+10,laser2toy+10);
          setwritemode(normalput);

        dec(sh2energy,1);
      end;

    end;
    if command='1' then begin {Shield>energy}
       if sh2energy<120 then begin
          if sh2shield<5 then begin
             sh2energy:=sh2energy+sh2shield;
          end
          else begin
             inc(sh2energy,5);
             dec(sh2shield,5);
          end;
       end;
    end;
    if command='3' then begin {Energy>Shield}
       if sh2shield<120 then begin
          if sh2energy<5 then begin
             sh2shield:=sh2shield+sh2energy;
          end
          else begin
             dec(sh2energy,5);
             inc(sh2shield,5);
          end;
       end;
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
    for i:=0 to 7 do begin
     if torp1out[i] then begin
       torp1x[i]:=torp1x[i]+round(torp1xspeed[i]);
       torp1y[i]:=torp1y[i]+round(torp1yspeed[i]);
       if torp1y[i]<0 then torp1y[i]:=325; if torp1y[i]>325 then torp1y[i]:=0;
       if torp1x[i]<0 then torp1x[i]:=615; if torp1x[i]>615 then torp1x[i]:=0;
       inc(torp1ticks[i]);
       if torp1ticks[i]>500 then begin
          torp1ticks[i]:=0;
          torp1out[i]:=false;
          torp1pointer:=i;
          if pagehidden=0 then begin
             putimage(oldtorp10x[i],oldtorp10y[i],p1torp1back[i]^,normalput);
             setactivepage(1);
             putimage(oldtorp11x[i],oldtorp11y[i],p0torp1back[i]^,normalput);
             setactivepage(0);
          end;
          if pagehidden=1 then begin
            putimage(oldtorp10x[i],oldtorp10y[i],p1torp1back[i]^,normalput);
            setactivepage(0);
            putimage(oldtorp11x[i],oldtorp11y[i],p0torp1back[i]^,normalput);
            setactivepage(1);
          end;


       end;
     end;
    end;

    for i:=0 to 7 do begin
     if torp2out[i] then begin
       torp2x[i]:=torp2x[i]+round(torp2xspeed[i]);
       torp2y[i]:=torp2y[i]+round(torp2yspeed[i]);
       if torp2y[i]<0 then torp2y[i]:=325; if torp2y[i]>325 then torp2y[i]:=0;
       if torp2x[i]<0 then torp2x[i]:=615; if torp2x[i]>615 then torp2x[i]:=0;
       inc(torp2ticks[i]);
       if torp2ticks[i]>500 then begin
          torp2ticks[i]:=0;
          torp2out[i]:=false;
          torp2pointer:=i;
          if pagehidden=0 then begin
             putimage(oldtorp20x[i],oldtorp20y[i],p1torp2back[i]^,normalput);
             setactivepage(1);
             putimage(oldtorp21x[i],oldtorp21y[i],p0torp2back[i]^,normalput);
             setactivepage(0);
          end;
          if pagehidden=1 then begin
            putimage(oldtorp20x[i],oldtorp20y[i],p1torp2back[i]^,normalput);
            setactivepage(0);
            putimage(oldtorp21x[i],oldtorp21y[i],p0torp2back[i]^,normalput);
            setactivepage(1);
          end;


       end;
     end;
    end;


    ship1x:=ship1x+round(sh1xspeed); ship1y:=ship1y+round(sh1yspeed);
    if ship1y<0 then ship1y:=325; if ship1y>325 then ship1y:=0;
    if ship1x<0 then ship1x:=615;  if ship1x>615 then ship1x:=0;

    ship2x:=ship2x+round(sh2xspeed); ship2y:=ship2y+round(sh2yspeed);
    if ship2y<0 then ship2y:=325; if ship2y>325 then ship2y:=0;
    if ship2x<0 then ship2x:=615;  if ship2x>615 then ship2x:=0;

    if upcase(command)='X' then begin
       sh1rotation:=random(16);
       sh1xspeed:=0;  sh1yspeed:=0;
       owarpx:=ship1x;
       owarpy:=ship1y;
       ship1x:=random(600)+20;
       ship1y:=random(300)+20;
       {setcolor(14);
         setwritemode(xorput);
         line(owarpx,owarpy,ship1x,ship1y);
         line(owarpx+10,owarpy+10,ship1x+10,ship1y+10);
         line(owarpx,owarpy,ship1x,ship1y);
         line(owarpx+10,owarpy+10,ship1x+10,ship1y+10);
        }

    end;
    if command='2' then begin
       sh2rotation:=random(16);
       sh2xspeed:=0;  sh2yspeed:=0;
       ship2x:=random(600)+20;
       ship2y:=random(300)+20;

    end;
    

    if pagehidden=0 then begin
           getimage(ship1x,ship1y,ship1x+20,ship1y+20,p1ship1background^);
           getimage(ship2x,ship2y,ship2x+20,ship2y+20,p1ship2background^);
           for i:=0 to 7 do
             if torp1out[i] then getimage(torp1x[i],torp1y[i],torp1x[i]+6,torp1y[i]+6,p1torp1back[i]^);
           for i:=0 to 7 do
             if torp2out[i] then getimage(torp2x[i],torp2y[i],torp2x[i]+6,torp2y[i]+6,p1torp2back[i]^);
           end
           else begin
            getimage(ship1x,ship1y,ship1x+20,ship1y+20,p0ship1background^);
            getimage(ship2x,ship2y,ship2x+20,ship2y+20,p0ship2background^);
            for i:=0 to 7 do
              if torp1out[i] then getimage(torp1x[i],torp1y[i],torp1x[i]+6,torp1y[i]+6,p0torp1back[i]^);
            for i:=0 to 7 do
              if torp2out[i] then getimage(torp2x[i],torp2y[i],torp2x[i]+6,torp2y[i]+6,p0torp2back[i]^);
           end;
    for i:=0 to 7 do begin
     if torp1out[i] then begin
        putimage(torp1x[i],torp1y[i],ship1torp^,orput);
        putimage(torp1x[i],torp1y[i],ship1torp^,andput);
        putimage(torp1x[i],torp1y[i],ship1torp^,xorput);
        putimage(torp1x[i],torp1y[i],ship1torp^,orput);
     end;
     if torp2out[i] then begin
        putimage(torp2x[i],torp2y[i],ship2torp^,orput);
        putimage(torp2x[i],torp2y[i],ship2torp^,andput);
        putimage(torp2x[i],torp2y[i],ship2torp^,xorput);
        putimage(torp2x[i],torp2y[i],ship2torp^,orput);
     end;
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
       for i:=0 to 7 do begin
         if torp1out[i] then begin
            oldtorp11x[i]:=torp1x[i];
            oldtorp11y[i]:=torp1y[i];
         end;
         if torp2out[i] then begin
            oldtorp21x[i]:=torp2x[i];
            oldtorp21y[i]:=torp2y[i];
         end;
       end;
    end
    else begin
       pagehidden:=1;
       oldship10x:=ship1x;
       oldship10y:=ship1y;
       oldship20x:=ship2x;
       oldship20y:=ship2y;
       for i:=0 to 7 do begin
         if torp1out[i] then begin
            oldtorp10x[i]:=torp1x[i];
            oldtorp10y[i]:=torp1y[i];
         end;
         if torp2out[i] then begin
            oldtorp20x[i]:=torp2x[i];
            oldtorp20y[i]:=torp2y[i];
         end;
       end;
    end;
    if pageshown=1 then pageshown:=0
        else pageshown:=1;
    setactivepage(pagehidden);
    setvisualpage(pageshown);


  if upcase(command)='T' then begin
       setactivepage(pageshown);
       explode(1,true);
       titlech2:=chr(63);
    end;
  until titlech2=chr(63);
  if titlech2=chr(63) then goto 100;

200:
  closegraph;
  move(imagedata,screen,4000);
  gotoxy(1,23);
end.