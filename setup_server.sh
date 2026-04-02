#!/bin/bash

# Function to install Nginx
install_nginx() {
    echo "Updating package index..."
    sudo apt update
    echo "Installing Nginx..."
    sudo apt install -y nginx
    echo "Starting Nginx..."
    sudo systemctl start nginx
    echo "Enabling Nginx to start on boot..."
    sudo systemctl enable nginx
    echo "✅ Nginx installed and started."
}

# Function to configure UFW
configure_ufw() {
    echo "Configuring UFW to allow HTTP and HTTPS traffic..."
    sudo ufw allow 'Nginx Full'
    echo "✅ UFW configured."
}

# Function to install Docker
install_docker() {
    echo "Removing old versions of Docker..."
    sudo apt remove -y docker docker-engine docker.io containerd runc
    echo "Installing necessary packages for Docker..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    echo "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    echo "Setting up the stable repository for Docker..."
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    echo "Updating the package index again..."
    sudo apt update
    echo "Installing Docker..."
    sudo apt install -y docker-ce
    echo "Starting Docker..."
    sudo systemctl start docker
    echo "Enabling Docker to start on boot..."
    sudo systemctl enable docker
    echo "Adding your user to the Docker group..."
    sudo usermod -aG docker $USER
    echo "✅ Docker installed."
}

# Function to configure Docker log rotation
configure_docker_logs() {
    echo "Configuring Docker log rotation..."
    sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "5"
  }
}
EOF
    echo "Restarting Docker to apply log config..."
    sudo systemctl restart docker
    echo "✅ Docker log rotation configured (max 50MB x 5 files = 250MB per container)."
}

# Function to setup Docker maintenance (weekly image cleanup)
configure_docker_maintenance() {
    echo "Setting up weekly Docker image cleanup..."
    (sudo crontab -l 2>/dev/null; echo "0 22 * * 0 docker system prune -a -f >> /var/log/docker-prune.log 2>&1") | sudo crontab -
    echo "✅ Weekly Docker cleanup scheduled (every Sunday at 3am)."
}

# Main script execution
install_nginx
configure_ufw
install_docker
configure_docker_logs
configure_docker_maintenance

echo ""
echo "🎉 Setup complete! Nginx, UFW, and Docker are ready."
echo "⚠️  Log out and back in for Docker group changes to take effect."
