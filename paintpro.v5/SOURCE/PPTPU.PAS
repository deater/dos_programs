unit pptpu;
{uses drivers,picmak,boxer,picload;}
interface
uses dos,graph,crt,boxer;


var xsize,ysize,gm,gh,pixelcol,oldpixco,numacros,temp2,
    na,color,r,i,graphdriver,graphmode,sx,sy,d,maxcolors:integer;
    temp1:longint;
    c,r1,r2,r3,x,xa,cr1,sr1,z,za,y,ya,cr2,sr2,cr3,sr3,mx,my,mz:real;
    corners: array[0..2,0..2] of integer;
    picture:text;
    st:char;
    filegrmode:string[30];
const pattern: fillpatterntype=($10,$10,$10,$ff,$10,$10,$10,$10);
procedure titlescrn;
function wx(n:real):integer;
function wy(n:real):integer;
procedure l610;
procedure l310;
procedure spin(n,co:integer);
procedure opening;
function input:string;
FUNCTION GET(XXX,YYYY,XX1,YYY1:INTEGER;PINT:POINTER):POINTER;
function graphread(x,y,bspcol,maxlength:integer):string;
procedure numon(no,co:integer);
procedure savpic(name:string);
procedure savpicat(xco1,yco1,xco2,yco2:integer;name:string);
procedure loadpic(name:string;page:integer);
pROCEDURE LOADPICAT(NAME2:STRING;Xx,Yy,PAGE2:INTEGER);

implementation
procedure titlescrn;
begin
  textbackground(1);
  clrscr;
  putstring(3,2,12,'€€€€€€  €€€€€€  €€€€€€ €€    €€  €€€€€€          €€€€€€  €€€€€€  €€€€€€ Ver.');
  putstring(3,3,12,'€€  €€  €€  €€    €€   €€€€  €€    €€            €€  €€  €€  €€  €€  €€ 3.15');
  putstring(3,4,12,'€€€€€€  €€€€€€    €€   €€ €€ €€    €€    €€€€€€  €€€€€€  €€€€€€  €€  €€');
  putstring(3,5,12,'€€      €€  €€    €€   €€  €€€€    €€            €€      €€ €€   €€  €€');
  putstring(3,6,12,'€€      €€  €€  €€€€€€ €€    €€    €€            €€      €€  €€  €€€€€€');
  putstring(27,8,5,'A Computer Graphics Program');
  putstring(39,10,15,'BY');
  putstring(34,11,15,'Vincent Weaver');
  putstring(31,12,7,'326 Foster Knoll Dr.');
  putstring(31,13,7,'Joppa, MD 21085-4706');
  putstring(28,14,7,'#3 Deater "UTOPIA" BBS 2400');
  putstring(35,15,7,'410-557-0868');
  putstring(5,19,6,'€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€');
  putstring(59,19,3,'€€');
  putstring(61,19,8,'€€€€€€€');
  putstring(68,19,14,'€€€');
  putstring(62,18,8,'‹‹‹‹‹‹');
  putstring(68,18,14,'‹');
  putstring(62,20,8,'ﬂﬂﬂﬂﬂﬂ');
  putstring(68,20,14,'ﬂ ﬂ');
  putstring(67,22,14,'‹‹‹‹‹‹‹‹‹');
  putstring(70,21,14,'€');
  gotoxy(1,24);
  repeat until keypressed;
end;


function wx(n:real):integer;
var n1:real;
begin
  n:=round(n);
  n:=n+399;
  n1:=639/799;
  n1:=n1*n;
  wx:=round(n1);
end;
function wy(n:real):integer;
var n1:real;
begin
  n:=round(n);
  n:=n+299;
  n1:=199/599;
  n1:=n1*n;
  wy:=round(n1);
end;
procedure l610;
begin
  sr1:=sin(r1); sr1:=sin(r2); sr3:=sin(r3);
  cr1:=cos(r1); cr2:=cos(r2); cr3:=cos(r3);
end;
procedure l310;
begin
  x:=(-1)*x; xa:=cr1*x-sr1*z; za:=sr1*x+cr1*z; x:=cr2*xa+sr2*y;
  ya:=cr2*y-sr2*xa; z:=cr3*za-sr3*ya; y:=sr3*za+cr3*ya; x:=x+mx;
  y:=y+my; z:=z+mz; sx:=round(d*x/z); sy:=round(d*y/z);
