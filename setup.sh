#!/bin/bash
dir=`pwd`
files="zshrc vimrc tmux.conf"
for file in $files; do
  ln -s $dir/$file ~/.$file
done
