local cab_signal = table.deepcopy(data.raw["rail-signal"]["rail-signal"])
cab_signal.name = "get-a-cab-chain-signal"

data:extend({
  cab_signal,
  {
    type = "custom-input",
    name = "get-a-cab-ghost-custom-input",
    key_sequence = "CONTROL + SHIFT + O",
    action = "lua",
    item_to_spawn = cab_signal.name
  },
  {
    type = "shortcut",
    name = "get-a-cab-ghost-custom-input",
    localised_name = {"mod-setting-name.shortcut-name"},
    order = "d[tools]-r[get-a-cab]",

    icon = "__get-a-cab-mod__/graphics/shortcut-x32-black.png",
    disabled_icon = "__get-a-cab-mod__/graphics/shortcut-x32-white.png",
    small_icon = "__get-a-cab-mod__/graphics/shortcut-x24-black.png",
    disabled_small_icon = "__get-a-cab-mod__/graphics/shortcut-x24-white.png",

    icon_size = 32,
    small_icon_size = 24,
    action = "lua",
    associated_control_input = "get-a-cab-ghost-custom-input",
  },
  {
    type = "item",
    name = cab_signal.name,
    stack_size = 1,
    icon = data.raw["rail-chain-signal"]["rail-chain-signal"].icon,
    place_result = cab_signal.name
  }
})
