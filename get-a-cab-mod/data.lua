local cab_signal = table.deepcopy(data.raw["rail-signal"]["rail-signal"])
cab_signal.name = "get-a-cab-chain-signal"
cab_signal.ground_picture_set = {
  structure = {
    layers = {
      util.sprite_load(
        "__get-a-cab-mod__/graphics/cab-signal",
        {
          priority = "high",
          frame_count = 1,
          direction_count = 16,
          scale = 0.5,
        }
      )
    }
  },
  structure_render_layer = "floor-mechanics",
  structure_align_to_animation_index = {
    --  X0Y0, X1Y0, X0Y1, X1Y1
    --  Left turn  | Straight/Multi |  Right turn
     0,  0,  0,  0,   0,  0,  0,  0,   0,  0,  0,  0, -- North
     1,  1,  1,  1,   1,  1,  1,  1,   1,  1,  1,  1,
     2,  2,  2,  2,   2,  2,  2,  2,   2,  2,  2,  2,
     3,  3,  3,  3,   3,  3,  3,  3,   3,  3,  3,  3,
     4,  4,  4,  4,   4,  4,  4,  4,   4,  4,  4,  4, -- East
     5,  5,  5,  5,   5,  5,  5,  5,   5,  5,  5,  5,
     6,  6,  6,  6,   6,  6,  6,  6,   6,  6,  6,  6,
     7,  7,  7,  7,   7,  7,  7,  7,   7,  7,  7,  7,
     8,  8,  8,  8,   8,  8,  8,  8,   8,  8,  8,  8, -- South
     9,  9,  9,  9,   9,  9,  9,  9,   9,  9,  9,  9,
    10, 10, 10, 10,  10, 10, 10, 10,  10, 10, 10, 10,
    11, 11, 11, 11,  11, 11, 11, 11,  11, 11, 11, 11,
    12, 12, 12, 12,  12, 12, 12, 12,  12, 12, 12, 12, -- West
    13, 13, 13, 13,  13, 13, 13, 13,  13, 13, 13, 13,
    14, 14, 14, 14,  14, 14, 14, 14,  14, 14, 14, 14,
    15, 15, 15, 15,  15, 15, 15, 15,  15, 15, 15, 15,
  },
  signal_color_to_structure_frame_index = {
    green  = 0,
    yellow = 0,
    red    = 2,
  },
  lights = {
    green  = { light = {intensity = 0.2, size = 4, color={r=0, g=1,   b=0 }}, shift = { 0, -0.5 }},
    yellow = { light = {intensity = 0.2, size = 4, color={r=1, g=0.5, b=0 }}, shift = { 0,  0   }},
    red    = { light = {intensity = 0.2, size = 4, color={r=1, g=0,   b=0 }}, shift = { 0,  0.5 }},
  },
}

cab_signal.elevated_picture_set = table.deepcopy(cab_signal.ground_picture_set)

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
    place_result = cab_signal.name,
    flags = { "only-in-cursor", "not-stackable" }
  },
  {
    type = "item",
    name = "cab-signal-sign",
    stack_size = 1,
    icon = data.raw["rail-chain-signal"]["rail-chain-signal"].icon,
    place_result = "cab-signal-sign",
    flags = { "only-in-cursor", "not-stackable" }
  },
  {
    type = "simple-entity",
    name = "cab-signal-sign",
    picture = util.sprite_load(
      "__get-a-cab-mod__/graphics/cab-signal",
      {
        priority = "high",
        frame_count = 1,
        direction_count = 16,
        scale = 0.5,
      }
    ),
    flags = {
      "placeable-off-grid",
      "not-repairable",
      "not-on-map",
      "not-deconstructable",
      "not-blueprintable",
      "hide-alt-info",
      "no-gap-fill-while-building",
      "no-automated-item-removal",
      "no-automated-item-insertion",
      "no-copy-paste",
      "not-selectable-in-game",
      "not-upgradable",
      "not-in-kill-statistics",
      "building-direction-16-way"
    }
  }
})
