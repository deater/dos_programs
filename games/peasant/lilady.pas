	{=====================================}
	{ INSIDE LADY HUT ACTIONS             }
	{=====================================}



Procedure inside_lady_actions;

begin

	if (current_verb=VERB_GET)
		or (current_verb=VERB_TAKE)
		or (current_verb=VERB_STEAL) then begin

		if (current_noun=NOUN_FEED) then begin
			if (inventory[ord(CHICKEN_FEED)] or inventory_gone[ord(CHICKEN_FEED)]) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_get_feed_already_message);
			end
			else begin
				{walk to feed}
				{TODO}
				{peasant_walkto(11,116);}
				{ face left }
				peasant_dir:=2;

				{get the feed}
				inventory[ord(CHICKEN_FEED)]:=true;

				{update score}
				score_points(1);

				print_offset:=
				inside_lady_dialog(inside_cottage_get_feed_message);
			end;
		end;
		if (current_noun=NOUN_BABY) then begin
			if game_state.LADY_GONE then begin
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_get_baby_message);
			end;
		end;
		if (current_noun=NOUN_CHAIR) then begin
			if game_state.LADY_GONE then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_get_chair_gone_message);
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_get_chair_message);
			end;
		end;
		if (current_noun=NOUN_GOLD) or (current_noun=NOUN_MONEY) then print_offset:=
			inside_lady_dialog(inside_cottage_get_gold_message);
		if (current_noun=NOUN_HAY) then print_offset:=
			inside_lady_dialog(inside_cottage_get_hay_message);
		if (current_noun=NOUN_FOOD) or (current_noun=NOUN_STUFF) then print_offset:=
			inside_lady_dialog(inside_cottage_get_food_message);
		if (current_noun=NOUN_PILLOW) then print_offset:=
			inside_lady_dialog(inside_cottage_get_pillow_message);


	end;


	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_BABY) then begin
			if (game_state.LADY_GONE=false) then
			print_offset:=
			inside_lady_dialog(inside_cottage_look_at_baby_message);
		end; { look baby }
		if (current_noun=NOUN_CHAIR) then print_offset:=
			inside_lady_dialog(inside_cottage_look_at_chair_message);
		if (current_noun=NOUN_FEED) then print_offset:=
			inside_lady_dialog(inside_cottage_look_at_feed_message);
		if (current_noun=NOUN_HAY) then print_offset:=
			inside_lady_dialog(inside_cottage_look_at_hay_message);
		if (current_noun=NOUN_PEASANT) or
			(current_noun=NOUN_LADY) or
			(current_noun=NOUN_WOMAN) then begin

			if (game_state.LADY_GONE) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_lady_gone_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_lady_gone2_message);
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_lady_message);
			end;
		end;
		if (current_noun=NOUN_PILLOW) then print_offset:=
			inside_lady_dialog(inside_cottage_look_at_pillow_message);
		if (current_noun=NOUN_SHELF) then print_offset:=
			inside_lady_dialog(inside_cottage_look_at_shelf_message);

		if (current_noun=NOUN_NONE) then begin
			if (game_state.LADY_GONE) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_gone_message);
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_message);
			end;
		end;

		end; {verb_look}


	VERB_TALK: begin

		if (current_noun=NOUN_BABY) then begin
			print_offset:=
			inside_lady_dialog(inside_cottage_talk_baby_message);
		end; { talk baby }
		if (current_noun=NOUN_PEASANT) or
			(current_noun=NOUN_LADY) or
			(current_noun=NOUN_WOMAN) or
			(current_noun=NOUN_NONE) then begin

			if (game_state.LADY_GONE) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_look_at_gone_message);
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_talk_lady_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_talk_lady2_message);

			end;
		end;

		end; { verb_talk }


	VERB_GIVE: begin

		if (current_noun=NOUN_RICHES) then begin
			if (inventory_gone[ord(RICHES)]) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_give_riches_already_message);
			end
			else if (inventory[ord(RICHES)]) then begin
				{ give the riches }
				print_offset:=
				inside_lady_dialog(inside_cottage_give_riches_message);
				partial_message_step;
				{ update score}
				score_points(5);
				{ get baby }
				inventory[ord(BABY)]:=true;
				{ get rid of lady }
				game_state.LADY_GONE:=true;

				{TODO}
				{update_chair_priority}

				print_offset:=
				inside_lady_dialog(inside_cottage_give_riches2_message);

			end
			else begin
				{notyet}
				print_offset:=
				inside_lady_dialog(inside_cottage_give_riches_notyet_message);
			end;
		end else

		if (current_noun=NOUN_TRINKET) then begin

			if (inventory[ord(TRINKET)]) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_give_trinket_message);
			end
			else begin
				if (game_state.LADY_GONE) then begin
					print_offset:=
					inside_lady_dialog(inside_cottage_give_trinket_nolady_message);
				end else begin
					print_offset:=
					inside_lady_dialog(inside_cottage_give_trinket_nohave_message);
					partial_message_step;
					print_offset:=
					inside_lady_dialog(inside_cottage_give_trinket_nohave2_message);

				end;
			end;

		end else

		if (game_state.LADY_GONE=false) then begin
			print_offset:=
				inside_lady_dialog(inside_cottage_give_default_message);
		end;

	end; {verb give }

	VERB_ASK: begin
		if (game_state.LADY_GONE=false) then begin

			{ default }
			print_offset:=
			inside_lady_dialog(inside_cottage_ask_unknown_message);

			if (current_noun=NOUN_BABY) then print_offset:=
				inside_lady_dialog(inside_cottage_ask_baby_message);
			if (current_noun=NOUN_FIRE) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_fire_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_fire2_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_fire3_message);
			end;
			if (current_noun=NOUN_JHONKA) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_jhonka_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_jhonka2_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_jhonka3_message);
			end;

			if (current_noun=NOUN_NED) then print_offset:=
				inside_lady_dialog(inside_cottage_ask_ned_message);

			if (current_noun=NOUN_ROBE) then print_offset:=
				inside_lady_dialog(inside_cottage_ask_robe_message); 

			if (current_noun=NOUN_SMELL) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_smell_message);
				partial_message_step;
				print_offset:=
				inside_lady_dialog(inside_cottage_ask_smell2_message);
			end;

			if (current_noun=NOUN_TROGDOR) then print_offset:=
				inside_lady_dialog(inside_cottage_ask_trogdor_message); 

		end; { ask lady there }

	end; {verb ask }

	VERB_SLEEP: begin
		print_offset:=
			inside_lady_dialog(inside_cottage_sleep_message);
	end; {verb sleep }

	end; {case}
