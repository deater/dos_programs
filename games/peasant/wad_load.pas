{************************************}
{ wad_load                           }
{************************************}

Procedure wad_load(dest: buffer_ptr; name: string);

var
	fff : file;
	header : array[0..15] of byte;
	name2 : array[0..7] of byte;
	result, lumps, i, j : integer;
	read_size, offset : LongInt;
	match : byte;
	bytes_read : word;

label wad_name_found;
label done_wad_load;

begin
	writeln('Loading peasant.wad');

	assign(fff,'peasant.wad');

{$I-}
	reset(fff,1);		{ Check that file is there}
				{ sets blocksize to 1 }
{$I+}
	if IOresult<>0 then begin	{ Error if not}
		{ TODO }
		writeln('cannot access file');
	end;

	{ setup name }
	for i:=0 to 7 do begin
		name2[i]:=0;
	end;

	for i:=0 to length(name)-1 do begin
		name2[i]:=ord(name[i+1]);
	end;

	{ read in the header }
	blockread(fff,header,12,result);

	{ TODO : check if PWAD value }

	{ TODO: only support up to 64 lumps }
	lumps:=header[4]+(header[5] shl 8);

	offset:=header[8]+(header[9] shl 8)+
		(header[10] shl 16) + (header[11] shl 24);


	writeln('found ',lumps,' Lumps at address $',offset);

	{ TODO: seek to offset }

	seek(fff,offset);

	{ Find name }

	for i:=0 to (lumps-1) do begin

		blockread(fff,header,16);

		write('lump ',i,' ');

		match:=0;
		for j:=0 to 7 do begin
			if (chr(name2[j])=chr(header[8+j])) then begin
				match:=match+1;
				write(':MATCH:');
			end;
			write( chr(name2[j]), chr(header[8+j]),';');
		end;
		writeln(' match=',match);
		if match=8 then goto wad_name_found;

	end;

	goto done_wad_load;

wad_name_found:

	writeln('Found match for ',name);

	{ get offset }

	offset:=header[0]+(header[1] shl 8)+
		(header[2] shl 16) + (header[3] shl 24);

	{ get size }

	read_size:=header[4]+(header[5] shl 8)+
		(header[6] shl 16) + (header[7] shl 24);


	{ seek to offset }

	writeln('Seeking to offset ',offset,' size ',read_size);

	seek(fff,offset);

	{ Read File }

	writeln('Position ',FilePos(fff));
	writeln('Reading into dest');

	blockread(fff,dest^,read_size,bytes_read);

	writeln('bytes read: ',bytes_read);

	writeln('buffer[0]=',dest^[0]);
	writeln('buffer[1]=',dest^[1]);
	writeln('buffer[16]=',dest^[16]);

done_wad_load:

	writeln('Closing File');

	close(fff);

end;
