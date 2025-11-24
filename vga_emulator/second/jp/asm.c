#include "asm.h"

//code 	SEGMENT para public 'CODE'
//	ASSUME cs:code
//.386
//LOCALS

//PUBLIC _sin1024
//include sin1024.inc

//PUBLIC _setborder
//_setborder PROC FAR

void setborder(int color) {
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

//	;400 rows
//	mov	dx,3d4h			; CRTC index register
//	mov	ax,00009h		; maximum scan line
//	out	dx,ax			; port 09 value 00?



//	;tweak
//	mov	dx,3d4h			; CRTC index register
//	mov	ax,00014h		; port 14 value 00?
//	out	dx,ax			; underline location?

//	mov	ax,0e317h		; port 17 value e3? 1110 0011
//	out	dx,ax			; 

//	mov	dx,3c4h
//	mov	ax,0604h		; port 04 / value 06
//	out	dx,ax
//	;
//	mov	dx,3c4h			; port 02/value 0f
//	mov	ax,0f02h
//	out	dx,ax


/* clear memory */
/* possibly this is needed as the original mode13h call only cleared */
/* the one half */

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

void setpalarea(unsigned char *p,int a, int b) {
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
//	inc	dx
//	mov	cx,[bp+12]
//	shl	cx,1
//	add	cx,ax
//	rep	outsb
//	pop	ds
//	pop	di
//	pop	si
//	pop	bp
//	ret
//_setpalarea ENDP
}

//include zoom.inc
void linezoom(char *a,char *b,int c) {
//PUBLIC _linezoom
//_linezoom PROC FAR
//	push	bp
//	mov	bp,sp
//	push	si
//	push	di
//	push	ds
//	les	di,[bp+6]
//	lds	si,[bp+10]
//	mov	bx,[bp+14]
//	cmp	bx,318
//	jbe	@@1
//	mov	bx,318
//@@1:	and	bx,not 1
//	mov dx,3c4h
//	mov ax,0f02h
//	out dx,ax
//	inc dx
//	xor ax,ax
//	call	cs:zoomt[bx]
//	pop	ds
//	pop	di
//	pop	si
//	pop	bp
//	ret
//_linezoom ENDP
}

//code	ENDS
//	END

