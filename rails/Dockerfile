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
RUN sudo chmod -R a+w /node_modules

ADD . /app
RUN sudo chmod -R a+w /app

WORKDIR /app
RUN bundle install
RUN yarn --modules-folder /node_modules install

