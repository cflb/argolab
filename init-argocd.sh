#!/bin/bash

set -e  # Faz o script parar imediatamente se algum comando falhar

echo "🚀 Iniciando a configuração do ambiente..."

# Instala o ArgoCD usando Ansible
echo "📦 Instalando K3d..."

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster delete k3d-cluster-1
# Inicializa a VM com Vagrant
echo "🔧 Iniciando a um cluster com k3d com 2 agentes."
k3d cluster create k3d-cluster-1 --agents 2 --api-port 0.0.0.0:6443 --port "80:30080" --port "443:30443"


# Define o KUBECONFIG para acessar o cluster Kubernetes criado
export KUBECONFIG=./kubeconfig/config
echo "✅ KUBECONFIG definido para acessar o cluster."

# Instala o ArgoCD usando Ansible
echo "📦 Instalando ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

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
