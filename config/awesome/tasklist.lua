local theme = require("theme")
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local function hoverable(widget)
    local container =
        wibox.widget {
        widget,
        widget = wibox.container.background
    }
    local previous_bg
    container:connect_signal(
        "mouse::enter",
        function()
            previous_bg = container.bg
            container.bg = "#ffffff11"
        end
    )

    container:connect_signal(
        "mouse::leave",
        function()
            container.bg = previous_bg
        end
    )

    return container
end

local tasklist_buttons =
    awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    )
)

local function build_layout()
    local l =
        wibox.widget {
        id = "background_role",
        border_strategy = "inner",
        widget = wibox.container.background,
        {
            layout = wibox.layout.align.horizontal,
            {
                id = "icon_margin_role",
                widget = wibox.container.margin,
                left = dpi(3),
                top = dpi(3),
                bottom = dpi(3),
                {id = "icon_role", widget = awful.widget.clienticon}
            },
            {
                id = "text_margin_role",
                widget = wibox.container.margin,
                left = dpi(4),
                right = dpi(4),
                {id = "text_role", widget = wibox.widget.textbox}
            },
            {
                layout = wibox.container.margin,
                margins = dpi(6),
                {
                    id = "close_button",
                    widget = hoverable,
                    shape = gears.shape.circle,
                    {
                        widget = wibox.container.margin,
                        margins = dpi(2),
                        {
                            widget = wibox.widget.imagebox,
                            image = theme.icon_dir .. "/close-line.svg",
                            opacity = 0.85
                        }
                    }
                }
            }
        }
    }
    return {
        ib = l:get_children_by_id("icon_role")[1],
        tb = l:get_children_by_id("text_role")[1],
        bgb = l:get_children_by_id("background_role")[1],
        tbm = l:get_children_by_id("text_margin_role")[1],
        ibm = l:get_children_by_id("icon_margin_role")[1],
        root = l
    }
end

local function list_update(w, buttons, label, data, objects)
    w:reset()
    for i, client in ipairs(objects) do
        local layout = data[client]

        if not layout then
            layout = build_layout()

            layout.root:buttons(awful.widget.common.create_buttons(buttons, client))

            layout.root:get_children_by_id("close_button")[1]:buttons(
                gears.table.join(
                    awful.button(
                        {},
                        1,
                        nil,
                        function()
                            client.kill(client)
                        end
                    )
                )
            )

            data[client] = layout
        end

        local text, bg, bg_image, icon, item_args = label(client, layout.tb)
        item_args = item_args or {}

        if layout.tbm and (text == nil or text == "") then
            layout.tbm:set_margins(0)
        elseif layout.tb then
            if not layout.tb:set_markup_silently(text) then
                layout.tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end

        layout.bgb:set_bg(bg)
        layout.bgb:set_bgimage(bg_image)

        layout.bgb.shape = item_args.shape
        layout.bgb.border_width = item_args.shape_border_width
        layout.bgb.border_color = item_args.shape_border_color

        if client then
            layout.ib.client = client
        end

        w:add(layout.root)
    end
end

return function(screen, filter)
    local filter = filter or awful.widget.tasklist.filter.currenttags
    return awful.widget.tasklist {
        screen = screen,
        filter = filter,
        buttons = tasklist_buttons,
        update_function = list_update,
        layout = {
            layout = wibox.layout.flex.horizontal,
            max_widget_size = theme.tasklist_task_size or 150
        }
    }
end
