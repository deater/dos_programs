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
	pq_well.zx02      ../text/D_WELL.ZX2   well_collision.zx02 \
	pq_ytree.zx02     ../text/D_YTREE.ZX2  yellow_tree_collision.zx02 \
	pq_waterfall.zx02 ../text/D_WFALL.ZX2  waterfall_collision.zx02 \
	pq_archery.zx02   ../text/D_ARCH.ZX2   \
	pq_rock.zx02      ../text/D_ROCK.ZX2   river_collision.zx02 \
	pq_knight.zx02    ../text/D_KNIGHT.ZX2 knight_collision.zx02 \
	pq_w_lake.zx02    ../text/D_WLAKE.ZX2  lake_w_collision.zx02 \
	pq_e_lake.zx02    ../text/D_ELAKE.ZX2  lake_e_collision.zx02 \
	pq_inn.zx02       ../text/D_INN.ZX2    outside_inn_collision.zx02 \
	pq_kerrek2.zx02   ../text/D_KERREK.ZX2 \
	pq_hut.zx02       ../text/D_OLADY.ZX2  lady_cottage_collision.zx02 \
	pq_btree.zx02     ../text/D_BTREE.ZX2  crooked_tree_collision.zx02 \
	pq_iinn.zx02      ../text/D_IINN.ZX2   inside_inn_collision.zx02 \
	pq_ilady.zx02     ../text/D_ILADY.ZX2  inside_cottage_collision.zx02 \
	pq_unknown.zx02	unknown_collision.zx02
	$(MKWAD) -o PEASANT.WAD \
		../sprites/s_walk.zx02,SWALK \
		pq_well.zx02,GWELL ../text/D_WELL.ZX2,DWELL \
		well_collision.zx02,PWELL \
		pq_ytree.zx02,GYTREE ../text/D_YTREE.ZX2,DYTREE \
		yellow_tree_collision.zx02,PYTREE \
		pq_waterfall.zx02,GWFALL ../text/D_WFALL.ZX2,DWFALL \
		waterfall_collision.zx02,PWFALL \
		pq_archery.zx02,GARCH ../text/D_ARCH.ZX2,DARCH \
		pq_rock.zx02,GROCK ../text/D_ROCK.ZX2,DROCK \
		river_collision.zx02,PROCK \
		pq_knight.zx02,GKNIGHT ../text/D_KNIGHT.ZX2,DKNIGHT \
		knight_collision.zx02,PKNIGHT \
		pq_w_lake.zx02,GWLAKE ../text/D_WLAKE.ZX2,DWLAKE \
		lake_w_collision.zx02,PWLAKE \
		pq_e_lake.zx02,GELAKE ../text/D_ELAKE.ZX2,DELAKE \
		lake_e_collision.zx02,PELAKE \
		pq_inn.zx02,GINN ../text/D_INN.ZX2,DINN \
		outside_inn_collision.zx02,PINN \
		pq_kerrek2.zx02,GKERREK2 ../text/D_KERREK.ZX2,DKERREK \
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

pq_well.zx02:	pq_well.cga
	$(ZX02) -f pq_well.cga pq_well.zx02

pq_well.cga:	pq_well.png
	$(PNG2CGA) -r ./pq_well.png > pq_well.cga

well_collision.zx02:	well_collision.combined
	$(ZX02) -f well_collision.combined well_collision.zx02

well_collision.combined:	well_collision.collision well_priority.priority
	cat well_priority.priority > well_collision.combined
	cat well_collision.collision >> well_collision.combined

well_priority.priority:	well_priority.png
	$(PNG2PRIORITY) well_priority.png well_priority.priority

well_collision.collision:	well_collision.png
	$(PNG2COLLISION) well_collision.png well_collision.collision

####

pq_ytree.zx02:	pq_ytree.cga
	$(ZX02) -f pq_ytree.cga pq_ytree.zx02

pq_ytree.cga:	pq_ytree.png
	$(PNG2CGA) -r ./pq_ytree.png > pq_ytree.cga

