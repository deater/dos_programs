program RotShape;
uses graph,crt,loadsav;
const  pi = 3.141592653589793238462643383279502884;
var COLORS:      array[0..21,0..19] of integer;

    newy,newx,x,y,graphdriver,graphmode:integer;
    angle:real;
    ch:char;
    xpos,ypos,i:integer;
begin
  graphdriver:=ega; graphmode:=egahi;
  initgraph(graphdriver,graphmode,'');
  loadpicat('SWSHIP1.ppo',0,0,0);

  FOR X := 1 TO 21 do
      FOR y := 1 TO 19 do  COLORS[X,y]:=getpixel(X-1,y-1);
  angle:=0;
  xpos:=0; ypos:=100;
  for i:=1 to 16 do begin
      xpos:=xpos+35;
    FOR X:=1 TO 21 do begin
        FOR y:= 1 TO 19 do begin
            NEWY:=round((x-11)*sin(angle)+(y-10)*cos(angle));
            NEWX:=round((x-11)*cos(angle)-(y-10)*sin(angle));
            Putpixel(NEWX + xpos, NEWY + ypos, COLORS[X, y]);
        end;
    end;
    angle:= angle + (pi / 8);
  end;
  savpicat(0,75,639,250,'swship3.sw3');
  readln;
end.

