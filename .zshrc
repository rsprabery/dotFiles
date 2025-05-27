# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

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
# Add custom bin's
[[ -d "$HOME/bin" ]] && PATH=$HOME/bin:${PATH}

# Add golang bin's
[[ -d "$HOME/go/bin" ]] && PATH=$HOME/go/bin:${PATH}


# -------------------------- BEGIN ZSH BEHAVIOR -----------------------------------

# plugins=(git ruby git-extras pip python vundle rvm osx bundler dotenv ansible brew colored-man-pages dash django gem iterm2 man npm node tmux)
plugins=(git pip python ruby gem bundler colored-man-pages rvm bundler brew tmux docker)

# enable control-s and control-q
stty start undef
stty stop undef
setopt noflowcontrol
stty -ixon

export PROMPT='%{$fg[yellow]%}%m%{$reset_color%}:%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)
%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )%{$reset_color%}${ret_status}%{$reset_color%} '

# vi mode for zsh
bindkey -v
export KEYTIMEOUT=0.3
set -o vi

function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

bindkey '^r' history-incremental-search-backward

# -------------------------- END ZSH BEHAVIOR -----------------------------------

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

  ########### Begin homebrew setup #############################
  # If brew is installed in the home dir, add it to the path.
  [[ -d "${HOME}/brew" ]] && export PATH=${HOME}/brew/bin:$PATH

  # Homebrew
  [[ -d "/opt/homebrew/bin" ]] && PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

  # zsh completions for brew
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})

  ###### Program specific setup

  # ctags override
  [[ -s $(brew --prefix)/bin/ctags ]] && alias ctags="`brew --prefix`/bin/ctags"

  # gnu utils override BSD versions.
  [[ -d "$(brew --prefix)/opt/gnu-tar/libexec/gnubin" ]] && \
    PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"

  ########### End homebrew setup #############################


  ############ Begin Mac Specific Python Setup #################

  # Make python 3 be "python" everywhere
  [[ -s "/opt/homebrew/opt/python@3/libexec/bin/python" ]] && \
    PATH="/opt/homebrew/opt/python@3/libexec/bin:$PATH"

  [[ -s "$(brew --prefix)/opt/python@3.11/libexec/bin/python" ]] && \
    export VIRTUALENVWRAPPER_PYTHON=$(brew --prefix)/opt/python@3.11/libexec/bin/python

  # path for programs installed with pip install --user
  [[ -d "${HOME}/Library/Python/3.9/bin" ]] && \
    PATH="${PATH}:${HOME}/Library/Python/3.9/bin"

  export WORKON_HOME=${HOME}/workspace/virtenvs
  [[ -s "${HOME}/Library/Python/3.9/bin/virtualenvwrapper.sh" ]] && \
    source ${HOME}/Library/Python/3.9/bin/virtualenvwrapper.sh

  ############ End Mac Specific Python Setup #################

fi # END MAC SPECIFIC



# ---------------------------- Begin LANGUAGE SETUP --------------------------------

######### Begin generic python setup #############
export WORKON_HOME=${HOME}/workspace/virtenvs

