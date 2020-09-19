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

local bar_widget = function(widget)
    return wibox.container.margin(widget, dpi(5), dpi(5), dpi(5), dpi(5))
end

-- Clock
local clock = wibox.widget.textclock("🕑 %H:%M ")
clock.font = theme.font
clock.forced_width = dpi(55)
clock.align = "center"
local clock_widget = bar_widget(clock)

-- Calendar
local calendar = wibox.widget.textclock("🗓️ %a %d %b")
calendar.font = theme.font
calendar.forced_width = dpi(80)
calendar.align = "center"
local calendar_widget = bar_widget(calendar)

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
            widget:set_markup("CPU " .. cpu_now.usage .. "%")
        end
    }
)
cpu.widget.forced_width = dpi(55)
cpu.widget.font = theme.font
cpu.widget.align = "center"
local cpu_widget = bar_widget(cpu.widget)

-- Memory
local memory =
    lain.widget.mem(
    {
        settings = function()
            widget:set_markup(space3 .. markup.font(theme.font, "RAM " .. mem_now.perc .. "%"))
        end
    }
)
memory.widget.forced_width = dpi(55)
memory.widget.font = theme.font
memory.widget.align = "center"
local memory_widget = bar_widget(memory.widget)

-- Systray
local systray = wibox.widget.systray()
systray:set_base_size(dpi(20))
local systray_widget = bar_widget(systray)

-- Weather
local icons = {
    clouds = "☁️",
    rain = "☔",
    snow = "❄️",
    clear = "☀️",
    thunderstorm = "🌩️"
}

local weather =
    lain.widget.weather(
    {
        city_id = 498817,
        notification_preset = {font = "Monospace 9", position = "bottom_right"},
        lang = "ru",
        settings = function()
            local descr = weather_now["weather"][1]["main"]:lower()
            local icon = icons[descr] or "⛅"
            local units = math.floor(weather_now["main"]["temp"])
            widget:set_markup(lain.util.markup.fontfg(theme.font, theme.fg_normal, icon .. "  " .. units .. "°C"))
        end
    }
)
weather.widget.forced_width = dpi(50)
weather.widget.align = "center"
local weather_widget = bar_widget(weather.widget)
bar.weather = weather

-- Keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
keyboardlayout.widget.font = theme.font
keyboardlayout.widget.forced_width = dpi(25)
keyboardlayout.widget.align = "center"
local keyboardlayout_widget = bar_widget(keyboardlayout)

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

function bar.create(s)
    -- Create a taglist widget
    s.taglist =
        awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
        layout = {
            spacing = 3,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id = "icon_role",
                    widget = wibox.widget.imagebox
                },
                margins = 2,
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background
        }
    }

    s.taglist_widget = bar_widget(s.taglist)

    -- Create a tasklist widget
    s.tasklist_widget = tasklist(s)

    -- Create the bottom wibox
    s.wibar = awful.wibar({position = "bottom", screen = s, border_width = dpi(0), height = dpi(28), ontop = false})

    -- Add widgets to the bottom wibox
    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.taglist_widget,
            -- s.layoutbox,
            s.promptbox
        },
        s.tasklist_widget, -- Middle widget
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
