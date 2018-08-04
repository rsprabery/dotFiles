# P ath to your oh-my-zsh configuration.
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

# Disable google analytic reporting in homebrew
HOMEBREW_NO_ANALYTICS=1

# Load any machine specific configs
[[ -s "$HOME/.local_box_profile" ]] && . $HOME/.local_box_profile

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby git-extras pip python svn vundle)

# enable control-s and control-q
stty start undef
stty stop undef
setopt noflowcontrol
stty -ixon

# LINUX SPECIFIC CONFIG
if [[ `uname` == 'Linux' ]]; then

  [[ -d "/home/read/.linuxbrew" ]] && export PATH=$PATH:/home/read/.linuxbrew/bin
  
  function open {
    if [[ -d "${1}" ]]; then 
      thunar ${1} &> /dev/null & 
      disown %$(jobs | sed 's/\[//g' | sed 's/\]//g'| grep thunar |  awk '{print $1}')
    else
      echo "${1} is not a directory!"
    fi
  }
  export TERM=xterm-256color

  which clang-3.8 >> /dev/null
  if [ $? -eq 0 ]; then
    alias clang=clang-3.8
  fi

  fucntion  pbcopy() {
    #sed 's/\n//g' | xclip -selection clipboard
    awk '{printf "%s",$0} END {print ""}' | xclip -selection clipboard
  }
  alias pbpaste='xclip -selection clipboard -o'


# OSX SPECIFIC CONFIG
elif [[ `uname` == 'Darwin' ]]; then

  # Ensure trim is enabled
  export TRIM=`system_profiler SPSerialATADataType | grep 'TRIM' | awk '{print $3}'`

  # if [[ $TRIM != 'Yes' ]]; then
  #   echo "Trim isn't enabled!"
  #   echo "Run 'sudo trimforce enable' to fix!"
  # fi

  plugins=($plugins osx)
  alias ctags="`brew --prefix`/bin/ctags"

  # zsh completions for brew
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
fi # END MAC SPECIFIC

[[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source /usr/local/bin/virtualenvwrapper.sh

which rbenv >> /dev/null
if [ $? -eq 0 ]; then
  eval "$(rbenv init -)"
fi

# Add custom bin's
[[ -d "$HOME/bin" ]] && PATH=$PATH:$HOME/bin

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias gls="git status"
export SVN_EDITOR=vim

GRADLE_BIN=$(which gradle)
function gradle {
  if [[ -a `pwd`/gradlew ]]; then
    ./gradlew $@
  else
    if [[ -z ${GRADLE_BIN} ]]; then 
      $HOME/bin/gradle $*
    else
      ${GRADLE_BIN} $*
    fi
  fi
}

if [[ -z "$ANSIBLE_BIN" ]]; then
  export ANSIBLE_BIN=`which ansible`
  export ANSIBLE_PLAYBOOK_BIN=`which ansible-playbook`
fi

function ansible {
  if [[ -a `pwd`/inventory ]]; then
    $ANSIBLE_BIN -i inventory $@ -f 50  --sudo 
  else
    $ANSIBLE_BIN $* -f 50 --sudo
  fi  
}

function playbook {
  if [[ -a `pwd`/inventory ]]; then
    $ANSIBLE_PLAYBOOK_BIN -i inventory $@ -f 50 --sudo
  else
    $ANSIBLE_PLAYBOOK_BIN $* -f 50 --sudo
  fi
}

function ap {
  if [[ -d `pwd`/../../roles ]]; then
    export ANSIBLE_ROLES_PATH=`pwd`/../../roles
  fi
  playbook $*
  unset ANSIBLE_ROLES_PATH
}

function make_role {
 mkdir $1
 mkdir $1/tasks
 mkdir $1/handlers
 mkdir $1/vars
 mkdir $1/defaults
 mkdir $1/meta
 echo "---\n" >> $1/tasks/main.yml
 echo "---\n" >> $1/handlers/main.yml
 echo "---\n" >> $1/vars/main.yml
 echo "---\n" >> $1/defaults/main.yml
 echo "---\n" >> $1/meta/main.yml
 mkdir $1/templates
 mkdir $1/files
 touch $1/templates/.keep
 touch $1/files/.keep
}

[[ -s "$HOME/.aws_creds" ]] && . "$HOME/.aws_creds" 

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm

alias gl='git log --oneline --all -10 --decorate'
alias fg='grep --line-number --recursive --color'


export PROMPT='%{$fg[yellow]%}%m%{$reset_color%}:%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)
%{$reset_color%} ${ret_status} %{$reset_color%}'

bindkey -v 
export KEYTIMEOUT=0.3

function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
bindkey '^r' history-incremental-search-backward
alias beep=''
[[ -s "/usr/share/sounds/purple/alert.wav" ]]  && export BEEP=/usr/share/sounds/purple/alert.wav && alias beep='paplay $BEEP'

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
   beep
}

function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}

function ctags-ruby() {
  ctags -R --languages=ruby --exclude=.git --exclude=log . 
  ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)
}

# add anaconda 3 to the path if it exists
if [ -d "${HOME}/anaconda3" ]; then
  PATH=${HOME}/anaconda3/bin:$PATH
fi

# make vim -> nvim if neovim is installed 
which nvim >> /dev/null
if [ $? -eq 0 ]; then
  alias vim=nvim
fi

# color output for wdiff
# https://www.gnu.org/software/wdiff/manual/html_node/wdiff-Examples.html
real_wdiff=$(which wdiff)
if [ $? -eq 0 ]; then
  function wdiff {
    ${real_wdiff} -n \
      -w $'\033[30;41m' -x $'\033[0m' \
      -y $'\033[30;42m' -z $'\033[0m' \
      $@ | less -R
  }
fi

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_twilight

# Git repo for config files
export DOTFILES_DIR="$HOME/dotFiles"
alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'

# Silver searcher with no highlights
alias agc='ag --color-match=#0'