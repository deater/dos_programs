program pcx2ppp;
uses nvmwgraph,svmwgraph;

var f:file of byte;
    r,g,b,error:byte;
    i,j:integer;
    x,y,col,numacross:integer;

begin
  if paramcount<>2 then begin
     writeln('usage: pcx2ppp file.pcx file.ppp');
     writeln;
     writeln('You should only use this on 320x200');
     writeln('256 color PCX files.');
  end
  else begin


  assign(f,paramstr(1));
{$I-}
  reset(f);
  close(f);
{$I+}
  if ioresult<>0 then writeln('Cannot read file ',paramstr(1))
  else begin
   reset(f);
    setmcga;
  for i:=0 to 127 do begin
      read(f,b);
  end;

  i:=0;
  x:=0; y:=0;
  while(y<=200) do begin
     read(f,b);
     if ((b>=192) and (b<=255)) then begin
        numacross:=b-192;
        read(f,b);
        for j:=x to x+numacross do begin
            putpixel(j,y,b,vga);
        end;
        x:=x+numacross;
     end
     else begin
          putpixel(x,y,b,vga);
          inc(x);
     end;
     if x>319 then begin x:=0; inc(y); end;
   end;

   seek(f,filesize(f)-768);
   for i:=0 to 255 do begin
       read(f,r);
       read(f,g);
       read(f,b);
       pal(i,r div 4,g div 4,b div 4);
   end;
  close(f);
  error:=mode13savepicpacked(0,0,320,200,256,vga,paramstr(2));
  readln;
  settext;
  if error<>0 then writeln('Could not open file',paramstr(2),'.');
  end;
  end;
end.