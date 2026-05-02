program peasants_quest;
{by Vince 'Deater' Weaver}

uses crt,zx02_asm,cga;

{$I pq_vid.pas}
{$I pq_title.pas}
{$I pq_tips.pas}


Procedure yellow_tree_actions; forward;
Procedure waterfall_actions; forward;
Procedure east_lake_actions; forward;
Procedure river_actions; forward;
Procedure knight_actions; forward;
Procedure outside_inn_actions; forward;
Procedure outside_lady_actions; forward;
Procedure burn_tree_actions; forward;
Procedure inside_inn_actions; forward;
Procedure inside_lady_actions; forward;


{$I o_ytree.pas}
{$I o_wfall.pas}
{$I o_rock.pas}
{$I o_knight.pas}
{$I o_elake.pas}
{$I o_inn.pas}
{$I o_olady.pas}
{$I o_btree.pas}
{$I o_iinn.pas}
{$I o_ilady.pas}

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

	type level_over_type = (
		LEVEL_NOT_OVER,
		LEVEL_NEW_LOCATION,
		LEVEL_NEW_FROM_DISK,
		LEVEL_NEW_FROM_LOAD,
		LEVEL_EXIT_TO_DOS
	);

	type map_locations = (
		LOCATION_POOR_GARY,		{ 0 }
		LOCATION_KERREK_1,		{ 1 }
		LOCATION_OLD_WELL,		{ 2 }
		LOCATION_YELLOW_TREE,		{ 3 }
		LOCATION_WATERFALL,		{ 4 }
		LOCATION_HAY_BALE,		{ 5 }
		LOCATION_MUD_PUDDLE,		{ 6 }
		LOCATION_ARCHERY,		{ 7 }
		LOCATION_RIVER_STONE,		{ 8 }
		LOCATION_MOUNTAIN_PASS,		{ 9 }
		LOCATION_JHONKA_CAVE,		{ 10 }
		LOCATION_YOUR_COTTAGE,		{ 11 }
		LOCATION_LAKE_WEST,		{ 12 }
		LOCATION_LAKE_EAST,		{ 13 }
		LOCATION_OUTSIDE_INN,		{ 14 }
		LOCATION_OUTSIDE_NN,		{ 15 }
		LOCATION_WAVY_TREE,		{ 16 }
		LOCATION_KERREK_2,		{ 17 }
		LOCATION_OUTSIDE_LADY,		{ 18 }
		LOCATION_BURN_TREES,		{ 19 }
		LOCATION_CLIFF_BASE,		{ 20 }
		LOCATION_CLIFF_HEIGHTS,		{ 21 }
		LOCATION_TROGDOR_OUTER,		{ 22 }
		LOCATION_TROGDOR_LAIR,		{ 23 }
		LOCATION_HIDDEN_GLEN,		{ 24 }
		LOCATION_INSIDE_LADY,		{ 25 }
		LOCATION_INSIDE_NN,		{ 26 }
		LOCATION_INSIDE_INN,		{ 27 }
		LOCATION_ARCHERY_GAME,		{ 28 }
		LOCATION_MAP,			{ 29 }
		LOCATION_CLIMB,			{ 30 }
		LOCATION_TROGDOR_OUTER2,	{ 31 }
		LOCATION_TROGDOR_OUTER3,	{ 32 }
		LOCATION_INSIDE_INN_NIGHT,	{ 33 }
		LOCATION_EMPTY			{ 34 }
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
		NOUN_WATERFALL, NOUN_WATER, NOUN_WELL, NOUN_WINDOW,
		NOUN_WOMAN, NOUN_RIVER, NOUN_STONES, NOUN_IN_HAY,
		NOUN_PUDDLE, NOUN_MENDELEV, NOUN_BLEED, NOUN_IN_WELL,
		NOUN_BUCKET, NOUN_WISH, NOUN_ARMS, NOUN_GOLD,
		NOUN_MONEY, NOUN_CARPET, NOUN_BED, NOUN_MATTRESS,
		NOUN_PARCHMENT, NOUN_DONGOLEV, NOUN_HALDO, NOUN_SHIRT,
		NOUN_SHIELD, NOUN_SWORD, NOUN_HELM, NOUN_DRAGON,
		NOUN_QUIZ, NOUN_ROCK, NOUN_STONE, NOUN_UNKNOWN
		);

	const noun_lookup : array [0..123] of string[10] = (
		'NONE', 'ARCHER', 'ARROW', 'BABY',
		'BEADS', 'BELL', 'BELT', 'BERRIES',
		'BOAT', 'BONE', 'BOW', 'BROOM',
		'BUSH', 'CANDLE', 'CAVE', 'CHAIR',
		'CLIFF', 'CLUB', 'COLD', 'COTTAGE',
		'CRANK', 'CURTAIN', 'DAN', 'DESK',
		'DINGHY', 'DOING_SPROINGS', 'DOOR', 'DRAWER',
		'DRESSER', 'DUDE', 'FEED', 'FENCE',
		'FIRE', 'FLIES', 'FOOD', 'FOOTPRINTS',
		'GAME', 'GARY', 'GREASE', 'GREEN',
		'GROUND', 'GUY', 'HAY', 'HOLE',
		'HORSE', 'INN', 'JHONKA', 'KERREK',
		'KNIGHT', 'LADY', 'LAKE', 'LANTERN',
		'LEG', 'LIGHTNING', 'MAN', 'MAP',
		'MASK', 'MUD', 'NED', 'NOTE',
		'OPENINGS', 'PAINTING', 'PAPER', 'PEASANT',
		'PEBBLES', 'PILLOW', 'PILLS', 'PLAGUE',
		'PLAQUE', 'POT', 'RICHES', 'ROBE',
		'ROCKS', 'ROOM', 'RUB', 'RUG',
		'SAND', 'SANDWICH', 'SHELF', 'SIGN',
		'SKELETON', 'SKULL', 'SMELL', 'SODA',
		'STUFF', 'STUMP', 'SUB', 'TARGET',
		'TRACKS', 'TREE', 'TRINKET', 'TROGDOR',
		'WATERFALL', 'WATER', 'WELL', 'WINDOW',
		'WOMAN', 'RIVER', 'STONES', 'IN_HAY',
		'PUDDLE', 'MENDELEV', 'BLEED', 'IN_WELL',
		'BUCKET', 'WISH', 'ARMS', 'GOLD',
		'MONEY', 'CARPET', 'BED', 'MATTRESS',
		'PARCHMENT', 'DONGOLEV', 'HALDO', 'SHIRT',
		'SHIELD', 'SWORD', 'HELM', 'DRAGON',
		'QUIZ', 'ROCK', 'STONE', 'UNKNOWN'
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

	type inventory_type = record
		{ Inventory 1}
		ARROW,
		BABY,
		KERREK_BELT,
		CHICKEN_FEED,
		BOW,
		MONSTER_MASK,
		PEBBLES,
		PILLS : boolean;
		{ Inventory 2}
		RICHES,
		ROBE,
		SODA,
		MEATBALL_SUB,
		TRINKET,
		TROGHELM,
		TROGSHIELD,
		TROGSWORD : boolean;
		{ Inventory 3}
		IMPOSSIBLE,
		SHIRT,
		MAP : boolean;
	end;


var
	visited_locations : array [0..34] of boolean;

	collision,file_buffer,dialog,background,framebuffer:buffer_ptr;

	score: word;
	screen:screentype absolute $B800:0000;
	frame,flame_count:byte;
	peasant_x,peasant_y,peasant_newy:integer; {signed }
	peasant_xadd,peasant_yadd:integer; { signed }
	peasant_dir,peasant_steps:byte;
	ch:char;
	i,next_space:word;
	input_x:byte;
	input_buffer : string;

	level_over: level_over_type;
	game_state: game_state_type;
	bush_status: byte;

	inventory,inventory_gone: inventory_type;

	previous_location, map_location : map_locations;

	print_offset : word;

	current_verb: verb_type;
	current_noun: noun_type;

label exit_to_dos;


{=====================================}
{ Update Score                        }
{=====================================}
{ also print it?  would we ever update w/o printing? }

{ this could be optimized more }

Procedure update_score;

var score_string : string[30];
    result,ones,tens,hundreds : Integer;
begin
	{ erase old score }
	Rectangle(0,0,319,10,$ff,@screen);

	ones:=score mod 10;		{ 3 }
	result:=score div 10;
	tens:=result mod 10;		{ 2 }
	result:=result div 10;
	hundreds:=result mod 10;	{ 1 }

	if (score<10) then begin
		score_string:='Score: 0 out of 150';
		score_string[8]:=chr(ones+48);
		PrintStringXor(score_string,0,0);
	end
	else if (score<100) then begin
		score_string:='Score: 10 out of 150';
		score_string[8]:=chr(tens+48);
		score_string[9]:=chr(ones+48);
		PrintStringXor(score_string,0,0);
	end
	else begin
		score_string:='Score: 100 out of 150';
		score_string[8]:=chr(hundreds+48);
		score_string[9]:=chr(tens+48);
		score_string[10]:=chr(ones+48);
		PrintStringXor(score_string,0,0);
	end;

	PrintStringXor('Peasant''s Quest',25,0);
end;

{=====================================}
{ Score Points                        }
{=====================================}

Procedure score_points(pts : byte);

begin
	score:=score+pts;

	update_score;

	{TODO: make noise}

end;



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

Procedure disp_put_string( x,y,offset: word);

var
	newx,dialog_offset: word;
	which: byte;

begin

	dialog_offset:=offset;
	newx:=x;

	while(dialog^[dialog_offset]<>0) do begin

		which:=dialog^[dialog_offset];

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

Procedure print_text_message( offset: word);

var
	y2,dialog_offset,message_lines: word;

begin
	{ count_message_lines }

	message_lines:=0;
	dialog_offset:=offset;

	while (dialog^[dialog_offset]<>0) do begin

		if (dialog^[dialog_offset]=13) then begin
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

	disp_put_string(6,4,offset);

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


{=====================================}
{ Noun Next Space                     }
{=====================================}
{ point to just after next space in parse input }

Procedure noun_next_space;

var x: word;

label done_noun_next_space;

begin

	for x:=next_space to Length(input_buffer) do begin
		if input_buffer[x]=' ' then begin
			next_space:=x+1;
			goto done_noun_next_space;
		end;
	end;
	next_space:=$FFFF;

done_noun_next_space:

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

var
	i: noun_type;
	next : word;
	label done_get_noun,get_noun_loop;

begin
	current_noun := NOUN_NONE;

	next_space:=1;

get_noun_loop:

	noun_next_space;

	if (next_space=$ffff) then goto done_get_noun;

	for i:=NOUN_ARCHER to NOUN_STONE do begin

		if (noun_lookup[ord(i)]=
			Copy(input_buffer,next_space,length(noun_lookup[ord(i)]) ))

		then begin
			current_noun:=i;
			goto done_get_noun;
		end;

	end;
	goto get_noun_loop;

done_get_noun:

end;


{=====================================}
{ partial message step                }
{=====================================}

Procedure partial_message_step;

begin
	print_text_message(print_offset);

	repeat until keypressed;

	{ throw away keypress }
	ch:=readkey;

end;


{=====================================}
{ parse input                         }
{=====================================}

Procedure parse_input;

label finish_parse_message;


begin

	{===========================}
	{special case: pot on head}

	if (game_state.POT_ON_HEAD) then begin

		print_offset:=common_dialog(inside_inn_pot_on_head_message);
		goto finish_parse_message;

	end;


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


	{=====================}
	{check for dan }

	if (current_noun=NOUN_DAN) then begin
		print_offset:=common_dialog(dan_message);
		goto finish_parse_message;
	end;

	{=================================}
	{ check if LOOKing at something in inventory}

	if (current_verb=VERB_LOOK) then begin
		{TODO}
		{look_check_if_in_inventory;}
		{if was, exit early}
	end;

	print_offset:=common_dialog(unknown_message);

	{=======================}
	{ Level-specific Actions}
	{=======================}
	case map_location of

		LOCATION_POOR_GARY:		knight_actions;
		LOCATION_KERREK_1:		knight_actions;
		LOCATION_OLD_WELL:		knight_actions;
		LOCATION_YELLOW_TREE:		yellow_tree_actions;
		LOCATION_WATERFALL:		waterfall_actions;
		LOCATION_HAY_BALE:		knight_actions;
		LOCATION_MUD_PUDDLE:		knight_actions;
		LOCATION_ARCHERY:		knight_actions;
		LOCATION_RIVER_STONE:		river_actions;
		LOCATION_MOUNTAIN_PASS:		knight_actions;
		LOCATION_JHONKA_CAVE:		knight_actions;
		LOCATION_YOUR_COTTAGE:		knight_actions;
		LOCATION_LAKE_WEST:		knight_actions;
		LOCATION_LAKE_EAST:		east_lake_actions;
		LOCATION_OUTSIDE_INN:		outside_inn_actions;
		LOCATION_OUTSIDE_NN:		knight_actions;
		LOCATION_WAVY_TREE:		knight_actions;
		LOCATION_KERREK_2:		knight_actions;
		LOCATION_OUTSIDE_LADY:		outside_lady_actions;
		LOCATION_BURN_TREES:		burn_tree_actions;
		LOCATION_CLIFF_BASE:		knight_actions;
		LOCATION_CLIFF_HEIGHTS:		knight_actions;
		LOCATION_TROGDOR_OUTER:		knight_actions;
		LOCATION_TROGDOR_LAIR:		knight_actions;
		LOCATION_HIDDEN_GLEN:		knight_actions;
		LOCATION_INSIDE_LADY:		inside_lady_actions;
		LOCATION_INSIDE_NN:		inside_inn_actions;
		LOCATION_INSIDE_INN:		knight_actions;
		LOCATION_ARCHERY_GAME:		knight_actions;
		LOCATION_MAP:			knight_actions;
		LOCATION_CLIMB:			knight_actions;
		LOCATION_TROGDOR_OUTER2:	knight_actions;
		LOCATION_TROGDOR_OUTER3:	knight_actions;
		LOCATION_INSIDE_INN_NIGHT:	knight_actions;
		LOCATION_EMPTY:			knight_actions;
	end;

	if (print_offset<>common_dialog(unknown_message)) then
		goto finish_parse_message;

	{=====================================}
	{ COMMON ROUTINES
	{=====================================}
	{ here if no custom dialog from level }

	print_offset:=common_dialog(unknown_message);

	{ Handle aliases here as Pascal has no fallthrough?}

	if (current_verb=VERB_DITCH) then current_verb:=VERB_DROP;
	if (current_verb=VERB_SNIFF) then current_verb:=VERB_SMELL;
	if (current_verb=VERB_TAKE) then current_verb:=VERB_GET;
	if (current_verb=VERB_STEAL) then current_verb:=VERB_GET;

	case current_verb of

		VERB_ASK:	print_offset:=common_dialog(unknown_ask_message);

		VERB_BOO:	print_offset:=common_dialog(boo_message);

		VERB_CHEAT:	print_offset:=common_dialog(cheat_message);

		VERB_CLIMB:	begin

				if (current_noun=NOUN_TREE) then begin
					if (game_state.night) then begin
						print_offset:=common_dialog(climb_tree_night_message);
					end
					else begin
						print_offset:=common_dialog(climb_tree_message);
					end;
				end;
				end;

		VERB_COPY:	begin
				{ TODO }
				end;

		VERB_DANCE:	print_offset:=common_dialog(dance_message);

		VERB_DIE:	begin
				level_over:=LEVEL_EXIT_TO_DOS;
				{ TODO }
				end;

		{also VERB_DITCH}
		VERB_DROP:	begin

				if (current_noun = NOUN_BABY) then begin

					if (inventory.baby = true) and
						(inventory_gone.baby = false)
						then begin

						print_offset:=common_dialog(ditch_baby_message);
					end
					else begin
						print_offset:=common_dialog(no_baby_message);
					end;


				end;

				end;

		VERB_DRINK:	begin

				print_offset:=common_dialog(drink_message);

				partial_message_step;

				print_offset:=common_dialog(drink_message2);

				end;

		VERB_THROW:	begin

				if (current_noun = NOUN_BABY) then begin

					if (inventory.baby = true) and
						(inventory_gone.baby = false)
						then begin

						print_offset:=common_dialog(throw_baby_yes_message);
					end
					else begin
						print_offset:=common_dialog(no_baby_message);
					end;


				end;

				end;

		{VERB_STEAL}
		{VERB_TAKE}
		VERB_GET:	begin

				if (current_noun = NOUN_PEBBLES) and
					(inventory.pebbles)
								then begin

					print_offset:=common_dialog(get_pebbles_message);

				end

				else print_offset:=common_dialog(get_message);

				end;

		VERB_GIVE:	print_offset:=common_dialog(give_message);

		VERB_GO:	print_offset:=common_dialog(go_message);

		VERB_HALDO:	print_offset:=common_dialog(haldo_message);

		VERB_HELP:	print_offset:=common_dialog(help_message);

		VERB_INVENTORY:	begin
				{ TODO }
				end;

		VERB_LOAD:	begin
				{ TODO }
				end;

		VERB_LOOK:	begin
				if (current_noun=NOUN_TREE) then
					print_offset:=
						common_dialog(look_trees_message)
				else
					print_offset:=
						common_dialog(look_irrelevant_message);
				end;

		VERB_MAP:	begin
				if (inventory.map) then begin

				{TODO}

				end
				else print_offset:=common_dialog(map_message);

				end;

		VERB_PARTY:	print_offset:=common_dialog(party_message);

		VERB_PWD:	begin
				{ TODO }
				end;

		VERB_QUIT:	print_offset:=common_dialog(quit_message);

		VERB_SAVE:	begin
				{ TODO }
				end;

		VERB_SHOW:	begin
				{ TODO }
				end;

		{VERB_SNIFF:}
		VERB_SMELL:	print_offset:=common_dialog(smell_message);

		VERB_TALK:	print_offset:=common_dialog(talk_noone_message);

		VERB_UNKNOWN:	print_offset:=common_dialog(unknown_message);

		VERB_VERSION:	print_offset:=common_dialog(version_message);

		VERB_WEAR:	begin

				if (current_noun = NOUN_ROBE) then begin
					if (inventory.ROBE) then begin
						{ TODO }
					end;

				end
				else if (current_noun = NOUN_BELT) then begin
					if (inventory.KERREK_BELT) then begin
						print_offset:=common_dialog(wear_belt_message);
					end;
				end
				else if (current_noun = NOUN_MASK) then begin
					if (inventory.MONSTER_MASK) then begin
						print_offset:=common_dialog(wear_mask_message);
					end;
				end

				end;

		VERB_THIS:	print_offset:=common_dialog(what_message);

		VERB_WHAT:	print_offset:=common_dialog(what_message);

		VERB_WHERE:	begin
				{ TODO }
				end;

		VERB_WHY:	print_offset:=common_dialog(why_message);

	end;


finish_parse_message:

	partial_message_step;

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

const exits_north : array [0..34] of map_locations = (
	LOCATION_OUTSIDE_NN,	{ LOCATION_POOR_GARY	=	0 }
	LOCATION_WAVY_TREE,	{ LOCATION_KERREK_1	=	1 }
	LOCATION_KERREK_2,	{ LOCATION_OLD_WELL	=	2 }
	LOCATION_OUTSIDE_LADY,	{ LOCATION_YELLOW_TREE	=	3 }
	LOCATION_BURN_TREES,	{ LOCATION_WATERFALL	=	4 }

	LOCATION_POOR_GARY,	{ LOCATION_HAY_BALE	=	5 }
	LOCATION_KERREK_1,	{ LOCATION_MUD_PUDDLE	=	6 }
	LOCATION_OLD_WELL,	{ LOCATION_ARCHERY	=	7 }
	LOCATION_YELLOW_TREE,	{ LOCATION_RIVER_STONE	=	8 }
	LOCATION_WATERFALL,	{ LOCATION_MOUNTAIN_PASS=	9 }

	LOCATION_HAY_BALE,	{ LOCATION_JHONKA_CAVE	=	10 }
	LOCATION_MUD_PUDDLE,	{ LOCATION_YOUR_COTTAGE	=	11 }
	LOCATION_ARCHERY,	{ LOCATION_LAKE_WEST	=	12 }
	LOCATION_RIVER_STONE,	{ LOCATION_LAKE_EAST	=	13 }
	LOCATION_MOUNTAIN_PASS,	{ LOCATION_OUTSIDE_INN	=	14 }

	LOCATION_JHONKA_CAVE,	{ LOCATION_OUTSIDE_NN	=	15 }
	LOCATION_YOUR_COTTAGE,	{ LOCATION_WAVY_TREE	=	16 }
	LOCATION_LAKE_WEST,	{ LOCATION_KERREK_2	=	17 }
	LOCATION_LAKE_EAST,	{ LOCATION_OUTSIDE_LADY	=	18 }
	LOCATION_OUTSIDE_INN,	{ LOCATION_BURN_TREES	=	19 }

	LOCATION_CLIFF_HEIGHTS,	{ LOCATION_CLIFF_BASE	=	20 }
	LOCATION_EMPTY,		{ LOCATION_CLIFF_HEIGHTS=	21 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER=	22 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_LAIR	=	23 }

	LOCATION_EMPTY,		{ LOCATION_HIDDEN_GLEN	=	24 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_LADY	=	25 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_NN	=	26 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN	=	27 }

	LOCATION_EMPTY,		{ LOCATION_ARCHERY	=	28 }
	LOCATION_EMPTY,		{ LOCATION_MAP		=	29 }
	LOCATION_EMPTY,		{ LOCATION_CLIMB	=	30 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER2=	31 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER3=	32 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN_NIGHT=	33 }
	LOCATION_EMPTY		{ LOCATION_EMPTY	=	34 }
);

const exits_south : array [0..34] of map_locations = (

	LOCATION_HAY_BALE,	{ LOCATION_POOR_GARY	=	0 }
	LOCATION_MUD_PUDDLE,	{ LOCATION_KERREK_1	=	1 }
	LOCATION_ARCHERY,	{ LOCATION_OLD_WELL	=	2 }
	LOCATION_RIVER_STONE,	{ LOCATION_YELLOW_TREE	=	3 }
	LOCATION_MOUNTAIN_PASS,	{ LOCATION_WATERFALL	=	4 }

	LOCATION_JHONKA_CAVE,	{ LOCATION_HAY_BALE	=	5 }
	LOCATION_YOUR_COTTAGE,	{ LOCATION_MUD_PUDDLE	=	6 }
	LOCATION_LAKE_WEST,	{ LOCATION_ARCHERY	=	7 }
	LOCATION_LAKE_EAST,	{ LOCATION_RIVER_STONE	=	8 }
	LOCATION_OUTSIDE_INN,	{ LOCATION_MOUNTAIN_PASS=	9 }

	LOCATION_OUTSIDE_NN,	{ LOCATION_JHONKA_CAVE	=	10 }
	LOCATION_WAVY_TREE,	{ LOCATION_YOUR_COTTAGE	=	11 }
	LOCATION_KERREK_2,	{ LOCATION_LAKE_WEST	=	12 }
	LOCATION_OUTSIDE_LADY,	{ LOCATION_LAKE_EAST	=	13 }
	LOCATION_BURN_TREES,	{ LOCATION_OUTSIDE_INN	=	14 }

	LOCATION_POOR_GARY,	{ LOCATION_OUTSIDE_NN	=	15 }
	LOCATION_KERREK_1,	{ LOCATION_WAVY_TREE	=	16 }
	LOCATION_OLD_WELL,	{ LOCATION_KERREK_2	=	17 }
	LOCATION_YELLOW_TREE,	{ LOCATION_OUTSIDE_LADY	=	18 }
	LOCATION_WATERFALL,	{ LOCATION_BURN_TREES	=	19 }

	LOCATION_CLIFF_HEIGHTS,	{ LOCATION_CLIFF_BASE	=	20 }
	LOCATION_EMPTY,		{ LOCATION_CLIFF_HEIGHTS=	21 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER=	22 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_LAIR	=	23 }

	LOCATION_EMPTY,		{ LOCATION_HIDDEN_GLEN	=	24 }
	LOCATION_OUTSIDE_LADY,	{ LOCATION_INSIDE_LADY	=	25 }
	LOCATION_OUTSIDE_NN,	{ LOCATION_INSIDE_NN	=	26 }
	LOCATION_OUTSIDE_INN,	{ LOCATION_INSIDE_INN	=	27 }

	LOCATION_EMPTY,		{ LOCATION_ARCHERY	=	28 }
	LOCATION_EMPTY,		{ LOCATION_MAP		=	29 }
	LOCATION_EMPTY,		{ LOCATION_CLIMB	=	30 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER2=	31 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_OUTER3=	32 }
	LOCATION_OUTSIDE_INN,	{ LOCATION_INSIDE_INN_NIGHT=	33 }
	LOCATION_EMPTY		{ LOCATION_EMPTY	=	34 }
);

const exits_east : array [0..34] of map_locations = (
	LOCATION_KERREK_1,	{ LOCATION_POOR_GARY	=	0 }
	LOCATION_OLD_WELL,	{ LOCATION_KERREK_1	=	1 }
	LOCATION_YELLOW_TREE,	{ LOCATION_OLD_WELL	=	2 }
	LOCATION_WATERFALL,	{ LOCATION_YELLOW_TREE	=	3 }
	LOCATION_EMPTY,		{ LOCATION_WATERFALL	=	4 }

	LOCATION_MUD_PUDDLE,	{ LOCATION_HAY_BALE	=	5 }
	LOCATION_ARCHERY,	{ LOCATION_MUD_PUDDLE	=	6 }
	LOCATION_RIVER_STONE,	{ LOCATION_ARCHERY	=	7 }
	LOCATION_MOUNTAIN_PASS,	{ LOCATION_RIVER_STONE	=	8 }
	LOCATION_CLIFF_BASE,	{ LOCATION_MOUNTAIN_PASS=	9 }

	LOCATION_YOUR_COTTAGE,	{ LOCATION_JHONKA_CAVE	=	10 }
	LOCATION_LAKE_WEST,	{ LOCATION_YOUR_COTTAGE	=	11 }
	LOCATION_LAKE_EAST,	{ LOCATION_LAKE_WEST	=	12 }
	LOCATION_OUTSIDE_INN,	{ LOCATION_LAKE_EAST	=	13 }
	LOCATION_EMPTY,		{ LOCATION_OUTSIDE_INN	=	14 }

	LOCATION_WAVY_TREE,	{ LOCATION_OUTSIDE_NN	=	15 }
	LOCATION_KERREK_2,	{ LOCATION_WAVY_TREE	=	16 }
	LOCATION_OUTSIDE_LADY,	{ LOCATION_KERREK_2	=	17 }
	LOCATION_BURN_TREES,	{ LOCATION_OUTSIDE_LADY	=	18 }
	LOCATION_EMPTY,		{ LOCATION_BURN_TREES	=	19 }

	LOCATION_EMPTY,		{ LOCATION_CLIFF_BASE	=	20 }
	LOCATION_TROGDOR_OUTER,	{ LOCATION_CLIFF_HEIGHTS=	21 }
	LOCATION_TROGDOR_LAIR,	{ LOCATION_TROGDOR_OUTER=	22 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_LAIR	=	23 }

	LOCATION_POOR_GARY,	{ LOCATION_HIDDEN_GLEN	=	24 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_LADY	=	25 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_NN	=	26 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN	=	27 }

	LOCATION_EMPTY,		{ LOCATION_ARCHER	=	28 }
	LOCATION_EMPTY,		{ LOCATION_MAP		=	29 }
	LOCATION_EMPTY,		{ LOCATION_CLIMB	=	30 }
	LOCATION_TROGDOR_LAIR,	{ LOCATION_TROGDOR_OUTER2=	31 }
	LOCATION_TROGDOR_LAIR,	{ LOCATION_TROGDOR_OUTER3=	32 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN_NIGHT=	33 }
	LOCATION_EMPTY		{ LOCATION_EMPTY	=	34 }
);

const exits_west : array [0..34] of map_locations = (
	LOCATION_HIDDEN_GLEN,	{ LOCATION_POOR_GARY	=	0 }
	LOCATION_POOR_GARY,	{ LOCATION_KERREK_1	=	1 }
	LOCATION_KERREK_1,	{ LOCATION_OLD_WELL	=	2 }
	LOCATION_OLD_WELL,	{ LOCATION_YELLOW_TREE	=	3 }
	LOCATION_YELLOW_TREE,	{ LOCATION_WATERFALL	=	4 }

	LOCATION_EMPTY,		{ LOCATION_HAY_BALE	=	5 }
	LOCATION_HAY_BALE,	{ LOCATION_MUD_PUDDLE	=	6 }
	LOCATION_MUD_PUDDLE,	{ LOCATION_ARCHERY	=	7 }
	LOCATION_ARCHERY,	{ LOCATION_RIVER_STONE	=	8 }
	LOCATION_RIVER_STONE,	{ LOCATION_MOUNTAIN_PASS=	9 }

	LOCATION_EMPTY,		{ LOCATION_JHONKA_CAVE	=	10 }
	LOCATION_JHONKA_CAVE,	{ LOCATION_YOUR_COTTAGE	=	11 }
	LOCATION_YOUR_COTTAGE,	{ LOCATION_LAKE_WEST	=	12 }
	LOCATION_LAKE_WEST,	{ LOCATION_LAKE_EAST	=	13 }
	LOCATION_LAKE_EAST,	{ LOCATION_OUTSIDE_INN	=	14 }

	LOCATION_EMPTY,		{ LOCATION_OUTSIDE_NN	=	15 }
	LOCATION_OUTSIDE_NN,	{ LOCATION_WAVY_TREE	=	16 }
	LOCATION_WAVY_TREE,	{ LOCATION_KERREK_2	=	17 }
	LOCATION_KERREK_2,	{ LOCATION_OUTSIDE_LADY	=	18 }
	LOCATION_OUTSIDE_LADY,	{ LOCATION_BURN_TREES	=	19 }

	LOCATION_EMPTY,		{ LOCATION_CLIFF_BASE	=	20 }
	LOCATION_EMPTY,		{ LOCATION_CLIFF_HEIGHTS=	21 }
	LOCATION_CLIFF_HEIGHTS,	{ LOCATION_TROGDOR_OUTER=	22 }
	LOCATION_EMPTY,		{ LOCATION_TROGDOR_LAIR	=	23 }

	LOCATION_EMPTY,		{ LOCATION_HIDDEN_GLEN	=	24 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_LADY	=	25 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_NN	=	26 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN	=	27 }

	LOCATION_EMPTY,		{ LOCATION_ARCHERY	=	28 }
	LOCATION_EMPTY,		{ LOCATION_MAP		=	29 }
	LOCATION_EMPTY,		{ LOCATION_CLIMB	=	30 }
	LOCATION_CLIFF_HEIGHTS,	{ LOCATION_TROGDOR_OUTER2=	31 }
	LOCATION_CLIFF_HEIGHTS,	{ LOCATION_TROGDOR_OUTER3=	32 }
	LOCATION_EMPTY,		{ LOCATION_INSIDE_INN_NIGHT=	33 }
	LOCATION_EMPTY		{ LOCATION_EMPTY	=	34 }
);

	{=====================}
	{ update map location }
	{=====================}

Procedure update_map_location(new_location : map_locations);

begin
	previous_location:=map_location;

	map_location:=new_location;

	level_over:=LEVEL_NEW_LOCATION;
end;



	{=========================}
	{ Move Map North          }
	{=========================}

Procedure move_map_north;
begin
	previous_location:=map_location;
	map_location:=exits_north[ord(previous_location)];
	level_over:=LEVEL_NEW_LOCATION;
end;

	{=========================}
	{ Move Map SOUTH          }
	{=========================}

Procedure move_map_south;
begin
	previous_location:=map_location;
	map_location:=exits_south[ord(previous_location)];
	level_over:=LEVEL_NEW_LOCATION;
end;

	{=========================}
	{ Move Map EAST           }
	{=========================}

Procedure move_map_east;
begin
	previous_location:=map_location;
	map_location:=exits_east[ord(previous_location)];
	level_over:=LEVEL_NEW_LOCATION;
end;



	{=========================}
	{ Move Map WEST           }
	{=========================}
Procedure move_map_west;
begin
	previous_location:=map_location;
	map_location:=exits_west[ord(previous_location)];
	level_over:=LEVEL_NEW_LOCATION;
end;


{=============================}
{ Peasant Collide             }
{=============================}
{ newx/7 in Y				}
{ newy in X				}
{ returns C=0 if no collide		}
{ C=1 if collide			}
{					}
{ collide data, 6 rows of 40 columns	}
{       then in 8 bit chunks		}
{					}
{ rrrtttii				}
{       bottom 2 bits don't matter (lores tile is 4 rows high) }
{       next 3 bits = which of 8 bits is relevant	}
{       top 3 bits are row lookup	}

function peasant_collide(x, y: integer) : boolean;

const collision_offset : array[0..5] of byte = (
	0,40,80,120,160,200);

const collision_masks : array [0..7] of byte = (
	$80,$40,$20,$10,$08,$04,$02,$01
);

var temp2,temp3,temp4,temp5 : byte;

begin
	{ sprite is 24 wide? collide only with feet in the middle? }
	{ also assume 28 high? }

	{ the collision map is like this: }
	{ 6 rows of 40 bytes }

	x:=(x shr 3)+1;	{ each block 8 pixels wide, point to middle }

	y:=y+30;	{ point to feet }

	{ temp:=y shr 2;}	{ offset lookup? }

	temp2:=(y shr 2) and $7;	{ mask off bits }

	{ temp:=y shr 5; }

	{ shift right 5 for row }

	temp3:=collision_offset[(y shr 5)]+x;

	temp4:=collision^[960+temp3]; { get 8 bits of collision info }

	temp5:=temp4 and collision_masks[temp2];

	if (temp5=0) then peasant_collide:=false
	else peasant_collide:=true;

end;

{=============================}
{ Move peasant                }
{=============================}

Procedure move_peasant;

label peasant_the_same;

var newx,newy : integer;

begin
	if (peasant_xadd=0) and (peasant_yadd=0) then goto peasant_the_same;

	{ moving }

	{ adjust steps }

	peasant_steps:=peasant_steps+1;
	if (peasant_steps>=6) then peasant_steps:=0;

	{ move x }

	newx:=peasant_x+peasant_xadd;

	{ check if too far left }

	if newx<0 then begin
		move_map_west;
		peasant_x:=300;
		peasant_newy:=peasant_y;
		goto peasant_the_same;
	end;

	{ check if too far right }

	if newx>300 then begin
		move_map_east;
		peasant_x:=0;
		peasant_newy:=peasant_y;
		goto peasant_the_same;
	end;

	{ collision detect x }

	if (peasant_collide(newx,peasant_y)=true) then begin
		stop_peasant;
		newx:=peasant_x;
	end;

	{ Move Peasant Y }
	peasant_x:=newx;

	newy:=peasant_y+peasant_yadd;

	{ check if too far up }
	if newy<45 then begin
		move_map_north;
		peasant_newy:=160;
		goto peasant_the_same;
	end;

	{ check if too far down }
	if newy>160 then begin
		move_map_south;
		peasant_newy:=45;
		goto peasant_the_same;
	end;

	{ collision detect y }

	if (peasant_collide(peasant_x,newy)=true) then begin
		stop_peasant;
		newy:=peasant_y;
	end;

	peasant_y:=newy;

peasant_the_same:

end;


{=============================}
{ Draw Peasant                }
{=============================}

Procedure draw_peasant;

var which : byte;

begin

	which := (peasant_dir*6)+peasant_steps;

	CGA_draw_sprite_bg_mask(peasant_x,peasant_y,WalkingSprites[which],
		screen_ptr(framebuffer),screen_ptr(collision));
{	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],screen_ptr(framebuffer));}
{	SpriteXY(peasant_x,peasant_y,WalkingSprites[which],@screen);}
end;

{$I wad_load.pas}

{$I lytree.pas}
{$I lwfall.pas}
{$I lriver.pas}
{$I lknight.pas}
{$I lelake.pas}
{$I linn.pas}
{$I lolady.pas}
{$I lbtree.pas}
{$I liinn.pas }
{$I lilady.pas }


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
 also 'give (item)' 'throw (item)' or some      16
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
	PrintStringXor(' can also ''give (item)'' ''throw (item)''',0,16);
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

Procedure init_inventory;

begin
	with inventory do begin
		ARROW := false;
		BABY := false;
		KERREK_BELT := false;
		CHICKEN_FEED := false;
		BOW := false;
		MONSTER_MASK := false;
		PEBBLES := false;
		PILLS := false;
		RICHES := false;
		ROBE := false;
		SODA := false;
		MEATBALL_SUB := false;
		TRINKET := false;
		TROGHELM := false;
		TROGSHIELD := false;
		TROGSWORD := false;
		IMPOSSIBLE := false;
		SHIRT := false;
		MAP := false;
	end;
	with inventory_gone do begin
		ARROW := false;
		BABY := false;
		KERREK_BELT := false;
		CHICKEN_FEED := false;
		BOW := false;
		MONSTER_MASK := false;
		PEBBLES := false;
		PILLS := false;
		RICHES := false;
		ROBE := false;
		SODA := false;
		MEATBALL_SUB := false;
		TRINKET := false;
		TROGHELM := false;
		TROGSHIELD := false;
		TROGSWORD := false;
		IMPOSSIBLE := false;
		SHIRT := false;
		MAP := false;
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
	GetMem(dialog,8192);		{ probably could be smaller }
	GetMem(file_buffer,5*1024);	{ 4k is slightly to small }
	GetMem(collision,1024+256);

	decompress(dialog,@D_COMMON);

	{****************}
	{ init variables }
	{****************}

	level_over:=LEVEL_NOT_OVER;
	peasant_x:=100;
	peasant_y:=100;
	peasant_xadd:=0;
	peasant_yadd:=0;
	peasant_dir:=0;
	peasant_steps:=0;
	input_x:=0;
	score:=0;

	for i:=0 to 34 do visited_locations[i]:=false;

	init_game_state;
	bush_status:=0;

	init_inventory;

	map_location:=LOCATION_MOUNTAIN_PASS;

	{ main game loop }

	while(true) do begin

		case map_location of

		LOCATION_POOR_GARY:		do_knight;
		LOCATION_KERREK_1:		do_knight;
		LOCATION_OLD_WELL:		do_knight;
		LOCATION_YELLOW_TREE:		do_yellow_tree;
		LOCATION_WATERFALL:		do_waterfall;
		LOCATION_HAY_BALE:		do_knight;
		LOCATION_MUD_PUDDLE:		do_knight;
		LOCATION_ARCHERY:		do_knight;
		LOCATION_RIVER_STONE:		do_river;
		LOCATION_MOUNTAIN_PASS:		do_knight;
		LOCATION_JHONKA_CAVE:		do_knight;
		LOCATION_YOUR_COTTAGE:		do_knight;
		LOCATION_LAKE_WEST:		do_knight;
		LOCATION_LAKE_EAST:		do_east_lake;
		LOCATION_OUTSIDE_INN:		do_outside_inn;
		LOCATION_OUTSIDE_NN:		do_knight;
		LOCATION_WAVY_TREE:		do_knight;
		LOCATION_KERREK_2:		do_knight;
		LOCATION_OUTSIDE_LADY:		do_outside_lady;
		LOCATION_BURN_TREES:		do_burn_tree;
		LOCATION_CLIFF_BASE:		do_knight;
		LOCATION_CLIFF_HEIGHTS:		do_knight;
		LOCATION_TROGDOR_OUTER:		do_knight;
		LOCATION_TROGDOR_LAIR:		do_knight;
		LOCATION_HIDDEN_GLEN:		do_knight;
		LOCATION_INSIDE_LADY:		do_inside_lady;
		LOCATION_INSIDE_NN:		do_knight;
		LOCATION_INSIDE_INN:		do_inside_inn;
		LOCATION_ARCHERY_GAME:		do_knight;
		LOCATION_MAP:			do_knight;
		LOCATION_CLIMB:			do_knight;
		LOCATION_TROGDOR_OUTER2:	do_knight;
		LOCATION_TROGDOR_OUTER3:	do_knight;
		LOCATION_INSIDE_INN_NIGHT:	do_knight;
		LOCATION_EMPTY:			do_knight;
	end;


		if level_over<>LEVEL_NEW_FROM_LOAD then peasant_y:=peasant_newy;

		if level_over=LEVEL_EXIT_TO_DOS then goto exit_to_dos;
	end;

exit_to_dos:

	{ Restore Text Mode}
	SetCGAMode(3);

end.
