audio = {
    _next_sfx = nil
}

function audio:play_sfx(sfx)
    self._next_sfx = audio:more_important_of(self._next_sfx, sfx)
end

function audio:more_important_of(prev_sfx, next_sfx)
    if not prev_sfx then
        return next_sfx
    end
    if not next_sfx then
        return prev_sfx
    end
    if prev_sfx == sounds.key_obtained_sfx and next_sfx == sounds.cannot_enter_cell_sfx then
        return prev_sfx
    end
    if prev_sfx and next_sfx == sounds.spikes_toggle_sfx then
        return prev_sfx
    end
    return next_sfx
end

function audio:update()
    if self._next_sfx then
        sfx(self._next_sfx)
        self._next_sfx = nil
    end
end