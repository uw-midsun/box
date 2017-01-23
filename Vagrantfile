# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. Please don't change it unless you know what you're doing.

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "uwmidsun/box"
  config.vm.synced_folder "shared", "/home/vagrant/shared", :mount_options => ["dmode=777", "fmode=666"]

  # Optional NFS. Make sure to remove other synced_folder line too
  # config.vm.synced_folder "shared", "/home/vagrant/shared", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

  # VirtualBox configuration
  config.vm.provider "virtualbox" do |vb|
    # Fix for VirtualBox 5.1 regression (for macOS)
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]

    # Turn on USB 2.0 support
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']

    # Add USB filter to attach STLink programmer
    # The VirtualBox extension pack MUST be installed first
    #   https://www.virtualbox.org/wiki/Downloads
    # On Linux, add your user to the vboxusers group
    #   sudo usermod -a -G vboxusers $USER
    vb.customize ['usbfilter', 'add', '0',
                  '--target', :id,
                  '--name', 'STLink',
                  '--vendorid', '0483',
                  '--productid', '3748']

    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end

end
