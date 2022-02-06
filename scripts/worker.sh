#! /bin/bash

echo "[TASK 1] Get required configs"
sudo  apt install -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster:/joincluster.sh /joincluster.sh 2>/dev/null
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster:/etc/kubernetes/admin.conf /admin.conf 2>/dev/null

echo "[TASK 2] Copy kubeconfig to vagrant home"
mkdir -p $HOME/.kube
cp -i /admin.conf $HOME/.kube/config
chown 1000:1000 $HOME/.kube/config


echo "[TASK 3] Join node to Kubernetes Cluster"
sudo  bash /joincluster.sh >/dev/null 2>&1
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
