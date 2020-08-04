FROM ruby:2.5.1-slim

RUN apt-get -y update && \
  apt-get install --fix-missing --no-install-recommends -qq -y \
  build-essential

RUN gem install bundler
#Install gems
RUN mkdir /gems
WORKDIR /gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

ARG INSTALL_PATH=/opt/terrastories_e2e
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .
