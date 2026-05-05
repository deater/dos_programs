PNG2CGA = ../../../utils/cga-utils/png2cga
PNG2COLLISION = ../../../utils/cga-utils/png2collision
PNG2PRIORITY = ../../../utils/cga-utils/png2priority
ZX02 = ~/research/6502_compression/zx02.git/build/zx02
BIN2PAS = ../../../utils/pas-utils/bin2pas
MKWAD = ../../../utils/disk-utils/mkwad

all:	PEASANT.WAD \
	PQ_VID.PAS PQ_TITLE.PAS PQ_TIPS.PAS

####

PEASANT.WAD:	\
	pq_ytree.zx02     ../text/D_YTREE.ZX2  yellow_tree_collision.zx02 \
	pq_waterfall.zx02 ../text/D_WFALL.ZX2  waterfall_collision.zx02 \
	pq_rock.zx02      ../text/D_ROCK.ZX2   river_collision.zx02 \
	pq_knight.zx02    ../text/D_KNIGHT.ZX2 knight_collision.zx02 \
	pq_w_lake.zx02 \
	pq_e_lake.zx02    ../text/D_ELAKE.ZX2  lake_e_collision.zx02 \
	pq_inn.zx02       ../text/D_INN.ZX2    outside_inn_collision.zx02 \
	pq_hut.zx02       ../text/D_OLADY.ZX2  lady_cottage_collision.zx02 \
	pq_btree.zx02     ../text/D_BTREE.ZX2  crooked_tree_collision.zx02 \
	pq_iinn.zx02      ../text/D_IINN.ZX2   inside_inn_collision.zx02 \
	pq_ilady.zx02     ../text/D_ILADY.ZX2  inside_cottage_collision.zx02 \
	pq_unknown.zx02	unknown_collision.zx02
	$(MKWAD) -o PEASANT.WAD \
		../sprites/s_walk.zx02,SWALK \
		pq_ytree.zx02,GYTREE ../text/D_YTREE.ZX2,DYTREE \
		yellow_tree_collision.zx02,PYTREE \
		pq_waterfall.zx02,GWFALL ../text/D_WFALL.ZX2,DWFALL \
		waterfall_collision.zx02,PWFALL \
		pq_rock.zx02,GROCK ../text/D_ROCK.ZX2,DROCK \
		river_collision.zx02,PROCK \
		pq_knight.zx02,GKNIGHT ../text/D_KNIGHT.ZX2,DKNIGHT \
		knight_collision.zx02,PKNIGHT \
		pq_w_lake.zx02,GWLAKE \
		pq_e_lake.zx02,GELAKE ../text/D_ELAKE.ZX2,DELAKE \
		lake_e_collision.zx02,PELAKE \
		pq_inn.zx02,GINN ../text/D_INN.ZX2,DINN \
		outside_inn_collision.zx02,PINN \
		pq_hut.zx02,GOLADY ../text/D_OLADY.ZX2,DOLADY \
		lady_cottage_collision.zx02,POLADY \
		pq_btree.zx02,GBTREE ../text/D_BTREE.ZX2,DBTREE \
		crooked_tree_collision.zx02,PBTREE \
		pq_iinn.zx02,GIINN ../text/D_IINN.ZX2,DIINN \
		inside_inn_collision.zx02,PIINN \
		pq_ilady.zx02,GILADY ../text/D_ILADY.ZX2,DILADY \
		inside_cottage_collision.zx02,PILADY \
		pq_unknown.zx02,GUNKNOWN \
		unknown_collision.zx02,PUNKNOWN

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

yellow_tree_collision.zx02:	yellow_tree_collision.collision
	$(ZX02) -f yellow_tree_collision.collision yellow_tree_collision.zx02

yellow_tree_collision.collision:	yellow_tree_collision.png yellow_tree_collision.png
	$(PNG2COLLISION) yellow_tree_collision.png yellow_tree_collision.collision

####

PQ_WFALL.PAS:	pq_waterfall.zx02
	$(BIN2PAS) -l PQ_WFALL pq_waterfall.zx02 > PQ_WFALL.PAS

pq_waterfall.zx02:	pq_waterfall.cga
	$(ZX02) -f pq_waterfall.cga pq_waterfall.zx02

pq_waterfall.cga:	pq_waterfall.png
	$(PNG2CGA) -r ./pq_waterfall.png > pq_waterfall.cga

