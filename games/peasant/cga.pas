{ Some CGA routines }

UNIT cga;

INTERFACE

type
	ScreenType = array [0..16383] of byte;
        screen_ptr = ^ScreenType;


	SpriteArray = array[0..241] of char;
	SpritePtr = ^SpriteArray;

Procedure PrintChar(which: char);
Procedure PrintCharXor(which: char;x,y:word);
Procedure CGA_draw_sprite_bg_mask(x,y: word; sprite: SpritePtr;
		framebuffer: screen_ptr);
Procedure SpriteXY(x,y: word; sprite: SpritePtr; framebuffer: screen_ptr);
Procedure PrintStringXor(st:string;x,y:word);
Procedure screen_copy(dest,src:screen_ptr);
Procedure screen_update(dest,src:screen_ptr);
Procedure wait_vsync;
Procedure SetCGAMode(Mode: byte);
Procedure SetPalette(which: byte);
Procedure PutPixelXY(x,y: word);
Procedure RestoreBG(x,y,xsize,ysize: word; bg, fb: screen_ptr);
Procedure RestoreBG4(x,y,ysize: word; bg, fb: screen_ptr);
Procedure Rectangle(x1,y1,x2,y2: word; color: byte; fb: screen_ptr);
Procedure Hline(x1,x2,y: word; color: byte; fb: screen_ptr);
Procedure Vline(y1,y2,x: word; color: byte; fb: screen_ptr);

IMPLEMENTATION


var 

	screen:screentype absolute $B800:0000;

CONST cga_addr = $b800;


{***********************************************}
{ screen_copy                                   }
{***********************************************}

Procedure screen_copy(dest,src:screen_ptr);

var
	dest_seg,dest_off,src_seg,src_off : word;

begin
	dest_seg:=seg(dest^);
	dest_off:=ofs(dest^);
	src_seg:=seg(src^);
	src_off:=ofs(src^);

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,8192
		rep	movsw

		pop	es
		pop	ds

	end;

end;


{***********************************************}
{ screen_update                                 }
{***********************************************}
{ Only update middle (graphics) part of screen) }
{  skipping title and text entry area           }

{ From line 10 to line 190                      }
{ so offset 400 to 7600  (190*80)/2             }
{ 7200 bytes, /2 = 3600                         }

{ this code currently measured at 261,677 cycles }
{	which is roughly 3 vsync refreshes }


Procedure screen_update(dest,src:screen_ptr);

var
	dest_seg,dest_off,src_seg,src_off : word;

