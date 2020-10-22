uses picload,graph,crt;
var gd,gm:integer;
begin
  gd:=ega;
  gm:=egalo;
  initgraph(gd,gm,'');
  loadpic('SAMPLE.PPO',0);
  gotoxy(1,20);
  readln;
end.
