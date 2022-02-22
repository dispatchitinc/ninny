FROM ruby:3.1.1-alpine
RUN apk add git
RUN gem install ninny
