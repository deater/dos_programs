extern unsigned short stack[4096];
extern unsigned short ax,bx,cx,dx,si,di,bp,cs,ds,es,fs;
extern int cf,of,zf,sf;
extern int sp;

void mul_16(unsigned short value);
void imul_8(char value);
void imul_16(short value);
void imul_16_bx(short value);
void imul_16_dx(short value);
void div_8(unsigned char value);
void idiv_16(signed short value);

void push(int value);
short pop(void);
