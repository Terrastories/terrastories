FROM ruby:2.5
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y build-essential libpq-dev nodejs yarn

#RUN sudo mkdir /gems
#RUN sudo chmod -R a+w /gems

#RUN sudo mkdir /node_modules
#RUN sudo chmod a+w /node_modules

#RUN sudo chmod -R a+w /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x entrypoint.sh

ENV NODE_ENV=development
ENV RAILS_ENV=development

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN bundle install
RUN yarn install
RUN rails new .
RUN mv node_modules /node_modules
RUN chmod a+r /node_modules
RUN mv yarn.lock /yarn.lock

CMD /entrypoint.sh

