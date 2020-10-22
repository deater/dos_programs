unit fishes;
interface
uses Graph,Crt;

const
     Fonts: array[0..4] of string[13]=
            ('DefaultFont','TriplexFont','SmallFont','SansSerifFont','GothicFont');
     Linestyles:array[0..4] of string[9]=
            ('SolidLn','DottedLn','CenterLn','DashedLn','UserBitLn');

var
   grdrive,grmode,fish,font,i,j,c1,c2,c3,tempfish:integer;
   fishx,fishy,fish2x,fish2y,size,ranfish,fishdir,oldfishdir:integer;
   fish1,fish2,fish3:pointer;
   weed1,weed2,weed3,weed4,floor1,floor2,floor3:integer;
   ch:array[0..10] of integer;

procedure movfish(fx,fy,fd:integer);
procedure initfish;

implementation procedure movfish(fx,fy,fd:integer);

begin;
    setfillstyle(solidfill,1);
      bar(fishx,fishy,fishx+45,fishy+30);

    fishx:=fishx+fx;
    fishy:=fishy+fy;
    if fishy<35 then fishy:=fishy+10;
    if fishy>145 then fishy:=fishy-10;
    if fishx<0 then fishx:=fishx+10;
    if fishx>575 then fishx:=fishx-10;
    tempfish:=fd;
    if oldfishdir<>fd then tempfish:=3;
    oldfishdir:=fd;
    if tempfish<2 then putimage(fishx,fishy,fish2^,orput);
    if ((tempfish>1)and(tempfish<3)) then putimage(fishx,fishy,fish1^,orput);
    if tempfish>2 then putimage(fishx,fishy,fish3^,orput);
end;


procedure initfish;
begin
       ch[0]:=1;
       ch[1]:=2;
       ch[2]:=3;
       ch[3]:=4;
       ch[4]:=4;
       ch[5]:=3;
       ch[6]:=2;
       ch[7]:=1;
       ch[8]:=2;
       ch[9]:=3;
       ch[10]:=4;
        grdrive:=ega;
        grmode:=egalo;
        font:=SansSerifFont;
     initgraph(grdrive,grmode,'');
     setfillstyle(solidfill,1);
     settextstyle(font,0,3);
     setcolor(12);
{Beginning}
     setfillstyle(solidfill,1);
     floodfill(20,20,1);
     setfillstyle(solidfill,11);
     bar(0,0,639,25);

       outtextxy(200,0,'Underwater Trouble');
       settextstyle(smallfont,0,4);
     outtextxy(420,13,'by Vincent Weaver');
        setcolor(12);
        setfillstyle(solidfill,1);

{Ocean Floor}
     setfillstyle(solidfill,14);
     bar(0,175,639,320);
     for floor3:=1 to 200 do begin
     floor1:=random(25)+1;
     floor2:=random(640);
     putpixel(floor2,floor1+175,6);
     end;
{Crab}
      setfillstyle(solidfill,4);
      setcolor(4);
      bar(244,186,250,192);
      bar(250,188,252,190);
      bar(242,188,244,190);
      bar(250,184,252,186);
      bar(242,184,244,186);
      bar(248,180,250,184);
      bar(252,180,254,184);
      bar(240,180,242,184);
      bar(244,180,246,184);
      bar(242,192,244,194);
      bar(250,192,252,194);
{SeaWeed}
         setfillstyle(solidfill,2);
         weed4:=280;
         repeat
         for weed1:=0 to 14 do begin
           if round(weed1/2)=weed1/2 then weed3:=1;
           bar(weed4+weed3,weed1*2+145,weed4+2+weed3,147+weed1*2);
           weed3:=0;
         end;
         weed4:=weed4+40;
         until weed4>390;
{Words}
       Setcolor(0);
       setfillstyle(0,solidfill);
       Settextstyle(triplexfont,0,2);
       outtextxy(20,175,'Life:');
       outtextxy(480,175,'Life:');
       bar(75,180,85,195);
       bar(95,180,105,195);
       bar(115,180,125,195);
       bar(135,180,145,195);
       bar(535,180,545,195);
       bar(555,180,565,195);
       bar(575,180,585,195);
       bar(595,180,605,195);

{Fishiez}
     setcolor(3);
     c1:=30;
     c2:=30;
       while c2<60 do begin
         while c1<75 do begin
         i:=-1;
            for j:=c1 to c1+10 do begin
              i:=i+1;
              fish:=ch[i];
              line(j,c2+3+fish,j,c2+5-fish);
            end;
            putpixel(c1+3,c2+3,1);
            setfillstyle(solidfill,3);
            bar(c1+4,c2+100,c1+6,c2+107);
            putpixel(c1+4,c2+103,1);
            putpixel(c1+6,c2+103,1);
            putpixel(c1+5,c2+106,1);
          i:=11;
            for j:=100+c1 to 110+c1 do begin
              i:=i-1;
              fish:=ch[i];
              line(j,c2+3+fish,j,c2+5-fish);
            end;
            putpixel(107+c1,c2+3,1);
         c1:=c1+15;
      end;
         c2:=c2+10;
         c1:=30;
      end;
     size:=imagesize(30,30,75,60);
        getmem(fish1,size);
        getimage(30,30,75,60,fish1^);
     size:=imagesize(130,30,175,60);
        getmem(fish2,size);
        getimage(130,30,175,60,fish2^);
     size:=imagesize(30,130,75,160);
        getmem(fish3,size);
        getimage(30,130,75,160,fish3^);
        putimage(30,30,fish1^,xorput);
        putimage(130,30,fish2^,xorput);
        putimage(30,130,fish3^,xorput);
          setfillstyle(solidfill,1);
        bar(30,30,75,60);
        bar(130,30,175,60);
        bar(30,130,75,160);
        fishx:=30;
        fishy:=30;
  end;
  end.
