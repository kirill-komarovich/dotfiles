local term = require("wezterm")
local config = term.config_builder()

local FONT_SIZE = 16.0

config.window_decorations = "RESIZE"

config.font = term.font("DroidSansM Nerd Font Mono")
config.font_size = FONT_SIZE

config.color_scheme = "Seti"
local scheme = term.color.get_builtin_schemes()[config.color_scheme]

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_frame = {
  font_size = FONT_SIZE,
}

config.window_padding = {
  left = "0.5cell",
  right = 0,
  top = 0,
  bottom = 0,
}

config.command_palette_bg_color = scheme.background
config.command_palette_fg_color = scheme.foreground
config.command_palette_font_size = FONT_SIZE + 6

config.debug_key_events = true
config.leader = { key = 'SUPER' }
config.keys = {
  {
    key = "p",
    mods = "SUPER",
    action = term.action.ShowLauncherArgs({
      flags = "WORKSPACES",
    }),
  },
  {
    key = "-",
    mods = "SUPER",
    action = term.action.SplitPane({
      direction = "Down",
    }),
  },
  {
    key = "_",
    mods = "SUPER|SHIFT",
    action = term.action.SplitPane({
      direction = "Down",
      top_level = true,
    }),
  },
  {
    key = "\\",
    mods = "SUPER",
    action = term.action.SplitPane({
      direction = "Right",
    }),
  },
  {
    key = "|",
    mods = "SUPER|SHIFT",
    action = term.action.SplitPane({
      direction = "Right",
      top_level = true,
    }),
  },
}

return config
