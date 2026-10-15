local MAIN_URL = "https://vampauth.com/api/projects/badcdb1d-4743-455c-9134-1824725f7105/scripts/bsnoic"
local ONYX_URL = "https://raw.githubusercontent.com/onyxuilibrary/onyx-ui/main/source.lua"

local function runMain()
    loadstring(game:HttpGet(MAIN_URL))()
end

local REQUIRED_OTHS = { "hook", "unhook", "get_root_callback", "is_hook_thread", "get_original_thread" }

local function getOthLib()
    local ok, lib = pcall(function() return oth end)
    if ok and typeof(lib) == "table" then
        return lib
    end
    local env = getgenv and getgenv() or nil
    if env and typeof(env.oth) == "table" then
        return env.oth
    end
    return nil
end

local function missingOthFunctions()
    local lib = getOthLib()
    if not lib then
        return REQUIRED_OTHS 
    end
    local missing = {}
    for _, name in ipairs(REQUIRED_OTHS) do
        if typeof(lib[name]) ~= "function" then
            table.insert(missing, "oth." .. name)
        end
    end
    return missing
end

local missing = missingOthFunctions()
if #missing == 0 then
    runMain()
    return
end

local executorName = "Unknown"
pcall(function()
    if typeof(identifyexecutor) == "function" then
        executorName = tostring(identifyexecutor())
    end
end)

local missingList = table.concat(missing, ", ")
local warningContent = "Your executor (" .. executorName .. ") does NOT support the `oth` function library.\n\n"
    .. "Missing: " .. missingList .. "\n\n"
    .. "Without `oth` hooking this script cannot hide itself properly and therefore might get DETECTED and get your account BANNED.\n\n"
    .. "Continuing is at your own risk."

local function fallbackWarning()
    local parent = nil
    pcall(function()
        if typeof(gethui) == "function" then
            parent = gethui()
        end
    end)
    if not parent then
        parent = game:GetService("CoreGui")
    end
    pcall(function()
        local old = parent:FindFirstChild("OthWarningFallback")
        if old then
            old:Destroy()
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "OthWarningFallback"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999
    pcall(function()
        if typeof(protectgui) == "function" then
            protectgui(gui)
        end
    end)
    gui.Parent = parent

    local shade = Instance.new("Frame")
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.new(0, 0, 0)
    shade.BackgroundTransparency = 0.35
    shade.BorderSizePixel = 0
    shade.Parent = gui

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromOffset(480, 340)
    panel.BackgroundColor3 = Color3.fromRGB(20, 8, 10)
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Draggable = true
    panel.Parent = shade

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 40, 40)
    stroke.Thickness = 3
    stroke.Parent = panel

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(24, 16)
    title.Size = UDim2.new(1, -48, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.Text = "⚠ UNSUPPORTED EXECUTOR"
    title.TextColor3 = Color3.fromRGB(255, 70, 70)
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = panel

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(24, 62)
    body.Size = UDim2.new(1, -48, 0, 180)
    body.Font = Enum.Font.Gotham
    body.Text = warningContent
    body.TextWrapped = true
    body.TextColor3 = Color3.fromRGB(235, 235, 235)
    body.TextSize = 14
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.Parent = panel

    local function makeButton(text, x, color)
        local b = Instance.new("TextButton")
        b.Position = UDim2.fromOffset(x, 262)
        b.Size = UDim2.fromOffset(206, 48)
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 15
        b.Parent = panel
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = b
        return b
    end

    local quit = makeButton("Quit", 24, Color3.fromRGB(44, 52, 70))
    local cont = makeButton("Continue (RISKY)", 250, Color3.fromRGB(200, 30, 30))

    quit.Activated:Connect(function()
        gui:Destroy()
    end)
    cont.Activated:Connect(function()
        gui:Destroy()
        runMain()
    end)
end

local ok, Onyx = pcall(function()
    return loadstring(game:HttpGet(ONYX_URL))()
end)
if not ok or not Onyx then
    fallbackWarning()
    return
end

local window
local okWin, winErr = pcall(function()
    window = Onyx:CreateWindow({
        name = "Security Warning",
        subtitle = "Unsupported executor",
        settingsTab = false,
        showPill = false,
    })
end)
if not okWin or not window then
    fallbackWarning()
    return
end

window:Popup({
    title = "⚠ UNSUPPORTED EXECUTOR",
    content = warningContent,
    dismissable = false,
    options = {
        {
            text = "Quit",
            style = "neutral",
            callback = function()
                pcall(function()
                    window:Unload()
                end)
            end,
        },
        {
            text = "Continue (RISKY)",
            style = "danger",
            callback = function()
                pcall(function()
                    window:Unload()
                end)
                runMain()
            end,
        },
    },
})
