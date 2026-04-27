PNG2CGA = ../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../utils/pas-utils/bin2pas
TPDIR = /home/vince/dos/dos/TP

all:	peasant.img

###

peasant.img:	PEASANT.EXE
	cp ../../disk_images/freedos.boot.disk.360K.img peasant.img
	mcopy -i peasant.img PEASANT.EXE ::PEASANT.EXE
	mcopy -i peasant.img graphics/PEASANT.WAD ::PEASANT.WAD


###

TEST.EXE:	test.pas
	cp test.pas $(TPDIR)
	dosbox -conf test.conf


###

PEASANT.EXE:	peasant.pas zx02.pas cga.pas \
	graphics/PQ_VID.PAS graphics/PQ_TITLE.PAS \
	sprites/s_walk.pas
	cp peasant.pas zx02.pas cga.pas $(TPDIR)
	cp wad_load.pas $(TPDIR)
	cp lytree.pas lwfall.pas $(TPDIR)
	cp lriver.pas lknight.pas $(TPDIR)
	cp lelake.pas linn.pas $(TPDIR)
	cp lolady.pas lbtree.pas $(TPDIR)
	cp test2.pas $(TPDIR)
	cp graphics/PQ_VID.PAS $(TPDIR)
	cp graphics/PQ_TITLE.PAS $(TPDIR)
	cp graphics/PQ_TIPS.PAS $(TPDIR)
	cp graphics/PEASANT.WAD $(TPDIR)
	cp sprites/s_walk.pas $(TPDIR)
	cp text/dialog_t.pas $(TPDIR)
	cp text/O_YTREE.PAS $(TPDIR)
	cp text/O_WFALL.PAS $(TPDIR)
	cp text/O_ROCK.PAS $(TPDIR)
	cp text/O_KNIGHT.PAS $(TPDIR)
	cp text/O_ELAKE.PAS $(TPDIR)
	cp text/O_INN.PAS $(TPDIR)
	cp text/O_OLADY.PAS $(TPDIR)
	cp text/O_BTREE.PAS $(TPDIR)
	cp text/D_COMMON.PAS $(TPDIR)
	cp text/O_COMMON.PAS $(TPDIR)
	dosbox -conf build.conf
	cp $(TPDIR)/PEASANT.EXE .

#	cp graphics/PQ_INN.PAS $(TPDIR)
#	cp graphics/PQ_KER1.PAS $(TPDIR)
#	cp graphics/PQ_YTREE.PAS $(TPDIR)


###

clean:	
	rm -f *~ PEASANT.EXE
