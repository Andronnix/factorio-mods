data:extend({
  {
    type = "custom-input",
    name = "ruler-get-selection-tool",
    key_sequence = "ALT+SHIFT+R",
    action = "lua",
  },
  {
    type = "shortcut",
    name = "ruler-get-selection-tool",
    localised_name = {"", "One ruler to rule them all"},
    order = "d[tools]-r[ruler-tool]",
    icon = "__ruler-mod__/graphics/shortcut-x32-black.png",
    disabled_icon = "__ruler-mod__/graphics/shortcut-x32-white.png",
    small_icon = "__ruler-mod__/graphics/shortcut-x24-black.png",
    disabled_small_icon = "__ruler-mod__/graphics/shortcut-x24-white.png",
    icon_size = 32,
    small_icon_size = 24,
    action = "lua",
    associated_control_input = "ruler-get-selection-tool",
  },
  {
    -- This is the selection tool itself: border and an icon
    type = "selection-tool",
    name = "ruler-selection-tool",
    order = "d[tools]-r[ruler-tool]",
    icons = {
      { icon = "__ruler-mod__/graphics/black-x64.png", icon_size = 64 },
      { icon = "__ruler-mod__/graphics/shortcut-x32-white.png", icon_size = 32, mipmap_count = 2 },
    },
    draw_label_for_cursor_render = false,
    always_include_tiles = true,
    select = {
      border_color = { r = 1, g = 1 },
      mode = { "blueprint" },
      cursor_box_type = "entity",
    },
    alt_select = {
      border_color = { r = 1, g = 0.5 },
      mode = { "blueprint" },
      cursor_box_type = "entity",
    },
    reverse_select = {
      border_color = { r = 1 },
      mode = { "blueprint" },
      cursor_box_type = "not-allowed",
    },
    alt_reverse_select = {
      border_color = { r = 1 },
      mode = { "blueprint" },
      cursor_box_type = "not-allowed",
    },
    stack_size = 1,
    flags = { "only-in-cursor", "not-stackable", "spawnable" },
    hidden = true,
  },
})
