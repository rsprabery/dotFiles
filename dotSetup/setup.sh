#!/bin/bash

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then 
  echo 'zsh alread installed'
else
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Change default shell
chsh -s /bin/zsh

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
  # git config --global user.email "rsprabery@users.noreply.github.com"
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
  if [[ `uname` == 'Linux' ]]; then
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim 
  elif [[ `uname` == 'Darwin' ]]; then
    brew install neovim
  fi
fi

if [[ `uname` == 'Linux' ]]; then
  sudo apt-get install python-pip silversearcher-ag
elif [[ `uname` == 'Darwin' ]]; then
  brew install ag
  sudo easy_install pip
fi

#anaconda
# if [ -d "$HOME/anaconda3" ]; then
#  echo 'anaconda3 installation found!'
# else
#   echo 'installing anaconda3'
#   if [[ `uname` == 'Linux' ]]; then
#     wget https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
#     bash Anaconda3-4.3.0-Linux-x86_64.sh
#     rm Anaconda3-4.3.0-Linux-x86_64.sh
#   elif [[ `uname` == 'Darwin' ]]; then
#     wget https://repo.continuum.io/archive/Anaconda3-4.3.0-MacOSX-x86_64.sh
#     bash Anaconda3-4.3.0-MacOSX-x86_64.sh
#     rm Anaconda3-4.3.0-MacOSX-x86_64.sh
#   fi
# fi

# install deps for neovim
# Right now, YCM only works with system python. So neovim needs to be able
# to talk to /usr/bin/python
# sudo pip install --upgrade pyOpenSSL cryptography idna certifi
if [[ `uname` == 'Linux' ]]; then
  sudo pip install neovim
elif [[ `uname` == 'Darwin' ]]; then
  pip install neovim
fi

# The pip cache may be owned by root, change owner
sudo chown -R $(whoami):$(id -g -n) ${HOME}/.cache

nvim +BundleInstall +qall

if [ -f "${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
  echo "YCM is already installed!"
  echo "To reinstall, run: "
  echo "rm ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so"
else
  # you complete me dependencies
  if [[ `uname` == 'Linux' ]]; then
    sudo apt-get install cmake build-essential python-dev \
      python3-dev exuberant-ctags cscope
  elif [[ `uname` == 'Darwin' ]]; then
    brew install ctags cscope
  fi
  export PATH=/usr/bin:$PATH
  cd ~/.vim/bundle/YouCompleteMe
  if [ -f "CMakeCache.txt" ]; then
    rm CMakeCache.txt
  fi
  ./install.py --clang-completer # --gocode-completer
fi

# Matcher for fuzzy matching with ctrlp
if [ -f "${HOME}/bin/matcher" ]; then
  echo "matcher installed"
else
  git clone https://github.com/burke/matcher.git
  cd matcher
  make
  mv matcher ${HOME}/bin/matcher
fi

# Color scheme for terminal & vim
if [ -d "${HOME}/.config/base16-shell" ]; then
  echo "colors already installed"
else
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

echo "Remember to ssh-add (-K on mac) your ~/.ssh/id_rsa!"
echo "Make sure your terminal is reported as xterm-256color"

