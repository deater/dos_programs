	{=====================================}
	{ OUTSIDE LADY HUT ACTIONS            }
	{=====================================}

Procedure outside_lady_actions;

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
				{ peasant_dir:=PEADANT_DIR_UP;}
				{ check if night }
				if (game_state.NIGHT) then begin
					{ new location LOCATION_INSIDE_INN_NIGHT }
				end
				else begin
					{ new location LOCATION_INSIDE_INN }
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
{ do_outside_lady                    }
{************************************}

Procedure do_outside_lady;

label done_outside_lady;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DOLADY');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'POLADY');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GOLADY');
	decompress(background,file_buffer);

	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));

	update_score;

	reset_prompt;


	{ mark visited }

	visited_locations[ord(map_location)]:=true;

	while(level_over=LEVEL_NOT_OVER) do begin

		{ check_keyboard }

		check_keyboard;

		{ erase peasant }
		RestoreBG(peasant_x,peasant_y,4,15,
			screen_ptr(background),screen_ptr(framebuffer));

		{ move_peasant }

		move_peasant;

		if level_over <> LEVEL_NOT_OVER then goto done_outside_lady;

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

done_outside_lady:

{	repeat until keypressed;
	ch:=readkey;
}
end;
