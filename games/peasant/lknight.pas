	{=====================================}
	{ KNIGHT ACTIONS                      }
	{=====================================}

Procedure knight_actions;

begin

	case current_verb of

	VERB_ASK:	begin
		{ default }
		print_offset:=knight_dialog(knight_ask_unknown_message);

		case current_noun of

			NOUN_FIRE:
				print_offset:=
					knight_dialog(knight_ask_fire_message);
			NOUN_JHONKA:
				print_offset:=
					knight_dialog(knight_ask_jhonka_message);
			NOUN_KERREK:
				print_offset:=
					knight_dialog(knight_ask_kerrek_message);
			NOUN_NED:
				print_offset:=
					knight_dialog(knight_ask_ned_message);
			NOUN_ROBE:
				print_offset:=
					knight_dialog(knight_ask_robe_message);
			NOUN_SMELL:
				print_offset:=
					knight_dialog(knight_ask_smell_message);
			NOUN_TROGDOR:
				print_offset:=
					knight_dialog(knight_ask_trogdor_message);
		end; {case noun}

		end; {verb_ask}

	VERB_ATTACK:
		if (current_noun=NOUN_SIGN) then
			print_offset:=
				knight_dialog(attack_sign_message);

	VERB_BREAK:
		if (current_noun=NOUN_SIGN) then
			print_offset:=
				knight_dialog(attack_sign_message);

	VERB_LOOK:	begin
		if (current_noun=NOUN_KNIGHT) or
			(current_noun=NOUN_MAN) or
			(current_noun=NOUN_DUDE) or
			(current_noun=NOUN_GUY) then

				print_offset:=knight_dialog(knight_look_message);

		if (current_noun=NOUN_SIGN) then
			print_offset:=knight_dialog(sign_look_message);
		if (current_noun=NOUN_TROGDOR) then
			print_offset:=knight_dialog(trogdor_look_message);
		if (current_noun=NOUN_NONE) then
			print_offset:=knight_dialog(pass_look_message);

		end; {verb_look}

	VERB_TALK:	begin
		if (current_noun=NOUN_KNIGHT) or
			(current_noun=NOUN_MAN) or
			(current_noun=NOUN_DUDE) or
			(current_noun=NOUN_GUY) then begin

			{ extra text first time talking }
			if (game_state.TALKED_TO_KNIGHT=false) then begin
				print_offset:=knight_dialog(talk_knight_first_message);
				partial_message_step;
				print_offset:=knight_dialog(talk_knight_second_message);
				partial_message_step;

			end;
			{ see if have belt }
			if (inventory[ord(KERREK_BELT)]) then begin
				{TODO}
			end;
			{ see if wearing robe }
			if (game_state.WEARING_ROBE) then begin
				{TODO}
			end;
			{ if have nothing }
			print_offset:=knight_dialog(talk_knight_third_message);
			partial_message_step;
			print_offset:=knight_dialog(talk_knight_stink_message);
			partial_message_step;
			print_offset:=knight_dialog(talk_knight_dress_message);
			partial_message_step;
			print_offset:=knight_dialog(talk_knight_fire_message);
			partial_message_step;

			print_offset:=knight_dialog(talk_knight_fourth_message);
			{ extra text first time talking }
			if (game_state.TALKED_TO_KNIGHT=false) then begin
				partial_message_step;
				print_offset:=knight_dialog(talk_knight_fifth_message);
				game_state.TALKED_TO_KNIGHT:=true;
			end;

		end; {talking to knight}


		end; {verb_talk}

	end; {case verb}

end;


{************************************}
{ do_knight                          }
{************************************}

Procedure do_knight;

label done_knight;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DKNIGHT');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PKNIGHT');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GKNIGHT');
	decompress(background,file_buffer);

	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));

	update_score;

	reset_prompt;

	{ move knight }

	{ mark visited }

	visited_locations[ord(map_location)]:=true;

	while(level_over=LEVEL_NOT_OVER) do begin

		{ check_keyboard }

		check_keyboard;

		{ erase peasant }
{		RestoreBG4(peasant_x,peasant_y,15,
			screen_ptr(background),screen_ptr(framebuffer));
}

		RestoreBG4(peasant_x,peasant_y,15,
			screen_ptr(background),@screen);



		{ move_peasant }

		move_peasant;

		if level_over <> LEVEL_NOT_OVER then goto done_knight;

		{ update screen }

		draw_peasant;

	{	screen_update(@screen,screen_ptr(framebuffer)); }

		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ wait vblank }

		wait_vsync;

		{ page  flip }

	end;

done_knight:

	{ check borders }


	{ avoid the inn }
	if (map_location=LOCATION_OUTSIDE_INN) then begin
		if (peasant_x>=(6*8)) and (peasant_x<(18*8)) then
			peasant_x:=4*8		{ move to left }
		else if (peasant_x<(31*8)) then
			peasant_x:=31*8;	{ move to right}
	end;

	if (map_location=LOCATION_CLIFF_BASE) then begin
		peasant_x:=18*8;
		peasant_newy:=140;
		peasant_dir:=0;		{ DIR_UP }
		stop_peasant;
	end;

end;
