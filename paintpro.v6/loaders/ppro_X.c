
/* gcc -o ppro ppro.c -L/usr/X11/lib/ -lX11 */

#include <X11/Xlib.h>
#include <stdio.h>
#include <X11/Xutil.h>
#include <math.h>

#define LEFT_BUTTON     1               /* left button position */
#define MIDDLE_BUTTON   2               /* middle button position */
#define RIGHT_BUTTON    3               /* right button position */


int xsize,ysize;
 int int1,int2;
 char buffer[300];
 XColor pal2[257]; 
 int lastread = 0;
 int buffpointer = 0;
 int errorlev;
 int virtscreen[1024][1024];
 int picwidth,picheight;
FILE *fff;
 


/* This procedure accepts from the calling program the name of the colour which
   they wish to set the current drawing colour to. */

void
setcolourvianame (myDisplay, myWindow, myGC, myColourmap,myDepth, colourname)
Display                 *myDisplay;
Window                  myWindow;
GC			myGC;			/* GC to set the colour for */
Colormap                myColourmap;            /* colour map */
int                     myDepth;
char			*colourname;		/* name of the colour to set */
{
XColor		rgbcolour;	/* exact rgb components of the colour */
XColor		hwarecolour;	/* closest rgb colour for the hardware */
int		status;		/* determines if function ok */
int		myScreen;

	myScreen = DefaultScreen (myDisplay);

/* if myDepth >1 then on a colour screen */
	if (myDepth > 1)
	{
		status = XLookupColor(myDisplay, myColourmap,
				colourname, &rgbcolour, &hwarecolour);
		if (status != 0)
		{
			/* allocate colour to colour map */
			status = XAllocColor (myDisplay, myColourmap, &hwarecolour);

			if (status != 0)
			{
				/* set drawing colour */
				XSetForeground (myDisplay, myGC, hwarecolour.pixel);
			}
			else
			{
				fprintf(stderr,"Cannot get a colour cell for :%s\n",colourname);
				fprintf(stderr,"Using Black instead\n");
				XSetForeground (myDisplay, myGC, BlackPixel (myDisplay, myScreen));
			}
		}
		else
		{
			fprintf(stderr,"Cannot find colour :%s\n",colourname);
			fprintf(stderr,"Using Black instead\n");
			XSetForeground (myDisplay, myGC, BlackPixel (myDisplay, myScreen));
		}
	}
	else
	{
		fprintf(stderr,"Cannot get a colour on this depth machine:%d\n",myDepth);
		fprintf(stderr,"Using Black instead\n");
		XSetForeground (myDisplay, myGC, BlackPixel (myDisplay, myScreen));
	}
}




