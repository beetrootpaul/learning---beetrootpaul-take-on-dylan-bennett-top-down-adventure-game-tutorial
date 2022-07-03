function _init()
end

-- Decided for 60fps, because default 30fps `_update` made
-- the game flicker subtly on my screen.
function _update60()
    gameplay:update()
    if not gameplay:is_over() then
        viewport:update()
        level:update()
        player:update()
        audio:update()
    end
end

function _draw()
    cls(colors.black)
    if gameplay:is_over() then
        gameplay:draw_end_screen()
    else
        viewport:draw()
        level:draw()
        player:draw()
        if btn(buttons.x) then
            inventory:draw()
        end
    end
end
