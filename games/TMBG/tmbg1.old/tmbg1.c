/* program They_Might_Be_Giants_Game;
 {By Vince Weaver  Started 4 Feb 1997}
 {Ported to C 17 april 1997 }
*/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <vga.h>
#include <vgagl.h>
#include <jlib.h>
#include "svmwgraph.h"


buffer_rec *buff,*vaddr,*vaddr2;
UBYTE *paltemp[768];  

/*
var CDROMmode:boolean;
    string_param:string;
    i,j,x,y:integer;
    hiscore:integer;
    ch:char;
    grapherror:byte;
    barpos:integer;
    level_map_file:text;

type Virtual = Array [1..64000] of byte;  { The size of our Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }

     ShapeTable = Array [0..40000] of byte;
     ShapePtr = ^ShapeTable;
     JohnType=record
          x,y,xspeed,yspeed:integer;
          step,map_x,map_y:integer;
     end;

var world_map : Array[0..4,0..4,0..20,0..20] of byte;
    local_map : Array[0..20,0..20] of byte;
    John:Johntype;
    Virscr,VirScr2 : VirtPtr;   { Our first Virtual screen }
    ShapeTable1:ShapePtr;
    num:byte;
    Vaddr,Vaddr2,Vaddr3 : Word;                      { The segment of our 2nd virt. screen}
    ShapeAddr:word;                     { The segment of the shape table}
    ShapeOfs:word;



function menuread:char;
var chtemp,ch2:char;
begin
  repeat until keyprefn;
  ch2:=#0;
  chtemp:=readkefn;
  if chtemp=chr(0) then ch2:=readkefn;
  chtemp:=upcase(chtemp);
  if (ord(chtemp)<10) and (ord(chtemp)<128) then begin
     if ch2='H' then chtemp:='ß';  {up}
     if ch2='M' then chtemp:='Þ';  {right}
     if ch2='P' then chtemp:='Ü';  {down}
     if ch2='K' then chtemp:='Ý';  {left}
     if ch2=';' then chtemp:='¨';  {f1}
     if ch2='I' then chtemp:='ô';  {pgup}
     if ch2='Q' then chtemp:='õ';  {pgdown}
  end;
  menuread:=chtemp;
end;
*/

void coolbox(int x1,int y1,int x2,int y2,int fill,buffer_rec *page)
{
   int i;
   
   for (i=0;i<5;i++) box(x1+i,y1+i,x2-i,y2-i,31-i,page);
   if(fill) for (i=y1+5;i<=y2-5;i++) buff_draw_h_line(page,x1+5,i,x2-5,7);
}

