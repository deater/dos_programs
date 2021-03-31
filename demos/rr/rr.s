# rr

# On Linux
#  assemble with     "as --32 -R -o rr.o rr.s"
#  link with         "objcopy -O binary rr.o rr.o.o"
#                    "dd if=rr.o.o of=rr.com bs=256 skip=1"

#  Explanation for the above:
#     -R merges text and data segments
#     the DOS .com format is raw assembler, so no linking, just copy
#         the binary blob
#     the dd skips the first 0x100 bytes, as gas's .org directive
#         fills it with useless zeros

#  dump with  "objdump -bbinary --disassemble-all -mi8086 ./rr.com"


# 258 bytes -- sorta working code with music
# 249 bytes -- disable turning off notes
# 253 bytes -- draw box as separate routine
# 281 bytes -- hand waving works

.text

# generate only 8086 code
.arch i8086
.code16
# COM file is loaded at 0x100 offset
.org 0x100

	.globl start
start:

	#==========================
	# setup graphics

	mov	$0x13,%ax	# set 320x200x256 mode
	int	$0x10

	mov	$0xa000,%bx	# point es:di to $a000:0000
	mov	%bx,%es
	xor	%di,%di

	#==========================
	# draw rick

	mov	$boxes,%si	# point to our boxes data

	call	draw_box	# draw initial with hands down

	#==========================
	# play music

music:
	mov	$0x3F,%al		# set UART mode - command
	mov 	$0x331,%dx		# MIDI Control Port
	out 	%al,%dx			# send !
	dec 	%dx			# MIDI Data Port ( = 330h )


	mov	$music_sequence,%si	# point to music sequence
music_loop:

	mov 	$0x90,%al		# send note on channel ZERO - command
	out 	%al,%dx			# send

	mov	$8,%cx			# set default note length

	lodsb				# get note (doesn't set flags)
	or	%al,%al			# if 0, then end
	jz	exit

	js	long			# if high bit set, leave it long

short:
	sar	%cx			# play note shorter
long:

	cmp	$1,%al			# see if pause/move hand
	jne	no_hands

	#======================
	# wave hands at pause
do_hands:
	xor	%bp,%bp
	cmp	$second,%si
	jle	blah
	sub	$16,%bp
blah:

	push	%si
	push	%dx			# need to save port number

	mov	$arm_down,%si
	add	%bp,%si

	call	draw_box

	pop	%dx
	pop	%si
	jmp	music_loop


no_hands:
	and	$0x7f,%al		# data byte 1: note in %al
#	push	%ax			# save note to turn off later

handle_note1:


	out 	%al,%dx			# send !
	mov 	$0x67,%al		# data byte 2 : VOLUME = 67h
	out 	%al,%dx			# send !



pause:

	# cx:dx = wait in microseconds
	# cx=1 = 65536us = 64ms
	# so 20 should be about a second?
	# dx preserved?

	mov	$0x86,%ah		# WAIT
	int	$0x15

	# Turn off note

#	mov 	$0x80,%al		# send note on channel ZERO - command
#	out 	%al,%dx			# send !

#	pop	%ax
#
#handle_note2:
#	out 	%al,%dx			# send !
#	mov 	$0x67,%al		# data byte 2 : VOLUME = 67h
#	out 	%al,%dx			# send !

	jmp	music_loop


#================================
# Draw Box
#================================
# input in si
# y is in di.   yend in dx
# color in AX
# saved width in bp->cx
# bx = add to next line

draw_box:
	xor	%ax,%ax
	lodsb			# get y1 into al

	cmp	$128,%al	# note lodsb does not set flags
	je	done_boxes

	add	$52,%al		# center vertically

	mov	$320,%dx
	imul	%dx		# y1*320 into ax
	mov	%ax,%di		# y1*320 into di

	lodsb			# get y2 into al
	mov	%al,%dl		# store in %dx

	xor	%ax,%ax
	lodsb			# get x1 into ax

	add	%ax,%di		# di=(320*y1)+x1
	add	$112,%di	# center horizontally

	lodsb			# get length
	mov	%ax,%bp		# store for later

	mov	$320,%bx	# offset to increment to get next line
	sub	%bp,%bx

	lodsb			# color

box_loop:
	mov	%bp,%cx		# put line length into %cx
	rep	stosb		# store out a line

	add	%bx,%di		# add offset to next line

	dec	%dl		# decrement row count
	jnz	box_loop	# repeat until box done

	jmp	draw_box	# draw next box

done_boxes:
	ret

	#================================
	# Exit
	#================================
exit:
	xor     %al,%al			# return 0
	mov	$0x4c,%ah		# exit
	int     $0x21             	# and exit




.data
boxes:
#	y1	ylen	x1	xlen	color
.byte	0,	95,	0,	95,	80	# 0 background
.byte	39,	56,	39,	19,	23	# 1 grey lower
.byte	39,	22,	17,	22,	19	# 2 left dgrey
.byte	39,	31,	53,	10,	19	# 3 right dgrey
.byte	48,	13,	15,	20,	18	# 4 l green
.byte	70,	25,	23,	36,	18	# 5 l green bottom
.byte	53,	17,	53,	7,	18	# 6 l green
.byte	26,	13,	38,	8,	64	# 7 neck
.byte	15,	19,	42,	10,	87	# 8 face
.byte	9,	6,	39,	15,	6	# 9 hair
.byte	12,	16,	33,	9,	6	# 10 hair
.byte	47,	48,	50,	3,	24	# 11 mic
.byte	35,	11,	47,	7,	24	# 12 mic
.byte	24,	4,	51,	3,	87	# 13 nose
.byte	61,	15,	11,	28,	17	# 14 l arm
.byte	60,	10,	39,	10,	64	# 15 l hand
arm_up:
.byte	60,	21,	63,	12,	80	# 16 erase r arm up
.byte	70,	12,	59,	15,	17	# 17 r arm
.byte	73,	8,	73,	12,	64	# 18 r hand
.byte	128
arm_down:
.byte	70,	15,	62,	26,	80	# 19 erase r arm down
.byte	70,	12,	62,	10,	17	# 20 r arm up
.byte	60,	10,	63,	8,	64	# 21 r hand up
.byte	128

PAUSE		= 1
SHORT		= 0
LONG		= 128
END		= 0

NOTE_A3		= 57
NOTE_B3		= 59
NOTE_CSHARP4	= 61
NOTE_D4		= 62
NOTE_E4		= 64
NOTE_FSHARP4	= 66

music_sequence:
first: # si=7
	.byte   SHORT|NOTE_A3, SHORT|NOTE_B3, SHORT|NOTE_D4, SHORT|NOTE_B3
	.byte   LONG|NOTE_FSHARP4, LONG|NOTE_FSHARP4, LONG|NOTE_E4,  PAUSE
second: #si=17
	.byte   SHORT|NOTE_A3, SHORT|NOTE_B3, SHORT|NOTE_D4, SHORT|NOTE_B3
	.byte   LONG|NOTE_E4, LONG|NOTE_E4, SHORT|NOTE_D4, SHORT|NOTE_CSHARP4
	.byte   LONG|NOTE_B3,   PAUSE
third: #si=29
	.byte   SHORT|NOTE_A3, SHORT|NOTE_B3, SHORT|NOTE_D4, SHORT|NOTE_B3
	.byte   LONG|NOTE_D4, SHORT|NOTE_E4, LONG|NOTE_CSHARP4, SHORT|NOTE_A3
	.byte   SHORT|NOTE_A3, LONG|NOTE_E4, LONG|NOTE_D4, END