waterfall_collision.zx02:	waterfall_collision.collision
	$(ZX02) -f waterfall_collision.collision waterfall_collision.zx02

waterfall_collision.collision:	waterfall_collision.png waterfall_collision.png
	$(PNG2COLLISION) waterfall_collision.png waterfall_collision.collision

#################################################
#################################################

PQ_ROCK.PAS:	pq_rock.zx02
	$(BIN2PAS) -l PQ_ROCK pq_rock.zx02 > PQ_ROCK.PAS

pq_rock.zx02:	pq_rock.cga
	$(ZX02) -f pq_rock.cga pq_rock.zx02

pq_rock.cga:	pq_rock.png
	$(PNG2CGA) -r ./pq_rock.png > pq_rock.cga

river_collision.zx02:	river_collision.collision
	$(ZX02) -f river_collision.collision river_collision.zx02

river_collision.collision:	river_collision.png river_collision.png
	$(PNG2COLLISION) river_collision.png river_collision.collision

###

PQ_KNGHT.PAS:	pq_knight.zx02
	$(BIN2PAS) -l PQ_KNIGHT pq_knight.zx02 > PQ_KNGHT.PAS

#pq_knight.zx02:	pq_knight.combined
#	$(ZX02) -f pq_knight.combined pq_knight.zx02

#pq_knight.combined: pq_knight.cga knight_priority.priority
#	cat pq_knight.cga knight_priority.priority > pq_knight.combined

pq_knight.zx02:	pq_knight.cga
	$(ZX02) -f pq_knight.cga pq_knight.zx02

pq_knight.cga:	pq_knight.png
	$(PNG2CGA) -r ./pq_knight.png > pq_knight.cga

knight_collision.zx02:	knight_collision.combined
	$(ZX02) -f knight_collision.combined knight_collision.zx02

knight_collision.combined:	knight_collision.collision knight_priority.priority
	cat knight_priority.priority > knight_collision.combined
	cat knight_collision.collision >> knight_collision.combined

knight_priority.priority:	knight_priority.png
	$(PNG2PRIORITY) knight_priority.png knight_priority.priority

knight_collision.collision:	knight_collision.png
	$(PNG2COLLISION) knight_collision.png knight_collision.collision


#################################################
#################################################

PQ_WLAKE.PAS:	pq_w_lake.zx02
	$(BIN2PAS) -l PQ_WLAKE pq_w_lake.zx02 > PQ_WLAKE.PAS

pq_w_lake.zx02:	pq_w_lake.cga
	$(ZX02) -f pq_w_lake.cga pq_w_lake.zx02

pq_w_lake.cga:	pq_w_lake.png
	$(PNG2CGA) -r ./pq_w_lake.png > pq_w_lake.cga

lake_w_collision.zx02:	lake_w_collision.collision
	$(ZX02) -f lake_w_collision.collision lake_w_collision.zx02

lake_w_collision.collision:	lake_w_collision.png lake_w_collision.png
	$(PNG2COLLISION) lake_w_collision.png lake_w_collision.collision

###

PQ_ELAKE.PAS:	pq_e_lake.zx02
	$(BIN2PAS) -l PQ_ELAKE pq_e_lake.zx02 > PQ_ELAKE.PAS

pq_e_lake.zx02:	pq_e_lake.cga
	$(ZX02) -f pq_e_lake.cga pq_e_lake.zx02

pq_e_lake.cga:	pq_e_lake.png
	$(PNG2CGA) -r ./pq_e_lake.png > pq_e_lake.cga

lake_e_collision.zx02:	lake_e_collision.collision
	$(ZX02) -f lake_e_collision.collision lake_e_collision.zx02

lake_e_collision.collision:	lake_e_collision.png lake_e_collision.png
	$(PNG2COLLISION) lake_e_collision.png lake_e_collision.collision

###

PQ_INN.PAS:	pq_inn.zx02
	$(BIN2PAS) -l PQ_INN pq_inn.zx02 > PQ_INN.PAS

pq_inn.zx02:	pq_inn.cga
	$(ZX02) -f pq_inn.cga pq_inn.zx02

pq_inn.cga:	pq_inn.png
	$(PNG2CGA) -r ./pq_inn.png > pq_inn.cga

