FROM ruby:3.0.3-alpine
RUN apk add git
RUN gem install ninny
