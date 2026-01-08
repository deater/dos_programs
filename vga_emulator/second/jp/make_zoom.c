#include <stdio.h>
#include <math.h>
#include <stdarg.h>

#define BLACK -1
#define EMPTY -2

#define BEG 140
#define END 244


int main(int argc, char **argv) {

	FILE *f1;

	int a,b,c,x,y,z,left,right,i;
	int xt[320];

	f1=fopen("zoom.c","w");
	if (f1==NULL) {
		fprintf(stderr,"Error opening zoom.inc!\n");
		return -1;
	}

	fprintf(f1,"#include <stdint.h>\n");
	fprintf(f1,"#include <stdio.h>\n\n");
	fprintf(f1,"#include \"../../vga_emulator/vga_emulator.h\"\n\n");

	a=(160-(END/2)-1)&(~7);
	b=(160+(END/2)+8)&(~7);

	fprintf(f1,"void zoom0(int destination, unsigned char *src) {\n\n");
	fprintf(f1,"\tint i;\n\n");
	fprintf(f1,"\tfor(i=%d;i<%d;i+=2) {\n",a/4,b/4);
        fprintf(f1,"\t\tframebuffer_write(destination+i,0);\n");
        fprintf(f1,"\t\tframebuffer_write(destination+i+1,0);\n");
	fprintf(f1,"\t}\n");
	fprintf(f1,"}\n\n");

	fprintf(f1,"static void clear_abcd(int destination, int a,int b,int c, int d) {\n\n");
	fprintf(f1,"\tint i;\n\n");
	fprintf(f1,"\tfor(i=a;i<=b;i++) {\n");
	fprintf(f1,"\t\tframebuffer_write(destination+i,0);\n");
	fprintf(f1,"\t}\n\n");
	fprintf(f1,"\tfor(i=c;i<=d;i++) {\n");
	fprintf(f1,"\t\tframebuffer_write(destination+i,0);\n");
	fprintf(f1,"\t}\n");
	fprintf(f1,"}\n\n");

	for(y=BEG;y<=END;y+=2) {

		printf("\n%i: ",y);
		fprintf(f1,"void zoom%d(int destination, unsigned char *src) {\n",y);
		fprintf(f1,"\tint al,ah;\n");
//		fprintf(f1,"@zoom%i:\n",y);

		/* width is y centered on screen */
		left=160-(y/2);
		right=160+(y/2);

		/* this is y+1 ??? */
		/* 160+(y/2) - (160-(y/2)) + 1 */
		/* 160+(y/2) - 160 + (y/2) + 1*/
		c=right-left+1;

		/* ???? */
		/* black off edges, center is */
		for(x=0;x<320;x++) {
			if (x<left || x>right) {
				xt[x]=BLACK;
			}
			else {
				xt[x]=((x-left)*185+(c/2))/c;
			}
		}

		left=160-END/2-1;
		left&=~7;

		right=160+END/2+8;
		right&=~7;

		/* reset from BLACK to EMPTY?  Why */
		for(x=0;x<left;x++) {
			xt[x]=EMPTY;
		}
		for(x=right;x<320;x++) {
			xt[x]=EMPTY;
		}

		/* write black edges to all planes */
		for(x=0;x<320;x+=8) {

			/* see if 8 cosecutive bits BLACK */
			for(b=x;b<x+8;b++) {
				if (xt[b]!=BLACK) break;
			}
			/* if they were, write 8 bytes of BLACK */
			if(b==x+8) {
				fprintf(f1,"//mov es:[di+%i],ax\n",x/4);
				fprintf(f1,"framebuffer_write(destination+%d,0);\n",x/4);
				fprintf(f1,"framebuffer_write(destination+%d+1,0);\n",x/4);
				/* mark as empty once done */
				/* this way we won't write again */
				/* when looking for runs of 4 */
				for(b=x;b<x+8;b++) xt[b]=EMPTY;
			}
		}

		/* Go back and handle runs of 4 */
		for(x=0;x<320;x+=4) {
			/* check for 4 consecutive blacks */
			for(b=x;b<x+4;b++) {
				if(xt[b]!=BLACK) break;
			}
			/* if it was, write 4 bytes */
			if(b==x+4) {
				fprintf(f1,"//mov es:[di+%i],al\n",x/4);
				fprintf(f1,"framebuffer_write(destination+%d,0);\n",x/4);
				/* mark as done */
				for(b=x;b<x+4;b++) xt[b]=EMPTY;
			}
		}

		/* print to screen any leftovers that happened? */
		for(x=0;x<320;x++) {
			if(xt[x]==BLACK) printf(" %i",x);
		}
		printf("\n");


		/* switch planes*/
		for(z=0;z<4;z++) {
			//fprintf(f1,"//mov al,%i\n",1<<z);
			//fprintf(f1,"//out dx,al\n");
			fprintf(f1,"\t/* switch to plane %d */\n",z);
			fprintf(f1,"\toutp(0x3c5,%d);\n",1<<z);

			/* trying to be extra clever and extra-optimize */
			/* urgh hard to undo */
			for(x=z;x<320;x+=8) {
				a=xt[x]; b=xt[x+4];

		if(a==EMPTY && b==EMPTY) continue;
		if(a==BLACK && b==BLACK) {
			fprintf(f1,"//xor ax,ax\n");
			fprintf(f1,"\tal=0; ah=0;\n");
		}
		else {
			if (a==BLACK) {
				fprintf(f1,"//xor al,al\n");
				fprintf(f1,"\tal=0;\n");
			}
			else if (a!=EMPTY) {
				fprintf(f1,"//mov al,ds:[si+%i]\n",a);
				fprintf(f1,"\tal=src[%d];\n",a);
			}

			if (b==BLACK) {
				fprintf(f1,"//xor ah,ah\n");
				fprintf(f1,"\tah=0;\n");
			}
			else if (b!=EMPTY) {
				fprintf(f1,"//mov ah,ds:[si+%i]\n",b);
				fprintf(f1,"\tah=src[%d];\n",b);
			}
		}

		if (b==EMPTY) {
			fprintf(f1,"//mov es:[di+%i],al\n",x/4);
			fprintf(f1,"framebuffer_write(destination+%d,al);\n",x/4);
		}
		else if (a==EMPTY) {
			fprintf(f1,"//mov es:[di+%i],ah\n",x/4+1);
			fprintf(f1,"framebuffer_write(destination+%d,ah);\n",x/4+1);
		}
		else {
			fprintf(f1,"//mov es:[di+%i],ax\n",x/4);
			fprintf(f1,"framebuffer_write(destination+%d,al);\n",x/4);
			fprintf(f1,"framebuffer_write(destination+%d,ah);\n",x/4+1);
		}

			}
		}


		fprintf(f1,"}\n\n");
	}

	fprintf(f1,"void zoomt(int bx, int ax, int destination, unsigned char *src) {\n\n");
	fprintf(f1,"\tif (ax!=0) {\n");
	fprintf(f1,"\t\tfprintf(stderr,\"Error zoomt: ax=%%d\\n\",ax);\n");
	fprintf(f1,"\t}\n\n");

	fprintf(f1,"\t/* was a lookup table of 2-byte 16-bit entries */\n");
	fprintf(f1,"\tbx>>=1;\n\n");

#if 0
	fprintf(f1,"\tif (bx!=0) {\n");
	fprintf(f1,"\t\tprintf(\"bx=%%d\\n\",bx);\n");
	fprintf(f1,"\t}\n\n");
#endif
	fprintf(f1,"\tswitch(bx) {\n");
	fprintf(f1,"\t\tcase 0:\n");
	fprintf(f1,"\t\t\tzoom0(destination,src); break;\n");

	for(i=1;i<71;i++) {
		if (i%5==1) {
			fprintf(f1,"\t\t");
		}
		fprintf(f1,"case %d: ",i);
		if (i%5==0) {
			fprintf(f1,"\n");
		}
	}
	fprintf(f1,"\t\t\tzoom140(destination,src); break;\n");

	for(i=0;i<51;i++) {
		fprintf(f1,"\t\tcase %d:\tzoom%d(destination,src); break;\n",
			i+71,i*2+142);
	}

	fprintf(f1,"\t\tcase 122: /* .. 160 */\n");

	fprintf(f1,"\t\tdefault:\n");
	fprintf(f1,"\t\t\tzoom244(destination,src); break;\n");
	fprintf(f1,"\t}\n");

	fprintf(f1,"}\n");

}
