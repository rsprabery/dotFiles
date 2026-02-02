# ==============================================================================
# 00) Boot / completion performance
# ==============================================================================

# Keep OMZ, but don't let it run compinit
skip_global_compinit=true
ZSH_DISABLE_COMPFIX=true

# Your custom completions
fpath=($HOME/.zsh/completions $fpath)

# Put compdump somewhere stable
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p -- "${ZSH_COMPDUMP:h}"

# Run fast compinit (audit daily)
autoload -Uz compinit
zmodload zsh/datetime

typeset -i now=$EPOCHSECONDS
typeset -i last=0
ts="${ZSH_COMPDUMP}.audit_ts"
[[ -f "$ts" ]] && last=$(< "$ts")

if (( now - last > 86400 )); then
  compinit -d "$ZSH_COMPDUMP"
  print -r -- "$now" > "$ts"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# ==============================================================================
# 01) Oh-My-Zsh (configuration only — load happens later)
# ==============================================================================

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

# plugins=(git ruby git-extras pip python vundle osx bundler dotenv ansible brew colored-man-pages dash django gem iterm2 man npm node tmux)
plugins=(git pip python ruby gem bundler colored-man-pages bundler brew tmux docker)

# Disable google analytic reporting in homebrew
HOMEBREW_NO_ANALYTICS=1


# ==============================================================================
# 02) Machine-specific / local overrides (early)
# ==============================================================================

[[ -s "$HOME/.local_box_profile.zsh" ]] && . $HOME/.local_box_profile.zsh


# ==============================================================================
# 03) PATH & core environment (cross-platform)
# ==============================================================================

# Add custom bin's
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"

[[ -d "/Applications/RubyMine.app/Contents/MacOS" ]] && export PATH="$PATH:/Applications/RubyMine.app/Contents/MacOS"


# ==============================================================================
# 04) Shell behavior, prompt, keybindings
# ==============================================================================

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

# ==============================================================================
# 05) OS-specific configuration
# ==============================================================================

if [[ "$(uname)" == "Linux" ]]; then
  [[ -d "/home/read/.linuxbrew" ]] && export PATH="$PATH:/home/read/.linuxbrew/bin"

  function open {
    if [[ -d "${1}" ]]; then
      thunar "${1}" &> /dev/null &
      disown %$(jobs | sed 's/\[//g' | sed 's/\]//g'| grep thunar |  awk '{print $1}')
    else
      echo "${1} is not a directory!"
    fi
  }

  function pbcopy() {
    # sed 's/\n//g' | xclip -selection clipboard
    awk '{printf "%s",$0} END {print ""}' | xclip -selection clipboard
  }
  alias pbpaste='xclip -selection clipboard -o'
