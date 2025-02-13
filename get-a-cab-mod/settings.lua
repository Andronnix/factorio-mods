data:extend({
  {
    type = "string-setting",
    name = "get-a-cab-cab-station-name",
    setting_type = "runtime-global",
    default_value = "DEPOT",
    auto_trim = true
  },
  {
    type = "string-setting",
    name = "get-a-cab-cab-group-name",
    setting_type = "runtime-global",
    default_value = "CAB",
    auto_trim = true
  },
  {
    type = "int-setting",
    name = "get-a-cab-cab-wait-time",
    setting_type = "runtime-global",
    default_value = 5,
    minimum_value = 1,
    maximum_value = 30
  }
})