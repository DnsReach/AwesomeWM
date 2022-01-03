-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_themes_dir()
local rnotification = require("ruled.notification")
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main

local theme = {}

-- }}}

-- {{{ Styles
theme.font      = "Cascadia code 8"

-- {{{ Colors

theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#192933"
theme.bg_focus   = "#192933"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal

-- }}}

-- {{{ Borders

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_color_normal = "#3F3F3F"
theme.border_color_active = "#6F6F6F"
theme.border_color_marked = "#CC9393"

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
