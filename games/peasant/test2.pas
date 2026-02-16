program test2;

uses crt;

var 
	input_buffer  : string;
	ch,ch2 : char;

begin



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

end.
