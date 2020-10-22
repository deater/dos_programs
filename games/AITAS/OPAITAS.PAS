program opening_for_AITAS;
uses dos,crt,graph,picload;
var gd,gm,tempint,delaytime:integer;
    ch:char;
    movie:pointer;
    mouthopen:boolean;

{=-=-=-=-=-=-=-=-=Function Getdelay=-=-=-=-=-=-=-=-=}

function getdelay:integer;
var hours,minutes,seconds,hundredths:word;
    zhours,zminutes,zseconds,zhundredths:word;
    tempsec,temphund:integer;
label back;
begin
  back:
    gettime(hours,minutes,seconds,hundredths);
    delay(1000);
    gettime(zhours,zminutes,zseconds,zhundredths);
    tempsec:=abs(zseconds-seconds);
    temphund:=abs(zhundredths-hundredths);
    tempsec:=(tempsec*100)+temphund;
  if tempsec<0 then goto back;
  getdelay:=(1000 DIV tempsec)*80;
end;

{=-=-=-=-=-=-=-=-=-=-=-=-Procedure Pause=-=-=--=-==-=-=-=-=}

procedure pause;
begin
  delay(delaytime div 20);
end;

{=-=-=-=-==-=-=-=-=-=-=-=Procedure Click=-=-=-=-=-=-=-=-=}

procedure click;
begin
  sound(37);
  delay(delaytime div 110);
  nosound;
  if keypressed then exit;
  delay(delaytime div 22);
  if keypressed then exit;
end;

{=-=-=-=-=-=-=-=-=-=-=-=-=Procedure Clickprint=-=-===-=-=--=}

procedure clickprint(x,y:integer;st:string;movemouth:boolean);
var i:integer;
begin

  for i:=1 to length(st) do begin
      click;
      tempint:=getcolor;
      if (movemouth) and(i mod 3=0) then begin
         if mouthopen then begin
            setfillstyle(solidfill,13);
            bar(258,58,266,60);
            setcolor(5);
            line(258,59,266,59);
         end;
         if not(mouthopen) then begin
            setcolor(5);
            line(262,58,266,58);
            line(262,60,266,60);
            setcolor(13);
            line(262,59,266,59);
          end;
          mouthopen:=not(mouthopen);
      end;
      setcolor(tempint);
      outtextxy(x+8*(i-1),y,st[i]);
      if st[i]='.'then pause;
  end;
end;

{=-=-=-==-==-=-=-=Procedure Wait For Keypress=-=-=-=-=-=-=-=}

procedure waitforkeypress;
begin
  if keypressed then ch:=readkey;
  outtextxy(150,180,'Press any Key To Continue, "Q" to Skip');
  repeat until keypressed;
  ch:=readkey;
end;

{=-=-=-=-=-==-=-=-Procedure Do Movie =-=-=-=-=-=-----=-==-}
procedure domovie(moviex,moviey,moviepage,displaypage:integer);
begin
  setactivepage(moviepage);
  getimage(moviex,moviey,moviex+143,moviey+40,movie^);
  setactivepage(displaypage);
  putimage(432,19,movie^,normalput);
end;

