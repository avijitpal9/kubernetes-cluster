#!/bin/bash
cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.195.10 master1.internal master1
192.168.195.20 node1.internal node1
192.168.195.30 node2.internal node2
EOF
yum install vim telnet nc -y
# Open Port on master1
if [[ `hostname` == "master1.internal" ]]
then
  iptables -I INPUT -p tcp --dport 6443 -j ACCEPT
  iptables -I INPUT -p tcp --dport 2379 -j ACCEPT
  iptables -I INPUT -p tcp --dport 2380 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10250 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10251 -j ACCEPT
  iptables -I INPUT -p tcp --dport 10252 -j ACCEPT
elif [[ `hostname` =~ node?.internal ]]
then
  iptables -I INPUT -p tcp --dport 10250 -j ACCEPT
  iptables -I INPUT -p tcp --dport 2379 -j ACCEPT
fi

# Disable Swap
sed -i -e '/swap/s/^#*/#/' /etc/fstab
swapoff -a

# Install Docker
yum install -y docker
systemctl enable docker && systemctl start docker

# set selinux to permissive mode
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux

# set Kernel parameters
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Set up Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Install kubelet kubeadm kubectl
yum install -y kubelet-1.11.2-0 kubeadm-1.11.2-0 kubectl-1.11.2-0 --disableexcludes=kubernetes
cat <<EOF > /etc/systemd/system/kubelet.service.d/11-cgroups.conf
[Service]
CPUAccounting=true
MemoryAccounting=true
EOF
systemctl daemon-reload && systemctl enable kubelet && systemctl start kubelet

## Run Script to Create K8S Cluster
#if [[ `hostname` == "master1.internal" ]]
#then
#  bash kubeadm-init.sh
#fi
