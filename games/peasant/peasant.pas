program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02,cga;

{$I pq_vid.pas}
{$I pq_title.pas}
{$I pq_ker1.pas}
{$I pq_knght.pas}
{$I pq_ytree.pas}
{$I pq_inn.pas}


(* type ScreenType = array [0..16384] of byte;  {For Graphics Loading} *)

(* Type
SpriteArray = array[0..241] of char;
SpritePtr = ^SpriteArray;
*)

{$I s_walk.pas}


const WalkingSprites : array[0..23] of SpritePtr =
(
	{0 = up}

	@walk_u0_sprite,@walk_u1_sprite,@walk_u2_sprite,
	@walk_u3_sprite,@walk_u4_sprite,@walk_u5_sprite,

	{1 = right}

	@walk_r0_sprite,@walk_r1_sprite,@walk_r2_sprite,
	@walk_r3_sprite,@walk_r4_sprite,@walk_r5_sprite,

	{2 = left}

	@walk_l0_sprite,@walk_l1_sprite,@walk_l2_sprite,
	@walk_l3_sprite,@walk_l4_sprite,@walk_l5_sprite,

	{3 = down}

	@walk_d0_sprite,@walk_d1_sprite,@walk_d2_sprite,
	@walk_d3_sprite,@walk_d4_sprite,@walk_d5_sprite

);


var 
	background,offscreen:buffer_ptr;

	screen:screentype absolute $B800:0000;
	level_over,frame,flame_count:byte;
	visited_0,visited_1,visited_2:byte;
	peasant_x,peasant_y:byte;
	peasant_xadd,peasant_yadd:integer; { signed }
	peasant_dir,peasant_steps:byte;
	ch:char;
	i:word;
	input_x:byte;

(*
CONST cga = $b800;

{ BH = page number,
  DH = row (0 top)
  DL = col (0 top)
}

{ ShapeTable = Array [0..16000] of byte; }





{***********************************************}
{ screen_copy                                   }
{***********************************************}

Procedure screen_copy(dest,src:buffer_ptr);

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

		mov	ax,cga
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

	mem[cga:offset]:=0;

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

*)

Procedure reset_prompt;

begin
	input_x:=0;
	PrintCharXor('>',input_x,24);	
	input_x:=2;
end;


Procedure check_keyboard;

var
	ch,ch2:char;

begin
	{ drain keyboard buffer}

	if keypressed=false then exit;

	ch:=readkey;

	if ch=chr(0) then begin
		ch2:=readkey;

		case ch2 of

			'M':	begin	{ right }

				{ if already moving right, stop}
				if peasant_xadd = 1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving right, start moving right}
				else begin
					peasant_xadd:=1;
					peasant_yadd:=0;
				end;

				peasant_dir:=1; { PEASANT_DIR_RIGHT}

				end;

			'K':	begin	{ left }

				{ if already moving left, stop}
				if peasant_xadd = -1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving left, start moving left}
				else begin
					peasant_xadd:=-1;
					peasant_yadd:=0;
				end;

				peasant_dir:=2; { PEASANT_DIR_LEFT}

				end;

			'H':	begin	{ up }

				{ if already moving up, stop}
				if peasant_yadd = -1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving up, start moving up}
				else begin
					peasant_xadd:=0;
					peasant_yadd:=-1;
				end;

				peasant_dir:=0; { PEASANT_DIR_UP}

				end;

			'P':	begin	{ down }

				{ if already moving down, stop}
				if peasant_yadd = 1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving down, start moving down}
				else begin
					peasant_xadd:=0;
					peasant_yadd:=1;
				end;

				peasant_dir:=3; { PEASANT_DIR_DOWN}

				end;




		end;
	end

	{ all other keys }
	else begin
		{hgr_input}

		PrintCharXor(ch,input_x,24);
		input_x:=input_x+1;

	end;                   

end;

Procedure move_peasant;

begin
	if (peasant_xadd<>0) or (peasant_yadd<>0) then begin

		{ moving }

		peasant_steps:=peasant_steps+1;
		if (peasant_steps>=6) then peasant_steps:=0;

		peasant_x:=peasant_x+peasant_xadd;
		peasant_y:=peasant_y+peasant_yadd;
	end;

	
end;

(*
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
*)

Procedure draw_peasant;

var which : byte;

begin

	which := (peasant_dir*6)+peasant_steps;

	SpriteXY(peasant_x,peasant_y,WalkingSprites[which]);
end;


{************************************}
{ do_knight                          }
{************************************}

Procedure do_knight(mode: byte);

label done_knight;

begin
	level_over:=0;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	{ decompress priority }

	{ load bg }

	decompress(background,@PQ_KNIGHT);

	{* decompress(@screen,@PQ_KNIGHT); *}
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',25,0);

	reset_prompt;
	
	{ move knight }

	visited_1:=visited_1 or 16;	{ MAP_MOUNTAIN_PASS}

	while(true) do begin

		{ check_keyboard }

		check_keyboard;

		{ move_peasant }

		move_peasant;

		if level_over <> 0 then goto done_knight;

		{ update screen }

		screen_copy(@screen,screen_ptr(background));

		draw_peasant;
		
		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ wait vblank }

		wait_vsync;

		{ page  flip }		

	end;

done_knight:

	repeat until keypressed;
	ch:=readkey;
end;






begin
	{Set CGA mode 4}

	SetCGAMode(4);

	SetPalette(1);

	decompress(@screen,@PQ_VID);
	repeat until keypressed;
	ch:=readkey;

	SetPalette(0);			{ cyan palette }

	decompress(@screen,@PQ_TITLE);
	repeat until keypressed;
	ch:=readkey;

	SetPalette(1);			{ yellow palette }


	{*****************}
	{ allocate memory }
	{*****************}

	GetMem(background,16384);
	

	{****************}
	{ init variables }
	{****************}

	peasant_x:=100;
	peasant_y:=100;
	peasant_xadd:=0;
	peasant_yadd:=0;
	peasant_dir:=0;
	peasant_steps:=0;
	input_x:=0;

	do_knight(0);

	decompress(@screen,@PQ_YTREE);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',25,0);

	repeat until keypressed;
	ch:=readkey;

	SetPalette(0);

	repeat until keypressed;
	ch:=readkey;


	decompress(@screen,@PQ_INN);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',24,0);

{	SpriteXY(8,100); }

	for i:=0 to 10 do begin
		PutPixelXY(0,50+i);
	end;

	repeat until keypressed;
	ch:=readkey;

	{ Restore Text Mode}
	SetCGAMode(3);

end.
