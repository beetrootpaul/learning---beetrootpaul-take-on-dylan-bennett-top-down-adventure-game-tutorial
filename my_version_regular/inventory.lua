inventory = {}

function inventory:draw()
    local text_line_1 = "inventory"
    local text_line_2 = "keys " .. player.keys

    local text_line_1_width = measure_text_width(text_line_1)
    local text_line_2_width = measure_text_width(text_line_2)
    local text_width = max(text_line_1_width, text_line_2_width)

    local box_margin_w = 8
    local box_margin_h = 6
    local text_line_gap = 4

    rectfill(
        viewport.x + viewport_size_px / 2 - text_width / 2 - box_margin_w,
        viewport.y + viewport_size_px / 2 - text_height_px - text_line_gap / 2 - box_margin_h,
        viewport.x + viewport_size_px / 2 + text_width / 2 + box_margin_w - 1,
        viewport.y + viewport_size_px / 2 + text_height_px + text_line_gap / 2 + box_margin_h - 1,
        colors.black
    )
    print(
        text_line_1,
        viewport.x + viewport_size_px / 2 - text_line_1_width / 2,
        viewport.y + viewport_size_px / 2 - text_height_px - text_line_gap / 2,
        colors.white
    )
    print(
        text_line_2,
        viewport.x + viewport_size_px / 2 - text_line_2_width / 2,
        viewport.y + viewport_size_px / 2 + text_line_gap / 2,
        colors.orange
    )
end