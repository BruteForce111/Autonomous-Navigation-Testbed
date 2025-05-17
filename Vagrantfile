# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define VM names for the Kubernetes cluster nodes
vm_name_cp = "controlplane"      # Name for the control plane node
vm_name_w1 = "worker1"           # Name for the first worker node
vm_name_w2 = "worker2"           # Name for the second worker node

# Define static private IP addresses for each VM
vm_ip_cp = "192.168.56.10"       # IP for control plane
vm_ip_w1 = "192.168.56.11"       # IP for worker 1
vm_ip_w2 = "192.168.56.12"       # IP for worker 2

# Start Vagrant configuration block
Vagrant.configure("2") do |config|
  # Set the base box image for all VMs (Ubuntu 22.04 LTS)
  config.vm.box = "ubuntu/jammy64"

  # Sync the current project directory to /home/vagrant/codes/ inside each VM
  config.vm.synced_folder "./", "/home/vagrant/codes/"

  # Provision all VMs with initial setup scripts
  config.vm.provision "shell", path: "./KubernetesClusterSetup/provision_all.sh" # General setup
  config.vm.provision "shell", path: "./KubernetesClusterSetup/CRI_DockerEng_containerd.sh" # Install container runtimes
  config.vm.provision "shell", path: "./KubernetesClusterSetup/kubeadm_kubelet_kubectl.sh" # Install Kubernetes tools

  # Add all VM hostnames and IPs to /etc/hosts for internal name resolution
  config.vm.provision "shell", inline: "echo '#{vm_ip_cp} #{vm_name_cp}' | sudo tee -a /etc/hosts"
  config.vm.provision "shell", inline: "echo '#{vm_ip_w1} #{vm_name_w1}' | sudo tee -a /etc/hosts"
  config.vm.provision "shell", inline: "echo '#{vm_ip_w2} #{vm_name_w2}' | sudo tee -a /etc/hosts"

  # --- Control Plane Node Configuration ---
  config.vm.define vm_name_cp do |cp|
    # Set up private network and hostname
    cp.vm.network "private_network", ip: vm_ip_cp
    cp.vm.hostname = vm_name_cp  # Set internal hostname
    cp.vm.provider "virtualbox" do |vb|
      vb.name = vm_name_cp # Name in VirtualBox GUI
      vb.memory = "18240" # Allocate 17.8 GB RAM
      vb.cpus = 14        # Allocate 14 CPU cores
    end

    # Provision the control plane node with cluster setup script
    cp.vm.provision "shell", path: "./KubernetesClusterSetup/create_cluster.sh"
    
    # Wait for cluster setup to stabilize
    cp.vm.provision "shell", inline: <<-SHELL
      echo "Waiting for the cluster setup to stabilize..."
      sleep 20
    SHELL

    # Install and configure the Kubernetes network plugin (e.g., Weave Net)
    cp.vm.provision "shell", path: "./Network/network_plugin.sh"
    
    # Wait for network plugin setup to stabilize
    cp.vm.provision "shell", inline: <<-SHELL
      echo "Waiting for the network plugin setup to stabilize..."
      sleep 20
    SHELL
    
    # Install and configure the monitoring system (Prometheus, Grafana, etc.)
    cp.vm.provision "shell", path: "./MonitoringSystem/monitoring.sh"
  end

  # --- Worker Node 1 Configuration ---
  config.vm.define vm_name_w1 do |w1|
    # Set up private network and hostname
    w1.vm.network "private_network", ip: vm_ip_w1
    w1.vm.hostname = vm_name_w1 # Set internal hostname
    w1.vm.provider "virtualbox" do |vb|
      vb.name = vm_name_w1 # Name in VirtualBox GUI
      vb.memory = "6096"  # Allocate 6 GB RAM
      vb.cpus = 2         # Allocate 2 CPU cores
    end
    # Join the worker node to the Kubernetes cluster using the join command
    w1.vm.provision "shell", inline: "bash /home/vagrant/codes/join-command.sh"
  end

  # --- Worker Node 2 Configuration ---
  config.vm.define vm_name_w2 do |w2|
    # Set up private network and hostname
    w2.vm.network "private_network", ip: vm_ip_w2
    w2.vm.hostname = vm_name_w2 # Set internal hostname
    w2.vm.provider "virtualbox" do |vb|
      vb.name = vm_name_w2 # Name in VirtualBox GUI
      vb.memory = "6096"  # Allocate 6 GB RAM
      vb.cpus = 2         # Allocate 2 CPU cores
    end
    # Join the worker node to the Kubernetes cluster using the join command
    w2.vm.provision "shell", inline: "bash /home/vagrant/codes/join-command.sh"
  end

end

# End of Vagrantfile
 
