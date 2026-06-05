---------------
---- INPUT ----
---------------
hl.config({
  input = {
    kb_layout    = "dk",
    follow_mouse = 1,
    repeat_rate  = 40,
    repeat_delay = 250,
    sensitivity  = 0,

    touchpad     = {
      natural_scroll = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})
