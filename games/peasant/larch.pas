	{=====================================}
	{ ARCHERY ACTIONS                     }
	{=====================================}

Procedure archery_play_game(skip: boolean);

begin
	if (skip<>true) then begin

		if (game_state.ARROW_BEATEN) then begin

		end;

		if (game_state.TRINKET_GIVEN) then begin

		end;

	end;

	print_offset:=
		archery_dialog(archery_play_game_message2);
	partial_message_step;

	update_map_location(LOCATION_ARCHERY_GAME);

end;


Procedure archery_actions;

begin

	if (current_verb=VERB_GET) or
		(current_verb=VERB_STEAL) or
		(current_verb=VERB_TAKE) then begin

		if (current_noun=NOUN_TARGET) then
			print_offset:=
				archery_dialog(archery_get_target_message);
		if (current_noun=NOUN_ARROW) then
			print_offset:=
				archery_dialog(archery_get_arrow_message);
	end;


	case current_verb of

	VERB_ASK:	begin

		if (game_state.HALDO_TO_DONGOLEV) then begin

			print_offset:=archery_dialog(archery_ask_about_unknown_message);

			if (current_noun=NOUN_FIRE) then begin
				print_offset:=
				archery_dialog(archery_ask_about_fire_message);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_fire_message2);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_fire_message3);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_fire_message4);

			end;

			if (current_noun=NOUN_NED) then
				print_offset:=
				archery_dialog(archery_ask_about_ned_message);
			if (current_noun=NOUN_SMELL) then
				print_offset:=
				archery_dialog(archery_ask_about_smell_message);
			if (current_noun=NOUN_ROBE) then
				print_offset:=
				archery_dialog(archery_ask_about_robe_message);
			if (current_noun=NOUN_TROGDOR) then begin
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message2);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message3);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message4);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message5);
				partial_message_step;
				print_offset:=
				archery_dialog(archery_ask_about_trogdor_message6);

			end;


		end; { said haldo }

		end; { verb_ask }

	VERB_GIVE:	begin

			{ only if dongolev there }
			if (current_noun=NOUN_TRINKET)
				and (game_state.HALDO_TO_DONGOLEV) then begin

				if (game_state.TRINKET_GIVEN) then begin
					{ already gave it }
					print_offset:=
					archery_dialog(archery_give_trinket_again_message);
				end
				else if (inventory[ord(TRINKET)]) then begin
					{ score 2 points }
					score_points(2);

					{ set trinket given }
					game_state.TRINKET_GIVEN:=true;

					{ mark us no longer having it }
					inventory_gone[ord(TRINKET)]:=true;


					print_offset:=
					archery_dialog(archery_give_trinket_message);
					partial_message_step;

					{ skip part of it }
					archery_play_game(true);

				end;
			end;

		end; { verb_give }

	VERB_HALDO:	begin

			if (game_state.HALDO_TO_DONGOLEV) then begin
				print_offset:=
					archery_dialog(archery_haldo_message);
			end;
		end; { verb_haldo }

	VERB_LOOK:	begin

		{ TODO: should we say the otherwise case }
		{ as the default once we've talked to dongolev }

		if (current_noun=NOUN_DESK) then
			print_offset:=archery_dialog(archery_look_at_desk_message);
		if (current_noun=NOUN_TARGET) then
			print_offset:=archery_dialog(archery_look_at_target_message);
		if (current_noun=NOUN_ARCHER) then begin

			{ first check if we've talked to mendelev }
			if (game_state.TALKED_TO_MENDELEV<>true) then begin
				print_offset:=archery_dialog(archery_look_at_archer_message);
			end else begin
				{ have talked to mendelev }
				if (game_state.HALDO_TO_DONGOLEV) then begin
					{ have talked to dongolev }
					print_offset:=archery_dialog(archery_look_at_archer_otherwise_message);
				end else begin
					print_offset:=archery_dialog(archery_look_at_archer_sponge_message);
				end;
			end;
		end;
		if (current_noun=NOUN_NONE) then
			print_offset:=archery_dialog(archery_look_message);
		end; {verb_look}

	VERB_PLAY:	begin
		end; {verb_play}

	VERB_TALK:	begin
		{ only talk if close }

		{ TODO: check y too? }
		if (peasant_x<(23*8)) then begin
			print_offset:=archery_dialog(archery_talk_far_message);
		end
		else begin {close enough}
			if (current_noun=NOUN_MAN) or
				(current_noun=NOUN_GUY) or
				(current_noun=NOUN_DUDE) or
				(current_noun=NOUN_MENDELEV) or
				(current_noun=NOUN_ARCHER) or
				(current_noun=NOUN_NONE) then begin
				{ talk to mendelev }
				if (game_state.TALKED_TO_MENDELEV) then begin

					{ URGH }
				end;
			end;
			if (current_noun=NOUN_DONGOLEV) then begin

			end;
		end; { talk close }

		end; {verb_talk}

	end; {case verb}

end;


{************************************}
{ do_archery                         }
{************************************}

Procedure do_archery;

label done_archery;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DARCH');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PARCH');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GARCH');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer)); }

	screen_copy(@screen,screen_ptr(background));

	{ set palette }

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

		if level_over <> LEVEL_NOT_OVER then goto done_archery;

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

done_archery:

	{ check borders }

end;
