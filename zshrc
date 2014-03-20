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
plugins=(git ruby rvm django git-extras pip python svn vundle)
if [[ `uname` == 'Linux' ]]; then
  export PATH=$PATH:/usr/local/lib/python2.7/dist-packages
  export PYTHONPATH=/usr/local/lib/python2.7/dist-packages
  source /usr/local/bin/virtualenvwrapper.sh
  # END LINUX SPECIFIC
elif [[ `uname` == 'Darwin' ]]; then
  # Mac Specific:
  plugins=($plugins brew osx)

  export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:`npm root -g`

  export NODE_PATH="`npm root -g`"

  #export PYTHONPATH=/usr/local/Cellar/python/2.7.3/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages

  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

  # Do some things so we can use MAMP for development
  alias mysql=/Applications/MAMP/Library/bin/mysql
  alias mysql_config=/Applications/MAMP/Library/bin/mysql_config
  # add mysql stuffs to path
  PATH=$PATH:/Applications/MAMP/Library/bin

  # add tex distribution to the path
  export PATH=/usr/texbin:$PATH

  # define path for GO
  export GOPATH=$HOME"/gocode"

  # java home
  export JAVA_HOME=$(/usr/libexec/java_home)

  export HADOOP_HOME=~/software/hadoop-0.20.2
  export PATH=$HADOOP_HOME/bin:$PATH
  export HADOOP_VERSION=0.20.2
  export PIG_HOME=~/software/pig-0.12.0
  export PATH=$PIG_HOME/bin:$PATH
  
  source /usr/local/bin/virtualenvwrapper.sh 

fi # END MAC SPECIFIC

# Add custom bin's
PATH=$PATH:$HOME/bin

# Source RVM 
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias gls="git status"
export SVN_EDITOR=vim

# Set things for python's virtuan env
export WORKON_HOME=~/.virtenvs

# PIP CACHE
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# OPAM configuration
. /Users/read/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
