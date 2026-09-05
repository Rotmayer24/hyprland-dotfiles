hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("qs -c ~/.config/quickshell & disown")
    hl.exec_cmd("awww-daemon")

    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    --hl.exec_cmd("sh -c 'waybar &'")
    hl.exec_cmd("sh -c 'wl-paste --type text --watch cliphist store &'")
    hl.exec_cmd("sh -c 'wl-paste --type image --watch cliphist store &'")

    hl.exec_cmd(
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )

    hl.exec_cmd("/usr/lib/xdg-desktop-portal -r -v")
end)
