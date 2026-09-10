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
    [118367369949006] = "https://raw.githubusercontent.com/noicyreal/bracehub/main/war.luau"
}

local url = scripts[placeId]

if not url then
    player:Kick("Game not supported.")
    return
end

local success, err = pcall(function()
    local source = game:HttpGet(url)
    local scriptToRun = loadstring(source)

    if not scriptToRun then
        error("Couldn't load the script.")
    end

    scriptToRun()
end)

if not success then
    warn("Something went to shit:", err)
end
