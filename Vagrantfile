# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. Please don't change it unless you know what you're doing.

VAGRANTFILE_API_VERSION = "2"

require_relative 'lib/better_usb.rb'
require_relative 'lib/which.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "uwmidsun/box"

  config.vm.network "private_network", ip: "192.168.24.24"
  config.vm.hostname = "midsunbox"

  # Default synced_folder mount. Remove this line if using NFS
  config.vm.synced_folder "shared", "/home/vagrant/shared", :mount_options => ["dmode=777", "fmode=777"]

  # Optional NFS. Make sure to remove other synced_folder line too
  # config.vm.synced_folder "shared", "/home/vagrant/shared", :nfs => true

  # VirtualBox configuration
  config.vm.provider "virtualbox" do |vb|
    # Turn on USB 2.0 support
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']

    # Add USB filter to attach STLink programmer
    # The VirtualBox extension pack MUST be installed first
    #   https://www.virtualbox.org/wiki/Downloads
    # On Linux, add your user to the vboxusers group
    #   sudo usermod -a -G vboxusers $USER
    if not Which.which('VBoxManage').nil?
      BetterUSB.usbfilter_add(vb, '0483', '3748', 'STLink')
      BetterUSB.usbfilter_add(vb, '1209', 'da42', 'CMSIS-DAP')
    else
      vb.customize ["usbfilter", "add", "0",
                    "--target", :id,
                    "--name", "STLink",
                    "--vendorid", "0483",
                    "--productid", "3748"
      ]
      vb.customize ["usbfilter", "add", "1",
                    "--target", :id,
                    "--name", "CMSIS-DAP",
                    "--vendorid", "1209",
                    "--productid, "da42"
      ]
    end

    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end

end
