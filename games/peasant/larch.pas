	{=====================================}
	{ ARCHERY ACTIONS                     }
	{=====================================}

Procedure archery_actions;

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

	wad_load(file_buffer,'PYTREE');
	decompress(buffer_ptr(@collision^[8192]),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GARCH');
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
