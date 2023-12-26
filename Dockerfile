FROM ruby:3.3.0-alpine
RUN apk add git
RUN gem install ninny
