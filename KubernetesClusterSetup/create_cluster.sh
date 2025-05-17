#!/bin/bash
# This script automates the initialization of a single-node Kubernetes cluster using kubeadm on a VM.
# It sets up the Kubernetes control plane, configures kubectl for both the vagrant user and root,
# saves the join command for worker nodes, removes the NoSchedule taint from the control plane node
# (so it can run pods), and enables kubectl bash auto-completion for convenience.

# Set non-interactive mode for apt-get to avoid prompts during installation
export DEBIAN_FRONTEND=noninteractive

# Update package lists
sudo apt-get update

# Initialize the Kubernetes control plane with a specific API server address and pod network CIDR
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16

# Set up kubectl config for the vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube

# Set up kubectl config for the current user (root or whoever runs the script)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Save the kubeadm join command to a shared location for adding worker nodes later
kubeadm token create --print-join-command > /home/vagrant/codes/join-command.sh

# Remove the NoSchedule taint from the control plane node so it can run regular pods
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-  

# Install bash-completion for kubectl command auto-completion
sudo apt-get update
sudo apt-get -y install bash-completion

# Enable kubectl auto-completion for the current user and vagrant user
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'source <(kubectl completion bash)' >> /home/vagrant/.bashrc
