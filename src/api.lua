return function(game)
    local api = {}
    
    --_G.api = api
    
    -- creating new objects
    api.new = {}
    
    -- Config objects
    api.new.color = function(r, g, b, a)
        game.colors[#colors + 1] = {(r or 0) /255, (g or 0) /255, (b or 0) /255, (a or 100) /100}
    end
    
    -- Game objects
    api.new.collectible = function(data_or_name, texture, color, size, chance, inv_slot, value, mults)
        --[[local c = data_or_name
        local d = game.default.collectible
        if type(c) == "string" then
            c = {
                name = c or d.name or "undefined",
                chance = chance or d.chance or 0,
                inv_slot = inv_slot or d.inv_slot or "undefined",
                value = value or d.value or 0,
                mults = mults or d.mults or {},
                texture = texture or d.texture,
                size = size or d.size or 0,
                color = color or d.color or "undefined"
            }
        end]]
        
        local c = type(data_or_name) == "table"
            and data_or_name
            or {name = data_or_name}
        
        local d = game.default.collectible
        
        for k, v in pairs(d) do
            if c[k] == nil then
                c[k] = v
            end
        end
        
        c.name = c.name or "undefined"
        c.chance = c.chance or 0
        c.inv_slot = c.inv_slot or "undefined"
        c.value = c.value or 0
        c.mults = c.mults or {}
        c.size = c.size or 0
        c.color = c.color or colors.undefined
        
        if type(c.color) == "string" then
            c.color = colors[c.color]
        end
        
        game.collectible.types.name[c.name] = c
        game.collectible.types.index[#game.collectible.types.index + 1] = c
    end
    
    -- UI objects
    api.new.button = function(id_or_data, x, y, width, height, txt, idle, tap, hold, act_i, act_t, act_h)
        local b = id_or_data
        if type(b) == "string" then
            b = {
                id = id_or_data,
                x = x,
                y = y,
                width = width,
                height = height,
                txt = txt, -- button text
                idle = idle, -- texture-idle
                tap = tap, -- texture-tap
                hold = hold, -- texture-hold
                act_i = act_i, -- add params for 3 acts, fix and cooldowns
                act_h = act_h,
                act_t = act_t,
                attributes = {}
            }
        end
        b.id = b.id or b.name
        b.name = b.name or b.id
        game.button.list[b.id or (#game.button.list + 1)] = b
    end
    
    api.new.menu = function(name, items, button_list)
    --[[
    world,
    player,
    joystick,
    hud
    ]]
        game.menu.list[name] = {
            buttons = {}
        }
        for _, item in ipairs(items) do
            game.menu.list[name][item] = true
        end
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
    
    api.get.f3 = function()
        return game.const.f3
    end
    -- screen
    api.get.screen = {}
    api.get.screen.width = function()
        return game.screen.pa.w
    end
    api.get.screen.height = function()
        return game.screen.pa.h
    end
    api.get.screen.size = function()
        return game.screen.pa.w, game.screen.pa.h
    end
    
    --player
    api.get.player = {}
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
    
    api.set.f3 = function(bool)
        game.const.f3 = bool
    end
    
    api.set.inv_order = function(list)
        game.player.inv_order = list
    end
    
    api.set.coll = {}
    api.set.coll.spawn_rate = function(num)
        game.collectible.spawn_rate = num or 0
    end
    api.set.coll.rolls = function(num)
        game.collectible.rolls = num or 1
    end
    api.set.coll.max = function(num)
        game.collectible.max = num or 30
    end
    -- Special APIs
    
    api.rgb = function(r, g, b, a)
        return {
            (r or 0) / 255,
            (g or 0) / 255,
            (b or 0) / 255,
            (a or 100) / 100
        }
    end
    
    
    return api
end