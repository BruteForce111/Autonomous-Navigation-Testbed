# Autonomous-Navigation-Testbed

Welcome to the Autonomous-Navigation-Testbed repository, an integrated environment designed for robust Kubernetes cluster management, ROS2 applications, and advanced monitoring systems using Vagrant and VirtualBox. This setup provides a comprehensive toolkit for developing, monitoring, and analyzing robotic systems and data.

## Overview

This project leverages Vagrant to automate the deployment of a Kubernetes cluster, configuring VirtualBox virtual machines, and setting up an extensive monitoring system. It is tailored for both development, particularly in robotic systems where ROS2 applications are prevalent.

## Installation and Usage

### Prerequisites

Before beginning, ensure you have VirtualBox and Vagrant installed on your machine.

#### Installation of VirtualBox

To install VirtualBox, run the following commands:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install virtualbox -y
```

Alternatively, you can download and install VirtualBox from the following link:
- https://www.virtualbox.org/wiki/Linux_Downloads
- https://download.virtualbox.org/virtualbox/7.0.14/virtualbox-7.0_7.0.14-161095~Ubuntu~jammy_amd64.deb

#### Installation of Vagrant

Install Vagrant with these commands:

```bash
sudo apt update && sudo apt upgrade -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

Verify the installation:

```bash
vagrant --version
```

To create the VMs and set up the Kubernetes cluster, clone the repository and execute the following:

```bash
git clone https://github.com/BruteForce111/Autonomous-Navigation-Testbed.git
cd Autonomous_Navigation_Testbed
vagrant up | tee vagrant.log
```

Follow the specific details provided in each subcomponent's README for detailed setup and usage guidelines.

## Project Structure

### Kubernetes Cluster Setup
Scripts and configurations to initialize a Kubernetes cluster. [More Details](./KubernetesClusterSetup/README.md)

- [Deploying a Kubernetes Cluster Using Vagrant and VirtualBox](./KubernetesClusterSetup/README.md#introduction)
- [Pre-requisites and Dependencies](./KubernetesClusterSetup/README.md#pre-requisites)
- [Cluster VM's Lifecycle Commands](./KubernetesClusterSetup/README.md)
- [Technical Details (Vagrantfile, Kubeadm, Kubectl, Kubelet, Container Network Interface Plugin)](./KubernetesClusterSetup/README.md)

### Network Configuration

Scripts to configure the network using CNI plugins like Weave Net. [More Details](./Network/README.md)

- [VMs/Nodes Network Configuration](./Network/README.md)
- [Kubernetes Network Plugin - CNI Plugin Configuration](./Network/README.md)

### Monitoring System 

- [Metrics Server](./MonitoringSystem/README.md)
- [Kubernetes Dashboard](./MonitoringSystem/README.md)
- [Dashboard Access and Security](./MonitoringSystem/README.md)
- [Prometheus and Grafana](./MonitoringSystem/README.md)
- [Helm](./MonitoringSystem/README.md)
- [Persistent Volume Configuration](./MonitoringSystem/README.md)
- [GUI Access URLs and Credentials](./MonitoringSystem/README.md)

### ROS2 Deployment

Deployment instructions and configurations for ROS2 Talker and Listener nodes. [More Details](./ROS2/README.md)

- [ROS2 (Robot Operating System 2)](./ROS2/README.md)
- [ROS2 Nodes vs. Kubernetes Nodes](./ROS2/README.md)
- [ROS2 Talker and Listener Nodes](./ROS2/README.md)
- [Deploying the ROS2 Nodes](./ROS2/README.md)
- [Testing the ROS2 Nodes](./ROS2/README.md)


### Data Analysis Tools

Python and Jupyter Notebook setups for analyzing data collected from the environment. [More Details](./DataAnalysis/README.md)

- [Data Extraction From Prometheus TSDB Databases](./DataAnalysis/README.md)
- [Using Python and Jupyter for Data Analysis](./DataAnalysis/README.md)



## Acknowledgments
- Kubernetes
- Vagrant
- VirtualBox
- Prometheus
- Grafana
- ROS2

Thank you for exploring our Autonomous-Navigation-Testbed repository. Dive into each component for a deeper understanding and more detailed documentation!