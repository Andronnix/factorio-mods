local cab_calls = {}

local function log(message)
  game.print(message)
end

local function destroy_or_log_error(entity)
  local result = entity.destroy()
  if not result then
    log({"runtime.error-cant-destroy-signal"})
  end

  return result
end

local function on_cab_arrived(event)
  local cab_call = nil
  local train_id = event.train.id
  for cab_id, call in pairs(cab_calls) do
    if train_id == cab_id then
      cab_call = call
      break
    end
  end

  if not cab_call then
    return
  end

  local cab = event.train

  local current_station_is_temporary = cab.schedule.records[cab.schedule.current].temporary
  if cab.state == defines.train_state.wait_station and current_station_is_temporary then
    local player = game.get_player(cab_call.player_index)
    -- If player does not exist, maybe they left the game, and that's fine.
    if player then
      local wait_time = settings.global["get-a-cab-cab-wait-time"].value
      player.create_local_flying_text({ create_at_cursor = true, text = {"", "Cab is waiting for you for "..wait_time.." seconds."} })
    end

    -- If call sign is not attached, maybe it was not possible to build it. Let's hope that it is not dangling.
    if cab_call.sign then
      destroy_or_log_error(cab_call.sign)
      cab_call.sign.destroy()
    end
  end
end

local function release_trains()
  if next(cab_calls) == nil then
    return
  end

  local tm = game.train_manager
  local park_station = settings.global["get-a-cab-cab-station-name"].value
  local group = settings.global["get-a-cab-cab-group-name"].value

  local cabs_not_restored = {}
  for cab_id, cab_call in pairs(cab_calls) do
    local cab = tm.get_train_by_id(tonumber(cab_id))

    -- If cab is not found then we want to clean it up (maybe train was destroyed or something?)
    if cab then
      local station = cab.schedule.records[cab.schedule.current].station
      if next(cab.passengers) == nil and park_station == station and #cab.schedule.records == 1 and not cab.manual_mode then
        cab.group = group
      else
        cabs_not_restored[cab_id] = cab_call
      end
    else
      log({"runtime.warn-cab-missing", cab_id})
    end
  end

  cab_calls = cabs_not_restored
end

local function on_tick(e)
  release_trains()
end

local function on_cab_prep(e)
  local name = e.input_name or e.prototype_name
  if name ~= "get-a-cab-ghost-custom-input" then
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

  cursor_stack.set_stack({ name = "get-a-cab-chain-signal", count = 1 })
end

local function find_free_cab(surface, force, rail, player)
  local cabs_processed = 0
  local cabs_seen = false
  local group = settings.global["get-a-cab-cab-group-name"].value

  -- Try both directions becauise it's hard to understand which direction is the correct one.
  local front_end = rail.get_rail_end(defines.rail_direction.front)
  local back_end = rail.get_rail_end(defines.rail_direction.back)

  for _, cab in ipairs(game.train_manager.get_trains({ surface = surface, force = force })) do
    cabs_seen = true
    -- When the train is called via mod, the group is reset to empty, so if there is a group - then it's free.
    -- Interrupts though?
    local suitable_cab = (cab.group == group) and (next(cab.passengers) == nil)

    if suitable_cab then
      cabs_processed = cabs_processed + 1

      local result = game.train_manager.request_train_path({ train = cab, goals = { front_end, back_end } })
      if result.found_path then
        return cab
      end
    end
  end

  if not cabs_processed and cabs_seen then
    player.create_local_flying_text({ create_at_cursor = true, text = {"runtime.no-cabs-available"} })
    return
  end

  if not cabs_seen then
    player.create_local_flying_text({ create_at_cursor = true, text = {"runtime.warn-no-cabs-at-all"} })
    return
  end

  player.create_local_flying_text({ create_at_cursor = true, text = {"runtime.destination-unreachable"} })
  return
end

local function call_a_cab(call_signal, player)
  local _, rail = next(call_signal.get_connected_rails(), nil)
  if not rail then
    log({"runtime.error-cant-find-connected-rail"})
    destroy_or_log_error(call_signal)
    return
  end

  local cab = find_free_cab(player.physical_surface, force, rail, player)

  if not cab then
    -- We already shown error to the user
    destroy_or_log_error(call_signal)
    return
  end

  player.create_local_flying_text({ create_at_cursor = true, text = {"runtime.cab-on-its-way"} })

  local wait_time = settings.global["get-a-cab-cab-wait-time"].value * 60

  cab.schedule = {
    current = 1,
    records = {
      { rail = rail, temporary = true, wait_conditions = { { type = "time", ticks = wait_time } } },
      { station = settings.global["get-a-cab-cab-station-name"].value }
    }
  }

  local position = call_signal.position
  local direction = call_signal.direction
  cab_calls[cab.id] = { player_index = player.index, position = position }

  if destroy_or_log_error(call_signal) then
    player.cursor_stack.set_stack({ name = "cab-signal-sign", count = 1 })
    if player.can_build_from_cursor({position = position, direction = direction}) then
      player.build_from_cursor({position = position, direction = direction})
    else
      player.cursor_stack.clear()
    end
  end
end

local function on_cab_called(e)
  if e.entity.name ~= "get-a-cab-chain-signal" then
    return
  end

  local call_signal = e.entity

  local player = game.get_player(e.player_index)
  if not player then
    log({"runtime.error-no-player"})
    return
  end

  call_a_cab(call_signal, player)

  if call_signal.valid then
    destroy_or_log_error(call_signal)
  end
end

local function on_signal_sign_built(e)
  local entity_position = e.entity.position

  for cab_id, call in pairs(cab_calls) do
    if call.position.x == entity_position.x and call.position.y == entity_position.y then
      call.sign = e.entity
      return
    end
  end

  -- Something went wrong and this signal does not correspond to any cab call. Let's clean up this sign. 
  destroy_or_log_error(e.entity)
end

local function on_built_entity(e)
  if e.entity.name == "get-a-cab-chain-signal" then
    on_cab_called(e)
    return
  end

  if e.entity.name == "cab-signal-sign" then
    on_signal_sign_built(e)
    return
  end
end


--[[
  Plan:
  1. On shortcut add an special signal item to stack.

  2. When player places the signal (ghost, maybe?) find a connected rail.
  3. Find path for a designated train (or one of those which are not busy) to that rail.
  4.a If path exists, order a train and write a floating text message.
  4.b If path doesn't exist, write a floating text message.
  4.c If there are no trains available, write a floating text message.
  5. Wait for a train to arrive(?)
  6. Remove the signal
--]]

script.on_event("get-a-cab-ghost-custom-input", on_cab_prep)
script.on_event(defines.events.on_lua_shortcut, on_cab_prep)
script.on_event(defines.events.on_train_changed_state, on_cab_arrived)

script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_nth_tick(30, on_tick)
