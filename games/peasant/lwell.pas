	{=====================================}
	{ WELL ACTIONS                        }
	{=====================================}

Procedure well_actions;

begin

	case current_verb of

	VERB_LOOK:	begin

		if (current_noun=NOUN_TREE) then
			print_offset:=yellow_tree_dialog(yellow_tree_look_tree_message);
		if (current_noun=NOUN_COTTAGE) then
			print_offset:=yellow_tree_dialog(yellow_tree_look_cottage_message);
		if (current_noun=NOUN_NONE) then
			print_offset:=yellow_tree_dialog(yellow_tree_look_message);
		end; {verb_look}


	end; {case verb}

end;


{************************************}
{ do_well                     }
{************************************}

Procedure do_well;

label done_well;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	wad_load(file_buffer,'DWELL');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

	wad_load(file_buffer,'PWELL');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GWELL');
	decompress(background,file_buffer);

{	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer)); }

	screen_copy(@screen,screen_ptr(background));

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

		if level_over <> LEVEL_NOT_OVER then goto done_well;

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

done_well:
	{ check border }

	{ in actual game, walking down center pops you out gap in trees }
        { at archery }
        { walking to the left side of screen pops you out the trees on left }
        { but you can't go back that way }

	if (map_location=LOCATION_ARCHERY) then begin

		if (peasant_x>=(6*8)) then begin
	{ ======================= }
	{ if 8..25 exit at 25 }
	{ if 30-40 exit at 29 }
	{ else exit as-is }
			if (peasant_x<(25*8)) then peasant_x:=(25*8)
			else if (peasant_x<(29*8)) then peasant_x:=(29*8);
		end
		else begin
			{ exit_through_trees }
			peasant_newy:=50;
			peasant_x:=(8*8);
		end;
	end;
end;
