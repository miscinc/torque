# Use the official Nginx image as the base
FROM nginx:alpine

# Install Tor
RUN apk add --update tor

# Copy the website files into the Nginx server's root directory
COPY web_content/ /usr/share/nginx/html/

# Copy the Tor configuration file into the container
COPY torrc /etc/tor/torrc

# Expose ports (80 for Nginx, 9050 for Tor SOCKS, 9051 for Tor control)
EXPOSE 80 9050 9051

# Start Nginx and Tor
CMD ["sh", "-c", "tor & nginx -g 'daemon off;'"]
