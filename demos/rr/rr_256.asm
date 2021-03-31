; rr

; roughly based on a PCbot twitter Qbasic program

; by Vince `deater` Weaver <vince@deater.net>
;	size optimization by Hellmood

;	--== Desire ==--


; 281 bytes -- my version
; 256 bytes -- hellmood re-write

org 100h

	;==========================
	; setup graphics

;	mov	ax,0013h

	mov	al,13h		; set mode13h 320x200x256 mode
	int	10h

;	mov	bx,0A000h
;	mov	es,bx
	les	bx,[bx]		; trick to get es to roughly $a000

	;==========================
	; draw rick

;	xor	di,di
	mov	si,boxes_data
	call	draw_box

;	mov	al,3Fh
;	mov	dx,0331h
;	out	dx,al
;	dec	dx
	mov	dx,0x330

	;==========================
	; play music

	; it's accepted to assume UART mode
	; has to be set in the dosbox config

	mov	si,music_sequence
music_loop:
	mov	al,90h
	out	dx,al
	mov	cl,08h
	lodsb
	or	al,al
	jz	exit
	js	ong
	sar	cx,01h
ong:
	cmp	al,01h
	jnz	nohands
	xor	bp,bp
	cmp	si,word second
	jle	blah
	sub	bp,byte 10h
blah:
;	push	si
;	push	dx
	pusha
;	mov	si,arm_down
;	add	si,bp
	lea	si,[bp+arm_down]

	call	draw_box
;	pop	dx
;	pop	si
	popa
	jmp	short music_loop
nohands:
	and	al,7Fh
	out	dx,al
	mov	al,67h
	out	dx,al
;	mov	ah,86h
;	int	15h
;	mov cl,6
waiter:
	hlt
	loop	waiter

	jmp	short music_loop


	;================================
	; Draw Box
	;================================
	; input in si
	; y is in di.   yend in dx
	; color in AX
	; saved width in bp->cx
	; bx = add to next line




draw_box:
;	xor	ax,ax
	lodsb
	cmp	al,80h
	jz	short done_boxes
	add	al,34h
;	mov	dx,0140h
;	imul	dx
	imul	ax,0x140

	mov	di,ax
	lodsb
	mov	dl,al
	xor	ax,ax
	lodsb
;	add	di,ax
;	add	di,byte 70h
	add	al,0x70
	add	di,ax
	lodsb
	mov	bp,ax
	mov	bx,0140h
	sub	bx,bp
	lodsb
box_loop:
	mov	cx,bp
	rep	stosb
	add	di,bx
	dec	dl
	jnz	short box_loop
	jmp	short draw_box



	;================================
	; Exit
	;================================
done_boxes:
exit:

	ret		; re-use ret

;	xor	al,al
;	mov	ah,4Ch
;	int	21h

data:

boxes_data:
;	y1	ylen	x1	xlen	color
db	0,	95,	0,	95,	80	; 0 background
db	39,	56,	39,	19,	23	; 1 grey lower
db	39,	22,	17,	22,	19	; 2 left dgrey
db	39,	31,	53,	10,	19	; 3 right dgrey
db	48,	13,	15,	20,	18	; 4 l green
db	70,	25,	23,	36,	18	; 5 l green bottom
db	53,	17,	53,	7,	18	; 6 l green
db	26,	13,	38,	8,	64	; 7 neck
db	15,	19,	42,	10,	87	; 8 face
db	9,	6,	39,	15,	6	; 9 hair
db	12,	16,	33,	9,	6	; 10 hair
db	47,	48,	50,	3,	24	; 11 mic
db	35,	11,	47,	7,	24	; 12 mic
db	24,	4,	51,	3,	87	; 13 nose
db	61,	15,	11,	28,	17	; 14 l arm
db	60,	10,	39,	10,	64	; 15 l hand
arm_up:
db	60,	21,	63,	12,	80	; 16 erase r arm up
db	70,	12,	59,	15,	17	; 17 r arm
db	73,	8,	73,	12,	64	; 18 r hand
db	128
arm_down:
db	70,	15,	62,	26,	80	; 19 erase r arm down
db	70,	12,	62,	10,	17	; 20 r arm up
db	60,	10,	63,	8,	64	; 21 r hand up
db	128

PAUSE:		equ 1
NSHORT:		equ 0
NLONG:		equ 128
END:		equ 0

; midi notes
NOTE_A3:	equ 57
NOTE_B3:	equ 59
NOTE_CSHARP4:	equ 61
NOTE_D4:	equ 62
NOTE_E4:	equ 64
NOTE_FSHARP4:	equ 66

music_sequence:
first:
	db   NSHORT|NOTE_A3, NSHORT|NOTE_B3, NSHORT|NOTE_D4, NSHORT|NOTE_B3
	db   NLONG|NOTE_FSHARP4, NLONG|NOTE_FSHARP4, NLONG|NOTE_E4,  PAUSE
second:
	db   NSHORT|NOTE_A3, NSHORT|NOTE_B3, NSHORT|NOTE_D4, NSHORT|NOTE_B3
	db   NLONG|NOTE_E4, NLONG|NOTE_E4, NSHORT|NOTE_D4, NSHORT|NOTE_CSHARP4
	db   NLONG|NOTE_B3,   PAUSE
third:
	db   NSHORT|NOTE_A3, NSHORT|NOTE_B3, NSHORT|NOTE_D4, NSHORT|NOTE_B3
	db   NLONG|NOTE_D4, NSHORT|NOTE_E4, NLONG|NOTE_CSHARP4, NSHORT|NOTE_A3
	db   NSHORT|NOTE_A3, NLONG|NOTE_E4, NLONG|NOTE_D4, END
