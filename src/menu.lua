local menu = {
    current = {}, -- contains data for the current menu / window
    default = { -- the default menu / window
        joystick = true,
        player = true,
        world = true,
        hud = true,
        buttons = {
            "f3"
        }
    },
    list = {} -- contains every menu / window
}
menu.current = menu.default
return menu

