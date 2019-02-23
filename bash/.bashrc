#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:$HOME/.scripts/bin

alias ls='ls -hNla --color=auto'
PS1='\[\e[94m\][\u@\h \W]\$\[\e[m\] '

# Aliases
alias p="sudo pacman"
alias v="vim"
alias g="git"
alias psg="ps aux | grep"
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash
