#!/bin/bash

# Configure application defaults
export SCHEMAREGISTRY_URL=${SCHEMAREGISTRY_URL:-'http://schema-registry.local'}
export ALLOW_GLOBAL=${ALLOW_GLOBAL:-'1'}
export ALLOW_TRANSITIVE=${ALLOW_TRANSITIVE:-'1'}
export ALLOW_DELETION=${ALLOW_DELETION:-'1'}
export PORT=${PORT:-'80'}

# Caddy crashes on its start ("slice bounds out of range") when the resolver
# configuration carries an option of exactly eight characters, because its
# bundled DNS library reads nine characters of it to compare them with
# "attempts:". Docker hands such an option (trust-ad) over to containers on
# user-defined networks, when the host runs systemd-resolved. The option
# only tells glibc to trust the resolver, and this image is built on musl
# libc, so we drop it. The file is mounted into the container, that is why
# we rewrite its contents instead of replacing it.
sed 's/ trust-ad//g' /etc/resolv.conf > /tmp/resolv.conf
cat /tmp/resolv.conf > /etc/resolv.conf && rm -f /tmp/resolv.conf

# Start the bootstrapping
source /run.sh
