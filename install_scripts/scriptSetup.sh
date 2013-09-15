#/bin/bash

mkdir -p ~/software
cd ~/software
git clone git@sprabery.com:shell_scripts

ln -s ~/software/shell_scripts/lsprojs.sh ~/bin/lsprojs
ln -s ~/software/shell_scripts/mkproj.sh ~/bin/mkproj

