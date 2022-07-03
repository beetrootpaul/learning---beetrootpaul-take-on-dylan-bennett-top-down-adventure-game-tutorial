level = {
    width_tiles = 32,
    height_tiles = 16,
    _spikes_toggle_length_s = 2 * fps,
    _spikes_toggle_countdown = 2 * fps,
}

function level:update()
    if self._spikes_toggle_countdown <= 0 then
        local are_any_spikes_visible = false
        for tile_x = viewport.x / tile_size_px, viewport.x / tile_size_px + viewport_size_tiles - 1 do
            for tile_y = viewport.y / tile_size_px, viewport.y / tile_size_px + viewport_size_tiles - 1 do
                if mget(tile_x, tile_y) == sprites.spikes_exposed then
                    mset(tile_x, tile_y, sprites.spikes_hidden)
                    are_any_spikes_visible = true
                elseif mget(tile_x, tile_y) == sprites.spikes_hidden then
                    mset(tile_x, tile_y, sprites.spikes_exposed)
                    are_any_spikes_visible = true
                end
            end
        end
        self._spikes_toggle_countdown = self._spikes_toggle_length_s
        if are_any_spikes_visible then
            audio:play_sfx(sounds.spikes_toggle_sfx)
        end
    else
        self._spikes_toggle_countdown = self._spikes_toggle_countdown - 1
    end
end

function level:draw()
    map(0, 0, 0, 0, self.width_tiles, self.height_tiles)
end

function level:cannot_enter(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return fget(sprite, flags.cannot_enter)
end

function level:is_key(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return sprite == sprites.key_on_grass
end

function level:is_closed_chest(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return sprite == sprites.chest_closed
end

function level:is_closed_door(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return sprite == sprites.door_closed
end

function level:is_goal(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return sprite == sprites.goal
end

function level:is_deadly(tile_x, tile_y)
    local sprite = mget(tile_x, tile_y)
    return fget(sprite, flags.is_deadly)
end

function level:remove_key(tile_x, tile_y)
    assert(mget(tile_x, tile_y) == sprites.key_on_grass)
    mset(tile_x, tile_y, sprites.grass_plain)
end

function level:open_chest(tile_x, tile_y)
    assert(mget(tile_x, tile_y) == sprites.chest_closed)
    mset(tile_x, tile_y, sprites.chest_open)
end

function level:open_door(tile_x, tile_y)
    assert(mget(tile_x, tile_y) == sprites.door_closed)
    mset(tile_x, tile_y, sprites.door_open)
end