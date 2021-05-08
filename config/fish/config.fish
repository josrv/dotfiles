# Vi Mode
fish_vi_key_bindings

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

