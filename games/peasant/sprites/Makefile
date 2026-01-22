CGA_SPRITE = ../../../utils/cga-utils/cga_make_sprite
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
LINKER_SCRIPTS = ../../../linker_scripts

all:	walk_sprites.inc


walk_sprites.inc:     walk_sprites.png
	$(CGA_SPRITE) -l walk_r0_sprite walk_sprites.png  14  32  27  62 > walk_sprites.inc
	$(CGA_SPRITE) -l walk_r0_mask   walk_sprites.png  14  63  27  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r1_sprite walk_sprites.png  42  32  53  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r1_mask   walk_sprites.png  42  63  53  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r2_sprite walk_sprites.png  70  32  83  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r2_mask   walk_sprites.png  70  63  83  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r3_sprite walk_sprites.png  98  32 111  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r3_mask   walk_sprites.png  98  63 111  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r4_sprite walk_sprites.png 126  32 139  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r4_mask   walk_sprites.png 126  63 139  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r5_sprite walk_sprites.png 154  32 167  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_r5_mask   walk_sprites.png 154  63 167  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l0_sprite walk_sprites.png  14 128  27 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l0_mask   walk_sprites.png  14 159  27 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l1_sprite walk_sprites.png  42 128  53 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l1_mask   walk_sprites.png  42 159  53 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l2_sprite walk_sprites.png  70 128  83 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l2_mask   walk_sprites.png  70 159  83 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l3_sprite walk_sprites.png  98 128 111 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l3_mask   walk_sprites.png  98 159 111 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l4_sprite walk_sprites.png 126 128 139 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l4_mask   walk_sprites.png 126 159 139 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l5_sprite walk_sprites.png 154 128 167 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_l5_mask   walk_sprites.png 154 159 167 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u0_sprite walk_sprites.png 182   1 195  31 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u0_mask   walk_sprites.png 183  32 195  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u1_sprite walk_sprites.png 210   1 221  31 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u1_mask   walk_sprites.png 210  32 223  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u2_sprite walk_sprites.png 238   1 251  31 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u2_mask   walk_sprites.png 238  32 251  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u3_sprite walk_sprites.png 266   1 279  31 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u3_mask   walk_sprites.png 266  32 279  62 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u4_sprite walk_sprites.png 182  63 195  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u4_mask   walk_sprites.png 182  94 195 124 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u5_sprite walk_sprites.png 210  63 223  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_u5_mask   walk_sprites.png 210  94 223 124 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d0_sprite walk_sprites.png 238  63 251  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d0_mask   walk_sprites.png 238  94 251 124 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d1_sprite walk_sprites.png 266  63 279  93 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d1_mask   walk_sprites.png 266  94 279 124 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d2_sprite walk_sprites.png 182 128 195 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d2_mask   walk_sprites.png 182 159 195 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d3_sprite walk_sprites.png 210 128 223 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d3_mask   walk_sprites.png 210 159 223 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d4_sprite walk_sprites.png 238 128 251 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d4_mask   walk_sprites.png 238 159 251 189 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d5_sprite walk_sprites.png 266 128 279 158 >> walk_sprites.inc
	$(CGA_SPRITE) -l walk_d5_mask   walk_sprites.png 266 159 279 189 >> walk_sprites.inc

clean:	
	rm -f *~ *.zx02 \
		walk_sprites.inc

distclean:
	make clean
