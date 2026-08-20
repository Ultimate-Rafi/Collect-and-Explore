
-- Buttons
local button = {
    touch = {},
    untouch = {},
    list = {},
}
function button.set_touch(self, id, x, y, list)
    for name in pairs(list) do
        butt = self.list[name]
        if butt.x < x and butt.y < y and (butt.x + butt.width) > x and (butt.y + butt.height) > y then
           
            self.touch[id] = name
            self.untouch[name] = false
            
            if butt.act_t then
                butt.act_t(butt.attributes) --add params, fix
            end
            
            return
        end
    end
end

function button.set_release(self, id)
    local name = self.touch[id]

    if not name then return end

    local butt = self.list[name]

    if butt.act_r then
        butt.act_r(butt.attributes)
    end

    self.untouch[name] = true
    self.touch[id] = nil
end


return button