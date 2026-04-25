program test2;

uses crt;

type
        buffer = Array [0..16383] of byte;
        buffer_ptr = ^buffer;

var
	input_buffer  : string;
	ch,ch2 : char;

	i : integer;

	file_buffer : buffer_ptr;

{$I wad_load.pas}

begin
	GetMem(file_buffer,4096);

	writeln('Testing loading GNKIGHT from WAD');

	wad_load(file_buffer,'GKNIGHT');

	writeln('after load');

	for i:=0 to 128 do begin
		write(file_buffer^[i],',');
	end;

	writeln;

(*
	while(true) do begin

		repeat until keypressed;

		ch:=readkey;

		if (ch=chr(8)) then begin
			writeln('deleting ',input_buffer[Length(input_buffer)]);
			Delete(input_buffer,Length(input_buffer),1);
			writeln('buffer: ',input_buffer);
		end
		else if (ch=chr(13)) then begin
			Delete(input_buffer,1,Length(input_buffer));
		end
		else begin
			input_buffer:=input_buffer+ch;
		end;

		writeln('buffer: ',Length(input_buffer),' ',input_buffer);

	end;
*)

end.
