FROM ruby:2.7-alpine as build

RUN apk --no-cache add --update \
    build-base \
    linux-headers \
    less \
    nodejs \
    python3 \
    yarn \
    tzdata \
    postgresql-dev \
    postgresql-client \
    postgresql \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    libc6-compat \
    imagemagick \
    ffmpeg && \
    gem update --system --no-document && \
    gem install bundler --no-document --force

WORKDIR /tmp

COPY Gemfile* /tmp/

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config set deployment 'true' && \
    bundle install

COPY . /tmp

RUN bundle exec rake assets:precompile

FROM ruby:2.7-alpine

EXPOSE 3000

ENV RAILS_ENV=offline \
    AUTO_RUN_MIGRATIONS=on \
    DATABASE_URL=""

RUN apk --no-cache add \
    less \
    nodejs \
    yarn \
    tzdata \
    postgresql-client \
    libffi \
    libxml2 \
    libxslt \
    libc6-compat \
    imagemagick \
    ffmpeg && \
    gem update --system --no-document && \
    gem install bundler --no-document --force

COPY --from=build /tmp/vendor/bundle /usr/local/bundle
COPY . /api
COPY --from=build /tmp/public /api/public

RUN bundle config set --local path /usr/local/bundle

WORKDIR /api

CMD ["scripts/server"]
