# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
if [[ `uname` == 'Linux' ]]; then
  plugins=(git brew ruby rvm django git-extras pip python svn vundle)
  export PATH=$PATH:/usr/local/lib/python2.7/dist-packages
  export PYTHONPATH=/usr/local/lib/python2.7/dist-packages
  # END LINUX SPECIFIC
elif [[ `uname` == 'Darwin' ]]; then
  # Mac Specific:
  plugins=(git brew ruby rvm django git-extras osx pip python svn vundle)

  export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/python

  export PYTHONPATH=/usr/local/Cellar/python/2.7.3/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages

  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

  #alias mysql=/Applications/MAMP/Library/bin/mysql
  #alias mysql_config=/Applications/MAMP/Library/bin/mysql_config
  # add mysql stuffs to path
  PATH=$PATH:/Applications/MAMP/Library/bin/

fi # END MAC SPECIFIC

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

source $ZSH/oh-my-zsh.sh

alias gls="git status"
SVN_EDITOR=vim
export WORKON_HOME=~/.virtenvs
source /usr/local/bin/virtualenvwrapper.sh

# PIP CACHE
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
