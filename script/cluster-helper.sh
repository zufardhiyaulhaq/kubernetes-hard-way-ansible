#!/bin/bash

# if you want to change the variable like cluster-name
# and network in vagrant, hosts/hosts and group_vars
# this script help you to change them automatically

read -p "cluster name: " CLUSTER_NAME

echo ""
echo "please only provide the network section"
echo "example 10.200.100.0/24 just input 10.200.100"
read -p "network address: " NETWORK_ADDRESS

echo ""
sed -i '.bak' "s/kubernetes-cluster-01/$CLUSTER_NAME/g" ../
sed -i '.bak' "s/10.200.100/$NETWORK_ADDRESS/g" ../

