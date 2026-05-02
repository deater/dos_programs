	{=====================================}
	{ UNKNOWN ACTIONS                     }
	{=====================================}

Procedure unknown_actions;

begin

end;


{************************************}
{ do_unknown                         }
{************************************}

Procedure do_unknown;

label done_unknown;

begin
	level_over:=LEVEL_NOT_OVER;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

{	wad_load(file_buffer,'DKNIGHT');
	decompress(buffer_ptr(@dialog^[4096]),file_buffer);
}
	{ decompress priority }

	wad_load(file_buffer,'PUNKNOWN');
	decompress(buffer_ptr(collision),file_buffer);

	{ load bg }

	wad_load(file_buffer,'GUNKNOWN');
	decompress(background,file_buffer);

	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));

	update_score;

	reset_prompt;

	{ move unknown }

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

		if level_over <> LEVEL_NOT_OVER then goto done_unknown;

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

done_unknown:

{	repeat until keypressed;
	ch:=readkey;
}
end;