begin
	dest_seg:=seg(dest^);
	dest_off:=ofs(dest^);
	src_seg:=seg(src^);
	src_off:=ofs(src^);

	src_off:=src_off+400;

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,400		{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,3600

		rep	movsw

		pop	es
		pop	ds

	end;

	src_off:=src_off+8192;

	asm

		push	ds
		push	es

		mov	ax,[dest_seg]
		mov	es,ax
		mov	di,8592		{; es:di = destination}

		mov	ax,[src_seg]
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	cx,3600

		rep	movsw

		pop	es
		pop	ds

	end;


end;


{***********************************************}
{ CGA_draw_sprite_bg_mask                       }
{***********************************************}
{ Really only used for Rather Dashing }
{ Assumptions: }
{   Sprites always 4 bytes wide }
{   x from 0..319 but only draw on byte (4-pixel) boundaries }


Procedure CGA_draw_sprite_bg_mask(x,y: word; sprite: SpritePtr;
			framebuffer: screen_ptr);

var	even_offset,odd_offset,mask_offset,width,height:word;
	xsize,ysize,s_seg,s_off,f_seg,f_off:word;
	tempy,col_offset:word;
	peasant_priority:byte;

label loopy,skip0,skip1,skip2,skip3,skip4,skip5,skip6,skip7;


{ get mask }
{ (y/8) gets you 24 rows }
{ (y/8)+(x/8) gets you starting }
{ top/bottom you can get from ((y/4)&1) }


begin
	f_seg:=seg(framebuffer^);		{ pointer to framebuffer }
	f_off:=ofs(framebuffer^);

	s_seg:=seg(sprite^);			{ pointer to sprite }
	s_off:=ofs(sprite^)+2;			{ skip xsize/ysize }

	even_offset:=((y div 2)*80)+(x div 4);	{ actual offset where to draw }
						{ note only draw at }
						{ x: multiple of 4-pixel }
						{ y: multiple of 2-pixel }

	even_offset:=even_offset+f_off;		{ CGA even and odd lines }
	odd_offset:=even_offset+$2000;		{ 8k apart in memory }

	xsize:=Word(sprite^[0]);		{ get xsize, extend to 16-bits }
	ysize:=Word(sprite^[1]);		{ get ysize, extend to 16-bits }
					{ note: ysize is 1/2 sprite size }

	mask_offset:=xsize*ysize*2;	{ point to mask which immediately }
					{ follows sprite }


	{ calculate depth of top of sprite (head) }
	tempy:=y;
	{ make sure at least 48 }
	if (tempy<48) then tempy:=48;
	{ ((y-48)/8)+2; }
	{ +2 skips colors 0,1.  0 used to be collision, 1 is always-visible }
	peasant_priority:=((tempy-48) shr 3)+2;

	asm

		push	ds
		push	es

{ 8088 timing notes }
{  inc 16-bit reg:	2 cycles }
{  add/sub: reg+imm	4 cycles }
{ effective addr calc:	}
{	base = 5 }
{	indexed = 5 }
{	displace = 6 }
{	BX+SI = 7 }
{	BX+DI = 8 }
{	BX+SI+IMM = 11 }
{	BX+DI+IMM = 12 }
{ movsw = 26 cycles 1 word, faster if rep }
{ stosw = 15 cycles 1 word, faster if rep }
{ Note: write to CGA memory can take up to 25 cycles / word }

		{=======================}
		{ initialize            }
		{=======================}

		mov	dh,[peasant_priority]

		mov	ax,[f_seg]
		mov	es,ax
		mov	di,[even_offset]	{ es:di = fb destination}

		mov	ax,[s_seg]
		mov	ds,ax
		mov	si,[s_off]		{ ds:si = source sprite}

		mov	bx,[mask_offset]	{ ds:si+bx = mask }

		mov	cx,[ysize]		{ cx = y iterator }

loopy:

		{ unroll: assume always 4-bytes wide }

		{ even lines first }

						{ xoffset=0 }
		mov	al,es:[di]		{ load bg from fb }
		mov	dl,es:[di][16384]
		cmp	dl,dh
		jge	skip0
		and	al,ds:[si][bx] 		{ mask with mask }
		or	al,ds:[si]		{ or in sprite }
skip0:
		inc	si			{ increment sprite ptr }
		stosb			 	{ store out to fb, di+=2}

						{ xoffset=2 }
		mov	al,es:[di]		{ load bg from fb }
		mov	dl,es:[di][16384]
		cmp	dl,dh
		jge	skip1
		and	al,ds:[si][bx] 		{ mask with mask }
		or	al,ds:[si]		{ or in sprite }
skip1:
		inc	si			{ increment sprite ptr }
		stosb			 	{ store out to fb, di+=2}

						{ xoffset=0 }
		mov	al,es:[di]		{ load bg from fb }
		mov	dl,es:[di][16384]
		cmp	dl,dh
		jge	skip2
		and	al,ds:[si][bx] 		{ mask with mask }
		or	al,ds:[si]		{ or in sprite }
skip2:		inc	si			{ increment sprite ptr }
		stosb			 	{ store out to fb, di+=2}

						{ xoffset=2 }
		mov	al,es:[di]		{ load bg from fb }
		mov	dl,es:[di][16384]
		cmp	dl,dh
		jge	skip3
		and	al,ds:[si][bx] 		{ mask with mask }
		or	al,ds:[si]		{ or in sprite }
skip3:
		inc	si			{ increment sprite ptr }
		stosb			 	{ store out to fb, di+=2}




		{ draw odd lines next }
		{ di is 4 bytes past where we want }

		mov	al,es:[di][8192-4]	{ unroll, xoffset=0 }
		mov	dl,es:[di][16384+8192-4]
		cmp	dl,dh
		jge	skip4
		and	al,ds:[si][bx]
		or	al,ds:[si]
skip4:
		mov	es:[di][8192-4],al


		mov	al,es:[di][8193-4]	{ unroll, xoffset=0 }
		mov	dl,es:[di][16384+8193-4]
		cmp	dl,dh
		jge	skip5
		and	al,ds:[si][bx][1]
		or	al,ds:[si][1]
skip5:
		mov	es:[di][8193-4],al


		mov	al,es:[di][8194-4]	{ unroll, xoffset=0 }
		mov	dl,es:[di][16384+8194-4]
		cmp	dl,dh
		jge	skip6
		and	al,ds:[si][bx][2]
		or	al,ds:[si][2]
skip6:
		mov	es:[di][8194-4],al



		mov	al,es:[di][8195-4]	{ unroll, xoffset=0 }
		mov	dl,es:[di][16384+8195-4]
		cmp	dl,dh
		jge	skip7
		and	al,ds:[si][bx][3]
		or	al,ds:[si][3]
skip7:
		mov	es:[di][8195-4],al


		add	si,4			{ adjust sprite pointer }
						{ di is unchanged }

		add	di,(80-4)		{ point fb to next line }

		 {loop	loopy too far :( }

		dec	cx
		jne	loopy

		{=========}

		pop	es
		pop	ds

	end;

end;

(*

Procedure CGA_draw_sprite_bg_mask(x,y: word; sprite: SpritePtr;
			framebuffer,priority: screen_ptr);

var	even_offset,odd_offset,mask_offset,width,height:word;
	xsize,ysize,s_seg,s_off,f_seg,f_off:word;
	peasant_priority,tempy,col_offset:word;


label loopy;


{ get mask }
{ (y/8) gets you 24 rows }
{ (y/8)+(x/8) gets you starting }
{ top/bottom you can get from ((y/4)&1) }


begin
	{ calculate depth of top of sprite (head) }
	tempy:=y;
	{ make sure at least 48 }
	if (tempy<48) then tempy:=48;
	{ ((y-48)/8)+2; }
	{ +2 skips colors 0,1.  0 used to be collision, 1 is always-visible }
	peasant_priority:=((tempy-48) shr 3)+2;

	f_seg:=seg(framebuffer^);		{ pointer to framebuffer }
	f_off:=ofs(framebuffer^);

	s_seg:=seg(sprite^);			{ pointer to sprite }
	s_off:=ofs(sprite^)+2;			{ skip xsize/ysize }

	even_offset:=((y div 2)*80)+(x div 4);	{ actual offset where to draw }
						{ note only draw at }
						{ x: multiple of 4-pixel }
						{ y: multiple of 2-pixel }

	even_offset:=even_offset+f_off;		{ CGA even and odd lines }
	odd_offset:=even_offset+$2000;		{ 8k apart in memory }

	xsize:=Word(sprite^[0]);		{ get xsize, extend to 16-bits }
	ysize:=Word(sprite^[1]);		{ get ysize, extend to 16-bits }
					{ note: ysize is 1/2 sprite size }

	mask_offset:=xsize*ysize*2;	{ point to mask which immediately }
					{ follows sprite }


	asm

		push	ds
		push	es

{ 8088 timing notes }
{  inc 16-bit reg:	2 cycles }
{  add/sub: reg+imm	4 cycles }
{ effective addr calc:	}
{	base = 5 }
{	indexed = 5 }
{	displace = 6 }
{	BX+SI = 7 }
{	BX+DI = 8 }
{	BX+SI+IMM = 11 }
{	BX+DI+IMM = 12 }
{ movsw = 26 cycles 1 word, faster if rep }
{ stosw = 15 cycles 1 word, faster if rep }
{ Note: write to CGA memory can take up to 25 cycles / word }


		{=======================}
		{ draw even lines first }
		{=======================}

		mov	ax,[f_seg]
		mov	es,ax
		mov	di,[even_offset]	{ es:di = fb destination}

		mov	ax,[s_seg]
		mov	ds,ax
		mov	si,[s_off]		{ ds:si = source sprite}

		mov	bx,[mask_offset]	{ ds:si+bx = mask }

		mov	cx,[ysize]		{ cx = y iterator }

loopy:

		{ unroll: assume always 4-bytes wide }

		{ even lines first }

						{ xoffset=0 }
		mov	ax,es:[di]		{ load bg from fb }
		and	ax,ds:[si][bx] 		{ mask with mask }
		or	ax,ds:[si]		{ or in sprite }
		inc	si			{ increment sprite ptr }
		inc	si			{ increment sprite ptr }
		stosw			 	{ store out to fb, di+=2}

						{ xoffset=2 }
		mov	ax,es:[di]		{ load bg from fb }
		and	ax,ds:[si][bx] 		{ mask with mask }
		or	ax,ds:[si]		{ or in sprite }
		inc	si			{ increment sprite ptr }
		inc	si			{ increment sprite ptr }
		stosw			 	{ store out to fb, di+=2}

		{ draw odd lines next }
		{ di is 4 bytes past where we want }

		mov	ax,es:[di][8192-4]	{ unroll, xoffset=0 }
		and	ax,ds:[si][bx]
		or	ax,ds:[si]
		mov	es:[di][8192-4],ax

		mov	ax,es:[di][8194-4]	{ unroll, xoffset=0 }
		and	ax,ds:[si][bx][2]
		or	ax,ds:[si][2]
		mov	es:[di][8194-4],ax

		add	si,4			{ adjust sprite pointer }
						{ di is unchanged }

		add	di,(80-4)		{ point fb to next line }

		loop	loopy

		{=========}

		pop	es
		pop	ds

	end;

end;
*)



{==================================}
{ RestoreBG4                       }
{==================================}
{ used to restore BG around Rather Dashing }
{ assumes 4-byte wide }

Procedure RestoreBG4(x,y,ysize: word; bg, fb: screen_ptr);

var
	b_seg,b_off,f_seg,f_off,src_off,dest_off,dest_odd_off,src_odd_off:word;

label loopy;

begin
	f_seg:=seg(fb^);			{ point to framebuffer}
	f_off:=ofs(fb^);

	b_seg:=seg(bg^);			{ point to background }
	b_off:=ofs(bg^);

	src_off:=((y div 2)*80)+(x div 4);	{ get offset in both }
	dest_off:=src_off;

	src_off:=src_off+b_off;			{ adjust offsets }
	dest_off:=dest_off+f_off;


	asm

		push	ds
		push	es

		{=======================}
		{ setup pointers }
		{=======================}

		mov	ax,[f_seg]	{ destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{ es:di = destination}

		mov	ax,[b_seg]	{ source is background}
		mov	ds,ax
		mov	si,[src_off]	{ ds:si = source}

		mov	cx,[ysize]	{ cx = y iterator }

loopy:
		{=======================}
		{ draw odd lines first  }
		{=======================}

		{ unroll, xoffset=0 }

		mov	ax,ds:[si][8192]	{ ds:si is src }
		mov	es:[di][8192],ax	{ es:di is dest }

		mov	ax,ds:[si][8194]	{ unroll xoffset=1 }
		mov	es:[di][8194],ax


		{ now even lines }

		movsw				{ move from src to dest }
		movsw			 	{ store out to fb + inc }

		add	di,(80-4)		{ point dest to next line }
		add	si,(80-4)		{ point src to next line }

		loop	loopy

		{=========}

		pop	es
		pop	ds

	end;

end;


{***********************************************}
{ SpriteXY                                      }
{***********************************************}

{ assume 8 pixels wide for now }
{ also assume always writing to even Y }

{
	x,y,x*y
	sprite_even:	x*y bytes
	sprite_odd:	x*y bytes
	mask_even:
	mask_odd:


	want to load background
	and with mask
	or with sprite
	store back to background

	needs 3 pointers!
		es:di = destination
		ds:si = source (sprite)
		ds:[bx][si] = source (mask)

}


Procedure SpriteXY(x,y: word; sprite: SpritePtr; framebuffer: screen_ptr);

var	even_offset,odd_offset,mask_offset,width,height:word;
	xsize,ysize,s_seg,s_off,f_seg,f_off:word;
	col_offset:word;

label even_loopy,even_loopx;
label odd_loopy,odd_loopx;

begin
	f_seg:=seg(framebuffer^);
	f_off:=ofs(framebuffer^);

	s_seg:=seg(sprite^);
	s_off:=ofs(sprite^)+2;

	even_offset:=((y div 2)*80)+(x div 4);
	even_offset:=even_offset+f_off;
	odd_offset:=even_offset+$2000;

	xsize:=Word(sprite^[0]);
	ysize:=Word(sprite^[1]);

	mask_offset:=xsize*ysize*2;

	asm

		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]
		mov	es,ax
		mov	di,[even_offset]	{; es:di = destination}

		mov	ax,[s_seg]
		mov	ds,ax
		mov	si,[s_off]	{; ds:si = source}

		mov	bx,[mask_offset]

		mov	dx,[ysize]

even_loopy:
		mov	cx,[xsize]
even_loopx:

		mov	al,es:[di]
		and	al,ds:[si][bx]
		or	al,ds:[si]
		inc	si
		stosb

		loop	even_loopx

		add	di,(80-4)

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[odd_offset]	{; es:di = destination}

		mov	dx,[ysize]

odd_loopy:
		mov	cx,[xsize]
odd_loopx:

		mov	al,es:[di]
		and	al,ds:[si][bx]
		or	al,ds:[si]
		inc	si
		stosb

		loop	odd_loopx

		add	di,(80-4)

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;

{==================================}
{ Hline                            }
{==================================}
{ x1,y to x2,y }
{ actually x1,y1,x2,y2 all in 320x200 co-ords }

Procedure Hline(x1,x2,y: word; color: byte; fb: screen_ptr);

var
	f_seg,f_off,dest_off,dest_odd_off,nextline,xsize,ysize : word;

begin
	xsize:=(x2-x1) div 4;

	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	dest_off:=((y div 2)*80)+(x1 div 4);
	dest_off:=dest_off+f_off;

	dest_odd_off:=dest_off+$2000;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	al,[color]

		mov	cx,[xsize]
		rep	stosb


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}

		mov	cx,[xsize]
		rep	stosb

		pop	es
		pop	ds

	end;
end;


{==================================}
{ Vline                            }
{==================================}
{ x,y1 to x,y2 }
{ actually x1,y1,x2,y2 all in 320x200 co-ords }

Procedure Vline(y1,y2,x: word; color: byte; fb: screen_ptr);


var
	f_seg,f_off,dest_off,dest_odd_off,nextline,xsize,ysize : word;

label even_loopy;
label odd_loopy,odd_loopx;

begin
	ysize:=(y2-y1) div 2; {FIXME: only works if Y is even }

	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	dest_off:=((y1 div 2)*80)+(x div 4);
	dest_off:=dest_off+f_off;

	dest_odd_off:=dest_off+$2000;

	nextline:=79;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	al,[color]
		mov	dx,[ysize]
even_loopy:
		stosb

		add	di,[nextline]

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}

		mov	dx,[ysize]
