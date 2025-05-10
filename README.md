# php-apache-node Docker Image

Github repository: https://github.com/SiestaCat/docker-php-apache-node

A custom Docker image bundling PHP, Apache and Node.js for modern web applications.

## Features

- PHP 8.4 with extensions: apcu, xdebug, redis, ldap, bcmath, opcache, sockets, curl, bz2, intl, xml, zip, pdo_mysql  
- Apache 2 with `mod_rewrite` enabled  
- Node.js v20.x installed via NVM  
- Composer pre-installed  
- Supervisor process manager  

## Prerequisites

- Docker Engine ≥ 20.10

## Usage

### Pull the latest image
```bash
docker pull siestacat/php-apache-node:latest
```

### Base image in your Dockerfile
```dockerfile
FROM siestacat/php-apache-node:latest
```

### As a multi-stage build
```dockerfile
FROM siestacat/php-apache-node:latest AS base
```

## Building Locally
```bash
git clone https://github.com/SiestaCat/docker-php-apache-node.git  
cd docker-php-apache-node  
docker build  --file Dockerfile  --tag siestacat/php-apache-node:latest  --progress=plain .
```

## Configuration

- Entrypoint script: [`entrypoint.sh`](entrypoint.sh)  
- Supervisor config: [`supervisord.conf`](supervisord.conf)  

## Contributing

1. Fork the repository  
2. Create a feature branch  
3. Submit a pull request