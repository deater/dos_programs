program Christmas_96;

{$G+}

uses svmwgraph,nvmwgraph,detect,smix,tsunth,tsuntm;
     {The last two are Timo Silami's units
      that replace borlands crt.tpu which
      will crash on newer faster computers}

  const
    XMSRequired   = 90;    {XMS memory required to load the sounds (KBytes) }
    SharedEMB     = true;
      {TRUE:   All sounds will be stored in a shared EMB}
      {FALSE:  Each sound will be stored in a separate EMB}
    NumSounds = 3;


type Virtual = Array [1..64000] of byte;  { The size of our Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }
     ShapeTable = Array [0..16000] of byte;
     ShapePtr = ^ShapeTable;


var {Brodsky's Variables}
    BaseIO: word; IRQ, DMA, DMA16: byte;
    Sound: array[0..NumSounds-1] of PSound;
    OldExitProc: pointer;
    Xsoundeffects,Xsbsound:byte;
    sbsound,sbeffects:boolean;
    XBASEIO,XDMA,XIRQ:word;
    ShapeAddr:word;                     { The segment of the shape table}
    ShapeOfs:word;

var x,y,q:integer;
    Virscr : VirtPtr;                      { Our first Virtual screen }
    VirScr2 : VirtPtr;                     { Our second Virtual screen }
    shapetable1:shapeptr;
    Vaddr  : word;                         { The segment of our virtual screen}
    Vaddr2 : Word;
    graphresult:byte;
    ch,ch2:char;
    i,j:integer;
    firstime:boolean;
    numtimes:integer;

    dev,mix,stat,pro,loop : integer;

    Soundp : Pointer;
    Check : BOOLEAN;


procedure pauseawhile(howlong:word);
var i:word;
begin
  i:=0;
  repeat
    waitretrace;
    inc(i);
    if i>howlong then exit;
  until KEYPREFN;
end;



procedure fillblock(xx1,yy1,xx2,yy2:integer;colo:byte;where:word);
label gus3,gus;
begin
   asm
     push es             {Save Variables}
       push ds
     mov ax,where      {Load where output Goes}
       mov es,ax
     mov ah,colo       {Color To Block}
       mov al,colo
     mov bx,yy1
     mov dx,bx         {Multiply by 320 to find start row}
       shl dx,5
       mov cx,dx
       shl dx,1
       shl cx,3
       add dx,cx
     add dx,xx1       {Add x to get column}
     mov di,dx        {Load into register}

     mov dx,[xx2]     {Calculate width and store in dx}
       sub dx,[xx1]
     mov bx,320       {Calcualte and store skipover}
       sub bx,dx
       push bx
     mov bx,[yy2]     {calculate height and store in bx}
       sub bx,[yy1]

gus3:
     mov cx,dx
     shr cx,1           {Divide width in half}
       jnc gus        {If even, jump}

     stosb            {then store odd byte}
                      {Jump Past}
gus:
      rep stosw       {Its even.. so store words}

    pop cx            {restore and add skipover}
    add di,cx
    push cx
    dec bx            {decrement y line}
    jnz gus3          {if not zero, go back}
    pop cx
    pop ds            {restore registers}
    pop es
   end;
end;

procedure ReadConfigFile;
var ff:text;
begin
(*
  {$I-}
     assign(ff,'config.tb1');
     reset(ff);
     close(ff);
  {$I+}
     if IOresult<>0 then begin
        writeln('Warning: Missing or Invalid "config.tb1" file');
        writeln;
        writeln('If you are running this off of a CD-ROM drive:');
        writeln('    For optimal performance you should copy this game');
        writeln('    to a floppy or hard disk.  However you can play in');
        writeln('    read only mode.');
        writeln;
        writeln('If you are not running this off of a CD-ROM drive:');
        write('    Please run the "');
        write('tbsetup');
        writeln('" utility included to set');
        writeln('    up your computer.  Thank You.');
        halt(5);
     end
     else begin
        assign(ff,'config.tb1');
        reset(ff);
          readln(ff,Xsoundeffects);
          readln(ff,Xsbsound);
          readln(ff,Xbaseio);
          readln(ff,Xirq);
          readln(ff,Xdma);
        close(ff);
     end *)
end;







Procedure blockmove(x1,y1,x2,y2,p1,x3,y3,p2:word);
  { This is a small procedure to copy block x1,y1,x2,y2,
    from page 1 to x3,y3 on page 2}
BEGIN
  asm
    push    ds
    push    es
    mov     ax,p1
    mov     ds,ax
    mov     ax,p2
    mov     es,ax

    mov     bx,[X1]
    mov     dx,[Y1]
    push    bx                      {; and this again for later}
    mov     bx, dx                  {; bx = dx}
    mov     dh, dl                  {; dx = dx * 256}
    xor     dl, dl
    shl     bx, 6                   {; bx = bx * 64}
    add     dx, bx                  {; dx = dx + bx (ie y*320)}
    pop     bx                      {; get back our x}
    add     bx, dx                  {; finalise location}
    mov     si, bx                  {; es:di = where to go}

    mov     bx,[X3]
    mov     dx,[Y3]
    push    bx                      {; and this again for later}
    mov     bx, dx                  {; bx = dx}
    mov     dh, dl                  {; dx = dx * 256}
    xor     dl, dl
    shl     bx, 6                   {; bx = bx * 64}
    add     dx, bx                  {; dx = dx + bx (ie y*320)}
    pop     bx                      {; get back our x}
    add     bx, dx                  {; finalise location}
    mov     di, bx                  {; es:di = where to go}

    mov ax,[y2]
    sub  ax,[y1]

    mov     dx,[x2]
    sub     dx,[x1]
    mov     bx,320
    sub     bx,dx

    
@@1 :
    mov     cx, dx         { Width of block to copy divided by 2 }
    shr     cx,1
    jnc     @@2
    rep     movsw
    movsb
    jmp @@3
@@2:
    rep     movsw
@@3:
    add     di,bx
    add     si,bx
    dec     ax
    jnz     @@1

    pop     es
    pop     ds
  end;
END;


 function HexW(W: word): string; {Word}
    const
      HexChars: array [0..$F] of Char = '0123456789ABCDEF';
    begin
      HexW :=
        HexChars[(W and $F000) shr 12] +
        HexChars[(W and $0F00) shr 8]  +
        HexChars[(W and $00F0) shr 4]  +
        HexChars[(W and $000F)];
    end;

  procedure OurExitProc; far;
   {If the program terminates with a runtime error before the extended memory}
   {is deallocated, then the memory will still be allocated, and will be lost}
   {until the next reboot.  This exit procedure is ALWAYS called upon program}
   {termination and will deallocate extended memory if necessary.            }
    var
      i: byte;
    begin
      for i := 0 to NumSounds-1 do
        if Sound[i] <> nil then FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
      ExitProc := OldExitProc; {Chain to next exit procedure}
    end;

procedure Init;

  begin
      if not(GetSettings(BaseIO, IRQ, DMA, DMA16)) then
      begin
        baseio:=xbaseio; irq:=xirq; dma:=xdma; dma16:=0;
      end;
      if not(InitSB(BaseIO, IRQ, DMA, DMA16)) then
      begin
        settext;
        writeln('Error initializing sound card');
        writeln('Incorrect base IO address, sound card not installed, or broken');
        writeln('Check your BLASTER= environmental value or re-run TBSETUP.');
        Halt(2); {Sound card could not be initialized}
      end;
      if not(InitXMS) then
      begin
            writeln('Error initializing extended memory');
            writeln('HIMEM.SYS must be installed');
            writeln('You might be better off by choosing no sound effects');
            writeln('In the TBSETUP program');
            Halt(3); {XMS driver not installed}
        end
        else
          begin
            if GetFreeXMS < XMSRequired
              then
                begin
                  writeln('Insufficient free XMS');
                  writeln('You might be better off by choosing no sound effects');
                  writeln('In the TBSETUP program.');
                  Halt(4); {Insufficient XMS memory}
                end
              else
                begin
                  if SharedEMB then InitSharing;
                  OpenSoundResourceFile('xmas96.snd');
                  LoadSound(Sound[0], 'HOHO');
                  LoadSound(Sound[1], 'JINGLE');
                  LoadSound(Sound[2], 'LAMB');
                  CloseSoundResourceFile;
                  OldExitProc := ExitProc;
                  ExitProc := @OurExitProc;
                end
          end;
      InitMixing;
    end;

  procedure Shutdownsb1;
    begin
      ShutdownMixing;
      ShutdownSB5;

      for i := 0 to NumSounds-1 do
        FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
      writeln;
    end;





Procedure SetUpVirtual;
   { This sets up the memory needed for the virtual screen }
BEGIN
  GetMem (VirScr,64000);
  vaddr := seg (virscr^);
  Getmem (Shapetable1,16000);
  shapeaddr:= seg (ShapeTable1^);
  shapeofs:=ofs (ShapeTable1^);
END;


Procedure ShutDown;
   { This frees the memory used by the virtual screen }
BEGIN
  FreeMem (VirScr,64000);
  FreeMem (ShapeTable1,16000);
END;



procedure opening;
begin
  fade;
  setmcga;
  graphresult:=Mode13LoadPicPacked(0,0,vga,true,false,'xmasopen.ppp');
  fade;
  graphresult:=Mode13LoadPicPacked(0,0,vga,false,true,'xmasopen.ppp');
  outtextxy('A',165,80,15,0,vga,false);
  outtextxy('CHRISTMAS',165,103,15,0,vga,false);
  outtextxy('PRODUCTION',165,113,15,0,vga,false);
  startsound(sound[1],0,false);
  unfade;
  if KEYPREFN then ch:=READKEFN;
  repeat until KEYPREFN;
  ch:=READKEFN;
  fade;
end;

procedure putshape(shapeoffset,towhere,xacross,yacross,xx,yy:word);
label bob,bob4,bob2,bob3;
begin
  asm
              {saves registers}
     push ds
     mov ax,[yy]     {multiplies y value by 320}
      shl ax,5
      mov cx,ax
      shl ax,1
      shl cx,3
      add ax,cx
      add ax,[xx]        {adds the x-value to get offset}
      mov di,ax
      mov bx,320
      sub bx,[xacross]   {xacross?}
      push bx
    mov bx,[yacross]
    xor dx,dx
      mov ax,[shapeaddr]     {moves segment of array}
      mov ds,ax
      mov ax,[shapeoffset]     {moves offsett if array}
      {add ax,[shapeofs]}
      mov si,ax
      mov ax,[towhere]        {loads place to move it}
      mov es,ax
      xor ax,ax
      xor cx,cx
      xor dx,dx
    bob:
      mov cx,[xacross]        {how long to loop across (the x-size of array)}
    bob4:
      xor ah,ah
      lodsb
      cmp ax,0               {If zero skip, if not, store value}
      jz bob2
      stosb
      dec di
    bob2:                    {Adds when x-value must be increased}
      inc di
      loop bob4
      cmp dx,bx
      jz bob3
      xor cx,cx
      pop ax
      add di,ax
      push ax
      inc dx
      jmp bob
  bob3:
    pop bx                  {restore variables}
    pop ds
  end;
end;





procedure sheep;
begin
  fade;
  cls(0,vga);
  cls(0,vaddr);
{***********loadsheeppic and palette************}
   graphresult:=Mode13LoadPicPacked(0,0,vaddr,false,true,'shepherd.ppp');
   graphresult:=Mode13LoadPicPacked(0,0,vga,false,true,'sheep.ppp');
   unfade;

  numtimes:=0;
  repeat
    repeat until KEYPREFN;
    if KEYPREFN then ch:=READKEFN;
       if (ch=' ') then begin
          inc(numtimes);
          if numtimes=1 then outtextxy('BAAA',70,150,32,0,vga,false);
          if numtimes=2 then outtextxy('BAAA',200,145,40,0,vga,false);
          if numtimes=3 then outtextxy('BAAA',205,150,47,0,vga,false);
          if numtimes=4 then outtextxy('PRESS ENTER TO CONTINUE',66,185,47,0,vga,false);
          if numtimes=6 then numtimes:=5;
          startsound(sound[2],0,false);
        end;
   until (ch=#13) and (numtimes>3);
   for i:=0 to 63 do begin
       pal(0,0,0,i);
       vdelay(2);
   end;
   pal(0,63,63,63); vdelay(10);

   blockmove(95,0,100,10,vaddr,95,45,vga);

   line(103,50,319,50,3,vga);
   line(0,50,95,50,3,vga);
   pal(0,0,0,0);
   vdelay(10);
   line(103,50,319,50,0,vga);
   line(0,50,95,50,0,vga);
   vdelay(50);
   blockmove(0,0,70,70,vaddr,210,60,vga);

   readln;
   outtextxy('Merry Christmas',10,10,9,0,vga,false);
   readln;

end;

procedure santa;
begin
  fade;
  graphresult:=Mode13LoadPicPacked(0,0,vaddr,false,true,'santa.ppp');
  for i:=0 to 60 do
       for j:=0 to 9 do begin
           ShapeTable1^[((j*60)+i)]:=getpixel(i+94,j+31,vaddr);
           ShapeTable1^[1000+((j*60)+i)]:=getpixel(i+94,j+44,vaddr);
       end;
  fillblock(94,31,154,53,0,vaddr);
  flip(vaddr,vga);

{procedure putshape(shapeoffset,towhere,xacross,yacross,xx,yy:word);}
  putshape(0,vga,60,9,0,34);
  unfade;
  x:=0;
  q:=0;
  repeat
    inc(x);
    inc(q);
    ch:='!';
    if KEYPREFN then ch:=READKEFN;
    if ch=' ' then startsound(sound[0],0,false);
    if ch=#13 then startsound(sound[1],0,false);
    if ch=#27 then x:=222;
    blockmove(x,34,x+60,44,vaddr,x,34,vga);
    inc(x);
    putshape((q mod 2)* 1000,vga,60,9,x,34);
    vdelay(10);
  until x>220;
  blockmove(x,34,x+60,44,vaddr,x,34,vga);
  outtextxy('Merry Christmas',10,10,9,0,vga,false);
  repeat until KEYPREFN;
end;





procedure menu;
begin
   cls(0,vga);
   unfade;

   if firstime then begin
      firstime:=false;
      j:=0;
      repeat
        if j<7 then outtextline('A VMW CHRISTMAS - 1996',80,80,4,0,j,vga);
        Move (mem[vga:320],mem[vga:0],25920);
        inc(j);
      until j=40;
   end
   else outtextxy('A VMW CHRISTMAS - 1996',80,40,4,0,vga,true);

   if KEYPREFN then ch:=READKEFN;
   outtextxy('PRESS:',0,80,12,0,vga,false);
   outtextxy('   1 : TO RUN BETHLEHEM SCENE',0,90,10,0,vga,false);
   outtextxy('   2 : TO RUN SANTA CLAUS SCENE',0,100,10,0,vga,false);
   outtextxy('   Q : TO QUIT TO DOS',0,110,10,0,vga,false);
   outtextxy('INSTRUCTIONS:',0,130,11,0,vga,false);
   outtextxy('   PRESS SPACEBAR TO MAKE THINGS HAPPEN',0,140,3,0,vga,false);
   outtextxy('   PRESS ESC TO RETURN TO THIS MENU',0,150,3,0,vga,false);
   outtextxy('BLASTER VARIABLE MUST BE SET FOR SOUND',0,180,1,0,vga,false);
end;


begin
  firstime:=true;
  ch2:='!';
  setuptb1;
  ReadConfigFile;
  if sbsound then init;
  setupvirtual;
  opening;
  while (ch2<>'Q') and (ch2<>'q') do begin
     menu;
     if KEYPREFN then ch2:=READKEFN;
     repeat
       repeat until KEYPREFN;
       ch2:=READKEFN;
     until (ch2='Q') or (ch2='q') or (ch2='1') or (ch2='2');
     if ch2='1' then sheep;
     if ch2='2' then santa;
  end;
  shutdown;
  settext;
end.