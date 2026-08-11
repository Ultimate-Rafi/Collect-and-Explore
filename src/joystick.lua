
-- ==================== Joystick =========================
local joystick = {}
function joystick.init(player)
    joystick.base_x = screen.pa.w * 140 / 841
    joystick.base_y = screen.pa.h * (387 - 140) / 387   -- will be set after window created
    joystick.knob_x = joystick.base_x
    joystick.knob_y = joystick.base_y
    joystick.radius = 67
    joystick.dead_zone = player.minspeed / player.speed
end
joystick.x = 0
joystick.y = 0
joystick.touch_id = nil

function update_joystick(touch_x, touch_y)
    local dx = touch_x - joystick.base_x
    local dy = touch_y - joystick.base_y
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist > joystick.radius then
        dx = dx / dist * joystick.radius
        dy = dy / dist * joystick.radius
        dist = joystick.radius
    end

    joystick.knob_x = joystick.base_x + dx
    joystick.knob_y = joystick.base_y + dy

    local norm = dist / joystick.radius
    if norm < joystick.dead_zone then
        joystick.x, joystick.y = 0, 0
    else
        joystick.x = dx / joystick.radius
        joystick.y = dy / joystick.radius
    end
end

-- ==================== Keyboard simulation ==============
-- Map arrow keys / WASD to joystick x,y values

function joystick.key_in()
    local x = 0
    local y = 0
    if love.keyboard.isDown("left")  or love.keyboard.isDown("a") then x = x - 1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then x = x + 1 end
    if love.keyboard.isDown("up")    or love.keyboard.isDown("w") then y = y - 1 end
    if love.keyboard.isDown("down")  or love.keyboard.isDown("s") then y = y + 1 end
    -- Normalize to length <= 1
    local len = math.sqrt(x*x + y*y)
    if len > 0 then
        x, y = x/len, y/len
    end
    joystick.x = x
    joystick.y = y
end

return joystick