//function Mode13LoadPicPacked(x1,y1:integer;where:word;LoadPal,LoadPic:boolean;FileName:string):byte;
//
//{*Loads a paintpro image, filename, at location x1,y1
//  to offset where (vga=$A000) and loadspal if LOADPAL=true
//  Loadsapicture if Loadpic=true and returns error}
//
//  Converted to Java by vince weaver weave@glue.umd.edu
//

import java.applet.Applet;
import java.awt.*;
import java.lang.*;
import java.net.*;
import java.io.*;

public class Loadpic extends Frame {

    int palr[];
    int palg[];
    int palb[];
    byte[] buffer;
    int result,buffpointer,int1,int2;
    FileInputStream f;
    int col,x,y,xsize,ysize,i,oldcol;
    int numcolors,tempint1,tempint2,numacross;
    String header;
    boolean lastread;
    byte tempbyte,Mode13LoadPicPacked;




public void sixbytes2twoint() 
{
    short temp1,temp2,temp3;

  temp1=this.buffer[buffpointer];
  temp2=buffer[buffpointer+1];
  temp3=buffer[buffpointer+2];
  buffpointer++; buffpointer++; buffpointer++;
  if (buffpointer>=result) {
     if (result==300) {
          try {result=f.read(buffer);}
          catch (IOException e){}
          buffpointer=0;
      }
      else {lastread=true;}
    }
      int i1,i2,i3;
      if (temp1<0){i1=256+temp1;} 
         else{i1=temp1;}
      if (temp2<0) {i2=256+temp2;} 
         else{i2=temp2;}
      if (temp3<0) {i3=256+temp3;} 
         else{i3=temp3;}
      int1=(i2/16)+(i1*16);
      int2=((i2-((i2/16)*16))*256)+i3;

 // asm
 //             {splits 3 bytes (24 bits)}
 //             {into two 12 bit integers}
 //             {and then pads them into}
 //             {two 16 bit integers}

}

public int byte2int(byte bb) {
int i3;
if (bb<0) {i3=256+bb;} 
         else{i3=bb;}
return bb;
}


public Loadpic()  {
   buffer=new byte[300]; 
   lastread=false;
   Mode13LoadPicPacked=0;     //{*Clear errors}
   header="";
   buffpointer=0;
   File fp=new File(".","tbgorg.tb1");
   try {f=new FileInputStream(fp);  
   }
   catch (FileNotFoundException e) {}
   //Canvas canvas;
   //add(canvas);
   //setLayout(null);
   //Image b;
   //b=createImage(100,100);
   //Graphics gg;
   //gg=g.getGraphics();
   //paint(g);
   //gg.drawLine(0,0,10,10);

//if IOresult<>0 then begin       {*Error if not}
  //   Mode13LoadPicPacked:=1;
  //end
  //else begin

  try {result=f.read(buffer);}
  catch (IOException e){}

  char[] headch;
  headch=new char[12];
  for(i=1; i<13; i++) {headch[i-1]=(char)buffer[i-1];}
  header=new String(headch,0,9);
  System.out.println(header);


  //if header<> 'PAINTPROV' then Mode13LoadPicPacked:=2;
  //if header<> 'PAINTPROV' then exit;    {*Error if not Paintpro header}

  //header:='';

  header=new String(headch,9,3);
  System.out.println(header);


  //if header<>'6.0' then Mode13LoadPicPacked:=3;   {*Error if wron version}
  //if header<>'6.0' then exit;
  
  buffpointer=12;
  sixbytes2twoint();
  
  xsize=int1;
  ysize=int2;
  System.out.println(int1);
  System.out.println(int2);
  sixbytes2twoint();
  System.out.println(int1);
  System.out.println(int2);
  numcolors=int1;
  palr=new int[256];
  palg=new int[256];
  palb=new int[256];
  for (i=0; i<numcolors; i++) { 
      palr[i]=(byte2int(buffer[buffpointer]));
      palg[i]=(byte2int(buffer[buffpointer+1]));
      palb[i]=(byte2int(buffer[buffpointer+2]));
      buffpointer++; buffpointer++; buffpointer++;
      if (buffpointer>=result) {
         if (result==300) {
              try {result=f.read(buffer);}
              catch (IOException e){}
            buffpointer=0;
         }
         else
         {lastread=true;}
       }
  //if loadpal then pal(i,r,g,b);
  }

  x=0;  //offset
  y=0;
  //if loadpic=true then begin
  i=0;
  while (lastread==false) {
        sixbytes2twoint();

        if (int1>2047)  {
           i=tempint1-2048;
   //        g.setColor(new Color(palr[i],palg[i],palb[i]));
   //        g.drawLine(x,y,x,y);
           x++;
  //       if x>=xsize+x1+1 then begin
  //          x:=x1; inc(y); end;
  //       putpixel(x,y,(tempint2-2048),where);
  //       inc(x);
 //        if x>=xsize+x1+1 then begin
  //          x:=x1; inc(y); end;
  //    end
  //    else begin
  //        col:=tempint1;
  //        numacross:=tempint2;
  //   while ((x+numacross)>=(xsize+x1+1)) do begin
  //         horizontalline(x,x1+xsize,y,col,where);
  //         numacross:=numacross-((xsize+1)-x);
  //         x:=x1;
  //         inc(y);
 //    end;
 //    if numacross<>0 then horizontalline(x,x+numacross,y,col,where);
 //      x:=x+numacross;
//   end;
 }
}
//close(f);
}

public void paint(Graphics g)
{
   g.drawLine(0,0,10,10);
}


public static void main(String args[])
{
  Frame f=new Loadpic();
  f.resize(200,100);
  Graphics g;
  g=f.getGraphics();
  g.drawLine(0,0,100,100);
  f.show();
  
  //app.init("tbgorg.tb1",f);
  //app.show();  
}


}




