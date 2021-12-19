FROM php:7.2-fpm-stretch

# Install modules
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

CMD ["php-fpm"]
