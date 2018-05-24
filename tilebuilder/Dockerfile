FROM debian:latest
RUN apt-get update
RUN apt-get install -y build-essential libsqlite3-dev zlib1g-dev git
RUN apt-get install -y gdal-bin jq
RUN cd etc; git clone https://github.com/mapbox/tippecanoe.git; \
cd tippecanoe; make -j; make install
RUN mkdir /script; cd /script; \
touch convert.sh; chmod a+x convert.sh; \
echo "echo 'Warning: No conversion script provided!\n\
  Specify one by mounting a volume on this container at /script.\n\
  The volume should contain an executable script named convert.sh'" >> convert.sh
CMD /script/convert.sh
