FROM bitnami/rails:latest
ENV BUNDLE_PATH /gems
RUN sudo apt-get update
RUN sudo apt-get install -y apt-transport-https
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | \
  sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  sudo tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | \
  sudo -E bash -
RUN sudo apt-get install -y nodejs yarn

RUN sudo mkdir /gems
RUN sudo chmod -R a+w /gems

RUN sudo mkdir /node_modules
RUN sudo chmod a+w /node_modules

RUN sudo chmod -R a+w /app

WORKDIR /app
COPY Gemfile Gemfile.lock package.json .yarnrc yarn.lock ./
RUN bundle install
RUN yarn install
RUN mkdir -p $(yarn bin)
RUN ln -fs /node_modules/webpacker/bin/webpack.js $(yarn bin)/webpack

COPY . .

