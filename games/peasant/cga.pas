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
Procedure SpriteXY(x,y: word; sprite: SpritePtr);
Procedure PrintStringXor(st:string;x,y:word);
Procedure screen_copy(dest,src:screen_ptr);
Procedure wait_vsync;
Procedure SetCGAMode(Mode: byte);
Procedure SetPalette(which: byte);
Procedure PutPixelXY(x,y: word);

IMPLEMENTATION


var 
	background,offscreen:screen_ptr;

	screen:screentype absolute $B800:0000;
	level_over,frame,flame_count:byte;
	visited_0,visited_1,visited_2:byte;
	peasant_x,peasant_y:byte;
	peasant_xadd,peasant_yadd:integer; { signed }
	peasant_dir,peasant_steps:byte;
	ch:char;
	i:word;
	input_x:byte;

CONST cga_addr = $b800;

{ BH = page number,
  DH = row (0 top)
  DL = col (0 top)
}


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
		mov	di,0		{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,8192
		{ mov	ax,65535 }
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


Procedure SpriteXY(x,y: word; sprite: SpritePtr);

var	even_offset,odd_offset,mask_offset,width,height:word;
	xsize,ysize,s_seg,s_off:word;

label even_loopy,even_loopx;
label odd_loopy,odd_loopx;

begin
	s_seg:=seg(sprite^);
	s_off:=ofs(sprite^)+2;

	even_offset:=((y div 2)*80)+(x div 4);
	odd_offset:=even_offset+$2000;

	xsize:=Word(sprite^[0]);
	ysize:=Word(sprite^[1]);

	mask_offset:=xsize*ysize*2;

	asm

		{; even first }

		push	ds
		push	es

		mov	ax,cga_addr
		mov	es,ax
		mov	di,even_offset	{; es:di = destination}

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

		mov	di,odd_offset	{; es:di = destination}

		{add	si,[mask_offset] }

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
