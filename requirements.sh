add_line_if_dne () {
  if ! grep -q "$1" "$2"; then
    echo "$1" >> "$2"
  fi
}

apt update

echo "==> Install common tools"
apt -y install tmux
apt -y install git
apt -y install vim
apt -y install curl
apt -y install scons

echo "==> Install python tooling"
apt -y install python3-pip
apt -y install virtualenv
apt -y install python3-autopep8
apt -y install pylint
python3 -m pip install cpplint

echo "==> Install tooling for CAN"
apt -y install can-utils
python3 -m pip install python-can
python3 -m pip install cantools
python3 -m pip install Jinja2
python3 -m pip install PyYAML

echo "==> Install go"
wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -O go-zip.tar.gz
tar -xzf go-zip.tar.gz -C /usr/local
add_line_if_dne 'PATH=$PATH:/usr/local/go/bin' /etc/profile
add_line_if_dne 'GOPATH=/home/vagrant/go' /home/vagrant/.bashrc
rm go*.tar.gz

echo "==> Install ruby"
apt -y install ruby

echo "==> Install clang and gcc"
apt -y install gcc-8
apt -y install clang-10
apt -y install clang-format-10
apt -y install gdb
ln -sf $(which gcc-8) /usr/bin/gcc
ln -sf $(which clang-10) /usr/bin/clang
ln -sf $(which clang-format-10) /usr/bin/clang-format

echo "==> Install arm gcc"
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2 -O arm-gcc.tar.bz2
tar xfj arm-gcc.tar.bz2 -C /usr/local
add_line_if_dne 'PATH=$PATH:/usr/local/gcc-arm-none-eabi-8-2019-q3-update/bin' /etc/profile
rm arm-gcc.tar.bz2

echo "==> Install other toolchain pieces"
apt -y install minicom
apt -y install openocd

echo "==> Setup for minicom"
touch /etc/minicom/minirc.dfl
add_line_if_dne "pu addcarreturn    Yes" /etc/minicom/minirc.dfl

echo "==> Install protobuf things"
apt -y install software-properties-common
add-apt-repository -y ppa:maarten-fonville/protobuf
apt -y install protobuf-compiler
apt -y install golang-goprotobuf-dev
python3 -m pip install protobuf

echo "==> Install protobuf-c"
apt -y install autoconf
apt -y install libtool
apt -y install pkg-config
apt -y install libprotoc-dev
git clone https://github.com/protobuf-c/protobuf-c
cd protobuf-c
./autogen.sh
./configure
make
make install
ldconfig
cd /home/vagrant
rm -rf protobuf-c
