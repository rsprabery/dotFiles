#/bin/bash

# Make a software directory
mkdir ~/software

# chagne to it
cd ~/software

# get the intellij package
wget -O intellij.tar.gz http://download.jetbrains.com/idea/ideaIC-12.1.4.tar.gz &&
tar -xvf intellij.tar.gz &&
rm intellij.tar.gz

# Rename the package for ease
mv idea* idea

# change to the home dir
cd 

# link the package to the local bin directory
ln -s ~/software/idea/bin/idea.sh ~/bin/idea
