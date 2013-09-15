#!/bin/bash

# install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Change default shell
chsh -s /bin/zsh

# Links configs
dir=`pwd`
files="zshrc vimrc tmux.conf gemrc"
for file in $files; do
  ln -s $dir/$file ~/.$file
done

# install vundle for vim
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# setup git
git config --global user.email "read.sprabery@gmail.com"
git config --global user.name "Read Sprabery"
git config --global core.editor vim
