CGA_SPRITE = ../../../utils/cga-utils/cga_make_sprite
CGA_SPRITE_MASK = ../../../utils/cga-utils/cga_make_sprite_mask
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPTS = ../../../linker_scripts

all:	s_walk.pas

s_walk.pas:     walk_sprites.png
	$(CGA_SPRITE_MASK) -s -l walk_r0_sprite walk_sprites.png \
			8   32   23  62       8  63   23  93 > s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_r1_sprite walk_sprites.png \
			32  32   47  62      32  63   47  93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_r2_sprite walk_sprites.png \
			56  32   71  62      56  63   71  93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_r3_sprite walk_sprites.png \
			80  32   95  62      80  63   95  93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_r4_sprite walk_sprites.png \
			104 32  119  62     104  63  119  93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_r5_sprite walk_sprites.png \
			128 32  143  62     128  63  143  93 >> s_walk.pas

	$(CGA_SPRITE_MASK) -s -l walk_l0_sprite walk_sprites.png \
			8   128   23  158       8  159   23  189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_l1_sprite walk_sprites.png \
			32  128   47  158      32  159   47  189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_l2_sprite walk_sprites.png \
			56  128   71  158      56  159   71  189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_l3_sprite walk_sprites.png \
			80  128   95  158      80  159   95  189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_l4_sprite walk_sprites.png \
			104 128  119  158     104  159  119  189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_l5_sprite walk_sprites.png \
			128 128  143  158     128  159  143  189 >> s_walk.pas

	$(CGA_SPRITE_MASK) -s -l walk_u0_sprite walk_sprites.png \
			160 32 175 62     160 63 175 93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_u1_sprite walk_sprites.png \
			184 32 199 62     184 63 199 93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_u2_sprite walk_sprites.png \
			208 32 223 62     208 63 223 93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_u3_sprite walk_sprites.png \
			232 32 247 62     232 63 247 93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_u4_sprite walk_sprites.png \
			256 32 271 62     256 63 271 93 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_u5_sprite walk_sprites.png \
			280 32 295 62     280 63 295 93 >> s_walk.pas

	$(CGA_SPRITE_MASK) -s -l walk_d0_sprite walk_sprites.png \
			160 128 175 158     160 159 175 189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_d1_sprite walk_sprites.png \
			184 128 199 158     184 159 199 189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_d2_sprite walk_sprites.png \
			208 128 223 158     208 159 223 189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_d3_sprite walk_sprites.png \
			232 128 247 158     232 159 247 189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_d4_sprite walk_sprites.png \
			256 128 271 158     256 159 271 189 >> s_walk.pas
	$(CGA_SPRITE_MASK) -s -l walk_d5_sprite walk_sprites.png \
			280 128 295 158     280 159 295 189 >> s_walk.pas

clean:	
	rm -f *~ *.zx02 \
		s_walk.pas

distclean:
	make clean
