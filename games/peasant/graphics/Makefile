PNG2CGA = ../../../utils/cga-utils/png2cga
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas


all:	PQ_KER1.PAS PQ_KNGHT.PAS PQ_YTREE.PAS

####

PQ_KER1.PAS:	pq_ker1.zx02
	$(BIN2PAS) -l PQ_KERREK1 pq_ker1.zx02 > PQ_KER1.PAS

pq_ker1.zx02:	pq_ker1.cga
	$(ZX02) -f pq_ker1.cga pq_ker1.zx02

pq_ker1.cga:	pq_ker1.png
	$(PNG2CGA) -r ./pq_ker1.png > pq_ker1.cga


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



clean:	
	rm -f *.PAS
