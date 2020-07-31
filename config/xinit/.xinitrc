xrdb -merge -I$HOME ~/.Xresources

setxkbmap -layout us,ru -option 'grp:win_space_toggle' -option 'caps:escape' -option 'compose:menu'
xmodmap -e "clear Lock"
xset r rate 200 40

xrandr --output HDMI-0 --auto --output DP-0 --auto --right-of HDMI-0

pasystray &
exec awesome
