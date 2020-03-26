xrdb -merge -I$HOME ~/.Xresources

setxkbmap -layout us,ru -option 'grp:win_space_toggle' -option 'caps:escape' -option 'compose:menu'

xmodmap -e "clear Lock"
xset r rate 200 40

sxhkd &
$HOME/.fehbg

tint2 &

exec bspwm
