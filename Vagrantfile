# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. Please don't change it unless you know what you're doing.

VAGRANTFILE_API_VERSION = '2'

require_relative 'lib/better_usb.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network 'private_network', ip: '192.168.24.24'
  
  # For Django development on CAN-Explorer project
  # config.vm.network :forwarded_port, host: 8000, guest: 8000
  # config.vm.network :forwarded_port, host: 3000, guest: 3000
  # config.vm.network :forwarded_port, host: 8086, guest: 8086

  # Default synced_folder mount. Remove this line if using NFS
  config.vm.synced_folder 'shared', '/home/vagrant/shared', :mount_options => ["dmode=777", "fmode=777"]

  # Optional NFS. Make sure to remove other synced_folder line too
  # config.vm.synced_folder "shared", "/home/vagrant/shared", :nfs => true

  ############################################################
  # Provider for Docker on Intel or ARM (aarch64)
  ############################################################
  config.vm.provider :docker do |docker, override|
    override.vm.box = nil
    docker.image = "rofrano/vagrant-provider:ubuntu"
    docker.remains_running = true
    docker.has_ssh = true
    docker.privileged = true
    docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
    docker.create_args = ["--cgroupns=host"]
    # Uncomment to force arm64 for testing images on Intel
    # docker.create_args = ["--platform=linux/arm64", "--cgroupns=host"]
    config.vm.provision "file", source: "./requirements.sh", destination: "requirements.sh"
    config.vm.provision :shell, path: "requirements.sh", run: 'always'
  end  
  
  ############################################################
  # VirtualBox configuration
  ############################################################
  config.vm.provider 'virtualbox' do |vb|
    config.vm.box = 'backpack.box'
    config.vm.box_url = 'https://github.com/uw-midsun/backpack/releases/download/v0.3/backpack.box'
    config.vm.hostname = 'midsunbox'  

    # Turn on USB 2.0 support
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']
    vb.customize ['modifyvm', :id, '--usbxhci', 'on']
    

    # Add USB filter to attach STLink programmer
    # The VirtualBox extension pack MUST be installed first
    #   https://www.virtualbox.org/wiki/Downloads
    # On Linux, add your user to the vboxusers group
    #   sudo usermod -a -G vboxusers $USER
    BetterUSB.usbfilter_add(vb, '1209', 'da42', 'CMSIS-DAP')
    BetterUSB.usbfilter_add(vb, '0403', '6001', 'FTDI TTL232R-3V3')
    BetterUSB.usbfilter_add(vb, '0483', '3748', 'STLink')

    # Digi XBee
    BetterUSB.usbfilter_add(vb, '0403', '6015', 'Digi XBee')

    # PEAK System PCAN-USB dongle
    BetterUSB.usbfilter_add(vb, '0c72', '0012', 'PEAK System PCAN-USB opto-decoupled')
    BetterUSB.usbfilter_add(vb, '0c72', '000c', 'PEAK System PCAN-USB')

    # Customize the amount of memory on the VM:
    # vb.memory = "1024"

  # Set appropriate environment variables for Windows OS
  if Vagrant::Util::Platform.windows? then
    config.vm.provision "shell", inline: <<-SHELL
    echo "export VIRTUALENV_ALWAYS_COPY=1" >> .profile
    SHELL
  end
  
  end

end
