program pprotsr;
{$M 1024, 0, 1024}
uses nvmwgraph,dos;
const
   videoseg=$A000;
var i:longint;
    picture:array[0..64000] of byte;
    image:array[0..2,0..255] of byte;
    r,g,b:byte;
    charptr:pointer;
    unload:boolean;

procedure takeit(flags,cs,ip,ax,bx,cx,dx,si,di,ds,es,bp:word);
interrupt;
begin
  for i:=0 to 64000 do picture[i]:=mem[videoseg:i];
  for i:=0 to 255 do begin
      getpal(i,r,g,b);
      image[0,i]:=r;
      image[1,i]:=g;
      image[2,i]:=b;
  end;
end;
begin
  getintvec($05,charptr);
  if integer(charptr^)<>1513 then begin
     writeln('Paintpro V5.00 TSR already loaded');
     writeln('Press Shift-Printscreen to activate');
     writeln('And run PPPWRITE.EXE to write to disk.');
     writeln('PPPTSR /0 unloads from memory');
     halt(1);
  end;
  unload:=false;
  if paramcount<>0 then begin
     for i:=0 to paramcount do
         if paramstr(i)='/0' then unload:=true;
     if unload=false then begin
        writeln('PPPTSR  [/0]        : /0 unloads it from RAM');
        halt(2);
     end;
     if unload=true then begin
        setintvec($05,charptr);
        halt(3);
     end;
  end;


  setintvec($05,@Takeit);
  setintvec($3A,@Image);
  setintvec($3B,@picture);
  setintvec($3C,@charptr);
  writeln('             PaintproV5.00 screen capture');
  writeln;
  writeln('Run this first.  Load a picture in 320x200x256 mode.');
  writeln('Press control-printscreen.  Exit to dos.  Run the ');
  writeln('Program PPPWRITE.EXE to write it to disk.  Repeat.');
  writeln('Sort of confusing, but functional.');
  writeln;
  writeln('Thank you--Vince Weaver  mjweaver@umd5.umd.edu');
  keep(0);
end.
