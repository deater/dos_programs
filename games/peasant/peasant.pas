program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02,cga;

{$I pq_vid.pas}
{$I pq_title.pas}
{$I pq_tips.pas}

{$I pq_knght.pas}
{$I d_knight.pas}

(*
{$I pq_ker1.pas}
{$I pq_ytree.pas}
{$I pq_inn.pas}
*)

{$I s_walk.pas}

{$I dialog_t.pas}
{$I o_common.pas}
{$I d_common.pas}

const WalkingSprites : array[0..23] of SpritePtr =
(
	{0 = up}

	@walk_u0_sprite,@walk_u1_sprite,@walk_u2_sprite,
	@walk_u3_sprite,@walk_u4_sprite,@walk_u5_sprite,

	{1 = right}

	@walk_r0_sprite,@walk_r1_sprite,@walk_r2_sprite,
	@walk_r3_sprite,@walk_r4_sprite,@walk_r5_sprite,

	{2 = left}

	@walk_l0_sprite,@walk_l1_sprite,@walk_l2_sprite,
	@walk_l3_sprite,@walk_l4_sprite,@walk_l5_sprite,

	{3 = down}

	@walk_d0_sprite,@walk_d1_sprite,@walk_d2_sprite,
	@walk_d3_sprite,@walk_d4_sprite,@walk_d5_sprite

);


	type verb_type = (
		VERB_UNKNOWN, VERB_ASK, VERB_BOO, VERB_BREAK,
		VERB_BUY, VERB_CHEAT, VERB_CLIMB, VERB_CLOSE,
		VERB_COPY, VERB_DANCE, VERB_DEPLOY, VERB_DIE,
		VERB_DITCH, VERB_DRINK, VERB_DROP, VERB_ENTER,
		VERB_FEED, VERB_GET, VERB_GIVE, VERB_GO,
		VERB_HALDO, VERB_INVENTORY, VERB_JUMP, VERB_KICK,
		VERB_KILL, VERB_KNOCK, VERB_LIGHT, VERB_LOAD,
		VERB_LOOK, VERB_MAKE, VERB_MAP, VERB_NO,
		VERB_OPEN, VERB_PARTY, VERB_PET, VERB_PLAY,
		VERB_PULL, VERB_PUNCH, VERB_PUSH, VERB_PUT,
		VERB_PWD, VERB_QUIT, VERB_READ, VERB_RIDE,
		VERB_RING, VERB_SAVE, VERB_SCARE, VERB_SEARCH,
		VERB_SHOOT, VERB_SHOW, VERB_SIT, VERB_SKIP,
		VERB_SLEEP, VERB_SMELL, VERB_SNIFF, VERB_STEAL,
		VERB_SWIM, VERB_TAKE, VERB_TALK, VERB_THIS,
		VERB_THROW, VERB_TRY, VERB_TURN, VERB_USE,
		VERB_VERSION, VERB_WAKE, VERB_WEAR, VERB_WHAT,
		VERB_WHERE, VERB_WHY, VERB_YES, VERB_HELP,
		VERB_ATTACK, VERB_HUG, VERB_HIDE, VERB_MOVE,
		VERB_CUT, VERB_SAY, VERB_SLAY,
		VERB_ALL_DONE );

	const verb_lookup : array [0..78] of string[10] =
		('UNKNOWN', 'ASK', 'BOO', 'BREAK',
		'BUY', 'CHEAT', 'CLIMB', 'CLOSE',
		'COPY', 'DANCE', 'DEPLOY', 'DIE',
		'DITCH', 'DRINK', 'DROP', 'ENTER',
		'FEED', 'GET', 'GIVE', 'GO',
		'HALDO', 'INVENTORY', 'JUMP', 'KICK',
		'KILL', 'KNOCK', 'LIGHT', 'LOAD',
		'LOOK', 'MAKE', 'MAP', 'NO',
		'OPEN', 'PARTY', 'PET', 'PLAY',
		'PULL', 'PUNCH', 'PUSH', 'PUT',
		'PWD', 'QUIT', 'READ', 'RIDE',
		'RING', 'SAVE', 'SCARE', 'SEARCH',
		'SHOOT', 'SHOW', 'SIT', 'SKIP',
		'SLEEP', 'SMELL', 'SNIFF', 'STEAL',
		'SWIM', 'TAKE', 'TALK', 'THIS',
		'THROW', 'TRY', 'TURN', 'USE',
		'VERSION', 'WAKE', 'WEAR', 'WHAT',
		'WHERE', 'WHY', 'YES', 'HELP',
		'ATTACK', 'HUG', 'HIDE', 'MOVE',
		'CUT', 'SAY', 'SLAY'
	);
	

	type noun_type = (
		NOUN_NONE, NOUN_ARCHER, NOUN_ARROW, NOUN_BABY,
		NOUN_BEADS, NOUN_BELL, NOUN_BELT, NOUN_BERRIES,
		NOUN_BOAT, NOUN_BONE, NOUN_BOW, NOUN_BROOM,
		NOUN_BUSH, NOUN_CANDLE, NOUN_CAVE, NOUN_CHAIR,
		NOUN_CLIFF, NOUN_CLUB, NOUN_COLD, NOUN_COTTAGE,
		NOUN_CRANK, NOUN_CURTAIN, NOUN_DAN, NOUN_DESK,
		NOUN_DINGHY, NOUN_DOING_SPROINGS, NOUN_DOOR, NOUN_DRAWER,
		NOUN_DRESSER, NOUN_DUDE, NOUN_FEED, NOUN_FENCE,
		NOUN_FIRE, NOUN_FLIES, NOUN_FOOD, NOUN_FOOTPRINTS,
		NOUN_GAME, NOUN_GARY, NOUN_GREASE, NOUN_GREEN,
		NOUN_GROUND, NOUN_GUY, NOUN_HAY, NOUN_HOLE,
		NOUN_HORSE, NOUN_INN, NOUN_JHONKA, NOUN_KERREK,
		NOUN_KNIGHT, NOUN_LADY, NOUN_LAKE, NOUN_LANTERN,
		NOUN_LEG, NOUN_LIGHTNING, NOUN_MAN, NOUN_MAP,
		NOUN_MASK, NOUN_MUD, NOUN_NED, NOUN_NOTE,
		NOUN_OPENINGS, NOUN_PAINTING, NOUN_PAPER, NOUN_PEASANT,
		NOUN_PEBBLES, NOUN_PILLOW, NOUN_PILLS, NOUN_PLAGUE,
		NOUN_PLAQUE, NOUN_POT, NOUN_RICHES, NOUN_ROBE,
		NOUN_ROCKS, NOUN_ROOM, NOUN_RUB, NOUN_RUG,
		NOUN_SAND, NOUN_SANDWICH, NOUN_SHELF, NOUN_SIGN,
		NOUN_SKELETON, NOUN_SKULL, NOUN_SMELL, NOUN_SODA,
		NOUN_STUFF, NOUN_STUMP, NOUN_SUB, NOUN_TARGET,
		NOUN_TRACKS, NOUN_TREE, NOUN_TRINKET, NOUN_TROGDOR,
		NOUN_WATER, NOUN_WATERFALL, NOUN_WELL, NOUN_WINDOW,
		NOUN_WOMAN, NOUN_RIVER, NOUN_STONES, NOUN_IN_HAY,
		NOUN_PUDDLE, NOUN_MENDELEV, NOUN_BLEED, NOUN_IN_WELL,
		NOUN_BUCKET, NOUN_WISH, NOUN_ARMS, NOUN_GOLD,
		NOUN_MONEY, NOUN_CARPET, NOUN_BED, NOUN_MATTRESS,
		NOUN_PARCHMENT, NOUN_DONGOLEV, NOUN_HALDO, NOUN_SHIRT,
		NOUN_SHIELD, NOUN_SWORD, NOUN_HELM, NOUN_DRAGON,
		NOUN_QUIZ, NOUN_ROCK, NOUN_STONE, NOUN_UNKNOWN
		);

	type game_state_type = record 
		{ game state 0}
		BABY_IN_WELL,
		BUCKET_DOWN_WELL,
		TALKED_TO_MENDELEV,
		HALDO_TO_DONGOLEV,
		ARROW_BEATEN,
		GARY_SCARED,
		LADY_GONE,
		TRINKET_GIVEN : boolean;
		{ game state 1}
		FISH_FED,		{ also implies man gone and inn open }
		PUDDLE_WET,
		IN_HAY_BALE,
		ALREADY_GOT_ROOM,
		RAINING,
		NIGHT,
		POT_ON_HEAD,
		WEARING_ROBE : boolean;
		{game state 2}
		ON_FIRE,
		COTTAGE_ROCK_MOVED,
		KNUCKLES_BLEED,
		DRESSER_OPEN,
		TALKED_TO_KNIGHT,
		COVERED_IN_MUD,
		GOT_MUDDY_ALREADY,
		GREASE_ON_HEAD : boolean;
		{game state 3}
		SWORD_THROWN,
		CLIFF_CLIMBED,
		KNIGHT_MOVED,
		ASLEEP,
		KERREK_DEAD,
		GOT_RICHES : boolean;

	end;

