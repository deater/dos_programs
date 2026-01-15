program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02;

{$I pq_ker1.pas}
{$I pq_knght.pas}

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

	decompress(@screen,@PQ_KERREK1);
	repeat until keypressed;
	ch:=readkey;

	decompress(@screen,@PQ_KNIGHT);
	repeat until keypressed;



{	move(PQ_KERREK1,screen,16384);}



	{ Restore Text Mode}
	SetCGAMode(3);
end.
