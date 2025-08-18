#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>


int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int ch;
	unsigned char out_buffer[80*25];
	unsigned char in_buffer[80*25*2];
	int color;

	FILE *outattr,*outdata,*infile;

	char attr_filename[256];
	char data_filename[256];

	if (argc<3) {
		fprintf(stderr,"Usage:\t%s INFILE OUTBASE\n\n",argv[0]);
		exit(-1);
	}

	infile=fopen(argv[1],"r");
	if (infile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",argv[1]);
		exit(-1);
	}

	sprintf(attr_filename,"%s.attr",argv[2]);
	sprintf(data_filename,"%s.data",argv[2]);

	outdata=fopen(data_filename,"w");
	if (outdata==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",data_filename);
		exit(-1);
	}

	outattr=fopen(attr_filename,"w");
	if (outattr==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",attr_filename);
		exit(-1);
	}

	fread(in_buffer,1,80*25*2,infile);


	memset(out_buffer,0,80*25);

	for(row=0;row<25;row++) {
		for(col=0;col<80;col++) {
			color=in_buffer[(row*160)+col*2+1];
			ch=in_buffer[(row*160)+col*2];
			fputc(color,outattr);
			fputc(ch,outdata);

		}
	}

	fclose(outdata);
	fclose(outattr);

	return 0;
}
