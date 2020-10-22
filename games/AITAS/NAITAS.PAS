program The_New_Adventures_In_Time_And_Space_AITAS;
uses inputter,dos,graph,picload,crt;
{$I c:\pascal\aitas\register.pas}

type screentype = array [0..3999] of byte;

var menupos,oldmenupos,i,graphdriver,graphmode,timedelay,shipy,shipyadd:integer;
    menuline:pointer;
    ch,command,tempch:char;
    viewport:viewporttype;
    var screen:screentype absolute $B800:0000;
    menucommand:string[10];
    gd,gm,ship1x,ship1y:integer;
    rotation:byte;
    star:pointer;
    stardefinedyet,cloakon,tempcondition:boolean;
    ship1:    array[0..15] of pointer;
    ship1rev: array[0..15] of pointer;
    ship2:    array[0..15] of pointer;
    ship2rev: array[0..15] of pointer;
    ship1background:pointer;
label menuagain;
{=-=-=-=-=-=-=Procedure That Gets Time Delay=-=-=-=-=-=}
function GetTimeDelay:integer;
  var hours,minutes,seconds,hundredths:word;
      zhours,zminutes,zseconds,zhundredths:word;
      tempsec,temphund:integer;
  label back;
 begin
    back:
      gettime(hours,minutes,seconds,hundredths);
      delay(1000);
      gettime(zhours,zminutes,zseconds,zhundredths);
      tempsec:=abs(zseconds-seconds);
      temphund:=abs(zhundredths-hundredths);
      tempsec:=(tempsec*100)+temphund;
    if tempsec<0 then goto back;
    GetTimeDelay:=(1000 div tempsec)*80;
end;
{-=-=-=-=-=-=-=-=-Procedure to Draw Stars-=-=-=-=-=-=-=-==-=-=-=-=}
procedure FillWithStars(howmany:integer);
var starx,stary,counter:integer;
begin
  if not(stardefinedyet) then begin
     starx:=random(635);
     stary:=random(194);
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

{-=-=-=-=-=-=-=-=-Procedure to Simplify Credits=-=-=-=-=-=-=-=-=-=}
  procedure inbox(color:integer;st1,st2:string);
  begin
    setcolor(color);
    outtextxy(3,0,st1);
    outtextxy(3,8,st2);
    delay(round(timedelay*1.25));
    clearviewport;
    delay(timedelay div 3);
  end;

{-=-=-=-=-=-=-=-=-Procedure to Do Credits=-=-=-=-=-=-=-=-=-=-=-=-}
  procedure docredits;
  begin
    while 2+2=4 do begin
      inbox(14,'A d v e n t u r e s   i n ','T i m e   a n d   s p a c e');
      if keypressed then exit;
      inbox(11,'P r o g r a m m i n g ','V i n c e n t   W e a v e r');
      if keypressed then exit;
      inbox(10,'S t o r y ','V i n c e n t   W e a v e r');
      if keypressed then exit;
      inbox(9,'S t o r y   C o n t .','P a u l   S t o n e   I V');
      if keypressed then exit;
      inbox(15,'S t o r y  C o n t .','J e f f   M e t h e n y');
      if keypressed then exit;
      inbox(13,'G r a p h ic s   H e l p','J e f f   W a r w i c k');
      if keypressed then exit;
      inbox(12,'P r o g r a m   I d e a s','J o h n   C l e m e n s');
      if keypressed then exit;
      inbox(7,'B B S','J a s o n   G r i m m');
      if keypressed then exit;
      inbox(4,'U T O P I A   B B S','4 1 0 - 5 5 7 - 0 8 6 8');
      if keypressed then exit;
      inbox(3,'R e n t   S p a c e ','H e r e . . C h e a p');
      if keypressed then exit;
    end;
  end;
{-=-=-=-=-=-=-=-=-=-Procedure that does opening-=-=-=-=-=-=--=}
  procedure openingscreen;
  begin
    {***First Screen***}
      clrscr;
      textcolor(7);  gotoxy(30,1);  writeln('N o w   L o a d i n g');
      textcolor(12); gotoxy(12,3);  writeln('A d v e n t u r e s');
      textcolor(14); gotoxy(34,3);  writeln('I n');
      textcolor(10); gotoxy(40,3);  writeln('T i m e');
      textcolor(9);  gotoxy(50,3);  writeln('A n d');
      textcolor(11); gotoxy(58,3);  writeln('S p a c e');
      textcolor(7);  gotoxy(19,5);  writeln('A Game Based On The Creative Radio Drama');
      textcolor(12); gotoxy(12,7);  writeln('A d v e n t u r e s');
      textcolor(14); gotoxy(34,7);  writeln('I n');
      textcolor(10); gotoxy(40,7);  writeln('T i m e');
      textcolor(9);  gotoxy(50,7);  writeln('A n d');
      textcolor(11); gotoxy(58,7);  writeln('S p a c e');
      textcolor(7);  gotoxy(38,9);  writeln('By');
      textcolor(12); gotoxy(32,11); writeln('Jeff A. Metheny');
      textcolor(14); gotoxy(32,12); writeln('Paul R. Stone IV');
      textcolor(10); gotoxy(32,13); writeln('Vincent M. Weaver');
      textcolor(7);  gotoxy(14,19); writeln('A');
      textcolor(4);  gotoxy(17,19); writeln('ßÛ');
      textbackground(1); gotoxy(19,19); writeln('ß ');
      textcolor(2);  gotoxy(21,19); writeln('ßÛß ßÛ');
      textbackground(0); gotoxy(27,19); writeln('ß');
      textcolor(7);  gotoxy(30,19); writeln('S o f t w a r e   P r o d u c t i o n');
      textcolor(8);  gotoxy(16,21); writeln('Made Using Paintpro, Another VMW Software Production');
      textcolor(15); gotoxy(29,23); writeln('<Press Any Key To Continue>');
      textcolor(0); write('Hi'); gotoxy(1,24);
      timedelay:=gettimedelay;
      repeat until keypressed;
      tempch:=readkey;
      textcolor(7);
