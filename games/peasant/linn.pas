	{=====================================}
	{ OUTSIDE INN ACTIONS                 }
	{=====================================}

Procedure outside_inn_actions;

begin

	case current_verb of

	VERB_GET:
		if current_noun=NOUN_NOTE then begin

			if game_state.FISH_FED then
				print_offset:=
					outside_inn_dialog(outside_inn_note_look_gone_message)
			else
				print_offset:=
					outside_inn_dialog(outside_inn_note_get_message);
		end;

	VERB_KNOCK:
		if (current_noun=NOUN_DOOR) or (current_noun=NOUN_NONE) then begin
			if game_state.FISH_FED then
				print_offset:=
					outside_inn_dialog(outside_inn_door_knock_message)
			else
				print_offset:=
					outside_inn_dialog(outside_inn_door_knock_locked_message);


		end;

	VERB_LOOK:	begin

		if (current_noun=NOUN_DOOR) then begin

			if game_state.FISH_FED then
				print_offset:=
					outside_inn_dialog(outside_inn_door_look_message)
			else
				print_offset:=
					outside_inn_dialog(outside_inn_door_look_note_message);

		end;

		if (current_noun=NOUN_INN) then
			print_offset:=outside_inn_dialog(outside_inn_inn_look_message);
		if (current_noun=NOUN_SIGN) then
			print_offset:=outside_inn_dialog(outside_inn_sign_look_message);
		if (current_noun=NOUN_WINDOW) then
			print_offset:=outside_inn_dialog(outside_inn_window_look_message);
		if (current_noun=NOUN_NOTE) then

			if game_state.FISH_FED then
				print_offset:=
					outside_inn_dialog(outside_inn_note_look_gone_message)
			else
				print_offset:=
					outside_inn_dialog(outside_inn_note_look_message);

		if (current_noun=NOUN_NONE) then
			print_offset:=outside_inn_dialog(outside_inn_look_message);

		end; {verb_look}

	VERB_OPEN: begin

		{ handle both, I guess this is safe? }

		if (current_noun=NOUN_DOOR) then current_noun:=NOUN_NONE;

		if (current_noun=NOUN_NONE) then begin

			{ check if door unlocked }

			if game_state.FISH_FED then begin
				{ unlocked case }
				{ walk to door }

				{ walk_to(9,116); TODO }
				peasant_x:=9*8;
				peasant_y:=120;
				peasant_dir:=0;	{PEASANT_DIR_UP}

				{ check if night }
				if (game_state.NIGHT) then begin
					update_map_location(LOCATION_INSIDE_INN_NIGHT);
				end
				else begin
					update_map_location(LOCATION_INSIDE_INN);
				end;
				{ update_map_location(); TODO }

				print_offset:=outside_inn_dialog(outside_inn_door_open_message);
			end
			else begin
				{ locked door }

				print_offset:=outside_inn_dialog(outside_inn_door_open_locked_message);
			end;
		end;

	end; {verb open }

	VERB_READ:
		{ same as look note }
		if (current_noun=NOUN_NOTE) then
			if game_state.FISH_FED then
				print_offset:=
					outside_inn_dialog(outside_inn_note_look_gone_message)
			else
				print_offset:=
					outside_inn_dialog(outside_inn_note_look_message);
	end; {case verb}

end;


{************************************}
{ do_outside_inn                     }
{************************************}

Procedure do_outside_inn;

label done_outside_inn;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DINN');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PINN');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GINN');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer)); }

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

		if level_over <> LEVEL_NOT_OVER then goto done_outside_inn;

		{ update screen }

		draw_peasant;

		{ screen_update(@screen,screen_ptr(framebuffer)); }

		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{  level specific }

		{ wait vblank }

		wait_vsync;

		{ page  flip }

	end;

done_outside_inn:

	{ check borders }

	{ avoid getting stuck in cliff }
	if (map_location=LOCATION_BURN_TREES) then
		if (peasant_x >= 33*8) then
			peasant_x:=(32*8);

	if (map_location=LOCATION_INSIDE_INN) then
		peasant_newy:=120;

end;
