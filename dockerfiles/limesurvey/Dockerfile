FROM php:7.4-fpm-alpine
LABEL maintainer="markus@martialblog.de"
ARG version='3.24.3+201027'


# Install OS dependencies
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        imap-dev \
        oniguruma-dev \
        libzip-dev && \
        apk add --no-cache netcat-openbsd bash

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP Plugins
RUN docker-php-ext-configure imap --with-imap-ssl
        
RUN docker-php-ext-install \
        gd \
        imap \
        mbstring \
        pdo \
        pdo_mysql \
        zip

# Download, unzip and chmod of LimeSurvey
RUN curl -sSL "https://github.com/LimeSurvey/LimeSurvey/archive/${version}.tar.gz" --output /tmp/limesurvey.tar.gz

RUN set -ex; \
        tar xzvf "/tmp/limesurvey.tar.gz" --strip-components=1 -C /var/www/html/ && \
        \
        rm -rf "/tmp/limesurvey.tar.gz" \
        /var/www/html/docs \
        /var/www/html/tests \
        /var/www/html/*.md && \
        chown -R www-data:root /var/www/ ; \
        chmod -R g=u /var/www

EXPOSE 9000

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/var/www/html/entrypoint.sh"]
CMD ["php-fpm"]
