
Procedure show_inventory;


const item_string : array [0..18] of string [20] = (
	'arrow',
	'baby',
	'kerrek belt',
	'chicken feed',
	'SuperTime FunBow TM',
	'monster maskus',
	'pebbles',
	'pills',
	'riches',
	'robe',
	'soda',
	'meatball sub',
	'super trinket',
	'TrogHelmet',
	'TrogShield',
	'TrogSword',
	'???',
	'shirt',
	'map'
);

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
			if inventory[(x*9)+y]=true then begin
				PrintStringXor(item_string[(x*9)+y],
					6+(x*16),4+y);
			end
			else begin
				PrintStringXor('???',6+(x*16),4+y);
			end;
		end;
	end;


	PrintStringXor('Press ENTER for description',6,13);
	PrintStringXor('Press ESC or BACKSPACE to exit',5,14);

	repeat until keypressed;
	ch:=readkey;

	{ refresh background }

        screen_update(@screen,screen_ptr(background));

end;
