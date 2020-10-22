/* Makelev by Vince Weaver */
/* Makes levels for my TMBG game */
/* 13 February 1997 {coincindently my 19th bday} */

#include <stdio.h>

FILE *f;
char file_name[255];
char fill[100];
int wide=20,height=20;
int s_width=20,s_height=20;
int i,j,x,y;
void main (void){
  printf("This makes a large text file of numbers for use in\n");
  printf("Vince Weaver's TMBG game engine.\nThis does minimum error checking so careful.\n\n");
  printf("Enter file name: ");
  scanf("%s",file_name);
  printf("\nEnter number of scenes wide, then scenes high (default 20 20): ");
  scanf("%d %d",&wide,&height); 
  printf("\nEnter width then height of each scene (default 20 20): ");
  scanf("%d %d",&s_width,&s_height);
  fflush(stdin);
   printf("\n Enter value to fill the levels with (default FF): ");
  scanf("%s",fill);
 printf("\n\nGenerating file %s size [%d %d] of [%d %d] filled with %s",
	file_name,wide,height,s_width,s_height,fill);
   f=fopen(file_name,"w");
for(y=0;y<height;y++){
   for(x=0;x<s_height;x++){
   for(i=0;i<wide;i++){
     for(j=0;j<s_width;j++){
	fprintf(f,"%s ",fill);
     }
     fprintf(f,"    ");
  }
  fprintf(f,"\n");
  }
   fprintf(f,"\n");
}
   close(f);

   
   printf("\nDone.\n");
}







