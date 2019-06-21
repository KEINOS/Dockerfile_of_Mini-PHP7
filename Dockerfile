FROM keinos/alpine:latest

ARG PORT=80
# Install dependencies
RUN apk add --no-cache \
      lighttpd \
      php7-fpm \
      runit \
    && rm -rf /var/cache/apk/*

# Set up folders, configure lighttpd and php-fpm7
RUN mkdir -p /app/htdocs /app/error /etc/service/lighttpd /etc/service/php-fpm \
    && sed -i -E \
      -e 's/var\.basedir\s*=\s*".*"/var.basedir = "\/app"/' \
      -e 's/#\s+(include "mod_fastcgi_fpm.conf")/\1/' \
      -e "s/#\s+server.port\s+=\s+81/server.port = $PORT/" \
      /etc/lighttpd/lighttpd.conf \
    && sed -i -E \
      -e 's/user\s*=\s*nobody/user = lighttpd/' \
      /etc/php7/php-fpm.conf \
    && touch /var/log/php-fpm.log \
    && chown -R lighttpd /var/log/php-fpm.log \
    && echo -e "#!/bin/sh\nlighttpd -D -f /etc/lighttpd/lighttpd.conf" > /etc/service/lighttpd/run \
    && echo -e "#!/bin/sh\nphp-fpm7 --nodaemonize" > /etc/service/php-fpm/run \
    && chmod -R +x /etc/service/* \
    && ln -s /usr/sbin/php-fpm7 /usr/bin/php

LABEL url.maintainer=https://github.com/KEINOS/ \
      url.image=https://hub.docker.com/r/keinos/php7-alpine \
      url.source=https://github.com/KEINOS/Dockerfile_of_PHP7-Alpine \
      version.php="7.2.18" \
      version.lighttpd="1.4.52" \
      version.runit="2.1.2"

EXPOSE $PORT

WORKDIR /app/htdocs

CMD ["runsvdir", "-P", "/etc/service"]

USER root