end;


{************************************}
{ do_inside_lady                    }
{************************************}

Procedure do_inside_lady;

label done_inside_lady;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DILADY');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PILADY');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GILADY');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer)); }

	screen_copy(@screen,screen_ptr(background));

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

		if level_over <> LEVEL_NOT_OVER then goto done_inside_lady;

		{ update screen }

		draw_peasant;

		{ screen_update(@screen,screen_ptr(framebuffer)); }

		{ increment frame }

		frame := frame + 1;

		{ increment flame }

		{ level specific }

		if (peasant_y>$95) then begin

			if ((inventory[ord(TRINKET)]) or
				(inventory_gone[ord(TRINKET)])) then begin
				print_offset:=
				inside_lady_dialog(inside_cottage_leaving_post_trinket_message);
				partial_message_step;
			end
			else begin
				print_offset:=
				inside_lady_dialog(inside_cottage_leaving_message);
				partial_message_step;
			end;
			{ actually leave }
			{ we update position later }
			update_map_location(LOCATION_OUTSIDE_LADY);
		end;

		{ wait vblank }

		wait_vsync;

		{ page  flip }

	end;

done_inside_lady:

	{ check borders }

	if (map_location=LOCATION_OUTSIDE_LADY) then begin
		peasant_x:=23*8;
		peasant_newy:=120;

		peasant_dir:=3;	{ PEASANT_DIR_DOWN }

		stop_peasant;
	end

end;
