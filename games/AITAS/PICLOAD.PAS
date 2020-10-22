unit picload;
   interface procedure loadpic(name:string;page:integer);
   PROCEDURE LOADPICAT(NAME2:STRING;Xx,Yy,PAGE2:INTEGER);
implementation

uses graph;
var
  picture:text;
  maxcolors,na,data,color,x,y,xsize,ysize,gm,gh,temp1:integer;
  c:real;
  st,filegrmode:string;
procedure loadpic(name:string;page:integer);
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

repeat
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
until temp1=0;
close(picture);
end;
procedure loadpicat(name2:string;xx,yy,page2:integer);
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

repeat
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
until temp1=0;
close(picture);

end;
begin
end.

