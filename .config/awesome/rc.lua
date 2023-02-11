pcall(require, "luarocks.loader")

require("awful.autofocus")
local gears                = require("gears")
local awful                = require("awful")
local wibox                = require("wibox")
local beautiful            = require("beautiful")
local naughty              = require("naughty")
local menubar              = require("menubar")
local hotkeys_popup_widget = require("awful.hotkeys_popup.widget")
local popup_keys           = require("awful.hotkeys_popup.keys")

----------------------------------------------------------------------------

if awesome.startup_errors then
    naughty.notification({
        preset = naughty.config.presets.critical,
        title = "Errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notification({
            preset = naughty.config.presets.critical,
            title = "Error!",
            text = tostring(err)
        })
        in_error = false
    end)
end

----------------------------------------------------------------------------

beautiful.init("~/.config/awesome/themes/default.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

----------------------------------------------------------------------------

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

menubar.utils.terminal = terminal

----------------------------------------------------------------------------

local screen1 = "DP1"
-- local screen1 = "HDMI2"
local screen2 = "eDP1"
local screen3 = "HDMI1"

local all_screens = {}
for s in screen do
    for name, _ in pairs(s.outputs) do
        all_screens[name] = s
    end
end

if all_screens[screen1] == nil then
    naughty.notification({ title = screen1 .. " mapped to eDP1." })
    screen1 = "eDP1"
end

if all_screens[screen2] == nil then
    naughty.notification({ title = screen2 .. " mapped to eDP1." })
    screen2 = "eDP1"
end

if all_screens[screen3] == nil then
    naughty.notification({ title = screen3 .. " mapped to eDP1." })
    screen3 = "eDP1"
end

-- if all_screens["HDMI1"] == nil then
--     naughty.notification({ title = "HDMI1 mapped to eDP1." })
--     all_screens["HDMI1"] = all_screens["eDP1"]
-- end

-- if all_screens["HDMI2"] == nil then
--     naughty.notification({ title = "HDMI2 mapped to eDP1." })
--     all_screens["HDMI2"] = all_screens["eDP1"]
-- end

----------------------------------------------------------------------------

modkey          = "Mod4"
terminal        = "alacritty"
process_viewers = { "btop", "htop" }

browser        = os.getenv("BROWSER")    or "librewolf"
calculator     = os.getenv("CALCULATOR") or "speedcrunch"
editor         = os.getenv("EDITOR")     or terminal .. " --class=micro," .. terminal .. " -e micro"

menubar_options =
    -- Height of run prompt
    "-h " .. beautiful.menubar_height .. " " ..
    -- Font family and size
    "-fn \""  .. beautiful.font_family .. ":size=" .. beautiful.font_size .. "\" " ..
    -- Normal (non-selected) item theme
    "-nb \""  .. string.sub(beautiful.menubar_bg, 1, 7) .. "\" -nf \""  .. string.sub(beautiful.menubar_fg,                  1, 7) .. "\" " ..
    -- Selected item theme
    "-sb \""  .. string.sub(beautiful.bg_focus,   1, 7) .. "\" -sf \""  .. string.sub(beautiful.menubar_fg,                  1, 7) .. "\" " ..
    -- Normal (non-selected) item highlighted substring theme
    "-nhb \"" .. string.sub(beautiful.menubar_bg, 1, 7) .. "\" -nhf \"" .. string.sub(beautiful.menubar_highlight_normal_fg, 1, 7) .. "\" " ..
    -- Selected item highlighted substring theme
    "-shb \"" .. string.sub(beautiful.bg_focus,   1, 7) .. "\" -shf \"" .. string.sub(beautiful.menubar_highlight_sel_bg,    1, 7) .. "\" "

local function menubar_global_options(s)
    return "-z " .. tostring(s.geometry.width - ((beautiful.status_bar_factor / 1000) * s.geometry.width))
end

mouse_button = {
    left       = 1,
    middle     = 2,
    right      = 3,
    scrollup   = 4,
    scrolldown = 5
}

----------------------------------------------------------------------------

local function string_split(s, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(s, "([^" .. sep .. "]+)") do table.insert(t, str) end
    return t
end


local function cycle_layout(relative)
    awful.layout.inc(relative)
    s = awful.screen.focused()
    s.layout_widget:emit_signal("widget::redraw_needed")
end

local device_notif_preset = {
    font    = beautiful.font_family .. " 10",
    timeout = 5,
    margin  = 8,
}

local volume_notif        = { is_expired = true }
local backlight_notif     = { is_expired = true }
local kbd_backlight_notif = { is_expired = true }
local battery_notif       = { is_expired = true }
local touchpad_notif      = { is_expired = true }
local numlock_notif       = { is_expired = true }
local capslock_notif      = { is_expired = true }

local function notify_current_volume()
    awful.spawn.easy_async_with_shell(
        "wpctl get-volume @DEFAULT_AUDIO_SINK@",
        function(stdout)
            local volume = math.floor(stdout:sub(stdout:find("%d.%d+")) * 100)
            local muted  = stdout:find("%[MUTED%]") and stdout:sub(stdout:find("%[MUTED%]")) or ""
            local icon   = ""
            if muted ~= "" then icon = "" end
            local notif_text = icon .. "  Volume: " .. volume .. "% " .. muted

            if volume_notif.is_expired then
                volume_notif = naughty.notification({
                    preset = device_notif_preset,
                    title = notif_text,
                })
            else
                volume_notif.title = notif_text
                volume_notif:reset_timeout(5)
            end

        end
    )
end

local function notify_current_display_brightness()
    awful.spawn.easy_async_with_shell(
        "xbacklight -ctrl intel_backlight -get",
        function(stdout)
            local notif_text = "盛 Backlight: " .. stdout:sub(1, -2) .. "%"

            if backlight_notif.is_expired then
                backlight_notif = naughty.notification({
                    preset = device_notif_preset,
                    title = notif_text,
                })
            end
        end
    )
end

local function notify_current_keyboard_brightness()
    awful.spawn.easy_async_with_shell(
        "xbacklight -ctrl asus::kbd_backlight -get",
        function(stdout)
            local notif_text = "  Keyboard backlight: " .. stdout:sub(1, -2) .. "%"

            if kbd_backlight_notif.is_expired then
                kbd_backlight_notif = naughty.notification({
                    preset = device_notif_preset,
                    title = notif_text,
                })
            else
                kbd_backlight_notif.title = notif_text
                kbd_backlight_notif:reset_timeout(5)
            end
        end
    )
end

local function notify_current_touchpad_status(command)
    local notif_text = "  Touchpad " .. command .. "d"
    if touchpad_notif.is_expired then
        touchpad_notif = naughty.notification({
            preset = device_notif_preset,
            title = notif_text,
        })
    else
        touchpad_notif.title = notif_text
        touchpad_notif:reset_timeout(5)
    end
end

----------------------------------------------------------------------------

local hotkeys_popup = hotkeys_popup_widget.new({
    hide_without_description = true,
    merge_duplicates = true,
    labels = {
        Mod1    = "Alt",
        Mod4    = "Super",
        Control = "Ctrl",

        Escape    = "Esc",
        Insert    = "Ins",
        Delete    = "Del",
        Backspace = "BackSpc",
        Tab       = "Tab",
        space     = "Space",
        Return    = "Enter",
        Next      = "PgDn",
        Prior     = "PgUp",

        Left  = "←",
        Up    = "↑",
        Right = "→",
        Down  = "↓",

        XF86AudioRaiseVolume  = "",                 -- "Volume Up"
        XF86AudioLowerVolume  = "",                 -- "Volume Down"
        XF86AudioMute         = "Fn+F1 ",          -- "" "Audio Mute"
        XF86Calculator        = "Fn+Numpad Enter ", -- "Calculator"
        XF86DisplayOff        = "Fn+F6 ",           -- "Display Off"
        XF86KbdBrightnessDown = "Fn+↑ ",           -- "Keyboard Brightness Down"
        XF86KbdBrightnessUp   = "Fn+↓ ",           -- "Keyboard Brightness Up"
        XF86MonBrightnessDown = "Fn+F7 益",           -- "Display Brightness Down"
        XF86MonBrightnessUp   = "Fn+F8 盛",           -- "Display Brightness Up"
        XF86TouchpadToggle    = "Fn+F10 ",          -- "Touchpad Toggle"

        ['#10']  = "1",
        ['#11']  = "2",
        ['#12']  = "3",
        ['#13']  = "4",
        ['#14']  = "5",
        ['#15']  = "6",
        ['#16']  = "7",
        ['#17']  = "8",
        ['#18']  = "9",
        ['#19']  = "0",
        ['#20']  = "-",
        ['#21']  = "=",
        ['#67']  = "F1",
        ['#68']  = "F2",
        ['#69']  = "F3",
        ['#70']  = "F4",
        ['#71']  = "F5",
        ['#72']  = "F6",
        ['#73']  = "F7",
        ['#74']  = "F8",
        ['#75']  = "F9",
        ['#76']  = "F10",
        ['#95']  = "F11",
        ['#96']  = "F12",
        ['#108'] = "Alt Gr",
    }
})

----------------------------------------------------------------------------

main_menu = awful.menu({
    items = {
        {
            "Awesome",
            {
                { "Hotkeys",     function() hotkeys_popup:show_help(nil, awful.screen.focused()) end },
                { "Edit config", editor .. " " .. awesome.conffile },
                { "Restart",     awesome.restart },
                { "Quit",        awesome.quit    },
            },
        },
        {
            "Wallpaper",
            {
                { "Choose wallpaper", function () awful.spawn.with_shell("nitrogen --random \"" .. beautiful.wallpaper_directory .. "\"") end },
                { "Random wallpaper", function () awful.spawn.with_shell("nitrogen --set-tiled --random \"" .. beautiful.wallpaper_directory .. "\" --save") end },
            }
        },
        {
            "Restart OpenRGB",
            function() awful.spawn.with_shell("/bin/sh -c 'killall openrgb ; sleep 2s ; openrgb --startminimized'") end
        },
        {
            "Open terminal",
            terminal
        }
    }
})

----------------------------------------------------------------------------

local function make_taglist_widget(s, dir)
    local taglist_buttons = gears.table.join(
        awful.button({}, mouse_button.left, function(t) t:view_only() end),
        awful.button({ modkey }, mouse_button.left, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),

        awful.button({}, mouse_button.right, awful.tag.viewtoggle),
        awful.button({ modkey }, mouse_button.right, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),

        awful.button({}, mouse_button.scrollup, function(t) awful.tag.viewprev(t.screen) end),

        awful.button({}, mouse_button.scrolldown, function(t) awful.tag.viewnext(t.screen) end)
    )

    local font_size = (s.geometry.height == 2160) and beautiful.taglist_font_size * 1.5
                    or (s.geometry.height == 1920) and beautiful.taglist_font_size - 2
                    or beautiful.taglist_font_size - 1

    local taglist_name_margin = (s.geometry.height == 2160) and beautiful.taglist_name_margin * 2
                    or beautiful.taglist_name_margin

    local taglist_widget_template = {
        id     = "background_role",
        widget = wibox.container.background,
        {
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
            {
                layout = wibox.layout.align.horizontal,
                {
                    id     = "index_role",
                    widget = wibox.widget.textbox,
                    font   = beautiful.font_family .. " " .. (font_size * 0.4),
                    align  = "center",
                    valign = "center"
                },
                {
                    widget = wibox.container.margin,
                    left   = taglist_name_margin,
                    right  = taglist_name_margin,
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                        font   = beautiful.taglist_font .. " " .. font_size,
                        align  = "center",
                        valign = "center"
                    }
                }
            }
        },

        create_callback = function(self, tag, index, all_tags)
            self:get_children_by_id("index_role")[1].text = index

            self:connect_signal("mouse::enter", function()
                if self.bg ~= beautiful.taglist_hover_bg then
                    self.backup     = self.bg
                    self.has_backup = true
                end
                self.bg = beautiful.taglist_hover_bg
            end)

            self:connect_signal("button::press", function()
                if self.bg ~= beautiful.bg_focus then
                    self.backup = beautiful.bg_focus
                end
                self.bg = beautiful.bg_focus
            end)

            self:connect_signal("mouse::leave", function()
                if self.has_backup then
                    self.bg         = self.backup
                    self.has_backup = false
                end
            end)
        end
    }

    taglist_widget = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        buttons         = taglist_buttons,
        layout          = {
            layout = dir == "right" and wibox.layout.fixed.vertical or dir == "top" and wibox.layout.fixed.horizontal
        },
        widget_template = taglist_widget_template
    }
    return taglist_widget
