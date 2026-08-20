
local inventory = {
    list = {},
    opened = {},
    
}

inventory.add = function(self, id, item, count, max)
    local inv = self.list[id]
    
    local slots = inv.slots
    
    local rem = count -- remaining
    
    for y, row in ipairs(slots) do
        for x, slot in ipairs(row) do
            if not slot.item or slot.item == item and (slot.count or 0) < max and rem > 0 then
                slot.item = item
                rem = rem - (max - (slot.count or 0))
                slot.count = math.min(max, (slot.count or 0) + count)
                if rem <= 0 then
                    return true
                    --error("here")
                end
            end
        end
    end
    
    if rem > 0 then
        error("You Won")
        return false
    end
end

inventory.interect = function(inv, from_x, from_y, to_x, to_y)
    
    
    
end
--[[

+ 10

max = 60


57 + 3
rem <- 7

58 + 2

0 + 5


example slots internal

slots = {
    [1] = {
        [1] = {
            item = "gold",
            count = 10
            fragment = 0 -- if something drop as decimal, skipping for now
        },
    }
}
]]

return inventory
