hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,

        border_size = 0,

        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,

        active_opacity = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("bouncy", { type = "spring", mass = 1, stiffness = 120, dampening = 10 })
hl.curve("snappy", { type = "spring", mass = 0.8, stiffness = 180, dampening = 20 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "bouncy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, spring = "snappy", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "easeOutExpo", style = "popin 80%" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.2, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.5, spring = "snappy", style = "slide bottom" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.8, bezier = "easeOutExpo", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.1, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.4, spring = "easy", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.1, bezier = "overshot", style = "slide 30%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.1, bezier = "easeOutExpo", style = "slide 30%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.8, bezier = "overshot", style =
"slidevert bottom 40%" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

hl.config({
    input = {
        kb_layout = "us,ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:win_space_toggle",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})
