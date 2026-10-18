hl.monitor({
    output   = "HDMI-A-2",
    mode     = "3840x2160@240",
    position = "0x0",
    scale    = "1.25",
})
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-2", default = true})
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-2"})
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-2"})
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-2"})
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-2"})
