program test;

uses crt;

type ScreenType = array [0..16384] of byte;  {For Graphics Loading}

        buffer = Array [0..16383] of byte;
        buffer_ptr = ^buffer;

var 
	background,offscreen:buffer_ptr;

	screen:buffer absolute $B800:0000;

CONST cga = $b800;


{***********************************************}
{ screen_copy                                   }
{***********************************************}

{ Procedure screen_copy(dest,src:buffer_ptr); }

Procedure screen_copy(dest,src:buffer_ptr); 

var
	dest_seg,dest_off,src_seg,src_off : word;

begin
	dest_seg:=seg(dest);
	dest_off:=ofs(dest);


{	dest_seg:=seg(dest);
	dest_off:=ofs(dest); 
	src_seg:=seg(src);
	src_off:=ofs(src);
}


	write('dest_seg=');
	writeln(seg(dest^));
	write('dest_off=');
	writeln(ofs(dest^));

{
	write('src_seg=');
	writeln(src_seg);
	write('src_off=');
	writeln(src_off);
}

end;




begin

	{*****************}
	{ allocate memory }
	{*****************}

	GetMem(background,16384);
	

	screen_copy(@screen,@screen);

end.
