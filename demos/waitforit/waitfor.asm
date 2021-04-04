; rr

; roughly based on a PCbot twitter Qbasic program

; by Vince `deater` Weaver <vince@deater.net>
;	size optimization by Hellmood

;	--== Desire ==--


; 281 bytes -- my version
; 256 bytes -- hellmood re-write
; 247 bytes -- have box lookup first entry be pre-computed 16-bit address
; 253 bytes -- add ESC check
; 248 bytes -- note there's an extraneous box
; 266 bytes -- add in sierpinski intro
; 265 bytes -- swap order of x2/y2 columns, can use lodsw now
; 264 bytes -- load bh instead of bx
; 257 bytes -- self modifying code
; 256 bytes -- make $39 the termination character
; 256 bytes -- lot of craziness by Hellmood

org 100h
PAUSE:		equ 16

	;==========================
	; setup graphics

;	mov	al,13h		; set mode13h 320x200x256 mode
;	int	10h
;	mov	bx,0A000h
;	mov	es,bx

	les	bx,[bx]		; trick to get es to roughly $a000

	; also, load 0xCD to bl
	; mov bl,cl
	; mov bl,2		; roughly four seconds


	; Hellmood code
	; here be dragons

	mov	al,0x13*2
X:
	sbb	dx,cx
	sar	dx,1
	rcl	bp,1

	jnc	F
	or	al,40h
	add	dx,byte 83

F:
	shr	al,1
	adc	cx,dx

	; cmp cl,-126
	; jg G
	; hlt
	; G:

	int	10h
	mov	ah,0ch

	; loop X
	inc	bl
	jnz	X


	inc	bh		; 0xCD ++ until 0 again
	hlt
	jnz	X

;	dec	bx
;	jnz	X
;	jmp	short X

escape:
;	mov	bx,arm_up

	;==========================
	; draw rick

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

	mov	dx,330h
	mov	al,90h		; MIDI start note
	out	dx,al

	 mov	si,music_sequence
music_loop:



	mov	cl,9
	lodsb

	or	al,0		; lodsb doesn't set flags
	jz	exit		; if zero, done

	js	long_note
short_note:
	mov	cl,04
long_note:
	cmp	al,PAUSE
	jnz	nohands


; xor	bl,0x10
	xor	byte [smc+1],al		; self modify the hand to use

	pusha				; save registers (si and dx most impt)
smc:
	mov	si,arm_up		; point to arm up/arm down

	call	draw_box

	popa				; restore registers

	jmp	short music_loop

nohands:
	and	al,7Fh			; strip off length
	out	dx,al			; output note

	mov	al,67h			; output velocity
	; xlat
	out	dx,al

;	mov	ah,86h			; pause
;	int	15h
;	mov	cl,6

waiter:
	hlt
	loop	waiter

	in	al,60h		; read whatever is at keyboard port; looking for ESC which is #1
	dec	al		; if ESC, AX now 0
	jnz	short music_loop		; fall through if 0, do jump somewhere else if otherwise

	ret ; might be excluded, then garbage on the screen on exit :P

	;================================
	; Draw Box
	;================================
	; input in si
	; y is in di.   yend in dx
	; color in AX
	; saved width in bp->cx
	; bx = add to next line

draw_box:
	lodsw				; get output pointer

	cmp	al,039h			; if bottom is ff then done
	jz	short done_boxes

;	mov	di,ax			; move into di
	xchg di,ax

	lodsw				; get xlen (ah) ylen (al)
	; mov	dl,ah			; store xlen in dl
	; xchg al,ah

	; xor	ah,ah			; clear top of ax
	; cbw
	; mov	bp,ax			; store ylen in bp

;	xchg bx,ax

;	movzx bp,bl			; zero extended byte to word load, leave AH untouched

;	mov	bx,0140h		; amount to add to get to next line
;	sub	bx,bp

	; lodsb				; load color
	inc	si

box_loop:
;	lea	bp,[di+0x140]

	push	di
	movzx	cx,[si-1]			; set amount to store
	rep
;	GHJ:
;	test	di,di
;	jp RTZ
;	xor	al,1
;	RTZ:
	stosb			; store out
;	loop GHJ


;	add	di,bx			; move to next
;	add	di,0x140		; modify directly
;	sub	di,bp			; also frees BX as register =)
;	mov	di,bp
	pop	di
	add	di,0x140

	; dec	dl			; decrease height
	dec	ah			; decrease height (use AH directly)
	jnz	short box_loop		; repeat until box done
;	inc	si			; DOESNT WORK ON SECOND RUN!
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

;              xlen  ylen  color
data:
boxes_data:
 db 080h-80, 041h, 80, 95, 255
;db 080h-80-1, 041h-41, 81, 95, 255
db 067h, 072h, 23, 56, 19
db 051h, 072h, 19, 32, 46
db 08Fh, 07Dh, 18, 13, 20
db 017h, 099h, 18, 25, 36
db 0F5h, 083h, 18, 17, 7
db 026h, 062h, 64, 13, 8
db 06Ah, 054h, 87, 19, 10
db 0E7h, 04Ch, 6, 6, 15
db 0A1h, 050h, 6, 16, 9
db 072h, 07Ch, 24, 48, 3
db 06Fh, 06Dh, 24, 11, 7
db 0B3h, 05Fh, 87, 4, 3
db 0CBh, 08Dh, 17, 15, 28
db 0A7h, 08Ch, 64, 10, 10
arm_up:
db 0BFh, 08Ch, 80, 21, 12
db 03Bh, 099h, 17, 12, 15
db 009h, 09Dh, 64, 8, 12
db 039h
arm_down:
db 03Eh, 099h, 80, 15, 26
db 03Eh, 099h, 17, 12, 10
db 0BFh, 08Ch, 64, 10, 8
;db 039h	; get this for free from music


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
	db   NSHORT|NOTE_A3, NSHORT|NOTE_B3, NSHORT|NOTE_D4-1, NSHORT|NOTE_A3
	db   NLONG|NOTE_E4, NLONG|NOTE_E4, NSHORT|NOTE_D4, NSHORT|NOTE_CSHARP4
	db   NLONG|NOTE_B3,   PAUSE
third:
	db   NSHORT|NOTE_A3, NSHORT|NOTE_B3, NSHORT|NOTE_D4, NSHORT|NOTE_B3
	db   NLONG|NOTE_D4, NSHORT|NOTE_E4, NLONG|NOTE_CSHARP4, NSHORT|NOTE_A3
	db   NSHORT|NOTE_A3, NLONG|NOTE_E4, NLONG|NOTE_D4;, END
