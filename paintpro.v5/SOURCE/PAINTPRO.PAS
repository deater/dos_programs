program paintProgram; {By Vincent M. Weaver 21085-4706}
uses PPTPU,drivers,graph,crt,dos;


var grinput,scrninput:string[20];
    filename,chxst,chyst,tempst,grinp:string;
    savestr,magchar,ch,colch:string[10];
    viewport:viewporttype;
    savchar,tempch,ch5,grinpchar,scrninpchar:char;
    xadd,yadd,linex,liney,xrad,yrad,oxrad,oyrad,
    page,i,xsize,ysize,drawcolor,rad,chx,chy,grinpint,tempint,
    miny,maxy,coloroffill,ifill,jfill,scrninpint,graphdriver,graphmode,
    size,tempcol,magx,magy,xval,maxcolor,magcolor,savx,savy,sxadd,syadd,
    row,rowadd:integer;
    menubarptr,magch,magch2,autodetectpointer,crossh,pulldownbar,
    boxreplace,blockout,screen,popbox,sidebar1ptr,sidebar2ptr:pointer;
    scol:word;
    fullscreenedit,getdrawing,circledrawing,linedrawing,squaredrawing:boolean;
    filestuff:searchrec;
    magarray: array[0..24,0..24] of integer;
label 10;
{$f+}
function detectvga256:integer;
var
  detecteddriver,suggestedmode:integer;
begin
  detectgraph(detecteddriver,suggestedmode);
  if (detecteddriver=vga) or (detecteddriver=mcga) then
     detectvga256:=0
  else
     detectvga256:=grerror;
  end;
{$f-}
procedure flippage;
begin
  setactivepage(1);
  setvisualpage(1);
  textcolor(15);
  directvideo:=false;
  getviewsettings(viewport);
end;
procedure flipback;
begin
  cleardevice;
  setvisualpage(0);
  setactivepage(0);
  with viewport do setviewport(x1,y1,x2,y2,clip);
end;
procedure putbox;
begin
  getimage(100,100,200,150,popbox^);
  setfillstyle(solidfill,15);
  bar(100,100,200,150);
  tempcol:=getcolor;
  setcolor(8);
  rectangle(100,100,200,150);
  setcolor(0);
end;
procedure killbox;
begin
  putimage(100,100,popbox^,normalput);
  setcolor(tempcol);
end;
procedure changecolor;
begin;
end;
procedure newbox;
begin
  setfillstyle(solidfill,15); bar(100,100,200,150);
  setcolor(8); rectangle(100,100,200,150);
  setcolor(0);
end;
procedure loadpicproc;
begin
  putbox;
  outtextxy(102,102,'Load File'); filename:=graphread(102,120,15,14);
  newbox;
  outtextxy(102,102,'Load at what');
  outtextxy(102,112,'X-');
     tempst:=graphread(122,112,15,8);
     val(tempst,xsize,xsize);
  outtextxy(102,122,'Y-');
     tempst:=graphread(122,122,15,8);
     val(tempst,ysize,ysize);
  findfirst(filename,anyfile,filestuff);
  killbox;
  page:=0;
  if doserror=0 then loadpicat(filename,xsize,ysize,page);
  if doserror<>0 then begin
     outtextxy(0,150,'**** Error File Not Found ***');
     writeln(chr(7));
     repeat until keypressed;
     tempch:=readkey;
  end;

end;
procedure boxwait;
begin
  outtextxy(102,142,'Press A Key');
  repeat until keypressed;  tempch:=readkey;
end;
procedure aboutppro;
begin
  putbox;
  outtextxy(102,102,'About...');
  outtextxy(112,112,'Paintpro');
  outtextxy(112,122,'Ver 3.16');
  outtextxy(112,132,'10-24-1993');
  boxwait;
  newbox;
  outtextxy(102,102,'Author');
  outtextxy(112,112,'Vincent');
  outtextxy(112,122,'Weaver');
  boxwait;
  newbox;
  outtextxy(102,102,'Send Any');
  outtextxy(102,112,'Donations To');
  outtextxy(102,122,'The Followin');
  outtextxy(102,132,'Address:');
  boxwait;
  newbox;
  outtextxy(102,102,'326 Foster');
  outtextxy(132,112,'Knoll DR');
  outtextxy(102,122,'Joppa, MD');
  outtextxy(112,132,'21085-4706');
  boxwait;
  newbox;
  outtextxy(102,102,'Or Call:');
  outtextxy(112,112,'UTOPIA BBS');
  outtextxy(102,122,'410-557-0868');
  outtextxy(102,132,' 2400bpsN81');
  outtextxy(112,142,'#3 Deater');
  repeat until keypressed;  tempch:=readkey;
  killbox;
