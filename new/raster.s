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
	# raster line
	mov	$33,%bx
	mov	$line1,%si
raster_loop:

	lodsb				# load Y into al
	push	%ax			# save for later

set_pal:
	mov	$0x3c8,%dx
	out	%al,%dx
	inc	%dx
	lodsb
#	mov	%ah,%al		# r
	out	%al,%dx
	xor	%al,%al		# g
	out	%al,%dx
#	xor	%al,%al		# b
	out	%al,%dx
#	ret


	# raster move

	pop	%ax			# load current Y
	cmp	$0,%al
	je	flip_dir		# if 0, switch to down
	cmp	$200,%al		# if 200, switch to up
	je	flip_dir
	jmp	was_fine		# otherwise we were good

flip_dir:
	negb	(%si)			# flip direction

was_fine:
	add	(%si),%al		# add direction into Y
	mov	%al,-2(%si)		# store out

	# do loop

	inc	%si
	sub	$3,%bx
	jns	raster_loop

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
.byte	51,	0,	1	# 0
.byte	52,	13,	1	# 1
.byte	53,	43,	1	# 2
.byte	54,	63,	1	# 3
.byte	55,	43,	1	# 4
.byte	56,	13,	1	# 5
#.byte	57,	0,	1	# 6
.byte	151,	0,	1	# 7
.byte	152,	13,	1	# 8
.byte	153,	43,	1	# 9
.byte	154,	63,	1	# 10
.byte	155,	43,	1	# 11
.byte	156,	13,	1	# 12
#.byte	157,	0,	1	# 13
