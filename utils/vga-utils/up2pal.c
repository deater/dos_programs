#include <stdio.h>

int main(int argc, char **argv) {

	FILE *fff;

	int i;
	unsigned char pal_r[256],pal_g[256],pal_b[256];
	unsigned char buffer[256];

	if (argc<2) {
		fprintf(stderr,"Error, need filename input\n");
	}

	fff=fopen(argv[1],"r");
	if (fff==NULL) {
		fprintf(stderr,"Error, couldn't open %s\n",argv[1]);
		return -1;
	}

	/* skip header */
	fread(buffer,16,1,fff);

	for(i=0;i<256;i++) {
		fread(buffer,3,1,fff);
		pal_r[i]=buffer[0];
		pal_g[i]=buffer[1];
		pal_b[i]=buffer[2];
	}

	fclose(fff);

	printf("GIMP Palette\n");
	printf("Name: %s\n",argv[1]);
	printf("Columns: 16\n");
	printf("#\n");
	for(i=0;i<256;i++) {
		printf("%d %d %d\t(%d:%x,%x,%x)\n",
			pal_r[i]<<2,pal_g[i]<<2,pal_b[i]<<2,
			i,pal_r[i],pal_g[i],pal_b[i]);
	}

	return 0;
}
