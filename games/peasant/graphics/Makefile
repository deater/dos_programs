PNG2CGA = ../../../utils/cga-utils/png2cga
PNG2COLLISION = ../../../utils/cga-utils/png2collision
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas
MKWAD = ../../../utils/disk-utils/mkwad

all:	PEASANT.WAD \
	PQ_VID.PAS PQ_TITLE.PAS PQ_TIPS.PAS

####

PEASANT.WAD:	\
	pq_ytree.zx02     ../text/D_YTREE.ZX2  yellow_tree_priority.zx02 \
	pq_waterfall.zx02 ../text/D_WFALL.ZX2  waterfall_priority.zx02 \
	pq_rock.zx02      ../text/D_ROCK.ZX2   river_priority.zx02 \
	pq_knight.zx02    ../text/D_KNIGHT.ZX2 knight_priority.zx02 \
	pq_e_lake.zx02    ../text/D_ELAKE.ZX2  lake_e_priority.zx02 \
	pq_inn.zx02       ../text/D_INN.ZX2    outside_inn_priority.zx02 \
	pq_hut.zx02       ../text/D_OLADY.ZX2  lady_cottage_priority.zx02 \
	pq_btree.zx02     ../text/D_BTREE.ZX2  crooked_tree_priority.zx02 \
	pq_iinn.zx02      ../text/D_IINN.ZX2   inside_inn_priority.zx02 \
	pq_ilady.zx02     ../text/D_ILADY.ZX2  inside_cottage_priority.zx02 \
	pq_unknown.zx02	unknown_priority.zx02
	$(MKWAD) -o PEASANT.WAD \
		pq_ytree.zx02,GYTREE ../text/D_YTREE.ZX2,DYTREE \
		yellow_tree_priority.zx02,PYTREE \
		pq_waterfall.zx02,GWFALL ../text/D_WFALL.ZX2,DWFALL \
		waterfall_priority.zx02,PWFALL \
		pq_rock.zx02,GROCK ../text/D_ROCK.ZX2,DROCK \
		river_priority.zx02,PROCK \
		pq_knight.zx02,GKNIGHT ../text/D_KNIGHT.ZX2,DKNIGHT \
		knight_priority.zx02,PKNIGHT \
		pq_e_lake.zx02,GELAKE ../text/D_ELAKE.ZX2,DELAKE \
		lake_e_priority.zx02,PELAKE \
		pq_inn.zx02,GINN ../text/D_INN.ZX2,DINN \
		outside_inn_priority.zx02,PINN \
		pq_hut.zx02,GOLADY ../text/D_OLADY.ZX2,DOLADY \
		lady_cottage_priority.zx02,POLADY \
		pq_btree.zx02,GBTREE ../text/D_BTREE.ZX2,DBTREE \
		crooked_tree_priority.zx02,PBTREE \
		pq_iinn.zx02,GIINN ../text/D_IINN.ZX2,DIINN \
		inside_inn_priority.zx02,PIINN \
		pq_ilady.zx02,GILADY ../text/D_ILADY.ZX2,DILADY \
		inside_cottage_priority.zx02,PILADY \
		pq_unknown.zx02,GUNKNOWN \
		unknown_priority.zx02,PUNKNOWN

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

yellow_tree_priority.zx02:	yellow_tree_priority.combined
	$(ZX02) -f yellow_tree_priority.combined yellow_tree_priority.zx02

yellow_tree_priority.combined:	yellow_tree_priority.png yellow_tree_collision.png
	$(PNG2COLLISION) yellow_tree_collision.png yellow_tree_priority.png yellow_tree_priority.combined

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

river_priority.zx02:	river_priority.combined
	$(ZX02) -f river_priority.combined river_priority.zx02

river_priority.combined:	river_priority.png river_collision.png
	$(PNG2COLLISION) river_collision.png river_priority.png river_priority.combined

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

lake_e_priority.zx02:	lake_e_priority.combined
	$(ZX02) -f lake_e_priority.combined lake_e_priority.zx02

lake_e_priority.combined:	lake_e_priority.png lake_e_collision.png
	$(PNG2COLLISION) lake_e_collision.png lake_e_priority.png lake_e_priority.combined

###

PQ_INN.PAS:	pq_inn.zx02
	$(BIN2PAS) -l PQ_INN pq_inn.zx02 > PQ_INN.PAS

pq_inn.zx02:	pq_inn.cga
	$(ZX02) -f pq_inn.cga pq_inn.zx02

pq_inn.cga:	pq_inn.png
	$(PNG2CGA) -r ./pq_inn.png > pq_inn.cga

outside_inn_priority.zx02:	outside_inn_priority.combined
	$(ZX02) -f outside_inn_priority.combined outside_inn_priority.zx02

