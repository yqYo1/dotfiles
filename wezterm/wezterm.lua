local wezterm = require("wezterm")
wezterm.log_info(" ")
wezterm.log_info("init")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

--theme
config.color_scheme = "Tokyo Night"

--disable title bar
config.window_decorations = "RESIZE"

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

  -- https://github.com/wez/wezterm/issues/4992
  local gpus = wezterm.gui.enumerate_gpus()
  local frontEnd = "OpenGL"
  for _, gpu in pairs(gpus) do
    if gpu.name == "Intel(R) Iris(R) Xe Graphics" then
      wezterm.log_info(gpu.backend)
      wezterm.log_info(gpu.name)
      frontEnd = "WebGpu"
      break
    end
  end
  wezterm.log_info("front end = " .. frontEnd)
  config.front_end = frontEnd

  --font
  config.font = wezterm.font_with_fallback({
    {
      family = "HackGen Console NF",
      weight = "Regular",
      stretch = "Normal",
      style = "Normal",
    },
  })
else
  -- not Windows
  config.window_background_opacity = 0.70
end

config.audible_bell = "Disabled"
config.use_ime = true

config.animation_fps = 60

config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

return config
