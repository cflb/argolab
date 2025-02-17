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
    ./init-playbooks.sh
    ```

**Este script realiza as seguintes ações automaticamente:**

1. Inicializa uma máquina virtual via Vagrant (vagrant up).
2. Executa um playbook do Ansible para:
    - Instalar e configurar k3d.
    - Criar um cluster Kubernetes local.
    - Instalar e configurar o ArgoCD.
    - Te informa na tela Login e Senha usados para acessar o serviço esposto em: ***https://0.0.0.0:80888***
    - Expõe o serviço do ArgoCD para acesso.