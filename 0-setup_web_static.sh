#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Installing..."
    sudo apt-get install -y nginx
else
    echo "Nginx is already installed."
fi

# Create directories for static content
echo "Setting up directories for static content..."
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
sudo tee /data/web_static/releases/test/index.html > /dev/null << 'EOF'
<html>
  <head>
  </head>
  <body>
    Web Static Deployment Test
  </body>
</html>
EOF

# Create a symbolic link to the test directory
echo "Creating symbolic link to test directory..."
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ directory to the ubuntu user and group
USER="ubuntu"
GROUP="ubuntu"
echo "Setting ownership of /data/ directory to the $USER user and $GROUP group..."
sudo chown -R $USER:$GROUP /data/

# Update Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
echo "Updating Nginx configuration..."
CONFIG_FILE="/etc/nginx/sites-available/default"
if ! grep -q "location /hbnb_static/" $CONFIG_FILE; then
    sudo sed -i '/server_name _;/a \\\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' $CONFIG_FILE
else
    echo "Nginx configuration for /hbnb_static already exists."
fi

# Restart Nginx to apply the changes
echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Setup complete!"

