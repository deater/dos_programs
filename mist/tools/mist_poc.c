/* mist poc */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <SDL.h>

#include "cga_sim.h"


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

	result=grsim_init();
	if (result<0) return -1;

	cga_load("pool");


	while(1) {
		grsim_update();
		usleep(10000);
		ch=grsim_input();
		if (ch==27) break;
	}

	return 0;

}
