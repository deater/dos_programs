	{=====================================}
	{ COTTAGE ACTIONS                     }
	{=====================================}

Procedure cottage_actions;

begin

	case current_verb of

	VERB_LOOK:	begin
	end;

	end; {case verb}

end;


{************************************}
{ do_cottage                     }
{************************************}

Procedure do_cottage;

label done_cottage;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DCOT');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PCOT');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GCOT');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer)); }

	screen_copy(@screen,screen_ptr(background));

	SetPalette(0); { yellow }

	update_score;

	reset_prompt;


	{ mark visited }

	visited_locations[ord(map_location)]:=true;

	while(level_over=LEVEL_NOT_OVER) do begin

		{ check_keyboard }

		check_keyboard;

		{ erase peasant }
		RestoreBG4(peasant_x,peasant_y,15,
			screen_ptr(background),@screen);

		{ move_peasant }

		move_peasant;

		if level_over <> LEVEL_NOT_OVER then goto done_cottage;

		{ update screen }

		draw_peasant;

		{ screen_update(@screen,screen_ptr(framebuffer)); }

		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ wait vblank }

		wait_vsync;

		{ page  flip }

	end;

done_cottage:

	{ check borders }


	{ possible to get stuck on edge of river }
	{ TODO: the apple II version here is likely bugged }

end;
