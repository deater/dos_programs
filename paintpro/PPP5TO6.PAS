program grtest6;
{$G+}
uses svmwgraph,nvmwgraph,crt;

var i:integer;
    error:byte;
    ch:char;

begin
   if paramcount<>2 then begin
      writeln; writeln('Usage:  ppp5to6 oldfile newfile');
      writeln; halt(0);
   end;
   setmcga;

   error:=loadpicsuperpacked(0,0,vga,true,true,paramstr(1));
   error:=mode13savepicpacked(0,0,320,200,256,vga,paramstr(2));
   if error=0 then begin
      {repeat ch:=readkey until not(keypressed);}
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
    end;
end.