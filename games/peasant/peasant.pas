program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02;

{$I pq_ker1.pas}
{$I pq_knght.pas}
{$I pq_ytree.pas}

{ BH = page number,
  DH = row (0 top)
  DL = col (0 top)
}

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



type ScreenType = array [0..16384] of byte;  {For Graphics Loading}

var
	screen:screentype absolute $B800:0000;
	ch:char;

begin
	{Set CGA mode 4}

	SetCGAMode(4);
	SetPalette(1);

	decompress(@screen,@PQ_KERREK1);
	repeat until keypressed;
	ch:=readkey;

	decompress(@screen,@PQ_KNIGHT);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',24,0);

	repeat until keypressed;
	ch:=readkey;

	decompress(@screen,@PQ_YTREE);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',24,0);

	repeat until keypressed;
	ch:=readkey;

	SetPalette(0);

	repeat until keypressed;
	ch:=readkey;


{	move(PQ_KERREK1,screen,16384);}



	{ Restore Text Mode}
	SetCGAMode(3);
end.
