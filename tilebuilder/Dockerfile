FROM debian:latest
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      gdal-bin \
      git \
      jq \
      libsqlite3-dev \
      zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN cd etc \
 && git clone https://github.com/mapbox/tippecanoe.git
RUN cd etc/tippecanoe \
 && make -j \
 && make install
RUN mkdir /script \
 && cd /script \
 && echo "echo 'Warning: No conversion script provided!\n\
  Specify one by mounting a volume on this container at /script.\n\
  The volume should contain an executable script named convert.sh'" >> convert.sh \
 && chmod a+x convert.sh
CMD /script/convert.sh

