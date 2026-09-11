local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId

local scripts = {
    [17738127017] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/brace.lua",
    [129870876180628] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/guess.lua",
    [139988436996662] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/stopthetimer.lua",
    [574407221] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/superherotycoon.lua",
    [132640332499066] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/anarchy.luau",
    [5938036553] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/frontlines.luau",
    [110808833601416] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/cham.lua",
    [76822114837453] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/war.luau"
    [7796842481] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/riotfall.luau"
}

local url = scripts[placeId]

if not url then
    player:Kick("Game not supported.")
    return
end

local source = game:HttpGet(url)

local func, loadError = loadstring(source)

if not func then
    warn("Could not load script:", loadError)
    return
end

local success, runError = xpcall(func, function(err)
    return debug.traceback(err)
end)

if not success then
    warn("Loaded script crashed:")
    warn(runError)
end
