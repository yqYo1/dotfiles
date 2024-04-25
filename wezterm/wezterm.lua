local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_background_opacity = 0.60
config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({
  {
    family = "HackGen Console NF",
    weight = "Regular",
    stretch = "Normal",
    style = "Normal",
  },
})
config.font_size = 12
config.adjust_window_size_when_changing_font_size = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
end

return config
