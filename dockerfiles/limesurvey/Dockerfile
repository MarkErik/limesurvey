FROM php:7.4-fpm-alpine

# Install OS dependencies
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libpng-dev \
        libzip-dev \
        libjpeg-turbo-dev \
        openldap-dev \
        oniguruma-dev \
        imap-dev && \
        apk add --no-cache netcat-openbsd bash

# Install PHP plugins
RUN set -ex; \
        docker-php-ext-configure gd --with-freetype --with-jpeg ; \
        docker-php-ext-configure imap --with-imap-ssl && \
        docker-php-ext-install \
        gd \
        imap \
        mbstring \
        pdo \
        pdo_mysql \
        zip

# Download LimeSurvey
RUN curl -sSL "https://download.limesurvey.org/lts-releases/limesurvey3.25.2+201131.zip" --output /tmp/limesurvey.zip

#Remove temp folder from LimeSurvey and create directory for runtime
RUN set -ex; \
        tar xzvf "/tmp/limesurvey.zip" --strip-components=1 -C /var/www/html/ && \
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
