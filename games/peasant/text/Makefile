
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas

CC = gcc
CFLAGS = -O2 -Wall -g

all:	shrink_text \
	D_YTREE.PAS  O_YTREE.PAS \
	D_WFALL.PAS  O_WFALL.PAS \
	D_ROCK.PAS   O_ROCK.PAS \
	D_KNIGHT.PAS O_KNIGHT.PAS \
	D_INN.PAS    O_INN.PAS \
	D_BTREE.PAS    O_BTREE.PAS \
	D_COMMON.PAS O_COMMON.PAS


#	DIALOG_NED_COTTAGE.ZX02 dialog_ned_cottage.inc \
#	DIALOG_WAVY_TREE.ZX02 dialog_wavy_tree.inc \
#	DIALOG_LADY_COTTAGE.ZX02 dialog_lady_cottage.inc \
#	DIALOG_KERREK2.ZX02 dialog_kerrek2.inc \
#	DIALOG_BURNINATED_TREE.ZX02 dialog_burninated_tree.inc \
#	DIALOG_JHONKA.ZX02 dialog_jhonka.inc \
#	DIALOG_COTTAGE.ZX02 dialog_cottage.inc \
#	DIALOG_LAKE_WEST.ZX02 dialog_lake_west.inc \
#	DIALOG_LAKE_EAST.ZX02 dialog_lake_east.inc \
#	DIALOG_OUTSIDE_INN.ZX02 dialog_outside_inn.inc \
#	DIALOG_GARY.ZX02 dialog_gary.inc \
#	DIALOG_KERREK1.ZX02 dialog_kerrek1.inc \
#	DIALOG_WELL.ZX02 dialog_well.inc \
#	DIALOG_YELLOW_TREE.ZX02 dialog_yellow_tree.inc \
#	DIALOG_WATERFALL.ZX02 dialog_waterfall.inc \
#	DIALOG_PUDDLE.ZX02 dialog_puddle.inc \
#	DIALOG_HAYSTACK.ZX02 dialog_haystack.inc \
#	DIALOG_BROTHERS.ZX02 dialog_brothers.inc \
#	DIALOG_RIVER.ZX02 dialog_river.inc \
#	DIALOG_KNIGHT.ZX02 dialog_knight.inc \
#	DIALOG_INSIDE_LADY.ZX02 dialog_inside_lady.inc \
#	DIALOG_INSIDE_NED.ZX02 dialog_inside_ned.inc \
#	DIALOG_HIDDEN_GLEN.ZX02 dialog_hidden_glen.inc \
#	DIALOG_INSIDE_INN.ZX02 dialog_inside_inn.inc \
#	DIALOG_INSIDE_INN_NIGHT.ZX02 dialog_inside_inn_night.inc \
#	DIALOG_CLIFF_BASE.ZX02 dialog_cliff_base.inc \
#	DIALOG_CLIFF_HEIGHTS.ZX02 dialog_cliff_heights.inc \
#	DIALOG_OUTER1.ZX02 dialog_outer1.inc \
#	DIALOG_OUTER2.ZX02 dialog_outer2.inc \
#	DIALOG_OUTER3.ZX02 dialog_outer3.inc \
#	DIALOG_TROGDOR.ZX02 dialog_trogdor.inc \
#	DIALOG_CLIMB.ZX02 dialog_climb.inc \
#	common.inc.lookup \
#	inventory.inc.lookup


############################################
############################################

O_YTREE.PAS:	dialog_waterfall.raw

D_YTREE.PAS:	D_YTREE.ZX2
	$(BIN2PAS) -l D_YTREE D_YTREE.ZX2 > D_YTREE.PAS

D_YTREE.ZX2:	dialog_yellow_tree.raw
	$(ZX02) -f  dialog_yellow_tree.raw D_YTREE.ZX2

dialog_yellow_tree.raw:	falls.inc
	./shrink_text dialog_yellow_tree.raw O_YTREE.PAS yellow_tree < yellow_tree.inc

####

O_WFALL.PAS:	dialog_waterfall.raw

D_WFALL.PAS:	D_WFALL.ZX2
	$(BIN2PAS) -l D_WFALL D_WFALL.ZX2 > D_WFALL.PAS

D_WFALL.ZX2:	dialog_waterfall.raw
	$(ZX02) -f  dialog_waterfall.raw D_WFALL.ZX2

dialog_waterfall.raw:	falls.inc
	./shrink_text dialog_waterfall.raw O_WFALL.PAS waterfall < falls.inc


############################################
############################################

O_ROCK.PAS:	dialog_rock.raw

D_ROCK.PAS:	D_ROCK.ZX2
	$(BIN2PAS) -l D_ROCK D_ROCK.ZX2 > D_ROCK.PAS

D_ROCK.ZX2:	dialog_rock.raw
	$(ZX02) -f  dialog_rock.raw D_ROCK.ZX2

dialog_rock.raw:	rock.inc
	./shrink_text dialog_rock.raw O_ROCK.PAS rock < rock.inc

#####

O_KNIGHT.PAS:	dialog_knight.raw

D_KNIGHT.PAS:	D_KNIGHT.ZX2
	$(BIN2PAS) -l D_KNIGHT D_KNIGHT.ZX2 > D_KNIGHT.PAS

D_KNIGHT.ZX2:	dialog_knight.raw
	$(ZX02) -f  dialog_knight.raw D_KNIGHT.ZX2

dialog_knight.raw:	knight.inc
	./shrink_text dialog_knight.raw O_KNIGHT.PAS knight < knight.inc

############################################
############################################

O_INN.PAS:	dialog_inn.raw

D_INN.PAS:	D_INN.ZX2
	$(BIN2PAS) -l D_INN D_INN.ZX2 > D_INN.PAS

D_INN.ZX2:	dialog_inn.raw
	$(ZX02) -f  dialog_inn.raw D_INN.ZX2

dialog_inn.raw:	outside_inn.inc
	./shrink_text dialog_inn.raw O_INN.PAS outside_inn < outside_inn.inc

############################################
############################################

O_BTREE.PAS:	dialog_burninated_tree.raw

D_BTREE.PAS:	D_BTREE.ZX2
	$(BIN2PAS) -l D_BTREE D_BTREE.ZX2 > D_BTREE.PAS

D_BTREE.ZX2:	dialog_burninated_tree.raw
	$(ZX02) -f  dialog_burninated_tree.raw D_BTREE.ZX2

dialog_burninated_tree.raw:	burninated_tree.inc
	./shrink_text dialog_burninated_tree.raw O_BTREE.PAS burninated_tree < burninated_tree.inc





####

O_COMMON.PAS:	dialog_common.raw

D_COMMON.PAS:	D_COMMON.ZX2
	$(BIN2PAS) -l D_COMMON D_COMMON.ZX2 > D_COMMON.PAS

D_COMMON.ZX2:	dialog_common.raw
	$(ZX02) -f  dialog_common.raw D_COMMON.ZX2

dialog_common.raw:	common.inc
	./shrink_text dialog_common.raw O_COMMON.PAS common < common.inc

###

clean:	
	rm -f *.o *~ dump_text shrink_text *.lookup *.ZX2

distclean:	
	rm -f *.o *~ dump_text shrink_text *.lookup *.ZX2 *.raw D_*.PAS O_*.PAS
