FROM php:8.4.7-apache

# Switch to root

USER root

# Install dependencies

RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -yqq \
    software-properties-common \
    dos2unix \
    gnupg2 \
    smbclient \
    lsb-release \
    supervisor \
    git \
    p7zip-full \
    unzip \
    wget \
    libcurl4-openssl-dev \
    libbz2-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    openssh-client \
    build-essential \
    libaio1 \
    inetutils-ping \
    libldap2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Pecl channel update

RUN pecl channel-update pecl.php.net

# Install PHP extensions

RUN pecl install apcu xdebug redis && \
    docker-php-ext-install ldap bcmath opcache sockets curl bz2 intl xml zip pdo pdo_mysql && \
    docker-php-ext-enable apcu xdebug ldap bcmath opcache sockets curl bz2 intl xml zip pdo pdo_mysql redis

# Install NPM using NVM

ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=v20.16.0

RUN mkdir -p $NVM_DIR \
 && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
 && . $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm use $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && echo 'export NVM_DIR="$NVM_DIR"' >> /etc/bash.bashrc \
 && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc \
 && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/bash.bashrc

ENV PATH=$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# Show up the node, npm and yarn version name

RUN echo "Node version: $(node -v)"
RUN echo "Npm version: $(npm -v)"

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Change document root to public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Use a custom Apache configuration file
# This step overrides the default configuration to set the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Change permissions

RUN chown -R www-data:www-data /var/www

# Switch to www-data

USER www-data

# Install composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer