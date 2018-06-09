# https://github.com/bitnami/bitnami-docker-rails/pull/75

FROM bitnami/minideb-extras:jessie-r13-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libpq5 libpq-dev

RUN bitnami-pkg install ruby-2.5.1-0 --checksum fd17ca9ec4faba06a21868c654681a79d1b00748efaefacb6805fe7e464442ef

ENV PATH=/opt/bitnami/ruby/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.2.0 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database postgresql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.2.0-r0

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["rootfs/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]