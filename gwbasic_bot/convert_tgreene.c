/* code by qkumba */

#include <stdio.h>
#include <unistd.h>

//#define OFFSET	32
#define OFFSET2	35

#define OFFSET	35

int main(int argc, char **argv) {

	int i = 0;
	int e = 0,filesize;
	int val,pv,final;
	unsigned char in[1024];
	unsigned char enc[1024],enc2[1024];
	int third,enc_ptr=0;

//	printf("1REM");


	filesize=read(0,in,1024);
	do {
		third = ((in[i + 2] & 3) << 4) +
			((in[i + 1] & 3) << 2) + (in[i + 0] & 3);
		enc[e++]=third+OFFSET2;
		if (i<filesize) {
			val=in[i+0];
			pv=val;
			val=val+0x40;
			val-=third;
//			val&=0xff;
			val=val>>2;
			val=val+OFFSET;
			final=((val-OFFSET)<<2)+third-0x40;
			fprintf(stderr,"%d: %x -> %x %x ==> %x\n",
				i,pv,val,third,final);
			if (pv!=final) fprintf(stderr,"error0: no match!\n");
			if (val<0) fprintf(stderr,"error0, negative! in=%x e=%x val=%x\n",
				in[i+0],third,val);
			if (val<0x23) fprintf(stderr,"error0, unprintable! in=%x pv=%x e=%x val=%x\n",
				in[i+0],pv,third,val);
			if (val>0x7e) fprintf(stderr,"error0, too big! in=%x pv=%x e=%x val=%x\n",
				in[i+0],pv,third,val);
//			printf("%c",val); //(in[i + 0] >> 2) + OFFSET);
			//printf("%c",val); //(in[i + 0] >> 2) + OFFSET);
			enc2[enc_ptr]=val;
			enc_ptr++;
		}
		if (i + 1 < filesize) {
			val=in[i+1];
			pv=val;
			val=val+0x40;
			val-=(third>>2);
//			val&=0xff;
			val=val>>2;
			val=val+OFFSET;
			final=((val-OFFSET)<<2)+(third>>2)-0x40;

			fprintf(stderr,"%d: %x -> %x %x ==> %x\n",
				i+1,pv,val,third>>2,final);
			if (pv!=final) fprintf(stderr,"error1: no match!\n");
			if (val<0) fprintf(stderr,"error1, negative! %x %x\n",
				in[i+0]&0xfc,third);
			if (val<0x23) fprintf(stderr,"error1, unprintable! %x %x\n",
				in[i+0]&0xfc,third);
			if (val>0x7e) fprintf(stderr,"error1, too big! in=%x pv=%x e=%x val=%x\n",
				in[i+0],pv,third,val);
//			printf("%c",val); //(in[i + 1] >> 2) + OFFSET);
			enc2[enc_ptr]=val;
			enc_ptr++;
		}
		if (i + 2 < filesize) {
			val=in[i+2];
			pv=val;
			val=val+0x40;
			val-=(third>>4);
//			val&=0xff;
			val=val>>2;
			val=val+OFFSET;
			final=((val-OFFSET)<<2)+(third>>4)-0x40;
			fprintf(stderr,"%d: %x -> %x %x ==> %x\n",
				i+2,pv,val,third>>4,final);
			if (pv!=final) fprintf(stderr,"error2: no match!\n");
			if (val<0) fprintf(stderr,"error2, negative! %x %x\n",
				in[i+0]&0xfc,third);
			if (val<0x23) fprintf(stderr,"error2, unprintable! %x %x\n",
				in[i+0]&0xfc,third);
			if (val>0x7e) fprintf(stderr,"error2 too big! in=%x pv=%x e=%x val=%x\n",
				in[i+0],pv,third,val);
//			printf("%c",val);//(in[i + 2] >> 2) + OFFSET);
			enc2[enc_ptr]=val;
			enc_ptr++;
		}
	} while ((i += 3) < filesize);
	enc[e]=0;
	enc2[enc_ptr]=0;

// from Tom Greene @txgx42

//	printf("1FORI=0TO%d:POKE768+I,4*PEEK(%d+I)-"
//		"192+(PEEK(%d+I/3)-%d)/4^(I-INT(I/3)*3):NEXT\n",
//		filesize-1,2128,2128+filesize,OFFSET2);
//	printf("2CALL768\"%s%s\n",enc2,enc);

	printf("A$=\"%s%s\"\n",enc2,enc);
	printf("V=SADD(A$)\n");
	printf("FOR I=0 TO %d\n",filesize-1);
	printf("POKE I,4*PEEK(V+I)-204+(PEEK(V+%d+I\\3)-35)\\4^(I MOD 3)\n",
		filesize);
	printf("NEXT\n");
	printf("CALL ABSOLUTE(Q)\n");

	return 0;
}
