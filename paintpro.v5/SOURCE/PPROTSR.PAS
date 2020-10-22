program pprotsr;
{$M 1024, 0, 1024}
uses dos;
const
   videoseg=$A000;
var i:longint;
    f:text;
    image:word;
    picture:array[0..28000] of byte;
procedure takeit(flags,cs,ip,ax,bx,cx,dx,si,di,ds,es,bp:word);
interrupt;
begin
  if image=4 then image:=0;
  if image=0 then begin port[$3CE]:=4; port[$3CF]:=0; end;
  if image=1 then begin port[$3CE]:=4; port[$3CF]:=1; end;
  if image=2 then begin port[$3CE]:=4; port[$3CF]:=2; end;
  if image=3 then begin port[$3CE]:=4; port[$3CF]:=3; end;
  for i:=0 to 28000 do picture[i]:=mem[videoseg:i];
  inc(image);
  port[$3CE]:=4; port[$3CF]:=0;
end;
begin
  image:=0;
  setintvec($05,@Takeit);
  setintvec($3A,@Image);
  setintvec($3B,@picture);
  writeln('PPROTSR- A screen Capture Utility For PaintPro is Installed');
  writeln;
  writeln('Remember---You can only run this in the EGA 640x350 graphics mode');
  writeln;
  writeln('Bring the picture up, and then Press "SHIFT-PRINTSCREEN"');
  writeln('      After running it once you must exit to DOS and run ');
  writeln('      the program "PPROWRIT.EXE.  ');
  writeln;
  writeln('Do the above 4 times.  Than run the program "PIC2PPO.EXE"');
  writeln('Then the picture will be saved as "OLDPIC.PPO"');
  writeln('You may then erase all the files with the names:');
  writeln('    PIC1.pic, PIC2.pic, PIC3.pic and PIC4.pic');
  writeln;
  writeln('THank you--VInce Weaver  #23 DEATER UTOPIA BBS 410-557-0868');
  keep(0);
end.
