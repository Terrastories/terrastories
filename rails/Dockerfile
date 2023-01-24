FROM ruby:2.5.9-alpine

RUN apk --no-cache add --update \
    build-base \
    linux-headers \
    less \
    nodejs \
    python2 \
    yarn \
    tzdata \
    postgresql-dev \
    postgresql-client \
    postgresql \
    libffi \
    libxml2-dev \
    libxslt-dev \
    libc6-compat \
    imagemagick \
    ffmpeg && \
    gem install rubygems-update -v '<3' --no-document && update_rubygems && \
    gem install bundler --no-document --force -v '~> 2.3.0'

WORKDIR /api

COPY Gemfile* /api/
RUN bundle config set --local path /usr/local/bundle && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install

COPY . /api

CMD ["scripts/server"]