end;
procedure spin (n,co:integer);
begin
  for r:=0 to 78 do begin
    if r<39 then sound(50+r);
    if r>39 then sound(89-(r-39));
    r1:=r/25;
    l610;
    x:=corners[0,0]; y:=corners[0,1]; z:=corners[0,2];
    l310;
    moveto(wx(sx),wy(sy));
    for i:=1 to 2 do begin
      x:=corners[i,0]; y:=corners[i,1]; z:=corners[i,2];
      l310;
      setcolor(co);
      lineto(wx(sx),wy(sy));
    end;
    x:=corners[0,0]; y:=corners[0,1]; z:=corners[0,2];
    l310;
    lineto(wx(sx),wy(sy));
    if (r=0) and (mz=-7) then begin
       setfillstyle(solidfill,0);
       floodfill(320,100,co);
    end;

    x:=corners[0,0]; y:=corners[0,1]; z:=corners[0,2];
    l310;
    moveto(wx(sx),wy(sy));
    for i:=1 to 2 do begin
      x:=corners[i,0]; y:=corners[i,1]; z:=corners[i,2];
      l310;
      setcolor(0);
      lineto(wx(sx),wy(sy));
    end;
    x:=corners[0,0]; y:=corners[0,1]; z:=corners[0,2];
    l310;
    lineto(wx(sx),wy(sy));
  end;
  nosound;
end;
procedure opening;
begin        {[x,y] x:=corner y=x or y or z]}
  x:=0; y:=0; z:=0; sx:=0; sy:=0; r1:=0; xa:=0; ya:=0; za:=0;
  sr1:=0; sr2:=0; sr3:=0; cr1:=0; cr2:=0; cr3:=0; i:=0;
  corners[0,0]:=-28;  corners[0,1]:=40;  corners[0,2]:=0;
  corners[1,0]:=28;   corners[1,1]:=40;  corners[1,2]:=0;
  corners[2,0]:=0;    corners[2,1]:=-40; corners[2,2]:=0;
  graphdriver:=ega;
  graphmode:=egalo;
  initgraph(graphdriver,graphmode,'');
  if graphresult<0 then exit;
  setbkcolor(0);
  setfillpattern(pattern,8);
  setfillstyle(userfill,0);
  floodfill(1,1,5);
  d:=10;  r2:=6.28319; r3:=6.23819; mx:=0; my:=0; mz:=-7;
{Big Red V}
  spin(0,4); setpalette(0,4); delay(10); setpalette(0,0);
  setcolor(4); line(170,0,270,0); moveto(270,0);
  lineto(220,50); lineto(170,0); setfillstyle(solidfill,4);
  floodfill(220,25,4); sound(200); setfillpattern(pattern,8);
  setfillstyle(userfill,0); floodfill(320,100,8); delay (20); nosound;
{Big Green 1/2 M}
  mz:=7;
  spin(1,2); setpalette(0,2); delay(10); setpalette(0,0);
  setcolor(2); line(270,0,320,50); moveto(320,50);
  lineto(220,50); lineto(270,0); setfillstyle(solidfill,2);
  floodfill(270,25,2); sound(200); setfillpattern(pattern,8);
  setfillstyle(userfill,0); floodfill(320,100,8); delay(20); nosound;
{Big Blue 1/2 W}
  mz:=-7;
  spin(2,1); setpalette(0,1); delay(10); setpalette(0,0);
  setcolor(1); line(270,0,370,0); moveto(370,0);
  lineto(320,50); lineto(270,0); setfillstyle(solidfill,1);
  floodfill(320,25,1); sound(200); setfillpattern(pattern,8);
  setfillstyle(userfill,0); floodfill(320,100,8); delay(20); nosound;
{Big Green 1/2 M}
  mz:=7;
  spin(1,2); setpalette(0,2); delay(10); setpalette(0,0);
  setcolor(2); line(370,0,420,50); moveto(420,50);
  lineto(320,50); lineto(370,0); setfillstyle(solidfill,2);
  floodfill(370,25,2); sound(200); setfillpattern(pattern,8);
  setfillstyle(userfill,0); floodfill(320,100,8); delay(20); nosound;
{Big Blue 1/2 W}
  mz:=-7;
  spin(2,1); setpalette(0,1); delay(10); setpalette(0,0);
  setcolor(1); line(370,0,470,0); moveto(470,0);
  lineto(420,50); lineto(370,0); setfillstyle(solidfill,1);
  floodfill(420,25,1); sound(200); setfillpattern(pattern,8);
  setfillstyle(userfill,0); floodfill(320,100,8); delay(20); nosound;
  directvideo:=false;
  textcolor(15);
  gotoxy(22,15);
  writeln('A Vincent Michael Weaver Production');
  gotoxy(19,16);
  textcolor(4);
  writeln('326 Foster Knoll Dr.  Joppa MD 21085-4706');
  gotoxy(17,17);
  textcolor(2);
  writeln('Home BBS - UTOPIA - 2400 - N81 - 410-557-0868');
  gotoxy(16,18);
  textcolor(1);
  writeln('E-Mail #3 Deater with any questions or comments');
  textcolor(7);
  gotoxy(26,24);
  writeln('Press <ENTER> to continue...');
  readln;
  closegraph;
