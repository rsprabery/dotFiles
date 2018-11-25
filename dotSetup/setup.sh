#!/bin/bash

# clone down this repo
cd ${HOME}
mkdir -p workspace
cd workspace

export DOTFILES_DIR="${HOME}/workspace/dotFiles.git"
function config() {
  /usr/bin/git --git-dir=${DOTFILES_DIR} --work-tree=${HOME} $@
}

# clone dotFiles repo
if [ -d "${HOME}/workspace/dotFiles.git" ]; then
    echo "Already cloned dotfiles"
else
    cd ${HOME}
    config clone --bare https://github.com/rsprabery/dotFiles.git ${HOME}/workspace/dotFiles.git
    config config --local status.showUntrackedFiles no
    config checkout master
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo 'zsh alread installed'
else
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Change default shell
chsh -s /bin/zsh

# setup homebrew on mac
HOMEBREW_NO_ANALYTICS=1
if [[ `uname` == 'Darwin' ]]; then
cd ${HOME}
    git clone https://github.com/Homebrew/brew.git
    PATH=$PATH:${HOME}/brew/bin
    brew analytics off
fi

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
  echo "Consider using rsprabery@users.noreply.github.com"
  git config --global --replace-all user.email "$email "
  git config --global --replace-all user.name "$name"
fi

git config --global core.editor vim
git config --global push.default simple
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# neovim and other software
if [[ `uname` == 'Linux' ]]; then
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim python-pip silversearcher-ag fzf wdiff htop
elif [[ `uname` == 'Darwin' ]]; then
    brew install ag fzf wdiff htop neovim gnu-tar
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
export WORKON_HOME=${HOME}/workspace/virtenvs
if [[ `uname` == 'Linux' ]]; then
  sudo pip install virtualenvwrapper
  source /usr/local/bin/virtualenvwrapper.sh
elif [[ `uname` == 'Darwin' ]]; then
  pip install --user virtualenvwrapper
  source ${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh
  PATH=${PATH}:${HOME}/Library/Python/2.7/bin
fi
mkvirtualenv neovim
pip install neovim

# The pip cache may be owned by root, change owner
sudo chown -R $(whoami):$(id -g -n) ${HOME}/.cache

nvim +BundleInstall +qall

#if [ -f "${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
#  echo "YCM is already installed!"
#  echo "To reinstall, run: "
#  echo "rm ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so"
#else
#  # you complete me dependencies
#  if [[ `uname` == 'Linux' ]]; then
#    sudo apt-get install cmake build-essential python-dev \
#      python3-dev exuberant-ctags cscope
#  elif [[ `uname` == 'Darwin' ]]; then
#    brew install ctags cscope
#  fi
#  export PATH=/usr/bin:$PATH
#  cd ~/.vim/bundle/YouCompleteMe
#  if [ -f "CMakeCache.txt" ]; then
#    rm CMakeCache.txt
#  fi
#  #./install.py --clang-completer # --gocode-completer
#fi

# Color scheme for terminal & vim
if [ -d "${HOME}/.config/base16-shell" ]; then
  echo "colors already installed"
else
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

echo "Remember to ssh-add (-K on mac) your ~/.ssh/id_rsa!"
echo "Make sure your terminal is reported as xterm-256color"
