#
# ~/.bash_profile
#

export EDITOR="vim"
export BROWSER="icecat"
export WINDOW_MANAGER="bspwm"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Launch X on the /dev/tty1
if [ "$(tty)" = "/dev/tty1" ]; then
    pgrep -x $WINDOW_MANAGER || exec startx
fi
