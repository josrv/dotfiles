local theme = require("theme")
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local base = require("wibox.widget.base")
local tasklist = require("tasklist")
local markup = lain.util.markup
local space3 = markup.font("Roboto 3", " ")

local bar = {}

local bar_icon = function(icon_path)
    return wibox.widget {
        widget = wibox.container.margin,
        left = dpi(2),
        right = dpi(5),
        top = dpi(3),
        bottom = dpi(2),
        {
            id = "icon_role",
            widget = wibox.widget.imagebox,
            image = icon_path
        }
    }
end

local bar_widget = function(widget, icon)
    local w
    if icon then
        w =
            wibox.widget {
            layout = wibox.layout.fixed.horizontal,
            bar_icon(icon),
            widget
        }
    else
        w = widget
    end

    return wibox.container.margin(w, dpi(5), dpi(5), dpi(5), dpi(5))
end

-- Clock
local clock = wibox.widget.textclock("%H:%M")
clock.font = theme.font
-- clock.forced_width = dpi(45)
local clock_widget = bar_widget(clock, theme.icon_dir .. "/time-line.svg")

-- Calendar
local calendar = wibox.widget.textclock("%a %d %b")
calendar.font = theme.font
-- calendar.forced_width = dpi(70)
local calendar_widget = bar_widget(calendar, theme.icon_dir .. "/calendar-line.svg")

-- Create calendar popup.
lain.widget.cal(
    {
        attach_to = {clock, calendar},
        notification_preset = {
            fg = "#FFFFFF",
            bg = theme.bg_normal,
            position = "bottom_right",
            font = "Monospace 10"
        }
    }
)

-- CPU
local cpu =
    lain.widget.cpu(
    {
        settings = function()
            widget:set_markup(cpu_now.usage .. "%")
        end
    }
)
cpu.widget.forced_width = dpi(30)
cpu.widget.font = theme.font
local cpu_widget = bar_widget(cpu.widget, theme.icon_dir .. "/cpu-line.svg")

-- Memory
local memory =
    lain.widget.mem(
    {
        settings = function()
            widget:set_markup(mem_now.perc .. "%")
        end
    }
)
memory.widget.forced_width = dpi(30)
memory.widget.font = theme.font
local memory_widget = bar_widget(memory.widget, theme.icon_dir .. "/pie-chart-line.svg")

-- Systray
local systray = wibox.widget.systray()
systray:set_base_size(dpi(20))
local systray_widget = bar_widget(systray)

-- Weather
local icons = {
    clouds = theme.icon_dir .. "/cloudy-2-line.svg",
    rain = theme.icon_dir .. "/showers-line.svg",
    snow = theme.icon_dir .. "/snowy-line.svg",
    clear = theme.icon_dir .. "/sun-line.svg",
    thunderstorm = theme.icon_dir .. "/thunderstorms-line.svg"
}

local weather_icon = bar_icon(theme.icon_dir .. "/question-line.svg")
local weather =
    lain.widget.weather(
    {
        city_id = 498817,
        notification_preset = {font = "Monospace 9", position = "bottom_right"},
        lang = "ru",
        settings = function()
            local descr = weather_now["weather"][1]["main"]:lower()
            local icon = icons[descr] or theme.icon_dir .. "/question-line.svg"
            local units = math.floor(weather_now["main"]["temp"])
            widget:set_markup(lain.util.markup.fontfg(theme.font, theme.fg_normal, units .. "°C"))
            weather_icon:get_children_by_id("icon_role")[1]:set_image(icon)
        end
    }
)
local weather_container =
    wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    weather_icon,
    weather
}
weather.widget.forced_width = dpi(30)
local weather_widget = bar_widget(weather_container)
bar.weather = weather

-- Keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
keyboardlayout.widget.forced_width = dpi(20)
keyboardlayout.widget.font = theme.font
local keyboardlayout_widget = bar_widget(keyboardlayout, theme.icon_dir .. "/keyboard-box-line.svg")

-- Camera monitor
local cameramon = wibox.widget.textbox("📸")
local cameramon_widget = bar_widget(cameramon)

cameramon.show_processes = function()
    cameramon.hide_processes()

    if cameramon.processes then
        cameramon.process_list =
            naughty.notify {
            title = "List of processes using camera (/dev/video0)",
            text = cameramon.processes,
            position = "bottom_right",
            timeout = 0
        }
    end
end

cameramon.hide_processes = function()
    if cameramon.process_list then
        naughty.destroy(cameramon.process_list)
    end
end

awful.spawn.with_line_callback(
    "devmon /dev/video0",
    {
        stdout = function(line)
            cameramon.visible = line ~= ""
            cameramon.processes = line
        end
    }
)

cameramon:connect_signal("mouse::enter", cameramon.show_processes)
cameramon:connect_signal("mouse::leave", cameramon.hide_processes)

local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

function bar.create(s)
    -- Create a taglist widget
    s.taglist =
        awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox
                        },
                        margins = 9,
                        widget = wibox.container.margin
                    },
                    {
                        id = "tasklist",
                        layout = wibox.layout.fixed.horizontal
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                id = "background_role",
                widget = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal,
            create_callback = function(self, _, index, _)
                function filter(i)
                    return function(c, scr)
                        local t = scr.tags[i]
                        local ctags = c:tags()
                        for _, v in ipairs(ctags) do
                            if v == t then
                                return true
                            end
                        end
                        return false
                    end
                end
                self:get_children_by_id("tasklist")[1]:add(tasklist(s, filter(index)))
            end
        }
    }

    -- Create the bottom wibox
    s.wibar = awful.wibar({position = "bottom", screen = s, border_width = dpi(0), height = dpi(28), ontop = false})

    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            -- s.layoutbox,
            s.promptbox
        },
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray_widget,
            cameramon_widget,
            weather_widget,
            cpu_widget,
            memory_widget,
            keyboardlayout_widget,
            calendar_widget,
            clock_widget
        }
    }

    -- Assign bar to the screen.
    s.bar = bar
end

return bar
