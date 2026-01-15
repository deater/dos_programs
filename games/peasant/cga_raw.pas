program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02;

{$I image.pas}

GraphicsRegisters :
         array [0..15] of byte =( 56, 40, 45, 10,
				127, 6, 100, 112,
				2, 1, 6, 7,
				0, 0, 0, 0);

Text80Registers :
         array [0..15] of byte =( 113, 80, 90, 10,
				31, 6, 25, 28,
				2, 7, 6, 7,
				0, 0, 0, 0);



Procedure Set6845Reg(Reg,Value: Byte);
label delay;
begin
	asm
		mov	dx,03d4h	{ 6845 address }
		mov	al,Reg
		out	dx,al
		jmp	delay
	delay:
		inc	dx
		mov	al,Value
		out	dx,al
	end;
end;


Procedure SetCGAMode(Mode: byte);
begin
	asm
		mov	dx,03d8h
		mov	al,Mode
		out	dx,al
	end;
end;






{ This procedure gets you into 320x200x2bpp CGA mode 4. }
Procedure SetCGAMode4;

{
var i : integer;

begin
	for i:=0 to 12 do Set6845Reg(i,GraphicsRegisters[i]);
	SetCGAMode($22);
end;
}
begin
	asm

		mov	ax, 04h
		int	10h
	end;
end;


{ This procedure gets you into 320x200x2bpp CGA mode 4. }
Procedure SetText80;

{
var i : integer;

begin
	for i:=0 to 12 do Set6845Reg(i,Text80Registers[i]);
	SetCGAMode($21);
end;
}
begin
	asm

		mov	ax, 03h
		int	10h
	end;
end;



type ScreenType = array [0..16384] of byte;  {For Graphics Loading}

var
	screen:screentype absolute $B800:0000;


begin
	SetCGAMode4;

	decompress(@screen,@IMAGEDATA);

{	move(IMAGEDATA,screen,16384);}
	repeat until keypressed;
	SetText80;
end.
