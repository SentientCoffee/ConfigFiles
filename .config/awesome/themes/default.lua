local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local gears        = require("gears")
local gfs          = require("gears.filesystem")

local dpi          = xresources.apply_dpi
local themes_path  = gfs.get_themes_dir()

----------------------------------------------------------------------------

local theme = {}

local global_font_size = 9

theme.font_family   = "Scada"
theme.font_size     = dpi(global_font_size)
theme.font          = theme.font_family .. " " .. theme.font_size

theme.bg_normal     = "#2b2b2b"
theme.fg_normal     = "#b4b4b4"

theme.bg_focus      = "#7e57c2"
theme.fg_focus      = "#d4d4d4"

theme.bg_urgent     = "#e69933"
theme.fg_urgent     = "#eeeeee"

theme.bg_minimize   = "#4a4a4a"
theme.fg_minimize   = "#757575"

theme.bg_systray    = theme.bg_normal

theme.border_normal = "#4a4a4a"
theme.border_focus  = "#7e57c2"
theme.border_marked = "#91231c"

theme.useless_gap   = dpi(1.5)
theme.border_width  = dpi(3)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

----------------------------------------------------------------------------

theme.status_bar_factor = 32 / 1000

----------------------------------------------------------------------------

theme.taglist_font_family = "FiraCode Nerd Font Propo"
theme.taglist_font_size   = dpi(global_font_size + 9)
theme.taglist_font        = theme.taglist_font_family .. " " .. theme.taglist_font_size

theme.taglist_hover_bg    = "#ffffff3c"
theme.taglist_bg_urgent   = "#e69933cc"

theme.taglist_name_margin = dpi(10)
theme.taglist_spacing     = dpi(2)


-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

----------------------------------------------------------------------------

theme.systray_base_size    = dpi(20)
theme.systray_icon_spacing = dpi(3)

----------------------------------------------------------------------------

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

theme.notification_icon_size = dpi(48)

----------------------------------------------------------------------------

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height       = dpi(20)
theme.menu_width        = dpi(175)

----------------------------------------------------------------------------

local menubar_font_size = 9
local menubar_height    = 28

theme.menubar_font_family         = "FiraCode Nerd Font Propo"
theme.menubar_font_size           = dpi(menubar_font_size)
theme.menubar_font                = theme.menubar_font_family .. " " .. theme.menubar_font_size

theme.menubar_bg                  = theme.bg_normal
theme.menubar_fg                  = theme.fg_normal
theme.menubar_highlight_normal_fg = "#e69933"
theme.menubar_highlight_sel_bg    = "#e6cc4d"

theme.menubar_height = dpi(menubar_height)

----------------------------------------------------------------------------

local hotkey_font_size = 14

theme.hotkeys_font_family      = "FiraCode Nerd Font Propo"
theme.hotkeys_font_size        = dpi(hotkey_font_size)
theme.hotkeys_font             = theme.hotkeys_font_family .. " " .. theme.hotkeys_font_size

theme.hotkeys_description_font_family = "Scada"
theme.hotkeys_description_font_size   = dpi(hotkey_font_size)
theme.hotkeys_description_font        = theme.hotkeys_description_font_family .. " " .. theme.hotkeys_description_font_size

theme.hotkeys_bg               = "#1a1a1a"
theme.hotkeys_fg               = "#b4b4b4"
theme.hotkeys_border_color     = "#757575"
theme.hotkeys_modifiers_fg     = "#757575"
theme.hotkeys_label_fg         = "#2a2a2a"

theme.hotkeys_border_width     = dpi(2)
theme.hotkeys_group_margin     = dpi(8)

----------------------------------------------------------------------------

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "default/titlebar/maximized_focus_active.png"

----------------------------------------------------------------------------

-- theme.wallpaper = themes_path .. "default/background.png"
theme.wallpaper_directory = "~/.local/share/wallpapers/desktop"

----------------------------------------------------------------------------

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv      = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating   = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max        = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile       = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop    = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path .. "default/layouts/cornersew.png"

----------------------------------------------------------------------------

theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

----------------------------------------------------------------------------

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
