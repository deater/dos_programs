{ Some CGA routines }

UNIT cga;

INTERFACE

type
	ScreenType = array [0..16383] of byte;
        screen_ptr = ^ScreenType;


	SpriteArray = array[0..241] of char;
	SpritePtr = ^SpriteArray;

Procedure PrintChar(which: char);
Procedure PrintCharXor(which: char;x,y:word);
Procedure SpriteXY(x,y: word; sprite: SpritePtr; framebuffer: screen_ptr);
Procedure PrintStringXor(st:string;x,y:word);
Procedure screen_copy(dest,src:screen_ptr);
Procedure screen_update(dest,src:screen_ptr);
Procedure wait_vsync;
Procedure SetCGAMode(Mode: byte);
Procedure SetPalette(which: byte);
Procedure PutPixelXY(x,y: word);
Procedure RestoreBG(x,y,xsize,ysize: word; bg, fb: screen_ptr);
Procedure Rectangle(x,y,xsize,ysize: word; color: byte; fb: screen_ptr);

IMPLEMENTATION


var 

	screen:screentype absolute $B800:0000;

CONST cga_addr = $b800;


{***********************************************}
{ screen_copy                                   }
{***********************************************}

Procedure screen_copy(dest,src:screen_ptr);

var
	dest_seg,dest_off,src_seg,src_off : word;

begin
	dest_seg:=seg(dest^);
	dest_off:=ofs(dest^);
	src_seg:=seg(src^);
	src_off:=ofs(src^);

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,8192
		rep	movsw

		pop	es
		pop	ds

	end;

end;


{***********************************************}
{ screen_update                                 }
{***********************************************}
{ Only update middle (graphics) part of screen) }
{  skipping title and text entry area           }

{ From line 10 to line 190                      }
{ so offset 400 to 7600  (190*80)/2             }
{ 7200 bytes, /2 = 3600                         }

Procedure screen_update(dest,src:screen_ptr);

var
	dest_seg,dest_off,src_seg,src_off : word;

begin
	dest_seg:=seg(dest^);
	dest_off:=ofs(dest^);
	src_seg:=seg(src^);
	src_off:=ofs(src^);

	src_off:=src_off+400;

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,400		{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,3600

		rep	movsw

		pop	es
		pop	ds

	end;

	src_off:=src_off+8192;

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,8592		{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,3600

		rep	movsw

		pop	es
		pop	ds

	end;


end;




{***********************************************}
{ SpriteXY                                      }
{***********************************************}

{ assume 8 pixels wide for now }
{ also assume always writing to even Y }

{
	x,y,x*y
	sprite_even:	x*y bytes
	sprite_odd:	x*y bytes
	mask_even:
	mask_odd:


	want to load background
	and with mask
	or with sprite
	store back to background

	needs 3 pointers!
		es:di = destination
		ds:si = source (sprite)
		ds:[bx][si] = source (mask)

}


Procedure SpriteXY(x,y: word; sprite: SpritePtr; framebuffer: screen_ptr);

var	even_offset,odd_offset,mask_offset,width,height:word;
	xsize,ysize,s_seg,s_off,f_seg,f_off:word;

label even_loopy,even_loopx;
label odd_loopy,odd_loopx;

begin
	f_seg:=seg(framebuffer^);
	f_off:=ofs(framebuffer^);

	s_seg:=seg(sprite^);
	s_off:=ofs(sprite^)+2;

	even_offset:=((y div 2)*80)+(x div 4);
	even_offset:=even_offset+f_off;
	odd_offset:=even_offset+$2000;

	xsize:=Word(sprite^[0]);
	ysize:=Word(sprite^[1]);

	mask_offset:=xsize*ysize*2;

	asm

		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]
		mov	es,ax
		mov	di,[even_offset]	{; es:di = destination}

		mov	ax,[s_seg]
		mov	ds,ax
		mov	si,[s_off]	{; ds:si = source}

		mov	bx,[mask_offset]

		mov	dx,[ysize]

even_loopy:
		mov	cx,[xsize]
even_loopx:

		mov	al,es:[di]
		and	al,ds:[si][bx]
		or	al,ds:[si]
		inc	si
		stosb

		loop	even_loopx

		add	di,(80-4)

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[odd_offset]	{; es:di = destination}

		mov	dx,[ysize]

odd_loopy:
		mov	cx,[xsize]
odd_loopx:

		mov	al,es:[di]
		and	al,ds:[si][bx]
		or	al,ds:[si]
		inc	si
		stosb

		loop	odd_loopx

		add	di,(80-4)

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;

{==================================}
{ Rectangle                        }
{==================================}

Procedure Rectangle(x,y,xsize,ysize: word; color: byte; fb: screen_ptr);

var
	f_seg,f_off,dest_off,dest_odd_off,nextline:word;

label even_loopy;
label odd_loopy,odd_loopx;

begin
	ysize:=ysize div 2; {FIXME: only works if Y is even }


	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	dest_off:=((y div 2)*80)+(x div 4);
	dest_off:=dest_off+f_off;

	dest_odd_off:=dest_off+$2000;

	nextline:=80-xsize;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	al,[color]
		mov	dx,[ysize]
even_loopy:
		mov	cx,[xsize]
		rep	stosb

		add	di,[nextline]

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}

		mov	dx,[ysize]
