function game_state_machine()
    local _current_state = nil

    return {
        init = function()
            _current_state = game_state_gameplay()
        end,
        current_state = function()
            return _current_state
        end,
        enter_state_over = function(args)
            _current_state = game_state_over({ is_win = args.is_win })
        end,
        is_state_over = function()
            return _current_state._type == "over"
        end,
    }
end