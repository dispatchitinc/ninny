FROM ruby:3.1.3-alpine
RUN apk add git
RUN gem install ninny
