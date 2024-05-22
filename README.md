![mDNS enabled landoop/schema-registry-ui](https://raw.githubusercontent.com/hausgold/docker-schema-registry-ui/master/docs/assets/project.png)

[![Continuous Integration](https://github.com/hausgold/docker-schema-registry-ui/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-schema-registry-ui/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-schema-registry-ui)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/schema-registry-ui/)

This Docker images provides the [landoop/schema-registry-ui](https://hub.docker.com/r/landoop/schema-registry-ui/) image as base
with the mDNS/ZeroConf stack on top. So you can enjoy the app
while it is accessible by default as *schema-registry-ui.local*. (Port 80)

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [docker-compose usage example](#docker-compose-usage-example)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [Further reading](#further-reading)

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

To get a [Schema Registry UI](https://github.com/Landoop/schema-registry-ui)
service up and running create a `docker-compose.yml` and insert the following
snippet:

```yaml
version: "3"
services:
  kafka:
    image: hausgold/kafka
    environment:
      # Mind the .local suffix
      - MDNS_HOSTNAME=kafka.local
    ports:
      # The ports are just for you to know when configure your
      # container links, on depended containers
      - "9092"

  schema-registry:
    image: hausgold/schema-registry
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: schema-registry.local
      # Defaults to http://0.0.0.0:8081
      SCHEMA_REGISTRY_LISTENERS: http://0.0.0.0:8081
      # Defaults to kafka.local:9092
      SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS: kafka:9092
      # Set the default Apache Avro schema compatibility
      #
      # See: http://bit.ly/2TcpoY1
      # See: http://bit.ly/2Hfo4wj
      SCHEMA_REGISTRY_AVRO_COMPATIBILITY_LEVEL: full
    ports:
      # The ports are just for you to know when configure your
      # container links, on depended containers
      - "80" # CORS-enabled nginx proxy to the schema-registry
      - "8081" # direct access to the schema-registry (no CORS)
    links:
      - kafka

  schema-registry-ui:
    image: hausgold/schema-registry-ui:0.9.5
    network_mode: bridge
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: schema-registry-ui.local
      # Defaults to http://schema-registry.local
      SCHEMAREGISTRY_URL: http://schema-registry.local
```

Afterwards start the service with the following command:

```bash
$ docker-compose up
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/schema-registry-ui
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/schema-registry-ui
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
