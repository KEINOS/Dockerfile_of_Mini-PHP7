[![](https://images.microbadger.com/badges/image/keinos/mini-php7.svg)](https://microbadger.com/images/keinos/mini-php7 "See image details on microbadger.com") [![](https://img.shields.io/docker/cloud/automated/keinos/mini-php7.svg)](https://hub.docker.com/r/keinos/mini-php7 "Docker Cloud Automated build") [![](https://img.shields.io/docker/cloud/build/keinos/mini-php7.svg)](https://hub.docker.com/r/keinos/mini-php7/builds "Docker Cloud Build Status")

# Dockerfile of mini-php7

**Super-lightweight PHP7 Web Server container.**

```bash
docker pull keinos/mini-php7:latest
```

- Note: This is a fork of "[mini-php](https://hub.docker.com/r/sseemayer/mini-php/)" but with PHP7 and latest Alpine image.
- Base image: [keinos/alpine:latest](https://hub.docker.com/r/keinos/alpine/) ([Alpine Linux](http://www.alpinelinux.org/))
  - [lighttpd](https://www.lighttpd.net/)
  - [php-fpm7](http://php-fpm.org/)
  - [runit](http://smarden.org/runit/)
- Exposed port: `80`
- Document Root: `/app/htdocs` (Place your webapp into the container at this directory)
- Repositories:
  - Image: https://hub.docker.com/r/keinos/mini-php7 @ DockerHub
  - Source: https://github.com/KEINOS/Dockerfile_of_Mini-PHP7 @ GitHub

## Sample Usage

```shellsession
$ # Pull image
$ docker pull keinos/mini-php7
...
$ # Prepare sample PHP file
$ ls
index.php
$ # Contents of the sample PHP file
$ cat index.php
＆lt;?php

echo 'Hello World!' . PHP_EOL;

$
$ # Run container in background, mounting the current
$ # directory at /app/htdocs/ as a document root dir
$ # of the web server and listens at port 8001 by port
$ # forwarding from 8001 to 80 (from host to container).
$ docker run --rm -d -v $(pwd):/app/htdocs -p 8001:80 keinos/mini-php7
30b4925837ff3f6a8ce9e1eb7c9f8ba77aedc864af1b15e71bb4f35ab5f6dcc1
$
$ # Web access from the host to host it self at container's port(8001)
$ curl http://localhost:8001/
Hello World!
$
$ # Check running container in background
$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
30b4925837ff        test                "/bin/sh -c 'runsvdi…"   19 minutes ago      Up 19 minutes       0.0.0.0:8001-&gt;80/tcp   clever_thompson
$
$ # Login to the running container for maintenance
$ docker exec -it 30b49 /bin/sh
/app/htdocs #
/app/htdocs # ls
index.php
/app/htdocs # exit
$
```
