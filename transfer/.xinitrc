setxkbmap -layout us,ru -option 'grp:win_space_toggle' -option 'caps:escape' -option 'compose:menu'

xmodmap -e "clear Lock"
xset r rate 200 40

exec xmonad
