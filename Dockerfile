FROM ruby:3.2.2-alpine
RUN apk add git
RUN gem install ninny