[[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && \
    source /usr/local/bin/virtualenvwrapper.sh

which pyenv >> /dev/null
if [ $? -eq 0 ]; then
 eval "$(pyenv init -)"
 eval "$(pyenv virtualenv-init -)"
fi

######### End generic python setup #############


######### Begin Ruby Lang setup #######

# Install ruby gem in HOME directory instead of system wide
export GEM_HOME=$HOME/.gems
export PATH=$HOME/.gems/bin:$PATH

function ctags-ruby() {
  ctags -R --languages=ruby --exclude=.git --exclude=log .
  ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)
}

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && \
  source "$HOME/.rvm/scripts/rvm" && \
  export PATH="$PATH:$HOME/.rvm/bin"

######### End Ruby Lang setup #######

found_brew=$(which brew)
if [[ -z ${found_brew} ]]; then
    export PATH="$(brew --prefix)/bin:${PATH}"
    export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
fi


[[ -d "${HOME}/go/bin" ]] && export PATH=${PATH}:${HOME}/go/bin/

# Support brew install nvm

######### Begin node/js Lang setup #######

# NodeJS Setup
export NVM_DIR="$HOME/.nvm"

# Support installs of NVM directly
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm


# Support brew install nvm
#
if [[ `uname` == 'Darwin' ]]; then
  # This loads nvm
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
  # This loads nvm bash_completion
  [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion"
fi

######### End node/js Lang setup #######

######################## begin java config #########################
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
######################## end java config #########################


# ---------------------------- END LANGUAGE SETUP ----------------------------------

################################## begin tmux config ###########################
# Add powerline to path (used in tmux config)
export PATH=${PATH}:~/workspace/virtenvs/powerline/bin
################################## end tmux config ##############################

################################## begin git/editor config ######################
alias gls="git status"
export SVN_EDITOR=vim
export HOMEBREW_EDITOR=vim
export EDITOR="code --wait"
alias gl='git log --oneline --all -10 --decorate'

# Git repo for config files
[[ -d ${HOME}/dotFiles ]] && export DOTFILES_DIR="${HOME}/dotFiles"
[[ -d ${HOME}/workspace/dotFiles.git ]] && \
  export DOTFILES_DIR="${HOME}/workspace/dotFiles.git"
alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'
################################## end git/editor config ###########################


# --------------------------- begin helper functions ---------------------------------

######################### begin ansible helpers ################
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
    export ANSIBLE_ROLES_PATH=`pwd`/../roles
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
######################### end ansible helpers #################


############## begin timer helpers ############################
alias beep=''
[[ -s "/usr/share/sounds/purple/alert.wav" ]]  && \
  export BEEP=/usr/share/sounds/purple/alert.wav && \
  alias beep='paplay $BEEP'

function countdown() {
   date1=$((`date +%s` + $1));
   while [ "$date1" -ge `date +%s` ]; do
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
   beep
}

function stopwatch() {
  date1=`date +%s`;
   while true; do
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
   done
}
############## end timer helpers #####################


# --------------------------- end helper functions -----------------------------------


# ------------------- BEGIN External Integrations ------------------------------------

# aws config
[[ -s "$HOME/.aws_creds" ]] && . "$HOME/.aws_creds"

# ------------------- END External Integrations --------------------------------------



# ------------------------- begin alias/ path masking --------------------------------

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
# [ -n "$PS1" ] && [ -s ${BASE16_SHELL}/profile_helper.sh ] && eval "$( cat ${BASE16_SHELL}/profile_helper.sh)"
# base16_solarized-light
# base16_brewer
[[ -s "${HOME}/.base16_theme" ]] && source ~/.base16_theme;

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
export FZF_DEFAULT_OPTS='--bind=ctrl-k:up,ctrl-j:down,alt-up:first,alt-down:last'

# ------------------------- end alias/ path masking ----------------------------------



# Per project env vars
which direnv >> /dev/null
if [ $? -eq 0 ]; then
  eval "$(direnv hook zsh)"
fi

[ -f "${HOME}/.fzf.zsh" ] && source ${HOME}/.fzf.zsh

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

eval "$(fzf --zsh)"

eval "$(zoxide init zsh)"

if [[ `uname` == 'Darwin' ]]; then
  export PATH="/Users/read/brew/sbin:$PATH"
  export PATH="$(brew --prefix python@3.11)/libexec/bin:$PATH"
fi

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




# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/sprabery/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
  fi

which zoxide >> /dev/null
if [ $? -eq 0 ]; then
  alias real_cd=$(which cd)
  alias cd='z'
fi

which eza >> /dev/null
if [ $? -eq 0 ]; then
  alias ls='eza'
fi

PATH=~/.console-ninja/.bin:$PATH
eval "$(mise activate zsh)"
