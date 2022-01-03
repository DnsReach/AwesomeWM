------------------------------------------------------------------
-- ________                __________                      .__     
-- \______ \   ____   _____\______   \ ____ _____    ____ |  |__  
-- |    |  \ /    \ /  ___/|       _// __ \\__  \ _/ ___\|  |  \ 
-- |    `   \   |  \\___ \ |    |   \  ___/ / __ \\  \___|   Y  \
-- /_______  /___|  /____  >|____|_  /\___  >____  /\___  >___|  /
--         \/     \/     \/        \/     \/     \/     \/     \/
--
-----------------------------------------------------------------

pcall(require, "luarocks.loader")
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)


-- Themes define colours, icons, font and wallpapers.

beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

--beautiful.menubar_bg_normal="#FF1493"

--theme_walpaper= themes_path.. "/home/dnsreach/image/1084297.png"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty -e tmux -2"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

modkey = "Mod4"

-- {{{ Menu
-- Create a launcher widget and a main menu

myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { {
             "awesome", myawesomemenu, beautiful.awesome_icon 
          },
                           { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

local cpu = lain.widget.cpu {
settings = function()
      widget:set_markup( "   " .. cpu_now.usage .. "%  CPU  " )
   end
}

local mymem = lain.widget.mem {
       settings = function()
             widget:set_markup("  " .. mem_now.perc.. "% RAM  ")
          end
}

local volume  = lain.widget.alsa {
       settings = function()
             widget:set_markup("   " .. " " ..  volume_now.level  .. "%  ")
          end
}

local battery =  require("battery-widget") {
                  battery_prefix = "    ",
                ac = "     ",
                     ac_prefix = "   ",
}

local temp = lain.widget.temp({
    settings = function()
        widget:set_markup("    " .. coretemp_now .. "°C  ")
    end
})


menubar.utils.terminal = terminal -- Set the terminal for applications that require it

--------------------------------------------------------------

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local my_textclock = wibox.widget {
       format = '  %b %d  %H:%M   ',
       widget = wibox.widget.textclock
}

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

       --awful.layout.suit.floating,
       --awful.layout.suit.tile,
       --awful.layout.suit.tile.left,
       --awful.layout.suit.tile.bottom,
       --awful.layout.suit.tile.top,
       --awful.layout.suit.fair,
       --awful.layout.suit.fair.horizontal,   
       --awful.layout.suit.spiral,
       --lain.layout.termfair.nmaster
       --awful.layout.suit.spiral.dwindle,
       --awful.layout.suit.max,
       --awful.layout.suit.max.fullscreen,
       --awful.layout.suit.magnifier,
       --awful.layout.suit.corner.nw,
       --
      
awful.layout.set(lain.layout.termfair, tag)

local l = awful.layout.suit
local ter = lain.layout.termfair
local te = lain.layout.centerwork
local we = lain.layout.termfair.center
local layouts = { we , l.spiral , l.floating, ter , te }

screen.connect_signal("request::desktop_decoration", function(s)
   awful.tag({ "   ", " ", " ", " ", "    "}, s, layouts)  
   s.mypromptbox = awful.widget.prompt()
   s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons =  taglist_buttons,
}

s.mytasklist = awful.widget.tasklist {
     screen  = s ,
     filter  = awful.widget.tasklist.filter.focused
}

---------------------------------------------------------------

local colors = {  
 { --purple          
   "#AA84C8" , 
--blue
    "#6D97E5",
 }  ,
{
  "#AA84C8" , "#6D97E5",
  } 
}

local gg = wibox.container.background(my_textclock , colors[2][2] )
local colo = wibox.container.background( cpu , colors[1][2] )
local volume_color = wibox.container.background(volume , colors[2][2] )
local hex = wibox.container.background(battery , colors[1][1] )
local colo2 = wibox.container.background( mymem , colors[2][1] )
local temp_pc = wibox.container.background( temp , colors[2][1] )
local separators = lain.util.separators

arrl_ld = separators.arrow_left(colors[1][1] ,  colors[1][2])
arr = separators.arrow_left(colors[1][1], colors[1][1])
arr2 = separators.arrow_left(colors[2][1], colors[2][2])
arr3 = separators.arrow_left("alpha", colors[2][1] )

arrl_ld2 = separators.arrow_left(colors[1][2] ,  colors[1][1])
----------------------------------------------------------------

praisewidget = wibox.widget.textbox()
praisewidget.text = "You are great!"

s.mywibox = awful.wibar({ position = "top", screen = s  , height = 25  , visible=true})
    -- Add widgets to the wibox
    s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
           layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
         },
          s.mytasklist ,   -- Middle widget
         { -- Right widgets
             layout = wibox.layout.fixed.horizontal,            
             wibox.widget.systray(),
             arr3,
             temp_pc,
              arrl_ld,
             volume_color,
              arrl_ld2,
               hex,
               arrl_ld,
               gg,
          },
    }
end)
-- }}}

awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
          
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
  
   awful.key({ modkey,}, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
  
awful.key({ modkey }, "d", function() awful.util.spawn("dmenu_run -l 1 -nb '#272B36' -sf '#605D76' -sb  '#F285C1' -nf '#1A84D6'  -fn 'mononoki-12' -p ''") end,
              {description = "dmenu", group = "launcher"}), 
   
    awful.key({ modkey }, "u", function() awful.util.spawn("systemctl poweroff") end,
              {description = "shutdown", group = "launcher"}), 

    awful.key({ modkey }, "t", function() awful.util.spawn("systemctl reboot") end,
              {description = "reboot", group= "launcher"}),
        
    awful.key({ modkey }, "r", function() awful.util.spawn("firefox") end,
              {description = "firefox", group= "nav"}),
        })


-- Tags related keybindings

awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,}, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings

awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,}, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,}, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, }, "e",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Con:trol" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,   }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
   })
end)

-- }}}

ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer", "Firefox"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = false}
    }

 ruled.client.append_rule {
    rule_any    = { class = {'firefox'} },
     properties = { tag = screen[1].tags[3]}, 
  }
  

  ruled.client.append_rule {
    rule_any    = { class = {'Gimp'} },
     properties = { tag = screen[1].tags[5] ,
  tag.connect_signal("request::default_layouts", function()
        awful.layout.append_default_layouts({
              lain.layout.termfair.nmaster
           })
     end
     )
  }   
 }

 ruled.client.append_rule {
    rule_any    = { class = {'Thunar'} },
     properties = { tag = screen[1].tags[4] }
  }


end)

ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

awful.rules.rules = {
Rule = {},
properties = {
border_width = 4 , 
border_color = beautiful.border_normal,
focus = awful.client.focus.filter,
raise = true,
keys=clientkeys,
screen= awful.screen.preferred,
placement= awful.placement.no_overlap+awful.placement.no_offscreen
}}


awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("xcompmgr")
