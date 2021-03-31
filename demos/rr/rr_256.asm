org 100h
            ; mov	ax,0013h
            mov	al,13h
            int	10h
            ; mov	bx,0A000h
            ; mov	es,bx
			les bx,[bx]
			
            ; xor	di,di
            mov	si,boxes_data
            call	draw_box
            
			;mov	al,3Fh
            ;mov	dx,0331h
            ;out	dx,al
            ;dec	dx
			mov dx,0x330
			; it's accepted to assume UART mode
			; has to be set in the dosbox config
						
            mov	si,music_sequence
			music_loop:
            mov	al,90h
            out	dx,al
            mov	cl,08h
            lodsb	
            or	al,al
            jz	exit
            js	ong
            sar	cx,01h
            ong: cmp	al,01h
            jnz	nohands
            xor	bp,bp
            cmp	si,word second
            jle	blah
            sub	bp,byte 10h
            blah: 
			; push	si
            ; push	dx
			pusha
            ; mov	si,arm_down
            ; add	si,bp
			lea si,[bp+arm_down]
						
            call	draw_box
            ; pop	dx
            ; pop	si
			popa
            jmp	short music_loop
            nohands: 
			and	al,7Fh
            out	dx,al
            mov	al,67h
            out	dx,al
            ; mov	ah,86h
            ; int	15h
			; mov cl,6
			waiter: hlt
			loop waiter
			
			jmp	short music_loop
			draw_box:
            ; xor	ax,ax
            lodsb	
            cmp	al,80h
            jz	short done_boxes
            add	al,34h
            ;mov	dx,0140h
            ;imul	dx
            imul ax,0x140
			
			mov	di,ax
            lodsb	
            mov	dl,al
            xor	ax,ax
            lodsb	
            ;add	di,ax
            ;add	di,byte 70h
            add al,0x70
			add di,ax
			lodsb	
            mov	bp,ax
            mov	bx,0140h
            sub	bx,bp
            lodsb	
            box_loop: mov	cx,bp
            rep  stosb	
            add	di,bx
            dec	dl
            jnz	short box_loop
            jmp	short draw_box
            exit: 
            done_boxes: ret	
			; ret
			 ; xor	al,al
             ; mov	ah,4Ch
             ; int	21h
	data:	
boxes_data:	
db  0x00	,0x5f	,0x00	,0x5f   ,0x50	
db 	0x27	,0x38	,0x27	,0x13	,0x17	,0x27	,0x16	,0x11		,0x16	,0x13	,0x27	,0x1f	,0x35	,0x0a	,0x13	,0x30		
db 	0x0d	,0x0f	,0x14	,0x12	,0x46	,0x19	,0x17	,0x24		,0x12	,0x35	,0x11	,0x35	,0x07	,0x12	,0x1a	,0x0d		
db 	0x26	,0x08	,0x40	,0x0f	,0x13	,0x2a	,0x0a	,0x57		,0x09	,0x06	,0x27	,0x0f	,0x06	,0x0c	,0x10	,0x21		
db 	0x09	,0x06	,0x2f	,0x30	,0x32	,0x03	,0x18	,0x23		,0x0b	,0x2f	,0x07	,0x18	,0x18	,0x04	,0x33	,0x03		
db 	0x57	,0x3d	,0x0f	,0x0b	,0x1c	,0x11	,0x3c	,0x0a		,0x27	,0x0a	,0x40	,0x3c	,0x15	,0x3f	,0x0c	,0x50		
db 	0x46	,0x0c	,0x3b	,0x0f	,0x11	,0x49	,0x08	,0x49		,0x0c	,0x40	,0x80	,
arm_down:
db 0x46	,0x0f	,0x3e	,0x1a	,0x50		
db 	0x46	,0x0c	,0x3e	,0x0a	,0x11	,0x3c	,0x0a	,0x3f		,0x08	,0x40	,0x80
music_sequence:
db 0x39	,0x3b	,0x3e	,0x3b	,0xc2		
db  0xc2	,0xc0	,0x01	
second:
db 0x39	,0x3b	,0x3e	,0x3b	,0xc0		,0xc0	,0x3e	,0x3d	,0xbb	,0x01	,0x39	,0x3b	,0x3e		
db 	0x3b	,0xbe	,0x40	,0xbd	,0x39	,0x39	,0xc0	,0xbe		,0x00            
			
		