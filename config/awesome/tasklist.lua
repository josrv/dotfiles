local theme = require("theme")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

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

            layout.bgb:buttons(awful.widget.common.create_buttons(buttons, client))

            layout.ib.client = client

            layout.tooltip = awful.tooltip {
                objects = {layout.root}
            }
            layout.root:connect_signal("mouse:enter", function()
                layout.tooltip.visible = true
            end)

            layout.root:connect_signal("mouse:leave", function()
                layout.tooltip.visible = false
            end)

            data[client] = layout
        end

        local text, bg, bg_image = label(client, layout.tb)

        if layout.tbm and (text == nil or text == "") then
            layout.tbm:set_margins(0)
        elseif layout.tb then
            if not layout.tb:set_markup_silently(text) then
                layout.tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end

        layout.bgb:set_bg(bg)
        layout.bgb:set_bgimage(bg_image)

        layout.tooltip.markup = text

        w:add(layout.root)
    end
end

return function(screen, filter)
    return awful.widget.tasklist {
        screen = screen,
        filter = filter or awful.widget.tasklist.filter.currenttags,
        update_function = list_update,
        layout = {
            layout = wibox.layout.flex.horizontal,
            max_widget_size = theme.tasklist_task_size or 150
        }
    }
end
