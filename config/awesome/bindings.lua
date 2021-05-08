local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local modkey = "Mod4"

local bindings = {
    keys = {},
    buttons = {}
}

bindings.keys.global =
    gears.table.join(
    -- System
    awful.key(
        {modkey},
        "F1",
        function()
            awful.spawn("powermenu")
        end,
        {description = "Choose power action (sleep, hibernate, reboot, poweroff)", group = "system"}
    ),
    awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "system"}),
    awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "system"}),
    awful.key({modkey, "Shift"}, "F12", awesome.quit, {description = "quit awesome", group = "system"}),
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
        end,
        {description = "increase master volume", group = "system"}
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
        end,
        {description = "decrease master volume", group = "system"}
    ),
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
        end,
        {description = "toggle master mute", group = "system"}
    ),
    awful.key(
        {modkey},
        "o",
        function()
          awful.spawn("nmtoggle wg")
        end,
        {description = "Toggle Wireguard connection", group = "system"}
    ),
    awful.key(
        {modkey},
        "-",
        function()
          awful.spawn("xkill")
        end,
        {description = "Select a window to kill", group = "system"}
    ),
    -- Tag
    awful.key({modkey}, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
    -- Client
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "u",
        awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- Screen
    awful.key(
        {modkey},
        "Tab",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    -- Programs
    awful.key(
        {modkey},
        "p",
        function()
            awful.spawn("rofilaunch")
        end,
        {description = "launch application or command", group = "programs"}
    ),
    awful.key(
        {modkey},
        "`",
        function()
            awful.spawn("rofilaunch")
        end,
        {description = "launch application or command", group = "programs"}
    ),
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn("alacritty")
        end,
        {description = "open terminal", group = "programs"}
    ),
    awful.key(
        {modkey},
        "r",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {description = "run prompt", group = "programs"}
    ),
    awful.key(
        {modkey},
        "y",
        function()
            awful.spawn("firefox")
        end,
        {description = "open web browser", group = "programs"}
    ),
    awful.key(
        {modkey},
        "e",
        function()
            awful.spawn("emacsclient -cn")
        end,
        {description = "open Emacs", group = "programs"}
    ),
    awful.key(
        {modkey, "Shift"},
        "e",
        function()
            awful.spawn("systemctl --user restart emacs", true,
              function()
                naughty.notify({ title = "Emacs restarted"})
              end
            )
        end,
        {description = "restart Emacs", group = "programs"}
    ),
    awful.key(
        {modkey},
        "a",
        function()
            awful.spawn("lastsms")
        end,
        {description = "Type last received SMS OTP code", group = "programs"}
    ),
    awful.key(
        {modkey, "Shift"},
        "a",
        function()
            awful.spawn("lastsms --notify")
        end,
        {description = "Show last SMS", group = "programs"}
    ),
    awful.key(
        {modkey},
        "d",
        function()
            awful.spawn("rofi -modi file-browser -show file-browser -matching fuzzy")
        end,
        {description = "open file manager", group = "programs"}
    ),
    awful.key(
        {},
        "Print",
        function()
            awful.spawn("flameshot gui")
        end,
        {description = "make screenshot", group = "programs"}
    ),
    awful.key(
        {modkey, "Shift"},
        "s",
        function()
            awful.spawn.with_shell("cat ~/.local/share/services | servicetoggle")
        end,
        {description = "toggle services", group = "programs"}
    ),
    awful.key(
        {modkey},
        ".",
        function()
            awful.util.scratchpad:toggle()
        end,
        {description = "open scratchpad terminal", group = "programs"}
    ),
    awful.key(
        {modkey},
        "[",
        function()
            awful.util.calculator:toggle()
        end,
        {description = "open calculator", group = "programs"}
    ),
    awful.key(
        {modkey},
        ",",
        function()
            awful.spawn.with_shell("bwmenu")
        end,
        {description = "open Bitwarden client", group = "programs"}
    ),
    awful.key(
        {modkey, "Shift"},
        "w",
        function()
            awful.screen.focused().bar.weather.show(5)
        end,
        {description = "show weather popup", group = "programs"}
    ),
    -- Layout
    awful.key(
        {modkey},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey},
        "m",
        function()
            awful.spawn.with_shell("summary")
        end,
        {description = "sync mail", group = "programs"}
    )
)

bindings.keys.client =
    gears.table.join(
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey},
        "q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    awful.key({modkey}, "i", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key(
        {modkey},
        "b",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key(
        {modkey},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "Tab",
        function(c)
            c:move_to_screen(c.screen.index + 1)
        end,
        {description = "move client to the other screen", group = "client"}
    )
)

for i = 1, 9 do
    bindings.keys.global =
        gears.table.join(
        bindings.keys.global,
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

bindings.buttons.client =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

return bindings
