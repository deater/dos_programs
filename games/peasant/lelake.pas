	{=====================================}
	{ EAST LAKE ACTIONS                   }
	{=====================================}

Procedure east_lake_actions;

begin

	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_BOAT) or (current_noun=NOUN_DINGHY) then begin
			if game_state.FISH_FED then
				print_offset:=lake_east_dialog(
					lake_east_look_at_boat_gone_message)
			else
				print_offset:=lake_east_dialog(
					lake_east_look_at_boat_message);
		end;

		if (current_noun=NOUN_DUDE) or (current_noun=NOUN_MAN) or
			(current_noun=NOUN_GUY) or (current_noun=NOUN_PEASANT)
				then
			if game_state.FISH_FED=false then
				print_offset:=lake_east_dialog(
					lake_east_look_at_man_message);

		if (current_noun=NOUN_LAKE) or (current_noun=NOUN_NONE) then begin

			if game_state.FISH_FED then
				print_offset:=lake_east_dialog(
					lake_east_look_at_lake_message_man_gone)
			else
				print_offset:=lake_east_dialog(
					lake_east_look_at_lake_message);

		end;

		if (current_noun=NOUN_SAND) then begin
			print_offset:=lake_east_dialog(lake_east_look_at_sand_message);
			partial_message_step;
			print_offset:=lake_east_dialog(lake_east_look_at_sand_message2);
			end;

		end; {verb_look}

	VERB_TALK:
		if (current_noun=NOUN_DUDE) or (current_noun=NOUN_MAN) or
			(current_noun=NOUN_GUY) or (current_noun=NOUN_PEASANT)
				then
			if game_state.FISH_FED then
				print_offset:=lake_east_dialog(
					lake_east_talk_man_after_message)
			else
				print_offset:=lake_east_dialog(
					lake_east_talk_man_message);


	VERB_THROW: begin

		if (current_noun=NOUN_FEED) then begin

			if (inventory[ord(CHICKEN_FEED)]) then begin

				{ check if too far up/down}
				if (peasant_y<52) or (peasant_y>120) then begin
					print_offset:=
					lake_east_dialog(
					lake_east_throw_feed_too_south_message);
				end
				else begin
					{ check if man still there }
					if (game_state.FISH_FED) then begin
						print_offset:=
						lake_east_dialog(
						lake_east_throw_feed_already_message);
					end
					else begin
						{ he's there still }
						{TODO}
						{pesant_walkto(27,64);}
						{peasant_dir:=PEASANT_DIR_LEFT;}

						{ actually throw food }
						print_offset:=
						lake_east_dialog(
						lake_east_throw_feed_message);
						partial_message_step;

						{ animate throwing}
						{ TODO}

						{ feed fish }
						game_state.FISH_FED:=true;
						inventory_gone[ord(CHICKEN_FEED)]:=true;

						{ FIXME: score should happen }
						{ after message? }

						score_points(2);

						print_offset:=
						lake_east_dialog(
						lake_east_throw_feed2_message);


					end;
				end;

			end {inventory chicken_feed }
			else
				print_offset:=
				lake_east_dialog(lake_east_throw_feed_none_message);

		end {NOUN_FEED}
		else if (current_noun=NOUN_STONES) or
			(current_noun=NOUN_STONE) or
			(current_noun=NOUN_ROCK) or
			(current_noun=NOUN_ROCKS) then begin
			print_offset:=
				lake_east_dialog(lake_east_skip_stones_message);
		end {NOUN_STONES}
		else
			{ throw anything else }
			if (game_state.FISH_FED) then
				print_offset:=
				lake_east_dialog(lake_east_throw_default_gone_message)
			else
				print_offset:=
				lake_east_dialog(lake_east_throw_default_message);

	end; {verb throw}

	VERB_SKIP: begin
		if (current_noun=NOUN_STONES) or
			(current_noun=NOUN_STONE) or
			(current_noun=NOUN_ROCK) or
			(current_noun=NOUN_ROCKS) then begin
			print_offset:=
				lake_east_dialog(lake_east_skip_stones_message);
		end;
	end; {verb skip}

	end; {case verb}

end;


{************************************}
{ do_east_lake                       }
{************************************}

Procedure do_east_lake;

label done_east_lake;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DELAKE');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PELAKE');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GELAKE');
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
		RestoreBG4(peasant_x,peasant_y,15,
			screen_ptr(background),@screen);

		{ move_peasant }

		move_peasant;

		if level_over <> LEVEL_NOT_OVER then goto done_east_lake;

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

done_east_lake:

	{ check borders }

end;
