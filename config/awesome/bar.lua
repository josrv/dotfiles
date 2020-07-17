local theme = require("theme")
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local colors = require("beautiful.xresources").get_current_theme()
local markup = lain.util.markup
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local blue   = "#80CCE6"
local space3 = markup.font("Roboto 3", " ")

local bar = {}

-- Clock
local mytextclock = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%H:%M   " .. markup.font("Roboto 4", " ")))
mytextclock.font = theme.font
local clock_icon = wibox.widget.imagebox(theme.clock)
local clockbg = wibox.container.background(mytextclock, theme.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, dpi(0), dpi(3), dpi(5), dpi(5))

-- Calendar
local mytextcalendar = wibox.widget.textclock(markup.fontfg(theme.font, "#FFFFFF", space3 .. "%a %d %b " .. markup.font("Roboto 5", " ")))
local calendar_icon = wibox.widget.imagebox(theme.calendar)
local calbg = wibox.container.background(mytextcalendar, theme.bg_focus, gears.shape.rectangle)
local calendarwidget = wibox.container.margin(calbg, dpi(0), dpi(0), dpi(5), dpi(5))

local cal = lain.widget.cal({
    attach_to = { mytextclock, mytextcalendar },
    notification_preset = {
        fg = "#FFFFFF",
        bg = theme.bg_normal,
        position = "bottom_right",
        font = "Monospace 10"
    }
})

-- CPU
local cpu_icon = wibox.widget.imagebox(theme.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(space3 .. markup.font(theme.font, "CPU " .. cpu_now.usage
                          .. "% ") .. markup.font("Roboto 5", " "))
    end
})
local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg, dpi(0), dpi(0), dpi(5), dpi(5))

-- Memory
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(space3 .. markup.font(theme.font, "RAM " .. mem_now.perc .. "% ") .. markup.font("Roboto 5", " "))
    end
})
local memorywidget = wibox.container.margin(
    wibox.container.background(memory.widget, theme.bg_focus, gears.shape.rectangle), dpi(0), dpi(0), dpi(5), dpi(5)
)

-- Net
local netdown_icon = wibox.widget.imagebox(theme.net_down)
local netup_icon = wibox.widget.imagebox(theme.net_up)
local net = lain.widget.net({
    notify = "off",
    wifi_state = "on",
    eth_state = "on",
    settings = function()
        --widget:set_markup(markup.font(theme.font, net_now.devices.wlp7s0.wifi))
    end
})
local netbg = wibox.container.background(net.widget, theme.bg_focus, gears.shape.rectangle)
local networkwidget = wibox.container.margin(netbg, dpi(0), dpi(0), dpi(5), dpi(5))

-- Systray
local systray = wibox.widget.systray()
systray:set_base_size(dpi(20))
local systraywidget = wibox.container.margin(systray, dpi(0), dpi(4), dpi(6), dpi(4))

-- Weather
local weather = lain.widget.weather({
    city_id = 498817,
    notification_preset = { font = "Monospace 9", position = "bottom_right" },
    lang = "ru",
    settings = function()
        local descr = weather_now["weather"][1]["description"]:lower()
        local units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(lain.util.markup.fontfg(theme.font, theme.fg_normal, units .. "°C"))
    end
})
local weatherwidget = wibox.container.margin(wibox.container.background(weather.widget, theme.bg_focus, gears.shape.rectangle), dpi(0), dpi(0), dpi(5), dpi(5))
bar.weather = weather

-- Keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
keyboardlayout.widget.font = theme.font
local keyboardwidget = wibox.container.margin(wibox.container.background(keyboardlayout, theme.bg_focus, gears.shape.rectangle), dpi(0), dpi(0), dpi(5), dpi(5))

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_bottom_right = wibox.widget.imagebox(theme.spr_bottom_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)

local barcolor  = gears.color({
    type  = "linear",
    from  = { dpi(32), 0 },
    to    = { dpi(32), dpi(32) },
    stops = { {0, theme.bg_focus}, {0.25, "#505050"}, {1, theme.bg_focus} }
})


function bar.create(s)
    -- Create a layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor })

    mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, dpi(0), dpi(0), dpi(5), dpi(5))

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist{
        screen = s, 
        filter = awful.widget.tasklist.filter.currenttags, 
        buttons = awful.util.tasklist_buttons,
        style = {
            bg_focus = theme.bg_focus,
            shape = gears.shape.rectangle,
            shape_border_width = 5,
            shape_border_color = theme.tasklist_bg_normal,
            align = "center" 
        },
        layout = {
            layout = wibox.layout.fixed.horizontal
        }
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = dpi(0), height = dpi(32) })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            s.mytag,
            spr_small,
            s.mylayoutbox,
            spr_small,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systraywidget,
            spr_small,
            weatherwidget,
            bottom_bar,
            cpu_icon,
            cpuwidget,
            bottom_bar,
            memorywidget,
            bottom_bar,
            keyboardwidget,
            bottom_bar,
            calendar_icon,
            calendarwidget,
            bottom_bar,
            clock_icon,
            clockwidget,
        },
    }

    -- Assign bar to the screen.
    s.bar = bar
end

return bar

