
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas

CC = gcc
CFLAGS = -O2 -Wall -g

all:	shrink_text \
	D_WELL.PAS   O_WELL.PAS \
	D_YTREE.PAS  O_YTREE.PAS \
	D_WFALL.PAS  O_WFALL.PAS \
	D_MUD.PAS    O_MUD.PAS \
	D_ARCH.PAS   O_ARCH.PAS \
	D_ROCK.PAS   O_ROCK.PAS \
	D_KNIGHT.PAS O_KNIGHT.PAS \
	D_COT.PAS   O_COT.PAS \
	D_WLAKE.PAS  O_WLAKE.PAS \
	D_ELAKE.PAS  O_ELAKE.PAS \
	D_INN.PAS    O_INN.PAS \
	D_WAVY.PAS   O_WAVY.PAS \
	D_KERREK.PAS O_KERREK.PAS \
	D_OLADY.PAS  O_OLADY.PAS \
	D_BTREE.PAS  O_BTREE.PAS \
	D_IINN.PAS   O_IINN.PAS \
	D_ILADY.PAS  O_ILADY.PAS \
	D_COMMON.PAS O_COMMON.PAS

############################################
############################################

O_WELL.PAS:	dialog_well.raw

D_WELL.PAS:	D_WELL.ZX2
	$(BIN2PAS) -l D_WELL D_WELL.ZX2 > D_WELL.PAS

D_WELL.ZX2:	dialog_well.raw
	$(ZX02) -f  dialog_well.raw D_WELL.ZX2

dialog_well.raw:	well.inc
	./shrink_text dialog_well.raw O_WELL.PAS well < well.inc

####

O_YTREE.PAS:	dialog_waterfall.raw

D_YTREE.PAS:	D_YTREE.ZX2
	$(BIN2PAS) -l D_YTREE D_YTREE.ZX2 > D_YTREE.PAS

D_YTREE.ZX2:	dialog_yellow_tree.raw
	$(ZX02) -f  dialog_yellow_tree.raw D_YTREE.ZX2

dialog_yellow_tree.raw:	yellow_tree.inc
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

O_MUD.PAS:	dialog_mud.raw

D_MUD.PAS:	D_MUD.ZX2
	$(BIN2PAS) -l D_MUD D_MUD.ZX2 > D_MUD.PAS

D_MUD.ZX2:	dialog_mud.raw
	$(ZX02) -f  dialog_mud.raw D_MUD.ZX2

dialog_mud.raw:	mud.inc
	./shrink_text dialog_mud.raw O_MUD.PAS mud < mud.inc

###
O_ARCH.PAS:	dialog_archery.raw

D_ARCH.PAS:	D_ARCH.ZX2
	$(BIN2PAS) -l D_ARCH D_ARCH.ZX2 > D_ARCH.PAS

D_ARCH.ZX2:	dialog_archery.raw
	$(ZX02) -f  dialog_archery.raw D_ARCH.ZX2

dialog_archery.raw:	archery.inc
	./shrink_text dialog_archery.raw O_ARCH.PAS archery < archery.inc

###

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

O_COT.PAS:	dialog_cottage.raw

D_COT.PAS:	D_COT.ZX2
	$(BIN2PAS) -l D_COT D_COT.ZX2 > D_COT.PAS

D_COT.ZX2:	dialog_cottage.raw
	$(ZX02) -f  dialog_cottage.raw D_COT.ZX2

dialog_cottage.raw:	cottage.inc
	./shrink_text dialog_cottage.raw O_COT.PAS cottage < cottage.inc

###

O_WLAKE.PAS:	dialog_lake_west.raw

D_WLAKE.PAS:	D_WLAKE.ZX2
	$(BIN2PAS) -l D_WLAKE D_WLAKE.ZX2 > D_WLAKE.PAS

D_WLAKE.ZX2:	dialog_lake_west.raw
	$(ZX02) -f  dialog_lake_west.raw D_WLAKE.ZX2

dialog_lake_west.raw:	lake_west.inc
	./shrink_text dialog_lake_west.raw O_WLAKE.PAS lake_west < lake_west.inc

#####

O_ELAKE.PAS:	dialog_lake_east.raw

D_ELAKE.PAS:	D_ELAKE.ZX2
	$(BIN2PAS) -l D_ELAKE D_ELAKE.ZX2 > D_ELAKE.PAS

