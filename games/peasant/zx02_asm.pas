{ De-compressor for ZX02 files
  (c) 2022 DMSC
  Code under MIT license, see LICENSE file.

  Modified for Turbo Pascal by Vince Weaver
}

UNIT zx02_asm;

INTERFACE

type
	buffer = Array [0..16383] of byte;
	buffer_ptr = ^buffer;


procedure decompress(dest,src:buffer_ptr);

IMPLEMENTATION


procedure decompress(dest,src:buffer_ptr);

var
	dest_seg,dest_off,src_seg,src_off : word;

label decode_literal,cop0,plus1,plus2;
label dzx0s_copy,cop1,plus3,plus4,dzx0s_new_offset;
label plus5,get_elias,elias_get,elias_skip1,elias_start,plus6;
label zx02_exit;

begin
	dest_seg:=seg(dest^);
	dest_off:=ofs(dest^);
	src_seg:=seg(src^);
	src_off:=ofs(src^);

	asm

	push	es
	push	ds			{ turbo pascal needs ds/bp saved }
	push	bp
	push	di
	push	si

	mov	ax,[dest_seg]
	mov	es,ax			{ ZX0_dst }
	mov	di,[dest_off]		{ es:di = destination}

	mov	ax,[src_seg]
	mov	ds,ax			{ ZX0_src }
	mov	si,[src_off]		{ ds:si = source}

	mov	dl,80h			{ bitr }

	xor     bx,bx			{ set offset to 0 }

	{=======================================================  }
	{ Decode literal: Ccopy next N bytes from compressed file }
	{   Elias(length)  byte[1]  byte[2]  ...  byte[N]         }
decode_literal:

	call	get_elias

cop0:
	lodsb				{ load byte from ZX0_src, 16-bit inc }
plus1:
	stosb				{ store byte to ZX0_dst, 16-bit inc }
plus2:
	dec     cl			{ X }
	jne	cop0

	sal	dl,1			{ arith shift left bitr, top in carry}
	jc	dzx0s_new_offset

	{ ########################################################## }
	{ # Copy from last offset (repeat N bytes from last offset)  }
	{ #    Elias(length)                                         }

	call	get_elias

dzx0s_copy:
	{ # 16-bit subtract: pntr = ZX0_dst - offset                 }
	{ # on 6502 C=0 here so we can't use SUB but                 }
	{ # instead SBB+sec (is carry inverted vs 6502?) to match    }
	stc
	mov	bp,di			{ load offset into ebp }
	sbb	bp,bx			{ ebp=edi-ebx }
					{ ebp is pntr }
cop1:
	mov	al,[es:bp]		{ load byte from ptr }
	inc	bp			{ increment pntr 16-bit }

plus3:
	stosb				{ store byte to ZX0_dst }
plus4:
	dec	cl
	jnz	cop1

	sal	dl,1
	jnc	decode_literal

	{ ======================================================= }
	{ Copy from new offset (repeat N bytes from new offset)   }
	{ Elias(MSB(offset))  LSB(offset)  Elias(length-1)        }

dzx0s_new_offset:
	{ Read elias code for high part of offset }

	call	get_elias

	or	al,al			{ see if 0 }
					{ we can't do this inside get_elias }
					{ because OR clears the carry flag }
					{ which broke things }

	jz	zx02_exit		{ Read a 0, signals the end }

	{ Decrease and divide by 2 }

	dec	cl
	mov	bh,cl			{ move to high part of offset }
	shr	bh,1			{ @ }

	{ Get low part of offset, a literal 7 bits }

	lodsb				{ load from ZX0_src, increment }
plus5:
					{ Divide by 2 }
	rcr	al,1			{ @ }
	mov	bl,al

	{ And get the copy length. }
	{ Start elias reading with the bit already in carry: }

	mov     cl,1
	call	elias_skip1

	inc	cl
	jnc	dzx0s_copy

{===================================== }
{ Read an elias-gamma interlaced code. }
{ ------------------------------------ }

get_elias:
					{ Initialize return value to #1 }
	mov     cl,1			{ ldx   #1 }
	jmp	elias_start

elias_get:				{ Read next data bit to result }
	sal	dl,1			{ arith shift left bitr }
	rcl     al,1			{ rotate into low bit }
	mov	cl,al			{ move to count register }

elias_start:
        { Get one bit }
	sal	dl,1			{ arith shift left bitr }
	jnz	elias_skip1             { }

	{ Read new bit from stream }
	lodsb				{ load ZX0_src, inc (16-bit) }
plus6:
	stc				{ set carry }
	rcl	al,1			{ @ }
	mov	dl,al			{ move into bitr }

elias_skip1:
	mov     al,cl			{ note: mov doesn't set zero flag }
	jc	elias_get

					{ Got ending bit, stop reading }
        ret

zx02_exit:
	pop	si
	pop	di
	pop	bp
	pop	ds
	pop	es

	end;


end;


end.
