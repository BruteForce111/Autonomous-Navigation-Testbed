#!/bin/bash
# This script installs Kubernetes tools (kubeadm, kubelet, kubectl) on an Ubuntu system.
# It adds the official Kubernetes apt repository, installs the required packages,
# and ensures they are held at their installed versions. It also enables the kubelet service.

# set -euxo pipefail

# Set non-interactive mode for apt-get to avoid prompts during installation
export DEBIAN_FRONTEND=noninteractive

# Update package lists
sudo apt-get update

# Install required packages for apt over HTTPS and for handling certificates and keys
# (apt-transport-https may be a dummy package on newer systems)
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Ensure the keyrings directory exists for storing trusted keys
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download and add the Kubernetes apt repository GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository to the system's sources list
# This will overwrite any existing kubernetes.list configuration
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again to include the new Kubernetes repository
sudo apt-get update

# Install kubelet (node agent), kubeadm (cluster bootstrap tool), and kubectl (command-line tool)
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent these packages from being automatically updated (to avoid version mismatches)
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start the kubelet service
sudo systemctl enable --now kubelet