end

----------------------------------------------------------------------------

local tasklist_buttons = gears.table.join(
    awful.button({}, mouse_button.left, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),

    awful.button({}, mouse_button.right, function()
        awful.menu.client_list(
            { theme = { width = 250 } }, nil,
            function(c, s)
                if c.type == "dock" then return false end
                return true
            end
        )
    end),
    awful.button({}, mouse_button.scrollup, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, mouse_button.scrolldown, function ()
        awful.client.focus.byidx(-1)
    end)
)

local function make_tasklist_widget(s)
    local tasklist_widget_template = {
        id     = "background_role",
        widget = wibox.container.background,
        {
            widget = wibox.container.margin,
            left   = 8,
            right  = 8,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    top    = 4,
                    bottom = 4,
                    right  = 8,
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    }
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
            }
        },
    }

    local tasklist_widget = awful.widget.tasklist {
        screen  = s,
        filter  = function(c, s)
            if c.type == "dock" then return false end
            return awful.widget.tasklist.filter.currenttags(c, s)
        end,
        buttons = tasklist_buttons,
        widget_template = tasklist_widget_template,
    }
    return tasklist_widget
end

----------------------------------------------------------------------------

-- local function make_sys_tray_widget()
--     local sys_tray = wibox.widget.systray()
--     sys_tray:set_base_size(beautiful.systray_base_size)
--     sys_tray:set_horizontal(false)

