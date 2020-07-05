-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.  pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

--
-- ERROR HANDLING
--

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

--
-- SETTINGS
--

terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 6 
beautiful.border_width = 2

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
}

--
-- MENUBAR
--

menubar.utils.terminal = terminal -- Set the terminal for applications that require it
mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c ~= client.focus then
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({modkey}, 1, function(c) c.minimized = true end),
    awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Tags
    awful.tag.add('1', { -- Terminal
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.75,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('2', { -- Web
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('3', { -- IDE
        screen = s,
        layout = awful.layout.suit.max
    })
    awful.tag.add('4', { -- Telegram
        screen = s,
        layout = awful.layout.suit.floating
    })
    awful.tag.add('5', {
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('6', {
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('7', {
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('8', {
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })
    awful.tag.add('9', {
        screen = s,
        layout = awful.layout.suit.tile,
        master_width_factor = 0.7,
        master_fill_policy = 'master_width_factor'
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end))
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s})

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            awful.widget.watch("weather", 600),
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox
        }
    }
end)

--
-- KEY BINDINGS
--

globalkeys = gears.table.join(
    -- System
    awful.key({modkey}, "F1", function() awful.spawn("systemctl suspend") end,
        { description = "suspend", group = "system" }),

    awful.key({modkey}, "s", hotkeys_popup.show_help, { description = "show help", group = "system" }),

    awful.key({modkey, "Control"}, "r", awesome.restart,
        { description = "reload awesome", group = "system" }),

    awful.key({modkey, "Shift"}, "w", awesome.quit,
        { description = "quit awesome", group = "system"}),

    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
        { description = "increase master volume", group = "system"}),

    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
        { description = "decrease master volume", group = "system"}),

    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
        { description = "toggle master mute", group = "system"}),

    -- Tag
    awful.key({modkey}, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

    awful.key({modkey}, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

    awful.key({modkey}, "Tab", awful.tag.history.restore, { description = "go back", group = "tag" }),

    -- Client
    awful.key({modkey}, "j", function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }),

    awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }),

    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    
    awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    
    awful.key({modkey}, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }), 

    awful.key({modkey, "Control"}, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    -- Screen
    awful.key({modkey, "Control"}, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    
    awful.key({modkey, "Control"}, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),

    -- Programs
    awful.key({modkey}, "p", function() awful.spawn("rofilaunch") end,
        { description = "Launch application or command", group = "programs" }),

    awful.key({}, "#135", function() awful.spawn("rofilaunch") end,
        { description = "Launch application or command", group = "programs" }),

    awful.key({modkey}, "`", function() awful.spawn("rofilaunch") end,
        { description = "Launch application or command", group = "programs" }),

    awful.key({modkey}, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "programs" }),

    awful.key({modkey}, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "programs" }),
         
    awful.key({modkey}, "y", function() awful.spawn("firefox") end,
        { description = "Web browser", group = "programs" }),

    awful.key({modkey, "Shift"}, "y", function() awful.spawn("firefoxwp") end,
        { description = "Web browser with profile", group = "programs" }),

    awful.key({modkey}, "d", function() awful.spawn("thunar") end,
        { description = "File manager", group = "programs" }),

    awful.key({modkey}, "F5", function() awful.spawn("screenshot") end,
        { description = "Screenshot (clipboard)", group = "programs" }),

    awful.key({modkey, "Shift"}, "F5", function() awful.spawn("screenshot file") end,
        { description = "Screnshot (file)", group = "programs" }),
    
    awful.key({modkey, "Shift"}, "s", function() awful.spawn.with_shell("cat ~/.local/share/services | servicetoggle") end,
        { description = "Toggle services", group = "programs" }),

    awful.key({modkey}, "\\", function() 
        -- TODO: don't spawn another scratchpad if there is already one active
        awful.spawn(terminal.." -title scratch -e 'screen -r scratchpad 2>&1 >/dev/null || screen -S scratchpad'")
    end, { description = "Scratchpad", group = "programs" }),

    -- Layout
    awful.key({modkey}, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),

    awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end, 
        { description = "decrease master width factor", group = "layout" }),

    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),

    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" })
)

clientkeys = gears.table.join(
    awful.key({modkey}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    
    awful.key({modkey}, "q", function(c) c:kill() end,
        { description = "close", group = "client"}),

    awful.key({modkey}, "i", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
    
    awful.key({modkey}, "b", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    
    awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    
    awful.key({modkey}, "n", function(c) c.minimized = true end,
        { description = "minimize", group = "client" }),
    
    awful.key({modkey}, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    
    awful.key({modkey, "Control"}, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
                              
    awful.key({modkey, "Shift"}, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({modkey}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
        end, { description = "view tag #" .. i, group = "tag" }),

        awful.key({modkey, "Control"}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then awful.tag.viewtoggle(tag) end
        end, { description = "toggle tag #" .. i, group = "tag" }),
    
        awful.key({modkey, "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
    
        awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:toggle_tag(tag) end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)

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
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false -- Terminal will correctly fit its space.
        }
    }, 
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui", "veromix", "Telegram", "xtightvncviewer",
                "mpv"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }, 
    -- Disable titlebars.
    {
        rule_any = { type = {"normal", "dialog"} },
        properties = { titlebars_enabled = false }
    }, 

    -- JetBrains IDEs.
    {
        rule = { class = "jetbrains-.*", name = "win.*" },
        properties = {
            titlebars_enabled = false,
            focusable = false,
            focus = true,
            floating = true,
            placement = awful.placement.restore
        }
    },

    -- Scratch
    {
        rule = { name = "scratch" },
        properties = {
            floating = true,
            maximized_horizontal = true
        }
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

