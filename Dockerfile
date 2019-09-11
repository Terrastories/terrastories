FROM ruby:2.5.1-slim
ARG precompileassets

RUN apt-get update && apt-get install -y curl gnupg

RUN apt-get -y update && \
  # apt-get install --fix-missing --no-install-recommends -qq -y \
  apt-get install --fix-missing --no-install-recommends -qq -y \
  build-essential \
  vim \ 
  mysql-client default-libmysqlclient-dev \
  wget gnupg \
  git-all \
  curl \
  ssh && \
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
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

ARG INSTALL_PATH=/opt/terrastories
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

# Permission update required for MacOS
# Update all scripts in the folder
RUN chmod -R a+x scripts
# RUN find scripts -type f -exec chmod a+X {} \
RUN scripts/potential_asset_precompile.sh $precompileassets