#include <stdio.h>

int main(int argc, char **argv) {

	char buffer[1024];
	char *ptr;
	int color,x1,x2,y1,y2,start;
	char output[1024];
	int out_ptr=0;

	while(1) {

		ptr=fgets(buffer,1024,stdin);
		if (ptr==NULL) break;

		sscanf(buffer,"%d %d %d %d %d",
			&color,&x1,&x2,&y1,&y2);

		start=320*52+y1*320+112+20+x1;

		printf("db 0%02Xh, 0%02Xh, %d, %d, %d\n",
			(start&0xff),(start>>8)&0xff,
			(y2-y1)+1,(x2-x1)+1,color);
	}

	return 0;
}
