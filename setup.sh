#!/bin/bash

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then 
  echo 'zsh alread installed'
else
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Change default shell
chsh -s /bin/zsh

# Links configs
dir=`pwd`
rm ~/.zshrc
files="zshrc vimrc tmux.conf gemrc"
for file in $files; do
  ln -s $dir/$file ~/.$file
done

mkdir -p $HOME/.gradle
ln -s $dir/gradle.properties $HOME/.gradle/gradle.properties

# install vundle for vim
if [ -d $HOME/.vim/bundle/vundle ]; then
  echo 'vundle already installed!'
else
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

# setup git
if [ -f $HOME/.gitconfig ]; then
  echo 'git already configured!'
else
  echo "Enter your email address for git"
  read email
  echo "Enter your full name for git"
  IFS="" read name 
  git config --global --replace-all user.email "$email "
  git config --global --replace-all user.name "$name"
fi
git config --global core.editor vim
git config --global push.default simple
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# neovim
which nvim >> /dev/null
if [ $? -eq 1 ]; then 
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim
fi

# link vimrc for neovim
mkdir -p $HOME/.config/nvim/
ln -s $dir/vimrc $HOME/.config/nvim/init.vim

#anaconda
if [ -d "$HOME/anaconda3" ]; then
  echo 'anaconda3 installation found!'
else
  echo 'installing anaconda3'
  wget https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
  bash Anaconda3-4.3.0-Linux-x86_64.sh
  rm Anaconda3-4.3.0-Linux-x86_64.sh
fi

# add anaconda 3 to the path
PATH=$HOME/anaconda3/bin:$PATH

# install depds for neovim
pip install neovim

nvim +BundleInstall +qall
#cd ~/.vim/bundle/command-t/ruby/command-t
#ruby extconf.rb
#make

if [ -f "${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
  echo "YCM is already installed!"
  echo "To reinstall, run: "
  echo "rm ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so"
else
  # you complete me dependencies
  sudo apt-get install cmake build-essential python-dev python3-dev exuberant-ctags
  export PATH=/usr/bin:$PATH
  alias python=/usr/bin/python3
  cd ~/.vim/bundle/YouCompleteMe
  if [ -f "CMakeCache.txt" ]; then
    rm CMakeCache.txt
  fi
  ./install.py --clang-completer --gocode-completer
fi

echo "Remember to ssh-add (-K on mac) your ~/.ssh/id_rsa!"
echo "Make sure your terminal is reported as xterm-256color"
