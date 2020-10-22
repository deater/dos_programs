Program VMW_CHRISTMAS_PROGRAM_1994;

{$M 16384,0,65535}

Uses voctool,CMFTool,Crt,vmwgraph;

type Virtual = Array [1..64000] of byte;  { The size of our Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }

VAR
   Check      : BOOLEAN;
   SongName   : String;
   SongBuffer : CMFDataTyp;
   x,i,j,c:integer;
   grapherror,y,r,g,b:byte;
   ch:char;
   palf:text;
   temp:array[0..3] of byte;
   Sound : Pointer;
   star:array[0..8,0..11] of byte;
   shepherd:array[0..70,0..72] of byte;
    Virscr : VirtPtr;                      { Our first Virtual screen }
    VirScr2 : VirtPtr;                     { Our second Virtual screen }
    Vaddr  : word;                      { The segment of our virtual screen}
    Vaddr2 : Word;
    tempbool,sbthere,vocthere:boolean;
    numtimes:integer;
Procedure SetUpVirtual;
   { This sets up the memory needed for the virtual screen }
BEGIN
  GetMem (VirScr,64000);
  vaddr := seg (virscr^);
END;



PROCEDURE TextNumError;
BEGIN
   Write(' Error #',CMFErrStat:3,': ');
   PrintCMFErrMessage;
   WriteLn;
END;

Procedure ShutDown;
   { This frees the memory used by the virtual screen }
BEGIN
  FreeMem (VirScr,64000);
END;

PROCEDURE VTextNumError;
BEGIN
   Write(' Error #',VOCErrStat:3,' =');
   PrintVOCErrMessage;
   WriteLn;
END;

procedure condition(torf:boolean;x1,y1,c:integer);
begin
  if torf=true then outtextxy('YES',x1,y1,15,c,0,vga,false);
  if torf=false then outtextxy('NO',x1,y1,15,c,0,vga,false);
end;


begin
   sbthere:=true;
   vocthere:=true;
   if cmferrstat>0 then sbthere:=false;
   if vocerrstat>0 then vocthere:=false;
   setupvirtual;
   fade;
   setmcga;
   for x:=0 to 40 do begin
       pal(100+x,x+20,0,0);
       pal(141+x,0,0,x+20);
       pal(182+x,0,x+20,0);
   end;
   fade;
   for x:=0 to 40 do begin
       line(x+40,45,x+40,45+(2*x),100+x,vga);
       line(x+120,45,x+120,45+(2*x),141+x,vga);
       line(x+200,45,x+200,45+(2*x),141+x,vga);
       line(x+80,125,x+80,125-(2*x),182+x,vga);
       line(x+160,125,x+160,125-(2*x),182+x,vga);
   end;
   for x:=40 downto 0 do begin
       line(x+80,45,x+80,125-(2*x),140-x,vga);
       line(x+160,45,x+160,125-(2*x),181-x,vga);
       line(x+240,45,x+240,125-(2*x),181-x,vga);
       line(x+120,125,x+120,45+(2*x),222-x,vga);
       line(x+200,125,x+200,45+(2*x),222-x,vga);
   end;
   outtextxy('A VMW SOFTWARE PRODUCTION',60,140,15,15,0,VGA,false);
   unfade;
   y:=0;
   repeat
   until keypressed;
   ch:=readkey;
   fade;
   cls(0,vga);
   unfade;
   j:=0;
   repeat
      if j<7 then outtextxy('A VMW CHRISTMAS - 1994',80,80,j,4,0,vga,false);
      Move (mem[vga:320],mem[vga:0],25920);
      inc(j);
   until j=40;
   if keypressed then ch:=readkey;
   outtextxy('INSTRUCTIONS:',0,80,15,11,0,vga,false);
   outtextxy('   PRESS SPACEBAR TO MAKE THINGS HAPPEN',0,90,15,3,0,vga,false);
   outtextxy('   PRESS ANY OTHER KEY TO CONTINUE',0,100,15,3,0,vga,false);
   outtextxy('SOUNDBLASTER:',0,165,15,9,0,vga,false);
   outtextxy('CMFPLAYER:   ',0,175,15,9,0,vga,false);
   outtextxy('VOCPLAYER:   ',0,185,15,9,0,vga,false);
   tempbool:=sbthere;
   tempbool:=tempbool or vocthere;
   condition(tempbool,112,165,9);
   condition(sbthere,112,175,9);
   condition(vocthere,112,185,9);
   repeat until keypressed;
   ch:=readkey;
   fade;

   {***********loadcmfstuff*********}
 if sbthere then begin
   IF Not (CMFDriverInstalled) THEN TextNumError;
   SongName :='fairy.CMF';
   Check := CMFGetSongBuffer(SongBuffer,SongName);
   IF NOT(Check) THEN TextNumError;
   CMFSetTransposeOfs(0);
   Check := CMFPlaySong(SongBuffer);
   IF NOT(Check) THEN TextNumError;
 end;
{***********loadsheeppic and palette************}
   cls(0,vga);
   assign(palf,'pal.tb1');
   reset(palf);
   for i:=0 to 255 do begin
       for j:=1 to 3 do readln(palf,temp[j]);
       pal(i,temp[1],temp[2],temp[3]);
   end;
   close(palf);
   
   grapherror:=loadpicsuperpacked(0,0,vaddr,'shepherd.amg');
   for i:=0 to 8 do
       for j:=0 to 11 do star[i,j]:=getpixel(i+95,j+1,vaddr);
   for i:=0 to 70 do
       for j:=0 to 72 do shepherd[i,j]:=getpixel(i,j,vaddr);
   fade;
   grapherror:=loadpicsuperpacked(0,0,vga,'sheep.amg');
   unfade;
{*************loadvoc stuff*************}
if vocthere then begin
   IF Not(VOCDriverInstalled) THEN vTextNumError;
   Check := VOCGetBuffer(Sound,'LAMB.VOC');
   IF Not(Check) THEN TextNumError;
