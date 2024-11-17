local ruler = { }

local function digit_count(n)
  local count = 1
  while n >= 10 do
    count = count + 1
    n = n / 10
  end
  return count
end

function ruler.draw_ruler(left_top, right_bottom, surface, graphics_color, graphics_ttl)
  local width = right_bottom.x - left_top.x
  local height = right_bottom.y - left_top.y

  if height > 0.5 then
    rendering.draw_circle({
      surface = surface,
      target = left_top,
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })
    rendering.draw_line({
      surface = surface,
      from = left_top,
      to = { x = left_top.x, y = right_bottom.y },
      color = graphics_color,
      time_to_live = graphics_ttl,
      width = 0.5
    })
    rendering.draw_circle({
      surface = surface,
      target = { x = left_top.x, y = right_bottom.y },
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })

    rendering.draw_text({
      text = {"", height },
      surface = surface,
      target = { x = left_top.x - 0.3 * digit_count(height), y = (left_top.y + right_bottom.y) / 2 - 0.3 },
      color = graphics_color,
      time_to_live = graphics_ttl,
      draw_on_ground = false
    })
  end

  if width > 0.5 then
    rendering.draw_circle({
      surface = surface,
      target = { x = left_top.x, y = right_bottom.y },
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })
    rendering.draw_line({
      surface = surface,
      from = { x = left_top.x, y = right_bottom.y },
      to = right_bottom,
      color = graphics_color,
      time_to_live = graphics_ttl,
      width = 0.5
    })
    rendering.draw_circle({
      surface = surface,
      target = right_bottom,
      radius = 0.05,
      filled = true,
      color = graphics_color,
      time_to_live = graphics_ttl,
    })

    rendering.draw_text({
      text = {"", width },
      surface = surface,
      target = { x = (left_top.x + right_bottom.x) / 2 - 0.2 * digit_count(width) / 2, y = right_bottom.y },
      color = graphics_color,
      time_to_live = graphics_ttl,
      draw_on_ground = false
    })
  end
end

return ruler