--     local sys_tray_widget = wibox.widget {
--         widget = wibox.container.background,
--         bg     = beautiful.bg_systray,
--         {
--             layout = wibox.container.place,
--             valign = "top",
--             halign = "center",
--             {
--                 widget = wibox.container.margin,
--                 bottom = beautiful.systray_icon_spacing + 8,
--                 {
--                     layout = wibox.layout.fixed.vertical,
--                     sys_tray
--                 }
--             }
--         }
--     }

--     return sys_tray_widget
-- end

----------------------------------------------------------------------------


local function make_sys_info_widget(s)
    local font_size = (s.geometry.height == 2160) and beautiful.font_size * 1.5
                    or (s.geometry.height == 1920) and beautiful.font_size - 1
                    or beautiful.font_size

    local package_updates = awful.widget.watch(--[[ "paru -Sy", 900,
        function(widget, sync_out)
            awful.spawn.easy_async_with_shell( ]]"paru -Qqu", 900,
                function(widget, paru_out)
                    local lines = string_split(paru_out, '\n')
                    widget.text = "  " .. #lines
                -- end
            -- )
        end,
        wibox.widget {
            widget = wibox.widget.textbox,
            text = "  --",
            font = beautiful.font_family .. " " .. font_size,
            align  = "center",
            valign = "center"
        }
    )

    -- local battery_level = awful.widget.watch("acpi -b", 60,
    local battery_level = awful.widget.watch("cat /sys/class/power_supply/BAT1/capacity", 60,
        function(widget, acpi_out)
            local level_icons = { "", "", "", "", "", "", "", "", "", "" }
            local level = string.sub(acpi_out, 1, -2)
            -- local level = string.sub(acpi_out:sub(acpi_out:find("%d+%%")), 1, -2)
            local icon_idx = math.ceil(level / 100 * #level_icons)
            widget:set_text(level_icons[icon_idx] .. " " .. level .. "%")

            if icon_idx == 1 then
                local warning = "LOW BATTERY: " .. level .. "% remaining"

                if battery_notif.is_expired then
                    battery_notif = naughty.notification({
                        preset = naughty.config.presets.critical,
                        title = warning,
                        margin = 8,
                    })
                else
                    battery_notif.title = warning
                end
            end
        end,
        wibox.widget {
            widget = wibox.widget.textbox,
            font = beautiful.font_family .. " " .. font_size,
            align  = "center",
            valign = "center"
        }
    )

    local text_clock_date = wibox.widget {
        widget  = wibox.widget.textclock,
        font = beautiful.font_family .. " " .. font_size,
        format  = "%d %b %Y",
        refresh = 1800,
        -- font    = beautiful.font_family .. " " .. (beautiful.font_size - 1),
        align   = "center",
        valign  = "center"
    }
    local text_clock_time = wibox.widget {
        widget  = wibox.widget.textclock,
        font = beautiful.font_family .. " " .. font_size,
        format  = "%R",
        refresh = 1,
        -- font    = beautiful.font_family .. " " .. (beautiful.font_size - 1),
        align   = "center",
        valign  = "center"
    }
    -- local keyboard_layout = wibox.widget {
        -- widget = awful.widget.keyboardlayout
        -- -- layout = wibox.layout.fixed.vertical
    -- }


    local sys_info_widget = wibox.widget {
        widget = wibox.container.margin,
        bottom = 8,
        {
            layout = wibox.layout.fixed.vertical,
            -- keyboard_layout,
            package_updates,
            battery_level,
            text_clock_date,
            text_clock_time
        }
    }

    return sys_info_widget
end

----------------------------------------------------------------------------

local function make_layout_widget(s)
    local font_size = (s.geometry.height == 2160) and beautiful.font_size * 1.5
                    or (s.geometry.height == 1920) and beautiful.font_size - 2
                    or beautiful.font_size - 1

    local margin = (s.geometry.height == 2160) and 24
                or (s.geometry.height == 1920) and 8
                or 12

    local layout_icon   = awful.widget.layoutbox(s)
    local layout_widget = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        {
            id     = "layout_name",
            widget = wibox.widget.textbox,
            text   = awful.layout.getname(awful.layout.get(s)),
            font   = beautiful.font_family .. " " .. font_size,
            align  = "center",
            valign = "center"
        },
        {
            widget = wibox.container.margin,
            top  = 0,      bottom = margin,
            left = margin, right  = margin,
            {
                layout = wibox.layout.fixed.vertical,
                layout_icon
            }
        }
    }

    layout_widget:buttons(gears.table.join(
        awful.button({}, mouse_button.left,  function () cycle_layout( 1) end),
        awful.button({}, mouse_button.right, function () cycle_layout(-1) end)
    ))

    layout_widget:connect_signal("widget::redraw_needed", function()
        layout_widget:get_children_by_id("layout_name")[1].text = awful.layout.getname(awful.layout.get(s))
    end)

    return layout_widget
end

----------------------------------------------------------------------------

local function set_wallpaper(s)
    if beautiful.wallpaper_directory then
        awful.spawn.with_shell("nitrogen --restore")
    else
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

----------------------------------------------------------------------------

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    local tag_names = { "", "爵", "", "", "", "" , "", "", "" }

    if s.geometry.height == 1920 then
        awful.tag(tag_names, s, awful.layout.layouts[3])
    else
        awful.tag(tag_names, s, awful.layout.layouts[1])
    end

    s.taglist         = make_taglist_widget(s, (s.geometry.height == 1920) and "top" or "right")
    s.tasklist        = make_tasklist_widget(s)
    s.sys_info_widget = make_sys_info_widget(s)
    s.layout_widget   = make_layout_widget(s)
    -- s.sys_tray_widget = make_sys_tray_widget()

    s.tasklist_bar = awful.wibar({
        screen   = s,
        position = "top",
        align    = "left",
        height   = (beautiful.status_bar_factor * s.geometry.height) / 2,
        width    = s.geometry.width - (beautiful.status_bar_factor),
       visible   = false,
    })
    s.tasklist_bar:setup {
        layout = wibox.layout.fixed.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
        },
        {
            layout = wibox.layout.flex.horizontal,
            s.tasklist,
        },
        {
            layout = wibox.layout.fixed.horizontal,
        },
    }

    local systray_height = (s.geometry.height == 2160) and 154 or 94
    local bar_pos        = (s.geometry.height == 1920) and "top" or "right"
    local bar_align      = (bar_pos == "top")          and "left" or "top"
    local bar_stretch    = (s ~= all_screens[screen1])

    local bar_width      = (bar_pos == "right") and (beautiful.status_bar_factor * s.geometry.width) or s.geometry.width
    local bar_height     = (s == all_screens[screen1]) and (s.geometry.height - systray_height)
                         or (bar_pos == "top") and (beautiful.status_bar_factor * s.geometry.height)
                         or s.geometry.height

    local bar_layout_align = (bar_pos == "top") and wibox.layout.align.horizontal or wibox.layout.align.vertical
    local bar_layout_fixed = (bar_pos == "top") and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical
    local bar_layout_flex  = (bar_pos == "top") and wibox.layout.flex.horizontal  or wibox.layout.flex.vertical

    -- naughty.notification({
    --     timeout = 0,
    --     title = s.name .. "\nscreen_dim " .. s.geometry.width .. "x" .. s.geometry.height .. "\npos " .. bar_pos .. "\nalign " .. bar_align .. "\nstretch " .. tostring(bar_stretch) .. "\ndim " .. bar_width .. "x" .. bar_height .. "\n"
    -- })

    s.status_bar = awful.wibar({
        screen   = s,
        position = bar_pos,
        align    = bar_align,
        stretch  = bar_stretch,
        width    = bar_width,
        height   = bar_height,
    })

    s.status_bar:setup {
        layout = bar_layout_align,
        -- Left widgets
        {
            layout = bar_layout_fixed,
            s.taglist,
        },

        -- Middle widget
        {
            layout = bar_layout_flex,
            -- s.tasklist,
        },

        -- Right widgets
        {
            layout = bar_layout_fixed,
            -- s.sys_tray_widget,
            s.sys_info_widget,
            s.layout_widget,
        },
    }

    if bar_pos == "right" then awful.placement.align(s.status_bar, { position = "top_right" }) end
