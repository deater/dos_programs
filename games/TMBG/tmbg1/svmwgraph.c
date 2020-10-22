
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <vga.h>
#include <vgagl.h>


/*unit SVmwGraph;  {Super Vmw Graphics Unit}*/


unsigned char unfadered[256],unfadeblue[256],unfadegreen[256];
unsigned char fontline[256],charset[256][16];
int charheight;


/*Errors:  0=No Errors
          1=File Not Found
          2=Not a Paintpro File (no PAINTPROVX.XX header)
          3=Improper Version (less then 6)
*/

/*


function Mode13SavePicPacked(x1,y1,x2,y2,numcolors:integer;where:word;filename:string):byte;

{**** Saves an image, with corners x1,y1 and x2,y2
      and number of colors NUMCOLORS, and at segment
      where ($A000 for vga) to the paintpro file
      filename ****}
    {x2 y2 should be plus one (320,200 not 319,199}

var buffer:array[0..2] of byte;
    header:string[15];
    f:file;
    col,x,y,xsize,ysize,i,oldcol,numacross:integer;
    byte1,byte2,byte3,temp:byte;
    r,g,b:byte;
    second1,zz:integer;

procedure integer23bytes(inter1,inter2:integer);
var temp1,temp2,temp3:integer;
    temp:byte;
begin
  {asm
    mov ax,inter1
    shl ax,1
      shl ax,1        this assembly will accomplish
      shl ax,1        what the below will.  Basically
      shl ax,1        it takes two, 16 bit integers,
    mov temp1,ah      strips off the top 4 bits of each,
    sub ah,ah         (makin two, 12 bit integers) and
    shr ax,1          joins these into three 8 bit bytes
      shr ax,1
      shr ax,1         for this assmebly to work, however
      shr ax,1        temp1,temp2, etc must be byte, not
    mov temp,al       integer
    mov ax,inter2
    mov temp3,al
    shr ax,1
      shr ax,1
      shr ax,1
      shr ax,1
    mov ah,temp
    shl ax,1
      shl ax,1        in the below, shl is shift left
      shl ax,1           (in C the equivelant is <<)
      shl ax,1        and shr is shift right ( >> )
    mov temp2,ah
  end;

  }
  temp1:=(inter1  AND $7FFF);
  temp1:=temp1 shr 4;
  temp3:=(inter2 AND $7FFF);
  temp2:= ((inter1 and $000F) shl 4)+ ((inter2 AND $0F00) shr 8);

    buffer[0]:=temp1;
    buffer[1]:=temp2;
    buffer[2]:=temp3;
    blockwrite(f,buffer,1);
end;


begin
  Mode13SavePicPacked:=0;    {*Clear the errors}
  assign(f,filename);        {*Open the file}
  {$I-}
   rewrite(f,3);             {*Turn off i/o and open file}
  {$I+}
   if Ioresult<>0 then Mode13SavePicPacked:=1;
   if Ioresult<>0 then exit;    {*If error, file not found}
   header:='PAINTPROV6.0';
  for i:=0 to 3 do begin        {*Write header}
      buffer[0]:=ord(header[(i*3)+1]);
      buffer[1]:=ord(header[(i*3)+2]);
      buffer[2]:=ord(header[(i*3)+3]);
      blockwrite(f,buffer,1);
  end;

  xsize:=abs(x2-x1);             {*Write xsize and ysize}
  ysize:=abs(y2-y1);
  integer23bytes(xsize,ysize);
  integer23bytes(numcolors,0);   {*Write number of colors and a blank}

  for i:=0 to (numcolors-1) do    {*Save the pallete (24 bit, rgb)}
  begin
      getpal(i,buffer[0],buffer[1],buffer[2]);
      buffer[0]:=buffer[0]* 4;    {*Multiplied by 4 because}
      buffer[1]:=buffer[1] * 4;   {mode 13h is only 18 bit}
      buffer[2]:=buffer[2] * 4;
      blockwrite(f,buffer,1);
  end;
  zz:=(y2-y1);
  y:=y1;
  numacross:=0;                          {this does RLE encoding}
  second1:=0;                            {see doc file}
  oldcol:=getpixel(x1,y,where);
  while y<=y2 do begin
        x:=x1;
        while x<=x2 do begin
              col:=getpixel(x,y,where);
              if (col=oldcol) and (numacross<2046) then inc(numacross)
              else begin                        {*compresses 1 color stretches}
                   if numacross=1 then begin
                      if second1=0 then begin
                         second1:=oldcol+2048;
                      end
                      else begin
                           integer23bytes(second1,oldcol+2048);
                           second1:=0;
                      end

                   end
                   else begin
                        if second1<>0 then
                        integer23bytes(second1-2048,1);
                        integer23bytes(oldcol,numacross);
                        second1:=0;
                   end;
                   numacross:=1;
              end;
              inc(x);
              oldcol:=col;
        end;
        inc(y);
  end;
      integer23bytes(col,numacross);

  close(f);
end;

*/

