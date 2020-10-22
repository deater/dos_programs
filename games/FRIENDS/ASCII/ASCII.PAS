
{                                                                    }
{                        Why do we cross the road?                   }
{                                  To,                               }
{        **********************************************************  }
{        *                                                        *  }
{        *                   HELP        ASCII                    *  }
{        *                                                        *  }
{        **********************************************************  }
{                                                                    }
{                                                                    }
{               HELP ASCII, a very short game by John Clemens.       }
{                                                                    }
{                                                                    }
{                              Version 1.0                           }
{                                                                    }
{                             Press F5 to play                       }
{                                                                    }
{                                                                     }
uses crt,graph,boxer,picload,dos;
var a,b,c,d,e,f,g,h:pointer;
    x1,x2,y1,y2,x12,y12,x22,y22,x,y,gm,gd,r,i,
    x3,x4,x5,x6,x7,y3,y4,y5,y6,y7,x32,x42,x52,
    x8,y8,x62,x72,y32,y42,y52,y62,y72,l:integer;
    speed1,speed2,speed3,speed4,speed5,speed6:integer;
    starthour,startminute,startsecond,sec100,
    finishhour,finishminute,finishsecond:word;
    temphour,tempminute,tempsecond:integer;
    q:longint;
    tst:string;
    tempchar,zst,rst,nst:char;

{******                ******}
{****** Opening Proced ******}
{******                ******}

procedure opening;
begin
  clrscr; textcolor(9); q:= 20000; r:= 25;
     gotoxy(10,4); writeln('Wie schnell ist dein Computer?');
     textcolor(10); gotoxy(16,6); writeln('1 = IBM XT/Compatible');
     textcolor(11); gotoxy(17,7); writeln('2 = IBM AT/286/Compatible');
     textcolor(12); gotoxy(18,8); writeln('3 = 386 SX');
     textcolor(13); gotoxy(19,9); writeln('4 = 386 DX');
     textcolor(14); gotoxy(20,10);writeln('5 = 486 SX');
     textcolor(15); gotoxy(21,11);writeln('6 = 486 DX/DX2');
     gotoxy(12,15); readln(tst);
       IF tst = '1' THEN q:= 15000;
       IF tst = '2' THEN q:= 17500;
       IF tst = '3' THEN q:= q;
       IF tst = '4' THEN begin q:= 30000; r:= 18; end;
       IF tst = '5' THEN begin q:= 50000; r:= 15; end;
       IF tst = '6' THEN begin
           gotoxy(17,20); writeln('TURN OFF YOUR TURBO BUTTON!!!!');
           q:= 50000; r:= 15;
           end;
       for i:=1 to q do begin end;
end;

{*****Bars*****}
procedure bars(xx,yy,xxx,yyy,co:integer);
begin
  setfillstyle(1,co);
  bar(xx,yy,xxx,yyy);
end;
{********************}
procedure drawlines(x,y:integer);
begin
   FOR i:= 1 TO 20 do begin
       setfillstyle(solidfill,7);
       bar(x, y,x + 30, y + 5); x:= x + 60;
    end;
end;


{********Mincemeat*****}
procedure mincemeat;
var j:integer;
begin
  for j:=1 to 3 do begin sound(200); delay(200); nosound; delay(10); end;
  y7:= 325; PUTimage(x72, y72, g^, XORput);
  PUTimage(x7, y7, g^, XORput); x72:= x7; y72:= y7;
end;
{***** XS *******}
procedure xs;
begin
  IF (x8>=x1) AND (x8<=x1+60) AND (y8>=y1) AND (y8<=y1+20) THEN mincemeat;
  IF (x8>=x2) AND (x8<=x2+40) AND (y8>=y2) AND (y8<=y2+20) THEN mincemeat;
  IF (x8>=x3) AND (x8<=x3+50) AND (y8>=y3) AND (y8<=y3+20) THEN mincemeat;
  IF (x8>=x4) AND (x8<=x4+40) AND (y8>=y4) AND (y8<=y4+20) THEN mincemeat;
  IF (x8>=x5) AND (x8<=x5+60) AND (y8>=y5) AND (y8<=y5+20) THEN mincemeat;
  IF (x8>=x6) AND (x8<=x6+40) AND (y8>=y6) AND (y8<=y6+20) THEN mincemeat;
end;

{***** OPtio ********}
procedure optio;
begin
  CLrScr; textCOLOR(9);
  gotoxy(29,15); writeln('Ha, da ist keine Wahl!');
  readln(tst);
end;

