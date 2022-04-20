FROM ruby:3.1.2-alpine
RUN apk add git
RUN gem install ninny
