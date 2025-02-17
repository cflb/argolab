#!/bin/bash

set -e  # Faz o script parar imediatamente se algum comando falhar

echo "🚀 Iniciando a configuração do ambiente..."

# Inicializa a VM com Vagrant
echo "🔧 Iniciando a máquina virtual com Vagrant..."
vagrant up

# Aguarda um tempo para garantir que a VM está totalmente pronta
sleep 5

# Instala o ArgoCD usando Ansible
echo "📦 Instalando ArgoCD..."
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbook-argo.yml

# Define o KUBECONFIG para acessar o cluster Kubernetes criado
export KUBECONFIG=./kubeconfig/config
echo "✅ KUBECONFIG definido para acessar o cluster."

# Aguarda um tempo para garantir que a instalação do ArgoCD esteja concluída
sleep 60
echo "🔔 É necessário esperar 1 minuto para o argocd terminar sua inicialização completa"
echo "🚨 Se ao final houver algum erro, provavelmente o argocd ainda nao inicializou completamente, então garanta que ele esta funcucionando e depois exponha o serviço - Leia o README.md no Topico: **Como acessar o serviço se eu parei o script?** para mais informações sobre como executar o serviço manualmente."

# Obtém a senha inicial do ArgoCD
echo "🔑 Obtendo senha do usuário admin do ArgoCD..."
PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

# Exibe as credenciais de acesso ao ArgoCD
echo "🎉 ArgoCD instalado com sucesso!"
echo "🌍 Acesse o ArgoCD em: https://0.0.0.0:8088"
echo "🔹 Login: admin"
echo "🔹 Senha: $PASSWORD"

# Expondo o serviço do ArgoCD para acesso externo
echo "🔄 Redirecionando porta 8088 para acesso ao ArgoCD..."
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8088:443
