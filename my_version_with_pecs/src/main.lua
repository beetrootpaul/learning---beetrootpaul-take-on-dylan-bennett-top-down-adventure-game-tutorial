local gsm = game_state_machine()

function _init()
    gsm.init()
end

function _update()
    gsm.current_state().update(gsm)
end

function _draw()
    cls(u.colors.black)
    gsm.current_state().draw()
end