end;
    {***Other Things***}
procedure initialize;
begin
    graphdriver:=ega;  graphmode:=egalo;
    initgraph(graphdriver,graphmode,'');
    setvisualpage(0);
    setactivepage(1);
    getmem(menuline,imagesize(0,0,100,8));
    setfillstyle(solidfill,15);
    bar(0,0,100,8);
    getimage(0,0,100,8,menuline^);
    setfillstyle(solidfill,0);
    bar(0,0,100,8);
end;
procedure opening;
begin
    setvisualpage(1);
    loadpic('Title.ats',0);
    setvisualpage(0);
    setcolor(8);
    settextstyle(2,0,2);
    outtextxy(0,190,'(C) C o p y r i g h t  b y  V I N C E   W E A V E R   1 9 9 4 ');
    setfillstyle(solidfill,0);
    bar(235,79,405,98);
    setcolor(9);
    rectangle(235,78,405,99);
    getviewsettings(viewport);
    setviewport(236,79,404,98,true);
    settextstyle(2,0,4);
    {170,80,340,98}
    docredits;
    ch:=readkey;
end;
{=-=-=-=-=-=-=-=-Main Program---=-=-=-=-=-=-=-=-=-=-=-=}
begin
{-=-=-=-=-=-=-=-=Initialize Sequence=-=-=-=-=-=-=-=-=-}
    openingscreen;
    initialize;
    opening;
    stardefinedyet:=false;
    rotation:=0;
    randomize;
    getmem(star,imagesize(0,0,4,4));
    getmem(ship1background,imagesize(0,0,20,20));
    for i:=0 to 15 do getmem(ship1[i],imagesize(0,0,20,20));
    for i:=0 to 15 do getmem(ship1rev[i],imagesize(0,0,20,20));
menuagain:
    menupos:=0;
{=-=-=-=-=-=-=-=-=-=-=-=-Opening Menu-=-=-=-=-=-=-=----=-=-}
   with viewport do setviewport(x1,y1,x2,y2,clip);
     setfillstyle(solidfill,8);
     bar(250,58,390,140);
     setcolor(7);
     rectangle(250,58,390,140);
     settextstyle(4,0,1);
     setcolor(12);
      outtextxy(248,60,' New Game');
      outtextxy(248,70,' Restore Game');
      outtextxy(248,80,' Save Game');
      outtextxy(248,90,' End Game');
      outtextxy(248,100,' Options');
      outtextxy(248,110,' See Story');
      outtextxy(248,120,' About AITAS...');
      outtextxy(248,130,' Quit to Dos');
     setcolor(10);
     outtextxy(1,1,'Press F1 for Help');
      repeat until keypressed;
      menucommand:=input;
      putimage(252,59+(menupos*10),menuline^,xorput);
      repeat
        repeat until keypressed;
        oldmenupos:=menupos;
        menucommand:=input;
        if menucommand='ÛUP' then menupos:=menupos-1;
        if menucommand='ÛDOWN' then menupos:=menupos+1;
        if menupos<0 then menupos:=7;
        if menupos>7 then menupos:=0;
        putimage(252,59+(oldmenupos*10),menuline^,xorput);
        putimage(252,59+(menupos*10),menuline^,xorput);
      until menucommand='ÛENTER';
      if menupos=0 then begin
         setvisualpage(0);

         clearviewport;
         loadpicat('SWSHIPS3.SW2',0,0,1);
         for i:=0 to 15 do getimage(5+(i*25),5,25+(i*25),25,ship1[i]^);
         loadpicat('SWSHIPR3.SW2',0,0,1);
         for i:=0 to 15 do getimage(5+(i*25),5,25+(i*25),25,ship1rev[i]^);
         setactivepage(0); setvisualpage(0);
         fillwithstars(150);
         ship1x:=100;
         ship1y:=100;
         rotation:=0;
         getimage(100,100,120,120,ship1background^);
         putimage(100,100,ship1[rotation]^,orput);
         putimage(100,100,ship1rev[rotation]^,andput);
         putimage(100,100,ship1[rotation]^,xorput);
         putimage(100,100,ship1[rotation]^,orput);
         repeat
            repeat until keypressed;
            command:=readkey;
            putimage(ship1x,ship1y,ship1background^,normalput);
            if command='4' then begin
               ship1x:=ship1x-10; if ship1x<0 then ship1x:=619;
            end;
            if command='6' then begin
               ship1x:=ship1x+10; if ship1x>619 then ship1x:=0;
            end;
            if command='9' then begin
               inc(rotation); if rotation>15 then rotation:=0;
            end;
            if command='7' then begin
               dec(rotation); if rotation>254 then rotation:=15;
            end;
            getimage(ship1x,ship1y,ship1x+20,ship1y+20,ship1background^);
            putimage(ship1x,ship1y,ship1[rotation]^,orput);
            putimage(ship1x,ship1y,ship1rev[rotation]^,andput);
            putimage(ship1x,ship1y,ship1[rotation]^,xorput);
            putimage(ship1x,ship1y,ship1[rotation]^,orput);


  until upcase(command)='Q';
  end;
      if menupos<>7 then goto Menuagain;
   closegraph;
   move(imagedata,screen,4000);
   textcolor(7);
   gotoxy(1,23);
end.