int LoadPicSuperPacked(int x1,int y1,int loadpal,int loadpic,char *filename)
{
   
   unsigned char temp1,temp2,temp3;
   int errorlev;
   int lastread=0;
   int int1,int2,buffpointer=0;
  unsigned char buffer[300];
  char header[10];
  int i;
  int r,g,b;
  float pal[256][3];
  int xsize;
  int ysize;
  int maxcolors;
  int x,y;
  int col,numacross;
  long upcorn[2];
  short val;
  FILE *fff;
   int picwidth, picheight;
   
     
  fff= fopen (filename,"r");

  if (fff==NULL){
      printf("Problem... File \"%s\" not found.\n",filename);
      return 1;
   }
     
  errorlev=fread(buffer,1,300,fff);
 
  for (i=0;i<9;i++) {header[i]=buffer[i];}
  header[9]='\0';

  if(strcmp(header,"PAINTPROV"))
  {
    printf("NOT A PAINTPRO FILE!\n");
    return 2;
   }
/*   printf("Paintpro Confirmed\n");*/
   header[0]=buffer[9];
   header[1]=buffer[10];
   header[2]=buffer[11];
   header[3]='\0';       
       
  /* printf("Version %s\n",&header);*/
   if(strcmp(header,"6.0"))
   {
     printf("Improper version");
     exit(3);
   }
       
   buffpointer=12;

   /*Begin old 6 bytes 2 two int  [are both these necessary?] */
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
   int2=((temp2-((temp2>>4)<<4))<<16)+temp3;
   /* end 6 bytes 2 two int */ 

  
   xsize=int1;
   ysize=int2;

   /* being old 6 bytes 2 two int*/
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
   /*End Old 6 bytes 2 two int*/
    
   maxcolors=int1;
   /*printf("Xsize: %d\n",xsize);
   printf("Ysize: %d\n",ysize);*/
   picwidth=xsize+1;
   picheight=ysize+1;
   
   /*printf("Max Colors: %d\n",maxcolors);*/
  
/*Load Palette*/
   for(i=0;i<256;i++) {     
      if (loadpal) gl_setpalettecolor(i,buffer[buffpointer]/4,
			 buffer[buffpointer+1]/4,buffer[buffpointer+2]/4);
      buffpointer+=3;
      
      if (buffpointer>=errorlev) {
         if (errorlev==300) {
            errorlev=fread(buffer,1,300,fff);
            buffpointer=0;
         }
         else lastread=1;
      }
      
  }

  x=x1;
  y=y1;
  
  while ((!lastread)&&(loadpic)) 
  {
     /* 6 bytes 2 two int */
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
    /* End Old 6 bytes 2 two int */
      
     if (int1>2047)   {
      gl_setpixel(x,y,int1-2048);
      x++;
      if (x>=xsize+x1+1){x=x1; y++;}
      gl_setpixel(x,y,int2-2048);
       x++;
      if (x>=xsize+x1+1){x=x1;y++;}
    }
    else {
      col=int1;
      numacross=int2;
      while ((x+numacross)>=(xsize+x1+1)) {
	 gl_hline(x,y,x1+xsize,col);
	 numacross=numacross-((xsize+1)-x);
	 x=x1;
	 y++;
      }
      if (numacross!=0) {
	  for(i=x;i<=x+numacross;i++) gl_setpixel(i,y,col);
      }
       
      x=x+numacross;
    }
   }
  if (fff!=NULL) fclose(fff);
  return 0;
}
 