void
InitWindow()
{
  char path[50];
  char header[10];
  int i;
  unsigned char temp1,temp2,temp3;
  int r,g,b;
  float pal[256][3];
  int maxcolors;
  int x,y,x1,y1;
  int col,numacross;
  long upcorn[2];
  short val;
   
  
  printf("Enter paintpro file name:\n");
  gets(path);
  
      /* Open the file */
   fff=fopen(path,"rb");
       if (fff==NULL){
	  printf("PPRO error... File \"%s\" not found.\n",path);
	  exit(1);
       }
       errorlev=fread(buffer,1,300,fff);
          /* Check to see if its really a Paintpro File */
       for (i=0;i<9;i++) {
	         header[i]=buffer[i];
       }
       header[9]='\0';
       if (strcmp(header,"PAINTPROV")) {
	         printf("PPRO error... %s is NOT a paintpro file!\n",path);
	         exit(2);
       }
       
       header[0]=buffer[9];
       header[1]=buffer[10];
       header[2]=buffer[11];
       header[3]='\0';
       if (strcmp(header,"6.0")) {
	         printf("PPRO error... Version %s unsupported, must be >6\n",header);
	         exit(3);
       }
       buffpointer=12;
   
   printf("Version %s\n",&header);
       /* Read X and Y sizes */
       temp1=buffer[buffpointer];
       temp2=buffer[buffpointer+1];
       temp3=buffer[buffpointer+2];
       buffpointer+=3;
       if (buffpointer>=errorlev) {
	         printf("PPRO error... Early end of file.\n");
	         exit(3);
       }
       xsize=(temp2>>4)+(temp1<<4);
       ysize=((temp2-((temp2>>4)<<4))*256)+temp3;
          /* being old 6 bytes 2 two int*/
       temp1=buffer[buffpointer];
       temp2=buffer[buffpointer+1];
       temp3=buffer[buffpointer+2];
       buffpointer+=3;
       if (buffpointer>=errorlev) {
	         printf("PPRO error... Early end of file.\n");
	         exit(3);
       }
       maxcolors=(temp2>>4)+(temp1<<4);
   
   
   printf("Xsize: %d\n",xsize);
   printf("Ysize: %d\n",ysize);
   picwidth=xsize+1;
   picheight=ysize+1;
    printf("Max Colors: %d\n",maxcolors);
  
/*Load Palette*/
   for(i=0;i<256;i++) {
     
     pal2[i].red=buffer[buffpointer]*256;
     pal2[i].green=buffer[buffpointer+1]*256;
     pal2[i].blue=buffer[buffpointer+2]*256;
     buffpointer+=3;
      
     if (buffpointer>=errorlev) 
     {
       
       if (errorlev==300) 
       {
         errorlev=fread(buffer,1,300,fff);
         buffpointer=0;
       }
       else {lastread=1;}
     }
      
  }
  x1=0;
  x=0;
  y=0;
  
  while (!lastread) 
  {
     temp1=buffer[buffpointer];
     temp2=buffer[buffpointer+1];
     temp3=buffer[buffpointer+2];
     buffpointer+=3;
     if (buffpointer>=errorlev) {
	if (errorlev==300) {
	   errorlev=fread(buffer,1,300,fff);
	   buffpointer=0;
	 }
	 else lastread=1;
      }
      int1=(temp2>>4)+(temp1<<4);
      int2=((temp2-((temp2>>4)<<4))*256)+temp3;
      if (int1>2047) {
	 virtscreen[x][y]=int1-2048;
         x++;
	 if (x>xsize+x1) {
	    x=x1; y++;
	 }
	 virtscreen[x][y]=int2-2048;
	 x++;
	if (x>xsize+x1){
	   x=x1;y++;
	}
     }
     else {
	col=int1;
	numacross=int2;
	while ((x+numacross)>(xsize+x1)) {
	      for(i=x;i<=x1+xsize;i++) virtscreen[i][y]=col;
	      numacross=numacross-((xsize+1)-x);
	      x=x1;
	      y++;
	  }
	 if (numacross!=0) {
	    for(i=x;i<=x+numacross;i++) virtscreen[i][y]=col;
	    
	  }
	  x+=numacross;
      }
  }
    
  if (fff!=NULL) fclose(fff);
  
}
 




void
DisplayWindowOfObjects(myDisplay, myWindow,myGC,myColourmap,myDepth)
Display                 *myDisplay;
Window                  myWindow;
GC			myGC;			/* GC to set the colour for */
Colormap                myColourmap;            /* colour map */
int                     myDepth;

{
 int q,v,z;
 int status;
 XColor bob;
   for(v=0;v<256;v++){
   status=XAllocColor(myDisplay,myColourmap,&pal2[v]);
    /*  XAllocColorCells(myDisplay,myColourMap,False,0,0,256,256); 
      XStoreColor(myDisplay,myColourmap,&pal2[v]);*/
   }
   for(q=0;q<xsize;q++) {
      for(z=0;z<ysize;z++) {
	 XSetForeground(myDisplay,myGC,pal2[virtscreen[q][z]].pixel);
         XDrawLine(myDisplay,myWindow,myGC,q,z,q,z);
      }
   }
}




  


void
poll (myDisplay, myWindow,myGC,myColourmap,myDepth,myfont)
Display                 *myDisplay;
Window                  myWindow;
GC			myGC;			/* GC to set the colour for */
Colormap                myColourmap;            /* colour map */
int                     myDepth;
XFontStruct		**myfont;
{
unsigned int		width, height;
int			newx, newy;	/* top left corner of closest box */
XEvent			myEvent;	/* event which has occured */
KeySym			mych;		/* */
int			ch;		/* character received */
char			text[10];	/* */
int			finished;	/* determines if user wishes to quit */
char 			*fontname;

	
	/* set up which events you want for a particular window */
	XSelectInput (myDisplay, myWindow,
		PointerMotionMask | ButtonPressMask | KeyPressMask | ExposureMask);

	finished = 0;			/* initialize loop control */
	while (!finished )
	{
		/* read next event in the queue */
		XNextEvent (myDisplay, &myEvent);
		switch (myEvent.type)
		{
			case Expose : /* window manager now sends an Expose Event since override_redirect =False */
				DisplayWindowOfObjects(myDisplay, myWindow,myGC,myColourmap,myDepth);
				break;
			case MotionNotify :
							break;
				
			
			case ButtonPress:
			            
				break;
			case KeyPress:
				{

					ch = XLookupString ((XKeyEvent *)&myEvent, text, 10, &mych, 0);

					/* check if user wishes to quit */
					if (ch == 1 && text[0] == 'q')
						finished = 1;
					else
					{
					char keystring[50];
						sprintf(keystring,"Key pressed is %s.",
							text);
						XDrawImageString (myDisplay, myWindow, myGC,200,30,
								keystring,strlen(keystring));
					}
				}
				break;
		}
	}
}

