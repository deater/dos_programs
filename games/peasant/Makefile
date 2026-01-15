PNG2CGA = ../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../utils/pas-utils/bin2pas

all:	peasant.img

###

peasant.img:	PEASANT.EXE
	cp ../../disk_images/freedos.boot.disk.360K.img peasant.img
	mcopy -i peasant.img PEASANT.EXE ::PEASANT.EXE

###

PEASANT.EXE:	peasant.pas zx02.pas \
	graphics/PQ_KER1.PAS graphics/PQ_KNGHT.PAS
	cp peasant.pas zx02.pas /home/vince/dos/dos/TP
	cp graphics/PQ_KER1.PAS graphics/PQ_KNGHT.PAS /home/vince/dos/dos/TP
	dosbox -conf build.conf
	cp /home/vince/dos/dos/TP/PEASANT.EXE .

###

clean:	
	rm -f PEASANT.EXE
