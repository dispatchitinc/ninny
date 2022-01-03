FROM ruby:3.1.0-alpine
RUN apk add git
RUN gem install ninny
