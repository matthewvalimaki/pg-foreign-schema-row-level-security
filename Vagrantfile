# -*- mode: ruby -*-
# vi: set ft=ruby :

# use virtualbox of available providers automatically
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(2) do |config|
  config.vm.box = "box-cutter/ubuntu1504-docker"

  # Postgres server
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  
  # VBox configuration
  config.vm.provider "virtualbox" do |vb|
	# Display the VirtualBox GUI when booting the machine
	vb.gui = false
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get dist-upgrade -y
    apt-get autoremove -y

    service docker start
  SHELL
end
