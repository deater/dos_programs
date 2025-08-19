PNG2CGA = ../../utils/cga-utils/png2cga -p ./pq_cga.png

all:	peasant.img

peasant.img:	PEASANT.EXE
	cp ../../disk_images/freedos.boot.disk.360K.img peasant.img
	mcopy -i peasant.img PEASANT.EXE ::PEASANT.EXE

PEASANT.EXE:	peasant.pas IMAGE.PAS
	cp peasant.pas IMAGE.PAS /home/vince/dos/dos/TP
	dosbox -conf build.conf
	cp /home/vince/dos/dos/TP/PEASANT.EXE .

IMAGE.PAS:	pq_cga.png
	$(PNG2CGA) -p ./pq_cga.png > IMAGE.PAS


clean:	
	rm -f IMAGE.PAS PEASANT.EXE
