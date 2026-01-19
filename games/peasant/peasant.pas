program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02;

{$I pq_vid.pas}
{$I pq_title.pas}
{$I pq_ker1.pas}
{$I pq_knght.pas}
{$I pq_ytree.pas}
{$I pq_inn.pas}

type ScreenType = array [0..16384] of byte;  {For Graphics Loading}

var 
	screen:screentype absolute $B800:0000;
	level_over,frame,flame_count:byte;
	visited_0,visited_1,visited_2:byte;
	peasant_x,peasant_y:byte;
	peasant_xadd,peasant_yadd:byte;
	peasant_dir,peasant_steps:byte;
	ch:char;
	i:word;
	input_x:byte;


CONST cga = $b800;

{ BH = page number,
  DH = row (0 top)
  DL = col (0 top)
}

{ assume 8 pixels wide for now }

Procedure SpriteXY(x,y: word);

var boffset,width,height:word;
label loopy;

begin
	boffset:=((y div 2)*80)+(x div 4);

	asm

		push	ds
		push	es
		mov	ax,cga
		mov	es,ax
		mov	di,boffset

		mov	dx,20
loopy:
		mov	ax,0
		mov	cx,4
		rep stosb
		
		add	di,(80-4)

		dec	dx
		jne	loopy

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
		if (peasant_steps>=0) then peasant_steps:=0;

		peasant_x:=peasant_x+peasant_xadd;

	end;

	
end;

Procedure draw_peasant;

begin
	SpriteXY(peasant_x,peasant_y);
end;


Procedure do_knight(mode: byte);

label done_knight;

begin
	level_over:=0;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	{ decompress priority }

	{ load bg }

	decompress(@screen,@PQ_KNIGHT);
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

		draw_peasant;
		
		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ wait vblank }

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

	SetPalette(0);

	decompress(@screen,@PQ_TITLE);
	repeat until keypressed;
	ch:=readkey;

	SetPalette(1);

	{ init }

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

	SpriteXY(8,100);

	for i:=0 to 10 do begin
		PutPixelXY(0,50+i);
	end;

	repeat until keypressed;
	ch:=readkey;

	{ Restore Text Mode}
	SetCGAMode(3);

end.
