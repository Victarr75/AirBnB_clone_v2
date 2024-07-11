#!/usr/bin/env bash
# This script sets up web servers for deployment of web_static.

# Install Nginx if not already installed
if ! dpkg -s nginx &> /dev/null; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create or recreate symbolic link
if [[ -L /data/web_static/current ]]; then
    sudo rm /data/web_static/current
fi
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Set ownership of directories
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
sudo sed -i '/^\tlocation \/hbnb_static\/ {$/a \
\t\talias /data/web_static/current/;\n' "$config_file"

# Restart Nginx
sudo service nginx restart

# Exit successfully
exit 0