{***** About *******}
procedure about;
  begin
    CLrScr; textCOLOR(14);
    gotoxy(1,13);
    writeln('                           berquert die Strasse');
    writeln;
    writeln('  Graphische Hilfe :        bei: John Clemens       Programm Hilfe :');
    writeln; writeln;
    writeln('     Jeff Warwick          (Wer hat viele Stunden   Vincent Weaver');
    writeln('                            gearbeitet so du musst,');
    writeln('                            hat es gern.');
    writeln('                                    ');
    repeat until keypressed; nst:=readkey;
end;

{***** Instruct******}
procedure inst;
begin
  CLrscr;
  putstring(30,2,14,'INSTRUKTIONEN');
  putstring(7,5,13,'Diese Spiel ist ganz einfach.  Du musst ASCII gegen die Straแe ');
  writeln('   berquerten.  Bevor du bist fertig du musst hilft Ascii mit');
  writeln('   drei Autobahnen er musst berquert zu gehen nach hause.  Dein');
  writeln('   Nummerlock sollt ON sein, so spiel mit der nummerisches keypad.');
  writeln('   Mit dem "8" Taste, ASCII geht aufwrds. Mit dem "2" Taste Ascii');
  writeln('   geht zuruck. Macht schnell.... die schneller die Besser.');
  writeln('   Viel Spaแ!');
  writeln;
  writeln('     ACHTUNG!  Was folgest ist wichtig!');
  textCOLOR(11);
  writeln;
  writeln('        8 = ASCII geht vorder');
  writeln('        2 = ASCII geht back:not fast');
  writeln('        ํ = ASCII');
  writeln('      Die Schlge  = Autos, Wagens');
  textCOLOR(9);
  writeln; writeln('                      <Druckt ein Taste>');
  repeat until keypressed;
  nst:=readkey;
