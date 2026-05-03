
Procedure show_inventory;

var
	x,y: Integer;

begin
	Rectangle(30,24,290,128,255,@screen);
        Hline(34,286,28,$AA,@screen);
        Hline(34,286,128-4,$AA,@screen);
        Vline(28,128-2,34,$EB,@screen);
        Vline(28,128-2,282,$EB,@screen);

        { print text }

	{ 4...12 }
	for x:=0 to 1 do begin
		for y:=0 to 8 do begin
			PrintStringXor('???',5+(x*14),4+y);
		end;
	end;


	PrintStringXor('Press ENTER for description',6,13);
	PrintStringXor('Press ESC or BACKSPACE to exit',5,14);

	repeat until keypressed;
	ch:=readkey;

end;
