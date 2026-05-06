	{=====================================}
	{ OUTSIDE LADY HUT ACTIONS            }
	{=====================================}



Procedure outside_lady_actions;

const bush_count_lookup : array [0..15] of byte = (
	$00,	{ 0000 }
	$01,	{ 0001 }
	$01,	{ 0010 }
	$02,	{ 0011 }
	$01,	{ 0100 }
	$02,	{ 0101 }
	$02,	{ 0110 }
	$03,	{ 0111 }
	$01,	{ 1000 }
	$02,	{ 1001 }
	$02,	{ 1010 }
	$03,	{ 1011 }
	$02,	{ 1100 }
	$03,	{ 1101 }
	$03,	{ 1110 }
	$04	{ 1111 }
);


Procedure bush_already_searched;
begin
	print_offset:=lady_cottage_dialog(lady_cottage_already_searched_message);
end;

Procedure actually_search_bush;

begin
	case bush_count_lookup[bush_status] of

		1:
			print_offset:=lady_cottage_dialog(lady_cottage_searched_1_bush_message);
		2:
			print_offset:=lady_cottage_dialog(lady_cottage_searched_2_bushes_message);
		3:
			print_offset:=lady_cottage_dialog(lady_cottage_searched_3_bushes_message);
		4: 	begin

			score_points(2);
			update_score;

			{ get trinket }
			inventory[ord(TRINKET)]:=true;

			print_offset:=lady_cottage_dialog(lady_cottage_searched_4_bushes_message);
			end;

	end;
end;


begin

	if ( ((current_verb=VERB_GET) or (current_verb=VERB_TAKE)) and (current_noun=NOUN_BERRIES)) or
	   ((current_verb=VERB_SEARCH) and (current_noun=NOUN_BUSH)) then begin

		if (bush_status=$f) then begin
			print_offset:=lady_cottage_dialog(lady_cottage_already_trinket_message);
		end
		else begin
			{ sort of a quadrant }
			{ walks you over to the one in the quadrant }

			if (peasant_x<15*8) then begin
				{ left bush }
				{ top left }
				if (peasant_y<$6D) then begin
					{ handle_bush2}
					if ((bush_status and $2)<>0) then begin
						bush_already_searched;
					end
					else begin
						bush_status:=bush_status or 2;
						actually_search_bush;
					end;
				end
				else begin
					{handle bush1}
					{ bottom left }
					if ((bush_status and $1)<>0) then begin
						bush_already_searched;
					end
					else begin
						bush_status:=bush_status or 1;
						actually_search_bush;
					end;
				end;
			end else begin
				{right bush }
				if (peasant_y<$6D) then begin
					{ handle_bush4}
					if ((bush_status and $8)<>0) then begin
						bush_already_searched;
					end
					else begin
						bush_status:=bush_status or 8;
						actually_search_bush;
					end;
				end
				else begin
					{handle bush3}
					{bottom right}
					if ((bush_status and $4)<>0) then begin
						bush_already_searched;
					end
					else begin
						bush_status:=bush_status or 4;
						actually_search_bush;
					end;
				end;

			end;

		end;
	end;


	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_BERRIES) then print_offset:=
			lady_cottage_dialog(lady_cottage_look_at_berries_message);
		if (current_noun=NOUN_BUSH) then print_offset:=
			lady_cottage_dialog(lady_cottage_look_at_bushes_message);
		if (current_noun=NOUN_COTTAGE) then print_offset:=
			lady_cottage_dialog(lady_cottage_look_at_cottage_message);
		if (current_noun=NOUN_DOOR) then print_offset:=
			lady_cottage_dialog(lady_cottage_look_at_door_message);
		if (current_noun=NOUN_NONE) then print_offset:=
			lady_cottage_dialog(lady_cottage_look_at_message);

		end; {verb_look}


	VERB_KNOCK:
		if (current_noun=NOUN_DOOR) or (current_noun=NOUN_NONE) then begin
			if game_state.LADY_GONE then
				print_offset:=
					lady_cottage_dialog(lady_cottage_knock_door_gone_message)
			else
				print_offset:=
					lady_cottage_dialog(lady_cottage_knock_door_message);


		end; { verb_knock }


	VERB_OPEN: begin

		{ handle both, I guess this is safe? }

		if (current_noun=NOUN_DOOR) then current_noun:=NOUN_NONE;

		if (current_noun=NOUN_NONE) then begin

			{ TODO: walk to door }
			{peasant_walkto(23,116);}

			print_offset:=lady_cottage_dialog(lady_cottage_open_door_message);

			update_map_location(LOCATION_INSIDE_LADY);
		end;

	end; {verb open }

	end; {case}
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
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GOLADY');
	decompress(background,file_buffer);

	{ screen_copy(screen_ptr(framebuffer),screen_ptr(background));

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

		if level_over <> LEVEL_NOT_OVER then goto done_outside_lady;

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

done_outside_lady:

	{ check borders }

	if (map_location=LOCATION_INSIDE_LADY) then begin
		peasant_x:=25*8;
		peasant_newy:=140;
		peasant_dir:=2; { PEASANT_DIR_LEFT }
	end;
end;
