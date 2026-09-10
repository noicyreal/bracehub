local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId

local scripts = {
    [17738127017] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/brace.lua",
    [83443937211921] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/guess.lua",
    [139988436996662] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/stopthetimer.lua",
    [574407221] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/superherotycoon.lua",
    [132640332499066] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/anarchy.luau",
    [5938036553] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/frontlines.luau",
    [110808833601416] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/cham.lua"
}

local url = scripts[placeId]

if url then
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Failed to load script:", err)
    end
else
    player:Kick("Game not supported.")
end
