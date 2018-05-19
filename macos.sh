#!/usr/bin/env bash

# Move to the box folder
# cd ~/box
# Disable USB filters - you may need to manually remove them
sed -i -e 's:BetterUSB.usbfilter_add:# BetterUSB.usbfilter_add:g' Vagrantfile
vagrant reload

# Install brew non-interactively - copied from https://brew.sh/
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
brew install openocd
brew install make
brew install minicom
# Install gcc-arm-embedded 6-2017-q2-update (gcc7 segfaults)
brew cask install https://raw.githubusercontent.com/caskroom/homebrew-cask/4d16a06d09bc695c6a7252843106c5d7adce5877/Casks/gcc-arm-embedded.rb

# Generate SSH keypair and copy the public key into the host
vagrant ssh -c "cat /dev/zero | ssh-keygen -q -N '' && echo 'Generated SSH keypair'"
vagrant ssh -c 'cat ~/.ssh/id_rsa.pub' >> ~/.ssh/authorized_keys

# Disable password authentication on host SSH server for safety, then enable Remote Login (SSH)
sudo sh -c "sed -i -e 's:#PermitRootLogin prohibit-password:PermitRootLogin no:g' /etc/ssh/sshd_config \
&& sed -i -e 's:#PasswordAuthentication yes:PasswordAuthentication no:g' /etc/ssh/sshd_config \
&& sed -i -e 's:#ChallengeResponseAuthentication yes:ChallengeResponseAuthentication no:g' /etc/ssh/sshd_config \
&& sed -i -e 's:UsePAM yes:UsePAM no:g' /etc/ssh/sshd_config \
&& systemsetup -setremotelogin on"

# Add environment variables so we can SSH from the guest
vagrant ssh -c "echo 'export MACOS_SSH_USERNAME=\"$(whoami)\"' >> ~/.bashrc"
vagrant ssh -c "echo 'export MACOS_SSH_BOX_PATH=\"$(pwd)\"' >> ~/.bashrc"
# Switch OpenOCD script dir since it's different when installed by brew
echo "export OPENOCD_SCRIPT_DIR=/usr/local/share/openocd/scripts/" >> ~/.bashrc

# Set up paths and add a .bash_profile for SSH
echo "[[ -f ~/.bashrc ]] && source ~/.bashrc" >> ~/.bash_profile
echo "export PATH=\"/usr/local/bin:/usr/local/opt/make/libexec/gnubin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc
