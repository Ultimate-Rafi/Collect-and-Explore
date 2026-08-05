

local mod = {
    list = {}
}
mod.list["vanilla"] = love.filesystem.load("mods/vanilla")

function mod.load(api)
    
    for _, mod in pairs(mod.list) do
        setfenv(mod,{
            api = api,
            print = print,
            math = math,
            pairs = pairs,
            ipairs = ipairs,
            type = type,
            tostring = tostring,
            tonumber = tonumber,
            table = table
        })
    end
end

