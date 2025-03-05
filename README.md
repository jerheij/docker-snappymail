## Snappymail and nginx container

### Sources
Base image: [ubuntu:focal](https://hub.docker.com/_/ubuntu/)  
Main software: [Snappymail](https://snappymail.eu/)  
Packages: php-fpm, openssl, nginx, supervisor, snappymail


### Requirements
A mailserver running SMTP and POP3/IMAP to connect to.

### Usage

#### Docker compose example
```
---
version: "2"  
services:
  snappymail:
    jerheij/snappymail:stable
    container_name: snappymail
    restart: always
    ports:
      - 443:443
      - 80:80
    environment:
      UID: 2000
      GID: 2000
      UPLOAD_MAX_SIZE: 128M
      SERVER_NAME: webmail.somedomain.uk
      LOG_TO_STDOUT: 'true'
    volumes:
      - /opt/docker/snappymail:/var/lib/snappymail
      - /etc/pki/tls/certs/webmail.somedomain.uk.fullchain.pem:/etc/nginx/ssl/cert.pem:ro
      - /etc/pki/tls/private/webmail.somedomain.uk.key.pem:/etc/nginx/ssl/key.pem:ro
      - /opt/docker/snappymail/client_certs:/client
      - /opt/docker/snappymail/ssl/dhparam.pem:/etc/nginx/ssl/dhparam.pem:ro
```

### SSL
The container has SSL enabled by default and expects the certificate chain and key to be available at the following locations inside the container:
- /etc/nginx/ssl/cert.pem
- /etc/nginx/ssl/key.pem

For added security I have added a dhparam parameter in the nginx configuration so it expects a dhparam.pem file at the following location:
- /etc/nginx/ssl/dhparam.pem

### Volumes
| Location in container      | Content                                                                              |
|----------------------------|--------------------------------------------------------------------------------------|
| /var/lib/snappymail        | Directory containing the Snappymail data (configuration, plugins, cache)             |
| /etc/nginx/ssl/cert.pem    | SSL webserver certificate in PEM format                                              |
| /etc/nginx/ssl/key.pem     | SSL webserver key in PEM format                                                      |
| /client                    | Location the container looks for CLIENT_CERT file                                    |
| /etc/nginx/ssl/dhparam.pem | Nginx dhparam file ([link](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)) |

### Variables
| Variable          | Function                                                      | Optional | Default |
|-------------------|---------------------------------------------------------------|----------|---------|
| `SERVER_NAME`     | Hostname of the website to reach the webmail                  | no       | no      |
| `UID`             | UID of the web user, for mount and persistence compatibility  | yes      | 991     |
| `GID`             | GID of the web group, for mount and persistence compatibility | yes      | 991     |
| `UPLOAD_MAX_SIZE` | Attachment size limit                                         | yes      | 25M     |
| `LOG_TO_STDOUT`   | Enable nginx and php error logs to stdout                     | yes      | false   |
| `MEMORY_LIMIT`    | PHP memory limit                                              | yes      | 128M    |
| `CLIENT_CERT`     | Client verification certificate                               | yes      | no      |

### Changes
I have introduced a "stable" tag instead of the "latest". The "latest" tag will be the git "master" branch while the "stable" tag will be the latest git tag.

For changes in the different versions see my [github](https://github.com/jerheij/docker-snappymail) repo's commit messages.

### Author
Jerheij
