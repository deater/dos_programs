PNG2CGA = ../../../utils/cga-utils/png2cga
PNG2COLLISION = ../../../utils/cga-utils/png2collision
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas
MKWAD = ../../../utils/disk-utils/mkwad

all:	PEASANT.WAD \
	PQ_VID.PAS PQ_TITLE.PAS PQ_TIPS.PAS

#	PQ_WFALL.PAS PQ_KNGHT.PAS PQ_INN.PAS \
#	PQ_YTREE.PAS PQ_ROCK.PAS \
#	PQ_KER1.PAS PQ_TIPS.PAS

####

PEASANT.WAD:	\
	pq_ytree.zx02     ../text/D_YTREE.ZX2 \
	pq_waterfall.zx02 ../text/D_WFALL.ZX2 waterfall_priority.zx02 \
	pq_rock.zx02      ../text/D_ROCK.ZX2 \
	pq_knight.zx02    ../text/D_KNIGHT.ZX2 knight_priority.zx02 \
	pq_e_lake.zx02    ../text/D_ELAKE.ZX2 \
	pq_inn.zx02       ../text/D_INN.ZX2 \
	pq_hut.zx02       ../text/D_OLADY.ZX2 \
	pq_btree.zx02     ../text/D_BTREE.ZX2
	$(MKWAD) -o PEASANT.WAD \
		pq_ytree.zx02,GYTREE ../text/D_YTREE.ZX2,DYTREE \
		pq_waterfall.zx02,GWFALL ../text/D_WFALL.ZX2,DWFALL \
		waterfall_priority.zx02,PWFALL \
		pq_rock.zx02,GROCK ../text/D_ROCK.ZX2,DROCK \
		pq_knight.zx02,GKNIGHT ../text/D_KNIGHT.ZX2,DKNIGHT \
		knight_priority.zx02,PKNIGHT \
		pq_e_lake.zx02,GELAKE ../text/D_ELAKE.ZX2,DELAKE \
		pq_inn.zx02,GINN ../text/D_INN.ZX2,DINN \
		pq_hut.zx02,GOLADY ../text/D_OLADY.ZX2,DOLADY \
		pq_btree.zx02,GBTREE ../text/D_BTREE.ZX2,DBTREE


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

PQ_TIPS.PAS:	pq_tips.zx02
	$(BIN2PAS) -l PQ_TIPS pq_tips.zx02 > PQ_TIPS.PAS

pq_tips.zx02:	pq_tips.cga
	$(ZX02) -f pq_tips.cga pq_tips.zx02

pq_tips.cga:	pq_tips.png
	$(PNG2CGA) -r ./pq_tips.png > pq_tips.cga

#################################################
#################################################

PQ_YTREE.PAS:	pq_ytree.zx02
	$(BIN2PAS) -l PQ_YTREE pq_ytree.zx02 > PQ_YTREE.PAS

pq_ytree.zx02:	pq_ytree.cga
	$(ZX02) -f pq_ytree.cga pq_ytree.zx02

pq_ytree.cga:	pq_ytree.png
	$(PNG2CGA) -r ./pq_ytree.png > pq_ytree.cga

####

PQ_WFALL.PAS:	pq_waterfall.zx02
	$(BIN2PAS) -l PQ_WFALL pq_waterfall.zx02 > PQ_WFALL.PAS

pq_waterfall.zx02:	pq_waterfall.cga
	$(ZX02) -f pq_waterfall.cga pq_waterfall.zx02

pq_waterfall.cga:	pq_waterfall.png
	$(PNG2CGA) -r ./pq_waterfall.png > pq_waterfall.cga

waterfall_priority.zx02:	waterfall_priority.combined
	$(ZX02) -f waterfall_priority.combined waterfall_priority.zx02

waterfall_priority.combined:	waterfall_priority.png waterfall_collision.png
	$(PNG2COLLISION) waterfall_collision.png waterfall_priority.png waterfall_priority.combined

#################################################
#################################################

PQ_ROCK.PAS:	pq_rock.zx02
	$(BIN2PAS) -l PQ_ROCK pq_rock.zx02 > PQ_ROCK.PAS

pq_rock.zx02:	pq_rock.cga
	$(ZX02) -f pq_rock.cga pq_rock.zx02

pq_rock.cga:	pq_rock.png
	$(PNG2CGA) -r ./pq_rock.png > pq_rock.cga

###

PQ_KNGHT.PAS:	pq_knight.zx02
	$(BIN2PAS) -l PQ_KNIGHT pq_knight.zx02 > PQ_KNGHT.PAS

pq_knight.zx02:	pq_knight.cga
	$(ZX02) -f pq_knight.cga pq_knight.zx02

pq_knight.cga:	pq_knight.png
	$(PNG2CGA) -r ./pq_knight.png > pq_knight.cga

knight_priority.zx02:	knight_priority.combined
	$(ZX02) -f knight_priority.combined knight_priority.zx02

knight_priority.combined:	knight_priority.png knight_collision.png
	$(PNG2COLLISION) knight_collision.png knight_priority.png knight_priority.combined



#################################################
#################################################

PQ_ELAKE.PAS:	pq_e_lake.zx02
	$(BIN2PAS) -l PQ_ELAKE pq_e_lake.zx02 > PQ_ELAKE.PAS

pq_e_lake.zx02:	pq_e_lake.cga
	$(ZX02) -f pq_e_lake.cga pq_e_lake.zx02

pq_e_lake.cga:	pq_e_lake.png
	$(PNG2CGA) -r ./pq_e_lake.png > pq_e_lake.cga

###

PQ_INN.PAS:	pq_inn.zx02
	$(BIN2PAS) -l PQ_INN pq_inn.zx02 > PQ_INN.PAS

pq_inn.zx02:	pq_inn.cga
	$(ZX02) -f pq_inn.cga pq_inn.zx02

pq_inn.cga:	pq_inn.png
	$(PNG2CGA) -r ./pq_inn.png > pq_inn.cga


#################################################
#################################################

PQ_OLADY.PAS:	pq_olady.zx02
	$(BIN2PAS) -l PQ_OLADY pq_hut.zx02 > PQ_OLADY.PAS

pq_hut.zx02:	pq_hut.cga
	$(ZX02) -f pq_hut.cga pq_hut.zx02

pq_hut.cga:	pq_hut.png
	$(PNG2CGA) -r ./pq_hut.png > pq_hut.cga

####

PQ_BTREE.PAS:	pq_btree.zx02
	$(BIN2PAS) -l PQ_BTREE pq_btree.zx02 > PQ_BTREE.PAS

pq_btree.zx02:	pq_btree.cga
	$(ZX02) -f pq_btree.cga pq_btree.zx02

pq_btree.cga:	pq_burntree.png
	$(PNG2CGA) -r ./pq_burntree.png > pq_btree.cga



#####

PQ_KER1.PAS:	pq_ker1.zx02
	$(BIN2PAS) -l PQ_KERREK1 pq_ker1.zx02 > PQ_KER1.PAS

pq_ker1.zx02:	pq_ker1.cga
	$(ZX02) -f pq_ker1.cga pq_ker1.zx02

pq_ker1.cga:	pq_ker1.png
	$(PNG2CGA) -r ./pq_ker1.png > pq_ker1.cga


####


####



####



####




####



clean:	
	rm -f *.PAS *.WAD
