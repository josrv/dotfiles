# Vi Mode
fish_vi_key_bindings

# Path
set -gx --path PATH $HOME/.local/bin:$HOME/.scripts:$HOME/projects/arrival/infra-console-tools/bin $PATH

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

bind -M insert \cp si
bind -M default \cp si

# Prompt
function fish_prompt
    printf '%s|%s%s@%s%s|%s%s%s> ' (set_color normal) (set_color blue) $USER (prompt_hostname) (set_color normal) (set_color red) (prompt_pwd) (set_color normal)
end
