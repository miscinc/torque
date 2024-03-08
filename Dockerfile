# Use the official Nginx image as the base
FROM nginx:alpine

# Install Tor
RUN apk add --update tor

# Copy the website files into the Nginx server's root directory
COPY web/ /usr/share/nginx/html/

# Copy the Tor configuration file into the container
COPY torrc /etc/tor/torrc

# Expose ports (80 for Nginx, 9050 for Tor SOCKS, 9051 for Tor control)
EXPOSE 80 9050 9051

# Start Nginx and Tor
CMD ["sh", "-c", "tor & nginx -g 'daemon off;'"]




# # To run
# docker build -t tor-onion-service .
# docker run -p 8080:80 -p 9050:9050 -p 9051:9051 --name tor_service tor-onion-service

# # To show hostname
# docker exec tor_service cat /var/lib/tor/hidden_service/hostname

# # To delete all docker containers 
# docker container rm $(docker container ls -aq) -f