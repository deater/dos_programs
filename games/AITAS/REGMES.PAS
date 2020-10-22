uses crt;
{$I c:\pascal\aitas\register.pas}
type screentype = array [0..3999] of byte;
var screen:screentype absolute $B800:0000;

begin
   move(imagedata,screen,4000);
   gotoxy(1,23);
end.