yellow_tree_collision.zx02:	yellow_tree_collision.combined
	$(ZX02) -f yellow_tree_collision.combined yellow_tree_collision.zx02

yellow_tree_collision.combined:	yellow_tree_collision.collision yellow_tree_priority.priority
	cat yellow_tree_priority.priority > yellow_tree_collision.combined
	cat yellow_tree_collision.collision >> yellow_tree_collision.combined

yellow_tree_priority.priority:	yellow_tree_priority.png
	$(PNG2PRIORITY) yellow_tree_priority.png yellow_tree_priority.priority

yellow_tree_collision.collision:	yellow_tree_collision.png
	$(PNG2COLLISION) yellow_tree_collision.png yellow_tree_collision.collision

####

pq_waterfall.zx02:	pq_waterfall.cga
	$(ZX02) -f pq_waterfall.cga pq_waterfall.zx02

pq_waterfall.cga:	pq_waterfall.png
	$(PNG2CGA) -r ./pq_waterfall.png > pq_waterfall.cga

waterfall_collision.zx02:	waterfall_collision.combined
	$(ZX02) -f waterfall_collision.combined waterfall_collision.zx02

waterfall_collision.combined:	waterfall_collision.collision waterfall_priority.priority
	cat waterfall_priority.priority > waterfall_collision.combined
	cat waterfall_collision.collision >> waterfall_collision.combined

waterfall_priority.priority:	waterfall_priority.png
	$(PNG2PRIORITY) waterfall_priority.png waterfall_priority.priority

waterfall_collision.collision:	waterfall_collision.png
	$(PNG2COLLISION) waterfall_collision.png waterfall_collision.collision


#################################################
#################################################

pq_archery.zx02:	pq_archery.cga
	$(ZX02) -f pq_archery.cga pq_archery.zx02

pq_archery.cga:	pq_archery.png
	$(PNG2CGA) -r ./pq_archery.png > pq_archery.cga

archery_collision.zx02:	archery_collision.combined
	$(ZX02) -f archery_collision.combined archery_collision.zx02

archery_collision.combined:	archery_collision.collision archery_priority.priority
	cat archery_priority.priority > archery_collision.combined
	cat archery_collision.collision >> archery_collision.combined

archery_priority.priority:	archery_priority.png
	$(PNG2PRIORITY) archery_priority.png archery_priority.priority

archery_collision.collision:	archery_collision.png
	$(PNG2COLLISION) archery_collision.png archery_collision.collision

###

pq_rock.zx02:	pq_rock.cga
	$(ZX02) -f pq_rock.cga pq_rock.zx02

pq_rock.cga:	pq_rock.png
	$(PNG2CGA) -r ./pq_rock.png > pq_rock.cga

river_collision.zx02:	river_collision.combined
	$(ZX02) -f river_collision.combined river_collision.zx02

river_collision.combined:	river_collision.collision river_priority.priority
	cat river_priority.priority > river_collision.combined
	cat river_collision.collision >> river_collision.combined

river_priority.priority:	river_priority.png
	$(PNG2PRIORITY) river_priority.png river_priority.priority

river_collision.collision:	river_collision.png
	$(PNG2COLLISION) river_collision.png river_collision.collision

###

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

pq_w_lake.zx02:	pq_w_lake.cga
	$(ZX02) -f pq_w_lake.cga pq_w_lake.zx02

pq_w_lake.cga:	pq_w_lake.png
	$(PNG2CGA) -r ./pq_w_lake.png > pq_w_lake.cga

lake_w_collision.zx02:	lake_w_collision.combined
	$(ZX02) -f lake_w_collision.combined lake_w_collision.zx02

lake_w_collision.combined:	lake_w_collision.collision lake_w_priority.priority
	cat lake_w_priority.priority > lake_w_collision.combined
	cat lake_w_collision.collision >> lake_w_collision.combined

lake_w_priority.priority:	lake_w_priority.png
	$(PNG2PRIORITY) lake_w_priority.png lake_w_priority.priority

