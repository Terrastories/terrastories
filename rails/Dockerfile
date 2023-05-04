#
# NOTE: This Dockerfile is used for building ALL dev and prod images
#
# It utilizes Docker's multi-stage build to handle dependencies.
# Adjust with caution!
#

# == Development Image
#
# Also used as the base for building assets for prod images.
FROM ruby:2.7.7-alpine as devcore

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
RUN bundle config set --local path /usr/local/bundle && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install

WORKDIR /api

# == Transient step for building assets
FROM devcore as builder

COPY . /api

# So we can build assets for prod with dev dependencies
RUN bundle exec rake assets:precompile

# == Final Production Image
#
# Start from base Ruby image so we can keep image size slim
# Final image can be used for online or offline mode.
FROM ruby:2.7.7-alpine as prod

EXPOSE 3000

ENV RAILS_ENV="production" \
    AUTO_RUN_MIGRATIONS=on \
    DATABASE_URL="" \
    OFFLINE_MODE="no" \
    SECRET_KEY_BASE=""

RUN apk --no-cache add \
    tzdata \
    postgresql-client \
    nodejs \
    libffi \
    libxml2 \
    libxslt \
    libc6-compat \
    imagemagick \
    ffmpeg && \
    gem update --system --no-document && \
    gem install bundler --no-document --force

# Set deployment to true, bundled to vendor/bundle
RUN bundle config set deployment 'true'

# Copy sourcecode
COPY . /api

# Copy in bundled gems from devcore
COPY --from=devcore /usr/local/bundle /api/vendor/bundle
# Copy in precompiled assets from build
COPY --from=builder /api/public /api/public

WORKDIR /api

CMD ["scripts/server"]
