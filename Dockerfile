FROM php:7.0.3-zts

ENV LIBRDKAFKA confluent-debian-0.9.0.99
ENV PHPRDKAFKA 0.9.1-php7

RUN apt-get update && apt-get install -y zlibc libssl-dev libsasl2-dev python

# Install C Kafka client
RUN cd /tmp \
  && curl -O -L https://github.com/edenhill/librdkafka/archive/$LIBRDKAFKA.tar.gz \
  && tar xzvf $LIBRDKAFKA.tar.gz \
  && cd /tmp/librdkafka-$LIBRDKAFKA \
  && ./configure && make && make install

# Install PHP Kafka client
RUN cd /tmp \
  && curl -O -L https://github.com/arnaud-lb/php-rdkafka/archive/$PHPRDKAFKA.tar.gz \
  && tar xzvf $PHPRDKAFKA.tar.gz \
  && cd /tmp/php-rdkafka-$PHPRDKAFKA \
  && phpize \
  && ./configure && make && make install \
  && docker-php-ext-enable rdkafka

RUN pecl install pthreads && docker-php-ext-enable pthreads
