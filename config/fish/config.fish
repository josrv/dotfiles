# Vi Mode
fish_vi_key_bindings

# Path
set -gx GOPATH $HOME/.local/share/go
set -gx --path PATH $HOME/.local/bin $HOME/.scripts $HOME/projects/arrival/infra-console-tools/bin $GOPATH/bin $PATH

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx LESSHISTFILE /dev/null
set -gx NOTMUCH_CONFIG $XDG_CONFIG_HOME/notmuch-config
set -gx K9SCONFIG $XDG_CONFIG_HOME/k9s
# Entirely configuring the kubectl directory is not possible.
# https://github.com/kubernetes/kubernetes/issues/78664
# Setting KUBECONFIG is not enough: $HOME/.kube/cache is hardcoded.
# set -gx KUBECONFIG $HOME/.config/kube/config
set -gx DOCKER_CONFIG $XDG_CONFIG_HOME/docker
set -gx AWS_SHARED_CREDENTIALS_FILE $XDG_CONFIG_HOME/aws/credentials
set -gx AWS_CONFIG_FILE $XDG_CONFIG_HOME/aws/config
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config
set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm
set -gx NPM_CONFIG_TMP $XDG_RUNTIME_DIR/npm

set -gx LIBVA_DRIVER_NAME radeonsi 
set -gx VDPAU_DRIVER radeonsi

set -gx MOZ_X11_EGL 1

## Cursor shape
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

## Disable mode indicator
function fish_mode_prompt; end

# Appearance
set fish_greeting ""

# Custom functions
## si -- install a package
function si
  commandline pkginstall
  commandline -f execute
end
## ui -- uninstall a package
function ui
  commandline pkguninstall
  commandline -f execute
end

# Prompt
function fish_prompt
    printf '%s|%s%s@%s%s|%s%s%s> ' (set_color normal) (set_color blue) $USER (prompt_hostname) (set_color normal) (set_color red) (prompt_pwd) (set_color normal)
end

# Bindings
bind -M insert  \cp si
bind -M default \cp si
bind -M insert  \cu ui
bind -M default \cu ui

## Navigation
### Disable arrow keys
#bind -M insert \e\[A false
#bind -M default \e\[A false
#bind -M insert \e\[B false
#bind -M default \e\[B false
#bind -M insert \e\[C false
#bind -M default \e\[C false
#bind -M insert \e\[D false
#bind -M default \e\[D false

### Navigation in the Insert mode
bind -M insert \el forward-char
bind -M insert \eh backward-char
bind -M insert \ej down-or-search
bind -M insert \ek up-or-search

# Start X at login.
if status is-login
    if test -z "$DISPLAY" -a (tty) = "/dev/tty1"
        exec startx -- -keeptty -dpi 120
    end
end
