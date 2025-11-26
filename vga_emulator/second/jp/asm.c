#include "asm.h"
#include "zoom.h"

#include "../../vga_emulator/vga_emulator.h"

//code 	SEGMENT para public 'CODE'
//	ASSUME cs:code
//.386
//LOCALS

//PUBLIC _sin1024
//include sin1024.inc

//PUBLIC _setborder
//_setborder PROC FAR

void setborder(int color) {

	inp(0x3da);	/* why? */

	outp(0x3c0,0x11+32);
	outp(0x3c0,color);

//-PUBLIC _setborder
//_setborder PROC FAR
//	push	bp
//	mov	bp,sp
//	mov	dx,3dah
//	in	al,dx
//	mov	dx,3c0h
//	mov	al,11h+32
//	out	dx,al
//	mov	al,[bp+6]
//	out	dx,al
//	pop	bp
//	ret
//_setborder ENDP
}

void inittwk(void) {

	int i;

//PUBLIC _inittwk
//_inittwk PROC FAR
//	push	bp
//	mov	bp,sp
//	push	si
//	push	di
//	push	ds

//	;clear palette
//	mov	dx,3c8h
//	xor	al,al
//	out	dx,al
//	inc	dx
//	mov	cx,768
//@@1:	out	dx,al
//	loop	@@1

	outp(0x3c8,0);
	for(i=0;i<768;i++) {
		outp(0x3c9,0);
	}

//	;400 rows
//	mov	dx,3d4h			; CRTC index register
//	mov	ax,00009h		; maximum scan line
//	out	dx,ax			; port 09 value 00?

	outp(0x3d4,0x09);
	outp(0x3d5,0x00);

//	;tweak
//	mov	dx,3d4h			; CRTC index register
//	mov	ax,00014h		; port 14 value 00?
//	out	dx,ax			; underline location?

	outp(0x3d4,0x14);
	outp(0x3d5,0x00);


//	mov	ax,0e317h		; port 17 value e3? 1110 0011
//	out	dx,ax			; 

	outp(0x3d4,0x17);
	outp(0x3d5,0xe3);

//	mov	dx,3c4h
//	mov	ax,0604h		; port 04 / value 06
//	out	dx,ax

	outp(0x3c4,0x04);
	outp(0x3d5,0x06);

//	;
//	mov	dx,3c4h			; port 02 / value 0f
//	mov	ax,0f02h		; set write mask to 0xf (all 4 planes)
//	out	dx,ax

	outp(0x3c4,0x02);
	outp(0x3d5,0x0f);

	/* clear memory */
	/* this is clearing all four planes */

	for(i=0;i<32768;i++) {
		framebuffer_write(0xa0000+i,0);
	}

//	mov	ax,0a000h		; write 0s to memory
//	mov	es,ax
//	xor	di,di
//	mov	cx,32768
//	xor	ax,ax
//	rep	stosw
//	;
//	pop	ds
//	pop	di
//	pop	si
//	pop	bp
//	ret
//_inittwk ENDP
}

#if 0
void lineblit(void) {
//PUBLIC _lineblit
//_lineblit PROC FAR
//	push	bp
//	mov	bp,sp
//	push	si
//	push	di
//	push	ds
//	mov	di,[bp+6]
//	mov	es,[bp+8]
//	mov	si,[bp+10]
//	mov	ds,[bp+12]
//	zpl=0
//	REPT	4
//	mov	dx,3c4h
//	mov	ax,02h+(100h shl zpl)
//	out	dx,ax
//	zzz=0
//	REPT	80/2
//	mov	al,ds:[si+(zzz+0)*4+zpl]
//	mov	ah,ds:[si+(zzz+1)*4+zpl]
//	mov	es:[di+zzz],ax
//	zzz=zzz+2
//	ENDM
//	zpl=zpl+1
//	ENDM
//	pop	ds
//	pop	di
//	pop	si
//	pop	bp
//	ret
//_lineblit ENDP
}
#endif

void setpalarea(unsigned char *src,int start,int count) {

	int i;

//PUBLIC _setpalarea
//_setpalarea PROC FAR
//	push	bp
//	mov	bp,sp
//	push	si
//	push	di
//	push	ds
//	mov	si,[bp+6]
//	mov	ds,[bp+8]
//	mov	ax,[bp+10]
//	mov	dx,3c8h
//	out	dx,al

	outp(0x3c8,start&0xff);

				//	inc	dx

	/* this is buggy?  should be copying 3*max not 2* ? */
	

//	max=end			//	mov	cx,[bp+12]
//	max<<=1;		//	shl	cx,1
//	max+=start;		//	add	cx,ax

	for(i=0;i<count*3;i++) {
		outp(0x3c9,src[count]);
	}
//	rep	outsb
//	pop	ds
//	pop	di
//	pop	si
//	pop	bp
//	ret
//_setpalarea ENDP
}

//include zoom.inc
void linezoom(int address,unsigned char *row,int c) {
	int bx,ax;
//PUBLIC _linezoom
//_linezoom PROC FAR
				//	push	bp
				//	mov	bp,sp
				//	push	si
				//	push	di
				//	push	ds
				//	les	di,[bp+6]
	/* es:di = address */
				//	lds	si,[bp+10]
	/* ds:si = row */

	/* bx = c */
	bx=c;			//	mov	bx,[bp+14]
	if (bx<=318) goto label1;
				//	cmp	bx,318
				//	jbe	@@1
				//	mov	bx,318
	bx=318;
label1:
	bx=bx&(~1);		//	and	bx,not 1

	/* 0x3c4 is the "Sequencer Address" Register */
	/* this writes 2 to it (Map Mask register at 0x3c5) */
	/* then writes 0xf to 0x3c5 */
	/*    0xf means write to all bit planes (0,1,2,3) */
	/* then points dx to 0x3c5 */

	outp(0x3c4,2);		/* set to map mask register */
	outp(0x3c5,0xf);	/* write to all planes */

	/* ???? */		//	mov dx,3c4h
				//	mov ax,0f02h
				//	out dx,ax
				//	inc dx




	ax=0;			//	xor ax,ax
				//	call	cs:zoomt[bx]
	zoomt(bx,ax,address,row);

					//	pop	ds
					//	pop	di
					//	pop	si
					//	pop	bp
					//	ret
//_linezoom ENDP
}

//code	ENDS
//	END