end)

----------------------------------------------------------------------------

root.buttons(gears.table.join(
    awful.button({}, mouse_button.right, function () main_menu:toggle() end)
))

----------------------------------------------------------------------------

globalkeys = gears.table.join(
    -- Awesome general globals
    awful.key(
        { modkey, "Shift" }, "/", function () hotkeys_popup:show_help() end,
        { group = "awesome", description = "Show hotkeys" }
    ),
    awful.key(
        { modkey }, "Escape", function () main_menu:show() end,
        { group = "awesome", description = "Show main menu" }
    ),
    awful.key(
        { modkey, "Shift" }, "r", awesome.restart,
        { group = "awesome", description = "Restart awesome" }
    ),
    awful.key(
        { modkey, "Shift" }, "q", awesome.quit,
        { group = "awesome", description = "Quit awesome" }
    ),
    awful.key(
        { modkey, "Shift" }, "b", function()
            awful.screen.focused().tasklist_bar.visible = not awful.screen.focused().tasklist_bar.visible
            awful.placement.align(awful.screen.focused().status_bar, { position = "top_right" })
        end,
        { group = "awesome", description = "Show/hide tasklist bar" }
    ),

    -- Hardware keybinds (function keys)
    awful.key(
        {}, "XF86DisplayOff", function() awful.spawn("xset dpms force off") end,
        { group = "device", description = "Turn off screen" }
    ),
    awful.key(
        {}, "XF86KbdBrightnessUp", function()
            -- awful.spawn("asusctl -n")
            awful.spawn("xbacklight -inc 33 -ctrl asus::kbd_backlight")
            notify_current_keyboard_brightness()
        end,
        { group = "device", description = "Increase keyboard brightness" }
    ),
    awful.key(
        {}, "XF86KbdBrightnessDown", function()
            -- awful.spawn("asusctl -p")
            awful.spawn("xbacklight -dec 33 -ctrl asus::kbd_backlight")
            notify_current_keyboard_brightness()
        end,
        { group = "device", description = "Decrease keyboard brightness" }
    ),
    awful.key(
        {}, "XF86MonBrightnessUp", function()
            awful.spawn("xbacklight -ctrl intel_backlight -inc 5")
            notify_current_display_brightness()
        end,
        { group = "device", description = "Increase backlight brightness" }
    ),
    awful.key(
        {}, "XF86MonBrightnessDown", function()
            awful.spawn("xbacklight -ctrl intel_backlight -dec 5")
            notify_current_display_brightness()
        end,
        { group = "device", description = "Decrease backlight brightness" }
    ),
    awful.key(
        {}, "XF86AudioRaiseVolume", function()
            awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+")
            notify_current_volume()
        end,
        { group = "device", description = "Increase audio volume" }
    ),
    awful.key(
        {}, "XF86AudioLowerVolume", function()
            awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-")
            notify_current_volume()
        end,
        { group = "device", description = "Decrease audio volume" }
    ),
    awful.key(
        {}, "XF86AudioMute", function()
            awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
            notify_current_volume()
        end,
        { group = "device", description = "Mute audio toggle" }
    ),
    awful.key(
        {}, "XF86TouchpadToggle", function()
            awful.spawn.easy_async_with_shell(
                "xinput list | grep Touchpad | awk '{ print $3, $4 }' | xargs -I {} xinput list-props \"{} Touchpad\" | grep -ie \"Device Enabled\" | awk -F \"\t\" '{ print $3 }'",
                function(stdout)
                    local command = "disable"
                    if stdout == "0\n" then command = "enable" end

                    awful.spawn.with_shell("xinput list | grep Touchpad | awk '{ print $3, $4 }' | xargs -I {} xinput " .. command .. " \"{} Touchpad\"")
                    notify_current_touchpad_status(command)
                end
            )
        end,
        { group = "device", description = "Touchpad toggle" }
    ),

    awful.key(
        {}, "Caps_Lock", function()
            awful.spawn.easy_async_with_shell("sleep 0.1 ; xset q | grep \"Caps Lock\" | awk '{ print $4 }'",
            function(capslock_out)
                capslock_out = capslock_out:sub(1, -2)
                    local c = ""
                    if capslock_out == "on" then c = "" end

                    local notif_text = c .. "  Caps Lock " .. capslock_out
                    if capslock_notif.is_expired then
                        capslock_notif = naughty.notification({
                            preset = device_notif_preset,
                            title = notif_text,
                        })
                    else
                        capslock_notif.title = notif_text
                        capslock_notif:reset_timeout(5)
                    end
                end
            )
        end
        -- { group = "device", description = "Caps lock toggle (notification)" }
    ),
    awful.key(
        {}, "Num_Lock", function()
            awful.spawn.easy_async_with_shell("sleep 0.1 ; xset q | grep \"Num Lock\" | awk '{ print $8 }'",
                function(numlock_out)
                    numlock_out = numlock_out:sub(1, -2)
                    local n = ""
                    if numlock_out == "on" then n = "" end

                    local notif_text = n .. "  Num Lock " .. numlock_out
                    if numlock_notif.is_expired then
                        numlock_notif = naughty.notification({
                            preset = device_notif_preset,
                            title = notif_text,
                        })
                    else
                        numlock_notif.title = notif_text
                        numlock_notif:reset_timeout(5)
                    end
                end
            )
        end
        -- { group = "device", description = "Num lock toggle (notification)" }
    ),


    -- Tag manipulation
    awful.key(
        { modkey, "Control" }, "Up", awful.tag.viewprev,
        { group = "tag", description = "View previous tag" }
    ),
    awful.key(
        { modkey, "Control" }, "Down", awful.tag.viewnext,
        { group = "tag", description = "View next tag" }
    ),
    awful.key(
        { modkey, "Mod1" }, "Up", awful.tag.history.restore,
        { group = "tag", description = "Go to last tag" }
    ),

    -- Screen manipulation
    awful.key(
        { modkey, "Control" }, "Left", function () awful.screen.focus_bydirection("left") end,
        { group = "screen", description = "Focus previous screen" }
    ),
    awful.key(
        { modkey, "Control" }, "Right", function () awful.screen.focus_bydirection("right") end,
        { group = "screen", description = "Focus next screen" }
    ),
    awful.key(
        { modkey, "Control" }, "space", function () awful.screen.focus(all_screens[screen1]) end,
        { group = "screen", description = "Focus main screen" }
    ),

    -- Client manipulation
    awful.key(
        { modkey }, "Left", function () awful.client.focus.byidx(-1) end,
        { group = "client", description = "Cycle focus to previous client" }
    ),
    awful.key(
        { modkey }, "Right", function () awful.client.focus.byidx(1) end,
        { group = "client", description = "Cycle focus to next client" }
    ),
    awful.key(
        { modkey, "Shift" }, "Left", function () awful.client.swap.byidx(-1) end,
        { group = "client", description = "Swap with previous client by index" }
    ),
    awful.key(
        { modkey, "Shift" }, "Right", function () awful.client.swap.byidx(1) end,
        { group = "client", description = "Swap with next client by index" }
    ),
    awful.key(
        { modkey,  }, "u", awful.client.urgent.jumpto,
        { group = "client", description = "Jump to urgent client" }
    ),
    awful.key(
        { modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end,
        { group = "client", description = "Jump to previous client" }
    ),
    awful.key(
        { modkey }, "Up",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then c:emit_signal(
                "request::activate",
                "key.unminimize",
                { raise = true }
            )
            end
        end,
        { group = "client", description = "Restore minimized client" }
    ),

    -- Launchers
    awful.key(
        { modkey, "Control" }, "Return", function()
            awful.spawn.with_shell("dmenu_run -p 'Run:' " .. menubar_options .. menubar_global_options(awful.screen.focused()))
        end,
        { group = "launchers", description = "Open run prompt (dmenu)" }
    ),
    awful.key(
        { modkey }, "Return", function () awful.spawn(terminal) end,
        { group = "launchers", description = "Open terminal (" .. terminal .. ")" }
    ),
    awful.key(
        { modkey, "Control", "Shift" }, "Escape", function()
            local opts = ""
            for i, v in ipairs(process_viewers) do
                opts = opts .. v .. "\n"
            end

            awful.spawn.easy_async_with_shell(
                "echo -n \"" .. opts .. "\"" .. " | dmenu -p 'Process viewer:' -l 1 -g " .. #process_viewers .. " " .. menubar_options .. menubar_global_options(awful.screen.focused()),
                function(stdout)
                    p = string.sub(stdout, 1, -2)
                    awful.spawn.with_shell(terminal .. " --class=" .. p .. "," .. terminal .. " -e " .. p)
                end
            )
        end,
        { group = "launchers", description = "Open process viewer picker" }
    ),
    awful.key(
        { modkey, "Control" }, "Escape", function()
            awful.spawn.with_shell(terminal .. " --class=" .. process_viewers[1] .. "," .. terminal .. " -e " .. process_viewers[1])
        end,
        { group = "launchers", description = "Open default process viewer (" .. process_viewers[1] .. ")" }
    ),
    awful.key(
        { modkey, "Control" }, "s", function()
            awful.spawn.easy_async_with_shell(
                "date +%Y%m%d_%H%M%S",
                function(date)
                    awful.spawn.easy_async_with_shell(
                        "slop -q -t 0 -l -b 3 -c 0.4,0.3,0.5,0.4",
                        function(size, err)
                            if err ~= "" or size == "" or date == "" then
                                naughty.notification({
                                    preset = device_notif_preset,
                                    title = "Screenshot cancelled"
                                })
                                return
                            end
                            awful.spawn.with_shell("menyoki capture -r --size " .. size:sub(1, -2) .. " png save \"-\" > ~/desktop/" .. date:sub(1, -2) .. "_Screenshot.png | xclip -selection clipboard -t image/png")
                            naughty.notification({
                                preset = device_notif_preset,
                                title = "Screenshot saved at ~/desktop/" .. date:sub(1, -2) .. "_Screenshot.png"
                            })
                        end
                    )
                end
            )
        end,
        { group = "launchers", description = "Open screenshot tool (menyoki)" }
    ),
    awful.key(
        { modkey, "Control" }, "b", function() awful.spawn(browser) end,
        { group = "launchers", description = "Open web browser (" .. browser .. ")" }
    ),
    awful.key(
        { modkey, "Control" }, "e", function() awful.spawn(editor) end,
        { group = "launchers", description = "Open editor (" .. editor .. ")" }
    ),
    awful.key(
        {}, "XF86Calculator", function() awful.spawn(calculator) end,
        { group = "launchers", description = "Open calculator (" .. calculator .. ")" }
    ),

    -- Layout manipulation
    awful.key(
        { modkey }, "[", function () awful.tag.incmwfact(-0.05) end,
        { group = "layout", description = "Decrease master width" }
    ),
    awful.key(
        { modkey }, "]", function () awful.tag.incmwfact(0.05) end,
        { group = "layout", description = "Increase master width" }
    ),
    awful.key(
        { modkey, "Shift" }, "[", function () awful.tag.incnmaster(1, nil, true) end,
        { group = "layout", description = "Increase the number of master clients" }
    ),
    awful.key(
        { modkey, "Shift" }, "]", function () awful.tag.incnmaster(-1, nil, true) end,
        { group = "layout", description = "Decrease the number of master clients" }
    ),
    awful.key(
        { modkey }, "=", function () awful.tag.incncol(1, nil, true) end,
        { group = "layout", description = "Increase the number of stack columns" }
    ),
    awful.key(
        { modkey }, "-", function () awful.tag.incncol(-1, nil, true) end,
        { group = "layout", description = "Decrease the number of stack columns" }
    ),
    awful.key(
        { modkey }, "period", function () cycle_layout(1) end,
        { group = "layout", description = "Cycle to next layout" }
    ),
    awful.key(
        { modkey }, "comma", function () cycle_layout(-1) end,
        { group = "layout", description = "Cycle to previous layout" }
    )
)

client_keys = gears.table.join(
    awful.key(
        { modkey }, "q", function (c) c:kill() end,
        { group = "client", description = "Close client" }
    ),
    awful.key(
        { modkey, "Shift" }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { group = "client", description = "Toggle fullscreen client" }
    ),
    awful.key(
        { modkey }, "f",  awful.client.floating.toggle,
        { group = "client", description = "Toggle floating client" }
    ),
    awful.key(
        { modkey }, "t", function (c) c.ontop = not c.ontop end,
        { group = "client", description = "Toggle keep on top on current client" }
    ),
    awful.key(
        { modkey }, "v",
        function (c)
            local cid = c.window
            local clip_cmd = "clipmenu -p 'Clipboard:' -F -pc " .. menubar_options

            awful.spawn.with_shell(
                "CM_OUTPUT_CLIP=1 " .. clip_cmd .. " -w " .. cid .. " | "
                .. "xdotool type --delay 0 --clearmodifiers --window " .. cid .. " --file -"
            )
        end,
        { group = "client", description = "Paste from clipboard history in window" }
    ),

    awful.key(
        { modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end,
        { group = "client", description = "Move to master in stack" }
    ),

    awful.key(
        { modkey }, "Down",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { group = "client", description = "Minimize client" }
    ),
    awful.key({ modkey, "Shift" }, "Up",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { group = "client", description = "(Un)maximize" }
    ),

    awful.key(
        { modkey, "Control", "Shift" }, "Left", function (c)
            local s = awful.screen.focused():get_next_in_direction("left")
            if s == nil then s = all_screens[screen3] end
            c:move_to_screen(s)
        end,
        { group = "client", description = "Move to screen on the left" }
    ),
    awful.key(
        { modkey, "Control", "Shift" }, "Right", function (c)
            local s = awful.screen.focused():get_next_in_direction("right")
            if s == nil then s = all_screens["eDP1"] end
            c:move_to_screen(s)
        end,
        { group = "client", description = "Move to screen on the right" }
    )
)

for i = 1, 9 do
    local tag_name = awful.screen.focused().tags[i].name
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key(
            { modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then tag:view_only() end
            end,
            { group = "tag", description = "Swtich to tag " .. tag_name }
        ),

        -- Toggle tag display.
        awful.key(
            { modkey, "Shift" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then awful.tag.viewtoggle(tag) end
            end,
            { group = "tag", description = "Toggle tag " .. tag_name .. " visibility" }
        ),

        -- Move client to tag.
        awful.key(
            { modkey, "Control" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            { group = "tag", description = "Move focused client to tag " .. tag_name }
        ),

        -- Toggle tag on focused client.
        awful.key(
            { modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end,
            { group = "tag", description = "Toggle showing focused client on tag " .. tag_name }
        )
    )
end

client_buttons = gears.table.join(
    awful.button({}, mouse_button.left, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, mouse_button.left, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, mouse_button.right, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)

----------------------------------------------------------------------------

local function center_on_screen(c)
    -- c:connect_signal("property::position", function()
    --     c.x = (c.screen.geometry.width  * 0.5) - (c.width  * 0.5)
    --     c.y = (c.screen.geometry.height * 0.5) - (c.height * 0.5)
    -- end)
    -- c:connect_signal("property::size", function()
    --     c.x = (c.screen.geometry.width  * 0.5) - (c.width  * 0.5)
    --     c.y = (c.screen.geometry.height * 0.5) - (c.height * 0.5)
    -- end)

    if c.type == "normal" then
        c.width  = c.screen.geometry.width  * 0.85
        c.height = c.screen.geometry.height * 0.9
    end
    c.x = c.screen.geometry.x + (c.screen.geometry.width  * 0.5) - (c.width  * 0.5)
    c.y = c.screen.geometry.y + (c.screen.geometry.height * 0.5) - (c.height * 0.5)
end

local function scrcpy_position(c)
    c.width  = 520
    c.height = c.screen.geometry.height - (beautiful.useless_gap * 2) - (beautiful.border_width * 4)
    c.x      = c.screen.geometry.x + c.screen.geometry.width - c.width - beautiful.status_bar_factor - (beautiful.useless_gap * 2) - (beautiful.border_width * 2)
    c.y      = c.screen.geometry.y + beautiful.useless_gap + beautiful.border_width
end

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_color      = beautiful.border_normal,
            border_width      = beautiful.border_width,
            buttons           = client_buttons,
            focus             = awful.client.focus.filter,
            keys              = client_keys,
            placement         = awful.placement.no_overlap + awful.placement.no_offscreen,
            raise             = true,
            screen            = awful.screen.preferred,
            titlebars_enabled = false
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",    -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
                "Picture in picture",
                "Steam - News"
            },
            role = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true
        }
    },
    {
        rule_any = {
            instance = {
                "btop",
                "htop"
            },
            class = {
                "Arandr",
                "Blueberry.py",
                "Blueman-manager",
                "Gprename",
                "Hdajackretask",
                "KeePassXC",
                "Nitrogen",
                "Nm-connection-editor",
                "Pavucontrol",
                "openrgb",
                "Keyboard Center",
            }
        },
        properties = {
            screen   = all_screens[screen1],
            floating = true,
            raise    = true,
            focus    = true,
            callback = center_on_screen
        }
    },
    {
        rule = {
            instance = "scrcpy",
            class    = "scrcpy"
        },
        properties = {
            floating = true,
            raise    = true,
            focus    = true,
            callback = scrcpy_position
        }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any   = {
            type = { "dialog" }
        },
        properties = {
            -- screen            = all_screens[screen1],
            screen            = awful.screen.focused(),
            titlebars_enabled = true,
            callback          = center_on_screen
        }
    },
    {
        rule_any   = {
            type = { "dock" }
        },
        properties = {
            focusable    = false,
            skip_taskbar = true,
            tag          = nil,
            border_width = 0
        }
    },

    {
        rule = {
            instance = "speedcrunch",
            class    = "SpeedCrunch"
        },
        properties = {
            focus    = true,
            callback = function(c) awful.client.setslave(c) end
        }
    },

    {
        rule_any = {
            instance = {
                "vscodium",
                "unityhub"
            },
            class = {
                "VSCodium",
                "unityhub"
            }
        },
        properties = {
            tag         = all_screens[screen1].tags[1],
            switchtotag = true,
            focus       = true,
        }
    },
    {
        rule_any = {
            instance = {
                "Navigator",
                "brave-browser"
            },
            class = {
                "librewolf",
                "firefox"
            }
        },
        properties = {
            tag         = all_screens[screen3].tags[2],
            switchtotag = true,
            focus       = true,
        }
    },
    {
        rule = {
            instance = "mailspring",
            class    = "Mailspring",
        },
        properties = {
            tag         = all_screens[screen2].tags[3],
            switchtotag = true,
            focus       = true,
        }
    },
    {
        rule = {
            instance = "obsidian",
            class    = "obsidian",
        },
        properties = {
            tag         = all_screens[screen3].tags[4],
            switchtotag = true,
            focus       = true,
        }
    },
    {
        rule_any = {
            instance = {
                "discord",
                "ripcord",
            },
            class = {
                "discord",
                "Ripcord",
            }
        },
        properties = {
            tag         = all_screens[screen3].tags[6],
            switchtotag = false,
            focus       = false,
        }
    },
    {
        rule_any = {
            instance = {
                "fl.exe",
                "fl64.exe",
            },
            class = {
                "fl.exe",
                "fl64.exe",
            }
        },
        properties = {
            tag               = all_screens[screen1].tags[7],
            switchtotag       = true,
            focus             = true,
            floating          = true,
            titlebars_enabled = false,
            callback          = function(c)
                c.width  = c.screen.geometry.width  * 0.9
                c.height = c.screen.geometry.height * 0.9
                c.x = (c.screen.geometry.width  * 0.5) - (c.width  * 0.5)
                c.y = (c.screen.geometry.height * 0.5) - (c.height * 0.5)
            end
        }
    },
    {
        rule_any = {
            instance = {
                "pcsx2-qt",
            },
            class = {
                "pcsx2-qt",
            }
        },
        properties = {
            tag         = all_screens[screen2].tags[8],
            switchtotag = true,
            focus       = true,
        }
    },
    {
        rule_any = {
            instance = {
                "Steam"
            },
            class = {
                "Steam"
            }
        },
        properties = {
            tag               = all_screens[screen1].tags[8],
            switchtotag       = true,
            focus             = true,
            titlebars_enabled = false,
            border_width      = 0,
            size_hints_honor  = false
        }
    },
    {
        rule = {
            instance = "virt-manager",
            class    = "Virt-manager",
        },
        properties = {
            tag         = awful.screen.focused().tags[9],
            switchtotag = true,
            focus       = true,
        }
    }
}

popup_keys.tmux.add_rules_for_terminal(
    {
        rule = { name = "tmux" }
    }
)

----------------------------------------------------------------------------

client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if      awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
        awful.placement.centered(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, mouse_button.left, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, mouse_button.right, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        layout = wibox.layout.align.horizontal,
        -- Left
        {
            layout  = wibox.layout.fixed.horizontal,
            buttons = buttons,
            {
                -- Title
                layout  = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    margins = 3,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        awful.titlebar.widget.iconwidget(c)
                    }
                },
                {
                    widget = wibox.container.margin,
                    left = 3,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        awful.titlebar.widget.titlewidget(c)
                    }
                }
            }
        },
        -- Middle
        {
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
        -- Right
            layout = wibox.layout.fixed.horizontal(),
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c)
        }
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
