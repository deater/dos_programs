/* mist poc */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <SDL.h>

#include "cga_sim.h"

#define ROOMS	18

static char *rooms[ROOMS]={

	"dock_n",
	"dock_switch_n",
	"dock_steps_w",
	"above_dock_s",
	"step_base_s",
	"step_land1_w",
	"step_land2_w",
	"step_dentist_w",
	"step_land3_w",
	"step_top_w",
	"step_top_s",
	"pool_s",
	"tree1_s",
	"tree2_s",
	"tree4_s",
	"tree5_s",
	"clock_s",
	"clock_ansi",
};


int cga_load(char *name) {

	unsigned char temp[80*25];
	char filename[256];
	int fd;
	int i;

	/* data */
	sprintf(filename,"%s.data",name);
	fd=open(filename,O_RDONLY);
	if (fd<0) {
		fprintf(stderr,"Error opening!\n");
		return -1;
	}

	read(fd,temp,80*25);
	close(fd);

	for(i=0;i<80*25;i++) ram[i*2]=temp[i];

	/* attr */
	sprintf(filename,"%s.attr",name);
	fd=open(filename,O_RDONLY);
	if (fd<0) {
		fprintf(stderr,"Error opening!\n");
		return -1;
	}

	read(fd,temp,80*25);
	close(fd);

	for(i=0;i<80*25;i++) ram[i*2+1]=temp[i];

	return 0;
}

int main(int argc, char **argv) {

	int result,ch;
	int which_room=0;

	result=grsim_init();
	if (result<0) return -1;

	cga_load(rooms[which_room]);

	while(1) {
		grsim_update();
		usleep(10000);
		ch=grsim_input();
		if (ch==27) break;
		if (ch==' ') {
			if (which_room<ROOMS-1) which_room++;
			cga_load(rooms[which_room]);
		}
		if (ch==8) {
			if (which_room>0) which_room--;
			cga_load(rooms[which_room]);
		}
	}

	return 0;

}
