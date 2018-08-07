#!/bin/bash

if [ $# -lt 1 ]; then
	echo "usage: $0 <map name>"
	exit;
fi
MAP=$(basename $1)
ENV=$1.env
OPTION=$1.option

. $ENV

#===========================
# remove the output 
#===========================
mkdir -p gmap
mkdir -p osm 
mkdir -p srtm
rm -rf gmap\*.*

#===========================
# download Srtm from http://osm.michis-pla.net/code/Srtm2Osm-1.12.1.0.zip and put to srtm2osm
#
# create topo osm source
# download DEM (Digital Elevation Model) file from 
# http://www.viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org3.htm
# to srtm.cache, eg. srtm.cache/SrtmCache/N09E124.hgt
#===========================
srtm2osm/Srtm2Osm.exe -d srtm.cache -cat 400 100 -large -corrxy 0.0005 0.0006 -bounds1 $SOUTH $WEST $NORTH $EAST -o srtm/srtm-${MAP}.osm

#===========================
echo "downloading Open Street Map Data for $MAP map"
#curl --output osm/$MAP.osm https://overpass-api.de/api/map?bbox=$WEST,$SOUTH,$EAST,$NORTH

#===========================
# download mkgmap from http://www.mkgmap.org.uk/ and put to garmin/mkgmap
# compile osm source and topo source
#===========================
java -Xmx1g -jar mkgmap/${MKGMAP}/mkgmap.jar -c $OPTION srtm/srtm-$MAP.osm osm/$MAP.osm

#==== rename the output and done ====
mv gmap/gmapsupp.img gmap/gmapsupp-$MAP.img

echo "gmap/gmapsupp-$MAP.img is created"


