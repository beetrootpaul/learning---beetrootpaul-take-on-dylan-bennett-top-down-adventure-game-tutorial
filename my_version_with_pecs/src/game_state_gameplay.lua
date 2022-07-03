function game_state_gameplay()

    local camera_x = 0;
    local camera_y = 0;

    local pecs_world = pecs()

    local c_controls_camera = pecs_world.component()
    local c_map_position = pecs_world.component({ cell_x = 0, cell_y = 0 })
    local c_spikes = pecs_world.component({ toggle_length_s = 1 * u.fps, toggle_countdown = 1 * u.fps })
    local c_controlled_by_player = pecs_world.component({ desired_direction = u.movement_direction.none })
    local c_sprite = pecs_world.component({ sprite = 0 })
    local c_sfx = pecs_world.component({ sfxs_to_play = {} })
    local c_collect_keys = pecs_world.component({ keys = 0 })
    local c_inventory = pecs_world.component({ visible = false, keys_collector = nil })

    -- spikes
    for cell_x = 0, u.map.width_cells - 1 do
        for cell_y = 0, u.map.height_cells - 1 do
            if mget(cell_x, cell_y) == u.sprites.spikes_exposed or mget(cell_x, cell_y) == u.sprites.spikes_hidden then
                pecs_world.entity({},
                    c_spikes(),
                    c_map_position({ cell_x = cell_x, cell_y = cell_y }),
                    c_sfx())
            end
        end
    end

    -- main character
    local main_character = pecs_world.entity({},
        c_controlled_by_player(),
        c_controls_camera(),
        c_map_position({ cell_x = 3, cell_y = 2 }),
        c_sprite({ sprite = u.sprites.player }),
        c_sfx(),
        c_collect_keys())

    -- inventory
    pecs_world.entity({},
        c_inventory({ keys_collector = main_character }))

    local update_player_movement_plan = pecs_world.system({ c_controlled_by_player, c_map_position }, function(entity)
        if (btnp(u.buttons.l)) then
            entity[c_controlled_by_player].desired_direction = u.movement_direction.left
        end
        if (btnp(u.buttons.r)) then
            entity[c_controlled_by_player].desired_direction = u.movement_direction.right
        end
        if (btnp(u.buttons.u)) then
            entity[c_controlled_by_player].desired_direction = u.movement_direction.up
        end
        if (btnp(u.buttons.d)) then
            entity[c_controlled_by_player].desired_direction = u.movement_direction.down
        end
    end)

    local calculate_next_cell_xy = function(cell_x, cell_y, desired_direction)
        local next_cell_x = cell_x
        local next_cell_y = cell_y
        if desired_direction == u.movement_direction.left then
            next_cell_x = next_cell_x - 1
        end
        if desired_direction == u.movement_direction.right then
            next_cell_x = next_cell_x + 1
        end
        if desired_direction == u.movement_direction.up then
            next_cell_y = next_cell_y - 1
        end
        if desired_direction == u.movement_direction.down then
            next_cell_y = next_cell_y + 1
        end
        return next_cell_x, next_cell_y
    end

    local update_animate_spikes = pecs_world.system({ c_spikes, c_map_position }, function(entity)
        local cell_x = entity[c_map_position].cell_x
        local cell_y = entity[c_map_position].cell_y

        if cell_x * u.cell_size_px < camera_x then
            return
        end
        if cell_x * u.cell_size_px >= camera_x + u.viewport_size_px then
            return
        end
        if cell_y * u.cell_size_px < camera_y then
            return
        end
        if cell_y * u.cell_size_px >= camera_y + u.viewport_size_px then
            return
        end

        if entity[c_spikes].toggle_countdown > 0 then
            entity[c_spikes].toggle_countdown = entity[c_spikes].toggle_countdown - 1
            return
        end

        if mget(cell_x, cell_y) == u.sprites.spikes_exposed then
            mset(cell_x, cell_y, u.sprites.spikes_hidden)
        elseif mget(cell_x, cell_y) == u.sprites.spikes_hidden then
            mset(cell_x, cell_y, u.sprites.spikes_exposed)
        end
        if entity[c_sfx] then
            add(entity[c_sfx].sfxs_to_play, u.sfxs.spikes_toggle)
        end

        entity[c_spikes].toggle_countdown = entity[c_spikes].toggle_length_s
    end)

    local update_interact_with_doors = pecs_world.system({ c_controlled_by_player, c_map_position, c_collect_keys }, function(entity)
        local next_cell_x, next_cell_y = calculate_next_cell_xy(
            entity[c_map_position].cell_x,
            entity[c_map_position].cell_y,
            entity[c_controlled_by_player].desired_direction
        )

        if mget(next_cell_x, next_cell_y) == u.sprites.door_closed and entity[c_collect_keys].keys > 0 then
            mset(next_cell_x, next_cell_y, u.sprites.door_open)
            entity[c_collect_keys].keys = entity[c_collect_keys].keys - 1
            if entity[c_sfx] then
                add(entity[c_sfx].sfxs_to_play, u.sfxs.open_door)
            end
        end
    end)

    local update_interact_with_chests = pecs_world.system({ c_controlled_by_player, c_map_position, c_collect_keys }, function(entity)
        local next_cell_x, next_cell_y = calculate_next_cell_xy(
            entity[c_map_position].cell_x,
            entity[c_map_position].cell_y,
            entity[c_controlled_by_player].desired_direction
        )

        if mget(next_cell_x, next_cell_y) == u.sprites.chest_closed then
            entity[c_collect_keys].keys = entity[c_collect_keys].keys + 1
            mset(next_cell_x, next_cell_y, u.sprites.chest_open)
            if entity[c_sfx] then
                add(entity[c_sfx].sfxs_to_play, u.sfxs.key_obtained)
            end
        end
    end)

    local update_player_cannot_enter = pecs_world.system({ c_controlled_by_player, c_map_position }, function(entity)
        local next_cell_x, next_cell_y = calculate_next_cell_xy(
            entity[c_map_position].cell_x,
            entity[c_map_position].cell_y,
            entity[c_controlled_by_player].desired_direction
        )

        if fget(mget(next_cell_x, next_cell_y), u.flags.cannot_enter) then
            entity[c_controlled_by_player].desired_direction = u.movement_direction.none
            if entity[c_sfx] then
                add(entity[c_sfx].sfxs_to_play, u.sfxs.cannot_enter_cell)
            end
        end
    end)

    local update_player_movement_execution = pecs_world.system({ c_controlled_by_player, c_map_position }, function(entity)
        local next_cell_x, next_cell_y = calculate_next_cell_xy(
            entity[c_map_position].cell_x,
            entity[c_map_position].cell_y,
            entity[c_controlled_by_player].desired_direction
        )
        entity[c_controlled_by_player].desired_direction = u.movement_direction.none

        entity[c_map_position].cell_x = mid(0, next_cell_x, u.map.width_cells - 1)
        entity[c_map_position].cell_y = mid(0, next_cell_y, u.map.height_cells - 1)
    end)

    local update_interact_with_keys = pecs_world.system({ c_map_position, c_collect_keys }, function(entity)
        local sprite = mget(entity[c_map_position].cell_x, entity[c_map_position].cell_y)
        if sprite == u.sprites.key_on_grass then
            entity[c_collect_keys].keys = entity[c_collect_keys].keys + 1
            mset(entity[c_map_position].cell_x, entity[c_map_position].cell_y, u.sprites.grass_plain)
            if entity[c_sfx] then
                add(entity[c_sfx].sfxs_to_play, u.sfxs.key_obtained)
            end
        end
    end)

    -- NOTE: This code suggest there could be more than one entity with `c_controls_camera` component
    --       What then? Is it OK to have the last iterated entity decide on a camera position?
    local update_camera = pecs_world.system({ c_controls_camera, c_map_position }, function(entity)
        local viewport_size_cells = u.viewport_size_px / u.cell_size_px
        local camera_x_cell = flr(entity[c_map_position].cell_x / viewport_size_cells) * viewport_size_cells
        local camera_y_cell = flr(entity[c_map_position].cell_y / viewport_size_cells) * viewport_size_cells
        camera_x = camera_x_cell * u.cell_size_px
        camera_y = camera_y_cell * u.cell_size_px
    end)

    local update_handle_death = function(game_state_machine_instance)
        local is_dead = false

        local entities = pecs_world.query({ c_controlled_by_player, c_map_position })
        for _, entity in pairs(entities) do
            local sprite = mget(entity[c_map_position].cell_x, entity[c_map_position].cell_y)
            is_dead = is_dead or fget(sprite, u.flags.is_deadly)
        end

        if is_dead then
            game_state_machine_instance.enter_state_over({ is_win = false })
        end
    end

    local update_handle_win = pecs_world.system({ c_controlled_by_player, c_map_position }, function(entity, game_state_machine_instance)
        local sprite = mget(entity[c_map_position].cell_x, entity[c_map_position].cell_y)
        local is_win = sprite == u.sprites.goal
        if is_win and not game_state_machine_instance.is_state_over() then
            game_state_machine_instance.enter_state_over({ is_win = true })
        end
    end)

    local update_play_sfx = function()
        local sfx_to_play

        local sfx_entities = pecs_world.query({ c_sfx })
        for _, sfx_entity in pairs(sfx_entities) do
            for sfx in all(sfx_entity[c_sfx].sfxs_to_play) do
                if sfx_to_play ~= u.sfxs.key_obtained then
                    sfx_to_play = sfx
                end
            end
            sfx_entity[c_sfx].sfxs_to_play = {}
        end

        if sfx_to_play then
            sfx(sfx_to_play)
        end
    end

    local update_inventory_visibility = pecs_world.system({ c_inventory }, function(inventory_entity)
        inventory_entity[c_inventory].visible = btn(u.buttons.x)
    end)

    local draw_map = function()
        map(
            0, 0,
            0, 0,
            u.map.width_cells, u.map.height_cells
        )
    end

    local draw_positioned_sprites = pecs_world.system({ c_map_position, c_sprite }, function(entity)
        spr(
            entity[c_sprite].sprite,
            entity[c_map_position].cell_x * u.cell_size_px,
            entity[c_map_position].cell_y * u.cell_size_px
        )
    end)

    local draw_inventory = pecs_world.system({ c_inventory }, function(inventory_entity)
        if not inventory_entity[c_inventory].visible or
            not inventory_entity[c_inventory].keys_collector or
            not inventory_entity[c_inventory].keys_collector[c_collect_keys]
        then
            return
        end

        local text_line_1 = "inventory"
        local text_line_2 = "keys " .. inventory_entity[c_inventory].keys_collector[c_collect_keys].keys

        local text_line_1_width = u.measure_text_width(text_line_1)
        local text_line_2_width = u.measure_text_width(text_line_2)
        local text_width = max(text_line_1_width, text_line_2_width)

        local box_margin_w = 8
        local box_margin_h = 6
        local text_line_gap = 4

        rectfill(
            camera_x + u.viewport_size_px / 2 - text_width / 2 - box_margin_w,
            camera_y + u.viewport_size_px / 2 - u.text_height_px - text_line_gap / 2 - box_margin_h,
            camera_x + u.viewport_size_px / 2 + text_width / 2 + box_margin_w - 1,
            camera_y + u.viewport_size_px / 2 + u.text_height_px + text_line_gap / 2 + box_margin_h - 1,
            u.colors.black
        )
        print(
            text_line_1,
            camera_x + u.viewport_size_px / 2 - text_line_1_width / 2,
            camera_y + u.viewport_size_px / 2 - u.text_height_px - text_line_gap / 2,
            u.colors.white
        )
        print(
            text_line_2,
            camera_x + u.viewport_size_px / 2 - text_line_2_width / 2,
            camera_y + u.viewport_size_px / 2 + text_line_gap / 2,
            u.colors.orange
        )
    end)

    return {
        _type = "gameplay",

        update = function(game_state_machine_instance)
            update_player_movement_plan()
            update_animate_spikes()
            update_interact_with_doors()
            update_interact_with_chests()
            update_player_cannot_enter()
            update_player_movement_execution()
            update_camera()
            update_interact_with_keys()
            update_handle_death(game_state_machine_instance)
            update_handle_win(game_state_machine_instance)
            update_play_sfx()
            update_inventory_visibility()
        end,

        draw = function()
            camera(camera_x, camera_y)
            draw_map()
            draw_positioned_sprites()
            draw_inventory()
        end,
    }
end
