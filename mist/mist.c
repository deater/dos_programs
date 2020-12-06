/* Main Program for MIST */

#include <stdio.h>
#include <string.h>

#include "zp.h"

struct zero_page zp;
struct game_state game;

int main(int argc, char **argv) {

	/* first time entry */
	/* start by loading text title */

	/* init variables */
	memset(&zp,0,sizeof(struct zero_page));
	memset(&game,0,sizeof(struct game_state));

//	text_title();		/* loading title */

//	title();		/* actual title display */

	zp.which_level=LEVEL_MIST;

	while(1) {

		switch(zp.which_level) {

			case LEVEL_MIST:
				break;

			default:
				break;
		}

	}

	return 0;
}
