-- Collectibles
api.set.default("collectible", {
    size = api.get.cell_size() * 0.4,
    mults = {},
    value = 1
})


api.new.collectible({
    name = "gold",
    color = api.rgb(247, 247,0, 100),
    chance = 10,
    inv_slot = "Gold"
})

api.new.collectible({
    name = "iron",
    color = api.rgb(240, 240, 240, 100),
    chance = 40,
    inv_slot = "Iron"
})

api.new.collectible({
    name = "amethyst",
    color = api.rgb(255, 0, 255, 100),
    chance = 3,
    inv_slot = "Amethyst"
})

api.new.collectible({
    name = "diamond",
    color = api.rgb(67, 255, 255, 100),
    chance = 0.01,
    inv_slot = "Diamond"
})

api.new.collectible({
    name = "obsidian",
    color = api.rgb(67, 0, 67),
    chance = 0.7,
    inv_slot = "Obsidian"
})

api.new.collectible({
    name = "mytheril",
    color = api.rgb(10, 60, 70),
    chance = 0.0001,
    inv_slot = "Mytheril",
    value = 0.25
})

api.set.inv_order({
    "Iron",
    "Gold",
    "Amethyst",
    "Obsidian",
    "Diamond",
    "Mytheril"
})

api.set.coll.spawn_rate(14)
api.set.coll.rolls(2)
api.set.coll.max(28)

-- Buttons

api.new.button({
    name = "f3",
    id = "vanilla:f3",
    x = api.get.screen.width() - 50,
    y = 3,
    height = 47,
    width = 47,
    txt = "f3",
    act_t = function()
        api.set.f3(not api.get.f3())
    end
})

-- Menus

api.new.menu("game", {"world", "player", "joystick", "hud"}, {"vanilla:f3"})


api.set.menu("game")


