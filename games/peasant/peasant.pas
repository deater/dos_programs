program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02,cga;

{$I pq_vid.pas}
{$I pq_title.pas}

{$I pq_knght.pas}

(*
{$I pq_ker1.pas}
{$I pq_ytree.pas}
{$I pq_inn.pas}
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
	background,framebuffer:buffer_ptr;

	screen:screentype absolute $B800:0000;
	level_over,frame,flame_count:byte;
	visited_0,visited_1,visited_2:byte;
	peasant_x,peasant_y:byte;
	peasant_xadd,peasant_yadd:integer; { signed }
	peasant_dir,peasant_steps:byte;
	ch:char;
	i:word;
	input_x:byte;
	input_buffer : string;

{=====================================}
{ Reset Prompt                        }
{=====================================}

Procedure reset_prompt;

begin
	Delete(input_buffer,1,Length(input_buffer));
	{ FIXME!  draw black rectangle to erase }
	input_x:=0;
	PrintCharXor('>',input_x,24);	
	input_x:=2;
end;

{=====================================}
{ graphics input                      }
{=====================================}

Procedure graphics_input(ch: char);

begin

	{ backspace }
	if (ch=chr(8)) then begin

		{ erase last character }

		if (length(input_buffer)>0) then begin
			input_x:=input_x-1;
			PrintCharXor(input_buffer[length(input_buffer)],
				input_x,24);
			Delete(input_buffer,Length(input_buffer),1);
		end
	end

	{ enter }
	else if (ch=chr(13)) then begin
		
		reset_prompt;

	end

	{ anything else }
	else begin
		if (Length(input_buffer)<40) then begin
			input_buffer:=input_buffer+ch;
			PrintCharXor(ch,input_x,24);
			input_x:=input_x+1;
		end
	end;
	
end;

{=====================================}
{ Check keyboard                      }
{=====================================}

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

		graphics_input(ch);

	end;                   

end;

{=============================}
{ Move peasant                }
{=============================}

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


{=============================}
{ Draw Peasant                }
{=============================}

Procedure draw_peasant;

var which : byte;

begin

	which := (peasant_dir*6)+peasant_steps;

	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],screen_ptr(framebuffer));
{	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],@screen);}
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

	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));

	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',25,0);

	reset_prompt;
	
	{ move knight }

	visited_1:=visited_1 or 16;	{ MAP_MOUNTAIN_PASS}

	while(true) do begin

		{ check_keyboard }

		check_keyboard;

		{ erase peasant }
		RestoreBG(peasant_x,peasant_y,4,15,
			screen_ptr(background),screen_ptr(framebuffer));

		{ move_peasant }

		move_peasant;

		if level_over <> 0 then goto done_knight;

		{ update screen }

		draw_peasant;

		screen_update(@screen,screen_ptr(framebuffer));

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



{====================================}
{ Main                               }
{====================================}

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
	GetMem(framebuffer,16384);
	

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

(*
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

	for i:=0 to 10 do begin
		PutPixelXY(0,50+i);
	end;

	repeat until keypressed;
	ch:=readkey;
*)
	{ Restore Text Mode}
	SetCGAMode(3);

end.