/*
Procedure blockmove(x1,y1,x2,y2,p1,x3,y3,p2:word);
  { This is a small procedure to copy block x1,y1,x2,y2,
    from page 1 to x3,y3 on page 2}
BEGIN
  asm
    push    ds
    push    es
    mov     ax,p1
    mov     ds,ax
    mov     ax,p2
    mov     es,ax

    mov     bx,[X1]
    mov     dx,[Y1]
    push    bx                      {; and this again for later}
    mov     bx, dx                  {; bx = dx}
    mov     dh, dl                  {; dx = dx * 256}
    xor     dl, dl
    shl     bx, 6                   {; bx = bx * 64}
    add     dx, bx                  {; dx = dx + bx (ie y*320)}
    pop     bx                      {; get back our x}
    add     bx, dx                  {; finalise location}
    mov     si, bx                  {; es:di = where to go}

    mov     bx,[X3]
    mov     dx,[Y3]
    push    bx                      {; and this again for later}
    mov     bx, dx                  {; bx = dx}
    mov     dh, dl                  {; dx = dx * 256}
    xor     dl, dl
    shl     bx, 6                   {; bx = bx * 64}
    add     dx, bx                  {; dx = dx + bx (ie y*320)}
    pop     bx                      {; get back our x}
    add     bx, dx                  {; finalise location}
    mov     di, bx                  {; es:di = where to go}

    mov ax,[y2]
    sub  ax,[y1]

    mov     dx,[x2]
    sub     dx,[x1]
    mov     bx,320
    sub     bx,dx

    
@@1 :
    mov     cx, dx         { Width of block to copy divided by 2 }
    shr     cx,1
    jnc     @@2
    rep     movsw
    movsb
    jmp @@3
@@2:
    rep     movsw
@@3:
    add     di,bx
    add     si,bx
    dec     ax
    jnz     @@1

    pop     es
    pop     ds
  end;
END;


procedure pauseawhile(howlong:word);
var i:word;
begin
  i:=0;
  repeat
    waitretrace;
    inc(i);
    if i>howlong then exit;
  until keyprefn;
end;

procedure putshape(shapeoffset,towhere,xacross,yacross,xx,yy:word);
label bob,bob4,bob2,bob3;
begin
  asm
              {saves registers}
     push ds
     mov ax,[yy]     {multiplies y value by 320}
      shl ax,5
      mov cx,ax
      shl ax,1
      shl cx,3
      add ax,cx
      add ax,[xx]        {adds the x-value to get offset}
      mov di,ax
      mov bx,320
      sub bx,[xacross]   {xacross?}
      push bx
    mov bx,[yacross]
    xor dx,dx
      mov ax,[shapeaddr]     {moves segment of array}
      mov ds,ax
      mov ax,[shapeoffset]     {moves offsett if array}
      {add ax,[shapeofs]}
      mov si,ax
      mov ax,[towhere]        {loads place to move it}
      mov es,ax
      xor ax,ax
      xor cx,cx
      xor dx,dx
    bob:
      mov cx,[xacross]        {how long to loop across (the x-size of array)}
    bob4:
      xor ah,ah
      lodsb
      cmp ax,0               {If zero skip, if not, store value}
      jz bob2
      stosb
      dec di
    bob2:                    {Adds when x-value must be increased}
      inc di
      loop bob4
      cmp dx,bx
      jz bob3
      xor cx,cx
      pop ax
      add di,ax
      push ax
      inc dx
      jmp bob
  bob3:
    pop bx                  {restore variables}
    pop ds
  end;
end;


function collision(x1,y1,xsize1,ysize1,x2,y2,xsize2,ysize2:integer):boolean;
var bob:byte;
    hit:boolean;
label aat1,aat2,aat3,aat4;
begin
  bob:=0;
    asm
      mov ax,[x1]
      mov bx,[x2]
      mov cx,[xsize1]
      mov dx,[xsize2]
      cmp bx,ax
    jnge aat1
      xchg ax,bx
      xchg cx,dx
    aat1:
      add ax,cx
      add bx,dx

      sub ax,bx
      add cx,dx
      cmp cx,ax
    jnge aat3
      inc [bob]

      mov ax,[y1]
      mov bx,[y2]
      mov cx,[ysize1]
      mov dx,[ysize2]
      cmp bx,ax
    jnge aat2
      xchg ax,bx
      xchg cx,dx
    aat2:
      add ax,cx
      add bx,dx

      sub ax,bx
      add cx,dx
      cmp cx,ax
    jnge aat3
      inc [bob]
    aat3:
      mov [hit],0
      cmp [bob],2
    jnz aat4
      mov [hit],1
    aat4:
  end;
  if hit then collision:=true
         else collision:=false;
end;







procedure loadtmbgshapes(filename:string);
var x,y,i,j,shape:byte;
begin

   grapherror:=Mode13LoadPicPacked(0,0,vaddr,false,true,'tmbshape.tmb');

  for j:=0 to 19 do
    for i:=0 to 19 do
      for x:=0 to 9 do
          for y:=0 to 9 do
              ShapeTable1^[(i*2000)+(y*10)+(j*100)+x]
                          :=getpixel((j*10)+x,(i*10)+y,vaddr);
  cls32(0,vaddr);

   {  LOAD MAP  }
    assign(level_map_file,'level1.tmb');
    reset(level_map_file);
     for x:=0 to 4 do
      for y:=0 to 19 do
       for j:=0 to 4 do
        for i:=0 to 19 do
         read(level_map_file,world_map[j,x,i,y]);
    close(level_map_file);



end;

procedure RedrawScreen;
var i,j:integer;
begin
  for i:=0 to 19 do
      for j:=0 to 19 do
           putshape(
              (world_map[john.map_x,john.map_y,i,j]*100),vaddr2,10,9,
              i*10,j*10);

end;

procedure outputstat;

var tempst:string;

begin
  str(john.x,tempst);
  for i:=0 to 100 do horizontalline(200,319,i,8,vaddr2);
  outtextxy(tempst,200,10,10,5,vaddr2,false);
  str(john.map_x,tempst);
  outtextxy(tempst,200,20,10,5,vaddr2,false);
end;


Procedure playthegame(level:integer);

var ch,ch2,tempch:char;
    tempst:string;
    levelover:boolean;


BEGIN
  fade;
  loadtmbgshapes('null_for_now');

  john.x:=100; john.y:=100;
  john.map_x:=1; john.map_y:=4;
  john.step:=0;
  ch:=#1; ch2:=#1;
  flipd320(vaddr2,vaddr);
  str(level,tempst);
  {fillblock(251,52,314,59,0,vaddr);}
  outtextxy(tempst,307,51,12,0,vaddr,false);

  RedrawScreen;

  for y:=0 to 199 do horizontalline(200,320,y,8,vaddr2);
  cls32(0,vga);
  coolbox(70,85,240,120,true,vga);
  outtextxy('   WELCOME TO:',84,95,4,7,vga,false);
  outtextxy('    PINK TOWN',84,105,4,7,vga,false);
  unfade;
  clearkeyboardbuffer;
  pauseawhile(300);
  fade;
  flipd320(vaddr2,vaddr);
  flipd320(vaddr,vga);
  unfade;
  levelover:=false;
  





{**** GAME LOOP ****}
{*******************}
  Repeat
    ch2:=#1;
    ch:=#1;
    flipd320(vaddr2,vaddr);

{***Collision Check***}
  if(john.x<3) then begin
    john.map_x:=john.map_x-1;
    if (john.map_x<0) then begin john.map_x:=0; john.x:=5 end
    else begin john.x:=184 end;
    RedrawScreen;
  end;
  if(john.x>185) then begin
    inc(john.map_x);
    if (john.map_x>4) then begin john.map_x:=4; john.x:=180 end
    else john.x:=5;
    RedrawScreen;
  end;
  if(john.y>165) then begin
    inc(john.map_y);
    if (john.map_y>4) then begin john.map_y:=4; john.y:=164 end
    else john.y:=5;
    RedrawScreen;
  end;
  if(john.y<4) then begin
    dec(john.map_y);
    if (john.map_y<0) then begin john.map_y:=0; john.y:=6 end
    else john.y:=164;
    RedrawScreen;
  end;

{***DO EXPLOSIONS***}

{***MOVE BULLET***}

{***MOVE ENEMIES***}

{***READ KEYBOARD***}

    if keyprefn then BEGIN
      ch:=readkefn;
      if ch=chr(0) then ch2:=readkefn;
      if ch=#27 then levelover:=true;
      clearkeyboardbuffer;

      if ch2='M' then begin
         inc(john.x,2);
         outputstat;
      end;
      if ch2='K' then begin
         dec(john.x,2);
         outputstat;
      end;
      if ch2='H' then begin
         dec(john.y,2);
         inc(john.step);
         if(john.step>3) then john.step:=0;
      end;
      if ch2='P' then begin
         inc(john.y,2);
         inc(john.step);
         if(john.step>3) then john.step:=0;
      end;
      {if ch2=';' then help;
      if ch='+' then begin
         inc(whatdelay);
         if whatdelay>25 then whatdelay:=25;
      end;}
      if (ch='P') or (ch='p') then begin
         coolbox(65,85,175,110,true,vga);
         outtextxy('GAME PAUSED',79,95,4,7,vga,false);
         clearkeyboardbuffer;
         repeat until keyprefn;  tempch:=readkefn;
      end;
      {if ch='-' then begin
         dec(whatdelay);
         if whatdelay<1 then whatdelay:=1;
      end;}
     {if (ch='S') or (ch='s') then sbeffects:=not(sbeffects);}

      {if ch2='<' then savegame;
       }
      end;
      if (ch=' ') then begin
         (*if (bullet1out=false) then begin
            {if sbeffects then StartSound(Sound[4], 0, false);}
            bullet1out:=true;
            bullet1x:=shipx+3;
            bullet1y:=shipy+4;
            bullet1dir:=shipframe;
            putshape(shape3array[76],vaddr,10,9,bullet1x,bullet1y);
         end
         else
         if (bullet2out=false) then begin
            {if sbeffects then StartSound(Sound[4], 0, false);}
            bullet2out:=true;
            bullet2x:=shipx;
            bullet2y:=shipy;
            bullet2dir:=shipframe;
            putshape(shape3array[76],vaddr,10,9,bullet2x,bullet2y);
       end;
       *)
    end;

{***MOVE JOHN***}


        
    putshape (0,vaddr,10,9,john.x,john.y);
    case john.step of
      0: putshape (20*100,vaddr,10,9,john.x,john.y+10);
      1: putshape (40*100,vaddr,10,9,john.x,john.y+10);
      2: putshape (20*100,vaddr,10,9,john.x,john.y+10);
      3: putshape(60*100,vaddr,10,9,john.x,john.y+10);
    end;

    waitretrace;
    flipd320(vaddr,vga);


  until levelover;
END;
*/