{==-=-=-=-=-=--=-=-Main Program=--==-=-=--=-=-=-=-=-==-=-}
begin
  delaytime:=getdelay;
  mouthopen:=false;

  gd:=ega;
  gm:=egalo;
  initgraph(gd,gm,'');
  getmem(movie,imagesize(0,0,142,43));
  loadpicat('Viewscrn.ats',0,0,3);
{-=-=-=-=-=-=-=-=-=-=Scene 1=-=-=-=-=-=-=-=-=-=-=-}
  setvisualpage(0);
  setactivepage(1);
  loadpicat('Sbase.ats',0,0,1);
  setvisualpage(1);
  setcolor(11);
  settextstyle(1,0,1);
  clickprint(10,10,'The Scene:',false);
  pause;
  pause;
  pause;
  clickprint(100,10,'Intergalactic Police Headquarters on the planet Toidi.',false);
  pause;
  pause;
  pause;
  setcolor(9);
  clickprint(10,20,'The Members of The IRS (Intergalactic Reject Soicety) have responded',false);
  clickprint(100,30,'to the frantic requests of the Intergalactic Police.',false);
  pause;
  pause;
  pause;
  setcolor(10);
  clickprint(10,40,'They are currently being briefed on a matter of inter-stellar importance.',false);
  pause;
  pause;
  pause;
  waitforkeypress;
{=-=-=-=-=-=-=-=-=-=-=-=-=-=Scene 2=-=-=-=-=-==-=-=-=-=-=-}
  setactivepage(0);
  loadpicat('Chief.ats',0,0,0);
  putpixel(0,0,0);
  setvisualpage(0);
  setcolor(13);
  clickprint(10,130,'OK, Ecniv, Luap, Ffej.  Valiant Members of the IRS.  Your mission is',true);
  clickprint(10,140,'    to save Princess Isabella Matilda Little of the planet Zorkon.',true);
  pause; pause; pause;
  setcolor(14);
  clickprint(10,150,'Apparently she was kidnapped by an enemy of her father, an act of revenge',true);
  clickprint(10,160,'    stemming from an arguement 30 years ago over a stolen pencil while',true);
  clickprint(10,170,'    they were in 3rd grade.  Here is footage of the kidnapping.',true);
  setcolor(12);
  waitforkeypress;
{=-=-=-=-=-=-=-=-=-=-=-=-=-=Scene 3=-=-=-=-=-==-=-=-=-=-=-}

  setactivepage(1);
    clearviewport;
    loadpicat('Chief.ats',0,0,1);
    putpixel(0,0,0);
    setcolor(13);
  setvisualpage(1);
    domovie(5,4,3,1);    waitforkeypress;
    domovie(156,4,3,1);  waitforkeypress;
    domovie(303,4,3,1);  waitforkeypress;
    domovie(450,4,3,1);  waitforkeypress;
    domovie(5,49,3,1);   waitforkeypress;
    domovie(159,49,3,1); waitforkeypress;
    domovie(302,49,3,1); waitforkeypress;
    domovie(450,49,3,1); waitforkeypress;
    setfillstyle(solidfill,8);
    bar(431,18,575,61);
  setcolor(12);
  waitforkeypress;
{=-=-=-=-=-=-=-=-=-=-=-=-=-=Scene 4=-=-=-=-=-=-=-=-=-==-=-=}
  setactivepage(0);
  clearviewport;
  loadpicat('Guys.ats',0,0,0);
  putpixel(0,0,0);
  setvisualpage(0);
  setcolor(13);
  clickprint(30,10,'Who would do a terrible thing like that?',false);
  setcolor(15);
  waitforkeypress;
{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=Scene 5=-=-=-=-=-=-=-=-=-=-=-=-}
  setactivepage(1);
    loadpicat('Chief.ats',0,0,1);
    putpixel(0,0,0);
    setvisualpage(1);
  setcolor(13);
    clickprint(10,120,'An Evil Villain named General Scram.',true);
    pause; pause; pause;
  setcolor(10);
    clickprint(10,130,'The Princess is believed to be at his base, the Space',true);
    clickprint(10,140,'    Conquest Underwater Military Base (SCUMB for Short)',true);
    pause; pause; pause;
  setcolor(11);
    clickprint(10,150,'It is a dangerous mission.  Two of our best operatives, Admiral',true);
    clickprint(10,160,'    O.J. and her sidekick Jello, met a grim fate there.',true);
    pause; pause; pause;
  setcolor(12);
    clickprint(10,170,'Here is some more footage.',true);
  setcolor(15);
  waitforkeypress;
{=-=-=-=-=-=-=-=-=-=-=-=-=-Scene 6=-=-=-=-=-=-=-=-=-=-}
  setactivepage(0);
    clearviewport;
    loadpicat('Chief.ats',0,0,0);
    putpixel(0,0,0);
    setcolor(13);
  setvisualpage(0);
    domovie(5,94,3,0);    waitforkeypress;
    domovie(159,94,3,0);  waitforkeypress;
    domovie(303,94,3,0);  waitforkeypress;
    domovie(450,94,3,0);  waitforkeypress;
    domovie(5,138,3,0);   waitforkeypress;
    domovie(159,138,3,0); waitforkeypress;
    domovie(304,138,3,0); waitforkeypress;
    domovie(450,138,3,0); waitforkeypress;
  setcolor(11);
    clickprint(10,130,'As You can see, They were turned into what our cheif medical',true);
    clickprint(10,140,'   Officer described as "A Wiggily Substance Not Unlike Orange',true);
    clickprint(10,150,'   gelitin"',true);
    pause; pause; pause;
  setcolor(10);
    clickprint(10,160,'Unfortunately, you are our last resort.  Your mission will be to',true);
    clickprint(10,170,'   go to the SCUMB and rescue the princess.  Do you accept?',true);
  setcolor(12);
  waitforkeypress;

{=-=-=-=-=--=-=-=-= SCENE 7-=-=-=-=-==-=-=-=-=-=}
  setactivepage(1);
  clearviewport;
  loadpicat('Guys.ats',0,0,1);
  putpixel(0,0,1);
  setvisualpage(1);
  setcolor(10);
    clickprint(100,5,'Sure!',false);
  setcolor(12);
    clickprint(250,5,'No Problem!',false);
  setcolor(11);
    clickprint(400,5,'Let''s Go!',false);
  setcolor(15);
  waitforkeypress;

  closegraph;
end.