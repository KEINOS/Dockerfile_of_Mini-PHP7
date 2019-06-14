#!/bin/sh

# Run this script INSIDE container.
# =================================
# This script just echoes the following app version:
#   PHP, lighttpd, runit

#set -o pipefail
set -e

# Get PHP version
VERSION_PHP=$(php -i | grep 'PHP Version' | head -1 | sed -e 's/[^0-9\.]//g')
# Get LIGHTTPD version
VERSION_LIGHTTPD=$(lighttpd -v | sed -e 's/[^0-9\.]//g')
# Get RUnit version
VERSION_RUNIT=$(apk list 2>&1 | grep installed | grep runit | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')

echo "VERSION_PHP=\"$VERSION_PHP\""
echo "VERSION_LIGHTTPD=\"$VERSION_LIGHTTPD\""
echo "VERSION_RUNIT=\"${VERSION_RUNIT}\""
