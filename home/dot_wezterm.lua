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
    key = "=",
    mods = "SUPER",
    action = term.action.IncreaseFontSize
  },
  {
    key = "+",
    mods = "SUPER",
    action = term.action.DecreaseFontSize
  },
  {
    key = "0",
    mods = "SUPER",
    action = term.action.ResetFontSize
  },
  {
    key = "p",
    mods = "SUPER",
    action = term.action.ShowLauncherArgs({
      flags = "WORKSPACES",
    }),
  },
  {
    key = "t",
    mods = "CMD",
    action = term.action.SpawnTab("CurrentPaneDomain")
  },
  {
    key = "w",
    mods = "CMD",
    action = term.action.CloseCurrentTab({ confirm = false })
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
  {
    key = "LeftArrow",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Left"),
  },
  {
    key = "h",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Left"),
  },
  {
    key = "RightArrow",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Right"),
  },
  {
    key = "l",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Right"),
  },
  {
    key = "UpArrow",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Up"),
  },
  {
    key = "k",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Up"),
  },
  {
    key = "DownArrow",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Down"),
  },
  {
    key = "j",
    mods = "SUPER",
    action = term.action.ActivatePaneDirection("Down"),
  },
  {
    key = "x",
    mods = "SUPER",
    action = term.action.CloseCurrentPane({ confirm = false }),
  },
  {
    key = "H",
    mods = "SUPER",
    action = term.action.AdjustPaneSize({ "Left", 2 }),
  },
  {
    key = "J",
    mods = "SUPER",
    action = term.action.AdjustPaneSize({ "Down", 2 }),
  },
  {
    key = "K",
    mods = "SUPER",
    action = term.action.AdjustPaneSize({ "Up", 2 })
  },
  {
    key = "L",
    mods = "SUPER",
    action = term.action.AdjustPaneSize({ "Right", 2 }),
  },
}

term.on("gui-startup", function()
  local _tab, _pane, window = term.mux.spawn_window({})
  window:gui_window():maximize()
end)

return config
