#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#ifdef _POSIX_PRIORITY_SCHEDULING
#  include <sched.h>
#else
#  define sched_yield() ;
#endif

#include <ggi/libggi.h>

 int int1,int2;
 char buffer[300];
 int lastread = 0;
 int buffpointer = 0;
 int errorlev;
 int picwidth,picheight;
FILE *fff;
 

void sixbytes2twoint()
{
  char temp1,temp2,temp3;
  int i1,i2,i3;
   
  temp1=buffer[buffpointer]; 
  temp2=buffer[buffpointer+1]; 
  temp3=buffer[buffpointer+2];
  buffpointer++;
  buffpointer++;
  buffpointer++;
  if (buffpointer>=errorlev) 
     {
      if (errorlev==300) 
         {
          errorlev=fread(buffer,1,300,fff);
          buffpointer=0;
         }
      else {lastread=1;}
     }
   
   
   if (temp1<0){i1=256+temp1;}
       else{i1=temp1;}
    if (temp2<0) {i2=256+temp2;}
       else{i2=temp2;}
    if (temp3<0) {i3=256+temp3;}
       else{i3=temp3;}
         int1=(i2/16)+(i1*16);
         int2=((i2-((i2/16)*16))*256)+i3; 
   /*int1=(temp2/16)+(temp1*16);
   int2=((temp2-((temp2/16)*16))*256)+temp3;*/
   
 }  
  
ggi_visual_t vis;

void usage(const char *prog)
{
	fprintf(stderr,"Usage:\n\n"
		       "%s <bpp> <xsize> <ysize> [<virtx> <virty>]\n\n"
		       "Default: %s 8 320 200 320 200\n",prog,prog);
	exit(1);
}

void waitabit(void)
{
	int key;

	while (!ggiKbhit(vis)) {
		sched_yield();
	}

	key=ggiGetc(vis);

	if ((key&0xff)=='q') /* Q pressed */
		ggiExit();
	
}

uint white;

void TestName(const char *name)
{
	ggiSetGCForeground(vis,white);
	ggiPuts(vis,0,0,name);
}

