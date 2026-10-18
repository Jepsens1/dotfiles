local colors = require("custom.colors")
hl.config({
    general = {
        gaps_in  = 7,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border   = colors.accent,
            inactive_border = colors.border,
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding       = 10,
        rounding_power = 3,
        active_opacity   = 1.0,
        inactive_opacity = 0.98,
        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0xaa121212,
        },
        blur = {
            enabled   = true,
            size      = 10,
            passes    = 2,
            vibrancy  = 0.3,
	    vibrancy_darkness = 0.2
        },
    },
    animations = {
        enabled = true,
    },
})
