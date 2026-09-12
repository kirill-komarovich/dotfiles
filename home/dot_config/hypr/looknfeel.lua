hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 1,
  },
  decoration = {
    rounding = 10,
    rounding_power = 4,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
    },
  },
})

-- Global blur reaches windows only; layer surfaces like the bar need opting in.
hl.layer_rule({ match = { namespace = "omarchy-bar" }, blur = true })
