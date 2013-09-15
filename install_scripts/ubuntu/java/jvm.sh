#!/bin/bash

# add repo
sudo add-apt-repository --yes ppa:webupd8team/java
sudo apt-get --assume-yes update

# don't ask to confrim license
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

# install it
sudo apt-get --assume-yes install oracle-java7-installer
sudo apt-get --assume-yes install oracle-java7-set-default