end;
procedure magnify;
begin
   if chx>615 then exit;
   if chy>(getmaxx-25) then exit;
   for magx:=0 to 24 do begin
       for magy:= 0 to 24 do begin
           magarray[magx,magy]:=getpixel(chx+magx,chy+magy);
       end;
   end;
   flippage;
   for magx:=0 to 24 do begin
       for magy:=0 to 24 do begin
           setfillstyle(1,magarray[magx,magy]);
           bar(magx*5,magy*5,magx*5+4,magy*5+4);
       end;
   end;
   for magx:=0 to 24 do begin
       for magy:=0 to 24 do begin
           putpixel(300+magx,50+magy,magarray[magx,magy]);
       end;
   end;
   setfillstyle(solidfill,15);
   bar(300,0,305,5);
   magch:=get(300,0,304,4,magch);
   magch2:=get(300,0,300,0,magch2);
   setfillstyle(solidfill,0);
   bar(300,0,305,5);
   magx:=0; magy:=0;
   magcolor:=15;
   putimage(magx*5,magy*5,magch^,xorput);
   putimage(300+magx,50+magy,magch2^,xorput);
   repeat
       repeat until keypressed;
       magchar:=input;
       putimage(magx*5,magy*5,magch^,xorput);
       putimage(300+magx,50+magy,magch2^,xorput);
       if upcase(magchar[1])=' ' then begin
          putpixel(300+magx,50+magy,magcolor);
          setfillstyle(1,magcolor);
          bar(magx*5,magy*5,magx*5+4,magy*5+4);
          magarray[magx,magy]:=magcolor;
       end;
       if upcase(magchar[1])='C' then begin
          magcolor:=magcolor+1;
          setfillstyle(1,magcolor);
          bar(300,80,325,105);
       end;
       if magchar='ÛDOWN' then magy:=magy+1;
       if magchar='ÛRIGHT' then magx:=magx+1;
       if magchar='ÛLEFT' then magx:=magx-1;
       if magchar='ÛUP' then magy:=magy-1;
       if magx>24 then magx:=24; if magx<0 then magx:=0;
       if magy>24 then magy:=24; if magy<0 then magy:=0;
       putimage(300+magx,50+magy,magch2^,xorput);
       putimage(magx*5,magy*5,magch^,xorput);
   until upcase(magchar[1])='Q';
   flipback;
   for magx:=0 to 24 do begin
       for magy:=0 to 24 do begin
           putpixel(chx+magx,chy+magy,magarray[magx,magy]);
       end;
   end;
end;
procedure fill;
begin
  xval:=0;
  ColorOfFill:=getpixel(chx,chy);
  for ifill:=chy downto 0 do begin
      if getpixel(chx,ifill)<>ColorOfFill then begin
         if miny=0 then miny:=ifill;
      end;
  end;
  if miny=0 then miny:=0;
  for ifill:=chy to getmaxy do begin
      if getpixel(chx,ifill)<>ColorOfFill then begin
         if maxy=0 then maxy:=ifill;
       end;
   end;
   if maxy=0 then maxy:=ifill;
   if miny<0 then miny:=0;
   for ifill:=(miny+1) to (maxy-1) do begin
       for jfill:=chx downto 0 do begin
           if getpixel(jfill,ifill)<>ColorOfFill then begin
           if xval=0 then xval:=jfill;
       end;
    end;
    setcolor(drawcolor);
    line(xval+1,ifill,chx,ifill);
    xval:=0;
    for jfill:=chx+1 to getmaxx do begin
        if getpixel(jfill,ifill)<>coloroffill then begin
           if xval=0 then xval:=jfill;
        end;
    end;
    if xval=0 then xval:=jfill;
    setcolor(drawcolor);
    line(chx,ifill,xval-1,ifill);
    xval:=0;
   end;
   miny:=0; maxy:=0;
