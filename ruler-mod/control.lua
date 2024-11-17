local graphics_ttl = 5 * 60 --- 10 seconds, assuming 60 ticks per second
local graphics_color = { r = 1, g = 1 }

--- Ideas: ghost underground pipe
---        ghost wire
---        ghost underground belt
---        heat transfer thingy

local function digit_count(n)
  local count = 1
  while n >= 10 do
    count = count + 1
    n = n / 10
  end
  return count
end


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

  local width = right_bottom.x - left_top.x
  local height = right_bottom.y - left_top.y

  if height > 0.5 then
    rendering.draw_circle({
      surface = player.physical_surface,
      target = left_top,
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })
    rendering.draw_line({
      surface = player.physical_surface,
      from = left_top,
      to = { x = left_top.x, y = right_bottom.y },
      color = graphics_color,
      time_to_live = graphics_ttl,
      width = 0.5
    })
    rendering.draw_circle({
      surface = player.physical_surface,
      target = { x = left_top.x, y = right_bottom.y },
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })

    rendering.draw_text({
      text = {"", height },
      surface = player.physical_surface,
      target = { x = left_top.x - 0.3 * digit_count(height), y = (left_top.y + right_bottom.y) / 2 - 0.3 },
      color = graphics_color,
      time_to_live = graphics_ttl,
      draw_on_ground = false
    })
  end

  if width > 0.5 then
    rendering.draw_circle({
      surface = player.physical_surface,
      target = { x = left_top.x, y = right_bottom.y },
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })
    rendering.draw_line({
      surface = player.physical_surface,
      from = { x = left_top.x, y = right_bottom.y },
      to = right_bottom,
      color = graphics_color,
      time_to_live = graphics_ttl,
      width = 0.5
    })
    rendering.draw_circle({
      surface = player.physical_surface,
      target = right_bottom,
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })

    rendering.draw_text({
      text = {"", width },
      surface = player.physical_surface,
      target = { x = (left_top.x + right_bottom.x) / 2 - 0.2 * digit_count(width) / 2, y = right_bottom.y },
      color = graphics_color,
      time_to_live = graphics_ttl,
      draw_on_ground = false
    })
  end

  --- Diagonal case?
--   rendering.draw_line({
--     surface = player.physical_surface,
--     from = left_top,
--     to = right_bottom,
--     color = graphics_color,
--     time_to_live = graphics_ttl,
--     width = 0.5
--   })
--
--   rendering.draw_text({
--     text = {"", width, "x", height },
--     surface = player.physical_surface,
--     target = right_bottom,
--     color = graphics_color,
--     time_to_live = graphics_ttl,
--     draw_on_ground = false
--   })
end

script.on_event(defines.events.on_lua_shortcut, on_select_start)
script.on_event("ruler-get-selection-tool", on_select_start)
script.on_event(defines.events.on_player_selected_area, on_selected)