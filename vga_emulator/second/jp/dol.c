#include <stdio.h>
#include <math.h>
#include <stdarg.h>

#define BLACK -1
#define EMPTY -2

#define BEG 140
#define END 244


int main(int argc, char **argv) {

	FILE *f1;

	int a,b,c,x,y,z,le,ri,i;
	int xt[320];

	f1=fopen("zoom.c","w");
	if (f1==NULL) {
		fprintf(stderr,"Error opening zoom.inc!\n");
		return -1;
	}

	fprintf(f1,"#include <stdint.h>\n");
	fprintf(f1,"#include <stdio.h>\n\n");
	fprintf(f1,"#include \"../../vga_emulator/vga_emulator.h\"\n\n");

//	fprintf(f1,"@zoom0:\n");
	a=(160-END/2-1)&(~7);
	b=(160+END/2+8)&(~7);
//	for(x=a;x<b;x+=8) fprintf(f1,"mov es:[di+%i],ax\n",x/4);
//	fprintf(f1,"ret\n");

	fprintf(f1,"void zoom0(int destination, unsigned char *src) {\n\n");
	fprintf(f1,"\tint i;\n\n");
	fprintf(f1,"\tfor(i=%d;i<%d;i+=2) {\n",a/4,b/4);
        fprintf(f1,"\t\tframebuffer_write(destination+i,0);\n");
        fprintf(f1,"\t\tframebuffer_write(destination+i+1,0);\n");
	fprintf(f1,"\t}\n");
	fprintf(f1,"}\n\n");


	for(y=BEG;y<=END;y+=2) {

		printf("\n%i: ",y);
		fprintf(f1,"void zoom%d(int destination, unsigned char *src) {\n",y);

//		fprintf(f1,"@zoom%i:\n",y);

		le=160-(y/2);
		ri=160+(y/2);
		c=ri-le+1;
		for(x=0;x<320;x++) {
			if(x<le || x>ri) xt[x]=BLACK;
			else xt[x]=((long)(x-le)*185L+(c/2))/(long)c;
		}

		le=160-END/2-1; le&=~7;
		ri=160+END/2+8; ri&=~7;
		for(x=0;x<le;x++) xt[x]=EMPTY;
		for(x=ri;x<320;x++) xt[x]=EMPTY;

		for(x=0;x<320;x+=8) {
			for(b=x;b<x+8;b++) if(xt[b]!=BLACK) break;
			if(b==x+8) {
				fprintf(f1,"//mov es:[di+%i],ax\n",x/4);
				for(b=x;b<x+8;b++) xt[b]=EMPTY;
			}
		}
		for(x=0;x<320;x+=4) {
			for(b=x;b<x+4;b++) if(xt[b]!=BLACK) break;
			if(b==x+4) {
				fprintf(f1,"//mov es:[di+%i],al\n",x/4);
				for(b=x;b<x+4;b++) xt[b]=EMPTY;
			}
		}
		for(x=0;x<320;x++) if(xt[x]==BLACK) printf(" %i",x);
		printf("\n");
		for(z=0;z<4;z++) {
			fprintf(f1,"//mov al,%i\n",1<<z);
			fprintf(f1,"//out dx,al\n");
			for(x=z;x<320;x+=8) {
				a=xt[x]; b=xt[x+4];
				if(a==EMPTY && b==EMPTY) continue;
				if(a==BLACK && b==BLACK) {
					fprintf(f1,"//xor ax,ax\n");
				}
				else {
					if(a==BLACK) fprintf(f1,"//xor al,al\n");
					else if(a!=EMPTY) fprintf(f1,"//mov al,ds:[si+%i]\n",a);
					if(b==BLACK) fprintf(f1,"//xor ah,ah\n");
					else if(b!=EMPTY) fprintf(f1,"//mov ah,ds:[si+%i]\n",b);
				}
				if (b==EMPTY) fprintf(f1,"//mov es:[di+%i],al\n",x/4);
				else if (a==EMPTY) fprintf(f1,"//mov es:[di+%i],ah\n",x/4+1);
				else fprintf(f1,"//mov es:[di+%i],ax\n",x/4);
			}
		}


		fprintf(f1,"}\n\n");
	}


	/* print the jump table */

//	fprintf(f1,"zoomt LABEL WORD\n");
//	for(a=0;a<320;a+=2)
//	{
//		y=a;
//		if(!y) fprintf(f1,"dw OFFSET @zoom0\n");
//		else if(y<BEG) fprintf(f1,"dw OFFSET @zoom%i\n",BEG);
//		else if(y>END) fprintf(f1,"dw OFFSET @zoom%i\n",END);
//		else fprintf(f1,"dw OFFSET @zoom%i\n",y);
//	}


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
