; rr

; roughly based on a PCbot twitter Qbasic program

; by Vince `deater` Weaver <vince@deater.net>
;	size optimization by Hellmood

;	--== Desire ==--


; 281 bytes -- my version
; 256 bytes -- hellmood re-write
; 247 bytes -- have box lookup first entry be pre-computed 16-bit address
; 253 bytes -- add ESC check

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
	mov	si,boxes_data	; point to the data
	call	draw_box




	;==========================
	; play music

	; it's accepted to assume UART mode
	; has to be set in the dosbox config

;	mov	al,3Fh
;	mov	dx,0331h
;	out	dx,al
;	dec	dx

	mov	dx,0x330

	mov	si,music_sequence
music_loop:

	in	al,60h		; read whatever is at keyboard port; looking for ESC which is #1
	dec	al		; if ESC, AX now 0
	jz	exit		; fall through if 0, do jump somewhere else if otherwise

	mov	al,90h		; MIDI start note
	out	dx,al

	mov	cl,08h
	lodsb
	or	al,al		; lodsb doesn't set flags
	jz	exit		; if zero, done

	js	ong
	sar	cx,01h
ong:
	cmp	al,01h
	jnz	nohands
	xor	bp,bp
	cmp	si,word second
	jle	blah
	sub	bp,byte 14
blah:

	pusha				; save registers (si and dx most impt)

	lea	si,[bp+arm_down]	; point to arm up/arm down

	call	draw_box

	popa				; restore registers

	jmp	short music_loop
nohands:
	and	al,7Fh			; strip off length
	out	dx,al			; output note

	mov	al,67h			; output velocity
	out	dx,al

;	mov	ah,86h			; pause
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
	lodsw				; get di
	mov	di,ax

	cmp	al,0ffh			; if bottom ff then done
	jz	short done_boxes

;	add	al,34h			; center
;	imul	ax,140h			; move to correct row

	mov	di,ax			; move into output pointer

;	xor	ax,ax

	lodsb				; get ylen/xlen
	mov	dl,al
	sar	dl,1
	sar	dl,1
	and	dl,03Ch			;  store in dl

;	xor	ax,ax			; get x1
;	lodsb
;	add	al,70h			; center
;	add	di,ax

	sal	ax,1
	sal	ax,1
	mov	bp,ax
	and	bp,03ch


;	lodsb				; get xlen
;	mov	bp,ax			; save in bp

	mov	bx,0140h		; amount to add to get to next line
	sub	bx,bp

	lodsb				; load color

box_loop:
	mov	cx,bp			; set amount to store
	rep	stosb			; store out
	add	di,bx			; move to next

	dec	dl			; decrease height
	jnz	short box_loop		; repeat until box done

	jmp	short draw_box		; loop



	;================================
	; Exit
	;================================
done_boxes:
exit:

	ret		; re-use ret

;	xor	al,al
;	mov	ah,4Ch
;	int	21h

;              y    x  col
data:
boxes_data:
db 080h, 041h, 0CCh, 80
db 0B0h, 041h, 0CCh, 80
db 080h, 07Dh, 0CCh, 80
db 0B0h, 07Dh, 0CCh, 80
db 026h, 062h, 31h, 64
db 050h, 072h, 8Ch, 19
db 08Eh, 07Dh, 45h, 18
db 068h, 072h, 83h, 23
db 098h, 096h, 79h, 18
db 0B4h, 082h, 72h, 18
db 028h, 053h, 53h, 87
db 0E7h, 04Ch, 14h, 6
db 0A2h, 050h, 42h, 6
db 0A7h, 08Ch, 23h, 64
db 071h, 07Ch, 0C1h, 24
db 06Fh, 06Dh, 32h, 24
db 0B2h, 05Fh, 11h, 87
db 0CBh, 08Dh, 47h, 17
arm_up:
db 0C0h, 082h, 84h, 80
db 03Ch, 099h, 34h, 17
db 00Ah, 09Dh, 23h, 64
db 0ffh
arm_down:
db 040h, 099h, 36h, 80
db 040h, 08Fh, 43h, 17
db 042h, 085h, 22h, 64
db 0ffh


;db	0h,	0h,	95,	80		; background
;	y1	ylen	x1	xlen	color
;db	0,	95,	0,	95,	80	; 0 background
;db	39,	56,	39,	19,	23	; 1 grey lower
;db	39,	22,	17,	22,	19	; 2 left dgrey
;db	39,	31,	53,	10,	19	; 3 right dgrey
;db	48,	13,	15,	20,	18	; 4 l green
;db	70,	25,	23,	36,	18	; 5 l green bottom
;db	53,	17,	53,	7,	18	; 6 l green
;db	26,	13,	38,	8,	64	; 7 neck
;db	15,	19,	42,	10,	87	; 8 face
;db	9,	6,	39,	15,	6	; 9 hair
;db	12,	16,	33,	9,	6	; 10 hair
;db	47,	48,	50,	3,	24	; 11 mic
;db	35,	11,	47,	7,	24	; 12 mic
;db	24,	4,	51,	3,	87	; 13 nose
;db	61,	15,	11,	28,	17	; 14 l arm
;db	60,	10,	39,	10,	64	; 15 l hand
;arm_up:
;db	60,	21,	63,	12,	80	; 16 erase r arm up
;db	70,	12,	59,	15,	17	; 17 r arm
;db	73,	8,	73,	12,	64	; 18 r hand
;db	128
;arm_down:
;db	70,	15,	62,	26,	80	; 19 erase r arm down
;db	70,	12,	62,	10,	17	; 20 r arm up
;db	60,	10,	63,	8,	64	; 21 r hand up
;db	128


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
