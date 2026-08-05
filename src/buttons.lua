
-- Buttons
button = {
    touch = {},
    untouch = {},
    list = {},
}
function button.set_touch(self, id, x, y, list)
    for name, button in pairs(self.list) do
        if button.sx < x and button.sy < y and button.ex > x and button.ey > y then
            if not list[name] then return end
            self.touch[id] = name
            self.untouch[name] = false
            button:act_t() --add params, fix
            return
        end
    end
end


