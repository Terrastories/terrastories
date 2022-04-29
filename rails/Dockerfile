FROM ruby:2.5.1-slim
ARG precompileassets

RUN apt-get update && apt-get install -y curl gnupg
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get -y update && \
  apt-get install --fix-missing --no-install-recommends -qq -y \
  build-essential \
  vim \ 
  wget gnupg \
  git-all \
  curl \
  ssh \
  imagemagick \
  postgresql-client-11 libpq5 libpq-dev -y && \
  wget -qO- https://deb.nodesource.com/setup_12.x  | bash - && \
  apt-get install -y nodejs && \
  wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler
#Install gems
RUN mkdir /gems
WORKDIR /gems
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install

ARG INSTALL_PATH=/opt/terrastories
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

# Permission update required for MacOS
# Update all scripts in the folder
RUN chmod a+x scripts/*
# RUN find scripts -type f -exec chmod a+X {} \
RUN scripts/potential_asset_precompile.sh $precompileassets