#!/bin/bash

vagrant up

sleep 5
echo "install argocd"
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbook-argo.yml

sleep 5
echo "copy kubeconfig/config"
export KUBECONFIG=./kubeconfig/config

PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

echo "Login: admin"
echo "Password: " $PASSWORD
echo "Use this data for login on 0.0.0.0:8088"

kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8088:443