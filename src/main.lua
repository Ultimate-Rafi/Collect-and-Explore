require("utility")
settings = require("settings")
screen = settings.screen
const = settings.const
colors = settings.colors

local player = require("player")
local collectible = require("collectible")
local entity = require("entity")
local joystick = require("joystick")
local button = require("button")
local inventory = require("inventory")
local menu = require("menu")

local api = require("api")
local mods = require("mods")

local draw = {
    txt = {}
}

vars = {
    dt = 0
}

-- ==================== Scoring & Save ===================




-- ==================== LÖVE callbacks ====================
function love.load()
    fps = 0
    fpst = {}
    love.math.setRandomSeed(os.time())
    math.randomseed(os.time())
    -- Adjust joystick base position after window resize
    
    screen.init()
    
    assert(const, "const is nil!")
    player.init()
    joystick.init(player)
    
    local game = {
        default = {},
        screen = screen,
        const = const,
        colors = colors,
        collectible = collectible,
        button = button,
        menu = menu,
        player = player,
        inventory = inventory,
        draw = draw,
        vars = vars
    }
    
    api = api(game)
    
    mods.load(api)
    --mods.load(api)

--[[error(
    "AFTER MOD LOAD\n" ..
    "menu.list.game = " .. tostring(menu.list.game) ..
    "\ngame buttons = " .. tostring(
        menu.list.game and menu.list.game.buttons
    )
)]]
    --data.init(player, collectible, entity, joystick, button, menu)
    
    -- Try to load save, else fresh start
    --load_game()
end

