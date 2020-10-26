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
#	cmp	$200,%bx		# see if at end
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
raster_loop:

	mov	line1+0(%bx,1),%al	# load Y into al
	push	%ax			# save for later
	mov	line1+2(%bx,1),%ah	# load color into ah

set_pal:
	mov	$0x3c8,%dx
	out	%al,%dx
	inc	%dx
	mov	%ah,%al		# r
	out	%al,%dx
	xor	%al,%al		# g
	out	%al,%dx
#	xor	%al,%al		# b
	out	%al,%dx
#	ret


	# raster move



	pop	%ax
#	mov	line1(%bx,1),%al	# load current Y
	cmp	$0,%al
	je	flip_dir		# if 0, switch to down
	cmp	$200,%al		# if 200, switch to up
	je	flip_dir
	jmp	was_fine		# otherwise we were good

flip_dir:
	negb	line1+1(%bx,1)		# flip direction

was_fine:
	add	line1+1(%bx,1),%al	# add direction into Y
	mov	%al,line1+0(%bx,1)	# store out

	# do loop

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
.byte	51,1,0		# 0
.byte	52,1,13		# 1
.byte	53,1,43		# 2
.byte	54,1,63		# 3
.byte	55,1,43		# 4
.byte	56,1,13		# 5
#.byte	57,1,0		# 6
.byte	151,1,0		# 7
.byte	152,1,13	# 8
.byte	153,1,43	# 9
.byte	154,1,63	# 10
.byte	155,1,43	# 11
.byte	156,1,13	# 12
#.byte	157,1,0		# 13