var 
	dialog,common,background,framebuffer:buffer_ptr;

	screen:screentype absolute $B800:0000;
	level_over,frame,flame_count:byte;
	visited_0,visited_1,visited_2:byte;
	peasant_x,peasant_y:byte;
	peasant_xadd,peasant_yadd:integer; { signed }
	peasant_dir,peasant_steps:byte;
	ch:char;
	i:word;
	input_x:byte;
	input_buffer : string;

	game_state: game_state_type;

	current_verb: verb_type;
	current_noun: noun_type;

	


{=====================================}
{ Reset Prompt                        }
{=====================================}

Procedure reset_prompt;

begin
	Delete(input_buffer,1,Length(input_buffer));

	{ erase bottom of screen }
	Rectangle(0,190,320,200,0,@screen);

	input_x:=0;
	PrintCharXor('>',input_x,24);	
	input_x:=2;
end;

{=====================================}
{ disp_put_string                     }
{=====================================}

Procedure disp_put_string( x,y,offset: word; whichd: buffer_ptr);

var
	newx,dialog_offset: word;
	which: byte;

begin

	dialog_offset:=offset;
	newx:=x;

	while(whichd^[dialog_offset]<>0) do begin

		which:=whichd^[dialog_offset];

		if (which=13) then begin
			y:=y+1;
			newx:=x;
		end
		else if (which>=128) then begin
			which:=which and $7F;
			for i:=1 to Length(dialog_lookup[which]) do begin
				PrintCharXor(char(dialog_lookup[which][i]),
						newx,y);
				newx:=newx+1;
			end;
		end
		else begin
			PrintCharXor(char(which),newx,y);
			newx:=newx+1;
		end;
		dialog_offset:=dialog_offset+1;
	end;
