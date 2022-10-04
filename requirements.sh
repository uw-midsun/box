add_line_if_dne () {
  if [ ! grep -q "$1" "$2" ]; then
    echo "$1" >> "$2"
  fi
}

exit 
apt-get update

echo "==> Install common tools"
apt-get -y install tmux
apt-get -y install git
apt-get -y install vim
apt-get -y install curl
apt-get -y install scons

echo "==> Install python tooling"
apt-get -y install python3-pip
apt-get -y install virtualenv
apt-get -y install python3-autopep8
apt-get -y install pylint
python3 -m pip install cpplint

echo "==> Install tooling for CAN"
apt-get -y install can-utils
python3 -m pip install python-can
python3 -m pip install cantools
python3 -m pip install Jinja2
python3 -m pip install PyYAML

echo "==> Install clang and gcc"
apt-get -y install gcc-8
apt-get -y install clang-10
apt-get -y install clang-format-10
apt-get -y install gdb
ln -sf $(which gcc-8) /usr/bin/gcc
ln -sf $(which clang-10) /usr/bin/clang
ln -sf $(which clang-format-10) /usr/bin/clang-format

which arm-none-eabi-gcc > /dev/null
if [ ! $? ]; then
  echo "==> Install arm gcc"
  wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/RC1.1/gcc-arm-none-eabi-8-2019-q3-update-linux.tar.bz2 -O arm-gcc.tar.bz2
  tar xfj arm-gcc.tar.bz2 -C /usr/local
  add_line_if_dne 'PATH=$PATH:/usr/local/gcc-arm-none-eabi-8-2019-q3-update/bin' /etc/profile
  rm arm-gcc.tar.bz2
fi

echo "==> Install other toolchain pieces"
apt-get -y install minicom
apt-get -y install openocd

echo "==> Setup for minicom"
touch /etc/minicom/minirc.dfl
add_line_if_dne "pu addcarreturn    Yes" /etc/minicom/minirc.dfl

echo "==> Install protobuf things"
apt-get -y install software-properties-common
add-apt-repository -y ppa:maarten-fonville/protobuf
apt-get -y install protobuf-compiler
apt-get -y install golang-goprotobuf-dev
python3 -m pip install protobuf

echo "==> Install protobuf-c"
apt-get -y install autoconf
apt-get -y install libtool
apt-get -y install pkg-config
apt-get -y install libprotoc-dev


git clone https://github.com/protobuf-c/protobuf-c
cd protobuf-c
./autogen.sh
./configure
make
make install
ldconfig
cd /home/vagrant
rm -rf protobuf-c
