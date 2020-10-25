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

#	push	%es
	mov	$0xa000,%cx
	mov	%cx,%es

	# draw colored lines

	xor	%dx,%dx
	xor	%di,%di
line_loop:
	mov	$160,%cx
	mov	%dl,%al
	mov	%al,%ah
	rep	stosw
	inc	%dx
	cmp	$200,%dx
	jne	line_loop


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

	# set all colors to zero
#	xor	%ax,%ax
#	xor	%cx,%cx
clear_pal_loop:
#	mov	%cl,%al
#	call	set_pal

#	inc	%cl
#	cmp	$255,%cl
#	jne	clear_pal_loop


	# raster line
	xor	%bx,%bx
raster_loop:

	mov	line1(%bx,1),%al
	mov	line1+2(%bx,1),%ah
	call	set_pal

	# raster move


	mov	line1(%bx,1),%al	# load current Y
	cmp	$0,%al
	je	make_positive		# if 0, switch to down
	cmp	$200,%al		# if 200, switch to up
	je	make_negative
	jmp	was_fine		# otherwise we were good

make_positive:
	mov	$0x1,%ah		# make add 1
	jmp	done_make

make_negative:
	mov	$0xff,%ah		# make add -1

done_make:
	mov	%ah,line1+1(%bx,1)	# move to add location

was_fine:
	add	line1+1(%bx,1),%al	# add direction into Y
	mov	%al,line1+0(%bx,1)	# store out

	# do loop

	add	$3,%bx
	cmp	$36,%bx
	jne	raster_loop

	jmp	big_big_loop

#	pop	%es

	#================================
	# Exit
	#================================
exit:
#	xor     %al,%al			# return 0
#	mov	$0x4c,%ah		# exit
#	int     $0x21             	# and exit


	# set palette
	# color in %al
	# r in %ah, g in %bh b in %bl

set_pal:
	mov	$0x3c8,%dx
	out	%al,%dx
	inc	%dx
	mov	%ah,%al		# r
	out	%al,%dx
#	xor	%al,%al		# g
	out	%al,%dx
#	xor	%al,%al		# b
	out	%al,%dx
	ret


	#===================================
	# assumes you want to clear a000:000
#cls:
#	push	%es
#	mov	$0xa000,%cx
#	mov	%cx,%es
#	mov	$32000,%cx
#	xor	%di,%di
#	rep	stosw
#	pop	%es
#	ret

.data

line1:
.byte	1,1,0
.byte	2,1,13
.byte	3,1,23
.byte	4,1,43
.byte	5,1,53
.byte	6,1,63
.byte	7,1,53
.byte	8,1,43
.byte	9,1,23
.byte	10,1,13
.byte	11,1,0