end;
procedure savepicproc(fullscrn:boolean);
begin
   if not(fullscrn) then begin
      setwritemode(xorput);
      setcolor(drawcolor);
      linex:=chx;
      liney:=chy;
      savx:=linex;
      savy:=liney;
      repeat;
         savestr:='!';
         if keypressed then begin
            savestr:=input;
            if savestr='ÛUP' then syadd:=-1;
            if savestr='ÛDOWN' then syadd:=+1;
            if savestr='ÛLEFT' then sxadd:=-1;
            if savestr='ÛRIGHT' then sxadd:=+1;
            if savestr='8' then syadd:=-5;
            if savestr='2' then syadd:=+5;
            if savestr='4' then sxadd:=-5;
            if savestr='6' then sxadd:=+5;
            directvideo:=false;
            if (savy+syadd>=liney) and (savy+syadd<getmaxy) then savy:=savy+syadd;
            if (savx+sxadd>=linex) and (savx+sxadd<getmaxx) then savx:=savx+sxadd;
            rectangle(linex,liney,savx-sxadd,savy-syadd);
            rectangle(linex,liney,savx,savy);
            sxadd:=0;   syadd:=0;
         end;
       until savestr='ÛENTER';
    rectangle(linex,liney,savx-sxadd,savy-syadd);
    setwritemode(normalput);
    end;
    putbox;
      outtextxy(102,102,'Save File As'); filename:=graphread(102,130,15,14);
    killbox;
    if not(filename='') then savpicat(linex,liney,savx,savy,filename);
end;
procedure helpscreen;
var helpfile:text;
    numstring,instring,cmmdstring,outstring:string;
    gd,gm,i,whereisthing,xacross,xpos,ypos:integer;
begin
  if getmaxx<600 then exit;
  getimage(160,10,480,190,boxreplace^);
  setfillstyle(solidfill,8);
  bar(160,10,480,190);
  setcolor(7);
  rectangle(160,10,480,190);
  xpos:=165+5;
  ypos:=10;
  setcolor(12);
  settextstyle(2,0,4);
  assign(helpfile,'ppro.hlp');
  reset(helpfile);
  repeat
    readln(helpfile,instring);
    for i:=1 to length(instring) do if instring[i]='}' then whereisthing:=i;
    cmmdstring:=copy(instring,1,whereisthing);
    outstring:=copy(instring,whereisthing+1,(length(instring)-whereisthing)+1);
    for i:=1 to length(outstring) do if outstring[i]='_' then outstring[i]:=' ';
    if cmmdstring[2]='X' then begin
       numstring:=copy(cmmdstring,3,2);
       val(numstring,xacross,xacross);
       for i:=1 to xacross do xpos:=xpos+10;
    end;
    outtextxy(xpos,ypos,outstring);
    ypos:=ypos+10;
    xpos:=170;
  until instring='{ENDFILE}';
  repeat until keypressed;
  tempch:=readkey;
  putimage(160,10,boxreplace^,normalput);
  settextstyle(defaultfont,0,0);
  close(helpfile);
end;

procedure sidebar;

var lengthofside,row,col,i:integer;
    ls,barsize:real;
    chxstr,chystr:string[5];
