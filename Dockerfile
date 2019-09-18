FROM ruby:2.6.4-slim
ARG precompileassets

RUN apt-get update && apt-get install -y curl gnupg \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && curl -q https://deb.nodesource.com/setup_12.x  | bash - \
    && curl -q https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list


RUN echo "here we go" \
    && apt-get -y update \
    && apt-get install --fix-missing --no-install-recommends -qq -y \
       build-essential \
       vim \
       wget \
       gnupg \
       git-all \
       curl \
       ssh \
       postgresql-client-11 \
       libpq5 \
       libpq-dev \
       nodejs \
       sqlite3 \
       libsqlite3-dev \
       yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install --production=false

COPY . .

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000
EXPOSE 3035

ENV SECRET_KEY_BASE=123
ENV PORT=3000
ENV HOST=0.0.0.0

# Permission update required for MacOS
# Update all scripts in the folder
#RUN chmod a+x scripts/*
# RUN find scripts -type f -exec chmod a+X {} \
RUN scripts/potential_asset_precompile.sh $precompileassets

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD "bundle exec foreman start -f Procfile.development"
