# decompress

# Syscalls
.equ SYSCALL_EXIT,     1
.equ SYSCALL_READ,     3
.equ SYSCALL_WRITE,    4
.equ SYSCALL_OPEN,     5
.equ SYSCALL_CLOSE,    6

	.globl _start
_start:

	#======================================
	# read in the file
	#======================================

	push	$SYSCALL_OPEN		# load 5 [ open() ]
	pop	%eax			# in 3 bytes

	mov	$filename,%ebx		# '/proc/cpuinfo'
	xor	%ecx,%ecx		# 0 = O_RDONLY <bits/fcntl.h>
	cdq				# clear edx in clever way
	int	$0x80			# syscall.  fd in eax.
					# we should check that eax>=0

	mov	%eax,%ebx		# save our fd

	push	$SYSCALL_READ		# load 3 = read()
	pop	%eax			# in 3 bytes

	mov	$disk_buffer,%ecx

	mov	$32,%dh			# 8192 bytes
					# we load sneakily by knowing
					# 32<<8 = 8192. be sure edx clear


	int	$0x80

	push	$SYSCALL_CLOSE		# close (to be correct)
	pop	%eax
	int	$0x80

	#======================================

zx02_full_decomp:

	mov	$out_buffer,%edi	# set destination ZX0_dst
	mov	$disk_buffer,%esi	# set source ZX0_src

	movb	$0x80,bitr

	xor	%ebx,%ebx		# set offset to 0

# Decode literal: Ccopy next N bytes from compressed file
#   Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal:

	call	get_elias



cop0:
	lodsb			# load byte from ZX0_src, inc
plus1:
	stosb			# store byte to ZX0_dst, inc
plus2:
	dec	%cl
	jne	cop0

	salb	$1,bitr
	jc	dzx0s_new_offset

# Copy from last offset (repeat N bytes from last offset)
#    Elias(length)

	call	get_elias

dzx0s_copy:
	mov	%edi,%edx		# load ZX0_dst
	sub	%edx,%ebx		# subtract offset
					# store in pntr
cop1:
	movb	(%edx),%al		# load byte from ptr
	inc	%edx			# increment pntr

plus3:
	stosb				# store byte to ZX0_dst
plus4:
	dec	%ebx
	jne	cop1

	salb	$1,bitr
	jnc	decode_literal

# Copy from new offset (repeat N bytes from new offset)
#    Elias(MSB(offset))  LSB(offset)  Elias(length-1)

dzx0s_new_offset:

	#  Read elias code for high part of offset
	call	get_elias
	je	zx02_exit	#  Read a 0, signals the end

	# Decrease and divide by 2
	dec	%cx
	shr	$1,%cx		# @
	mov	%cl,%bh

	# Get low part of offset, a literal 7 bits

	lodsb			# load from ZX0_src, increment
plus5:
				# Divide by 2
	ror	%ax		#  @
	mov	%ax,%bx

	# And get the copy length.
	# Start elias reading with the bit already in carry:

	mov	$1,%cx
	call	elias_skip1

	inc	%cx
	jnc	dzx0s_copy

# Read an elias-gamma interlaced code.
# ------------------------------------

get_elias:

					# Initialize return value to #1
	mov	$1,%ecx			# ldx   #1
	jmp	elias_start

elias_get:				# Read next data bit to result
	salb	$1,bitr
	rol	%ecx			# @

elias_start:
	# Get one bit
	salb	$1,bitr
	jne	elias_skip1

	# Read new bit from stream
	lodsb				# load ZX0_src, inc (16-bit)

	stc				# set carry
	rol	%al			# @
	mov	%al,bitr

elias_skip1:
	mov	%cl,%al
	jc	elias_get
					#  Got ending bit, stop reading
	ret

zx02_exit:





	#======================================
	# write out output to stdout
	#======================================


	push	$1			# stdout
	pop	%ebx			# in bx

	push	$SYSCALL_WRITE		# load 3 = read()
	pop	%eax			# in 3 bytes

	mov	$out_buffer,%ecx

	cdq				# clear dx (sign extend ax into it)

	mov	$64,%dh			# 16384 bytes
					# we load sneakily by knowing
					# 64<<8 = 16384. be sure edx clear


	int	$0x80

	push	$SYSCALL_CLOSE		# close (to be correct)
	pop	%eax
	int	$0x80


	#================================
	# Exit
	#================================
exit:
	xor     %ebx,%ebx
	xor	%eax,%eax
	inc	%eax	 		# put exit syscall number (1) in eax
	int     $0x80             	# and exit


#===========================================================================
#	section .data
#===========================================================================
.data

filename:	.ascii	"pq_title.zx02"

#============================================================================
#	section .bss
#============================================================================
.bss
.lcomm	disk_buffer,8192
.lcomm	out_buffer,16384
.lcomm	bitr,1
