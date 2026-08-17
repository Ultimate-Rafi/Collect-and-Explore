

local mods = {
    list = {}
}
mods.list["vanilla"], err = love.filesystem.load("mods/vanilla.lms")
if not mods.list.vanilla then
    error("Couldnt load vanilla"..tostring(err))
end
function mods.load(api)
    
    for _, mod in pairs(mods.list) do
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
        mod()
    end
end

return mods

