program writetodisk;
uses nvmwgraph,dos;
type
   arraytype=array[0..64000] of byte;
   array2type=array[0..2,0..255] of byte;
var image:^array2type;
    picture:^arraytype;
    i:longint;
    pntr:pointer;
    screenfile:text;
    filename:string;
    x,y:integer;
    error:byte;
begin
  getintvec($3A,pntr);
  image:=pntr;
  getintvec($3B,pntr);
  picture:=pntr;

  write('What filename to save as? ');
  readln(filename);
  setmcga;
  for x:=0 to 319 do
      for y:=0 to 199 do
          putpixel(x,y,picture^[(y*320)+x],vga);
  for i:=0 to 255 do
      pal(i,image^[0,i],image^[1,i],image^[2,i]);
  error:=savepicsuperpacked(0,0,319,199,256,vga,filename);
  settext;
end.