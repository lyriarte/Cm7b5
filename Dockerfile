FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    lighttpd \
    && rm -rf /var/lib/apt/lists/*

# Enable CGI module
RUN lighttpd-enable-mod cgi

# Copy config
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

# Copy static site & CGI
COPY www /var/www/
COPY cgi-bin /var/www/cgi-bin
COPY compiler /var/www/cgi-bin
RUN chmod +x /var/www/cgi-bin/*

EXPOSE 8080

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