outside_inn_collision.zx02:	outside_inn_collision.collision
	$(ZX02) -f outside_inn_collision.collision outside_inn_collision.zx02

outside_inn_collision.collision:	outside_inn_collision.png outside_inn_collision.png
	$(PNG2COLLISION) outside_inn_collision.png outside_inn_collision.collision

#################################################
#################################################

PQ_OLADY.PAS:	pq_olady.zx02
	$(BIN2PAS) -l PQ_OLADY pq_hut.zx02 > PQ_OLADY.PAS

pq_hut.zx02:	pq_hut.cga
	$(ZX02) -f pq_hut.cga pq_hut.zx02

pq_hut.cga:	pq_hut.png
	$(PNG2CGA) -r ./pq_hut.png > pq_hut.cga

lady_cottage_collision.zx02:	lady_cottage_collision.collision
	$(ZX02) -f lady_cottage_collision.collision lady_cottage_collision.zx02

lady_cottage_collision.collision:	lady_cottage_collision.png lady_cottage_collision.png
	$(PNG2COLLISION) lady_cottage_collision.png lady_cottage_collision.collision

####

PQ_BTREE.PAS:	pq_btree.zx02
	$(BIN2PAS) -l PQ_BTREE pq_btree.zx02 > PQ_BTREE.PAS

pq_btree.zx02:	pq_btree.cga
	$(ZX02) -f pq_btree.cga pq_btree.zx02

pq_btree.cga:	pq_burntree.png
	$(PNG2CGA) -r ./pq_burntree.png > pq_btree.cga

crooked_tree_collision.zx02:	crooked_tree_collision.collision
	$(ZX02) -f crooked_tree_collision.collision crooked_tree_collision.zx02

crooked_tree_collision.collision:	crooked_tree_collision.png crooked_tree_collision.png
	$(PNG2COLLISION) crooked_tree_collision.png crooked_tree_collision.collision

#################################################
#################################################

PQ_IINN.PAS:	pq_iinn.zx02
	$(BIN2PAS) -l PQ_IINN pq_iinn.zx02 > PQ_IINN.PAS

pq_iinn.zx02:	pq_iinn.cga
	$(ZX02) -f pq_iinn.cga pq_iinn.zx02

pq_iinn.cga:	pq_iinn.png
	$(PNG2CGA) -r ./pq_iinn.png > pq_iinn.cga

inside_inn_collision.zx02:	inside_inn_collision.collision
	$(ZX02) -f inside_inn_collision.collision inside_inn_collision.zx02

inside_inn_collision.collision:	inside_inn_collision.png inside_inn_collision.png
	$(PNG2COLLISION) inside_inn_collision.png inside_inn_collision.collision


####

PQ_ILADY.PAS:	pq_ilady.zx02
	$(BIN2PAS) -l PQ_ILADY pq_ilady.zx02 > PQ_ILADY.PAS

pq_ilady.zx02:	pq_ilady.cga
	$(ZX02) -f pq_ilady.cga pq_ilady.zx02

pq_ilady.cga:	pq_ilady.png
	$(PNG2CGA) -r ./pq_ilady.png > pq_ilady.cga

inside_cottage_collision.zx02:	inside_cottage_collision.collision
	$(ZX02) -f inside_cottage_collision.collision inside_cottage_collision.zx02

inside_cottage_collision.collision:	inside_cottage_collision.png inside_cottage_collision.png
	$(PNG2COLLISION) inside_cottage_collision.png inside_cottage_collision.collision

#################################################
#################################################

PQ_UNKNOWN.PAS:	pq_unknown.zx02
	$(BIN2PAS) -l PQ_UNKNOWN pq_unknown.zx02 > PQ_UNKNOWN.PAS

pq_unknown.zx02:	pq_unknown.cga
	$(ZX02) -f pq_unknown.cga pq_unknown.zx02

pq_unknown.cga:	pq_unknown.png
	$(PNG2CGA) -r ./pq_unknown.png > pq_unknown.cga

unknown_collision.zx02:	unknown_collision.collision
	$(ZX02) -f unknown_collision.collision unknown_collision.zx02

unknown_collision.collision:	unknown_collision.png unknown_collision.png
	$(PNG2COLLISION) unknown_collision.png unknown_collision.collision

####

clean:	
	rm -f *.PAS *.WAD *.combined *.collision *.priority
