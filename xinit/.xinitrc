#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Display
xrandr --output DP1 --auto --output LVDS1 --auto --below DP1

desktop_monitor_status="$(cat /sys/class/drm/card0-DP-1/status)"
if [ "$desktop_monitor_status" = "connected" ]; then
    xrandr --output LVDS1 --off
fi

# Keyboard
setxkbmap -layout us,ru -option 'grp:win_space_toggle' -option 'caps:escape'
xmodmap -e "clear Lock"
xset r rate 200 40
xinput disable "SynPS/2 Synaptics TouchPad"

# Background image
. ~/.fehbg &

exec bspwm
