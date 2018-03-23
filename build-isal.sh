#!/usr/bin/env bash
set -e
set -u
#set -x
set -o pipefail

# install util
yum install -y wget
yum install -y git
yum install -y gcc
yum install -y autoconf
yum install -y automake
yum install -y libtool

# install nasm
rm -rf nasm-2.13.03
wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.gz
tar -xvf nasm-2.13.03.tar.gz
cd nasm-2.13.03/
./autogen.sh
./configure
make -j 8
make install
cd ..

# install isa-l
rm -rf isa-l
git clone https://github.com/01org/isa-l.git
cd isa-l/
./autogen.sh
./configure
make -j 8
make install
cd ..