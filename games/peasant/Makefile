PNG2CGA = ../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../utils/pas-utils/bin2pas
TPDIR = /home/vince/dos/dos/TP

all:	peasant.img

###

peasant.img:	PEASANT.EXE
	cp ../../disk_images/freedos.boot.disk.360K.img peasant.img
	mcopy -i peasant.img PEASANT.EXE ::PEASANT.EXE

###

PEASANT.EXE:	peasant.pas zx02.pas \
	graphics/PQ_INN.PAS \
	graphics/PQ_KER1.PAS graphics/PQ_KNGHT.PAS graphics/PQ_YTREE.PAS
	cp peasant.pas zx02.pas $(TPDIR)
	cp graphics/PQ_INN.PAS $(TPDIR)
	cp graphics/PQ_KER1.PAS $(TPDIR)
	cp graphics/PQ_KNGHT.PAS $(TPDIR)
	cp graphics/PQ_YTREE.PAS $(TPDIR)
	dosbox -conf build.conf
	cp $(TPDIR)/PEASANT.EXE .

###

clean:	
	rm -f PEASANT.EXE
