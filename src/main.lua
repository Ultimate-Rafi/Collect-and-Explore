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
local menu = require("menu")

local api = require("api")
local mods = require("mods")


-- ==================== Scoring & Save ===================




-- ==================== LÖVE callbacks ====================
function love.load()
    fps = 0
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
        player = player
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

    -- Spawn coins
    collectible:spawn(dt, player)
    collectible:collect(player)
    fps = 1 / dt
    
    assert(menu.current.buttons, table.concat(menu.current, "\n"))
    --for name, untouch in pairs(button.untouch) do
    for name, bool in pairs(menu.current.buttons) do
        local butt = button.list[name]
        if button.untouch[name] and butt.act_i then
            butt.act_i(butt.attributes)
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
        assert(name, "nope its not it")
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
        line = line + 4
        
        for _, name in ipairs(player.inv_order) do
            count = player.inventory[name]
            if count and count > 0 then
                love.graphics.print(name..": "..count, 10, 10 + line * font_size)
                line = line + 1
            end
            
        end
        
    end
end

-- ==================== Touch handlers (joystick) =========
function love.touchpressed(id, x, y)
    local dx = x - joystick.base_x
    local dy = y - joystick.base_y
    if math.sqrt(dx*dx + dy*dy) < joystick.radius * 1.5 and menu.current.joystick then
        joystick.touch_id = id
        update_joystick(x, y)
    end
    button:set_touch(id, x, y, menu.current.buttons)
end

function love.touchmoved(id, x, y)
    if id == joystick.touch_id and menu.current.joystick then
        update_joystick(x, y)
    end
    local name = button.touch[id]
    if name and button.list[name].act_h and menu.current.buttons[name] then
        button.list[name]:act_h()
    end
end

function love.touchreleased(id)
    if id == joystick.touch_id then
        joystick.touch_id = nil
        joystick.x, joystick.y = 0, 0
        joystick.knob_x, joystick.knob_y = joystick.base_x, joystick.base_y
    elseif button.touch[id] then
        button.untouch[button.touch[id]] = true
        button.touch[id] = nil
    end
end
function love.keypressed(key)
    if key == "f3" then
        f3 = not f3
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
