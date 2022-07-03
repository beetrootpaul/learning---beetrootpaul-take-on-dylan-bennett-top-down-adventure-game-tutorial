viewport = {
    x = 0,
    y = 0,
}

function viewport:update()
    local tile_offset_x = flr(player.tile_x / viewport_size_tiles) * viewport_size_tiles
    local tile_offset_y = flr(player.tile_y / viewport_size_tiles) * viewport_size_tiles
    self.x = tile_offset_x * tile_size_px
    self.y = tile_offset_y * tile_size_px
end

function viewport:draw()
    camera(self.x, self.y)
end