end;

{=====================================}
{ print_text_message                  }
{=====================================}

Procedure print_text_message( offset: word; whichd: buffer_ptr);

var
	y2,dialog_offset,message_lines: word;

begin
	{ count_message_lines }

	message_lines:=0;
	dialog_offset:=offset;

	while (whichd^[dialog_offset]<>0) do begin

		if (whichd^[dialog_offset]=13) then begin
			message_lines:=message_lines+1;
		end;

		dialog_offset:=dialog_offset+1;
	end;

	message_lines:=message_lines+1; { for end }


	{ draw box }
	{ Apple II starts at 35,24 }
	{ Adjust for fact screen is 320, 5 columns in = 40 }
	{	40 to 280 }

	{ Y2 = 24+ 10*message_lines, originally 70? }
	y2:=24+16+8*message_lines;

	Rectangle(40,24,280,y2,255,@screen);	
	Hline(44,276,28,$AA,@screen);
	Hline(44,276,y2-4,$AA,@screen);
	Vline(28,y2-2,44,$EB,@screen);
	Vline(28,y2-2,272,$EB,@screen);

	{ print text }

{	PrintStringXor('test test',6,4); }

	disp_put_string(6,4,offset,whichd);

end;



	{===========================    }
	{ get verb                      }
	{===========================    }
	{ verb has to be the first word }

Procedure get_verb;

var
	i: verb_type;

begin
	current_verb := VERB_UNKNOWN;

{	PrintStringXor(chr(length(verb_lookup[ord(VERB_PARTY)])+48),6,14);}

	for i:=VERB_ASK to VERB_SLAY do begin

		if (verb_lookup[ord(i)]=
			Copy(input_buffer,1,length(verb_lookup[ord(i)]) ))

		then begin
			current_verb:=i;
		end;
	end;