int LoadFont(char *namest)

{
  unsigned char buff[16];
  FILE *f;
  int i,fonty;

  f=fopen(namest,"r");
  if(f==NULL) { printf("Font %s not found\n",namest); return 1; }

  fonty=0;
  while ( (!feof(f)) && (fonty<4097)) {
       fread(buff,1,16,f);
       for(i=0;i<16;i++) charset[fonty/16][i]=buff[i];
       fonty+=16;
  }
  fclose(f);
}


int bit(unsigned char mree,int whichbit)
{
 return mree&(128>>whichbit);  
}

void outtextlineover(char *st,int x,int y,int col,int background,int line)
{
  int i,xx,yy,len;
  len=strlen(st);
  for (i=0;i<len;i++)
      for(xx=0;xx<8;xx++)
         if ( (charset[st[i]][line])&(128>>xx)   ) gl_setpixel(x+(i*8)+xx,y,col);
         else gl_setpixel(x+(i*8)+xx,y,background);
}

void outtextline(char *st,int x,int y,int col,int background,int line)
{
  int i,len,xx;
  len=strlen(st);
   for(i=0;i<len;i++)
      for(xx=0;xx<8;xx++)
         if( (charset[st[i]][line])&(128>>xx) ) gl_setpixel(x+(i*8)+xx,y,col);
}

void outtextxy(char *st,int x,int y,int col,int background,int overwrite)
{
  int lineon;
  for (lineon=0;lineon<8;lineon++)
      if (overwrite) 
         outtextlineover(st,x,y+lineon,col,background,lineon);
      else
         outtextline(st,x,y+lineon,col,background,lineon);
}

