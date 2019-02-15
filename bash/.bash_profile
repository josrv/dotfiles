#
# ~/.bash_profile
#

export EDITOR="vim"
export BROWSER="surf"
export PATH="$HOME/Scripts:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Launch X on the /dev/tty1
if [ "$(tty)" = "/dev/tty1" ]; then
    pgrep -x i3 || exec startx
fi
