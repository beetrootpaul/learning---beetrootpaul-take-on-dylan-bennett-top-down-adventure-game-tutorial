local utils = {
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
    },
    cell_size_px = 8,
    colors = {
        black = 0,
        white = 7,
        red = 8,
        orange = 9,
        grey = 13,
        pink = 14,
    },
    flags = {
        cannot_enter = 0,
        is_deadly = 2,
    },
    fps = 30,
    glyphs = {
        button_x = "❎",
        checker = "▒",
        star = "★",
    },
    map = {
        width_cells = 32,
        height_cells = 16,
    },
    measure_text_width = function(text)
        local y_to_print_outside_screen = -20
        return print(text, 0, y_to_print_outside_screen)
    end,
    movement_direction = {
      none = 0,
      left = 1,
      right = 2,
      up = 3,
      down = 4,
    },
    sfxs = {
        cannot_enter_cell = 0,
        key_obtained = 1,
        open_door = 2,
        spikes_toggle = 3,
    },
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
    },
    text_height_px = 5,
    viewport_size_px = 128
}

u = utils


