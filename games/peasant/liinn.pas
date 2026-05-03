	{=====================================}
	{ INSIDE INN ACTIONS                  }
	{=====================================}

Procedure inside_inn_actions;

begin

	if (current_verb=VERB_GIVE) or (current_verb=VERB_USE) then begin
		if (current_noun=NOUN_BABY) then begin
			if (inventory[ord(PILLS)]) then begin
				print_offset:=inside_inn_dialog(inside_inn_give_baby_already_message);
			end
			else if (inventory[ord(BABY)]) then begin
				print_offset:=inside_inn_dialog(inside_inn_give_baby_message);
				partial_message_step;
				{ add 5 points to score }
				score_points(5);
				{ get pills }
				inventory[ord(PILLS)]:=true;
								print_offset:=inside_inn_dialog(inside_inn_give_baby2_message);
			end
			else begin
				{no pills and no baby }
				print_offset:=inside_inn_dialog(inside_inn_give_baby_before_message);
			end;

		end;

	end;

	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_PILLOW) then
			print_offset:=inside_inn_dialog(inside_inn_look_pillow_message);
		if (current_noun=NOUN_PARCHMENT) or
			(current_noun=NOUN_NOTE) or
			(current_noun=NOUN_PAPER) then
			print_offset:=inside_inn_dialog(inside_inn_look_paper_message);
		if (current_noun=NOUN_PAINTING) then
			print_offset:=inside_inn_dialog(inside_inn_look_painting_message);
		if (current_noun=NOUN_DUDE) or
			(current_noun=NOUN_GUY) or
			(current_noun=NOUN_MAN) then
			print_offset:=inside_inn_dialog(inside_inn_look_man_message);
		if (current_noun=NOUN_WINDOW) then
			print_offset:=inside_inn_dialog(inside_inn_look_window_message);
		if (current_noun=NOUN_RUG) or
			(current_noun=NOUN_CARPET) then
			print_offset:=inside_inn_dialog(inside_inn_look_rug_message);
		if (current_noun=NOUN_BED) or
			(current_noun=NOUN_MATTRESS) then
			print_offset:=inside_inn_dialog(inside_inn_look_bed_message);
		if (current_noun=NOUN_BELL) then
			print_offset:=inside_inn_dialog(inside_inn_look_bell_message);
		if (current_noun=NOUN_DESK) then
			print_offset:=inside_inn_dialog(inside_inn_look_desk_message);
		if (current_noun=NOUN_DOOR) then
			print_offset:=inside_inn_dialog(inside_inn_open_door_message);
		if (current_noun=NOUN_NONE) then
			print_offset:=inside_inn_dialog(inside_inn_look_message);

		end; {verb_look}

	VERB_TALK: begin
		if (current_noun=NOUN_NONE) or
			(current_noun=NOUN_MAN) or
			(current_noun=NOUN_GUY) or
			(current_noun=NOUN_DUDE) then
				print_offset:=
					inside_inn_dialog(inside_inn_talk_man_message)

		end; {verb_talk}


	VERB_GET:	begin

		if (current_noun=NOUN_PARCHMENT) or
			(current_noun=NOUN_NOTE) or
			(current_noun=NOUN_PAPER) then
			print_offset:=inside_inn_dialog(inside_inn_get_paper_message);
		if (current_noun=NOUN_PAINTING) then
			print_offset:=inside_inn_dialog(inside_inn_get_painting_message);
		if (current_noun=NOUN_RUG) or
			(current_noun=NOUN_CARPET) then
			print_offset:=inside_inn_dialog(inside_inn_get_rug_message);
		if (current_noun=NOUN_DOING_SPROINGS) then
			print_offset:=inside_inn_dialog(inside_inn_get_doing_message);
		if (current_noun=NOUN_PILLOW) then
			print_offset:=inside_inn_dialog(inside_inn_get_pillow_message);
		if (current_noun=NOUN_BELL) then
			print_offset:=inside_inn_dialog(inside_inn_get_bell_message);
		if (current_noun=NOUN_BED) then
			print_offset:=inside_inn_dialog(inside_inn_get_bed_message);
		if (current_noun=NOUN_RUB) then
			print_offset:=inside_inn_dialog(inside_inn_get_rub_message);

		if (current_noun=NOUN_ROOM) then begin
			if (game_state.WEARING_ROBE) then begin
				{ wearing robe }
				if (game_state.ON_FIRE) then begin
					{ robe and on file }
					print_offset:=inside_inn_dialog(inside_inn_get_room_on_fire_message);
				end
				else begin
					{ robe but not on fire }

					print_offset:=inside_inn_dialog(inside_inn_get_room_message);
					partial_message_step;
					{ TODO walk to bed }
					{ peasant_walkto(33*8,95); }
					peasant_dir:=1; { PEASANT_DIR_RIGHT}
					game_state.NIGHT:=true;
					game_state.asleep:=true;

					{ TODO: do effect }
					{wipe_center_to_black;}

					if (game_state.ALREADY_GOT_ROOM=false) then begin
						{ only points if not slept before }
						game_state.ALREADY_GOT_ROOM:=true;
						score_points(3);
					end;

					print_offset:=inside_inn_dialog(inside_inn_get_room2_message);
					partial_message_step; {TODO: ? }

					update_map_location(LOCATION_INSIDE_INN_NIGHT);
				end;

			end
			else begin
				{ no robe }
				print_offset:=inside_inn_dialog(inside_inn_get_room_no_robe_message);
			end;
		end;

		end; {verb_get}

	VERB_ASK: begin

		{ default }
		print_offset:=inside_inn_dialog(inside_inn_ask_about_unknown_message);

		if (current_noun=NOUN_FIRE) then
			print_offset:=inside_inn_dialog(inside_inn_ask_about_fire_message);
		if (current_noun=NOUN_NED) then
			print_offset:=inside_inn_dialog(inside_inn_ask_about_ned_message);
		if (current_noun=NOUN_ROBE) then
			print_offset:=inside_inn_dialog(inside_inn_ask_about_robe_message);
		if (current_noun=NOUN_SMELL) then
			print_offset:=inside_inn_dialog(inside_inn_ask_about_smell_message);
		if (current_noun=NOUN_TROGDOR) then
			print_offset:=inside_inn_dialog(inside_inn_ask_about_trogdor_message);

		end; {verb_ask}

	VERB_RING:
		if (current_noun=NOUN_BELL) then
				print_offset:=
					inside_inn_dialog(inside_inn_ring_bell_message);



	VERB_SLEEP: if (current_noun=NOUN_BED) or
			(current_noun=NOUN_NONE) then
				print_offset:=
					inside_inn_dialog(inside_inn_sleep_bed_message);

	VERB_OPEN: if (current_noun=NOUN_DOOR) then
				print_offset:=
					inside_inn_dialog(inside_inn_open_door_message);


	end; {case verb}

end;


{************************************}
{ do_inside_inn                      }
{************************************}

Procedure do_inside_inn;

label done_inside_inn;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DIINN');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PIINN');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GIINN');
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

		if level_over <> LEVEL_NOT_OVER then goto done_inside_inn;

		{ update screen }

		draw_peasant;

		screen_update(@screen,screen_ptr(framebuffer));

		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ per-level }

		if (peasant_y>149) then begin
			update_map_location(LOCATION_OUTSIDE_INN);
		end;


		{ wait vblank }

		wait_vsync;

		{ page  flip }

	end;

done_inside_inn:

	{ check borders }

	if (map_location=LOCATION_OUTSIDE_INN) then begin
		peasant_x:=9*8;
		peasant_newy:=112;
		peasant_dir:=3;		{PEASANT_DIR_DOWN}

	end;

end;
