#!/bin/bash
# This script installs Docker Engine, Docker CLI, containerd, and configures containerd to use systemd as the cgroup driver.
# It sets up Docker's official repository, installs required packages, adds users to the docker group,
# and modifies the containerd configuration for Kubernetes compatibility.

# set -euxo pipefail

# Set non-interactive mode for apt-get to avoid prompts during installation
export DEBIAN_FRONTEND=noninteractive

# Add Docker's official GPG key and update package lists
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources
# This allows apt-get to install Docker packages from Docker's official repo

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update

# Install Docker Engine, CLI, containerd, and Docker plugins
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user and vagrant user to the docker group for non-root Docker usage
sudo usermod -aG docker $USER
sudo usermod -aG docker vagrant
# Activate the new group membership in the current shell
newgrp docker

# Configure containerd to use systemd as the cgroup driver (recommended for Kubernetes)
CONFIG_FILE="/etc/containerd/config.toml"
# Backup the original config file
sudo mv $CONFIG_FILE "${CONFIG_FILE}.backup"

# Generate a new default config and modify it
sudo containerd config default > temp.toml
# Change SystemdCgroup from false to true for runc runtime
sed -i '/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc\]/,/^\[/{s/SystemdCgroup = false/SystemdCgroup = true/}' temp.toml

# Replace the config file with the modified one
sudo cp temp.toml ${CONFIG_FILE}

# Restart containerd to apply the new configuration
sudo systemctl restart containerd