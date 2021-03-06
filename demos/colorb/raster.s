#  Thanks to Kragen Javier Sitaker for a blog post showing
#     how to create a DOS .COM file using gas

#
#  Thanks to PCGPE
#

#  Thanks to Ralf Brown's DOS interrupt list
#     *fun fact* Ralf Brown grew up in the same town that I did
#		and his sister was a baby-sitter for my family
#

#  assemble with     "as --32 -R -o raster.o raster.s"
#  link with         "objcopy -O binary raster.o raster.o.o"
#                    "dd if=raster.o.o of=raster.com bs=256 skip=1"

#  Explanation for the above:
#     -R merges text and data segments
#     the DOS .com format is raw assembler, so no linking, just copy
#         the binary blob
#     the dd skips the first 0x100 bytes, as gas's .org directive
#         fills it with useless zeros

#  dump with  "objdump -bbinary --disassemble-all -mi8086 ./raster.com"


# 142 bytes
# 140 bytes (optimize draw lines loop)
# 137 bytes (count down loop)
# 139 bytes (fix bug where we were drawing white rather than red)
# 135 bytes (inline raster)
# 133 bytes (save y position)
# 127 bytes (use neg on memory)
# 125 bytes (loop backward)
# 128 bytes (two rasterbars)
# 119 bytes (use si for indexing)
# 125 bytes (make rasterbar thicker again)
# 119 bytes (remove per-line direction)
# 120 bytes (two thick lines)
# 117 bytes (direction in %cx)
# 127 bytes (red and green bars)
# 126 bytes (use loop instruction)
# 133 bytes (red and green moving independently)
# 132 bytes (can make assumption %cx is 0)
# 128 bytes (remove unnecessary ands)

.text

# generate only 8086 code
.arch i8086
.code16
# COM file is loaded at 0x100 offset
.org 0x100

	.globl start
start:

	# set 320x200x256 mode

	mov	$0x13,%ax
	int	$0x10

	mov	$0xa000,%bx		# point es:di to $a000:0000
	mov	%bx,%es
	xor	%di,%di

	# draw colored lines

	mov	$200,%bx
line_loop:
	mov	$320,%cx		# X
	mov	%bl,%al			# set color
	rep	stosb			# slower but fewer bytes
	dec	%bx			# increment color
	jne	line_loop		# if not, loop


	# CX is zero at this point

	mov	$0x101,%bx		# direction

big_big_loop:
	# wait for vertical refresh

	mov	$0x3da,%dx
l1:
	in	%dx,%al
	and	$8,%al
	jnz	l1
l2:
	in	%dx,%al
	and	$8,%al
	jz	l2

	#=============================================
	#=============================================
	# raster line
	#=============================================
	#=============================================

	mov	$16,%cl
	mov	$line1,%si

raster_loop:

	# 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
	#swap
	test	$7,%cl		# (16 and 8 it equals 0)
	jne	no_swap

do_swap:
	xchg	%bh,%bl


	# check to see if switch direction

	lodsb				# load Y into al

	cmp	$0,%al
	je	flip_dir		# if 0, switch to down
	cmp	$192,%al		# if 190, switch to up
	jne	was_fine		# otherwise we were good

flip_dir:
	neg	%bl			# flip direction

was_fine:
	dec	%si



no_swap:




	lodsb				# load Y into al

	# raster move

	add	%bl,%al			# add direction into Y
	mov	%al,-1(%si)		# store out

set_pal:
	mov	$0x3c8,%dx
	out	%al,%dx
	inc	%dx

	lodsb
	push	%ax
#	and	$0x0f,%al
	shl	%al
	shl	%al
	out	%al,%dx		# r

	pop	%ax
#	and	$0xf0,%al
	shr	%al
	shr	%al
	out	%al,%dx		# g

	xor	%al,%al
	out	%al,%dx		# b

	# do loop

	loop	raster_loop

	jmp	big_big_loop


	#================================
	# Exit
	#================================
exit:
#	xor     %al,%al			# return 0
#	mov	$0x4c,%ah		# exit
#	int     $0x21             	# and exit


.data

line1:
.byte	51,	0x00	# 16		r=(color&0xf)<<2
.byte	52,	0x03	# 15
.byte	53,	0x08	# 14
.byte	54,	0x0b	# 13
.byte	55,	0x0f	# 12
.byte	56,	0x0b	# 11
.byte	57,	0x08	# 10
.byte	58,	0x00	# 9

.byte	151,	0x00	# 8		g=(color&0xf0)>>2
.byte	152,	0x30	# 7
.byte	153,	0x80	# 6
.byte	154,	0xb0	# 5
.byte	155,	0xf0	# 4
.byte	156,	0xb0	# 3
.byte	157,	0x80	# 2
.byte	158,	0x00	# 1
