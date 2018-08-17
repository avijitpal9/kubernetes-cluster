#!/bin/bash
# Setup basic K8S resource for initial cluster like ingress contoller
# and dashboard with ingress rules.

# kubernetes Nginx ingress Controller
kubectl apply -f k8s-resources/nginx-controller-deployment.yaml

# Exposing Kubernetes Nginx Ingress Service on NodePort
kubectl apply -f k8s-resources/ingress-service-nodeport.yaml


for i in {0..10}
do
  echo "Waiting for Nginx Controller Pods for $((120-10*i)) seconds."
  kubectl get pods --all-namespaces
  sleep 10
done

# Kubernetes Dashboard Deployment
kubectl apply -f k8s-resources/kubernetes-dashboard.yaml

for i in {0..10}
do
  echo "Waiting for Kubernetes Dashboard Pods for $((120-10*i)) seconds."
  kubectl get pods --all-namespaces
  sleep 10
done

# Disable Kubernetes Dashboard Authentication
kubectl apply -f k8s-resources/kubernetes-dashboard-admin.yaml


# Kubernetes DashBoard URL
echo "##################################################################"
echo "Kubernetes DashBoard is accessible on http://192.168.195.10:30080"
echo "##################################################################"
