unit LOADSAV;
interface
uses graph,dos,crt;
function savpacked(filename:string;x1,y1,x2,y2:integer):string;
function loadpacked(filename:string;x1,y1,page:integer):string;
procedure savpic(name:string);
procedure savpicat(xco1,yco1,xco2,yco2:integer;name:string);
procedure loadpic(name:string;page:integer);
procedure loadpicat(name2:string;xx,yy,page2:integer);

implementation
function dec2hex(x:integer):char;
begin
  if x>9 then dec2hex:=CHR(55+X);
  if x<10 then dec2hex:=CHR((48+X));
end;
function hex2dec(x:char):integer;
begin
  if ord(x)<64 then hex2dec:=(ord(X)-48);
  if ord(x)>64 then hex2dec:=(ord(X)-55);
end;

function savpacked(filename:string;x1,y1,x2,y2:integer):string;
var pixelcol,oldpixco,repetition,numacros,x,y:integer;
    picfile:text;
    outline:string;

procedure savetodisk(opico,numacro:longint);
  var firstdigit,divresult,modresult:integer;
      tempst:string[10];
  begin
    inc(repetition);
    divresult:=opico div 16;
    modresult:=opico mod 16;
    if outline='NUL' then outline:=dec2hex(divresult)
                     else outline:=concat(outline,dec2hex(divresult));
    outline:=concat(outline,dec2hex(modresult));
    firstdigit:=numacro div 256;
    divresult:=(numacro-(256*firstdigit));
    modresult:=divresult mod 16;
    divresult:=divresult div 16;
    outline:=concat(outline,dec2hex(firstdigit),dec2hex(divresult),
                    dec2hex(modresult),':');
    if repetition=10 then begin
       writeln(picfile,outline);
       outline:='NUL';
       repetition:=-1;
    end;




  end;
begin
  outline:='NUL';
  repetition:=-1;
  if (x2-x1<1) or (y2-y1<1) then savpacked:='Invalid Coordinates';
  if (x2-x1<1) or (y2-y1<1) then exit;
  assign(picfile,filename);
  rewrite(picfile);
  writeln(picfile,'PACKED');
  writeln(picfile,getmaxcolor+1);
  writeln(picfile,x2-x1);
  writeln(picfile,y2-y1);
  x:=x1;
  y:=y1;
  oldpixco:=getpixel(x,y);
  numacros:=0;
  repeat
    while x<x2 do begin
        inc(x);
        inc(numacros);
        pixelcol:=getpixel(x,y);
        if (pixelcol<>oldpixco) then begin
            savetodisk(oldpixco,numacros);
            numacros:=0;
            oldpixco:=pixelcol;
         end;
       end;
       savetodisk(oldpixco,numacros);
       x:=x1;
       inc(y);
       numacros:=0;
       oldpixco:=getpixel(x,y);
  until y>y2-1;
  if outline<>'NUL' then writeln(picfile,outline);
  writeln(picfile,'FDONE');
  close (picfile);
end;


function loadpacked(filename:string;x1,y1,page:integer):string;
var color,repetitions,x,y,maxcolors,xsize,ysize,digit1,digit2,
    digit3,numacros:integer;
    picfile:text;
    filegrmode:string[10];
    picdata:string[6];
    inlines:string;
begin
  assign(picfile,filename);
  reset(picfile);
  readln(picfile,filegrmode);
  readln(picfile,maxcolors);
  readln(picfile,xsize);
  readln(picfile,ysize);
  x:=x1;
  y:=y1;
  moveto(x1,y1);
  setactivepage(page);
  inlines:='NULL';
  while inlines<>'FDONE' do begin
    readln(picfile,inlines);
    repetitions:=-1;
    repeat
       inc(repetitions);
       picdata:=copy(inlines,(repetitions*6)+1,repetitions*6+6);
       if picdata='' then inlines:='FDONE';
       digit1:=hex2dec(picdata[1]);
       digit2:=hex2dec(picdata[2]);
       color:=(digit1*16)+digit2;
       digit1:=hex2dec(picdata[3]);
       digit2:=hex2dec(picdata[4]);
       digit3:=hex2dec(picdata[5]);
       numacros:=((digit1*256)+(digit2*16))+digit3;
       setcolor(color);
       lineto(x+(numacros-1),y);
       if (x+numacros+1)>xsize+x1 then begin
          inc(y);
          x:=x1;
          numacros:=0;
       end;
       x:=x+(numacros);
       moveto(x,y);
     until repetitions=10;
  end;
  close(picfile);
end;



procedure savpic(name:string);
var pixelcol,numacros,oldpixco,x,y,xsize,ysize:integer;
    picture:text;

  procedure savetodisk(opico,pico,numacro:longint);
    var temp1:longint;
  begin
     temp1:=(opico*1000)+numacro;
     writeln(picture,temp1);
  end;

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
  writeln(picture,#26);
close (picture);
end;

procedure savpicat(xco1,yco1,xco2,yco2:integer;name:string);
var pixelcol,oldpixco,numacros,xsize,ysize,x,y:integer;
    picture:text;

  procedure savetodisk(opico,pico,numacro:longint);
  var temp1:longint;
  begin
     temp1:=(opico*1000)+numacro;
     writeln(picture,temp1);
  end;
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
  writeln(picture,#26);
close (picture);
end;


procedure loadpic(name:string;page:integer);
var na,color,x,y,maxcolors,ysize,xsize:integer;
    picture:text;
    filegrmode:string[15];
    temp1:longint;
    c:real;
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
var na,color,x,y,maxcolors,xsize,ysize:integer;
    picture:text;
    filegrmode:string[15];
    temp1:longint;
    c:real;
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