end;


	{=========================== }
	{=========================== }
	{ get noun                   }
	{=========================== }
	{=========================== }

	{ assume command is "VERB SOMETHING SOMETHING SOMETHING" }
	{ skip to first space, return NONE if nothing else       }
	{               parse for first matching noun            }
	{               return UNKNOWN if no matches             }

Procedure get_noun;

begin
	current_noun := NOUN_NONE;

end;




{=====================================}
{ parse input                         }
{=====================================}

Procedure parse_input;

label finish_parse_message;

var
	print_offset : common_offsets;

begin

	{===========================}
	{special case: pot on head}

	{lda     GAME_STATE_1}
	{and     #POT_ON_HEAD}
	{beq     no_pot_on_head}

	{ldx     #<inside_inn_pot_on_head_message}
	{ldy     #>inside_inn_pot_on_head_message}
	{jmp     finish_parse_message}

{no_pot_on_head:}

	{======================}
	{ uppercase the buffer }

	for i:=1 to Length(input_buffer) do begin
		input_buffer[i]:=upCase(input_buffer[i]);
	end;

	{=====================}
	{get the verb }

	get_verb;

	{=====================}
	{get the noun }

	get_noun;


	{=====================================}
	{ COMMON ROUTINES
	{=====================================}
	{ here if no custom dialog from level }

	print_offset:=unknown_message;

	case current_verb of

		VERB_ASK:	print_offset:=unknown_ask_message;

		VERB_BOO:	print_offset:=boo_message;

		VERB_CHEAT:	print_offset:=cheat_message;

		VERB_CLIMB:	begin
				{ TODO }
				end;

		VERB_COPY:	begin
				{ TODO }
				end;

		VERB_DANCE:	print_offset:=dance_message;
		
		VERB_DIE:	begin
				{ TODO }
				end;

		VERB_DITCH:	begin
				{ TODO }
				end;

		VERB_DROP:	begin
				{ TODO }
				end;

		VERB_DRINK:	begin
				{ TODO }
				end;

		VERB_THROW:	begin
				{ TODO }
				end;

		VERB_GET:	begin
				{ TODO }
				end;
		VERB_TAKE:	begin
				{ TODO }
				end;
		VERB_STEAL:	begin
				{ TODO }
				end;

		VERB_GIVE:	print_offset:=give_message;

		VERB_GO:	print_offset:=go_message;

		VERB_HALDO:	print_offset:=haldo_message;

		VERB_HELP:	print_offset:=help_message;

		VERB_INVENTORY:	begin
				{ TODO }
				end;

		VERB_LOAD:	begin
				{ TODO }
				end;

		VERB_LOOK:	begin
				{ TODO }
				end;

		VERB_MAP:	begin
				{ TODO }
				end;

		VERB_PARTY:	print_offset:=party_message;

		VERB_PWD:	begin
				{ TODO }
				end;

		VERB_QUIT:	begin
				{ TODO }
				end;

		VERB_SAVE:	begin
				{ TODO }
				end;

		VERB_SHOW:	begin
				{ TODO }
				end;

		VERB_SNIFF:	print_offset:=smell_message;

		VERB_SMELL:	print_offset:=smell_message;

		VERB_TALK:	print_offset:=talk_noone_message;

		VERB_UNKNOWN:	print_offset:=unknown_message;

		VERB_VERSION:	print_offset:=version_message;

		VERB_WEAR:	begin
				{ TODO }
				end;

		VERB_THIS:	print_offset:=what_message;

		VERB_WHAT:	print_offset:=what_message;

		VERB_WHERE:	begin
				{ TODO }
				end;

		VERB_WHY:	print_offset:=why_message;

	end;


finish_parse_message:

	print_text_message(
			common_lookup[ord(print_offset)],common);

	repeat until keypressed;

	{ throw away keypress }
	ch:=readkey;
end;


{=====================================}
{ stop peasant                        }
{=====================================}

Procedure stop_peasant;

begin
	peasant_xadd:=0;
	peasant_yadd:=0;
end;

{=====================================}
{ graphics input                      }
{=====================================}

Procedure graphics_input(ch: char);

begin

	{ backspace }
	if (ch=chr(8)) then begin

		{ erase last character }

		if (length(input_buffer)>0) then begin
			input_x:=input_x-1;
			PrintCharXor(input_buffer[length(input_buffer)],
				input_x,24);
			Delete(input_buffer,Length(input_buffer),1);
		end
	end

	{ enter }
	else if (ch=chr(13)) then begin
		
		stop_peasant;
		
		parse_input;

		reset_prompt;

	end

	{ anything else }
	else begin
		if (Length(input_buffer)<40) then begin
			input_buffer:=input_buffer+ch;
			PrintCharXor(ch,input_x,24);
			input_x:=input_x+1;
		end
	end;
	
end;


{=====================================}
{ Check keyboard                      }
{=====================================}

Procedure check_keyboard;

var
	ch,ch2:char;

begin
	{ drain keyboard buffer}

	if keypressed=false then exit;

	ch:=readkey;

	if ch=chr(0) then begin
		ch2:=readkey;

		case ch2 of

			'M':	begin	{ right }

				{ if already moving right, stop}
				if peasant_xadd = 1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving right, start moving right}
				else begin
					peasant_xadd:=1;
					peasant_yadd:=0;
				end;

				peasant_dir:=1; { PEASANT_DIR_RIGHT}

				end;

			'K':	begin	{ left }

				{ if already moving left, stop}
				if peasant_xadd = -1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving left, start moving left}
				else begin
					peasant_xadd:=-1;
					peasant_yadd:=0;
				end;

				peasant_dir:=2; { PEASANT_DIR_LEFT}

				end;

			'H':	begin	{ up }

				{ if already moving up, stop}
				if peasant_yadd = -1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving up, start moving up}
				else begin
					peasant_xadd:=0;
					peasant_yadd:=-1;
				end;

				peasant_dir:=0; { PEASANT_DIR_UP}

				end;

			'P':	begin	{ down }

				{ if already moving down, stop}
				if peasant_yadd = 1 then begin
					peasant_xadd:=0;
					peasant_yadd:=0;		
				end
				{ not moving down, start moving down}
				else begin
					peasant_xadd:=0;
					peasant_yadd:=1;
				end;

				peasant_dir:=3; { PEASANT_DIR_DOWN}

				end;

		end;
	end

	else begin
		{ all other keys }

		{  Note, it handles enter }

		graphics_input(ch);

	end;
end;

{=============================}
{ Move peasant                }
{=============================}

Procedure move_peasant;

begin
	if (peasant_xadd<>0) or (peasant_yadd<>0) then begin

		{ moving }

		peasant_steps:=peasant_steps+1;
		if (peasant_steps>=6) then peasant_steps:=0;

		peasant_x:=peasant_x+peasant_xadd;
		peasant_y:=peasant_y+peasant_yadd;
	end;

	
end;


{=============================}
{ Draw Peasant                }
{=============================}

Procedure draw_peasant;

var which : byte;

begin

	which := (peasant_dir*6)+peasant_steps;

	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],screen_ptr(framebuffer));
{	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],@screen);}
end;