lake_w_collision.collision:	lake_w_collision.png
	$(PNG2COLLISION) lake_w_collision.png lake_w_collision.collision

###

pq_e_lake.zx02:	pq_e_lake.cga
	$(ZX02) -f pq_e_lake.cga pq_e_lake.zx02

pq_e_lake.cga:	pq_e_lake.png
	$(PNG2CGA) -r ./pq_e_lake.png > pq_e_lake.cga

lake_e_collision.zx02:	lake_e_collision.combined
	$(ZX02) -f lake_e_collision.combined lake_e_collision.zx02

lake_e_collision.combined:	lake_e_collision.collision lake_e_priority.priority
	cat lake_e_priority.priority > lake_e_collision.combined
	cat lake_e_collision.collision >> lake_e_collision.combined

lake_e_priority.priority:	lake_e_priority.png
	$(PNG2PRIORITY) lake_e_priority.png lake_e_priority.priority

lake_e_collision.collision:	lake_e_collision.png
	$(PNG2COLLISION) lake_e_collision.png lake_e_collision.collision

###

pq_inn.zx02:	pq_inn.cga
	$(ZX02) -f pq_inn.cga pq_inn.zx02

pq_inn.cga:	pq_inn.png
	$(PNG2CGA) -r ./pq_inn.png > pq_inn.cga

outside_inn_collision.zx02:	outside_inn_collision.combined
	$(ZX02) -f outside_inn_collision.combined outside_inn_collision.zx02

outside_inn_collision.combined:	outside_inn_collision.collision outside_inn_priority.priority
	cat outside_inn_priority.priority > outside_inn_collision.combined
	cat outside_inn_collision.collision >> outside_inn_collision.combined

outside_inn_priority.priority:	outside_inn_priority.png
	$(PNG2PRIORITY) outside_inn_priority.png outside_inn_priority.priority

outside_inn_collision.collision:	outside_inn_collision.png
	$(PNG2COLLISION) outside_inn_collision.png outside_inn_collision.collision

#################################################
#################################################

pq_kerrek2.zx02:	pq_kerrek2.cga
	$(ZX02) -f pq_kerrek2.cga pq_kerrek2.zx02

pq_kerrek2.cga:	pq_kerrek2.png
	$(PNG2CGA) -r ./pq_kerrek2.png > pq_kerrek2.cga

kerrek2_collision.zx02:	kerrek2_collision.combined
	$(ZX02) -f kerrek2_collision.combined kerrek2_collision.zx02

kerrek2_collision.combined:	kerrek2_collision.collision kerrek2_priority.priority
	cat kerrek2_priority.priority > kerrek2_collision.combined
	cat kerrek2_collision.collision >> kerrek2_collision.combined

kerrek2_priority.priority:	kerrek2_priority.png
	$(PNG2PRIORITY) kerrek2_priority.png kerrek2_priority.priority

kerrek2_collision.collision:	kerrek2_collision.png
	$(PNG2COLLISION) kerrek2_collision.png kerrek2_collision.collision

####

pq_hut.zx02:	pq_hut.cga
	$(ZX02) -f pq_hut.cga pq_hut.zx02

pq_hut.cga:	pq_hut.png
	$(PNG2CGA) -r ./pq_hut.png > pq_hut.cga

lady_cottage_collision.zx02:	lady_cottage_collision.combined
	$(ZX02) -f lady_cottage_collision.combined lady_cottage_collision.zx02

lady_cottage_collision.combined:	lady_cottage_collision.collision lady_cottage_priority.priority
	cat lady_cottage_priority.priority > lady_cottage_collision.combined
	cat lady_cottage_collision.collision >> lady_cottage_collision.combined

lady_cottage_priority.priority:	lady_cottage_priority.png
	$(PNG2PRIORITY) lady_cottage_priority.png lady_cottage_priority.priority

lady_cottage_collision.collision:	lady_cottage_collision.png
	$(PNG2COLLISION) lady_cottage_collision.png lady_cottage_collision.collision