odd_loopy:
		stosb

		add	di,[nextline]

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;

{==================================}
{ Rectangle                        }
{==================================}
{ actually x1,y1,x2,y3 all in 320x200 co-ords }
{    but we div x by 4 before using }

Procedure Rectangle(x1,y1,x2,y2: word; color: byte; fb: screen_ptr);

var
	f_seg,f_off,dest_off,dest_odd_off,nextline,xsize,ysize : word;

label even_loopy;
label odd_loopy,odd_loopx;

begin
	ysize:=(y2-y1) div 2; {FIXME: only works if Y is even }
	xsize:=(x2-x1) div 4;

	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	dest_off:=((y1 div 2)*80)+(x1 div 4);
	dest_off:=dest_off+f_off;

	dest_odd_off:=dest_off+$2000;

	nextline:=80-xsize;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	al,[color]
		mov	dx,[ysize]
even_loopy:
		mov	cx,[xsize]
		rep	stosb

		add	di,[nextline]

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}

		mov	dx,[ysize]
odd_loopy:
		mov	cx,[xsize]
		rep	stosb

		add	di,[nextline]

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;

{==================================}
{ RestoreBG                        }
{==================================}


Procedure RestoreBG(x,y,xsize,ysize: word; bg, fb: screen_ptr);

var
	b_seg,b_off,f_seg,f_off,src_off,dest_off,dest_odd_off,src_odd_off:word;