{************************************}
{ do_knight                          }
{************************************}

Procedure do_knight(mode: byte);

label done_knight;

begin
	level_over:=0;
	frame:=0;
	flame_count:=0;

	{ decompress dialog }

	decompress(dialog,@D_KNIGHT);

	{ decompress priority }

	{ load bg }

	decompress(background,@PQ_KNIGHT);

	screen_copy(screen_ptr(framebuffer),screen_ptr(background));

	screen_copy(@screen,screen_ptr(framebuffer));

	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',25,0);

	reset_prompt;
	
	{ move knight }

	visited_1:=visited_1 or 16;	{ MAP_MOUNTAIN_PASS}

	while(true) do begin

		{ check_keyboard }

		check_keyboard;

		{ erase peasant }
		RestoreBG(peasant_x,peasant_y,4,15,
			screen_ptr(background),screen_ptr(framebuffer));

		{ move_peasant }

		move_peasant;

		if level_over <> 0 then goto done_knight;

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

done_knight:

	repeat until keypressed;
	ch:=readkey;
end;


{************************************}
{ tips_screen                        }
{************************************}

{         1         2         3
0123456789012345678901234567890123456789
   Here's how things work round here:           8
-Look around by typing stuff like 'look         10
 tree' or just plain 'look'                     11
-Talk to folks by typing stuff like             12
 'talk man'                                     13
-Take items by typing 'get (item)'              14
-Use items by typing 'use (item)' You can       15
 also 'give (item)' 'throw(item)' or some       16
 other action words                             17
-Type 'inv' to see your INVENTORY               18
-Type 'save' to save your game and 'load'       19
 to load one. To save games, your browser       20
 must have cookies enabled                      21
-press + and - to speed up or slow down your    22
 character                                      23
}


