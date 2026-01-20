PNG2CGA = ../../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas


all:	PQ_VID.PAS PQ_TITLE.PAS \
	PQ_WFALL.PAS PQ_KNGHT.PAS PQ_INN.PAS \
	PQ_YTREE.PAS PQ_ROCK.PAS \
	PQ_KER1.PAS

####

PQ_VID.PAS:	pq_videlectrix.zx02
	$(BIN2PAS) -l PQ_VID pq_videlectrix.zx02 > PQ_VID.PAS

pq_videlectrix.zx02:	pq_videlectrix.cga
	$(ZX02) -f pq_videlectrix.cga pq_videlectrix.zx02

pq_videlectrix.cga:	pq_videlectrix.png
	$(PNG2CGA) -r ./pq_videlectrix.png > pq_videlectrix.cga


####

PQ_TITLE.PAS:	pq_title.zx02
	$(BIN2PAS) -l PQ_TITLE pq_title.zx02 > PQ_TITLE.PAS

pq_title.zx02:	pq_title.cga
	$(ZX02) -f pq_title.cga pq_title.zx02

pq_title.cga:	pq_title.png
	$(PNG2CGA) -r ./pq_title.png > pq_title.cga

####

PQ_INN.PAS:	pq_inn.zx02
	$(BIN2PAS) -l PQ_INN pq_inn.zx02 > PQ_INN.PAS

pq_inn.zx02:	pq_inn.cga
	$(ZX02) -f pq_inn.cga pq_inn.zx02

pq_inn.cga:	pq_inn.png
	$(PNG2CGA) -r ./pq_inn.png > pq_inn.cga


####

PQ_KER1.PAS:	pq_ker1.zx02
	$(BIN2PAS) -l PQ_KERREK1 pq_ker1.zx02 > PQ_KER1.PAS

pq_ker1.zx02:	pq_ker1.cga
	$(ZX02) -f pq_ker1.cga pq_ker1.zx02

pq_ker1.cga:	pq_ker1.png
	$(PNG2CGA) -r ./pq_ker1.png > pq_ker1.cga


####

PQ_WFALL.PAS:	pq_waterfall.zx02
	$(BIN2PAS) -l PQ_WFALL pq_waterfall.zx02 > PQ_WFALL.PAS

pq_waterfall.zx02:	pq_waterfall.cga
	$(ZX02) -f pq_waterfall.cga pq_waterfall.zx02

pq_waterfall.cga:	pq_waterfall.png
	$(PNG2CGA) -r ./pq_waterfall.png > pq_waterfall.cga

####

PQ_KNGHT.PAS:	pq_knight.zx02
	$(BIN2PAS) -l PQ_KNIGHT pq_knight.zx02 > PQ_KNGHT.PAS

pq_knight.zx02:	pq_knight.cga
	$(ZX02) -f pq_knight.cga pq_knight.zx02

pq_knight.cga:	pq_knight.png
	$(PNG2CGA) -r ./pq_knight.png > pq_knight.cga

####

PQ_YTREE.PAS:	pq_ytree.zx02
	$(BIN2PAS) -l PQ_YTREE pq_ytree.zx02 > PQ_YTREE.PAS

pq_ytree.zx02:	pq_ytree.cga
	$(ZX02) -f pq_ytree.cga pq_ytree.zx02

pq_ytree.cga:	pq_ytree.png
	$(PNG2CGA) -r ./pq_ytree.png > pq_ytree.cga

####

PQ_ROCK.PAS:	pq_rock.zx02
	$(BIN2PAS) -l PQ_ROCK pq_rock.zx02 > PQ_ROCK.PAS

pq_rock.zx02:	pq_rock.cga
	$(ZX02) -f pq_rock.cga pq_rock.zx02

pq_rock.cga:	pq_rock.png
	$(PNG2CGA) -r ./pq_rock.png > pq_rock.cga


####



clean:	
	rm -f *.PAS
