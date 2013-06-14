#!/bin/bash
dir=`pwd`
files="zshrc vimrc tmux.conf gemrc"
for file in $files; do
  ln -s $dir/$file ~/.$file
done
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