outside_inn_priority.combined:	outside_inn_priority.png outside_inn_collision.png
	$(PNG2COLLISION) outside_inn_collision.png outside_inn_priority.png outside_inn_priority.combined

#################################################
#################################################

PQ_OLADY.PAS:	pq_olady.zx02
	$(BIN2PAS) -l PQ_OLADY pq_hut.zx02 > PQ_OLADY.PAS

pq_hut.zx02:	pq_hut.cga
	$(ZX02) -f pq_hut.cga pq_hut.zx02

pq_hut.cga:	pq_hut.png
	$(PNG2CGA) -r ./pq_hut.png > pq_hut.cga

lady_cottage_priority.zx02:	lady_cottage_priority.combined
	$(ZX02) -f lady_cottage_priority.combined lady_cottage_priority.zx02

lady_cottage_priority.combined:	lady_cottage_priority.png lady_cottage_collision.png
	$(PNG2COLLISION) lady_cottage_collision.png lady_cottage_priority.png lady_cottage_priority.combined

####

PQ_BTREE.PAS:	pq_btree.zx02
	$(BIN2PAS) -l PQ_BTREE pq_btree.zx02 > PQ_BTREE.PAS

pq_btree.zx02:	pq_btree.cga
	$(ZX02) -f pq_btree.cga pq_btree.zx02

pq_btree.cga:	pq_burntree.png
	$(PNG2CGA) -r ./pq_burntree.png > pq_btree.cga

crooked_tree_priority.zx02:	crooked_tree_priority.combined
	$(ZX02) -f crooked_tree_priority.combined crooked_tree_priority.zx02

crooked_tree_priority.combined:	crooked_tree_priority.png crooked_tree_collision.png
	$(PNG2COLLISION) crooked_tree_collision.png crooked_tree_priority.png crooked_tree_priority.combined

#####

PQ_KER1.PAS:	pq_ker1.zx02
	$(BIN2PAS) -l PQ_KERREK1 pq_ker1.zx02 > PQ_KER1.PAS

pq_ker1.zx02:	pq_ker1.cga
	$(ZX02) -f pq_ker1.cga pq_ker1.zx02

pq_ker1.cga:	pq_ker1.png
	$(PNG2CGA) -r ./pq_ker1.png > pq_ker1.cga


#################################################
#################################################

PQ_IINN.PAS:	pq_iinn.zx02
	$(BIN2PAS) -l PQ_IINN pq_iinn.zx02 > PQ_IINN.PAS

pq_iinn.zx02:	pq_iinn.cga
	$(ZX02) -f pq_iinn.cga pq_iinn.zx02

pq_iinn.cga:	pq_iinn.png
	$(PNG2CGA) -r ./pq_iinn.png > pq_iinn.cga

inside_inn_priority.zx02:	inside_inn_priority.combined
	$(ZX02) -f inside_inn_priority.combined inside_inn_priority.zx02

inside_inn_priority.combined:	inside_inn_priority.png inside_inn_collision.png
	$(PNG2COLLISION) inside_inn_collision.png inside_inn_priority.png inside_inn_priority.combined


####

PQ_ILADY.PAS:	pq_ilady.zx02
	$(BIN2PAS) -l PQ_ILADY pq_ilady.zx02 > PQ_ILADY.PAS

pq_ilady.zx02:	pq_ilady.cga
	$(ZX02) -f pq_ilady.cga pq_ilady.zx02

pq_ilady.cga:	pq_ilady.png
	$(PNG2CGA) -r ./pq_ilady.png > pq_ilady.cga

inside_cottage_priority.zx02:	inside_cottage_priority.combined
	$(ZX02) -f inside_cottage_priority.combined inside_cottage_priority.zx02

inside_cottage_priority.combined:	inside_cottage_priority.png inside_cottage_collision.png
	$(PNG2COLLISION) inside_cottage_collision.png inside_cottage_priority.png inside_cottage_priority.combined

#################################################
#################################################

PQ_UNKNOWN.PAS:	pq_unknown.zx02
	$(BIN2PAS) -l PQ_UNKNOWN pq_unknown.zx02 > PQ_UNKNOWN.PAS

pq_unknown.zx02:	pq_unknown.cga
	$(ZX02) -f pq_unknown.cga pq_unknown.zx02

pq_unknown.cga:	pq_unknown.png
	$(PNG2CGA) -r ./pq_unknown.png > pq_unknown.cga

unknown_priority.zx02:	unknown_priority.combined
	$(ZX02) -f unknown_priority.combined unknown_priority.zx02

unknown_priority.combined:	unknown_priority.png unknown_collision.png
	$(PNG2COLLISION) unknown_collision.png unknown_priority.png unknown_priority.combined

####

clean:	
	rm -f *.PAS *.WAD