begin
  fullscreenedit:=not(fullscreenedit);
  if(fullscreenedit=true) then begin
     putimage(0,0,sidebar1ptr^,normalput);
     putimage(0,round(getmaxy/2),sidebar2ptr^,normalput);
  end;
  if fullscreenedit=true then exit;
  getimage(0,0,49,round(getmaxy/2),sidebar1ptr^);
  getimage(0,round(getmaxy/2),49,getmaxy,sidebar2ptr^);
  str(chx,chxstr);
  str(chy,chystr);
  chxstr:='X:'+chxstr;
  chystr:='Y:'+chystr;
  ls:=(((getmaxy+1)/100)-1)*50;
  lengthofside:=round(ls);
  barsize:=(lengthofside/8);
  if getdrivername<>'EGAVGA' then begin
     setcolor(15);
     rectangle(0,150,49,199);
     for row:=0 to 15 do begin
       for col:=0 to 15 do begin
         setfillstyle(solidfill,(row*16)+col);
         bar(1+(row*3),151+(col*3),3+(row*3),153+(col*3));
       end;
     end;
     setfillstyle(solidfill,15);
     bar(0,109,49,150);
     setfillstyle(solidfill,drawcolor);
     setcolor(0);
     bar(2,110,18,130);
     rectangle(2,110,18,130);
     settextstyle(smallfont,0,0);
     outtextxy(20,108,chxstr);
     outtextxy(20,118,chystr);
     outtextxy(1,133,'PAINTPRO');
  end;
  if getdrivername='EGAVGA' then begin
     setcolor(15);
     for row:=0 to 1 do begin
         for col:=0 to 7 do begin
           setfillstyle(solidfill,(row*8)+col);
           bar(1+round(row*24),1+(getmaxy-lengthofside)+(col*round(barsize)),1+(row*24)+23,1+getmaxy+(col*round(barsize)));
           rectangle(0,getmaxy-lengthofside,49,getmaxy);
         end;
     end;
     setfillstyle(solidfill,15);
     bar(0,109,49,getmaxy-lengthofside-1);
     setfillstyle(solidfill,drawcolor);
     setcolor(0);
     bar(2,110,18,130);
     rectangle(2,110,18,130);
     settextstyle(smallfont,0,0);
     outtextxy(20,108,chxstr);
     outtextxy(20,118,chystr);
     outtextxy(1,133,'PAINTPRO');
  end;
  settextstyle(defaultfont,0,0);
end;
{*************}
procedure pressenter;
var lengthofside,newcolor,row,col,i:integer;
    ls,barsize:real;
    chxstr,chystr:string[5];
begin
  if fullscreenedit=false then begin
     if chx<50 then begin
        str(chx,chxstr);
        str(chy,chystr);
        chxstr:='X:'+chxstr;
        chystr:='Y:'+chystr;
        ls:=(((getmaxy+1)/100)-1)*50;
        lengthofside:=round(ls);
        if chy>getmaxy-lengthofside then begin
           newcolor:=getpixel(chx,chy);
           drawcolor:=newcolor;
           setfillstyle(solidfill,drawcolor);
           setcolor(0);
           bar(2,110,18,130);
           rectangle(2,110,18,130);
        end;
     end;
  end;
end;
procedure menubar(oldkey:string);
var column,columnadd:integer;
   procedure filebar;
   begin
     getimage(0,9,75,60,pulldownbar^);
     setfillstyle(solidfill,15);
     bar(0,9,75,60);
     setcolor(8);
     rectangle(0,9,75,60);
     line(0,48,75,48);
     setcolor(0);
     outtextxy(1,10,' bout...');
     outtextxy(1,20,' ave');
     outtextxy(1,30,'Save A ea');
     outtextxy(1,40,' oad');
     outtextxy(1,50,' uit');
     setcolor(7);
     outtextxy(1,10,'A');
     outtextxy(1,20,'S');
     outtextxy(1,30,'      r');
     outtextxy(1,40,'L');
     outtextxy(1,50,'Q');
     putimage(1,10,blockout^,xorput);
     row:=1;
     repeat;
       rowadd:=0;
         ch:=input;
         if ch='ÛDOWN' then rowadd:=+1;
         if ch='ÛUP' then rowadd:=-1;
         if rowadd<>0 then begin
            putimage(1,row*10,blockout^,xorput);
            row:=row+rowadd;
            if row>5 then row:=1;
            if row<1 then row:=5;
            if row=1 then putimage(1,10,blockout^,xorput);
            if row=2 then putimage(1,20,blockout^,xorput);
            if row=3 then putimage(1,30,blockout^,xorput);
            if row=4 then putimage(1,40,blockout^,xorput);
            if row=5 then putimage(1,50,blockout^,xorput);
       end;
     until (ch='ÛESCAPE') or (ch='ÛENTER');
     putimage(0,9,pulldownbar^,normalput);
     if (row=1) and (ch='ÛENTER') then aboutppro;
     if (row=2) and (ch='ÛENTER') then savepicproc(true);
     if (row=3) and (ch='ÛENTER') then savepicproc(false);
     if (row=4) and (ch='ÛENTER') then loadpicproc;
     if (row=5) and (ch='ÛENTER') then begin closegraph; halt; end;


   end;
   procedure editbar;
   begin
   end;
   procedure optionsbar;
   begin
   end;
