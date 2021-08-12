FROM ruby:3.0.2-alpine
RUN apk add git
RUN gem install ninny