main (argc, argv)
int argc;
char **argv;
{
Display			*myDisplay;
int			myScreen;
int 			myDepth;
Colormap                myColourmap;            /* colour map */
XSetWindowAttributes	myWindowAttributes;
unsigned long		myWindowMask;
Window			myWindow;
XSizeHints		theSizeHints;
GC			myGC;
unsigned long		myWhitePixel;
unsigned long		myBlackPixel;
XGCValues		myGCValues;
unsigned long		myValueMask;
XFontStruct		*myfont;
int			i;
int                     x 	= 200;		/* x top left corner of window */
int                     y 	= 150;		/* y top left corner of window */
unsigned int            width; /*	= 850;		width of the window */
unsigned int            height; /*	= 700;		height of the window */
int 			border_width = 20;	/* border width of the window */

        InitWindow();
        width=picwidth;
        height=picheight;
	myDisplay = XOpenDisplay ("");
	if (myDisplay == NULL)
	{
		fprintf (stderr, 
			"ERROR: Could not open a connection to X on display %s\n",
		XDisplayName (NULL));
		exit (0);
	}

	myScreen = DefaultScreen (myDisplay);
	myDepth = DefaultDepth (myDisplay, myScreen);
   
    /*myColourmap=XCreateColormap(myDisplay,myWindow,XDefaultVisual(myDisplay,myScreen),AllocNone);
     DefaultColormap (myDisplay, myScreen);*/

	myWhitePixel = WhitePixel (myDisplay, myScreen);
	myBlackPixel = BlackPixel (myDisplay, myScreen);

	/* border colour */
	myWindowAttributes.border_pixel = BlackPixel (myDisplay, myScreen);

	/* background colour */
	myWindowAttributes.background_pixel = WhitePixel (myDisplay, myScreen);

	/* if window manager intervenes or not */
	myWindowAttributes.override_redirect = False;
	
	/* create mask for attributes */
	myWindowMask = CWBackPixel | CWBorderPixel | CWOverrideRedirect;

	myWindow = XCreateWindow (myDisplay, 
				RootWindow (myDisplay, myScreen),
				x, y, width, height, border_width,
				myDepth, InputOutput, CopyFromParent,
				myWindowMask, &myWindowAttributes);

	
  myColourmap=XCreateColormap(myDisplay,myWindow,XDefaultVisual
			      (myDisplay,myScreen),AllocNone);
   
        theSizeHints.flags      = PPosition | PSize;    /* set mask for the hints */
	theSizeHints.x          = x;                    /* x position */
	theSizeHints.y          = y;                    /* y position */
	theSizeHints.width      = width;                /* width of the window */
	theSizeHints.height     = height;               /* height of the window */

	XSetNormalHints (myDisplay, myWindow, &theSizeHints);

	myGC = XCreateGC (myDisplay, myWindow, (unsigned long) 0, &myGCValues);

	/* error... cannot create gc */
	if (myGC == 0)
	{
		XDestroyWindow(myDisplay, myScreen);
		exit (0);
	}

	/* set forground and background defaults */
	else
	{
		XSetForeground (myDisplay, myGC, myBlackPixel);
		XSetBackground (myDisplay, myGC, myWhitePixel);
	}

	XMapWindow (myDisplay, myWindow);

	DisplayWindowOfObjects(myDisplay, myWindow,myGC,myColourmap,myDepth,&myfont);

	XFlush (myDisplay);

	
/*-----------------------------------------------------------------------------
	Now Poll
-----------------------------------------------------------------------------*/

	poll (myDisplay, myWindow,myGC,myColourmap,myDepth,&myfont);
/*-----------------------------------------------------------------------------
	DESTROY ALL WINDOWS
-----------------------------------------------------------------------------*/

	
	XDestroyWindow (myDisplay, myWindow);
	XCloseDisplay (myDisplay);

	exit (0);
}
