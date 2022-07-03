sprites = {
    player = 1,
    grass_plain = 16,
    key_on_grass = 19,
    chest_closed = 20,
    chest_open = 21,
    spikes_exposed = 22,
    spikes_hidden = 23,
    door_closed = 51,
    door_open = 52,
    goal = 53,
}

sounds = {
    cannot_enter_cell_sfx = 0,
    key_obtained_sfx = 1,
    key_open_door_sfx = 2,
    spikes_toggle_sfx = 3,
}

-- button numbers to use comfortably in IDE instead of glyphs (emojis)
buttons = {
    -- left, right, up, down
    l = 0,
    r = 1,
    u = 2,
    d = 3,
    -- "O" (default: Z/C/N) and "X" (default: X/V/M)
    o = 4,
    x = 5,
}

glyphs = {
    button_x = "❎",
    star = "★",
    checker = "▒",
}

flags = {
    cannot_enter = 0,
    has_key = 1,
    is_deadly = 2,
}

tile_size_px = 8

viewport_size_tiles = 16

viewport_size_px = viewport_size_tiles * tile_size_px
viewport_center_x = viewport_size_px / 2
viewport_center_y = viewport_size_px / 2

text_height_px = 5

fps = 30

colors = {
    black = 0,
    white = 7,
    red = 8,
    orange = 9,
    grey = 13,
}

function measure_text_width(text)
    local y_to_print_outside_screen = -20
    return print(text, 0, y_to_print_outside_screen)
end