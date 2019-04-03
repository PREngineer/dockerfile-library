FROM alpine

LABEL MAINTAINER Jorge Pabón <pianistapr@hotmail.com>

# Copy PHPInfo page
COPY phpinfo.php /apps/phpinfo.php

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the GeoIP data file
COPY GeoIP.dat /apps/GeoIP.dat

# Copy Startup script
COPY start.sh /start.sh
COPY start.sh /setup-alpine.sh

# Make Startup script executable
RUN chmod +x /start.sh \
    && chmod +x /setup-alpine.sh \
    && mkdir /apps \
    && echo "Your application files should reside in /apps." > /apps/index.html \
    && ./setup-alpine.sh

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["./start.sh"]

# Build
# docker build .
# Rename
# docker tag <img #> <name>
# Run
# docker run -d -it --name <container name> -p <local>:<container> <img name>
# Terminal into the container
# docker exec -it <conainer name> sh