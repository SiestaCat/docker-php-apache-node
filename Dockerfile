FROM php:8.4.8RC1-apache-bookworm

# Switch to root

USER root

# Set chown

RUN chown -R www-data:www-data /var/www

# Install dependencies

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -

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
    nodejs \
    ripgrep \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Npm update

RUN npm cache clean --force
RUN npm install -g npm@latest
RUN npm update -g

# Switch to www-data to config npm

USER www-data

RUN mkdir -p ~/.local
RUN npm config set prefix '~/.local/'
RUN mkdir -p ~/.local/bin && echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc

# Show up the node, npm and yarn version name

RUN echo "Node version: $(node -v)"
RUN echo "Npm version: $(npm -v)"

# Switch back to root

USER root

# Pecl channel update

RUN pecl channel-update pecl.php.net

# Install PHP extensions

RUN pecl install apcu redis && \
    docker-php-ext-install ldap bcmath opcache sockets curl bz2 xml zip pdo pdo_mysql && \
    docker-php-ext-enable apcu ldap bcmath opcache sockets curl bz2 xml zip pdo pdo_mysql redis

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Change document root to public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Use a custom Apache configuration file
# This step overrides the default configuration to set the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -i 's/LogLevel warn/LogLevel debug/' /etc/apache2/apache2.conf

# give www-data a valid login shell

RUN usermod --shell /bin/bash www-data

# Configure Symfony to log to stderr in dev/prod
ENV SHELL_VERBOSITY=3

# Switch to www-data

USER www-data

WORKDIR /var/www/html

# Install composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Expose apache port

EXPOSE 80

# Copy the Supervisord configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy entrypoint

COPY --chown=www-data:www-data entrypoint.sh ./

# Override apache CMD, now will be supervisord

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

RUN mkdir -p ./public

# Remove \r

RUN dos2unix entrypoint.sh