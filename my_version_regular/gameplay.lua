gameplay = {
    _over = false,
    _win = false,
}

function gameplay:win()
    self._over = true
    self._win = true
end

function gameplay:lose()
    self._over = true
    self._win = false
end

function gameplay:is_over()
    return self._over
end

function gameplay:has_win()
    return self._win
end

function gameplay:update()
    if gameplay:is_over() then
        if btnp(buttons.x) then
            extcmd("reset")
        end
    end
end

function gameplay:draw_end_screen()
    camera()

    local text_line_gap = 8

    if self:has_win() then
        local text = glyphs.star .. " you made it! " .. glyphs.star
        local text_width = measure_text_width(text)
        print(
            text,
            viewport_size_px / 2 - text_width / 2,
            viewport_size_px / 2 - text_height_px - text_line_gap / 2,
            colors.white
        )
    else
        local text = glyphs.checker .. " dead " .. glyphs.checker
        local text_width = measure_text_width(text)
        print(
            text,
            viewport_size_px / 2 - text_width / 2,
            viewport_size_px / 2 - text_height_px - text_line_gap / 2,
            colors.red
        )
    end

    local restart_prompt = "press " .. glyphs.button_x .. " to restart"
    local restart_prompt_width = measure_text_width(restart_prompt)
    print(
        restart_prompt,
        viewport_size_px / 2 - restart_prompt_width / 2,
        viewport_size_px / 2 + text_line_gap / 2,
        colors.grey
    )
end