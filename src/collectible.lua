-- ==================== Collectibles and items system ======================
local collectible = {
    spawn_rate = 67.6767,
    rolls = 2,
    types = {
        name = {},
        index = {}
    },
    spawned = {},
    occupied = {},
    max = 30
}

function collectible.spawn(self, dt, player)
    if math.random(1, 100 * const.rng_offset) > (self.spawn_rate * const.rng_offset * 60 * dt) or #self.spawned >= self.max then return end
    local type = nil
    local x, y = math.random(1, screen.grid.w), math.random(1, screen.grid.h)
    if self.occupied[x] and self.occupied[x][y] then return end
    
    local mult = {
        tb = 1,
        lr = 1,
        d = 1
    }
    if x == 1 or x == screen.grid.w then mult.tb = 10 end
    if y == 1 or y == screen.grid.h then mult.lr = 10 end
    mult.d = 10^(( 100 * math.sqrt( math.abs(player.x - x)^2 + math.abs(player.y - y)^2 ) / screen.grid.s - const.spawn_boost) / 10)
    -- add the collectibles
    local mul = 1
    for i = 1, self.rolls do
        local no = math.random(1, #self.types.index)
        local coll = self.types.index[no]
        mul = 1
        
        assert(coll.mults, "multiplier is nil? :"..coll.name)
        
        for m = 1, #(coll.mults) do
            mul = mul * mult[coll.mults[m]]
        end
        if math.random(1, 100 * const.rng_offset) <= coll.chance * const.rng_offset * mul then
            self.spawned[#self.spawned + 1] = {
                name = coll.name,
                x = x * const.cell_size,
                y = y * const.cell_size
            }
            self.occupied[x] = self.occupied[x] or {}
            self.occupied[x][y] = true
            return
        end
    end
    --return tostring(mult.d), ""
end

function collectible.collect(self, player, inventory)
    for i = #self.spawned, 1, -1 do
        c = self.spawned[i]
        cdata = self.types.name[c.name]
        if math.sqrt((player.x - c.x)^2 + (player.y - c.y)^2) <= (player.rad + self.types.name[c.name].size) then
            
            player.inventory[cdata.inv_slot] = (player.inventory[cdata.inv_slot] or 0) + cdata.value
            
            if inventory:add("vanilla:main_inventory", c.name, cdata.value, cdata.max) then
                
                table.remove(self.spawned, i)
                
                self.occupied[c.x] = self.occupied[c.x] or {}
                self.occupied[math.floor(c.x/ const.cell_size)][math.floor(c.y / const.cell_size)] = false
            end
        end
    end
end

return collectible



