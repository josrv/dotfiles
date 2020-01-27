#!/bin/sh

# TODO: DSL

CURRENT_DIR=`pwd`
ln -s "$CURRENT_DIR/config/emacs/config.org" "$HOME/.config/emacs/config.org"
ln -s "$CURRENT_DIR/config/emacs/init.el" "$HOME/.emacs.d/init.el"
