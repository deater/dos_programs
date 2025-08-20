PNG2CGA = ../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../utils/pas-utils/bin2pas

all:	peasant.img

peasant.img:	PEASANT.EXE
	cp ../../disk_images/freedos.boot.disk.360K.img peasant.img
	mcopy -i peasant.img PEASANT.EXE ::PEASANT.EXE

PEASANT.EXE:	peasant.pas IMAGE.PAS zx02.pas
	cp peasant.pas IMAGE.PAS zx02.pas /home/vince/dos/dos/TP
	dosbox -conf build.conf
	cp /home/vince/dos/dos/TP/PEASANT.EXE .

IMAGE.PAS:	pq_cga.zx02
	$(BIN2PAS) -l IMAGEDATA pq_cga.zx02 > IMAGE.PAS

pq_cga.zx02:	pq_cga.cga
	$(ZX02) -f pq_cga.cga pq_cga.zx02

pq_cga.cga:	pq_cga.png
	$(PNG2CGA) -r ./pq_cga.png > pq_cga.cga


clean:	
	rm -f IMAGE.PAS PEASANT.EXE
