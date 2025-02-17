# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "kmaster1" do |node|
    node.vm.hostname = "kmaster1.internal"
    node.vm.network "private_network", ip: "10.1.0.11"
  # Configuração da interface de rede
    node.vm.network "public_network", bridge: "wlo1" # Interface pública ligada à sua Wi-Fi
    node.vm.provider :virtualbox do |domain|
      domain.memory = 8096
      domain.cpus = 4
    end
  end
 
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.groups = {
      "kubernetes" => ["kmaster1"], 
      "master_root" => ["kmaster1"],
    }
  end
end
