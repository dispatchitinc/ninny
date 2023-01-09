FROM ruby:3.2.0-alpine
RUN apk add git
RUN gem install ninny
