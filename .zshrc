# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# ZSH_THEME="avit"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

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
[[ -s "$HOME/.local_box_profile.zsh" ]] && . $HOME/.local_box_profile.zsh

# Add powerline to path (used in tmux config)
# export PATH=${PATH}:~/workspace/virtenvs/powerline/bin

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git ruby git-extras pip python vundle rvm osx bundler dotenv ansible brew colored-man-pages dash django gem iterm2 man npm node tmux)
plugins=(git pip python ruby gem bundler colored-man-pages rvm bundler brew)

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
  # export TERM=xterm-256color

  which clang-3.8 >> /dev/null
  if [ $? -eq 0 ]; then
    alias clang=clang-3.8
  fi

  fucntion  pbcopy() {
    #sed 's/\n//g' | xclip -selection clipboard
    awk '{printf "%s",$0} END {print ""}' | xclip -selection clipboard
  }
  alias pbpaste='xclip -selection clipboard -o'

  export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer

# OSX SPECIFIC CONFIG
elif [[ `uname` == 'Darwin' ]]; then
  [[ -d "${HOME}/brew" ]] && export PATH=${HOME}/brew/bin:$PATH

  # Ensure trim is enabled
  # export TRIM=`system_profiler SPSerialATADataType | grep 'TRIM' | awk '{print $3}'`

  # if [[ $TRIM != 'Yes' ]]; then
  #   echo "Trim isn't enabled!"
  #   echo "Run 'sudo trimforce enable' to fix!"
  # fi

  # plugins=($plugins osx)
  alias ctags="`brew --prefix`/bin/ctags"

  # zsh completions for brew
  function setup-brew() {
    fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
  }

  # path for programs installed with pip install --user
  PATH=${PATH}:${HOME}/Library/Python/2.7/bin
fi # END MAC SPECIFIC

# Per project env vars
which direnv >> /dev/null
if [ $? -eq 0 ]; then
  eval "$(direnv hook zsh)"
fi

# Python Setup
export WORKON_HOME=${HOME}/workspace/virtenvs
[[ -s "${HOME}/Library/Python/3.9/bin/virtualenvwrapper.sh" ]] && \
    source ~/Library/Python/3.9/bin/virtualenvwrapper.sh

# Ruby Lang setup
# which rbenv >> /dev/null
# if [ $? -eq 0 ]; then
#   eval "$(rbenv init -)"
# fi

# Install ruby gem in HOME directory instead of system wide
# export GEM_HOME=$HOME/.gems
# export PATH=$HOME/.gems/bin:$PATH

function ctags-ruby() {
  ctags -R --languages=ruby --exclude=.git --exclude=log .
  ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)
}

function setup-rvm() {
    # Load RVM into a shell session *as a function*
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
    export PATH="$PATH:$HOME/.rvm/bin"
}

function setup-crystal() {
    # Crystal Lang Env Vars
    which crystal >> /dev/null
    if [ $? -eq 0 ]; then
      export CRYSTAL_CACHE_DIR="/tmp/crystal/.cache/"
      mkdir -p ${CRYSTAL_CACHE_DIR}
      export CRYSTAL_PATH="/Users/read/brew/Cellar/crystal/0.27.0/src:lib"
    fi
}

found_brew=$(which brew)
if [[ -z ${found_brew} ]]; then
    export PATH="$(brew --prefix)/bin:${PATH}"
    export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
fi


[[ -d "${HOME}/go/bin" ]] && export PATH=${PATH}:${HOME}/go/bin/

# NodeJS Setup
export NVM_DIR="$HOME/.nvm"
# Support installs of NVM directly
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm
# Support brew install nvm
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Add custom bin's
[[ -d "$HOME/bin" ]] && PATH=$HOME/bin:${PATH}

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias gls="git status"
export SVN_EDITOR=vim
export HOMEBREW_EDITOR=vim
export EDITOR=code

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
    $ANSIBLE_BIN -i inventory $@ -f 50
  else
    $ANSIBLE_BIN $* -f 50
  fi
}

function playbook {
  if [[ -a `pwd`/inventory ]]; then
    $ANSIBLE_PLAYBOOK_BIN -i inventory $@ -f 50
  else
    $ANSIBLE_PLAYBOOK_BIN $* -f 50
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

alias gl='git log --oneline --all -10 --decorate'

export PROMPT='%{$fg[yellow]%}%m%{$reset_color%}:%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)
%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )%{$reset_color%}${ret_status}%{$reset_color%} '

# vi mode for zsh
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


# add anaconda 3 to the path if it exists
# if [ -d "${HOME}/.anaconda3" ]; then
#   PATH=${HOME}/.anaconda3/bin:$PATH
# fi

# make vim -> nvim if neovim is installed
which nvim >> /dev/null
if [ $? -eq 0 ]; then
  alias vim=nvim
  alias view='nvim -R'
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
[ -n "$PS1" ] && [ -s ${BASE16_SHELL}/profile_helper.sh ] && eval "$( cat ${BASE16_SHELL}/profile_helper.sh)"
# base16_solarized-light
base16_brewer

# Git repo for config files
[[ -d ${HOME}/dotFiles ]] && export DOTFILES_DIR="${HOME}/dotFiles"
[[ -d ${HOME}/workspace/dotFiles.git ]] && export DOTFILES_DIR="${HOME}/workspace/dotFiles.git"
alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'

# GOlang setup
[[ -d "${HOME}/go" ]] && export GOPATH="${HOME}/go"

ag() {
  command ag \
    -p "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "$(git rev-parse --show-toplevel)/.gitignore")" \
    "$@"
}

# Silver searcher with no highlights
alias agc='ag --color-match=#0'

export FZF_DEFAULT_COMMAND="rg --files"
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi

function silent_background() {
  # if [[ -n $ZSH_VERSION ]]; then  # zsh:  https://superuser.com/a/1285272/365890
    setopt local_options no_notify no_monitor
    # We'd use &| to background and disown, but incompatible with bash, so:
    "$@" &
  # elif [[ -n $BASH_VERSION ]]; then  # bash: https://stackoverflow.com/a/27340076/5353461
  #   { 2>&3 "$@"& } 3>&2 2>/dev/null
  # else  # Unknownness - just background it
  #   "$@" &
  # fi
  # disown &>/dev/null  # Close STD{OUT,ERR} to prevent whine if job has already completed
}

function setup-all() {
    setup-nvm
    # setup-rvm
    # setup-brew
}

# silent_background setup-all
export PATH="/Users/read/brew/sbin:$PATH"
export PATH="$(brew --prefix python@3.11)/libexec/bin:$PATH"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/read/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

export LC_ALL="en_US.UTF-8"

fshow () {
        git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

gs () {
    # -S only shows commits where the number of occurrences changed, so if
    # the word was added in one place and removed in another, the commit
    # won't show up.
    #
    # -G shows all commits where the word occurs at all.
    fshow -S${@}
}

recent-branches () {
    git reflog | egrep -io "moving from ([^[:space:]]+)" | awk '{ print $3 }' | awk ' !x[$0]++' | egrep -v '^[a-f0-9]{40}$'
}


PATH=~/.console-ninja/.bin:$PATH

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/sprabery/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/sprabery/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
  fi
