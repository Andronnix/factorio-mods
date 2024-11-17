local ruler = require("ruler")

local graphics_ttl = 5 * 60 --- 10 seconds, assuming 60 ticks per second
local graphics_color = { r = 1, g = 1 }

--- Ideas: ghost underground pipe
---        ghost wire
---        ghost underground belt
---        heat transfer thingy

local function on_select_start(e)
  local name = e.input_name or e.prototype_name
  if name ~= "ruler-get-selection-tool" then
    return
  end

  local player = game.get_player(e.player_index)
  if not player then
    return
  end
  local cursor_stack = player.cursor_stack
  if not cursor_stack or not player.clear_cursor() then
    return
  end
  cursor_stack.set_stack({ name = "ruler-selection-tool", count = 1 })
end



local function on_selected(e)
  local player = game.get_player(e.player_index)
  if not player then
    return
  end

  if e.item ~= "ruler-selection-tool" then
    return
  end

  local left_top = {
    x = math.floor(e.area.left_top.x + 0.5),
    y = math.floor(e.area.left_top.y + 0.5)
  }
  local right_bottom = {
    x = math.floor(e.area.right_bottom.x + 0.5),
    y = math.floor(e.area.right_bottom.y + 0.5)
  }

  ruler.draw_ruler(left_top, right_bottom, player.physical_surface, graphics_color, graphics_ttl)
end

script.on_event(defines.events.on_lua_shortcut, on_select_start)
script.on_event("ruler-get-selection-tool", on_select_start)
script.on_event(defines.events.on_player_selected_area, on_selected)