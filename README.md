# ArgoLab

O **ArgoLab** é um ambiente de laboratório automatizado que utiliza Vagrant e Ansible para configurar um cluster Kubernetes local com k3d e implementar o ArgoCD para gerenciamento contínuo de aplicações através de GitOps.

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes softwares instalados em sua máquina:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Configuração do Ambiente

Siga os passos abaixo para configurar o ambiente:

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/cflb/argolab.git
   cd argolab

2. **Executar o Script de Inicialização**

    ```bash
    ./init-argocd.sh
    ```

**Este script realiza as seguintes ações automaticamente:**

1. Inicializa uma máquina virtual via Vagrant (vagrant up) e executa uma ***playbook.yml*** para fazer uma otimização de segurança no sistema operacionial que vai hospedar o cluster k3d.
2. Executa a ***playbook-argo.yml*** do Ansible para:
    - Instalar e configurar k3d.
    - Criar um cluster Kubernetes local com 1 controll-plane e 2 agentes.
    - Instalar e configurar o ArgoCD no namespace **argocd**.
    - Te informa na tela Login e Senha usados para acessar o serviço exposto em: ***https://0.0.0.0:8088***
    - Expõe o serviço do ArgoCD para acesso.

## Como acessar o serviço se eu parei o script?

Você não precisa iniciar o script novamente, você só precisa garantir que o cluster esta ativo. Também lembre que o kubeconfig necessário para acessar o cluster esta no diretório ***kubeconfig/*** criado apos a primeira execução com sucesso do script de inicialização.

**Export o kubeconfig para usar o cluster k3d**

Execute dentro do diretorio do Projeto clonado.

```bash
export KUBECONFIG=./kubeconfig/config
```

Você pode também definir este kubeconfig como padrão para você, copiando copiando o arquivo **config** (```cp kubeconfig/config $HOME/.kube/```) ele para o seu ***$HOME/.kube/***

**Coletar senha padrão do argocd via segredo (você pode mudar esta senha quando quiser)**

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```

**Expor agoracd on 0.0.0.0:8088 (você pode mudar a porta se quiser)***

```bash
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8088:443
```