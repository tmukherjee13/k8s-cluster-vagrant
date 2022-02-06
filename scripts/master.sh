#! /bin/bash

MASTER_IP="192.168.56.10"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"


echo "[TASK 1] Pull required containers"
sudo kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP  --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
sudo kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] Copy kubeconfig to vagrant home"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown 1000:1000 $HOME/.kube/config




## ------------------------------------ ##

# Install Metrics Server

#kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml

# Install Kubernetes Dashboard

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# Create Dashboard User

#cat <<EOF | kubectl apply -f -
#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  name: admin-user
#  namespace: kubernetes-dashboard
#EOF

#cat <<EOF | kubectl apply -f -
#apiVersion: rbac.authorization.k8s.io/v1
#kind: ClusterRoleBinding
#metadata:
#  name: admin-user
#roleRef:
#  apiGroup: rbac.authorization.k8s.io
#  kind: ClusterRole
#  name: cluster-admin
#subjects:
#- kind: ServiceAccount
#  name: admin-user
#  namespace: kubernetes-dashboard
#EOF

#kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" >> /vagrant/configs/token

