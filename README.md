# box

``uwmidsun/box`` is a preconfigured Vagrant box with a full GCC ARM toolchain for compiling ARM code and flashing and debugging it with tools like OpenOCD and gdb. Using this virtual environment, you can get set up to compile and load ARM code from any platform that Vagrant supports (Windows, Mac OSX, Linux).

No provisioning tools or setup is really even required to use ``uwmidsun/box``. Since everything is packaged into the base box, running ``vagrant`` is super fast, you'll never have to worry about your environment breaking with updates, and you won't need the internet to code.

The ARM toolchain that will be set up includes the following tools:

* GCC ARM Embedded
* OpenOCD

In addition, the virtual machine will be setup to automatically passthrough a STLink V2 programmer for easy flashing of STM32 microcontrollers.

## Requirements
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

On **Linux**, you'll also have to add your user to the ``vboxusers`` group, so that the virtual machine can access your USB devices. After installing all the above, run

```bash
sudo usermod -a -G vboxusers $USER
```

Then reboot your machine.

## Getting Started

```bash
git clone https://github.com/uw-midsun/box.git box && cd box
vagrant up && vagrant reload
vagrant ssh
```

These 3 steps only need to be run the first time you start working with ``uwmidsun/box``. Otherwise, you can just do ``vagrant up``, followed by ``vagrant ssh``.

**Note**: Ensure that when running these commands, the STLink and USB device is disconnected. The ``vagrant reload`` is necessary to ensure USB passthrough is enabled.

The ``shared/`` directory will be shared between your host operating system and the virtual environmnent (``/home/vagrant/shared/``).

## Vagrant Commands

Open a terminal in the directory with the ``Vagrantfile`` and run these commands

### Start or resume

```bash
vagrant up
```

### Connect to the box (ssh)

```bash
vagrant ssh
```

When you're ready to stop the VM, you can exit it by running the following command inside the VM:

```bash
exit
```

**Notes**: After you exit the VM, it will still be running! You can enter the VM again by sshing in again, or you can shutdown the VM by running

```bash
vagrant halt
```

### Delete box

If you ever want to start fresh (which wipes everything)

```bash
vagrant destroy
```

## Updating the box

Although not necessary, if you want to check for updates, just type

```bash
vagrant box outdated
```

It will tell you if you are running the latest version or not. If it says you aren't, simply run

```bash
vagrant box update
```

## Features

This box comes with the following

### System Stuff
* Git
* tmux
* vim

### C Stuff
* build-essential
* gdb

### Ruby
* rvm
