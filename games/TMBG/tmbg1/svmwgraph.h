/*unit SVmwGraph;  {Super Vmw Graphics Unit}*/

/*Errors:  0=No Errors
          1=File Not Found
          2=Not a Paintpro File (no PAINTPROVX.XX header)
          3=Improper Version (less then 6)
*/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <vga.h>
#include <vgagl.h>


/*unit SVmwGraph;  {Super Vmw Graphics Unit}*/


unsigned char unfadered[256],unfadeblue[256],unfadegreen[256];
unsigned char fontline[256],charset[256][16];


/*
function Mode13SavePicPacked(x1,y1,x2,y2,numcolors:integer;where:word;filename:string):byte;
*/

int LoadPicSuperPacked(int x1,int y1,int loadpal,int loadpic,char *filename);
int LoadFont(char *namest);
int bit(unsigned char mree,int whichbit);
void outtextlineover(char *st,int x,int y,int col,int background,int line);
void outtextline(char *st,int x,int y,int col,int background,int line);
void outtextxy(char *st,int x,int y,int col,int background,int overwrite);
void fade();
void unfade();
