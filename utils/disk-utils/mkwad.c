#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

/* usage: mkwad -o output_file filename,WADNAME */

static void print_help(char *exe_name,int print_version) {

	printf("MKWAD version 0.1\n");

	if (!print_version) return;

	printf("usage: %s -o output_file filename,WADNAME ...\n",exe_name);
}

int main(int argc, char **argv) {

	int fd_in,fd_out;
	char *out_name=NULL;
	int c,lumps=1;
	int directory_offset=12;

	unsigned char header[12];

	while ( (c=getopt(argc, argv, "hvo:") ) != -1) {

		switch(c) {

			case 'h':
				print_help(argv[0],0);
				break;
			case 'v':
				print_help(argv[0],1);
				break;
			case 'o':
				out_name=strdup(optarg);
				break;
		}
	}

	if (out_name==NULL) {
		fprintf(stderr,"Please specify a file name\n");
		return -1;
	}

	fd_out=open(out_name,O_WRONLY|O_CREAT,0660);
	if (fd_out<0) {
		fprintf(stderr,"Error opening file %s\n",out_name);
		return -1;
	}

	/* setup header */
	header[0]='P';
	header[1]='W';
	header[2]='A';
	header[3]='D';

	/* lumps */
	header[4]=(lumps&0xff);
	header[5]=((lumps>>8)&0xff);
	header[6]=((lumps>>16)&0xff);
	header[7]=((lumps>>24)&0xff);

	/* directory offset */
	header[8]=(directory_offset&0xff);
	header[9]=((directory_offset>>8)&0xff);
	header[10]=((directory_offset>>16)&0xff);
	header[11]=((directory_offset>>24)&0xff);

	/* write header */
	write(fd_out,header,12);

	close(fd_out);

	return 0;

}
