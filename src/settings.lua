
-- ==================== Game settings, Config ====================
local screen = {
    grid = {
        w, h = 2, 2
    },
    pa = {
        w, h = 2, 2
    }
}

local const = {
    cell_size = 20,          -- pixels per cell
    rng_offset = 8, -- accuracy to _ digits after decimal point
    spawn_boost = 90,
    f3 = true
}
const.rng_offset = 10 ^ const.rng_offset

screen.init = function()
    screen.grid.h, screen.grid.w = math.floor(love.graphics.getHeight() / 20), math.floor(love.graphics.getWidth() / 20)
    screen.grid.s = math.floor(math.sqrt(screen.grid.h^2 + screen.grid.w^2))
    screen.pa.w = screen.grid.w * const.cell_size
    screen.pa.h = screen.grid.h * const.cell_size
end

-- ==================== colors ==========================
local colors = {
    undefined = rgb(0, 0, 0, 0),
    button = rgb(113, 113, 113, 0.8),
    buttback = rgb(163, 163, 163, 0.6),
    grass   = {0.2, 0.8, 0.2, 1},
    border  = {0.8, 0.2, 0.2},
    player  = {0.2, 0.4, 0.8}
}


return {screen = screen,
    const = const,
    colors = colors
}
