program writetodisk;
uses dos;
type
   arraytype=array[0..64000] of byte;
var image:^word;
    picture:^arraytype;
    i:longint;
    pntr:pointer;
    screenfile:text;
    filename:string;
begin
  getintvec($3A,pntr);
  image:=pntr;
  getintvec($3B,pntr);
  picture:=pntr;
  filename:='PIC1.pic';
  assign(screenfile,filename);
  {$I-}rewrite(screenfile); {$I+}
  for i:=0 to 64000 do writeln(screenfile,picture^[i]);
  close(screenfile);
end.