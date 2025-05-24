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

### Pull the Claude variant
```bash
docker pull siestacat/php-apache-node:claude
```

### Base image in your Dockerfile
```dockerfile
FROM siestacat/php-apache-node:latest
```

### Base image for the Claude variant
```dockerfile
FROM siestacat/php-apache-node:claude
```

### As a multi-stage build
```dockerfile
FROM siestacat/php-apache-node:latest AS base
```

### As a multi-stage build (Claude variant)
```dockerfile
FROM siestacat/php-apache-node:claude AS base
```

## Building Locally

```bash
git clone https://github.com/SiestaCat/docker-php-apache-node.git
cd docker-php-apache-node

# build 'latest'
docker build  --file Dockerfile  --tag siestacat/php-apache-node:latest  --progress=plain .

# build 'claude'
docker build --file Dockerfile.claude --tag siestacat/php-apache-node:claude --progress=plain .
```

### Push to Docker Hub

```bash
# push 'latest'
docker push siestacat/php-apache-node:latest

# push 'claude'
docker push siestacat/php-apache-node:claude
```

## Configuration

- Entrypoint script: [`entrypoint.sh`](entrypoint.sh)  
- Supervisor config: [`supervisord.conf`](supervisord.conf)  

## Contributing

1. Fork the repository  
2. Create a feature branch  
3. Submit a pull request