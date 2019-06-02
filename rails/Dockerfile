FROM ruby:2.5.1 as dev
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-transport-https \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      yarn

ENV NODE_ENV=development
ENV RAILS_ENV=development

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install
# RUN bundle exec rails new .

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD ["/entrypoint.sh"]
HEALTHCHECK --start-period=10m --timeout=120s --interval=120s CMD curl localhost:3000/en/home || exit 1

FROM dev as prod

COPY package.json yarn.* ./
RUN yarn install

COPY . .

RUN bundle exec rails acts_as_taggable_on_engine:install:migrations \
 && bundle exec rails webpacker:compile


COPY entrypoint.prod.sh /entrypoint.prod.sh
CMD ["/entrypoint.prod.sh"]