####

pq_btree.zx02:	pq_burntree.cga
	$(ZX02) -f pq_burntree.cga pq_btree.zx02

pq_burntree.cga:	pq_burntree.png
	$(PNG2CGA) -r ./pq_burntree.png > pq_burntree.cga

crooked_tree_collision.zx02:	crooked_tree_collision.combined
	$(ZX02) -f crooked_tree_collision.combined crooked_tree_collision.zx02

crooked_tree_collision.combined:	crooked_tree_collision.collision crooked_tree_priority.priority
	cat crooked_tree_priority.priority > crooked_tree_collision.combined
	cat crooked_tree_collision.collision >> crooked_tree_collision.combined

crooked_tree_priority.priority:	crooked_tree_priority.png
	$(PNG2PRIORITY) crooked_tree_priority.png crooked_tree_priority.priority

crooked_tree_collision.collision:	crooked_tree_collision.png
	$(PNG2COLLISION) crooked_tree_collision.png crooked_tree_collision.collision

#################################################
#################################################

###

pq_iinn.zx02:	pq_iinn.cga
	$(ZX02) -f pq_iinn.cga pq_iinn.zx02

pq_iinn.cga:	pq_iinn.png
	$(PNG2CGA) -r ./pq_iinn.png > pq_iinn.cga

inside_inn_collision.zx02:	inside_inn_collision.combined
	$(ZX02) -f inside_inn_collision.combined inside_inn_collision.zx02

inside_inn_collision.combined:	inside_inn_collision.collision inside_inn_priority.priority
	cat inside_inn_priority.priority > inside_inn_collision.combined
	cat inside_inn_collision.collision >> inside_inn_collision.combined

inside_inn_priority.priority:	inside_inn_priority.png
	$(PNG2PRIORITY) inside_inn_priority.png inside_inn_priority.priority

inside_inn_collision.collision:	inside_inn_collision.png
	$(PNG2COLLISION) inside_inn_collision.png inside_inn_collision.collision

####

pq_ilady.zx02:	pq_ilady.cga
	$(ZX02) -f pq_ilady.cga pq_ilady.zx02

pq_ilady.cga:	pq_ilady.png
	$(PNG2CGA) -r ./pq_ilady.png > pq_ilady.cga

inside_cottage_collision.zx02:	inside_cottage_collision.combined
	$(ZX02) -f inside_cottage_collision.combined inside_cottage_collision.zx02

inside_cottage_collision.combined:	inside_cottage_collision.collision inside_cottage_priority.priority
	cat inside_cottage_priority.priority > inside_cottage_collision.combined
	cat inside_cottage_collision.collision >> inside_cottage_collision.combined

inside_cottage_priority.priority:	inside_cottage_priority.png
	$(PNG2PRIORITY) inside_cottage_priority.png inside_cottage_priority.priority

inside_cottage_collision.collision:	inside_cottage_collision.png
	$(PNG2COLLISION) inside_cottage_collision.png inside_cottage_collision.collision

#################################################
#################################################

###

pq_unknown.zx02:	pq_unknown.cga
	$(ZX02) -f pq_unknown.cga pq_unknown.zx02

pq_unknown.cga:	pq_unknown.png
	$(PNG2CGA) -r ./pq_unknown.png > pq_unknown.cga

unknown_collision.zx02:	unknown_collision.combined
	$(ZX02) -f unknown_collision.combined unknown_collision.zx02

unknown_collision.combined:	unknown_collision.collision unknown_priority.priority
	cat unknown_priority.priority > unknown_collision.combined
	cat unknown_collision.collision >> unknown_collision.combined

unknown_priority.priority:	unknown_priority.png
	$(PNG2PRIORITY) unknown_priority.png unknown_priority.priority

unknown_collision.collision:	unknown_collision.png
	$(PNG2COLLISION) unknown_collision.png unknown_collision.collision

####

clean:	
	rm -f *.PAS *.WAD *.combined *.collision *.priority *.cga *.zx02
