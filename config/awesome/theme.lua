local colors = require("beautiful.xresources").get_current_theme()
local dpi   = require("beautiful.xresources").apply_dpi

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir                                  = os.getenv("HOME") .. "/.config/awesome/theme/icons"
theme.wallpaper                                 = os.getenv("HOME") .. "/media/pictures/wall.jpg"
theme.font                                      = "Inter 9"
theme.fg_normal                                 = "#FFFFFF"
theme.bg_focus                                  = "#474747"
theme.bg_normal                                 = "#242424"
--theme.bg_normal                                 = "#0B0636"
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#006B8E"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#252525"
theme.border_focus                              = colors["color4"]
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_normal                        = "#222222"
theme.tasklist_plain_task_name                  = true
theme.tasklist_task_size                        = 120
theme.menu_height                               = dpi(20)
theme.menu_width                                = dpi(160)
theme.menu_icon_size                            = dpi(32)
theme.close_icon                                = theme.icon_dir .. "/close.svg"
theme.useless_gap                               = dpi(4)
theme.systray_icon_spacing                      = 2
theme.gap_single_client                         = false

return theme
