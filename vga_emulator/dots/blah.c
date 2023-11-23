#include <stdio.h>


int main(int argc, char **argv) {

	short ax;
	unsigned short q;

	ax=-1;
	printf("AX=%hx\n",ax);

	ax=5;
	printf("5 AX=%hx\n",ax);
	ax=-ax;
	printf("-5 AX=%hx\n",ax);
	ax=-ax;
	printf("5 AX=%hx\n",ax);

	ax=-1;
	ax=ax>>4;
	printf("AX=%hx\n",ax);

	ax=0xdead;
	ax=ax>>4;
	printf("AX=%hx\n",ax);

	//

	q=-1;
	printf("Q=%hx\n",q);

	q=5;
	printf("5 Q=%hx\n",q);
	q=-q;
	printf("-5 Q=%hx\n",q);
	q=-q;
	printf("5 Q=%hx\n",q);

	q=-1;
	q=q>>4;
	printf("Q=%hx\n",q);

	q=0xdead;
	q=q>>4;
	printf("Q=%hx\n",q);


	ax=0xdead;
	if (ax<0) printf("%d (%hx) is less than 0\n",ax,ax);
	if (ax>0) printf("%d (%hx) is greater than 0\n",ax,ax);

	q=0xdead;
	if (q<0) printf("%d (%hx) is less than 0\n",q,q);
	if (q>0) printf("%d (%hx) is greater than 0\n",q,q);


	return 0;

}
