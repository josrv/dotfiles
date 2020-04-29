xrdb -merge -I$HOME ~/.Xresources

$HOME/.scripts/configure-keyboard

$HOME/.fehbg

# Launch SXHKD
sxhkd &

# Launch BSPWM
exec bspwm
