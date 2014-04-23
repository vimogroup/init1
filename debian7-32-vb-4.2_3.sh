#!/bin/bash

# http://git.io/n4OFcg
 
#date > /etc/vagrant_box_build_time
 
#echo 'ubuntu-saucy.vagrant' > /etc/hostname
#echo '127.0.0.1 ubuntu-saucy.vagrant' >> /etc/hosts
#start hostname
 
apt-get -y update
#Este lo documente porque no se si pudiera afectar
#apt-get -y upgrade
apt-get -y install libsdl-ttf2.0-0:amd64 gcc-4.6-base:amd64 cpp-4.6 dkms gcc-4.6 linux-headers-amd64 linux-kbuild-3.2

#apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev
#apt-get -y install vim
#apt-get -y install dkms
#apt-get -y install nfs-common
apt-get clean

cat > /etc/apt/sources.list.d/virtualbox.list <<EOF
deb http://download.virtualbox.org/virtualbox/debian wheezy contrib
EOF

#eliminamos el virtualbox 4.2

apt-get remove virtualbox-4.2

#Agregamos la key
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -


   apt-get -y update
   apt-get -y install virtualbox-4.3
   apt-get -y install dpkg-dev dkms

#instalamos lo demas

wget http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.deb

dpkg -i vagrant_1.3.5_x86_64.deb

#Instalamos varios sis


   vagrant box add precise32 http://files.vagrantup.com/precise32.box
 
   vagrant box add vmdebian http://puppet-vagrant-boxes.puppetlabs.com/debian-73-i386-virtualbox-puppet.box  

#   vagrant box add fedora18 http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210.box
 
#   vagrant box add centos65 http://puppet-vagrant-boxes.puppetlabs.com/centos-65-i386-virtualbox-puppet.box

# checamos que esten instaladas:

vagrant box list

#plugins

#Vamos a instalar el plugin pero actualizando a la ultima version:

vagrant plugin install vagrant-vbguest

#Ahora vamos a actualizar a la ultima version:

wget https://www.virtualbox.org/download/testcase/VBoxGuestAdditions_4.3.11-93070.iso‌​ sudo cp VBoxGuestAdditions_4.3.11-93070.iso /usr/share/virtualbox/VBoxGuestAdditions.iso



vagrant plugin install vagrant-hostsupdater

#vamos a crear los archivos de configuracion


   mkdir /home/vm
   chmod 777 /home/vm
   cd  /home/vm
   
cat > /home/vm/Vagrantfile <<EOF

# -*- mode: ruby -*-
# vi: set ft=ruby :

####Esto va en el encabezado
require 'yaml'
servers = YAML::load_file('servers.yaml')


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
 # config.vm.box = "precise32"

	servers.each do |servers|
	    config.vm.define servers["name"] do |serv|
		serv.vm.box = servers["box"]
		serv.vm.hostname = servers["hostname"]

		serv.vm.provider "virtualbox" do |v|

	#           v.customize ["modifyvm", :id, "--ioapic", "on"]
	#           v.memory = 64
	#           v.cpus = servers["cpu"]

	#            v.customize ["modifyvm", :id, "--ioapic", "on"]
		    v.customize ["modifyvm", :id, "--memory", servers["ram"]]
		    v.customize ["modifyvm", :id, "--cpus", servers["cpu"]]

	#	    v.customize ["modifyvm", :id, "--ioapic", "on"]


		 end


		serv.vm.network "private_network", ip: servers["ip"]

	       serv.vm.synced_folder "v-root/", "/home/vm/share", create: true


	    end
	end

end


EOF

cat > /home/vm/servers.yaml <<EOF
---
- name: ubuntu
  hostname: sr0.vmbrokers.org
  box: precise32
  ram: 128
  cpu: 1
  ip: 10.0.2.100
  environment: prod
- name: debian
  hostname: sr1.vmbrokers.org
  box: vmdebian
  ram: 64
  cpu: 1
  ip: 10.0.2.101
  environment: staging

EOF

vagrant box list

#vamos a reiniciar el sistema, porque la parecer no funciona si no se hace esto

reboot

vagrant up

vagrant status

