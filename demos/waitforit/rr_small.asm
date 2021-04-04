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

org 100h

	;==========================
	; setup graphics

;	mov	al,13h		; set mode13h 320x200x256 mode
;	int	10h

;	mov	bx,0A000h
;	mov	es,bx

	mov	bh,$10

sier_loop:
	add	al,13h		; sierpinski code by hellmood
	and	cl,ch
	int	10h
	mov	ah,0Ch

	mov	dx,3DAh		; run for a few seconds, checks vblank
	in	al,dx		; prob not the best way to do this
	and	al,08h
	jz	l1

	dec	bx
	je	escape
l1:
	loop	sier_loop

escape:
	les	bx,[bx]		; trick to get es to roughly $a000


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

	js	long_note
short_note:
	sar	cx,01h
long_note:
	cmp	al,01h
	jnz	nohands

;	xor	bp,bp
;	cmp	si,word second
;	jle	blah
;	sub	bp,byte 10h
;blah:

	pusha				; save registers (si and dx most impt)

	xor	byte [smc+1],10h	; self modify the hand to use

smc:
	mov	si,arm_up		; point to arm up/arm down

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
	lodsw				; get output pointer

	mov	di,ax			; move into di

	cmp	al,039h			; if bottom is ff then done
	jz	short done_boxes

	lodsw				; get xlen (ah) ylen (al)
	mov	dl,ah			; store xlen in dl

	xor	ah,ah			; clear top of ax
	mov	bp,ax			; store ylen in bp

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

;              xlen  ylen  color
data:
boxes_data:
db 080h, 041h, 95, 95, 80
db 067h, 072h, 19, 56, 23
db 051h, 072h, 46, 32, 19
db 08Fh, 07Dh, 20, 13, 18
db 017h, 099h, 36, 25, 18
db 0F5h, 083h, 7, 17, 18
db 026h, 062h, 8, 13, 64
db 06Ah, 054h, 10, 19, 87
db 0E7h, 04Ch, 15, 6, 6
db 0A1h, 050h, 9, 16, 6
db 072h, 07Ch, 3, 48, 24
db 06Fh, 06Dh, 7, 11, 24
db 0B3h, 05Fh, 3, 4, 87
db 0CBh, 08Dh, 28, 15, 17
db 0A7h, 08Ch, 10, 10, 64
arm_up:
db 0BFh, 08Ch, 12, 21, 80
db 03Bh, 099h, 15, 12, 17
db 009h, 09Dh, 12, 8, 64
db 039h
arm_down:
db 03Eh, 099h, 26, 15, 80
db 03Eh, 099h, 10, 12, 17
db 0BFh, 08Ch, 8, 10, 64
;db 039h	; get this for free from music


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
