	{=====================================}
	{ BURNED TREE ACTIONS                 }
	{=====================================}

Procedure burn_tree_actions;

begin

	case current_verb of

	VERB_CLIMB:
		if current_noun=NOUN_CLIFF then
			print_offset:=
				burninated_tree_dialog(crooked_tree_climb_cliff_message);


	VERB_GET: begin
		if (current_noun=NOUN_FIRE) and (game_state.NIGHT) then begin
			{ only at night }
			if (game_state.ON_FIRE) then begin
				{ already on fire }
				print_offset:=
					burninated_tree_dialog(
					crooked_tree_get_fire_already_message);
			end
			else begin
				{ not on fire yet }
				if (game_state.GREASE_ON_HEAD) then
				print_offset:=
					burninated_tree_dialog(
					crooked_tree_get_fire_greased_message)
				else
				print_offset:=
					burninated_tree_dialog(
					crooked_tree_get_fire_not_greased_message);

			end;


		end; { VERB_GET NOUN_FIRE }

		if (current_noun=NOUN_LANTERN) then
			print_offset:=
				burninated_tree_dialog(
					crooked_tree_get_lantern_message);

		if (current_noun=NOUN_PLAGUE) then
			print_offset:=
				burninated_tree_dialog(
					crooked_tree_get_plague_message);

		if (current_noun=NOUN_PLAQUE) then
			print_offset:=
				burninated_tree_dialog(
					crooked_tree_get_plaque_message);

		end; {VERB GET}

	VERB_LIGHT: begin
		if (current_noun=NOUN_LANTERN) then begin

			if (game_state.NIGHT) then
				print_offset:=
					burninated_tree_dialog(
					crooked_tree_light_lantern_night_message)
			else
				print_offset:=
					burninated_tree_dialog(
					crooked_tree_light_lantern_day_message);
		end;

		end; { VERB_LIGHT }

	VERB_LOOK:	begin

		if (current_noun=NOUN_LANTERN) then
			if (game_state.NIGHT) then
				print_offset:=burninated_tree_dialog(
					crooked_look_lantern_night_message)
			else
				print_offset:=burninated_tree_dialog(
					crooked_look_lantern_day_message);

		if (current_noun=NOUN_STUMP) then
			print_offset:=burninated_tree_dialog(
				crooked_look_stump_message);
		if (current_noun=NOUN_TREE) then
			print_offset:=burninated_tree_dialog(
				crooked_look_tree_message);
		if (current_noun=NOUN_NONE) then
			if (game_state.NIGHT) then
				print_offset:=burninated_tree_dialog(
					crooked_look_night_message)
			else
				print_offset:=burninated_tree_dialog(
					crooked_look_day_message);

		end; {verb_look}

	end; {case verb}

end;


{************************************}
{ do_burn_tree                       }
{************************************}

Procedure do_burn_tree;

label done_burn_tree;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DBTREE');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PBTREE');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GBTREE');
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

		if level_over <> LEVEL_NOT_OVER then goto done_burn_tree;

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

done_burn_tree:

	{ check borders }


end;
