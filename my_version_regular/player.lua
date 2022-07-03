player = {
    tile_x = 3,
    tile_y = 2,
    keys = 0,
}

function player:update()
    local new_tile_x = self.tile_x
    local new_tile_y = self.tile_y

    if (btnp(buttons.l)) then
        new_tile_x = new_tile_x - 1
    end
    if (btnp(buttons.r)) then
        new_tile_x = new_tile_x + 1
    end
    if (btnp(buttons.u)) then
        new_tile_y = new_tile_y - 1
    end
    if (btnp(buttons.d)) then
        new_tile_y = new_tile_y + 1
    end

    if level:is_goal(new_tile_x, new_tile_y) then
        gameplay:win()
    elseif level:is_deadly(new_tile_x, new_tile_y) then
        gameplay:lose()
    end

    if level:is_key(new_tile_x, new_tile_y) then
        self.keys = self.keys + 1
        level:remove_key(new_tile_x, new_tile_y)
        audio:play_sfx(sounds.key_obtained_sfx)
    end
    if level:is_closed_chest(new_tile_x, new_tile_y) then
        self.keys = self.keys + 1
        level:open_chest(new_tile_x, new_tile_y)
        audio:play_sfx(sounds.key_obtained_sfx)
    end
    if self.keys > 0 and level:is_closed_door(new_tile_x, new_tile_y) then
        self.keys = self.keys - 1
        level:open_door(new_tile_x, new_tile_y)
        audio:play_sfx(sounds.key_open_door_sfx)
    end

    if level:cannot_enter(new_tile_x, new_tile_y) then
        audio:play_sfx(sounds.cannot_enter_cell_sfx)
    else
        self.tile_x = mid(0, new_tile_x, level.width_tiles - 1)
        self.tile_y = mid(0, new_tile_y, level.height_tiles - 1)
    end

    function player:draw()
        spr(
            sprites.player,
            self.tile_x * tile_size_px,
            self.tile_y * tile_size_px
        )
    end

end
