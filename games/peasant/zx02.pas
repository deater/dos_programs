{ De-compressor for ZX02 files
  (c) 2022 DMSC
  Code under MIT license, see LICENSE file.

  Modified for Turbo Pascal by Vince Weaver
}

UNIT zx02;

INTERFACE

type
	buffer = Array [0..16383] of byte;
	buffer_ptr = ^buffer;


procedure decompress(dest,src:buffer_ptr);

IMPLEMENTATION


var
	bitr : byte;		{ bit reserve }
	extra_bit: byte;	{ extra bit to inject }
	offset: word;		{ last offset }
	ipos: word;		{ input position }
	opos: word;		{ output position }
	input,output: buffer_ptr;


{************ get byte *************}

function get_byte:byte;

begin

	ipos := ipos + 1;

	get_byte := 0;

	get_byte:=input^[ipos-1];
end;

{************ get bit *************}

function get_bit:byte;

var	bit,c:byte;

begin

	if (extra_bit<>0) then begin
		bit := extra_bit and 1;
		extra_bit := 0;
	end
	else begin
		if (bitr = $80) then begin
			c := get_byte;
			if ((c and $80) <> 0) then bit:=1 else bit:=0;
			bitr := ((c shl 1) or 1);
		end 
		else begin
			if ((bitr and $80) <> 0) then bit:=1 else bit:=0;
			bitr := (bitr shl 1);
		end
	end;
	get_bit:=bit;
end;

{************ put byte *************}

procedure put_byte(b:byte);

begin

    output^[opos] := b;
    opos := opos + 1;

end;

{************ get elias *************}
{* Reads interlaced elias code      *}

function get_elias:word;

var
	ret,retval:word;
	i,b:byte;

label
	early_out;

begin
	ret:=1;
	retval:=0;

	for i:=0 to 8 do begin

		b := get_bit;
		if (b = 0) then begin
			retval:=ret;
			goto early_out;
		end;

		ret := ((ret shl 1) or get_bit);

		if (ret > $100) then begin
			retval:=0;
			goto early_out;
		end;
	end;
early_out:
	get_elias:= retval;
end;


{************ decode literal *************}

procedure decode_literal;

var
	c:byte;
	len:word;

label	early_out;

begin

	len := get_elias;

	if (len=0) then goto early_out;

	while (len<>0) do begin
		c := get_byte;
		put_byte(c);
		len:=len-1;
	end;

early_out:

end;


{************ decode match *************}

procedure decode_match(len_add:word);

var
	len,pos:word;

label	early_out;

begin

	len := get_elias + len_add;
	pos := opos;

	if (len > $100) then len := len and $FF;

	pos := pos - offset - 1;

	if (len=0) then goto early_out;

	while (len<>0) do begin
		put_byte(output^[pos]);
		pos := pos + 1;
		len := len - 1;
	end;

early_out:

end;

{************ decode match *************}

function decode_offset:word;

var
	msb,off,retval:word;

label	early_out;

begin
	retval := 0;
	msb := get_elias;

	if ((msb and $FF) = 0) then begin
		retval := 1;
		goto early_out;
	end;

	msb := msb - 1;

	off := get_byte;

	{ last bit in offset LSB is used as next bit to be read:}
	extra_bit := 2 or (off and 1);
	offset := (msb shl 7) or (off shr 1);

early_out:
	decode_offset:=retval;

end;


{*****************}
{ Decode Loop     }
{*****************}


procedure decode_loop;

var
	state:word;

label	early_out;

begin

	state := 0; { LITERAL }

	while(true) do begin
		case state of

			0: begin		{ Decode literal value: }
				decode_literal;
				if (get_bit<>0) then state := 2
				else state := 1;
			   end;

			2: begin		{ Decode new offset: }
				if (decode_offset<>0) then goto early_out;
				decode_match(1);

				if (get_bit<>0) then state := 2
				else state := 0;
			   end;
			1: begin		{  Decode repeated offset: }
				decode_match(0);
				if (get_bit<>0) then state := 2
				else state := 0;
			   end;
		end;
	end;

early_out:

end;


{*****************}
{ Decompress file }
{*****************}

procedure decompress(dest,src:buffer_ptr);

begin
	opos := 0;
	bitr := $80;
	ipos := 0;

	input := src;
	output := dest;

	decode_loop;

end;

end.
