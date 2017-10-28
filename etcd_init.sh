#!/bin/bash

#Enter scratchpad
cd /tmp

#Get etcd
wget "https://github.com/coreos/etcd/releases/download/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz"
tar -xvf etcd-v3.2.8-linux-amd64.tar.gz
sudo mv etcd-v3.2.8-linux-amd64/etcd* /usr/local/bin/
sudo mkdir -p /etc/etcd /var/lib/etcd

#Place the generated certs
sudo cp /vagrant_data/pki/ca.crt /vagrant_data/pki/issued/kubernetes.crt /vagrant_data/pki/private/kubernetes.key /etc/etcd/

#ETCD service file
ETCD_NAME=$(hostname -s)
INTERNAL_IP=$(hostname -I | awk '{print $2}' | tr -d '\n')
CLUSTER_IPS=('192.168.33.10' '192.168.33.11' '192.168.33.12')
cat > etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \
  --name ${ETCD_NAME} \
  --cert-file=/etc/etcd/kubernetes.crt \
  --key-file=/etc/etcd/kubernetes.key \
  --peer-cert-file=/etc/etcd/kubernetes.crt \
  --peer-key-file=/etc/etcd/kubernetes.key \
  --trusted-ca-file=/etc/etcd/ca.crt \
  --peer-trusted-ca-file=/etc/etcd/ca.crt \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \
  --listen-peer-urls https://${INTERNAL_IP}:2380 \
  --listen-client-urls https://${INTERNAL_IP}:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://${INTERNAL_IP}:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster master1=https://${CLUSTER_IPS[0]}:2380,master2=https://${CLUSTER_IPS[1]}:2380,master3=https://${CLUSTER_IPS[2]}:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

#Start etcd
sudo mv etcd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
