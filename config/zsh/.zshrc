typeset -U path cdpath fpath manpath


export DEFAULT_USER="ivan"
export EDITOR="nvim"

export PROMPT="|%F{33}%n@%m%f|%F{160}%1~%f> "

export ZSH_AUTOSUGGEST_MANUAL_REBIND="true"
export ZSH_AUTOSUGGEST_USE_ASYNC="true"

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/rycee/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


# vim mode config
# ---------------

# Activate vim mode.
bindkey -v

# Remove mode switching delay.
KEYTIMEOUT=5

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# Fix backspace
bindkey "^?" backward-delete-char

# Aliases
alias ..='cd ..'
alias v='vim'
alias vi='vim'
alias vim='nvim'

## OS-specific aliases
case `uname` in
  Darwin)
    alias ls='ls -hlGa'
  ;;
  Linux)
    alias ls='ls -hlNa --color=auto'
  ;;
esac

# Custom functions

# si  — search package and install
si() {
    pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -r sudo pacman -S --noconfirm
}
zle -N si{,}

# si  — uninstall a package
ui() {
    pacman -Qq | fzf -m --preview 'pacman -Qi {1}' | xargs -r sudo pacman -R --noconfirm
}

# Bindings
bindkey "^P" si # Install packages
