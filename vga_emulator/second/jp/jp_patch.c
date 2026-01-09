#include <stdio.h>

int main(int argc, char **argv) {

	FILE *fff,*ggg;
	int c;

	if (argc<3) {
		fprintf(stderr,"Usage: jp_patch to_patch image\n");
		return 0;
	}

	fff=fopen(argv[1],"r+");
	if (fff==NULL) {
		fprintf(stderr,"error opening %s\n",argv[1]);
		return -1;
	}

	ggg=fopen(argv[2],"r");
	if (ggg==NULL) {
		fprintf(stderr,"error opening %s\n",argv[1]);
		return -1;
	}

	while(1) {
		c=fgetc(fff);

		if (c==EOF) {
			fprintf(stderr,"Not found!\n");
			return -1;
		}

//		int countdown=256;
		if (c==0xfd) {
			c=fgetc(fff);
			if (c==0xfc) {

				fgetc(ggg);
				fgetc(ggg);
				while(1) {
//					countdown--;
//					if (countdown==0) break;
					c=fgetc(ggg);
					if (c==EOF) break;
					fputc(c,fff);
				}
				fclose(fff);
				fclose(ggg);
				break;
			}
		}

	}

	return 0;
}
