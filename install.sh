#!/bin/bash

# Install dotfiles using GNU Stow
stow -R bash -R bspwm less sxhkd vim X xinit

# Install custom Firefox styles
profile_name=`grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=//`
mkdir -p ~/.mozilla/firefox/$profile_name/chrome && cp userChrome.css "$_"