label even_loopy;
label odd_loopy;

begin
	f_seg:=seg(fb^);
	f_off:=ofs(fb^);

	b_seg:=seg(bg^);
	b_off:=ofs(bg^);

	src_off:=((y div 2)*80)+(x div 4);
	dest_off:=src_off;

	src_off:=src_off+b_off;
	dest_off:=dest_off+f_off;
	dest_odd_off:=dest_off+$2000;
	src_odd_off:=src_off+$2000;

	asm
		{; even first }

		push	ds
		push	es

		mov	ax,[f_seg]	{; destination is framebuffer }
		mov	es,ax
		mov	di,[dest_off]	{; es:di = destination}

		mov	ax,[b_seg]	{; source is background}
		mov	ds,ax
		mov	si,[src_off]	{; ds:si = source}

		mov	dx,[ysize]
even_loopy:
		mov	cx,[xsize]
		rep	movsb

		add	di,(80-4)	{FIXME: hardcoded}
		add	si,(80-4)

		dec	dx
		jne	even_loopy


		{; odd next }
		{; at this point }

		mov	di,[dest_odd_off]	{; es:di = destination}
		mov	si,[src_odd_off]

		mov	dx,[ysize]
odd_loopy:
		mov	cx,[xsize]
		rep	movsb

		add	di,(80-4)
		add	si,(80-4)

		dec	dx
		jne	odd_loopy

		pop	es
		pop	ds

	end;

