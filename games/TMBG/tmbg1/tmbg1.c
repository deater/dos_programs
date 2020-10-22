/* program They_Might_Be_Giants_Game;
 {By Vince Weaver  Started 4 Feb 1997}
 {Ported to C 17 april 1997 }
*/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <vga.h>
#include <jlib.h>
#include "svmwgrph.h"  /* SVMWGRAPH -- DA*N BILL GATES AND HIS 8.3 */


buffer_rec *offscreen,*faroffscreen;
UBYTE *paltemp[768];  


void coolbox(int x1,int y1,int x2,int y2,int fill,buffer_rec *page)
{             
   int i;
   
   for (i=0;i<5;i++) box(x1+i,y1+i,x2-i,y2-i,31-i,page);
   if(fill) for (i=y1+5;i<=y2-5;i++) buff_draw_h_line(page,x1+5,i,x2-5,7);
}

void quit(buffer_rec *buff)
{
   int barpos,ch=0;
   USHORT key_hit=0;
   
   coolbox(90,75,230,125,1,buff);
   barpos=0;
   outtextxy("QUIT??? ARE YOU",97,82,9,7,1,buff);
   outtextxy("ABSOLUTELY SURE?",97,90,9,7,1,buff);
   outtextxy("YES-RIGHT NOW!",97,98,150,0,1,buff);
   outtextxy("NO--NOT YET.",97,106,150,7,1,buff);
   screen_blit_fs_buffer(buff);
  
   while (key_hit!=13) {
    key_hit=kb_get_next_code();
    if ((key_hit==KB_UP)||(key_hit==KB_DOWN)){ 
       if (barpos==0) key_hit='N';
       else key_hit='Y';
    }
    
    switch(key_hit){
      case 'Y': case 'y': 
           barpos=0; 
           outtextxy("YES-RIGHT NOW!",97,98,150,0,1,buff);
           outtextxy("NO--NOT YET.",97,106,150,7,1,buff);
           screen_blit_fs_buffer(buff);
           break; 
      case 'N': case 'n': 
           barpos=1; 
           outtextxy("YES-RIGHT NOW!",97,98,150,7,1,buff);
           outtextxy("NO--NOT YET.",97,106,150,0,1,buff);
           screen_blit_fs_buffer(buff);
           break;
     }
     if (barpos==2) barpos=0;
   }
   
   if (barpos==0) {
      screen_restore_video_mode();
      kb_closedown();
      exit(0);
   }
  barpos=6;
}


void VMW_PRODUCTION(buffer_rec *buff,UBYTE pal[256][3])
{
  /*UBYTE pal[256][3];*/
  int x,ch;
   
  for (x=0;x<41;x++){
       pal[100+x][0]=(x+20)*4;
       pal[100+x][1]=0;
       pal[100+x][2]=0;
       
       pal[141+x][0]=0;
       pal[141+x][2]=(x+20)*4;
       pal[141+x][1]=0;
       
       pal[182+x][0]=0;
       pal[182+x][2]=0;
       pal[182+x][1]=(x+20)*4;
       
  }
  pal[15][0]=255; pal[15][1]=255; pal[15][2]=255;
  pal[0][0]=0; pal[0][1]=0; pal[0][2]=0;
   
  screen_fade_out_pal(pal,1);
   
  for(x=0;x<41;x++){
       buff_draw_lineNC(buff,x+40,45,x+40,45+(2*x),100+x);
       buff_draw_lineNC(buff,x+120,45,x+120,45+(2*x),141+x);
       buff_draw_lineNC(buff,x+200,45,x+200,45+(2*x),141+x);
       buff_draw_lineNC(buff,x+80,125-(2*x),x+80,125,182+x);
       buff_draw_lineNC(buff,x+160,125-(2*x),x+160,125,182+x);
  }
  for(x=40;x>0;x--){
       buff_draw_lineNC(buff,x+80,45,x+80,125-(2*x),140-x);
       buff_draw_lineNC(buff,x+160,45,x+160,125-(2*x),181-x);
       buff_draw_lineNC(buff,x+240,45,x+240,125-(2*x),181-x);
       buff_draw_lineNC(buff,x+120,125,x+120,45+(2*x),222-x);
       buff_draw_lineNC(buff,x+200,125,x+200,45+(2*x),222-x);
  }
 
  outtextxy("A VMW SOFTWARE PRODUCTION",60,140,15,15,0,buff); 
  screen_blit_fs_buffer(buff);
  screen_fade_in_pal(pal,2);       
  ch=kb_get_next_key();
  screen_fade_out_pal(pal,2);
}



