#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdlib.h>

/* usage: mkwad -o output_file filename,WADNAME */

static void print_help(char *exe_name,int print_version) {

	printf("MKWAD version 0.1\n");

	if (!print_version) return;

	printf("usage: %s -o output_file filename,WADNAME ...\n",exe_name);
}

/* directory format: 4 byte offset, 4-byte length, 8-byte name */
static int write_directory(int fd, int *out_offset,char *filename, char *name) {

	unsigned char buffer[16];

	int i;
	int offset=*out_offset;
	int size=0;
	int len=strlen(name);
	struct stat our_stat;

	if (stat(filename,&our_stat)<0) {
		fprintf(stderr,"Error statting %s\n",filename);
		return -1;
	}

	size=our_stat.st_size;

	if (len>8) len=8;

	buffer[0]=(offset&0xff);
	buffer[1]=((offset>>8)&0xff);
	buffer[2]=((offset>>16)&0xff);
	buffer[3]=((offset>>24)&0xff);

	buffer[4]=(size&0xff);
	buffer[5]=((size>>8)&0xff);
	buffer[6]=((size>>16)&0xff);
	buffer[7]=((size>>24)&0xff);

	for(i=0;i<8;i++) buffer[8+i]=0;

	for(i=0;i<len;i++) buffer[8+i]=name[i];

	write(fd,buffer,16);

	*out_offset+=our_stat.st_size;

	fprintf(stderr,"Adding %s as %s, size: %ld\n",
			filename,name,our_stat.st_size);

	return 0;
}

static int write_file(int fd, char *filename) {

	int fd_in,result;
	char buffer[1024];

	fd_in=open(filename,O_RDONLY);
	if (fd_in<0) {
		fprintf(stderr,"Error reading file %s\n",filename);
		return -1;
	}

	while((result=read(fd_in,buffer,1024))) {
		write(fd,buffer,result);
	}
	return 0;
}

int main(int argc, char **argv) {

	int i;
	int fd_out;
	char *out_name=NULL;
	int c,lumps=1;
	int directory_offset=12;
	int offset;

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

	/* get number of lumps */
	lumps=argc-optind;

	char **filenames;
	char **names;

	/* allocate memory for filenames list */
	filenames=calloc(lumps,sizeof(char *));
	if (filenames==NULL) {
		fprintf(stderr,"Memory error!\n");
		return -1;
	}

	/* allocate memory for names list */
	names=calloc(lumps,sizeof(char *));
	if (names==NULL) {
		fprintf(stderr,"Memory error!\n");
		return -1;
	}

	int j=0;
	for(i=optind;i<argc;i++) {
		filenames[j]=strdup(strtok(argv[i],","));
		names[j]=strdup(strtok(NULL,""));
//		fprintf(stderr,"%d: %s %s\n",j,filenames[j],names[j]);
		j++;
	}

	/* point past directory */
	offset=12+(lumps*16);

	/* write directory */
	for(i=0;i<lumps;i++) {
		write_directory(fd_out,&offset,filenames[i],names[i]);
	}

	/* write file */
	for(i=0;i<lumps;i++) {
		write_file(fd_out,filenames[i]);
	}

	close(fd_out);



	return 0;

}
