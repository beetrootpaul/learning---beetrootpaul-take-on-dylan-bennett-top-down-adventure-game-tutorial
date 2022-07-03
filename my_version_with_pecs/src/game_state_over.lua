function game_state_over(args)
    local is_win = args.is_win

    function draw_end_screen()
        camera()

        local text_line_gap = 8

        if is_win then
                local text = u.glyphs.star .. " you made it! " .. u.glyphs.star
                local text_width = u.measure_text_width(text)
                print(
                    text,
                    u.viewport_size_px / 2 - text_width / 2,
                    u.viewport_size_px / 2 - u.text_height_px - text_line_gap / 2,
                    u.colors.white
                )
        else
            local text = u.glyphs.checker .. " dead " .. u.glyphs.checker
            local text_width = u.measure_text_width(text)
            print(
                text,
                u.viewport_size_px / 2 - text_width / 2,
                u.viewport_size_px / 2 - u.text_height_px - text_line_gap / 2,
                u.colors.red
            )
        end

        local restart_prompt = "press " .. u.glyphs.button_x .. " to restart"
        local restart_prompt_width = u.measure_text_width(restart_prompt)
        print(
            restart_prompt,
            u.viewport_size_px / 2 - restart_prompt_width / 2,
            u.viewport_size_px / 2 + text_line_gap / 2,
            u.colors.grey
        )
    end

    return {
        _type = "over",

        update = function(game_state_machine_instance)
            if btnp(u.buttons.x) then
                extcmd("reset")
            end
        end,

        draw = function()
            draw_end_screen()
        end,
    }
end
