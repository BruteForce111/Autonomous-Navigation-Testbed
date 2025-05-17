#!/bin/bash
# This script provisions a VM for Kubernetes by installing essential system packages,
# disabling swap, configuring kernel modules and sysctl parameters required for Kubernetes networking.
# It ensures the system is ready for Kubernetes installation and operation.

# set -euxo pipefail

# Set non-interactive mode for apt-get to avoid prompts during installation
export DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential utilities
sudo apt-get update 
sudo apt-get install -y git vim curl bash-completion 
# sudo apt-get -y upgrade  # Uncomment to upgrade all packages

# Disable swap (Kubernetes requires swap to be off)
sudo swapoff -a
# Ensure swap stays off after reboot by adding a cron job
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# Update package lists again
sudo apt-get update -y

# Load required kernel modules for Kubernetes networking
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set sysctl parameters needed for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl parameters without reboot
sudo sysctl --system

# Print the values of the key sysctl parameters to verify
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward


