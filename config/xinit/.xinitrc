#!/bin/sh

[ -f ~/.xprofile ] && . ~/.xprofile

# GNOME keyring prompt doesn't work without this.
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

exec awesome

