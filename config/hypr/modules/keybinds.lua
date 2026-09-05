local terminal = "kitty"
local fileManager = "dolphin"
local browser = "firefox"
local mainMod = "SUPER"

hl.bind(mainMod .. " + V",
    hl.dsp.exec_cmd("qs ipc call luci openClipboard"))

hl.bind(mainMod .. " + R",
    hl.dsp.exec_cmd("qs ipc call luci openAppLauncher"))

hl.bind(mainMod .. "+ B",
    hl.dsp.exec_cmd("qs ipc call luci openPowerMenu"))

hl.bind(mainMod .. "+ W",
    hl.dsp.exec_cmd("qs ipc call luci openWallpaperSelector"))

hl.bind(mainMod .. "+ SHIFT + T",
    hl.dsp.exec_cmd("qs ipc call luci openThemeSelector"))


hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("qs ipc call luci toggleBar"))

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
--hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/rofi/scripts/launcher.sh"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/rofi/scripts/menu.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/rofi/scripts/powermenu.sh"))

hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"))

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/rofi/scripts/clipboard/clipboard.sh"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = 1 }))

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.config/rofi/scripts/switch-panel.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/rofi/scripts/waybar-switch.sh"))

--hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/rofi/scripts/wallpaper.sh"))

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("qs ipc call overview toggle"))


hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("qs ipc call luci lock"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))

hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("bash ~/.config/rofi/scripts/screenshot.sh"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

for i = 1, 10 do
    local key = i % 10

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + Z", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
    mainMod .. " + SHIFT + equal",
    hl.dsp.exec_cmd("~/.config/quickshell/scripts/volume.sh up"),
    { locked = true, repeating = true }
)

hl.bind(
    mainMod .. " + SHIFT + minus",
    hl.dsp.exec_cmd("~/.config/quickshell/scripts/volume.sh down"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("~/.config/quickshell/scripts/volume.sh mute"),
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
