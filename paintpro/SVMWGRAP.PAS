unit SVmwGraph;  {Super Vmw Graphics Unit}
{$X+}{$G+}


INTERFACE

function Mode13SavePicPacked(x1,y1,x2,y2,numcolors:integer;where:word;filename:string):byte;
function Mode13LoadPicPacked(x1,y1:integer;where:word;LoadPal,LoadPic:boolean;FileName:string):byte;

{Errors:  0=No Errors
          1=File Not Found
          2=Not a Paintpro File (no PAINTPROVX.XX header)
          3=Improper Version (less then 6)
}
IMPLEMENTATION

uses nvmwgraph;


function Mode13SavePicPacked(x1,y1,x2,y2,numcolors:integer;where:word;filename:string):byte;

{**** Saves an image, with corners x1,y1 and x2,y2
      and number of colors NUMCOLORS, and at segment
      where ($A000 for vga) to the paintpro file
      filename ****}
    {x2 y2 should be plus one (320,200 not 319,199}

var buffer:array[0..2] of byte;
    header:string[15];
    f:file;
    col,x,y,xsize,ysize,i,oldcol,numacross:integer;
    byte1,byte2,byte3,temp:byte;
    r,g,b:byte;
    second1,zz:integer;

procedure integer23bytes(inter1,inter2:integer);
var temp1,temp2,temp3:integer;
    temp:byte;
begin
  {asm
    mov ax,inter1
    shl ax,1
      shl ax,1        this assembly will accomplish
      shl ax,1        what the below will.  Basically
      shl ax,1        it takes two, 16 bit integers,
    mov temp1,ah      strips off the top 4 bits of each,
    sub ah,ah         (makin two, 12 bit integers) and
    shr ax,1          joins these into three 8 bit bytes
      shr ax,1
      shr ax,1         for this assmebly to work, however
      shr ax,1        temp1,temp2, etc must be byte, not
    mov temp,al       integer
    mov ax,inter2
    mov temp3,al
    shr ax,1
      shr ax,1
      shr ax,1
      shr ax,1
    mov ah,temp
    shl ax,1
      shl ax,1        in the below, shl is shift left
      shl ax,1           (in C the equivelant is <<)
      shl ax,1        and shr is shift right ( >> )
    mov temp2,ah
  end;

  }
  temp1:=(inter1  AND $7FFF);
  temp1:=temp1 shr 4;
  temp3:=(inter2 AND $7FFF);
  temp2:= ((inter1 and $000F) shl 4)+ ((inter2 AND $0F00) shr 8);

    buffer[0]:=temp1;
    buffer[1]:=temp2;
    buffer[2]:=temp3;
    blockwrite(f,buffer,1);
end;


begin
  Mode13SavePicPacked:=0;    {*Clear the errors}
  assign(f,filename);        {*Open the file}
  {$I-}
   rewrite(f,3);             {*Turn off i/o and open file}
  {$I+}
   if Ioresult<>0 then Mode13SavePicPacked:=1;
   if Ioresult<>0 then exit;    {*If error, file not found}
   header:='PAINTPROV6.0';
  for i:=0 to 3 do begin        {*Write header}
      buffer[0]:=ord(header[(i*3)+1]);
      buffer[1]:=ord(header[(i*3)+2]);
      buffer[2]:=ord(header[(i*3)+3]);
      blockwrite(f,buffer,1);
  end;

  xsize:=abs(x2-x1);             {*Write xsize and ysize}
  ysize:=abs(y2-y1);
  integer23bytes(xsize,ysize);
  integer23bytes(numcolors,0);   {*Write number of colors and a blank}

  for i:=0 to (numcolors-1) do    {*Save the pallete (24 bit, rgb)}
  begin
      getpal(i,buffer[0],buffer[1],buffer[2]);
      buffer[0]:=buffer[0]* 4;    {*Multiplied by 4 because}
      buffer[1]:=buffer[1] * 4;   {mode 13h is only 18 bit}
      buffer[2]:=buffer[2] * 4;
      blockwrite(f,buffer,1);
  end;
  zz:=(y2-y1);
  y:=y1;
  numacross:=0;                          {this does RLE encoding}
  second1:=0;                            {see doc file}
  oldcol:=getpixel(x1,y,where);
  while y<=y2 do begin
        x:=x1;
        while x<=x2 do begin
              col:=getpixel(x,y,where);
              if (col=oldcol) and (numacross<2046) then inc(numacross)
              else begin                        {*compresses 1 color stretches}
                   if numacross=1 then begin
                      if second1=0 then begin
                         second1:=oldcol+2048;
                      end
                      else begin
                           integer23bytes(second1,oldcol+2048);
                           second1:=0;
                      end

                   end
                   else begin
                        if second1<>0 then
                        integer23bytes(second1-2048,1);
                        integer23bytes(oldcol,numacross);
                        second1:=0;
                   end;
                   numacross:=1;
              end;
              inc(x);
              oldcol:=col;
        end;
        inc(y);
  end;
      integer23bytes(col,numacross);

  close(f);
end;






function Mode13LoadPicPacked(x1,y1:integer;where:word;LoadPal,LoadPic:boolean;FileName:string):byte;

{*Loads a paintpro image, filename, at location x1,y1
  to offset where (vga=$A000) and loadspal if LOADPAL=true
  Loadsapicture if Loadpic=true and returns error}

var buffer:array[0..299] of byte;
    result,buffpointer:integer;
    f:file;
    col,x,y,xsize,ysize,i,oldcol,
    numcolors,tempint1,tempint2,numacross:integer;
    header:string;
    lastread:boolean;
    tempbyte,r,g,b:byte;


procedure sixbytes2twoint;

var temp1,temp2,temp3:byte;
    int1,int2:integer;

begin
  temp1:=buffer[buffpointer];
  temp2:=buffer[buffpointer+1];
  temp3:=buffer[buffpointer+2];
  inc(buffpointer,3);
  if (buffpointer>=result) then
     if (result=300) then begin
        blockread(f,buffer,300,result);
        buffpointer:=0;
     end
     else lastread:=true;
  asm
    mov ah,temp1          {splits 3 bytes (24 bits)}
    mov al,temp2          {into two 12 bit integers}
    shr ax,4              {and then pads them into}
    mov int1,ax          {two 16 bit integers}
    mov ah,temp2
    mov al,temp3
    shl ah,4
    shr ah,4
     mov int2,ax
  end;
  tempint1:=int1;
  tempint2:=int2;
end;



begin
  lastread:=false;
  Mode13LoadPicPacked:=0;     {*Clear errors}
  header:='';
  buffpointer:=0;
  assign(f,filename);
  {$I-}
    reset(f,1);             {*Check that file is there}
  {$I+}
  if IOresult<>0 then begin       {*Error if not}
     Mode13LoadPicPacked:=1;
  end
  else begin

  blockread(f,buffer,300,result);

  for i:=1 to 9 do header:=concat(header,chr(buffer[i-1]));


  if header<> 'PAINTPROV' then Mode13LoadPicPacked:=2;
  if header<> 'PAINTPROV' then exit;    {*Error if not Paintpro header}

  header:='';

  header:=concat(header,chr(buffer[9]),chr(buffer[10]),chr(buffer[11]));

  if header<>'6.0' then Mode13LoadPicPacked:=3;   {*Error if wron version}
  if header<>'6.0' then exit;
  buffpointer:=12;

  sixbytes2twoint;
  xsize:=tempint1;
  ysize:=tempint2;
  sixbytes2twoint;
  numcolors:=tempint1;



  for i:=0 to (numcolors-1) do begin
      r:=(buffer[buffpointer] div 4);
      g:=(buffer[buffpointer+1] div 4);
      b:=(buffer[buffpointer+2] div 4);
  inc(buffpointer,3);
  if (buffpointer>=result) then
     if (result=300) then begin
        blockread(f,buffer,300,result);
        buffpointer:=0;
     end
     else

     lastread:=true;
  if loadpal then pal(i,r,g,b);
  end;



  


  x:=x1;
  y:=y1;
if loadpic=true then begin
   while (lastread=false) do begin
     sixbytes2twoint;

      if tempint1>2047 then begin
         putpixel(x,y,(tempint1-2048),where);
         inc(x);
         if x>=xsize+x1+1 then begin
            x:=x1; inc(y); end;
         putpixel(x,y,(tempint2-2048),where);
         inc(x);
         if x>=xsize+x1+1 then begin
            x:=x1; inc(y); end;
      end

      else begin
          col:=tempint1;
          numacross:=tempint2;
     while ((x+numacross)>=(xsize+x1+1)) do begin
           horizontalline(x,x1+xsize,y,col,where);
           numacross:=numacross-((xsize+1)-x);
           x:=x1;
           inc(y);
     end;
     if numacross<>0 then horizontalline(x,x+numacross,y,col,where);
       x:=x+numacross;

   end;
   end;
end;
close(f);
end;
end;

begin
   {if paramcount<>2 then begin
      writeln; writeln('Usage:  ppp5to6 oldfile newfile');
      writeln; halt(0);
   end;
   setmcga;

   error:=loadpicsuperpacked(0,0,vga,true,true,paramstr(1));
   error:=savepic6superpacked(0,0,319,199,256,vga,paramstr(2));
   if error=0 then begin
      repeat ch:=readkey until not(keypressed);
      repeat until keypressed;
      ch:=readkey;
      settext;
   end
   else begin
     settext;
     case error of
        1:writeln('File Not Found');
        2:writeln('Not a Paintpro File');
        3:writeln('Incorrect Paintpro Version');
     end;
    end;}
end.