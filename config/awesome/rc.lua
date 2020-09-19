local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local theme = require("theme")

awful.util.shell = "sh"

local bar = require("bar")
local bindings = require("bindings")

--
-- ERROR HANDLING
--

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

--
-- SETTINGS
--

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.max,
    awful.layout.suit.floating
}

root.keys(bindings.keys.global)

-- Scratchpad
awful.util.scratchpad =
    lain.util.quake {
    app = "termite",
    name = "scratchpad",
    argname = "--name %s",
    height = 0.45,
    followtag = true,
    settings = function(c)
        c.sticky = true
    end
}

awful.screen.connect_for_each_screen(
    function(s)
        -- If wallpaper is a function, call it with the screen
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)

        -- Tags
        awful.tag.add(
            "MAIN",
            {
                layout = awful.layout.suit.tile,
                screen = s,
                icon = theme.icon_dir .. "/home.svg",
                icon_only = true,
                selected = true
            }
        )
        awful.tag.add(
            "WEB",
            {
                layout = awful.layout.suit.max,
                screen = s,
                icon = theme.icon_dir .. "/chrome.svg",
                icon_only = true
            }
        )
        awful.tag.add(
            "IDE",
            {
                layout = awful.layout.suit.max,
                screen = s,
                icon = theme.icon_dir .. "/code.svg",
                icon_only = true
            }
        )
        awful.tag.add(
            "CHAT",
            {
                layout = awful.layout.suit.floating,
                screen = s,
                icon = theme.icon_dir .. "/message-square.svg",
                icon_only = true
            }
        )
        awful.tag.add(
            "MEDIA",
            {
                layout = awful.layout.suit.tile,
                screen = s,
                icon = theme.icon_dir .. "/play-circle.svg",
                icon_only = true
            }
        )
        awful.tag.add(
            "MISC",
            {
                layout = awful.layout.suit.tile,
                screen = s,
                icon = theme.icon_dir .. "/grid.svg",
                icon_only = true
            }
        )
        bar.create(s)
    end
)

--
-- RULES
--

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = bindings.keys.client,
            buttons = bindings.buttons.client,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false -- Terminal will correctly fit its space.
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "pinentry"
            },
            class = {
                "Arandr",
                "Sxiv",
                "Tor Browser",
                "Telegram",
                "mpv"
            },
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        rule = {
            class = "firefox",
            instance = "Devtools"
        },
        properties = {floating = true}
    },
    -- Disable titlebars.
    {
        rule_any = {type = {"normal", "dialog"}},
        properties = {titlebars_enabled = false}
    },
    -- JetBrains IDEs.
    {
        rule = {class = "jetbrains-.*", name = "win.*"},
        properties = {
            titlebars_enabled = false,
            focusable = false,
            focus = true,
            floating = true,
            placement = awful.placement.restore
        }
    },
    -- Prompts.
    {
        rule = {
            class = "Gcr-prompter" -- Gnome Keyring password prompt.
        },
        properties = {
            floating = true,
            focus = true,
            placement = awful.placement.centered
        }
    },
    -- Tags.
    {
        rule = {class = "jetbrains-.*"},
        properties = {tag = "IDE", switchtotag = true}
    },
    {
        rule = {class = "firefox"},
        properties = {tag = "WEB", switchtotag = true}
    },
    {
        rule = {class = "Telegram"},
        properties = {screen = 2, tag = "CHAT", switchtotag = true}
    },
    {
        rule = {class = "mpv"},
        properties = {tag = "MEDIA", switchtotag = true}
    },
    {
        rule = {class = "zoom"},
        properties = {tag = "MEDIA", switchtotag = true}
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        if not awesome.startup then
            awful.client.setslave(c)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)

client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
        awful.last_focused_client = c
    end
)

-- No borders when rearranging only 1 non-floating or maximized client.
screen.connect_signal(
    "arrange",
    function(s)
        local only_one = #s.tiled_clients == 1
        for _, c in pairs(s.clients) do
            if only_one and not c.floating or c.maximized then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
        end
    end
)

-- Focus urgent clients automatically (excluding some clients).
local excluded_for_urgent_jumps = {{class = "Telegram"}}
client.connect_signal(
    "property::urgent",
    function(c)
        c.minimized = false

        ---if not awful.rules.matches_list(c, excluded_for_urgent_jumps) then
        c:jump_to()
        -- end
    end
)
