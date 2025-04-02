# -*- mode: ruby -*- 
# vi: set ft=ruby : 

Vagrant.configure("2") do |config| 
    if Vagrant.has_plugin? "vagrant-vbguest" 
      config.vbguest.no_install  = true 
      config.vbguest.auto_update = false 
      config.vbguest.no_remote   = true 
    end
    # máquina de control (control-node)
    config.vm.define "control-node" do |control| 
      control.vm.box = "bento/ubuntu-22.04" 
      control.vm.network :private_network, ip: "192.168.100.3" 
      control.vm.hostname = "control-node"
      control.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      control.vm.provision "shell", path: "control.sh"
    end  
    # máquina target (web-node)
    config.vm.define "web-node" do |web| 
      web.vm.box = "bento/ubuntu-22.04" 
      web.vm.network :private_network, ip: "192.168.100.2" 
      web.vm.hostname = "web-node" 
      web.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
      web.vm.provision "shell", path: "web.sh"
    end
    # Configurar SSH para que la máquina de control pueda acceder a la target
    config.vm.provision "shell", privileged: false, run: "always", inline: <<-SHELL
      if [ "$(hostname)" = "control-node" ]; then
        cat /home/vagrant/.ssh/id_rsa.pub | sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@192.168.100.2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
        echo "Configuración de claves SSH entre nodos completada"
      fi
    SHELL
  end