end;
function input:string;
var char1,char2:char;
    inp,CHAR3:string;
begin
  input:='';
  if keypressed then begin
     char1:=readkey;
     char2:='¸';
     if char1=chr(0) then char2:=readkey;
     inp:='¸';
     if char2='H' then inp:='€UP';
     if char2='K' then inp:='€LEFT';
     if char2='M' then inp:='€RIGHT';
     if char2='P' then inp:='€DOWN';
     IF CHAR2='G' THEN INP:='€HOME';
     IF CHAR2='I' THEN INP:='€PAGEUP';
     IF CHAR2='O' THEN INP:='€END';
     IF CHAR2='Q' THEN INP:='€PAGEDOWN';
     IF CHAR2='R' THEN INP:='€INSERT';
     IF CHAR2='S' THEN INP:='€DELETE';
     if char2='s' then inp:='€CTRL-LEFT';
     if char2='t' then inp:='€CTRL-RIGHT';
     if char1=chr(13) then inp:='€ENTER';
     if char1=chr(8) then inp:='€BACKSPACE';
     if char1=chr(27) then inp:='€ESCAPE';
     if char1=chr(9) then inp:='€TAB';
     if char1=chr(219) then inp:='€€';
     IF (ORD(CHAR2)>58) AND (ORD(CHAR2)<69) THEN BEGIN
        STR(ORD(CHAR2)-58,CHAR3);
        INP:=CONCAT('€F',CHAR3);
     END;
     IF (ORD(CHAR2)>103) AND (ORD(CHAR2)<114) THEN BEGIN
        STR(ORD(CHAR2)-103,CHAR3);
        INP:=CONCAT('€ALT-F',CHAR3);
     END;
     IF (ORD(CHAR2)>93) AND (ORD(CHAR2)<104) THEN BEGIN
        STR(ORD(CHAR2)-93,CHAR3);
        INP:=CONCAT('€CONTROL-F',CHAR3);
     END;
     IF (ORD(CHAR2)>83) AND (ORD(CHAR2)<94) THEN BEGIN
        STR(ORD(CHAR2)-83,CHAR3);
        INP:=CONCAT('€SHIFT-F',CHAR3);
     END;
     if char1=chr(0) then begin
        if inp='¸' then begin
          if char2='x' then inp:='1'; if char2='y' then inp:='2';
          if char2='z' then inp:='3'; if char2='{' then inp:='4';
          if char2='|' then inp:='5'; if char2='}' then inp:='6';
          if char2='~' then inp:='7'; if char2=chr(127) then inp:='8';
          if char2='Ä' then inp:='9'; if char2='Å' then inp:='0';
          if char2='Ç' then inp:='-'; if char2='É' then inp:='=';
          if char2=chr(16) then inp:='Q';
          if char2=chr(17) then inp:='W';
          if char2=chr(18) then inp:='E';
          if char2=chr(19) then inp:='R';
          if char2=chr(20) then inp:='T';
          if char2=chr(21) then inp:='Y';
          if char2=chr(22) then inp:='U';
          if char2=chr(23) then inp:='I';
          if char2=chr(24) then inp:='O';
          if char2=chr(25) then inp:='P';
          if char2=chr(30) then inp:='A';
          if char2=chr(31) then inp:='S';
          if char2=' ' then inp:='D'; if char2='!' then inp:='F';
          if char2='"' then inp:='G'; if char2='#' then inp:='H';
          if char2='$' then inp:='J'; if char2='%' then inp:='K';
          if char2='&' then inp:='L'; if char2=',' then inp:='Z';
          if char2='-' then inp:='X'; if char2='.' then inp:='C';
          if char2='/' then inp:='V'; if char2='0' then inp:='B';
          if char2='1' then inp:='N'; if char2='2' then inp:='M';
          inp:=concat('€ALT-',inp);
        end;
     end;
     if inp='¸' then inp:=char1;
     input:=inp;
  end;
  char1:='!';  char2:='!';
end;
FUNCTION GET(xxx,yyyY,xx1,yyY1:INTEGER;PINT:POINTER):POINTER;
BEGIN
  GETMEM(PINT,IMAGESIZE(XXX,YYYY,XX1,YYY1));
  GETIMAGE(XXX,YYYY,XX1,YYY1,PINT^);
  GET:=PINT;
END;
function graphread(x,y,bspcol,maxlength:integer):string;
  function read2:string;
   var ch5:char;
   lenofstring:integer;
       ch3,st57:string;
       ch7:string[1];
   begin
     st57:='';
     ch5:=chr(0);
     repeat
     ch3:='!';
     ch3:=input;
     lenofstring:=0;
     if ch3='€BACKSPACE' then begin
        st57:=copy(st57,1,length(st57)-1);
        setfillstyle(1,bspcol);
        bar(x,y,x+98,y+10);
        outtextxy(x,y,st57);
        if lenofstring>0 then dec(lenofstring);

     end;
     if (length(ch3)<2) and (ch3<>'ENTER') then begin;
     if length(st57)<(maxlength-1) then begin
        outtextxy(x,y,st57);
        ch7:=ch3;
        inc(lenofstring);
        st57:=concat(st57,ch7);
     end
     else begin write(chr(7)); dec(lenofstring); end;
     end;
     until ch3='€ENTER';
     read2:=st57;
   end;
