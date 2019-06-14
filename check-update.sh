#!/bin/bash

# Run this script locally.
# ========================
# This script builds docker image and checks version of:
#   PHP, lighttpd, runit
# If it's updated then:
#   - exports version info to 'VERSION.txt'
#   - git add, merge, tag
#   - git push --tags and origin

set -e

# File Names
# ======================
PATH_FILE_VER_INFO='VERSION.txt'
PATH_FILE_VER_TEMP='VERSION.temp.txt'

# Check Updates
# =============
echo -n '- Checking for updates ... '

#name_image='mini-php7:build'
name_image='test:test'
docker build --no-cache -t $name_image .
VERSION_NEW=$(docker run --rm -v $(pwd)/check-version.sh:/check-version.sh --entrypoint /check-version.sh $name_image)

echo "${VERSION_NEW}" > $PATH_FILE_VER_TEMP
HASH_NEW=$(openssl md5 -r $PATH_FILE_VER_TEMP | awk '{ print $1 }')
HASH_OLD=$(openssl md5 -r $PATH_FILE_VER_INFO | awk '{ print $1 }')

if [ $HASH_NEW == $HASH_OLD ]; then
    echo 'NO UPDATE FOUND'
    exit 1
fi
echo 'UPDATE FOUND'

echo '==============='
echo ' UPDATE BEGIN'
echo '==============='
. ./$PATH_FILE_VER_INFO
echo '- Version info:'
echo '  - PHP Version:' $VERSION_PHP
echo '  - LIGHTTPD Version:' $VERSION_LIGHTTPD
echo '  - RUnit Version:' $VERSION_RUNIT

echo '- Update VERSION.txt'
mv $PATH_FILE_VER_TEMP $PATH_FILE_VER_INFO

# Update Docker file
echo "- Updating Dockerfile's LABEL"
dockerfile=$(cat Dockerfile \
  | sed "s/php.version=\"\(.*\)\"/php.version=\"${VERSION_PHP}\"/" \
  | sed "s/lighttpd.version=\"\(.*\)\"/lighttpd.version=\"${VERSION_LIGHTTPD}\"/" \
  | sed "s/runit.version=\"\(.*\)\"/runit.version=\"${VERSION_RUNIT}\"/"
)
echo "${dockerfile}" > Dockerfile

# Generating version tag
HASH_HEAD=$(echo $HASH_NEW | cut -c 1-8)
tag="v${VERSION_PHP}-${HASH_HEAD}"
echo "- Version tag is: ${tag}"

# Updating git
echo '- Git add'
git add .
echo '- Git commit'
git commit -m "${tag}"
echo '- Git tag'
git tag $tag
echo '- Git push tag'
git push --tags
echo '- Git push origin'
git push origin

echo '- Cleaning'
rm -f $PATH_FILE_VER_TEMP
docker image rm $name_image
docker image prune -f
