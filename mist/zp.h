// MIST zero page addresses

//FRAMEL			= $60
//FRAMEH			= $61
//CURSOR_X		= $62
//CURSOR_Y		= $63
//XPOS			= $64
//YPOS			= $65
//LOCATION_STRUCT_L	= $66
//LOCATION_STRUCT_H	= $67
//IN_SPECIAL		= $68
//CURSOR_VISIBLE		= $69
//IN_LEFT			= $6A
//IN_RIGHT		= $6B
//BTC_L			= $6C
//BTC_H			= $6D

// We have to save/restore the following values
// when loading/storing from disk

struct zero_page {
	unsigned char which_level;	// which level to load
#define LEVEL_TITLE	0
#define LEVEL_MIST	1
	unsigned char direction;	// direction we are pointing
#define DIRECTION_N		0x01
#define DIRECTION_S		0x02
#define DIRECTION_E		0x04
#define DIRECTION_W		0x08
#define DIRECTION_ANY		0x0f
#define DIRECTION_ONLY_POINT	0x40	// do not change pointer to grab
#define	DIRECTION_SPLIT		0x80	// split text/graphics
	unsigned char location;		// location on the map
	unsigned char red_pages_taken;	// red pages that have been picked up
#define OCTAGON_PAGE	0x01
#define	MECHE_PAGE	0x02
#define	SELENA_PAGE	0x04
#define	STONEY_PAGE	0x08
#define	CHANNEL_PAGE	0x10
#define FINAL_PAGE	0x20
	unsigned char blue_pages_taken;	// blue pages that have been picked up
	unsigned char clock_bridge;	// is the clock island bridge raised
	unsigned char gear_open;	// is the big gear open
	unsigned char marker_switches;	// state of the marker switches
#define MARKER_DOCK		0x01
#define MARKER_GEARS		0x02
#define MARKER_SPACESHIP	0x04
#define MARKER_GENERATOR	0x08
#define MARKER_CLOCK		0x10
#define	MARKER_TREE		0x20
#define MARKER_POOL		0x40
#define MARKER_DENTIST		0x80
	unsigned char clock_hour;	// hour on the mist clock
	unsigned char clock_minute;	// minute on the mist clock

	unsigned char boiler_level;	// furnace in the cabin level

	unsigned char fileplace_grid[6];// fireplace grid puzzle state

	unsigned char clock_count;	// clock puzzle (turns taken)
	unsigned char clock_top;	// clock puzzle (top dial)
	unsigned char clock_middle;	// clock puzzle (middle dial)
	unsigned char clock_bottom;	// clock puzzle (bottom dial)
	unsigned char clock_last;	// clock puzzle (last dial turned)

	unsigned char breaker_tripped;	// generator (circuit breakers status)
	unsigned char generator_volts;	// generator (total volts)
	unsigned char rocket_volts;	// generator (rocket volts)
	unsigned char switch_top_row;	// generator (switch top row)
	unsigned char switch_bottom_row;// generator (switch bottom row)
	unsigned char generator_volts_disp;	//  generator (total volts on display)
	unsigned char rocket_volts_disp;	// generator (rocket volts on display)

	unsigned char rocket_handle_step;	//  organ (which knob is lit) [why zp?]
	unsigned char rocket_npte[4];	// organ (note slider 1-4)

	unsigned char meche_elevator;	// fortress elevator state
	unsigned char meche_rotation;	// fortress rotation state
	// 0..3  = S
	// 4..7  = E
	// 8..11  = N
	// 12..15 = W
	unsigned char meche_levers;	// fortress rotation levers
#define LEFT_LEVER 	1
#define RIGHT_LEVER	2
	unsigned char meche_lock[4];	// meche lock symbol1-4

	unsigned char holding_page;	//  which page in hand
#define HOLDING_RED_PAGE	0x80
#define HOLDING_BLUE_PAGE	0x40
#define HOLDING_WHITE_PAGE	0xC0
	//FINAL_PAGE   = $20
	//CHANNEL_PAGE = $10
	//STONEY_PAGE  = $08
	//SELENA_PAGE  = $04
	//MECHE_PAGE   = $02
	//OCTAGON_PAGE = $01

	unsigned char red_page_count;	// # of red pages in book
	unsigned char blue_page_count;	// # of blue pages in book

	unsigned char viewer_channel;	// viewer: current channel
	unsigned char viewer_latched;	// viewer: latched channel

	unsigned char tower_rotation;	// tower rotation: which
#define ROTATION_GEARS		2
#define ROTATION_DOCK		3
#define ROTATION_TREE		4
#define ROTATION_SPACESHIP	8
	unsigned char ship_raised;	//  ship raised or not

