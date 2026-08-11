


-- ==================== Player ===========================
local player = {
    speed = 250,        -- pixels per second
    minspeed = 50,
    inventory = {},
    inv_order = {
        "Sulfur",
        "Amethyst",
        "Iron",
        "Obsidian",
        "Diamond",
        "Mytherite"
    },
    score = 0
}
--print(type(screen), screen.pa.w)
function player.init()
    player.x = (screen.pa.w or 10)/ 2
    player.y = (screen.pa.h or 10) / 2
    player.rad = const.cell_size * 0.7
end

return player

