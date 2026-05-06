	{=====================================}
	{ RIVER/ROCK ACTIONS                  }
	{=====================================}

Procedure river_actions;

begin
	if (current_verb=VERB_GET) or (current_verb=VERB_STEAL) or
		(current_verb=VERB_TAKE) then begin

	end;

	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_ROCK) or (current_noun=NOUN_STONE) then
			print_offset:=rock_dialog(river_look_at_rock_message);
		if (current_noun=NOUN_WATER) or (current_noun=NOUN_RIVER) then
			print_offset:=rock_dialog(river_look_at_water_message);
		if (current_noun=NOUN_NONE) then
			print_offset:=rock_dialog(river_look_message);

		end; {verb_look}

	VERB_SWIM:
		if (current_noun=NOUN_WATER) or
			(current_noun=NOUN_RIVER) or
			(current_noun=NOUN_ROCK) or
			(current_noun=NOUN_STONE) then
			print_offset:=
				rock_dialog(river_swim_message);

	end; {case verb}

end;


{************************************}
{ do_river                           }
{************************************}

Procedure do_river;

label done_river;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DROCK');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PROCK');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GROCK');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));}

	screen_copy(@screen,screen_ptr(background));

	SetPalette(1); { cyan }

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

		if level_over <> LEVEL_NOT_OVER then goto done_river;

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

done_river:

	{ check borders }

	if (map_location=LOCATION_LAKE_EAST) then begin
		if (peasant_x<16*8) then peasant_x:=16*8;
	end;

	if (map_location=LOCATION_YELLOW_TREE) then begin
		if (peasant_x>(3*8)) then peasant_x:=3*8;
	end;

end;
