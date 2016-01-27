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

mkdir -p $HOME/.gradle
ln -s $dir/gradle.properties $HOME/.gradle/gradle.properties

# install vundle for vim
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# setup git
echo "Enter your email address for git"
read email
echo "Enter your full name for git"
IFS="" read name 
git config --global --replace-all user.email "$email "
git config --global --replace-all user.name "$name"
git config --global core.editor vim
