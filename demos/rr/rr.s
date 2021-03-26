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


# ??? bytes

.text

# generate only 8086 code
.arch i8086
.code16
# COM file is loaded at 0x100 offset
.org 0x100

	.globl start
start:

	mov	$0x13,%ax	# set 320x200x256 mode
	int	$0x10

	mov	$0xa000,%bx	# point es:di to $a000:0000
	mov	%bx,%es
	xor	%di,%di

	mov	$boxes,%si

	# input in si
	# y is in di.   yend in dx
	# color in AX
	# saved width in bp->cx
	# bx = add to next line
draw_box:
	xor	%ax,%ax
	lodsb			# get y1 into al

	cmp	$128,%al	# note lodsb does not set flags
	je	exit

	add	$52,%al		# center vertically

	mov	$320,%dx
	imul	%dx		# y1*320 into ax
	mov	%ax,%di		# y1*320 into di

	lodsb			# get y2 into al
	mov	%al,%dl

	xor	%ax,%ax
	lodsb			# get x1 into al
	add	%ax,%di		# di=(320*y1)+x1
	add	$112,%di	# center horizontally

	lodsb			# get length
	mov	%ax,%bp		# store for later

	mov	$320,%bx
	sub	%bp,%bx

	lodsb			# color

box_loop:
	mov	%bp,%cx
	rep	stosb

	add	%bx,%di

	dec	%dl
	jnz	box_loop

	jmp	draw_box

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
.byte	60,	21,	63,	12,	80	# 16 erase r arm up
.byte	70,	12,	59,	15,	17	# 17 r arm
.byte	73,	8,	73,	12,	64	# 18 r hand
.byte	70,	15,	62,	26,	80	# 19 erase r arm down
.byte	70,	12,	62,	10,	17	# 20 r arm up
.byte	60,	10,	63,	8,	64	# 21 r hand up
.byte	128
