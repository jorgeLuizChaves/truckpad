FROM ruby:2.5.5-alpine3.10
LABEL maintainer="george.luizchaves@gmail.com"
RUN apk add --no-cache --update build-base linux-headers git postgresql-dev \
    nodejs tzdata ruby-dev ruby-nokogiri alpine-sdk sqlite-dev
ADD . /app
WORKDIR /app
RUN bundle install
EXPOSE 3000
ENTRYPOINT ["/usr/local/bundle/bin/rails", "s", "-b"]
CMD ["0.0.0.0"]