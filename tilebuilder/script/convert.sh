mkdir /tmp/geo
mkdir /tmp/line
rm -rf /data/mbtiles/*
rm -rf /tmp/geo/*
rm -rf /tmp/line/*
find /data/shapefiles | grep ".shp$" | while read filepath; do
  file=$(echo "$filepath" | sed -E 's@.*/([0-9a-zA-Z_-]+)\.[a-z]+@\1@')
  ogr2ogr -f "GeoJSON" /tmp/geo/$file.json $filepath
  jq -rc '.features[]' /tmp/geo/$file.json > /tmp/line/$file.geojson
done
tippecanoe --read-parallel -pf -pk -z10 -Bg -o /data/mbtiles/basic.mbtiles $(find /tmp/line -type f | grep .json$)