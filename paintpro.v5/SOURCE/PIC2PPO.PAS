uses graph,picmak;
var seg1:word absolute $A000:$03CE;
    seg2:word absolute $A000:$03CF;
    gd,gm:integer;
    i:longint;
    f:text;
    q:byte;
begin
  assign(F,'Pic1.pic');
  reset(f);
  gd:=ega; gm:=egahi;
  initgraph(gd,gm,'');

  port[$3c4]:=2;
  port[$3c5]:=1;
  for i:=0 to 28000 do begin
   readln(f,q);
   mem[$a000:i]:=q;
  end;
  close(f);
  assign(F,'Pic2.pic');
  reset(f);
  port[$3c4]:=2;
  port[$3c5]:=2;
  for i:=0 to 28000 do begin
   readln(f,q);
   mem[$a000:i]:=q;
  end;
  close(f);
  assign(F,'Pic3.pic');
  reset(f);
  port[$3c4]:=2;
  port[$3c5]:=4;
  for i:=0 to 28000 do begin
   readln(f,q);
   mem[$a000:i]:=q;
  end;
  close(f);
  assign(F,'Pic4.pic');
  reset(f);
  port[$3c4]:=2;
  port[$3c5]:=8;
  for i:=0 to 28000 do begin
   readln(f,q);
   mem[$a000:i]:=q;
  end;
  close(f);
  port[$3c4]:=2;
  port[$3c5]:=$f;
  savpicat(0,0,639,349,'OLDPIC.PPO');
  writeln('FILE CONVERTED....PRESS ENTER');
  readln;
  closegraph;

end.