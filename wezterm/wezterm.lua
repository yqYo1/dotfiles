local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

--theme
config.color_scheme = "Tokyo Night"

--disable title bar
config.window_decorations = "RESIZE"

--font
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
config.anti_alias_custom_block_glyphs = true
--config.bold_brightens_ansi_colors = "BrightOnly"
--config.bold_brightens_ansi_colors = "No"

--os
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
  config.window_background_opacity = 0.2
  config.win32_system_backdrop = "Acrylic"

  --todo: front_end set WebGpu only when using Intel Iris Xe Graphics
  --config.front_end = "WebGpu"
  config.front_end = "OpenGL"
else
  config.window_background_opacity = 0.70
end

config.audible_bell = "Disabled"
config.use_ime = true

config.animation_fps = 60

config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

return config
