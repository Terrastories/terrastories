FROM ruby:2.7-alpine

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
    libffi \
    libxml2-dev \
    libxslt-dev \
    libc6-compat \
    imagemagick \
    ffmpeg && \
    gem update --system --no-document && \
    gem install bundler --no-document --force

WORKDIR /api

COPY Gemfile* /api/
RUN bundle config set --local path /usr/local/bundle && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install

COPY . /api

CMD ["scripts/server"]
