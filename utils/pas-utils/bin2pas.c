/* Converts binary file to pascal source file */

#define VERSION "0.0.1"

#include <stdio.h>	/* For FILE I/O */
#include <string.h>	/* For strncmp */
#include <fcntl.h>	/* for open()  */
#include <unistd.h>	/* for lseek() */
#include <sys/stat.h>	/* for file modes */
#include <stdlib.h>	/* free() */

static int debug=0;

static void print_help(char *name,int version) {

	printf("\nbin2pas version %s\n",VERSION);

	if (version) exit(1);

	printf("\nUsage: %s [-v] [-h] [-l label] BINFILE\n\n",name);
	printf("\n");

	exit(1);
}




int main(int argc, char **argv) {

	char *filename;
	int i,c,filesize,result;
	struct stat statbuf;
	FILE *fff;

	char labelname[BUFSIZ]="IMAGEDATA";

	/* Parse command line arguments */

	while ( (c=getopt(argc, argv, "hvdl:") ) != -1) {

		switch(c) {

                        case 'h':
                                print_help(argv[0],0);
				break;
                        case 'v':
                                print_help(argv[0],1);
				break;
                        case 'd':
				debug=1;
				break;
			case 'l':
				strncpy(labelname,optarg,BUFSIZ-1);
				break;

			default:
				print_help(argv[0],0);
				break;
		}
	}

	if (optind>=argc) {
		printf("ERROR: Was expecting filename!\n");
		exit(1);
	}

	filename=strdup(argv[optind]);

	result=stat(filename,&statbuf);
	if (result<0) {
		fprintf(stderr,"Error stating %s\n",filename);
		return -1;
	}

	filesize=statbuf.st_size;

	fff=fopen(filename,"r");
	if (fff==NULL) {
		fprintf(stderr,"Error opening %s\n",filename);
		return -1;
	}

	printf("{ bin2pas output}\n");
	printf("const\n");
	printf("\t%s : array [0..%d] of Char = (\n",labelname,filesize-1);
	for(i=0;i<filesize;i++) {
		if (i%12==0) printf("\t");
		printf("#$%02X",fgetc(fff));
		if (i!=filesize-1) printf(",");
		if (i%12==11) printf("\n");
	}
	printf(");\n");

	fclose(fff);

	return 0;
}
