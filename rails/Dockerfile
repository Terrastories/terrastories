FROM ruby:2.5.7-alpine
ARG precompileassets

RUN apk --no-cache add --update \
    build-base \
    nodejs \
    yarn \
    tzdata \
    postgresql-dev \
    postgresql-client \
    postgresql \
    libffi \
    libxml2 \
    libxslt \
    libc6-compat \
    imagemagick && \
    gem update --system --no-document && \
    gem install bundler --no-document --force

WORKDIR /api

COPY Gemfile* /api/
RUN bundle config set --local path /usr/local/bundle && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install

COPY package.json yarn.lock /api/
RUN yarn install

COPY . /api

RUN scripts/potential_asset_precompile.sh $precompileassets

CMD ["scripts/server"]
