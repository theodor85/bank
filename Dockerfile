FROM ruby:3.2.1

RUN apt-get update

# pg gem`s dependencies
RUN apt-get install libpq-dev -y

WORKDIR /app

RUN gem install bundler
COPY ./Gemfile      /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
RUN bundle

COPY  . .
RUN chmod +x ./start.sh
