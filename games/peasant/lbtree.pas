	{=====================================}
	{ BURNED TREE ACTIONS                 }
	{=====================================}

Procedure burn_tree_actions;

begin

	case current_verb of

	VERB_CLIMB:
		if current_noun=NOUN_CLIFF then
			print_offset:=
				waterfall_dialog(waterfall_climb_cliff_message);

	VERB_LOOK:	begin

		if (current_noun=NOUN_TREE) then
			print_offset:=waterfall_dialog(waterfall_look_tree_message);
		if (current_noun=NOUN_WATERFALL) then
			print_offset:=waterfall_dialog(waterfall_look_waterfall_message);
		if (current_noun=NOUN_NONE) then
			print_offset:=waterfall_dialog(waterfall_look_at_message);

		end; {verb_look}

	VERB_SWIM:
		if (current_noun=NOUN_WATER) or
			(current_noun=NOUN_WATERFALL) or
			(current_noun=NOUN_NONE) then
			print_offset:=
				waterfall_dialog(waterfall_swim_message);

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

	wad_load(file_buffer,'DWFALL');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);

	{ decompress priority }

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

{	repeat until keypressed;
	ch:=readkey;
}
end;
