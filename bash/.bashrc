#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias ls='ls -hN --color=auto'
alias p="sudo pacman"
alias s="sudo systemctl"
alias v="nvim"
alias g="git"
alias psg="ps aux | grep"