D_ELAKE.ZX2:	dialog_lake_east.raw
	$(ZX02) -f  dialog_lake_east.raw D_ELAKE.ZX2

dialog_lake_east.raw:	lake_east.inc
	./shrink_text dialog_lake_east.raw O_ELAKE.PAS lake_east < lake_east.inc

#####

O_INN.PAS:	dialog_inn.raw

D_INN.PAS:	D_INN.ZX2
	$(BIN2PAS) -l D_INN D_INN.ZX2 > D_INN.PAS

D_INN.ZX2:	dialog_inn.raw
	$(ZX02) -f  dialog_inn.raw D_INN.ZX2

dialog_inn.raw:	outside_inn.inc
	./shrink_text dialog_inn.raw O_INN.PAS outside_inn < outside_inn.inc

############################################
############################################

O_WAVY.PAS:	dialog_wavy_tree.raw

D_WAVY.PAS:	D_WAVY.ZX2
	$(BIN2PAS) -l D_WAVY D_WAVY.ZX2 > D_WAVY.PAS

D_WAVY.ZX2:	dialog_wavy_tree.raw
	$(ZX02) -f  dialog_wavy_tree.raw D_WAVY.ZX2

dialog_wavy_tree.raw:	wavy_tree.inc
	./shrink_text dialog_wavy_tree.raw O_WAVY.PAS wavy_tree < wavy_tree.inc


####
O_KERREK.PAS:	dialog_kerrek.raw

D_KERREK.PAS:	D_KERREK.ZX2
	$(BIN2PAS) -l D_KERREK D_KERREK.ZX2 > D_KERREK.PAS

D_KERREK.ZX2:	dialog_kerrek.raw
	$(ZX02) -f  dialog_kerrek.raw D_KERREK.ZX2

dialog_kerrek.raw:	kerrek.inc
	./shrink_text dialog_kerrek.raw O_KERREK.PAS kerrek < kerrek.inc

####

O_OLADY.PAS:	dialog_lady_cottage.raw

D_OLADY.PAS:	D_OLADY.ZX2
	$(BIN2PAS) -l D_OLADY D_OLADY.ZX2 > D_OLADY.PAS

D_OLADY.ZX2:	dialog_lady_cottage.raw
	$(ZX02) -f  dialog_lady_cottage.raw D_OLADY.ZX2

dialog_lady_cottage.raw:	lady_cottage.inc
	./shrink_text dialog_lady_cottage.raw O_OLADY.PAS lady_cottage < lady_cottage.inc

###

O_BTREE.PAS:	dialog_burninated_tree.raw

D_BTREE.PAS:	D_BTREE.ZX2
	$(BIN2PAS) -l D_BTREE D_BTREE.ZX2 > D_BTREE.PAS

D_BTREE.ZX2:	dialog_burninated_tree.raw
	$(ZX02) -f  dialog_burninated_tree.raw D_BTREE.ZX2

dialog_burninated_tree.raw:	burninated_tree.inc
	./shrink_text dialog_burninated_tree.raw O_BTREE.PAS burninated_tree < burninated_tree.inc


############################################
############################################

O_IINN.PAS:	dialog_inside_inn.raw

D_IINN.PAS:	D_IINN.ZX2
	$(BIN2PAS) -l D_IINN D_IINN.ZX2 > D_IINN.PAS

D_IINN.ZX2:	dialog_inside_inn.raw
	$(ZX02) -f  dialog_inside_inn.raw D_IINN.ZX2

dialog_inside_inn.raw:	inside_inn.inc
	./shrink_text dialog_inside_inn.raw O_IINN.PAS inside_inn < inside_inn.inc

###

O_ILADY.PAS:	dialog_inside_lady.raw

D_ILADY.PAS:	D_ILADY.ZX2
	$(BIN2PAS) -l D_ILADY D_ILADY.ZX2 > D_ILADY.PAS

D_ILADY.ZX2:	dialog_inside_lady.raw
	$(ZX02) -f  dialog_inside_lady.raw D_ILADY.ZX2

dialog_inside_lady.raw:	inside_lady.inc
	./shrink_text dialog_inside_lady.raw O_ILADY.PAS inside_lady < inside_lady.inc


############################################
############################################

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
