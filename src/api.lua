return function(game)
    local api = {}
    
    --_G.api = api
    
    -- creating new objects
    api.new = {}
    
    -- Config objects
    api.new.color = function(r, g, b, a)
        game.colors[#colors + 1] = {r/255, g/255, b/255, a/100}
    end
    
    -- Game objects
    api.new.collectible = function(data_or_name, texture, color, size, chance, inv_slot, value, mults)
        local c = data_or_name
        local d = game.default.collectible
        if type(c) == "string" then
            c = {
                name = c or d.name or "undefined,
                chance = chance or d.chance or 0,
                inv_slot = inv_slot or d.inv_slot or "undefined",
                value = value or d.value or 0,
                mults = mults or d.mults or {},
                texture = texture or d.texture,
                size = size or d.size or 0,
                color = color or d.color or "undefined"
            }
        end
        if type(c.color) == "string" then
            c.color = colors[c.color]
        end
        
        game.collectible.types.name[c.name] = c
        game.collectible.types.index[#game.collectible.types.index + 1] = c
    end
    
    -- UI objects
    api.new.button = function(id_data, sx, sy, ex, ey, txt, idle, tap, hold, act_i, act_t, act_h)
        local b = id_or_data
        if type(b) == "string" then
            b = {
                id = id,
                sx = sx,
                sy = sy,
                ex = ex,
                ey = ey,
                txt = txt, -- button text
                idle = idle, -- texture-idle
                tap = tap, -- texture-tap
                hold = hold, -- texture-hold
                act_i = act_i, -- add params for 3 acts, fix and cooldowns
                act_h = act_h,
                act_t = act_t,
                width = ex - sx,
                height = ey - sy,
                attributes = {}
            }
        end
        game.button.list[id or (#game.button.list + 1)] = b
    end
    api.new.menu = function(name, items, button_list, etc)
    --[[
    world,
    player,
    joystick,
    hud
    ]]
        game.menu.list[name] = {
            table.unpack(items),
            buttons = {}
        }
        for _, bnm in ipairs(button_list) do
            game.menu.list[name].buttons[bnm] = true
        end
    end
    
    -- Getting readable value
    api.get = {}
    -- const
    api.get.cell_size = function()
        return game.const.cell_size
    end
    
    -- screen
    api.get.screen.width = function()
        return game.screen.x
    end
    api.get.screen.height = function()
        return game.screen.y
    end
    api.get.screen.size = function()
        return game.screen.x, game.screen.y
    end
    
    --player
    api.get.player.x = function()
        return game.player.x
    end
    api.get.player.y = function()
        return game.player.y
    end
    api.get.player.coords = function()
        return game.player.x, game.player.y
    end
    
    -- inventory
    api.get.item_count = function(name)
        return game.player.inventory[name]
    end
    
    -- Updating an object
    api.set = {}
    api.set.menu = function(name)
        game.menu.current = game.menu.list[name] or game.menu.default
    end
    
    api.set.default = function(type, data)
        game.default[type] = data
    end
    -- Special APIs
    
    api.rgb = function(r, g, b, a)
        return {(r / 255) or 0, (g / 255) or 0, (b / 255) or 0, (a / 100) or 0}
    end
    
    
    return api
end