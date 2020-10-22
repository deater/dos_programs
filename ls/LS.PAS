program ls;

uses dos;

const months:array[1..12] of string[3]=
      ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

var f:file;
    homedr,sizes,fname:string;
    i:integer;
    dt:searchrec;
    att:byte;
    tempatt:byte;
    diratt,writeatt,execatt,sysatt:boolean;
    ytemp,mtemp,dtemp,wtemp:word;
    tempst:string;
    timel:longint;
    times,ttemp,dates:string;
    dq:datetime;
    tempint:integer;

procedure outputline(dirb,rb,wb,xb,sb:boolean;size,date,time,name:string);
var bigstr:string;
    temp:string;
    i:integer;
    
procedure stradd;
begin
  write(temp);
end;

begin
  bigstr:='';
  if dirb then temp:='d' else temp:='-';
  stradd;
  for i:=1 to 3 do begin
    if rb then temp:='r' else temp:='-';
    stradd;
    if wb then temp:='w' else temp:='-';
    stradd;
    if xb then temp:='x' else temp:='-';
    stradd;
  end;
  if sb=true then
     temp:='    1 root    user'
  else
     temp:='    1 root    sys ';
  stradd;
  for i:=1 to (12-length(size)) do write(' ');
  write(size);
  write(' ',date,' ',time,' ',name);
  writeln;
end;

function checkatt(att2,check:byte):boolean;
var tempatt:byte;
begin
  tempatt:=(att2 and check);
  if tempatt=check then checkatt:=true else checkatt:=false;
end;

begin
 if paramcount<>0 then begin
    homedr:=paramstr(paramcount);
    if ((length(homedr)<3) and (homedr[2]=':')) then begin
       tempint:=ord(homedr[1])-64;
       if tempint>26 then tempint:=tempint-32;
       if tempint>26 then halt(0);
       getdir(tempint,homedr);
       if length(homedr)>3 then homedr:=concat(homedr,'\*.*');
       if length(homedr)<4 then homedr:=concat(homedr,'*.*');
    end;
 end;
 if paramcount=0 then begin
   getdir(0,homedr);
   if length(homedr)>3 then homedr:=concat(homedr,'\');
   homedr:=concat(homedr,'*.*');
 end;
   Findfirst(homedr,AnyFile,dt);
 while doserror=0 do begin
   str(dt.size,sizes);
   execatt:=false;
   att:=(dt.attr);
     if checkatt(att,$10) then begin
        diratt:=true;
        execatt:=true;
     end
     else begin
        diratt:=false;
        execatt:=false;
     end;

     if checkatt(att,$01) then
        writeatt:=false else writeatt:=true;

     if checkatt(att,$04) then
        sysatt:=false else sysatt:=true;

     fname:=dt.name;
   att:=dt.attr;
     if checkatt(att,$02) then
        fname:=concat('.',fname);
   for i:=1 to length(fname) do
       if ((fname[i]>='A') and (fname[i]<='Z'))
          then fname[i]:=chr(ord(fname[i])+32);

   if length(fname)>3 then begin
      tempst:=copy(fname,length(fname)-3,4);
      if ((tempst='.exe') or (tempst='.bat') or (tempst='.com'))
         then execatt:=true;
   end;
    timel:=dt.time;
     times:='';
     unpacktime(timel,dq);
     str(dq.hour,ttemp);
     if length(ttemp)<2 then ttemp:=concat(' ',ttemp);
     times:=concat(times,ttemp);
     str(dq.min,ttemp);
     if length(ttemp)<2 then ttemp:=concat('0',ttemp);
     getdate(ytemp,mtemp,dtemp,wtemp);
     times:=concat(times,':',ttemp);
     if ytemp<>dq.year then begin
        str(dq.year,ttemp);
        times:=concat(' ',ttemp);
     end;
     dates:=months[dq.month];
     str(dq.day,ttemp);
     if length(ttemp)<2 then ttemp:=concat(' ',ttemp);
     dates:=concat(dates,' ',ttemp);

   {attrib searchrec}
   outputline(diratt,true,writeatt,execatt,sysatt,sizes,dates,times,fname);
   findnext(dt);
 end;
   writeln(homedr);
end.