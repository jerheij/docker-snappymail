FROM ubuntu:focal

RUN apt-get update -y && \
    apt-get install -y ca-certificates && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

COPY rootfs /

VOLUME /var/lib/snappymail

ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install snappymail -y && \
    apt-get install -y \
    supervisor \
    php-dom \
    php-mysql && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/share/snappymail/ -type d -exec chmod 755 {} \; && \
    find /usr/share/snappymail/ -type f -exec chmod 644 {} \; && \
    rm -vf /etc/nginx/sites-enabled/default && \
    mkdir /logs

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/run.sh"]

CMD ["supervisord", "-c", "/conf/supervisor.conf"]]
