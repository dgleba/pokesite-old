FROM ruby:2.2.3-slim

RUN apt-get update && apt-get install -y --no-install-recommends build-essential nodejs && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 3000

ENV BUNDLE_PATH /ruby_gems

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock

RUN bundle install