Procedure tips_screen;

begin

	decompress(@screen,@PQ_TIPS);
	PrintStringXor('Here''s how things work round here:',3,8);
	PrintStringXor('-Look around by typing stuff like ''look',0,10);
	PrintStringXor(' tree'' or just plain ''look''',0,11);
	PrintStringXor('-Talk to folks by typing stuff like',0,12);
	PrintStringXor(' ''talk man''',0,13);
	PrintStringXor('-Take items by typing ''get (item)''',0,14);
	PrintStringXor('-Use items by typing ''use (item)'' You',0,15);
	PrintStringXor(' can also ''give (item)'' ''throw(item)''',0,16);
	PrintStringXor(' or some other action words',0,17);
	PrintStringXor('-Type ''inv'' to see your INVENTORY',0,18);
	PrintStringXor('-Type ''save'' to save your game and',0,19);
	PrintStringXor(' ''load'' to load one.',0,20);
	PrintStringXor('-press + and - to speed up or slow down',0,22);
	PrintStringXor(' your character',0,23);
end;

Procedure init_game_state;

begin
	with game_state do begin
		BABY_IN_WELL := false;
		BUCKET_DOWN_WELL := false;
		TALKED_TO_MENDELEV := false;
		HALDO_TO_DONGOLEV := false;
		ARROW_BEATEN := false;
		GARY_SCARED := false;
		LADY_GONE := false;
		TRINKET_GIVEN := false;

		FISH_FED := false;
		PUDDLE_WET := false;
		IN_HAY_BALE := false;
		ALREADY_GOT_ROOM := false;
		RAINING := false;
		NIGHT := false;
		POT_ON_HEAD := false;
		WEARING_ROBE := false;

		ON_FIRE := false;
		COTTAGE_ROCK_MOVED := false;
		KNUCKLES_BLEED := false;
		DRESSER_OPEN := false;
		TALKED_TO_KNIGHT := false;
		COVERED_IN_MUD := false;
		GOT_MUDDY_ALREADY := false;
		GREASE_ON_HEAD := false;

		SWORD_THROWN := false;
		CLIFF_CLIMBED := false;
		KNIGHT_MOVED := false;
		ASLEEP := false;
		KERREK_DEAD := false;
		GOT_RICHES := false;
	end;
end;

{====================================}
{ Main                               }
{====================================}

begin
	{Set CGA mode 4}

	SetCGAMode(4);

	{**************************************************}
	{ Videlectrix Logo }
	{**************************************************}

	SetPalette(1);

	decompress(@screen,@PQ_VID);
	repeat until keypressed;
	ch:=readkey;

	{**************************************************}
	{ Title Screen }
	{**************************************************}

	SetPalette(0);			{ yellow palette }

	decompress(@screen,@PQ_TITLE);
	repeat until keypressed;
	ch:=readkey;

	{**************************************************}
	{ Tips Screen }
	{**************************************************}

	SetPalette(1);			{ cyan palette }

	tips_screen;


	repeat until keypressed;
	ch:=readkey;

	{*****************}
	{ allocate memory }
	{*****************}

	GetMem(background,16384);
	GetMem(framebuffer,16384);
	GetMem(dialog,4096);
	GetMem(common,4096);

	decompress(common,@D_COMMON);

	{****************}
	{ init variables }
	{****************}

	peasant_x:=100;
	peasant_y:=100;
	peasant_xadd:=0;
	peasant_yadd:=0;
	peasant_dir:=0;
	peasant_steps:=0;
	input_x:=0;

	init_game_state;

	do_knight(0);

(*
	decompress(@screen,@PQ_YTREE);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',25,0);

	repeat until keypressed;
	ch:=readkey;

	SetPalette(0);

	repeat until keypressed;
	ch:=readkey;


	decompress(@screen,@PQ_INN);
	PrintStringXor('Score:0 out of 150',0,0);
	PrintStringXor('Peasant''s Quest',24,0);

	for i:=0 to 10 do begin
		PutPixelXY(0,50+i);
	end;

	repeat until keypressed;
	ch:=readkey;
*)
	{ Restore Text Mode}
	SetCGAMode(3);

end.