odd_loopy:
		mov	cx,[xsize]
		rep	stosb

		add	di,[nextline]

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;

{==================================}
{ RestoreBG                        }
{==================================}


Procedure RestoreBG(x,y,xsize,ysize: word; bg, fb: screen_ptr);

var
	b_seg,b_off,f_seg,f_off,src_off,dest_off,dest_odd_off,src_odd_off:word;

label even_loopy;
label odd_loopy;

begin
	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	b_seg:=seg(bg^);
	b_off:=ofs(bg^);

	src_off:=((y div 2)*80)+(x div 4);
	dest_off:=src_off;

	src_off:=src_off+b_off;
	dest_off:=dest_off+f_off;
	dest_odd_off:=dest_off+$2000;
	src_odd_off:=src_off+$2000;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	ax,[b_seg]	{; source is background}
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	dx,[ysize]
even_loopy:
		mov	cx,[xsize]
		rep	movsb

		add	di,(80-4)	{FIXME: hardcoded}
		add	si,(80-4)

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}
		mov	si,[src_odd_off]

		mov	dx,[ysize]
odd_loopy:
		mov	cx,[xsize]
		rep	movsb

		add	di,(80-4)
		add	si,(80-4)

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;


{==================================}
{ PutPixelXY                       }
{==================================}

Procedure PutPixelXY(x,y: word);

var offset,width,height:word;

begin

	offset:=((y div 2)*80)+(x div 4);

	if (y mod 2 = 1) then offset:=offset+8192;

	mem[cga_addr:offset]:=0;

end;



Procedure GotoXY(x,y: byte);
begin
	asm
		mov	bh,0
		mov	dl,x
		mov	dh,y
		mov	ah,2
		int	10h
	end;
end;

{ AL = character
  BH = page number?
  BL = foreground color
}

Procedure PrintChar(which: char);
begin
	asm
		mov	al,which
		mov	ah,0eh
		mov	bh,0
		mov	bl,0
		int	10h
	end;
end;

{ al = char
  bh = page num
  bl = color (bit 7 means xor)
  cx = number of times
}

Procedure PrintCharXor(which: char;x,y:word);
begin
	GotoXY(x,y);

	asm
		mov	al,which
		mov	ah,09h
		mov	bh,0
		mov	bl,131
		mov	cx,1
		int	10h
	end;
end;

Procedure PrintStringXor(st:string;x,y:word);

var i:word;

begin
	for i:=1 to length(st) do begin
		PrintCharXor(st[i],(i-1)+x,y);
	end;
end;

{
  BH = 0
  BL = background/border color
}

Procedure SetBackground(color: byte);
begin
	asm
		mov	ah,0bh
		mov	bh,0
		mov	bl,color
		int	10h
	end;
end;

{
  BH = 01h
  BL = palette (00=g/r/b, 01=c/m/w)
}

Procedure SetPalette(which: byte);
begin
	asm
		mov	bh,1
		mov	bl,which
		mov	ah,0bh
		int	10h
	end;
end;

Procedure SetCGAMode(Mode: byte);
begin
	asm
		mov	ah,0
		mov	al,Mode
		int	10h
	end;
end;

Procedure wait_vsync;

label	wait_retrace,wait_next;

begin
	{ wait for retrace }

	asm
		mov	dx,3dah
wait_retrace:
		in	al,dx
		test	al,8
		jz	wait_retrace
wait_next:
		in	al,dx
		test	al,8
		jnz	wait_next
	end;
end;

end.
