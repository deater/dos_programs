program grtest6;
{$G+}
uses svmwgraph,nvmwgraph,crt;

var i:integer;
    error:byte;
    ch:char;

begin

   if paramcount<>1 then begin
      writeln; writeln('Usage:  pppview filename');
      writeln; halt(0);
   end;
   setmcga;
   error:=mode13loadpicpacked(0,0,vga,true,true,paramstr(1));
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