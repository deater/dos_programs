unit subs2;
interface
uses Sub,Fishes,Graph,Crt,soundfx;
var
   life1,life2,col,count1,m1x,m1y,m2x,m2y,sub1x,sub1y,size,counter,movedir,subtemp1x,subtemp1y,sub2x,sub2y,
   ju,jx,jy,jc,rn,subtemp2x,subtemp2y,li:integer;
   sub1,sub2:pointer;
   ke,ne:char;
   sub1win,sub2win,movsub1,movsub2,mispres1,mispres2,missile1,missile2,explo1,explo2:boolean;
procedure ckey;
procedure setup;
procedure uwt(v1,v2,v3,v4:integer);
implementation procedure ckey;
 begin
 count1:=count1+1;

 if keypressed then begin
        ke:=readkey;
        if ke='W' then sub1y:=subtemp1y-10;
        if ke='X' then sub1y:=subtemp1y+10;
        if ke='D' then sub1x:=subtemp1x+10;
        if ke='A' then sub1x:=subtemp1x-10;
        if (ke='A')or(ke='D')or(ke='X')or(ke='W')then movsub1:=true;
        if ke=chr(0) then begin
          ne:=readkey;
          if ord(ne)=72 then sub2y:=subtemp2y-10;
          if ord(ne)=80 then sub2y:=subtemp2y+10;
          if ord(ne)=77 then sub2x:=subtemp2x+10;
          if ord(ne)=75 then sub2x:=subtemp2x-10;
        if (ord(ne)=72) or (ord(ne)=80) or (ord(ne)=77) or (ord(ne)=75) then movsub2:=true;
        if ord(ne)=82 then mispres2:=true;
        end;

        if ke=' ' then begin
             if missile1<>true then begin
             m1x:=sub1x+49;
             m1y:=sub1y+10;
             missile1:=true;
             launch;
             end;
           end;
        if (mispres2) and (missile2=false) then begin
              mispres2:=false;
              m2x:=sub2x-1;
              m2y:=sub2y+10;
              missile2:=true;
              launch;
              end;
        mispres1:=false;
        mispres2:=false;
        if sub1y<30 then sub1y:=sub1y+10;
        if sub1x<0 then sub1x:=sub1x+10;
        if sub1y>150 then sub1y:=sub1y-10;
        if sub1x>220 then sub1x:=sub1x-10;
        if sub2y>150 then sub2y:=sub2y-10;
        if sub2y<30 then sub2y:=sub2y+10;
        if sub2x<375 then sub2x:=sub2x+10;
        if sub2x>575 then sub2x:=sub2x-10;
          setfillstyle(solidfill,1);
        if movsub1 then bar(subtemp1x,subtemp1y,subtemp1x+48,subtemp1y+17);
        if movsub2 then bar(subtemp2x,subtemp2y,subtemp2x+48,subtemp2y+17);
        if movsub2 then putimage(sub2x,sub2y,sub2^,$0);
        if movsub1 then putimage(sub1x,sub1y,sub1^,$0);
        if movsub1 then movsub1:=false;
        if movsub2 then movsub2:=false;
        subtemp1x:=sub1x;
        subtemp1y:=sub1y;
        subtemp2y:=sub2y;
        subtemp2x:=sub2x;
        end;
        if count1>1500 then count1:=0;

     if (missile1=true) and (count1=50) then begin
       setcolor(1);
       line(m1x,m1y,m1x+10,m1y);
       m1x:=m1x+10;
       setcolor(0);
       line(m1x,m1y,m1x+10,m1y);
       end;
     if (missile2=true) and (count1=50) then begin
        setcolor(1);
        line(m2x,m2y,m2x-10,m2y);
        m2x:=m2x-10;
        setcolor(0);
        line(m2x,m2y,m2x-10,m2y);
        end;
     if (m2x<10) then begin
        setcolor(1);
        line(m2x,m2y,m2x-10,m2y);
        missile2:=false;
        m2x:=20;
        end;
     if (m1x>600) then begin
        setcolor(1);
        line(m1x,m1y,m1x+10,m1y);
        missile1:=false;
        m1x:=590;
     end;
     if missile1 =true then begin
       if (m1x+4>=sub2x) and (m1x<sub2x+30) and  (m1y>=sub2y) and (m1y<sub2y+20) then explo1:=true;
     end;
     if missile2=true then begin
       if (m2x-4>=sub1x) and (m2x<sub1x+50) and (m2y>=sub1y) and (m2y<sub1y+20) then explo2:=true;
     end;
     if explo1=true then begin
       hit;
       setfillstyle(solidfill,1);
       bar(m1x,m1y-2,m1x+10,m1y+3);
       setfillstyle(solidfill,12);
       bar(m1x+9,m1y-2,m1x+10,m1y+3);
       setcolor(14);
       line(m1x+5,m1y-2,m1x+8,m1y-1);
       line(m1x+3,m1y,m1x+8,m1y);
       line(m1x+5,m1y+2,m1x+8,m1y+1);
          setfillstyle(solidfill,14);
         life2:=life2-1;
         if life2=3 then bar(605,180,595,195);
         if life2=2 then bar(575,180,585,195);
         if life2=1 then bar(555,180,565,195);
         if life2=0 then bar(535,180,545,195);
         if life2<=-1 then sub1win:=true;
       explo1:=false;
       missile1:=false;
      end;
     if explo2=true then begin
      hit;
      setfillstyle(solidfill,1);
      bar(m2x-10,m2y-2,m2x,m2y+3);
      setfillstyle(solidfill,12);
      bar(m2x-10,m2y-2,m2x-9,m2y+3);
      setcolor(14);
      line(m2x-5,m2y-2,m2x-8,m2y-1);
      line(m2x-5,m2y+2,m2x-8,m2y+1);
      line(m2x-3,m2y,m2x-8,m2y);
         setfillstyle(solidfill,14);
         life1:=life1-1;
         if life1=3 then bar(135,180,145,195);
         if life1=2 then bar(115,180,125,195);
         if life1=1 then bar(95,180,105,195);
         if life1=0 then bar(75,180,85,195);
         if life1<=-1 then sub2win:=true;
      explo2:=false;
      missile2:=false;
     end;
 if sub2win=true then begin
    for ju:=1 to 100 do begin
      jx:=random(47);
      jy:=random(17);
      jc:=random(20);
      rn:=random(4);
      if rn=1 then rn:=12;
      if rn=2 then rn:=14;
      if rn=3 then rn:=6;
      setcolor(rn);
      circle(jx+sub1x,jy+sub1y,jc);
     end;
     end;
 if sub1win=true then begin
    for ju:=1 to 100 do begin
       jx:=random(47);
       jy:=random(17);
       jc:=random(20);
       rn:=random(4);
       if rn=1 then rn:=12;
       if rn=2 then rn:=14;
       if rn=3 then rn:=6;
       setcolor(rn);
       circle(jx+sub2x,jy+sub2y,jc);
       end;
       end;
     end;
procedure setup;
begin
  initfish;
  initsub;
  missile2:=false;
  m1y:=100;
  sub1win:=false;
  sub2win:=false;
  missile1:=false;
  life1:=4;
  life2:=4;
  size:=imagesize(101,100,148,117);
  getmem(sub1,size);
  getimage(101,100,148,117,sub1^);
  setfillstyle(1,solidfill);
  bar(101,100,148,117);
  size:=imagesize(201,100,248,117);
  getmem(sub2,size);
  getimage(201,100,248,117,sub2^);
  bar(201,100,248,117);
  sub1x:=100;
  sub1y:=100;
  sub2x:=500;
  sub2y:=100;
  subtemp1x:=100;
  subtemp2x:=500;
  subtemp1y:=100;
  subtemp2y:=100;
  putimage(subtemp1x,subtemp1y,sub1^,$0);
  putimage(sub2x,sub2y,sub2^,$0);
  ke:=' ';
  end;
procedure uwt(v1,v2,v3,v4:integer);
begin
     setup;
  repeat
  ckey;
    if ke<>'L' then ke:='.';
    if missile1= true then begin
    end;
    until (ke='L') or (sub1win=true) or (sub2win=true);
    readln;
    closegraph;
  end;
begin;
end.