begin
  getimage(0,0,getmaxx-1,8,menubarptr^);
  setfillstyle(solidfill,4);
  bar(0,0,getmaxx-1,8);
  setcolor(7);
  outtextxy(1,1,' ILE           DIT           PTIONS');
  setcolor(15);
  outtextxy(1,1,'F'); outtextxy(112,1,'E'); outtextxy(224,1,'O');
  if oldkey='ÛALT-=' then begin
     column:=1;
     putimage(0,0,blockout^,xorput);
     repeat
       columnadd:=0;
       ch:=input;
       if ch='ÛRIGHT' then columnadd:=+1;
       if ch='ÛLEFT' then columnadd:=-1;
       if columnadd<>0 then begin
          putimage((column-1)*112,0,blockout^,xorput);
          column:=column+columnadd;
          if column>3 then column:=1;
          if column<1 then column:=3;
          if column=1 then putimage(0,0,blockout^,xorput);
          if column=2 then putimage(112,0,blockout^,xorput);
          if column=3 then putimage(224,0,blockout^,xorput);
       end;
     until (ch='ÛESC') or (ch='ÛENTER');
     if ch='ÛENTER' then begin
        if column=1 then oldkey:='ÛALT-F';
        if column=2 then oldkey:='ÛALT-E';
        if column=3 then oldkey:='ÛALT-O';
     end;
  end;
  if oldkey='ÛALT-F' then filebar;
  if oldkey='ÛALT-O' then optionsbar;
  if oldkey='ÛALT-E' then editbar;
  putimage(0,0,menubarptr^,normalput);
  ch:='ü';
end;


begin
  if (paramstr(2)<>'-') and (paramstr(1)<>'-') then opening;
  titlescrn;
  ch:=readkey;
  clrscr;
  numon(1,0);
  maxy:=0;
  if (Paramstr(1)<>'1') and (Paramstr(1)<>'2') and(Paramstr(1)<>'3')
     and(Paramstr(1)<>'4') then begin
  if registerBGIdriver(@egavgadriverproc)<0 then writeln;
  writeln('Please Choose the Graphics Mode You Wish To Use');
  writeln('       1. Low EGA  640 x 200  16 colors Screen 8 in basic');
  writeln('       2. Hi  EGA  640 x 350  16 colors Screen 9 in basic');
  writeln('       3. Hi  VGA  640 x 480  16 colors Screen 11 in QBasic');
  writeln('       4. MCGA/VGA 320 x 200 256 colors Screen 12 in QBasic');
  writeln;
