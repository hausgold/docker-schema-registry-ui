FROM landoop/schema-registry-ui:0.9.5
MAINTAINER Hermann Mayer "hermann.mayer@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=schema-registry-ui.local

# Install system packages
RUN apk add --no-cache \
  dbus avahi avahi-tools supervisor bash

# Reconfigure supervisord
RUN sed \
  -e 's#^\(files =\).*#\1 /etc/supervisor/conf.d/*.conf#g' \
  -i /etc/supervisord.conf

# Copy avahi.sh
COPY config/avahi.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/avahi.sh

# Copy schema-registry-ui.sh
COPY config/schema-registry-ui.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/schema-registry-ui.sh

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Define the command to run per default
CMD /usr/bin/supervisord -nc /etc/supervisord.conf

# Reset the base image entrypoint
ENTRYPOINT []
