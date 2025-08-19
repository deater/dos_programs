PNG2CGA = ../../utils/cga-utils/png2cga -p ./pq_cga.png

all:	IMAGE.PAS

IMAGE.PAS:	pq_cga.png
	$(PNG2CGA) -p ./pq_cga.png > IMAGE.PAS


clean:	
	rm -f IMAGE.PAS
