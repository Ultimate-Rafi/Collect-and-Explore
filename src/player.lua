


-- ==================== Player ===========================
player = {
    speed = 250,        -- pixels per second
    minspeed = 50,      -- not used here, kept for compatibility
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
player.x = pa.w / 2
player.y = pa.h / 2
player.rad = cell_size * 0.7




