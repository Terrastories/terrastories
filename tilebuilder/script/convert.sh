# ogr2ogr -f "GeoJSON" /tmp/geomorph.geojson /data/shapefiles/Suriname_Geomorphology.shp
# ogr2ogr -f "GeoJSON" /tmp/roads.geojson /data/shapefiles/Suriname_Roads.shp
# ogr2ogr -f "GeoJSON" /tmp/creeks.geojson /data/shapefiles/Saramacca_Creeks.shp
# tippecanoe -o /data/mbtiles/basic.mbtiles /tmp/geomorph.geojson /tmp/roads.geojson /tmp/creeks.geojson

find /data/shapefiles | grep ".shp$" | while read filepath; do
  file=$(echo "$filepath" | sed -E 's@.*/([0-9a-zA-Z_-]+)\.[a-z]+@\1@')
  ogr2ogr -f "GeoJSON" /tmp/$file.json $filepath
done

tippecanoe -o /data/mbtiles/basic.mbtiles $(find /tmp -type f | grep .json$)
