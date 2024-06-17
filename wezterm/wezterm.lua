local wezterm = require("wezterm")

local hostname = wezterm.hostname()
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

config.launch_menu = {}

--os
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
  table.insert(config.launch_menu, {
    label = "pwsh",
    args = { "pwsh.exe", "-NoLogo" },
  })
  local DevShellarg = nil
  if hostname == "FMV-LAPTOP-i7-1165G7" then
    DevShellarg = "edf27e67"
  elseif hostname == "DESKTOP-7900X3D" then
    DevShellarg = "d9da56ea"
  else
    wezterm.log_info("hostname " .. hostname .. " is not registered")
  end

  for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
    local year = vsvers:gsub("Microsoft Visual Studio/", "")
    table.insert(config.launch_menu, {
      label = "x64 Native Tools VS " .. year,
      args = {
        "cmd.exe",
        "/k",
        "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
      },
    })
    table.insert(config.launch_menu, {
      label = "Developer PWSH VS " .. year,
      args = {
        "pwsh.exe",
        "-NoLogo",
        "-NoExit",
        "-Command",
        '&{Import-Module "C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell '
          .. DevShellarg
          .. ' -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',
      },
    })
  end

  config.window_background_opacity = 0.75

  -- https://github.com/wez/wezterm/issues/4992
  local gpus = wezterm.gui.enumerate_gpus()
  local frontEnd = "OpenGL"
  for _, gpu in pairs(gpus) do
    if gpu.name == "Intel(R) Iris(R) Xe Graphics" and gpu.backend == "Vulkan" then
      --wezterm.log_info(gpu.backend)
      --wezterm.log_info(gpu.name)
      frontEnd = "WebGpu"
      config.bold_brightens_ansi_colors = "BrightOnly"
      break
    end
  end
  --wezterm.log_info("front end = " .. frontEnd)
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