int main(int argc,char **argv)
{
	const char *prog=argv[0];
	ggi_graphtype type;
	ggi_color pal[256];
	int depth;
	int sx,sy,vx,vy;
	int fx=0,fy=0;
	int c,r,x,y,dx,dy,w,h,i,err;
	ggi_color map[256];
	unsigned char pack[256];
	int textmode=0;
        char path[50];
        char header[10];
        int g,b;
        int xsize;
        int ysize;
        int maxcolors;
        int x1,y1;
        int col,numacross;
        long upcorn[2];
        short val;
                           
   
   
	if (argc==1)
		depth=8;
	else {
		if ((argv[1][0] | 0x20)=='t') {
			textmode=1;
			depth=atoi(argv[1]+1);
		} else
			depth=atoi(argv[1]);
		argc--;
		argv++;
	}

	if (argc==1) {
		sx=320;
		sy=200;
		vx=sx;
		vy=sy;
	} else if (argc==3) {
		sx=atoi(argv[1]);
		sy=atoi(argv[2]);
		vx=sx;
		vy=sy;
	} else if (argc==5) {
		sx=atoi(argv[1]);
		sy=atoi(argv[2]);
		vx=atoi(argv[3]);
		vy=atoi(argv[4]);
	} else {
		usage(prog);
		return 1;
	}

	printf("Using mode (%dx%d [%dx%d] %c%dbpp)\n",
		sx,sy,vx,vy,textmode ? 'T' : ' ',depth);

	if (textmode==1) {
		fx=vx;
		fy=vy;
		vx=sx;
		vy=sy;
		if (depth==16) {
			type=GT_TEXT16;
		} else if (depth==32) {
			type=GT_TEXT32;
		} else {
			 fprintf(stderr,"%s: Invalid textmode depth!\n\n",prog);
			 usage(prog);
			 return 1;
		}
	} else {
	   switch (depth) {
		case 1:
			type=GT_1BIT;
			break;
		case 4: type=GT_4BIT;
			break;
		case 8:	type=GT_8BIT;
			break;
		case 15: type=GT_15BIT;
			 break;
		case 16: type=GT_16BIT;
			 break;
		case 24: type=GT_24BIT;
			 break;
		case 32: type=GT_32BIT;
			 break;
		default:
			 fprintf(stderr,"%s: Invalid depth!\n\n",prog);
			 usage(prog);
			 return 1;
	   }
	}

	srandom(time(NULL));

	ggiInit();

	vis=ggiOpen(NULL);

	ggiSetFocus(vis);

	if (textmode) 
		err=ggiSetTextMode(vis,sx,sy,vx,vy,fx,fy,type);
	else
		err=ggiSetGraphMode(vis,sx,sy,vx,vy,type);

	if (err) {
		fprintf(stderr,"Can't set mode\n");
		return 2;
	}

	
	map[0].r=0xFFFF;
	map[0].g=0xFFFF;
	map[0].b=0xFFFF;
	white=ggiMapColor(vis,map[0]);
	printf("white=%d\n",white);

	ggiSetGCForeground(vis,white);
	ggiPuts(vis,0,0,"Press any key to begin tests...");

	/* Hline tests */
	ggiSetGCForeground(vis,0);
	ggiFillscreen(vis);


   /*printf("Enter paintpro file name:\n");
  gets(path);
  */
   sprintf(path,"%s","tbgorg.tb1");
  fff= fopen (path,"r");

  if (fff==NULL){
      printf("Problem... File \"%s\" not found.\n",path);
      exit(1);
  }
     
  errorlev=fread(buffer,1,300,fff);
 
  for (i=0;i<9;i++) {header[i]=buffer[i];}
  header[9]='\0';

  if(strcmp(header,"PAINTPROV"))
  {
    printf("NOT A PAINTPRO FILE!\n");
    exit(2);
   }
   printf("Paintpro Confirmed\n");
   header[0]=buffer[9];
   header[1]=buffer[10];
   header[2]=buffer[11];
   header[3]='\0';       
       
   printf("Version %s\n",&header);
   if(strcmp(header,"6.0"))
   {
     printf("Improper version");
     exit(3);
   }
       
   buffpointer=12;
     
   sixbytes2twoint();
   xsize=int1;
   ysize=int2;
   sixbytes2twoint();
   maxcolors=int1;
   printf("Xsize: %d\n",xsize);
   printf("Ysize: %d\n",ysize);
   picwidth=xsize+1;
   picheight=ysize+1;
   
   printf("Max Colors: %d\n",maxcolors);
  
/*Load Palette*/
   for(i=0;i<256;i++) {
      pal[i].r=buffer[buffpointer];
      pal[i].g=buffer[buffpointer+1];
      pal[i].b=buffer[buffpointer+2]; 
      buffpointer++;
      buffpointer++;
      buffpointer++;
      if (buffpointer>=errorlev) {
	 if (errorlev==300) {
	    errorlev=fread(buffer,1,300,fff);
	    buffpointer=0;
	 }
	 else {lastread=1;
	 }
      }    
   
   }
   ggiSetPaletteVec(vis,0,256,pal);         
        
   x1=0;
  x=0;
  y=0;
  
  while (!lastread) 
  {
    sixbytes2twoint();
     /*printf("%d    %d\n",int1,int2);*/
    if (int1>2047)   {
      ggiPutPixel(vis,x,y,int1-2048);
      x++;
      if (x>=xsize+x1+1){x=x1; y++;}
      ggiPutPixel(vis,x,y,int2-2048);
       x++;
      if (x>=xsize+x1+1){x=x1;y++;}
    }
    else {
      col=int1;
      numacross=int2;
      while ((x+numacross)>=(xsize+x1+1)) {
	 ggiSetGCForeground(vis,col);
	 ggiDrawHLine(vis,x,y,numacross);
         numacross=numacross-((xsize+1)-x);
	 x=x1;
	 y++;
      }
      if (numacross!=0) {
	 ggiSetGCForeground(vis,col);
	 ggiDrawHLine(vis,x,y,numacross);
      }
       
      x=x+numacross;
    }
   }
ggiFlush(vis);
  
  if (fff!=NULL) fclose(fff);


 




   
        waitabit();

	
	ggiClose(vis);

	ggiExit();	

	return 0;
}
