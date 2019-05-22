#!/bin/bash
# Prequisite
# Enable passwordless ssh access across all boxes for vagrant user

if [[ `hostname` == "master1.internal" ]]
then
  kubeadm init --apiserver-advertise-address=192.168.195.10 --pod-network-cidr=10.32.0.0/12 | tee /tmp/kubeadm-init.tmp
  kubeadmjoin=$(grep -A 1 "kubeadm join" /tmp/kubeadm-init.tmp)
  sed -i '/export KUBECONFIG/d' /root/.bash_profile
  sed -i -e '$aexport KUBECONFIG=/etc/kubernetes/admin.conf' /root/.bash_profile
  source /root/.bash_profile
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  for i in {0..12}
  do
    echo "Waiting for CoreDNS Pods for $((120-10*i)) seconds."
    kubectl get pods --all-namespaces
    sleep 10
  done
  echo "##################################################################"
  echo "Execute the below command on Workers Nodes as Root User"
  echo $kubeadmjoin
  echo "##################################################################"
fi
