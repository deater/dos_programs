/* code by qkumba */

#include <stdio.h>
#include <unistd.h>

//#define OFFSET_CHAR 32	// ' '
#define OFFSET_CHAR 58	// ':'

int main(int argc, char **argv) {

	int i = 0;
	int e = 0,filesize;
	unsigned char in[1024];
	unsigned char enc[1024];

	filesize=read(0,in,1024);
	printf("\"");
	do {
		enc[e++] = ((in[i + 2] & 3) << 4) +
			((in[i + 1] & 3) << 2) + (in[i + 0] & 3) + OFFSET_CHAR;
		if (i<filesize) printf("%c",(in[i + 0] >> 2) + OFFSET_CHAR);
		if (i + 1 < filesize) printf("%c",(in[i + 1] >> 2) + OFFSET_CHAR);
		if (i + 2 < filesize) printf("%c",(in[i + 2] >> 2) + OFFSET_CHAR);
	} while ((i += 3) < filesize);
	enc[e]=0;
//printf("\n\n");
	printf("%s\"\n",enc);

	return 0;
}
