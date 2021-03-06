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
    config config user.email "rsprabery@users.noreply.github.com"
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo 'zsh alread installed'
else
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Change default shell
if [ "$(getent passwd $LOGNAME | cut -d: -f7)" -ne "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

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
  echo "Consider using rsprabery@users.noreply.github.com"
  echo "Enter your email address for git"
  read email
  echo "Enter your full name for git"
  IFS="" read name
  git config --global --replace-all user.email "$email "
  git config --global --replace-all user.name "$name"
fi

git config --global core.editor nvim
git config --global push.default simple
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# neovim and other software
if [[ `uname` == 'Linux' ]]; then
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim python-pip silversearcher-ag wdiff htop \
        xclip git python3-venv build-essential python3-dev libpython3-dev \
        ctags ruby clang-tools openssh-server tmux clang build-essential

    sudo update-alternatives --install /usr/bin/clangd \
        clangd /usr/bin/clangd-6.0 100

    sudo update-alternatives --install /usr/bin/llvm-symbolizer \
        llvm-symbolizer /usr/bin/llvm-symbolizer-6.0 100

elif [[ `uname` == 'Darwin' ]]; then
    brew tap twlz0ne/homebrew-ccls
    brew install ag fzf wdiff htop neovim gnu-tar Markdown \
        ctags \
        nvm \
        direnv \
        jemalloc \
        gpg \
        tree \
        wget \
        python3 \
        ccls
    sudo easy_install pip
fi

# Add RVM GPG key
# gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || exit

# Install RVM
# \curl -sSL https://get.rvm.io | bash -s stable --ruby


if [[ `uname` == 'Darwin' ]]; then
    mkdir -p ${HOME}/bin
    ln -s $(brew --prefix)/bin/ctags ${HOME}/bin/ctags
fi

# install deps for neovim
export WORKON_HOME=${HOME}/workspace/virtenvs
if [[ `uname` == 'Linux' ]]; then

  pip install --user virtualenvwrapper
  source ${HOME}/.local/bin/virtualenvwrapper.sh
  PATH=${PATH}:${HOME}/.local/bin
  which fzf
  if [[ "$?" -ne "0" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
  fi
elif [[ `uname` == 'Darwin' ]]; then
  pip install --user virtualenvwrapper
  source ${HOME}/Library/Python/2.7/bin/virtualenvwrapper.sh
  PATH=${PATH}:${HOME}/Library/Python/2.7/bin
fi

mkvirtualenv neovim
pip install neovim
deactivate

mkvirtualenv pylsp
pip install 'python-language-server[all]'
deactivate

# The pip cache may be owned by root, change owner
sudo chown -R $(whoami):$(id -g -n) ${HOME}/.cache

# Setup python3 with neovim
python3 -m venv ~/workspace/virtenvs/p3neovim
source ~/workspace/virtenvs/p3neovim/bin/activate
pip install neovim python-language-server[all] black
deactivate

# Setup black python formatter
python3 -m venv ~/workspace/virtenvs/black-vim
source ~/workspace/virtenvs/black-vim/bin/activate
pip install neovim black
deactivate

nvim +BundleInstall +qall

# Setup global sphinx documentation
python3 -m venv ~/workspace/virtenvs/pydev
source ~/workspace/virtenvs/pydev/bin/activate
pip install sphinx black sphinx_rtd_theme sphinx-autobuild
deactivate
mkdir -p ~/bin/
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-apidoc ~/bin/sphinx-apidoc
ln -s ~/workspace/virtenvs/pydev/bin/sphinx ~/bin/sphinx
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-autogen  ~/bin/sphinx-autogen
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-build  ~/bin/sphinx-build
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-quickstart  ~/bin/sphinx-build
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-quickstart  ~/bin/sphinx-quickstart
ln -s ~/workspace/virtenvs/pydev/bin/sphinx-autobuild  ~/bin/sphinx-autobuild

# Setup powerline for tmux.
python3 -m venv ~/workspace/virtenvs/powerline
source ~/workspace/virtenvs/powerline/bin/activate
pip install powerline-status
deactivate

# Setup NVM for Node
mkdir ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/Users/read/brew/opt/nvm/nvm.sh" ] && . "/Users/read/brew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/Users/read/brew/opt/nvm/etc/bash_completion" ] && . "/Users/read/brew/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Color scheme for terminal & vim
if [ -d "${HOME}/.config/base16-shell" ]; then
  echo "colors already installed"
else
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

echo "Remember to ssh-add (-K on mac) your ~/.ssh/id_rsa!"
echo "Make sure your terminal is reported as xterm-256color"

if [[ `uname` == 'Darwin' ]]; then
    # Fix copy from tmux in vscode
    brew install reattach-to-user-namespace

    # Install fonts system wide on OS X
    echo "Install fonts system wide by double clicking a font and selecting"
    echo "'install'."
    open /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/

    # Copy over iterm2 config
    mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
    cp ${HOME}/dotSetup/iterm2.json \
        ${HOME}/Library/Application\ Support/iTerm2/DynamicProfiles
fi

# Setup powerline font
echo "Install alt font to be used for non-ascii characters in terminal."
echo "Double click and select 'install'."
curl "https://github.com/powerline/fonts/blob/master/RobotoMono/Roboto%20Mono%20Medium%20for%20Powerline.ttf?raw=true" \
    -o ~/Downloads/RobotoMonoMediumForPowerline.ttf

