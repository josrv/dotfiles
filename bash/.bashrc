#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='ls -hNla --color=auto'
PS1='\[\e[94m\][\u@\h \W]\$\[\e[m\] '

# Aliases
alias p="sudo pacman"
alias s="sudo rc-service"
alias v="vim"
alias g="git"
alias psg="ps aux | grep"
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash

# Settings
#set -o vi

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# ce — edit dotfiles
ce() {
    local file
    file=$(find -L ~/.dotfiles/ -type f | fzf)
    [[ -n "$file" ]] && $EDITOR "$file" && echo "Edited $file"
}