function love.update(dt)
    
    vars.dt = dt
    
    if menu.current.joystick then
        -- Keyboard input (if no touch active)
        if joystick.touch_id == nil then
            joystick.key_in()
        end
        -- Move player with speed and joystick
        player.x = player.x + player.speed * joystick.x * dt
        player.y = player.y + player.speed * joystick.y * dt
        
        -- Clamp to play area (keep inside green, touching border allowed)
        player.x = math.max(player.rad, math.min(screen.pa.w - player.rad, player.x))
        player.y = math.max(player.rad, math.min(screen.pa.h - player.rad, player.y))
    end
    
    if menu.current.collectible then
        -- Spawn coins
        collectible:spawn(dt, player)
        collectible:collect(player, inventory)
    end
    
    
    fpst[#fpst + 1] = 1/ dt
    
    if #fpst > 30 then table.remove(fpst, 1) end
    
    fps = 0
    for _, t in ipairs(fpst) do
        fps = fps + t
    end
    
    fps = fps / #fpst
    
    --assert(menu.current.buttons, table.concat(menu.current, "\n"))
    --for name, untouch in pairs(button.untouch) do
    
    for name in pairs(menu.current.buttons) do
        local butt = button.list[name]
        if button.untouch[name] then
            if butt.act_i then
                butt.act_i(butt.attributes)
                --button.untouch[name] = false
            end
        else
            if butt.act_h then
                butt.act_h(butt.attributes)
            end
        end
    end
end


function love.draw()
    local line = 0
    local font_size = love.graphics.getFont():getHeight()
    
    if menu.current.world then
        -- Draw play area background (green)
        love.graphics.setColor(colors.grass)
        love.graphics.rectangle("fill", 0, 0, screen.pa.w, screen.pa.h)
        
        -- Draw red border (4 rectangles)
        love.graphics.setColor(colors.border)
        local border_thick = 4
        love.graphics.rectangle("fill", 0, 0, screen.pa.w, border_thick)   -- top
        love.graphics.rectangle("fill", 0, screen.pa.h - border_thick, screen.pa.w, border_thick)  -- bottom
        love.graphics.rectangle("fill", 0, 0, border_thick, screen.pa.h)   -- left
        love.graphics.rectangle("fill", screen.pa.w - border_thick, 0, border_thick, screen.pa.h)  -- right
        
    -- Draw collctibles
        for _, c in ipairs(collectible.spawned) do
            love.graphics.setColor(collectible.types.name[c.name].color)
            --love.graphics.setColor(c.color)
            love.graphics.circle("fill", c.x, c.y, collectible.types.name[c.name].size)
        end
    end
    
    if menu.current.player then
        -- Draw player
        love.graphics.setColor(colors.player)
        love.graphics.circle("fill", player.x, player.y, player.rad)
    end
    
    if menu.current.joystick then
        -- Draw joystick
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.circle("fill", joystick.base_x, joystick.base_y, joystick.radius)
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.circle("fill", joystick.knob_x, joystick.knob_y, joystick.radius * 0.4)
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    -- Buttons
    for name in pairs(menu.current.buttons) do
        --assert(name, "nope its not it")
        local butt = button.list[name]
        
        --error(butt, butt.id, butt.x, butt.y, butt.width, butt.height)
        --assert(butt, "butt it is. "..name)
        
        love.graphics.setColor(colors.buttback)
        love.graphics.rectangle("fill", butt.x, butt.y, butt.width, butt.height)
        
        love.graphics.setColor(colors.button)
        love.graphics.rectangle("fill", butt.x + 5, butt.y + 5, butt.width - 10, butt.height - 10)
        
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.printf(butt.txt, butt.x, butt.y + (butt.height - font_size)/2, butt.width, "center")
    end
    --love.graphics.print("f3: " .. tostring(f3) .. "\nhud: " .. tostring(menu.current.hud), 10, 10)
    -- Draw HUD (score, etc.)
    if const.f3 and menu.current.hud then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(string.format("XY: %d, %d \nFPS: %d \nCoins: %d", math.floor(player.x/20 + 0.5), math.floor(player.y/20 + 0.5), fps, #collectible.spawned), 10, line * font_size + 10)
        line = line + 3
        
        for _, txt in pairs(draw.txt) do
            love.graphics.print(txt, 10, 10 + line * font_size)
            line = line + 1
        end
        --draw.txt = {}
        
        line = line + 1
        
        for _, name in ipairs(player.inv_order) do
            count = player.inventory[name]
            if count and count > 0 then
                love.graphics.print(name..": "..count, 10, 10 + line * font_size)
                line = line + 1
            end
        end
    end
    
   -- assert(not inventory.is_opened, "opened")
    
    if inventory.is_opened then
        --[[love.graphics.setColor(rgb(25, 25, 25))
        love.graphics.rectangle("fill", screen.pa.w * 0.15 + 3, screen.pa.h * 0.15 + 2, screen.pa.w * 0.7, screen.pa.h * 0.7)
        
        love.graphics.setColor(rgb(55, 55, 55))
        love.graphics.rectangle("fill", screen.pa.w * 0.17, screen.pa.h * 0.2, screen.pa.w * 0.66, screen.pa.h * 0.6)
        
        
        love.graphics.setColor(rgb(105, 105, 105))
        love.graphics.rectangle("fill", screen.pa.w * 0.185, screen.pa.h * 0.23, screen.pa.w * 0.63, screen.pa.h * 0.54)
        
        local size = 50
        for i = screen.pa.h * 0.25, screen.pa.h * 0.75 - size, 1.1 * size do
            for j = screen.pa.w * 0.2, screen.pa.w * 0.8 - size, 1.1 * size do
                love.graphics.setColor(rgb(35, 35, 35))
                love.graphics.rectangle("fill", j, i, size, size)
            end
        end]]
        local inv = inventory.opened
        local pad1 = 0.1
        local pad3 = 0.64
        
        
        local pad2 = (1 - 2 * pad1) * inv.slot.size
        pad1 = inv.slot.size * pad1
        
        -- slots
        for y = inv.lcy + inv.slot.size, inv.slot.y * inv.slot.size + inv.lcy, inv.slot.size do
            for x = inv.lcx + inv.slot.size, inv.lcx + inv.slot.x * inv.slot.size, inv.slot.size do
                
                if inv.selected and inv.selected.x == math.floor((x - inv.lcx) / inv.slot.size) and inv.selected.y == math.floor((y - inv.lcy) / inv.slot.size)then
                    love.graphics.setColor(1, 1, 1, 1) -- highlight for selected slot
                else
                    love.graphics.setColor(0,0,0, 1)
                end
                love.graphics.rectangle("fill", x, y, inv.slot.size, inv.slot.size)
                
                love.graphics.setColor(rgb(100,100,100,1))
                love.graphics.rectangle("fill", x + pad1, y + pad1, pad2, pad2)
                
                local slot = inv.slots[(y - inv.lcy) / inv.slot.size][(x - inv.lcx) / inv.slot.size]
                if slot.item then
                    love.graphics.setColor(collectible.types.name[slot.item].color)
                    
                    if inv.selected and inv.selected.x == math.floor((x - inv.lcx) / inv.slot.size) and inv.selected.y == math.floor((y - inv.lcy) / inv.slot.size)then
                        love.graphics.circle("fill", x + inv.slot.size / 2, y + inv.slot.size / 2, collectible.types.name[slot.item].size + const.cell_size * 0.1)
                    else
                        love.graphics.circle("fill", x + inv.slot.size / 2, y + inv.slot.size / 2, collectible.types.name[slot.item].size)
                    end
                    
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.print(slot.count, x + inv.slot.size * pad3, y + inv.slot.size * pad3)
                end
            end
        end
        --[[ selected slot
        if inv.selected then
            
            love.graphics.setColor(collectible.types.name[slot.item].color)
            love.graphics.circle("fill", inv.selected.x + inv.slot.size / 2, inv.selected.y + inv.slot.size / 2, collectible.types.name[slot.item].size + 0.1 * const.cell_size)
        end]]
        
     --   love.graphics.setColor(rgb(25, 25, 25))
  --      love.graphics.rectangle("fill", screen.pa.w * 0.15 + 4, screen.pa.h * 0.15 + 3, screen.pa.w * 0.7, screen.pa.h * 0.7)
        
    end
    
end

-- ==================== Touch handlers (joystick) =========
function love.touchpressed(id, x, y)
    local dx = x - joystick.base_x
    local dy = y - joystick.base_y
    if math.sqrt(dx*dx + dy*dy) < joystick.radius * 1.5 and menu.current.joystick then
        joystick.touch_id = id
        update_joystick(x, y)
    elseif button:set_touch(id, x, y, menu.current.buttons) then
    end
end

function love.touchmoved(id, x, y)
    if id == joystick.touch_id and menu.current.joystick then
        update_joystick(x, y)
    end
    local name = button.touch[id]
    
    --if name and button.list[name].act_h and menu.current.buttons[name] then
        --button.list[name]:act_h(button.list[name].attributes)
  --  end

end

function love.touchreleased(id)
    if id == joystick.touch_id then
        joystick.touch_id = nil
        joystick.x, joystick.y = 0, 0
        joystick.knob_x, joystick.knob_y = joystick.base_x, joystick.base_y
    elseif button.touch[id] then
        button:set_release(id)
    end
end
function love.keypressed(key)
    if key == "f3" then
        const.f3 = not const.f3
        --[[if f3 then
            f3 = true
        else
            f3 = false
        end]]
    end
end

-- ==================== Exit handling =====================
function love.quit()
    player.last_score = player.score
    --save_game()
end

-- ==================== Simple table serialisation ========
-- (used by save/load)
