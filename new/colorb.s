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


# 128 bytes (fork from raster.s)
# 129 bytes (re-write to support three colors)

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

	# %cx==0 here

	mov	$8,%cl
	mov	$line1,%si

	# check to see if switch direction

	lodsb				# load direction into al
	mov	%al,%bl			# move current direction into bl
	lodsb				# load current Y into al
	mov	%al,%bh			# move Y into bh

	cmp	$0,%bh
	je	flip_dir		# if 8, switch to down
	cmp	$192,%bh		# if 190, switch to up
	jne	was_fine		# otherwise we were good

flip_dir:
	neg	%bl			# flip direction
	mov	%bl,-2(%si)
was_fine:
	add	%bl,%al
	mov	%al,-1(%si)		# store out updated Y

raster_loop:

set_pal:
	mov	$0x3c8,%dx
	mov	%bh,%al
	out	%al,%dx
	inc	%dx

	lodsb
	push	%ax
	and	$0x03,%al
	shl	%al
	shl	%al
	shl	%al
	shl	%al
	out	%al,%dx		# r

	pop	%ax
	push	%ax
	shl	%al
	shl	%al
	and	$0xc0,%al
	out	%al,%dx		# g

	pop	%ax
	and	$0xc0,%al
	out	%al,%dx		# b

	# do loop


	add	$1,%bh			# point to next Y


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
.byte	1,	51				# red
.byte	0x00,0x01,0x02,0x03,0x03,0x02,0x02,0x00
.byte	1,	151				# green
.byte	0x00,0x04,0x08,0x0c,0x0c,0x08,0x04,0x00