end;
  numtimes:=0;
  repeat
    repeat until keypressed;
    if keypressed then ch:=readkey;
       if (ch=' ') and (vocthere) then begin
          inc(numtimes);
          if numtimes=1 then outtextxy('BAAA',70,150,15,32,0,vga,false);
          if numtimes=2 then outtextxy('BAAA',200,145,15,40,0,vga,false);
          if numtimes=3 then outtextxy('BAAA',205,150,15,47,0,vga,false);
          if numtimes=4 then outtextxy('PRESS ENTER TO CONTINUE',66,185,15,47,0,vga,false);
          if numtimes=6 then numtimes:=5;
          VOCOutput(Sound);
          REPEAT UNTIL KeyPressed OR (VOCStatusWord = 0);
          IF KeyPressed THEN VOCStop;
        end;
   until (ch=#13) and (numtimes>3);
   for i:=0 to 63 do begin
       pal(0,0,0,i);
       vdelay(2);
   end;
   pal(0,63,63,63); vdelay(10);
   for i:=0 to 8 do for j:=0 to 11 do putpixel(i+95,j+45,star[i,j],vga);
   line(103,50,319,50,3,vga);
   line(0,50,95,50,3,vga);
   pal(0,0,0,0);
   vdelay(10);
   line(103,50,319,50,0,vga);
   line(0,50,95,50,0,vga);
   vdelay(50);
   for i:=0 to 69 do
       for j:=0 to 71 do
                 putpixel(i+210,j+60,shepherd[i,j],vga);
   readln;
   outtextxy('Merry Christmas',10,10,15,9,0,vga,false);
   readln;
{****END PROGRAM AND CLEAR RAM ROUTINEs***********}
   if vocthere then Check := VOCFreeBuffer(Sound);
   if sbthere then begin
      IF Not(Check) THEN TextNumError;
      Check := CMFStopSong;
      IF NOT(Check) THEN TextNumError;
      Check := CMFResetDriver;
      IF NOT(Check) THEN TextNumError;
      Check := CMFFreeSongBuffer(SongBuffer);
      IF NOT(Check) THEN TextNumError;
   end;
   shutdown;
   settext;
END.