elif [[ "$(uname)" == "Darwin" ]]; then
  ########### Begin homebrew setup #############################

  if [[ "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
    # Darwin brew completions (only if brew exists)
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
    export PATH="$(brew --prefix)/bin:${PATH}"

    # ctags override
    [[ -s "$(brew --prefix)/bin/ctags" ]] && alias ctags="$(brew --prefix)/bin/ctags"

    # gnu utils override BSD versions.
    [[ -d "$(brew --prefix)/opt/gnu-tar/libexec/gnubin" ]] && \
      PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
  fi

  ########### End homebrew setup #############################

fi


# ==============================================================================
# 06) Language managers & toolchains
# ==============================================================================

# --- mise (toolchain manager) ---
if [[ -o interactive ]]; then
  which mise >> /dev/null
  if [ $? -eq 0 ]; then
    eval "$(mise activate zsh)"
  fi
fi

# --- Ruby / Gems ---
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

function ctags-ruby() {
  ctags -R --languages=ruby --exclude=.git --exclude=log .
  ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)
}


# --- Go ---
[[ -d "${HOME}/go" ]] && export GOPATH="${HOME}/go"
[[ -d "${HOME}/go/bin" ]] && export PATH="${PATH}:${HOME}/go/bin/"

# --- Java / Gradle wrapper ---
GRADLE_BIN=$(which gradle)
function gradle {
  if [[ -a "$(pwd)/gradlew" ]]; then
    ./gradlew "$@"
  else
    if [[ -z "${GRADLE_BIN}" ]]; then
      "$HOME/bin/gradle" "$*"
    else
      "${GRADLE_BIN}" "$*"
    fi
  fi
}


# ==============================================================================
# 07) Tmux / terminal extras
# ==============================================================================

[[ -d "${HOME}/workspace/virtenvs/powerline/bin" ]] && export PATH="${PATH}:~/workspace/virtenvs/powerline/bin"


# ==============================================================================
# 08) Git, editor, dotfiles
# ==============================================================================

alias gls="git status"
alias gl='git log --oneline --all -10 --decorate'

export SVN_EDITOR=vim
export HOMEBREW_EDITOR=vim
export EDITOR="vim"
# export EDITOR="code --wait"

# Git repo for config files
[[ -d ${HOME}/dotFiles ]] && export DOTFILES_DIR="${HOME}/dotFiles"
[[ -d ${HOME}/workspace/dotFiles.git ]] && export DOTFILES_DIR="${HOME}/workspace/dotFiles.git"
alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'


# ==============================================================================
# 09) External integrations / tool hooks
# ==============================================================================

# aws config
[[ -s "$HOME/.aws_creds" ]] && . "$HOME/.aws_creds"

eval "$(zoxide init zsh)"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/sprabery/Library/Caches/heroku/autocomplete/zsh_setup \
  && test -f "$HEROKU_AC_ZSH_SETUP_PATH" \
  && source "$HEROKU_AC_ZSH_SETUP_PATH"

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi


# ==============================================================================
# 10) Custom functions (helpers)
# ==============================================================================

# --- Ansible helpers ---
if [[ -z "$ANSIBLE_BIN" ]]; then
  export ANSIBLE_BIN="$(which ansible)"
  export ANSIBLE_PLAYBOOK_BIN="$(which ansible-playbook)"
fi

function ansible {
  if [[ -a "$(pwd)/inventory" ]]; then
    "$ANSIBLE_BIN" -i inventory "$@" -f 50
  else
    "$ANSIBLE_BIN" "$*" -f 50
  fi
}

function playbook {
  if [[ -a "$(pwd)/inventory" ]]; then
    "$ANSIBLE_PLAYBOOK_BIN" -i inventory "$@" -f 50
  else
    "$ANSIBLE_PLAYBOOK_BIN" "$*" -f 50
  fi
}

function ap {
  if [[ -d "$(pwd)/../../roles" ]]; then
    export ANSIBLE_ROLES_PATH="$(pwd)/../roles"
  fi
  playbook "$*"
  unset ANSIBLE_ROLES_PATH
}

function make_role {
  mkdir -p "$1"/{tasks,handlers,vars,defaults,meta,templates,files}
  echo "---\n" >> "$1/tasks/main.yml"
  echo "---\n" >> "$1/handlers/main.yml"
  echo "---\n" >> "$1/vars/main.yml"
  echo "---\n" >> "$1/defaults/main.yml"
  echo "---\n" >> "$1/meta/main.yml"
  touch "$1/templates/.keep" "$1/files/.keep"
}

# --- Timer helpers ---
alias beep=''
[[ -s "/usr/share/sounds/purple/alert.wav" ]] && \
  export BEEP=/usr/share/sounds/purple/alert.wav && \
  alias beep='paplay $BEEP'

function countdown() {
  date1=$(( $(date +%s) + $1 ))
  while [ "$date1" -ge "$(date +%s)" ]; do
    echo -ne "$(date -u --date @$((date1 - $(date +%s))) +%H:%M:%S)\r"
    sleep 0.1
  done
  beep
}

function stopwatch() {
  date1="$(date +%s)"
  while true; do
    echo -ne "$(date -u --date @$(( $(date +%s) - date1 )) +%H:%M:%S)\r"
    sleep 0.1
  done
}

# --- Git + fzf helpers ---
fshow () {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
          (grep -o '[a-f0-9]\{7\}' | head -1 |
          xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
          {}
FZF-EOF"
}

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview "$preview"
}

gs () {
  # -S only shows commits where the number of occurrences changed
  # -G shows all commits where the word occurs at all.
  fshow -S${@}
}

recent-branches () {
  git reflog | egrep -io "moving from ([^[:space:]]+)" | awk '{ print $3 }' | \
    awk ' !x[$0]++' | egrep -v '^[a-f0-9]{40}$'
}


# ==============================================================================
# 11) Wrappers / aliases around common utils
# ==============================================================================

# Make vim -> nvim if neovim is installed
which nvim >> /dev/null
if [ $? -eq 0 ]; then
  alias vim=nvim
  alias view='nvim -R'
fi

# wdiff with color output piped into less -R
real_wdiff=$(which wdiff)
if [ $? -eq 0 ]; then
  function wdiff {
    ${real_wdiff} -n \
      -w $'\033[30;41m' -x $'\033[0m' \
      -y $'\033[30;42m' -z $'\033[0m' \
      "$@" | less -R
  }
fi

# Base16 theme
BASE16_SHELL=$HOME/.config/base16-shell/
[[ -s "${HOME}/.base16_theme" ]] && source ~/.base16_theme

# ag wrapper (uses repo .gitignore when inside a git repo)
ag() {
  command ag \
    -p "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "$(git rev-parse --show-toplevel)/.gitignore")" \
    "$@"
}
alias agc='ag --color-match=#0'

# cd wrapper via zoxide
which zoxide >> /dev/null
if [ $? -eq 0 ]; then
  # NOTE: `cd` is a shell builtin; `which cd`/aliasing "real_cd" is not meaningful.
  # Keeping your intent, but you can always use: `builtin cd`.
  alias cd='z'
fi

# ls wrapper via eza
which eza >> /dev/null
if [ $? -eq 0 ]; then
  alias ls='eza'
fi


# ==============================================================================
# 12) Misc env vars / paths
# ==============================================================================

PATH=~/.console-ninja/.bin:$PATH
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$HOMEBREW_PREFIX/lib:$DYLD_FALLBACK_LIBRARY_PATH"

export LC_ALL="en_US.UTF-8"


# ==============================================================================
# 13) OMZ load (late) + compile hack
# ==============================================================================

# Prevent OMZ from running zrecompile at every startup
autoload -Uz zrecompile 2>/dev/null || true
typeset -f zrecompile >/dev/null && __REAL_ZRECOMPILE=$(functions zrecompile)
zrecompile() { :; }  # no-op during init

# Load oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# Restore real zrecompile after OMZ loads (optional)
if [[ -n "${__REAL_ZRECOMPILE:-}" ]]; then
  eval "$__REAL_ZRECOMPILE"
else
  unfunction zrecompile 2>/dev/null || true
  autoload -Uz zrecompile 2>/dev/null || true
fi
unset __REAL_ZRECOMPILE

omz_compile() {
  command zrecompile -p ~/.oh-my-zsh/**/*.zsh(N) ~/.oh-my-zsh/**/*.zsh-theme(N) 2>/dev/null
}

# ==============================================================================
# 14) fzf (load LAST so nothing overwrites keybindings)
# ==============================================================================

if [[ -o interactive ]] && command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="rg --files"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--bind=ctrl-k:up,ctrl-j:down,alt-up:first,alt-down:last'

  # Defines fzf-* widgets and default bindings (Ctrl-T/Ctrl-R/Alt-C)
  eval "$(fzf --zsh)"

  # overrides
  bindkey -M viins '^F' fzf-file-widget
  bindkey -M vicmd '^F' fzf-file-widget
  bindkey -M viins '^R' fzf-history-widget
  bindkey -M vicmd '^R' fzf-history-widget
fi
