#include <stdio.h>
#include <stdlib.h>
#include <jlib.h>

#define NUM_SPRITES 3
#define NUM_ITERATIONS 50000

/* A simple demo of sprite collision testing */
/* Taken from demo11.c from jlib distribution */

buffer_rec *offscreen,*faroffscreen;


int play_the_game(int level)
     {
	int i,johnx,johny;
	unsigned char *pal;
	sprite_system *john_sprites;
	int body[5] = {1,2,3,2,1};
	int head[1]= {0};
	
        john_sprites = sprite_init(NUM_SPRITES+1,64);
	pal = pal_load("pal.tmb");

	if((john_sprites == NULL) || (pal == NULL))
		jlib_exit("Initialization Failed.");

	if(sprite_load("johns.tmb",john_sprites)!=SUCCESS)
		jlib_exit("Sprite Load Failed.");

	screen_block_set_pal(pal);

        johnx=10; johny=10;

	sprite_set_xy(john_sprites,1,johnx,johny);
	sprite_set_an_frame(john_sprites,1,0);
        sprite_add_rect(john_sprites,0,0,0,10,10);
	sprite_set_anim_info(john_sprites,1,2,5,body);
	sprite_set_move_info(john_sprites,1,0,-2,-2);
 
	sprite_turn_on(john_sprites,1);
   
        sprite_set_xy(john_sprites,0,johnx,johny+10);
        sprite_set_an_frame(john_sprites,0,0);
        sprite_set_anim_info(john_sprites,0,2,1,head);
        sprite_set_move_info(john_sprites,0,0,-2,-2);

        sprite_turn_on(john_sprites,0);
        buff_clear(offscreen);
        buff_clear(faroffscreen);

	for(i=0;i<NUM_ITERATIONS;i++){
		sprite_update_all_anim_and_move(john_sprites);

		buff_save_all_sprites(john_sprites,offscreen);

	        buff_draw_all_sprites(john_sprites,offscreen);
		screen_blit_fs_buffer(offscreen);
	   
		buff_rest_all_sprites(john_sprites,offscreen);

		if(kb_keydown(KEY_UP))    johny=johny-1;
	        if(kb_keydown(KEY_DOWN))  johny=johny+1;
                if(kb_keydown(KEY_LEFT))  johnx=johnx-1;
	        if(kb_keydown(KEY_RIGHT)) johnx=johnx+1;
	     
	         sprite_set_xy(john_sprites,0,johnx,johny);
		 sprite_set_xy(john_sprites,1,johnx,johny+9);
	
		if(kb_keydown(KEY_Q)||kb_keydown(KEY_ESC))
			break;
	}

	return 1;
}
