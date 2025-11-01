-- ─────────────────────────────────────────────────────────────────
--
--
--  ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
--  ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
--  ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
--  ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
--  ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--   ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
--
--
-- ─────────────────────────────────────────────────────────────────
--
-- Config author : Wakana Shimamura
-- Configs repo  : https://github.com/wakanashimamura/bspwm_dotfiles
-- File          : wezterm.lua
-- Compatible    : wezterm 20240203-110809-5046fc22
-- Description   : Configuration settings for wezterm
--
-- ─────────────────────────────────────────────────────────────────

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │                           GENERAL SETTINGS                           │
-- └──────────────────────────────────────────────────────────────────────┘

local wezterm = require 'wezterm'
local config  = wezterm.config_builder()

config.default_prog = { '/usr/bin/fish' }

config.alternate_buffer_wheel_scroll_speed = 1
config.scrollback_lines                    = 3500

config.animation_fps = 120
config.max_fps       = 120

config.front_end  = "OpenGL"
config.prefer_egl = true

copy_on_select = true

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │                              APPEARANCE                              │
-- └──────────────────────────────────────────────────────────────────────┘

config.color_scheme = 'Catppuccin Mocha (Gogh)'

config.default_cursor_style = 'SteadyBar'

config.font      = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.font_size = 16

config.use_fancy_tab_bar            = false
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
  tab_bar = {
    background = '#181825',

    active_tab = {
      bg_color = '#282740',
      fg_color = '#cdd6f4',
    },

    inactive_tab = {
      bg_color = '#181825',
      fg_color = '#cdd6f4',
    },

    inactive_tab_hover = {
      bg_color = '#45475a',
      fg_color = '#cdd6f4',
    },

    new_tab = {
      bg_color = '#181825',
      fg_color = '#b4befe',
    },
    
    new_tab_hover = {
      bg_color = '#45475a',
      fg_color = '#b4befe',
    },
  },
}

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │                              KEY BINDING                             │
-- └──────────────────────────────────────────────────────────────────────┘

config.disable_default_key_bindings = true
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = {
 
  { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true }, },
  { key = 'u', mods = 'LEADER', action = wezterm.action.SpawnTab 'DefaultDomain'            },

  { key = 'a', mods = 'LEADER|CTRL', action = wezterm.action.SplitHorizontal  { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'LEADER|CTRL', action = wezterm.action.SplitVertical    { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'LEADER|CTRL', action = wezterm.action.CloseCurrentPane { confirm = true },              },
  
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left',  },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right', },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up',    },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down',  },

  { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left'  },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up'    },
  { key = 'DownArrow',  mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down'  },

  { key = 'h', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Left',  5 }, },
  { key = 'j', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Down',  5 }, },
  { key = 'k', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Up',    5 }, },
  { key = 'l', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Right', 5 }, },

  { key = 'C', mods = 'CTRL', action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection', },
  { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard'                  },

  { key = '-', mods = 'LEADER', action = wezterm.action.DecreaseFontSize },
  { key = '=', mods = 'LEADER', action = wezterm.action.IncreaseFontSize },
  { key = '0', mods = 'LEADER', action = wezterm.action.ResetFontSize    },
    
  { key = '{', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  { key = '}', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1)  },

  { key = 'k', mods = 'LEADER|ALT', action = wezterm.action.ScrollByLine(-1) },
  { key = 'j', mods = 'LEADER|ALT', action = wezterm.action.ScrollByLine(1)  },

  { key = 'PageUp',   mods = 'LEADER', action = wezterm.action.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'LEADER', action = wezterm.action.ScrollByPage(1)  },
} 

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
