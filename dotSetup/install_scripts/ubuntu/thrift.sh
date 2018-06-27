#!/bin/bash

clear 
echo "Make sure you have java installed already..."
echo "[ENTER] to continue"
# only read one character and be silent about it
read -n 1 -s
sudo apt-get install -y libboost-dev libboost-test-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev

# get the current time since the epoch with +%s
export CURRENT_TIME=`date +%s`

export INSTALL_DIR=${CURRENT_TIME}_thrift_install
mkdir $INSTALL_DIR 

cd $INSTALL_DIR
export THRIFT_VERSION=0.9.2
export TAR_NAME=thrift-${THRIFT_VERSION}.tar.gz

wget http://apache.mesi.com.ar/thrift/0.9.2/$TAR_NAME

tar -xf $TAR_NAME 

cd thrift-${THRIFT_VERSION} 

./configure && make

sudo make install

echo "Feel free to remove ${INSTALL_DIR}, but you wont be able to run \
  make uninstall"

echo "You may see an error above, this is not a problem in most cases"
