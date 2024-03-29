FROM php:8.0-fpm-alpine

ARG version='3.28.26+220829'

# Install OS dependencies
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libpng-dev \
        libzip-dev \
        libjpeg-turbo-dev \
        tidyhtml-dev \
        libsodium-dev \
        openldap-dev \
        oniguruma-dev \
        imap-dev \
        postgresql-dev && \
        apk add --no-cache netcat-openbsd bash

# Install PHP Plugins
RUN set -ex; \
        docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr && \
        docker-php-ext-configure imap --with-imap-ssl && \
        docker-php-ext-install \
        gd \
        imap \
        ldap \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        sodium \
        tidy \
        zip

# Download LimeSurvey
RUN curl -sSL "https://github.com/LimeSurvey/LimeSurvey/archive/${version}.tar.gz" --output /tmp/limesurvey.tar.gz

#Remove temp folder from LimeSurvey and create directory for runtime
RUN set -ex; \
        tar xzvf "/tmp/limesurvey.tar.gz" --strip-components=1 -C /var/www/html/ && \
        \
        rm -rf "/tmp/limesurvey.tar.gz" \
        /var/www/html/docs \
        /var/www/html/tests \
        /var/www/html/*.md && \
        mkdir -p /var/limesurvey/runtime
        

#fetch and install plugins
RUN set -ex; \
        wget http://extensions.sondages.pro/IMG/auto/addScriptToQuestion.zip -P /var/www/html/plugins/ && \
        unzip /var/www/html/plugins/addScriptToQuestion.zip -d /var/www/html/plugins/ && \
        rm /var/www/html/plugins/addScriptToQuestion.zip

#set ownership and permissions 
RUN set -ex; \
       chown -R www-data:www-data /var/www/ /var/limesurvey/runtime/; \
        find /var/www/html/ -type d -exec chmod 755 {} \; &&\
        find /var/www/html/ -type f -exec chmod 644 {} \; && \
        find /var/www/html/plugins/ -type d -exec chmod 750 {} \; &&\
        find /var/www/html/plugins/ -type f -exec chmod 640 {} \;

#Create robots.txt and set permissions
RUN set -ex; \
        printf "User-agent: *\nDisallow: /\n" > /var/www/html/robots.txt && \
        chmod 0444 /var/www/html/robots.txt

#For the nginx->fpm
EXPOSE 9000

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/var/www/html/entrypoint.sh"]
CMD ["php-fpm"]