10:write  ('Please pick one==>'); readln(grinput);
  if length(grinput)>1 then writeln('Invalid Input');
  if length(grinput)>1 then goto 10;
  grinpchar:=grinput[1];
  if (ord(grinpchar)<49) or (ord(grinpchar)>52) then goto 10;
  val(grinpchar,grinpint,tempint);
  end;
  if  (Paramstr(1)='1') or (Paramstr(1)='2') or (Paramstr(1)='3')
       or (Paramstr(1)='4') then begin
       grinp:=paramstr(1);
       val(grinp[1],grinpint,tempint);
  end;
  case grinpint of
       1:begin graphdriver:=ega; graphmode:=egalo; end;
       2:begin graphdriver:=ega; graphmode:=egahi; end;
       3:begin graphdriver:=vga; graphmode:=vgahi; end;
       4:begin autodetectpointer:=@detectvga256;
               graphdriver:=installuserdriver('VGA256',autodetectpointer);
               graphdriver:=detect;  end;  end;
  fullscreenedit:=true;
  initgraph(graphdriver,graphmode,'');


  putpixel(0,0,15);
  setfillstyle(solidfill,15);
  maxcolor:=getmaxcolor;
  GETMEM(CROSSH,IMAGESIZE(0,0,1,1));
  GETIMAGE(0,0,1,1,CROSSH^);
  getmem(popbox,imagesize(0,0,100,50));
  getmem(boxreplace,imagesize(160,10,480,190));
  getmem(menubarptr,imagesize(0,0,getmaxx-1,8));
  bar(0,0,73,8);
  blockout:=get(0,0,73,8,blockout);
  SETFILLSTYLE(SOLIDFILL,0);
  bar(0,0,73,8);
  Size := ImageSize(0, 0, 100,100);
  GetMem(pulldownbar, Size);
  linedrawing:=false;
  squaredrawing:=false;
  circledrawing:=false;
  chx:=0;
  chy:=0;
  ch:='!';
  drawcolor:=15;
  size:=imagesize(0,0,44,round(getmaxy/2));
  getmem(sidebar1ptr,size);
  size:=imagesize(0,round(getmaxy/2),44,getmaxy);
  getmem(sidebar2ptr,size);
  sidebar;
  putimage(chx,chy,crossh^,xorput);
  repeat;
  if keypressed then begin
     ch:=input;
     putimage(chx,chy,crossh^,xorput);
     if ch='ÛUP' then if (chy-1)>0 then yadd:=-1;
     if ch='ÛDOWN' then if (chy+1)<getmaxy then yadd:=+1;
     if ch='ÛRIGHT' then if (chx+1)<getmaxx then xadd:=+1;
     if ch='ÛLEFT' then if (chx-1)>0 then xadd:=-1;
     if ch='ÛF1' then helpscreen;
     if ch='ÛF2' then sidebar;
     if ch='ÛENTER' then pressenter;
     if (ch='ÛALT-F') or (ch='ÛALT-O') or (ch='ÛALT-E')
         or (ch='ÛALT-=') then menubar(ch);
         if ch='2' then if (chy+10)<getmaxy then yadd:=+10;
     if ch='6' then if (chx+10)<getmaxx then xadd:=+10;
     if ch='4' then if (chx-7)>0 then xadd:=-10;
     if ch='8' then if (chy-7)>0 then yadd:=-10;
     chx:=chx+xadd;
     chy:=chy+yadd;
     if upcase(ch[1])='H' then clearviewport;
     if upcase(ch[1])='M' then magnify;
     if ch=' ' then putpixel(chx,chy,drawcolor);
     if upcase(ch[1])='F' then fill;
     if upcase(ch[1])='U' then begin
              if squaredrawing=true then begin
              setwritemode(normalput);
              rectangle(linex,liney,chx,chy);
           end;
           if squaredrawing=false then begin
              setwritemode(xorput);
              setcolor(drawcolor);
              linex:=chx;
              liney:=chy;
           end;
           squaredrawing:=not(squaredrawing);
           end;
     if upcase(ch[1])='Y' then begin
        if circledrawing=true then begin
           rectangle(linex-rad,liney-rad,linex+rad,liney+rad);
           setwritemode(normalput);
           circle(linex,liney,rad);
        end;
        if circledrawing=false then begin
           setwritemode(xorput);
           setcolor(drawcolor);
           linex:=chx;
           liney:=chy;
           rad:=0;
        end;
        circledrawing:=not(circledrawing);
     end;
     if upcase(ch[1])='T' then begin
        if linedrawing=true then begin
           setwritemode(normalput);
           line(linex,liney,chx,chy);
        end;
        if linedrawing=false then begin
           setwritemode(xorput);
           setcolor(drawcolor);
           linex:=chx;
           liney:=chy;
        end;
        linedrawing:=not(linedrawing);
     end;
     if linedrawing=true then begin
        line(linex,liney,chx-xadd,chy-yadd);
        line(linex,liney,chx,chy);
     end;
     if getdrawing=true then begin
        rectangle(linex,liney,chx-xadd,chy-yadd);
        rectangle(linex,liney,chx,chy);
     end;
     if squaredrawing=true then begin
        rectangle(linex,liney,chx-xadd,chy-yadd);
        rectangle(linex,liney,chx,chy);
     end;
     if circledrawing=true then begin
        rectangle(linex-rad,liney-rad,linex+rad,liney+rad);
        rad:=round(sqrt(sqr(linex-chx)+sqr(liney-chy)));
        rectangle(linex-rad,liney-rad,linex+rad,liney+rad);
     end;

     if upcase(ch[1])='G' then begin
        if getdrawing=true then begin
           setwritemode(normalput);
           rectangle(linex,liney,chx,chy);
        end;
        if getdrawing=false then begin
           setwritemode(xorput);
           setcolor(drawcolor);
           linex:=chx;
           liney:=chy;
        end;
        getdrawing:=not(getdrawing);
     end;
     if upcase(ch[1])='P' then begin
     end;
     if upcase(ch[1])='S' then savepicproc(false);
     if upcase(ch[1])='L' then loadpicproc;

     putimage(chx,chy,crossh^,xorput);

  end;
  xadd:=0;
  yadd:=0;
  until (ch='ÛALT-Q');
  closegraph;
end.