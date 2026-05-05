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

PEASANT.EXE:	peasant.pas zx02_asm.pas cga.pas \
	inv.pas \
	graphics/PQ_VID.PAS graphics/PQ_TITLE.PAS \
	lwell.pas lytree.pas lwfall.pas \
	larch.pas lriver.pas lknight.pas \
	lwlake.pas lelake.pas linn.pas \
	lkerrek2.pas lolady.pas lbtree.pas \
	liinn.pas lilady.pas
	cp peasant.pas zx02_asm.pas cga.pas inv.pas $(TPDIR)
	cp wad_load.pas $(TPDIR)
	cp lwell.pas lytree.pas lwfall.pas $(TPDIR)
	cp larch.pas lriver.pas lknight.pas $(TPDIR)
	cp lwlake.pas lelake.pas linn.pas $(TPDIR)
	cp lkerrek2.pas lolady.pas lbtree.pas $(TPDIR)
	cp liinn.pas lilady.pas $(TPDIR)
	cp lunknown.pas $(TPDIR)
	cp test2.pas $(TPDIR)
	cp graphics/PQ_VID.PAS $(TPDIR)
	cp graphics/PQ_TITLE.PAS $(TPDIR)
	cp graphics/PQ_TIPS.PAS $(TPDIR)
	cp graphics/PEASANT.WAD $(TPDIR)
	cp text/dialog_t.pas $(TPDIR)
	cp text/O_WELL.PAS $(TPDIR)
	cp text/O_YTREE.PAS $(TPDIR)
	cp text/O_WFALL.PAS $(TPDIR)
	cp text/O_ARCH.PAS $(TPDIR)
	cp text/O_ROCK.PAS $(TPDIR)
	cp text/O_KNIGHT.PAS $(TPDIR)
	cp text/O_WLAKE.PAS $(TPDIR)
	cp text/O_ELAKE.PAS $(TPDIR)
	cp text/O_INN.PAS $(TPDIR)
	cp text/O_KERREK.PAS $(TPDIR)
	cp text/O_OLADY.PAS $(TPDIR)
	cp text/O_BTREE.PAS $(TPDIR)
	cp text/O_IINN.PAS $(TPDIR)
	cp text/O_ILADY.PAS $(TPDIR)
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
