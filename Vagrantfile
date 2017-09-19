# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/centos-7.3"
  config.vm.box_version = "201708.22.0"

  if defined? VagrantVbguest
    config.vbguest.auto_update = false
  end

  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  # 共通処理 set ipaddress & set network & update
  common_provision = <<-EOT
      echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
      echo net.ipv6.conf.default.disable_ipv6 = 1 >> /etc/sysctl.conf
      /sbin/sysctl -p
      yum update -y
    EOT

  config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.customize ['modifyvm', :id, '--memory', '2048']
      vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  ################################################################################
  # tas
  config.vm.define :tas do |node|
    # ansible install & run
    provision = <<-EOT
      wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      rpm -ivh epel-release-latest-7.noarch.rpm
      yum -y install ansible libselinux-python
      ansible-playbook /recipe/playbook-tas.yml --connection=local -i /recipe/hosts -l tas
    EOT
  
    # set ipaddress & set network
    node.vm.network :forwarded_port, host: 80, guest: 80, auto_correct: true # website
    node.vm.network :forwarded_port, guest: 443, host: 443, auto_correct: true # ssl
    node.vm.network :forwarded_port, guest: 3306, host: 3306, auto_correct: true # mysql
    node.vm.network :forwarded_port, guest: 9000, host: 9000, auto_correct: true # phpmyadmin
    node.vm.network :forwarded_port, guest: 27017, host: 27017, auto_correct: true # mongodb
    node.vm.network :private_network, ip: "192.168.69.101"

    # set synced folder
    node.vm.synced_folder "recipe", "/recipe", :mount_options => ["dmode=777", "fmode=777"]
    node.vm.synced_folder "../projects", "/var/www/html", :mount_options => ["dmode=777", "fmode=777"]
   
    # provisioning
    node.vm.provision :shell, :inline => common_provision
    node.vm.provision :shell, :inline => provision
    node.vm.provision :shell, inline: "echo Finish !!!"
  end

end