	unsigned char pump_state;	// stoneship pump state
#define DRAINED_EXIT		0x01
#define DRAINED_TUNNELS		0x02
#define DRAINED_LIGHTHOUSE	0x04

	unsigned char battery_charge;	// stoneship battery charge
	unsigned char compass_state;	//  stoneship compass state
#define COMPASS_DEFAULT		0	// cabin lights off
#define COMPASS_LIGHT_ON	1	// proper angle selected
	unsigned char crank_angle;	//  stoneship crank angle

	unsigned char white_page_taken;	//  white page taken

	unsigned char channel_switches;	// channelwood switches
#define CHANNEL_SW_FAUCET		0x80
#define CHANNEL_SW_WINDMILL		0x40
#define CHANNEL_SW_GATE_BOTTOM		0x20
#define CHANNEL_ELEVATOR1_UP		0x10
#define CHANNEL_SW_GATE_TOP		0x08
#define CHANNEL_BOOK_ELEVATOR_UP	0x04
#define CHANNEL_PIPE_EXTENDED		0x02
#define CHANNEL_BRIDGE_UP		0x01

	unsigned char channel_valves;	// channelwood valves
#define CHANNEL_VALVE1		0x01		// elevator2
#define CHANNEL_VALVE2		0x02		// big tree
#define CHANNEL_VALVE3		0x04		// broken
#define CHANNEL_VALVE4		0x08		// elevator1
#define CHANNEL_VALVE5		0x10		// entry
#define CHANNEL_VALVE6		0x20		// bridge

	unsigned char dentist_light;	//  dentist lightswitch
	unsigned char dentist_month;	//  dentist panel: month
	unsigned char dentist_day;	//  dentist panel: day
	unsigned char dentist_century;	// dentist panel: century
	unsigned char dentist_year;	//  dentist panel: year
	unsigned char dentist_hours;	//  dentist panel: hours
	unsigned char dentist_minutes;	//  dentist panel: minutes

	unsigned char pillar_on;	// pillars: which on/off
#define PILLAR_EYE		0x01
#define PILLAR_SNAKE		0x02
#define	PILLAR_BUG		0x04
#define PILLAR_ANCHOR		0x08
#define PILLAR_ARROW		0x10
#define PILLAR_LEAF		0x20
#define PILLAR_CROSS		0x40
#define PILLAR_EMU		0x80

	unsigned char green_book_progress;	// green book: what's been seen

	unsigned char dni_progress;		// dni: atrus status

	unsigned char compartment_open;		// dock marker switch compartment

	unsigned char game_complete;		// game has been completed

	unsigned char safe_hundreds;		// safe combination, hundreds
	unsigned char safe_tens;		// safe combination, tens
	unsigned char safe_ones;		//  safe combination, ones

	unsigned char tree_level;		//  how high is the tree hole

	unsigned char holding_item;
#define HOLDING_KEY		0x04
#define HOLDING_LIT_MATCH	0x02
#define HOLDING_MATCH		0x01

	unsigned char boiler_valve;	//  how many turns of the boiler valve

	unsigned char trunk_state;	//  trunk state in stonsehip
#define TRUNK_VALVE_OPEN	0x01
#define TRUNK_WATER_DRAINED	0x02
#define TRUNK_KEY_TAKEN		0x04
#define TRUNK_LID_OPEN		0x08
#define TRUNK_HATCH_OPEN	0x10
#define TRUNK_KEY_ON_FLOOR	0x20

	unsigned char selena_button_status;
#define SELENA_BUTTON1		0x01	// POOL  (water)
#define SELENA_BUTTON2		0x02	// CHASM (fire)
#define SELENA_BUTTON3		0x04	// CLOCK (ticking)
#define SELENA_BUTTON4		0x08	// CRYSTALS (whistle)
#define	SELENA_BUTTON5		0x10	// TUNNEL (wind)
#define SELENA_LIGHTSWITCH	0x80	// light in the tunnel

	unsigned char selena_antenna[5]; // rotation angle for antenna1-5
	unsigned char selena_lock[5];	// antenna lock slider1-5

	unsigned char selena_antenna_active;	// which antenna currently selected

	unsigned char sub_location;
	unsigned char sub_direction;

	unsigned char nibel_projector;	// which button on projector in nibel

};

struct game_state {
	unsigned char joystick_enabled;
	unsigned char sound_status;
	unsigned char level_over;
	unsigned char displ_page;
	unsigned char draw_page;
};

//; temp var per-world define
//LONG_FRAME	=	$E4	; nibel
//CURRENT_DISPLAY	=	$E4	; selena
//LAST_PLAYED	=	$E4	; selena

/* levels */
int level_mist(void);
