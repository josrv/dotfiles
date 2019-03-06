#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.profile ]] && . ~/.profile

# Launch X on the /dev/tty1
if [ "$(tty)" = "/dev/tty1" ]; then
    pgrep -x bspwm || exec startx
fi