void quit(buffer_rec *buff)
{
   int barpos,ch=0;
   
   coolbox(90,75,230,125,1,buff);
   barpos=0;
   outtextxy("QUIT??? ARE YOU",97,82,9,7,1,buff);
   outtextxy("ABSOLUTELY SURE?",97,90,9,7,1,buff);
   while (ch!='\n') {
     if (barpos==0) outtextxy("YES-RIGHT NOW!",97,98,150,0,1,buff);
        else outtextxy("YES-RIGHT NOW!",97,98,150,7,1,buff);
     if (barpos==1) outtextxy("NO--NOT YET.",97,106,150,0,1,buff);
        else outtextxy("NO--NOT YET.",97,106,150,7,1,buff);
     screen_blit_fs_buffer(buff);
     ch=getchar();
     /*
     if (ord(ch)>219) and (ord(ch)<224) then inc(barpos);*/
     if (toupper(ch)=='Y') barpos=0;
     if (toupper(ch)=='N') barpos=1;
     if (barpos==2) barpos=0;
   }
   if (barpos==1) goto menu2;
   screen_restore_video_mode();
   kb_closedown();
   exit(0);
  menu2:
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
  ch=getchar();
  screen_fade_out_pal(pal,2);
}



int main(int argc, char **argv)
{
   int CDROMmode,i,j,ch,y,hiscore,grapherror;
   char string_param[50];
   UBYTE *pal[768];
   int barpos;
   
   CDROMmode=0;
/*   for (i=1;i<argc;i++) {
       strcpy(argv[i],string_param);
       for (j=0;j<strlen(string_param);j++) string_param[j]=toupper(string_param[j]);
       if (strstr("CDROM",string_param)!=NULL) CDROMmode=1;
       if ( (strstr("HELP",string_param)!=NULL) ||
            (strstr("H",string_param)!=NULL) ){
          printf("TMBG\n\n");
          printf("Command line:  tb1 [-CDROM] [-HELP]\n\n");
          printf("-CDROM starts game in read-only mode\n");
          printf("-HELP gives this message\n\n");
          return 7;
       }
   }
  */
   
   LoadFont("tmbg1.fnt");

   
   srand(time(NULL));
    screen_set_app_title("TheyMightBeGame");   
    screen_set_video_mode();
    kb_init();
    
     buff=buff_init(SCREEN_WIDTH,SCREEN_HEIGHT);
     vaddr=buff_init(SCREEN_WIDTH,SCREEN_HEIGHT);
     vaddr2=buff_init(SCREEN_WIDTH,SCREEN_HEIGHT);
   
     buff_clear(buff);
     buff_clear(vaddr);
     buff_clear(vaddr2);
     screen_blit_fs_buffer(buff);    
     
     VMW_PRODUCTION(buff,pal);
   
   y=0; hiscore=0;

      
   
   grapherror=LoadPicSuperPacked(0,0,1,0,"tmbg1.tmb",buff,pal);
PICLOADER:   
   /*screen_fade_out_pal(pal,1);*/
   screen_blank_pal();
   grapherror=LoadPicSuperPacked(0,0,0,1,"tmbg1.tmb",vaddr2,pal);
   barpos=0;
   
MENU:
   ch=0;
   flip320(vaddr2,buff);
   screen_fade_in_pal(pal,1);
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
   {clearkeyboardbuffer;}
  */
   outtextxy("F1 HELP",0,190,9,7,0,buff);
   coolbox(117,61,200,140,1,buff);
   screen_blit_fs_buffer(buff);
   while(ch!='\n')  {
      if(barpos==0) outtextxy("NEW GAME",123,67,32,0,1,buff);
         else outtextxy("NEW GAME",123,67,32,7,1,buff);
      if(barpos==1) outtextxy("OPTIONS",123,77,32,0,1,buff);
         else outtextxy("OPTIONS",123,77,32,7,1,buff);
      if (barpos==2) outtextxy("REGISTER",123,87,32,0,1,buff);
         else outtextxy("REGISTER",123,87,32,7,1,buff);
      if (barpos==3) outtextxy("LOAD GAME",123,97,32,0,1,buff);
         else outtextxy("LOAD GAME",123,97,32,7,1,buff);
      if (barpos==4) outtextxy("STORY",123,107,32,0,1,buff);
         else outtextxy("STORY",123,107,32,7,1,buff);
      if (barpos==5) outtextxy("CREDITS",123,117,32,0,1,buff);
         else outtextxy("CREDITS",123,117,32,7,1,buff);
      if (barpos==6) outtextxy("QUIT",123,127,32,0,1,buff);
         else outtextxy("QUIT",123,127,32,7,1,buff);
     screen_blit_fs_buffer(buff);
     ch=getchar();
       /*if (ord(ch)=222) or (ord(ch)=220) then inc(barpos);
       if (ord(ch)=223) or (ord(ch)=221) then dec(barpos);
       if (ord(ch)=168) then begin barpos:=10; ch:=#13; end;*/
       if (ch=='N') barpos=0;
       if (ch=='O') barpos=1;
       if (ch=='R') barpos=2;
       if (ch=='L') barpos=3;
       if (ch=='S') barpos=4;
      if (ch=='C') barpos=5;
       if (ch=='Q') barpos=6;
       /*if ch==#27 then begin
          barpos:=6;
          ch:=#13;
       end;
	*/
       if (barpos==7) barpos=0;
       if (barpos==-1) barpos=6;
   }
   if (barpos==6) quit(buff);
/*   {if barpos=1 then options;
   if barpos=2 then register;
   if barpos=3 then loadgame;
   if barpos=4 then
      begin
        story;
        fade;
        cls(0,vga);
      end;
   if barpos=5 then credits;
   if barpos=10 then help;          }
   if barpos=0 then playthegame(0);
 */
   if (barpos==0) goto PICLOADER;
   if (barpos==4) goto PICLOADER;
   if (barpos==3) goto PICLOADER;
   goto MENU;
    
 screen_restore_video_mode();   
  
  
}