int main(int argc, char **argv)
{
   int CDROMmode,i,j,ch,y,hiscore,grapherror;
   char string_param[50];
   UBYTE *pal[768];
   int barpos;
   USHORT key_press;
   
   CDROMmode=0;
   /*
   for (i=1;i<argc;i++) {
       strcpy(argv[i],string_param);
       for (j=0;j<strlen(string_param);j++) string_param[j]=toupper(string_param[j]);
       if (strstr("CDROM",string_param)!=NULL) CDROMmode=1;
       if ( (strstr("HELP",string_param)!=NULL) ||
            (strstr("H",string_param)!=NULL) ){
          printf("TMBG\n\n");
          printf("Command line:  tb1 [-cdrom] [-help]\n\n");
          printf("-cdrom starts game in read-only mode\n");
          printf("-help gives this message\n\n");
          return 7;
       }
   }
  */
   
   screen_set_app_title("TheyMightBeGame");
   
   if(!screen_set_video_mode()) jlib_exit("Screen Setup failed.");
   
   if(!KEYBOARD_AVAILABLE) jlib_exit("No Keyboard Support.");
   
   kb_init();
   
   srand(time(NULL));
   LoadFont("tmbg1.fnt");
   
     offscreen=buff_init(SCREEN_WIDTH,SCREEN_HEIGHT);
     faroffscreen=buff_init(SCREEN_WIDTH,SCREEN_HEIGHT);
   
     buff_clear(offscreen);
     buff_clear(faroffscreen);
     screen_blit_fs_buffer(offscreen);    
     
     VMW_PRODUCTION(offscreen,pal);
     buff_clear(offscreen);
     screen_blit_fs_buffer(offscreen);
   
   y=0; hiscore=0;

   grapherror=LoadPicSuperPacked(0,0,1,0,"tmbg1.tmb",offscreen,pal);
PICLOADER:   
   screen_blank_pal();
   grapherror=LoadPicSuperPacked(0,0,0,1,"tmbg1.tmb",faroffscreen,pal);
   barpos=0;
   
MENU:
   ch=0;
   flip320(faroffscreen,offscreen);
   screen_blit_fs_buffer(offscreen);
   screen_fade_in_pal(pal,2);
      
 /*
   {gettime(ho,mi,se,s100);
   tempsec:=se-30;
   if tempsec<0 then tempsec:=tempsec+60;}
   repeat
    { gettime(ho,mi,se,s100);
     if se=tempsec then begin

        credits;
        flipd320(vaddr2,vga);
        gettime(ho,mi,se,s100);
        tempsec:=se-30;
        if tempsec<0 then tempsec:=tempsec+60;

     end;}
   until keyprefn;
   ch:=readkefn;
  */
   kb_clear();
   key_press=0;
   outtextxy("F1 HELP",13,190,9,7,0,offscreen);
   coolbox(2,86,85,165,1,offscreen);
   screen_blit_fs_buffer(offscreen);
   while(key_press!=13)  {
      if(barpos==0) outtextxy("NEW GAME",8,92,32,0,1,offscreen);
         else outtextxy("NEW GAME",8,92,32,7,1,offscreen);
      if(barpos==1) outtextxy("OPTIONS",8,102,32,0,1,offscreen);
         else outtextxy("OPTIONS",8,102,32,7,1,offscreen);
      if (barpos==2) outtextxy("REGISTER",8,112,32,0,1,offscreen);
         else outtextxy("REGISTER",8,112,32,7,1,offscreen);
      if (barpos==3) outtextxy("LOAD GAME",8,122,32,0,1,offscreen);
         else outtextxy("LOAD GAME",8,122,32,7,1,offscreen);
      if (barpos==4) outtextxy("STORY",8,132,32,0,1,offscreen);
         else outtextxy("STORY",8,132,32,7,1,offscreen);
      if (barpos==5) outtextxy("CREDITS",8,142,32,0,1,offscreen);
         else outtextxy("CREDITS",8,142,32,7,1,offscreen);
      if (barpos==6) outtextxy("QUIT",8,152,32,0,1,offscreen);
         else outtextxy("QUIT",8,152,32,7,1,offscreen);
     screen_blit_fs_buffer(offscreen);
     key_press=kb_get_next_code();
      switch(key_press){
       case KB_DOWN: case KB_RIGHT: barpos++; break;
       case KB_UP: case KB_LEFT: barpos--; break;
       case 'N': case 'n': barpos=0; break;
       case 'O': case 'o': barpos=1; break;
       case 'R': case 'r': barpos=2; break;
       case 'L': case 'l': barpos=3; break;
       case 'S': case 's': barpos=4; break;
       case 'C': case 'c': barpos=5; break;
       case 'Q': case 'q': barpos=6; break;
       case 27: barpos=6; key_press=13; break;
      }
	
       if (barpos==7) barpos=0;
       if (barpos==-1) barpos=6;
   }
   if (barpos==6) quit(offscreen);
/*   if barpos=1 then options;
   if barpos=2 then register;
   if barpos=3 then loadgame;
   if barpos=4 then
      begin
        story;
        fade;
        cls(0,vga);
      end;
   if barpos=5 then credits;
   if barpos=10 then help;  */
   
   if (barpos==0) play_the_game(0);
   if (barpos==0) goto PICLOADER;
   if (barpos==4) goto PICLOADER;
   if (barpos==3) goto PICLOADER;
   goto MENU;
  
}

