#!/usr/bin/env bash

read -r -d '' FILES << EOC
emacs/config.org     $HOME/.config/emacs/config.org
emacs/init.el        $HOME/.emacs.d/init.el
EOC

CURRENT_DIR=`pwd`

