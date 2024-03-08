# Use the official Nginx image as the base
FROM nginx:alpine

# Install Tor
RUN apk add --update tor

# Check if the 'tor' user exists, and if not, create it, then set directory permissions
# The '||' operator is used to attempt to add the tor user if getting its id fails.
RUN addgroup -S tor 2>/dev/null || true && \
    adduser -S -D -H -h /var/lib/tor -s /sbin/nologin -G tor -g tor tor 2>/dev/null || true && \
    mkdir -p /var/lib/tor /var/run/tor && \
    chown -R tor:tor /var/lib/tor /var/run/tor

# Copy the website files into the Nginx server's root directory
COPY web_content/ /usr/share/nginx/html/

# Copy the Tor configuration file into the container
COPY torrc /etc/tor/torrc

# Expose ports (80 for Nginx, 9050 for Tor SOCKS, 9051 for Tor control)
EXPOSE 80 9050 9051

# Start Nginx and Tor under 'tor' user
CMD ["sh", "-c", "su tor -s /bin/sh -c 'tor &' && nginx -g 'daemon off;'"]

# # Copy the entrypoint script
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# # Make the entrypoint script executable
# RUN chmod +x /usr/local/bin/entrypoint.sh

# # Use the entrypoint script
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# # To run
# docker build -t tor-onion-service .
# docker run -p 8080:80 -p 9050:9050 -p 9051:9051 --name tor_service tor-onion-service

# # To show hostname
# docker exec tor_service cat /var/lib/tor/hidden_service/hostname

# # To delete all docker containers 
# docker container rm $(docker container ls -aq) -f