/*



procedure OutSmallTextLineOver(st:string;x,y:integer;col,background:byte;line:integer;where:word);
label gus1,gus4,gus5,gus7,gus8,gus3;
var i,len:word;

begin
  len:=length(St);
  for i:=1 to (len div 2)+1 do begin
      fontline[(i-1)*2]:=charset[(ord(st[(i*2)]))+128,line];
      fontline[((i-1)*2)+1]:=charset[(ord(st[(i*2)-1]))+128,line];
  end;
  asm
    push ds
    push si
    push es
    push di
      mov ax,[fontseg]
      mov ds,ax
      mov ax,[fontoff]
      mov si,ax
      mov dh,[col]
      mov dl,[background]
          mov ax,[y]     {multiplies y value by 320}
          shl ax,5
          mov cx,ax
          shl ax,1
          shl cx,3
          add ax,cx
          add ax,[x]        {adds the x-value to get offset}
      mov di,ax
      mov ax,[where]
      mov es,ax
   mov bx,[len]
gus1:
   xor ax,ax
   cmp bx,02
   jnge gus4
   mov cx,10
   lodsb
   push bx
   mov bl,al
   xor bh,bh
   lodsb
   shl ax,5
   add ax,bx
   shl ax,3
   pop bx
   jmp gus5
gus4:
   mov cx,5
   lodsw
gus5:
   shl ax,1
   push ax
   jc gus7
   mov al,dl
   jmp gus8
gus7:
   mov al,dh
gus8:
  xor ah,ah
  stosb
  pop ax
  loop gus5
  cmp bx,2
  jng gus3
  dec bx
  dec bx
   jmp gus1
gus3:
    pop di
    pop es
    pop si
    pop ds
end;
end;

procedure outsmalltextline(st:string;x,y:integer;col,background:byte;line:integer;where:word);
label gus1,gus4,gus6,gus5,gus7,gus8,gus3;
var i,len:word;

begin
  len:=length(St);
  for i:=1 to (len div 2)+1 do begin
      fontline[(i-1)*2]:=charset[(ord(st[(i*2)]))+128,line];
      fontline[((i-1)*2)+1]:=charset[(ord(st[(i*2)-1]))+128,line];
  end;
  asm
    push ds
    push si
    push es
    push di
      mov ax,[fontseg]
      mov ds,ax
      mov ax,[fontoff]
      mov si,ax
      mov dh,[col]
      mov bl,[background]
          mov ax,[y]     {multiplies y value by 320}
          shl ax,5
          mov cx,ax
          shl ax,1
          shl cx,3
          add ax,cx
          add ax,[x]        {adds the x-value to get offset}
      mov di,ax
      mov ax,[where]
      mov es,ax
   mov bx,[len]

gus1:
   xor ax,ax
   cmp bx,02
   jnge gus4
   mov cx,10
   lodsb
   push bx
   mov bl,al
   xor bh,bh
   lodsb
   shl ax,5
   add ax,bx
   shl ax,3
   pop bx
   jmp gus5
gus4:
   mov cx,5
   lodsw
gus5:
   shl ax,1
   push ax
   jc gus7
   inc di
   jmp gus8
gus7:
   mov al,dh
   xor ah,ah
   stosb
gus8:
  pop ax
  loop gus5
  cmp bx,2
  jng gus3
  dec bx
  dec bx
  jmp gus1
gus3:
    pop di
    pop es
    pop si
    pop ds
end;
end;


procedure outsmalltextxy(st:string;x,y,col,background:integer;where:word;overwrite:boolean);
label l0105;
var l,len,i,xadd,yadd,lineon:integer;
    n,k,o,min,max,qwerty:byte;
begin
  for lineon:=0 to 4 do
      if overwrite then
         outsmalltextlineover(st,x,y+lineon,col,background,lineon,where)
      else
         outsmalltextline(st,x,y+lineon,col,background,lineon,where);

end;



function sgn(a:real):integer;
begin
     if a>0 then sgn:=+1;
     if a<0 then sgn:=-1;
     if a=0 then sgn:=0;
end;
*/

void fade()
{
  int i,j;
  int r,g,b;

  for (i=0;i<256;i++){
      gl_getpalettecolor(i,&r,&g,&b);
      unfadered[i]=r;
      unfadeblue[i]=b;
      unfadegreen[i]=g;
  }
  for (i=0;i<64;i++){ 
      for(j=0;j<256;j++){
          gl_getpalettecolor(j,&r,&g,&b);
          if (r>0) r--;
          if (g>0) g--;
          if (b>0) b--;
          gl_setpalettecolor(j,r,g,b);
      }
  }
}

void unfade()
{
   int i,j;
   int r,g,b;
   for(i=0;i<64;i++){ 
      for(j=0;j<256;j++){
          gl_getpalettecolor(j,&r,&g,&b);
          if (r<unfadered[j]) r++;
          if (g<unfadegreen[j]) g++;
          if (b<unfadeblue[j]) b++;
          gl_setpalettecolor(j,r,g,b);
      }
   }
}



/*
procedure box(x1,y1,x2,y2,col:integer;where:word);
begin
   line(x1,y1,x1,y2,col,where);
   horizontalline(x1,x2,y2,col,where);
   line(x2,y2,x2,y1,col,where);
   horizontalline(x1,x2,y1,col,where);
end;

procedure vdelay(howlong:integer);
var i:integer;
begin
  for i:=1 to howlong do waitretrace;
end;

 */
