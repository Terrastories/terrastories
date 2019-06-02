FROM ruby:2.5.1
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-transport-https \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y build-essential libpq-dev nodejs yarn

ENV NODE_ENV=development
ENV RAILS_ENV=development

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN mkdir -p /node_modules \
 && ln -sf ../node_modules \
 && yarn install --modules-folder ../node_modules
RUN bundle exec rails new .
RUN mv yarn.lock /yarn.lock

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD ["/entrypoint.sh"]
HEALTHCHECK --start-period=10m --timeout=120s --interval=120s CMD curl localhost:3000/en/home || exit 1