end;
{*****          *****}
{***** Title Sc *****}
{*****          *****}
procedure titlescreen;
var gd,gm:integer;
begin
  gd:=3; gm:=1;
  initgraph(gd,gm,'');
  setfillstyle(1,8); bar(0, 0,640, 350);
  directvideo:=false; textCOLOR(4);
  gotoxy(15,4); writeln('ษออออออออออออออออออออออออออออออออออออออออออออออป');
  gotoxy(15,5); write  ('บ   ');
    textcolor(10); write('Hilft Ascii Agent #237 Retten Agent #235');
    textcolor(4); writeln('   บ');
    gotoxy(15,6); writeln('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
  loadpicat('car5.shp',76,120,0);
  loadpicat('car6.shp',198,120,0);
  loadpicat('Car7.shp',320,120,0);
  loadpicat('Car8.shp',442,120,0);
  putstring(28,17,9,'Macht bei John Clemens');
  putstring(21,19,12,'Verbessert und erste Deutsch version bei');
  putstring(31,20,13,'Vincent M. Weaver');
  gotoxy(1,23); writeln('Druckt ein Taste....');
  repeat until keypressed; zst:=readkey;
end;
{*****************}
{******Menu*******}
{*****************}
procedure menu;
label 10;
begin
  restorecrtmode;
  l:=0;
10:
  zst:=' ';
  cLrscr;
  putstring(15,4,13,'   ÛÛ      ÛÛ      ÛÛ      ÛÛ     ÛÛ      ÛÛ');
  putstring(15,5,13,'   ÛÛÛÛ  ÛÛÛÛ    ÛÛ  ÛÛ    ÛÛ     ÛÛÛÛ    ÛÛ');
  putstring(15,6,13,'   ÛÛ  ÛÛ  ÛÛ   ÛÛ    ÛÛ   ÛÛ     ÛÛ  ÛÛ  ÛÛ');
  putstring(15,7,13,'   ÛÛ      ÛÛ   ÛÛÛÛÛÛÛÛ   ÛÛ     ÛÛ    ÛÛÛÛ');
  putstring(15,8,13,'   ÛÛ      ÛÛ   ÛÛ    ÛÛ   ÛÛ     ÛÛ      ÛÛ');
  putstring(12,11,13,'     ษอออออออออออออออออออออออออออออออออออออออออป');
  putstring(12,12,13,'     บ             MAIN      MENU              บ');
  gotoxy(12,13);   write('     บ  ');
    textCOLOR(14); write('1 = ');
    textCOLOR(9 ); write('   SPIEL');
    textcolor(13); writeln('                           บ');
  gotoxy(12,14);   write('     บ  ');
    textCOLOR(14); write('2 = ');
    textCOLOR(9 ); write('   LIES DIE INSTRUKTIONEN');
    textCOLOR(13); writeln('          บ');
  gotoxy(12,15);   write('     บ  ');
    textCOLOR(14); write('3 = ');
    textCOLOR(9 ); write('   SPIELWAHLEN');
    textCOLOR(13); writeln('                     บ');
  gotoxy(12,16);   write('     บ  ');
    textcolor(14); write('4 = ');
    textCOLOR(9 ); write('   BER HILFT ASCII           ');
    textCOLOR(13); writeln('     บ');
  gotoxy(12,17);   write('     บ  ');
    textCOLOR(14); write('5 = ');
    textcOLOR( 9); write('   BEENDEN');
    textCOLOR(13); writeln('                         บ');
  putstring(12,18,13,'     ศอออออออออออออออออออออออออออออออออออออออออผ');
  gotoxy(25,21);write('Was machst du jetzt? ');
  readln(zst);
    IF zst = '2' THEN inst;
    IF zst = '3' THEN optio;
    IF zst = '4' THEN about;
    IF zst='5' then halt;
    if (zst='2') or (zst=chr(13)) then goto 10;
    if (zst='3') or (zst=chr(13)) then goto 10;
    if (zst='4') or (zst=chr(13)) then goto 10;
end;
{****** Finish ******}
procedure finish;
var hsfile:text;
    yourname:string;
    j,place:integer;
    scores:array[1..5] of integer;
    names :array[1..5] of string[7];

begin
  restorecrtmode;
  textCOLOR(4);
  gettime(finishhour,finishminute,finishsecond,sec100);
  tempsecond:=finishsecond-startsecond;
  if tempsecond<0 then begin
     finishminute:=finishminute-1;
     finishsecond:=finishsecond+60;
     tempsecond:=finishsecond-startsecond;
  end;
  tempminute:=finishminute-startminute;
  if tempminute<0 then begin
     finishhour:=finishhour-1;
     finishminute:=finishminute+60;
     tempminute:=tempminute-startminute;
  end;
  temphour:=finishhour-starthour;
  if starthour<0 then begin
     temphour:=(24-starthour)+finishhour;
  end;
  tempsecond:=tempsecond+(tempminute*60)+((temphour*60)*60);
  gotoxy(30,15);writeln(' YOUR TIME WAS: ',tempsecond,'sec.');
  readln;
   assign(hsfile,'hs.atc');
   reset(hsfile);
   for i:=1 to 5 do readln(hsfile,names[i]);
   for i:=1 to 5 do readln(hsfile,scores[i]);
   close(hsfile);
   if tempsecond<scores[5] then begin
      for i:=5 downto 1 do if tempsecond<scores[i] then place:=i;
      writeln('You have made the highscore list in ',place,' place');
      repeat
        write('Enter your name, up to 7 characters ');
        readln(yourname);
      until length(yourname)<8;
      for i:=4 downto place do names[i+1]:=names[i];
      names[place]:=yourname;
      for i:=4 downto place do scores[i+1]:=scores[i];
      scores[place]:=tempsecond;
      assign(hsfile,'hs.atc');
      rewrite(hsfile);
      for i:=1 to 5 do writeln(hsfile,names[i]);
      for i:=1 to 5 do writeln(hsfile,scores[i]);
      close(hsfile);
   end;
  clrscr;
   textCOLOR(9);
   gotoxy(33,2); writeln('BEST TIMES');
   for i:=1 to 5 do begin
     gotoxy(25,2+2*i);
     textcolor(15-i);
     write(i,'.     ',names[i]);
     for j:=1 to (14-length(names[i])) do write(' ');
     writeln('=    ',scores[i],'sec.');
   end;


  readln;
end;
{****** Game *******}
procedure game;
begin
  gm:=ega; gd:=egahi; initgraph(gm,gd,'');
  setfillstyle(1,8); bar(0, 0,640, 350);
  setfillstyle(1,15);bar(0, 320,640, 350);
  setfillstyle(1,14);bar(0, 167,640, 163); bar(0, 158,640, 153);
  drawlines(0,267);
  drawlines(0,215);
  drawlines(0,100);
  drawlines(0,49);
{****cars****}
  bars(1, 1,40, 20,4); a:=GET (1, 1,40, 20,a); PUTimage(0, 286, a^, XORput);
  bars(0, 0,40, 20,8);
  bars(1, 1,50, 20,1); bars(51, 3,60, 17, 10);
  b:=GET (1, 1,60, 20, b); PUTimage (0, 234, b^, XORput);
  bars(1, 1,60, 20, 8); bars(1, 1,40, 20, 5);
  c:=GET (1, 1,40, 20, c); PUTimage(0, 181, c^, XORput);
  bars(1, 1,40, 20, 8); bars(1, 1,50, 20,11);
  d:=GET (1, 1,50, 20,d); PUTimage (590, 119, d^, XORput);
  bars(1, 1,50, 20, 8); bars(1, 1,40, 20, 9);
  e:=GET (1, 1,40, 20, e); PUTimage (600, 68, e^, XORput);
  bars(1, 1,40, 20, 8); bars(10, 1,60, 20, 15); bars(1, 3,9, 18, 12);
  f:=GET (1, 1,60, 20, f); bars(1, 1,60, 20, 8); PUTimage (580, 14, f^, XORput);
{*****you*****}
  gotoxy(2,1); writeln('ํ'); g:=GET (8, 1,15, 10, g); PUTimage (316, 325,g^,XORput);
  bars(0, 0,16, 13,8);
{** now, to get the cars to move**}
  x1:= 580; y1:= 14; x12:= 580; y12:= 14;
  x2:= 600; y2:= 68; x22:= 600; y22:= 68;
  x3:= 590; y3:= 119; x32:= 590; y32:= 119;
  x4:= 0; y4:= 181; x42:= 0; y42:= 181;
  x5:= 0; y5:= 234; x52:= 0; y52:= 234;
  x6:= 0; y6:= 286; x62:= 0; y62:= 286;
  x7:= 316; y7:= 325; x72:= 316; y72:= 325;
  rst:=' '; nst:=' ';
  speed1:=trunc(random*8)+12;
  speed2:=speed1+4;
  speed3:=speed1+2;
  speed4:=trunc(random*8)+12;
  speed5:=speed4-1;
  speed6:=speed4+3;

  gettime(starthour,startminute,startsecond,sec100);
repeat;
  x1:= x1 - speed1-l;
  x2:= x2 - speed2-l;
  x3:= x3 - speed3-l;
  x4:= x4 + speed4+1;
  x5:= x5 + speed5+1;
  x6:= x6 + speed6+1;
   IF x1 < 1 THEN x1:= 580;
   IF x2 < 1 THEN x2:= 600;
   IF x3 < 1 THEN x3:= 590;
   IF x4 > 600 THEN x4:= 0;
   IF x5 > 580 THEN x5:= 0;
   IF x6 > 600 THEN x6:= 0;
   PUTimage(x12, y12, f^, XORput); PUTimage(x1,y1,f^,XORput);
     x12:= x1; y12:= y1;
   PUTimage(x22, y22, e^, XORput); PUTimage(x2,y2,e^,XORput);
     x22:= x2; y22:= y2;
   PUTimage(x32, y32, d^, XORput); PUTimage(x3,y3,d^,XORput);
     x32:= x3; y32:= y3;
   PUTimage(x42, y42, c^, XORput); PUTimage(x4,y4,c^,XORput);
     x42:= x4; y42:= y4;
   PUTimage(x52, y52, b^, XORput); PUTimage(x5,y5,b^,XORput);
     x52:= x5; y52:= y5;
   putimage(x62, y62, a^, XORput); PUTimage(x6,y6,a^,XORput);
     x62:= x6; y62:= y6;
   sound(523); delay(1); nosound;
if keypressed then begin
  rst:= readkey;
  if upcase(rst)='P' then begin
     repeat until keypressed;
     tempchar:=readkey;
  end;
  IF rst= CHR(0) THEN nst:= readkey;
  IF (nst = '8') OR (rst = '8') THEN y7:= y7 - 5;
  IF y7 < 1 THEN begin y7:= 325; inc(l); end;
  IF (nst ='2') or (rst = '2') THEN begin y7:= y7 + 5; IF y7 > 340 THEN y7:= 340; end;
  PUTimage(x72, y72, g^, XORput);
  PUTimage(x7, y7, g^, XORput);
  x72:= x7; y72:= y7;
end;
 IF (x7>=x1) AND (x7<=x1+60) AND (y7>=y1) AND (y7<=y1+20) THEN mincemeat;
 IF (x7>=x2) AND (x7<=x2+40) AND (y7>=y2) AND (y7<=y2+20) THEN mincemeat;
 IF (x7>=x3) AND (x7<=x3+50) AND (y7>=y3) AND (y7<=y3+20) THEN mincemeat;
 IF (x7>=x4) AND (x7<=x4+40) AND (y7>=y4) AND (y7<=y4+20) THEN mincemeat;
 IF (x7>=x5) AND (x7<=x5+60) AND (y7>=y5) AND (y7<=y5+20) THEN mincemeat;
 IF (x7>=x6) AND (x7<=x6+40) AND (y7>=y6) AND (y7<=y6+20) THEN mincemeat;
 x8:= x7 + 8; y8:= y7; xs;
 x8:= x7 + 8; y8:= y7 + 10;  xs;
 x8:= x7; y8:= y7 + 10; xs;
until (upcase(rst)='Q') or (l>1);

end;

begin
  opening;
  titlescreen;
  repeat;
  menu;
  game;
  if l>1 then finish;
  until 5=0;
  closegraph;
end.















