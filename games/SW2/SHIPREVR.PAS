uses graph, loadsav;
var x,y,gd,gm:integer;
    ship:pointer;
begin
  gd:=ega; gm:=egahi;
  initgraph(gd,gm,'');
  getmem(ship,imagesize(0,0,21,21));
  loadpicat('SW3SHP1.sw3',51,80,0);
  for x:=0 to 639 do for y:=0 to 349 do if getpixel(x,y)=0 then putpixel(x,y,15);
  savpicat(51,80,635,110,'SW3shp1r.sw3');

  readln;
  closegraph;
end.