var ch:char;
    st,st2:string;
begin

  graphread:=read2;
end;
procedure numon(no,co:integer);
  const
    capson=$40;
    numon=$20;
  var keyflag1:byte absolute $0040:$0017;
  begin
    if no=0 then keyflag1:=keyflag1 and (not numon);
    if no=1 then keyflag1:=keyflag1 or numon;
    if co=0 then keyflag1:=keyflag1 and (not capson);
    if co=1 then keyflag1:=keyflag1 or capson;
end;
procedure savetodisk(opico,pico,numacro:longint);
 begin
     temp1:=(opico*1000)+numacro;
     writeln(picture,temp1);
   end;
procedure savpic(name:string);
var x,y:integer;
begin
  assign(picture,name);
  rewrite(picture);
  xsize:=getmaxx;
  ysize:=getmaxy;
  writeln(picture,getdrivername);
  writeln(picture,getmaxcolor+1);
  writeln(picture,xsize);
  writeln(picture,ysize);
  x:=0;
  y:=0;
  oldpixco:=getpixel(0,0);
  numacros:=0;
repeat
while x<xsize do begin
    inc(x);
    inc(numacros);
    pixelcol:=getpixel(x,y);
  if (pixelcol<>oldpixco) then begin
     savetodisk(oldpixco,pixelcol,numacros);
     numacros:=0;
     oldpixco:=pixelcol;
  end;
  end;
  savetodisk(oldpixco,pixelcol,numacros);
  x:=0;
  inc(y);
  numacros:=0;
  oldpixco:=getpixel(x,y);
  until y>ysize-1;
close (picture);
end;

procedure savpicat(xco1,yco1,xco2,yco2:integer;name:string);
var xsize,ysize,x,y:integer;
begin
  xsize:=xco2-xco1;
  ysize:=yco2-yco1;
  if (xsize<1) or (ysize<1) then exit;
  assign(picture,name);
  rewrite(picture);
  writeln(picture,'PARTIAL');
  writeln(picture,getmaxcolor+1);
  writeln(picture,xsize);
  writeln(picture,ysize);
  x:=xco1;
  y:=yco1;
  oldpixco:=getpixel(xco1,yco1);
  numacros:=0;
repeat
while x<xco2 do begin
    inc(x);
    inc(numacros);
    pixelcol:=getpixel(x,y);
  if (pixelcol<>oldpixco) then begin
     savetodisk(oldpixco,pixelcol,numacros);
     numacros:=0;
     oldpixco:=pixelcol;
  end;
  end;
  savetodisk(oldpixco,pixelcol,numacros);
  x:=xco1;
  inc(y);
  numacros:=0;
  oldpixco:=getpixel(x,y);
  until y>yco2-1;
close (picture);
end;
procedure loadpic(name:string;page:integer);
var x,y:integer;
begin
  assign(picture,name);
  reset(picture);
  readln(picture,filegrmode);
  readln(picture,maxcolors);
  readln(picture,xsize);
  readln(picture,ysize);
  x:=0;
  y:=0;
  moveto(x,y);
  setactivepage(page);

while not(eof(picture)) do begin
  read(picture,temp1);
  c:=temp1 div 1000;
  c:=int(c);
  color:=round(c);
  na:=temp1-(color*1000);
  setcolor(color);
  lineto(x+na,y);
  if (x+na+1)>xsize then begin
    y:=y+1;
    x:=0;
    na:=0;
    end;
  x:=x+na;
  moveto(x,y);
end;
close(picture);
end;
procedure loadpicat(name2:string;xx,yy,page2:integer);
var x,y:integer;
begin
  assign(picture,name2);
  reset(picture);
  readln(picture,filegrmode);
  readln(picture,maxcolors);
  readln(picture,xsize);
  readln(picture,ysize);
  x:=xx;
  y:=yy;
  moveto(x,y);
  setactivepage(page2);

while not(eof(picture)) do begin
  read(picture,temp1);
  c:=temp1 div 1000;
  c:=int(c);
  color:=round(c);
  na:=temp1-(color*1000);
  setcolor(color);
  lineto(x+na,y);
  if (x+na+1)>xsize+xx then begin
    y:=y+1;
    x:=xx;
    na:=0;
    end;
  x:=x+na;
  moveto(x,y);
end;
close(picture);

end;


begin
end.