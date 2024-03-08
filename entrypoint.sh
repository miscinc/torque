#!/bin/sh

# Start Tor in the background
tor &

# Wait for the .onion hostname to be generated
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
  sleep 1
done

# Display the .onion hostname
echo "Your .onion address is:"
cat /var/lib/tor/hidden_service/hostname

# Start Nginx in the foreground
nginx -g 'daemon off;'