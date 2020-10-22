program UnderWaterTrouble (input,output);
uses graph,boxer,crt,subs2;
label gop;
const
  iota:fillpatterntype=($10,$10,$10,$ff,$10,$10,$10,$10);
var getit:char;
    dx,dy,col,gmode,gval:integer;
    reginf,instr:text;
    st:string;
procedure menu;
begin
  textmode (co40);
  clrscr;
  textcolor(4);
  boxes(9,10,29,16);
  putstring(6,3,9,'І І');
  putstring(6,4,9,'І І');
  putstring(6,5,9,'І І');
  putstring(6,6,9,'ІІІ');
  putstring(9,6,9,'nder');
  putstring(14,3,9,'±   ±');
  putstring(14,4,9,'±   ±');
  putstring(14,5,9,'± ± ±');
  putstring(14,6,9,'±± ±±');
  putstring(19,6,9,'ater');
  putstring(24,3,9,'°°°');
  putstring(25,4,9,'°');
  putstring(25,5,9,'°');
  putstring(25,6,9,'°');
  putstring(26,6,1,'rouble');
  putstring(32,3,4,'By Ы Ы');
  putstring(35,4,4,'Ы Ы');
  putstring(36,5,4,'Ы');
  putstring(36,6,4,'i');
  putstring(36,7,4,'n');
  putstring(36,8,4,'c');
  putstring(36,9,4,'e');
  putstring(36,10,4,'n');
  putstring(36,11,4,'t');
  putstring(34,13,2,'Ы   Ы');
  putstring(34,14,2,'Ы Ы Ы');
  putstring(34,15,2,'ЫЫ ЫЫ');
  putstring(36,16,2,'e');
  putstring(36,17,2,'a');
  putstring(36,18,2,'v');
  putstring(36,19,2,'e');
  putstring(36,20,2,'r');
  putstring(7,12,9,'O');
  putstring(7,13,9,'o');
  putstring(7,14,9,'ш');
  textbackground(3);
  putstring(2,14,0,'\Ы “');
  putstring(2,15,0,'-   <');
  putstring(2,16,0,'/Ы  ');
  textbackground(0);
  putstring(12,18,5,'ЫЫЫ ЫЫЫ ЫЫЫ ЫЫЫ');
  putstring(12,19,5,' Ы  Ы Ы  Ы  Ы Ы');
  putstring(12,20,5,' Ы  Ы Ы  Ы  ЫЫЫ');
  putstring(12,21,5,'ЫЫЫ ЫЫЫ  Ы  Ы Ы');
  putstring(11,23,5,'S h a r e w a r e');
{end}
  putstring(10,11,14,'1.Begin New Game');
  putstring(10,12,14,'2.Instructions');
  putstring(10,13,14,'3.Other Options');
  putstring(10,14,14,'4.Registering Info');
  gotoxy(10,15);
  textcolor(2);
  readln(getit);
  if (getit='2')or(getit='4') then begin
    gmode:=ega;
    gval:=egalo;
    initgraph(gmode,gval,'');
    cleardevice;
    setfillpattern(iota,1);
    bar(0,0,640,200);
    setfillstyle(solidfill,5);
  end;
  if getit='2' then begin
    assign(instr,'inst.uwt');
    reset(instr);
    repeat
      readln(instr,dx,dy,col,st);
      settextstyle(0,0,1);
      setcolor(col);
      outtextxy(dx,dy,st);
      until seekeof(instr);
    readln;
    end;
  if getit='4' then begin
    assign(reginf,'ri.uwt');
    reset (reginf);
    repeat
      readln(reginf,dx,dy,col,st);
      settextstyle(0,0,1);
      setcolor(col);
      outtextxy(dx,dy,st);
    until seekeof(reginf);
    readln;
  end;
  if getit='3' then begin
    clrscr;
    writeln('these are not available yet: Fishes, Computer');
    readln;
  end;
end;
begin
gop:
  menu;
  if (getit<>'1') and(getit<>'Q') and (Getit<>'q')then goto gop;
  numon(0,1);
  if (getit<>'Q') and (getit<>'q') then uwt(0,0,0,0);
  numon(1,0);
  textmode(co80);
end.