end;


{==================================}
{ PutPixelXY                       }
{==================================}

Procedure PutPixelXY(x,y: word);

var offset,width,height:word;

begin

	offset:=((y div 2)*80)+(x div 4);

	if (y mod 2 = 1) then offset:=offset+8192;

	mem[cga_addr:offset]:=0;

end;



Procedure GotoXY(x,y: byte);
begin
	asm
		mov	bh,0
		mov	dl,x
		mov	dh,y
		mov	ah,2
		int	10h
	end;
end;

{ AL = character
  BH = page number?
  BL = foreground color
}

Procedure PrintChar(which: char);
begin
	asm
		mov	al,which
		mov	ah,0eh
		mov	bh,0
		mov	bl,0
		int	10h
	end;
end;

{ al = char
  bh = page num
  bl = color (bit 7 means xor)
  cx = number of times
}

Procedure PrintCharXor(which: char;x,y:word);
begin
	GotoXY(x,y);

	asm
		mov	al,which
		mov	ah,09h
		mov	bh,0
		mov	bl,131
		mov	cx,1
		int	10h
	end;
end;

Procedure PrintStringXor(st:string;x,y:word);

var i:word;

begin
	for i:=1 to length(st) do begin
		PrintCharXor(st[i],(i-1)+x,y);
	end;
end;

{
  BH = 0
  BL = background/border color
}

Procedure SetBackground(color: byte);
begin
	asm
		mov	ah,0bh
		mov	bh,0
		mov	bl,color
		int	10h
	end;
end;

{
  BH = 01h
  BL = palette (00=g/r/b, 01=c/m/w)
}

Procedure SetPalette(which: byte);
begin
	asm
		mov	bh,1
		mov	bl,which
		mov	ah,0bh
		int	10h
	end;
end;

Procedure SetCGAMode(Mode: byte);
begin
	asm
		mov	ah,0
		mov	al,Mode
		int	10h
	end;
end;

Procedure wait_vsync;

label	wait_retrace,wait_next;

begin
	{ wait for retrace }

	asm
		mov	dx,3dah
wait_retrace:
		in	al,dx
		test	al,8
		jz	wait_retrace
wait_next:
		in	al,dx
		test	al,8
		jnz	wait_next
	end;
end;

end.
