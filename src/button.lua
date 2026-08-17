
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
           -- if not list[name] then return end
            self.touch[id] = name
            self.untouch[name] = false
            butt:act_t() --add params, fix
            return
        end
    end
end


return button