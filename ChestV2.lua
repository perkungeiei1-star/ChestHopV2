--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlaceID, JobID = game.PlaceId, game.JobId
local API = "https://games.roblox.com/v1/games/"

--// Server Hop Function
local function GetServers(cursor)
    local raw = game:HttpGet(API .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=10" .. ((cursor and "&cursor="..cursor) or ""))
    return HttpService:JSONDecode(raw)
end

local function ServerHop()
    local servers = GetServers()
    if servers and servers.data and #servers.data > 0 then
        local srv = servers.data[math.random(1,#servers.data)]
        TeleportService:TeleportToPlaceInstance(PlaceID, srv.id, Player)
    end
end

--// Warp Points (ครบทุกจุด)
local Points = {
    CFrame.new(-35.25, 228.99998474121094, 2155.75),
    CFrame.new(767, 215.99998474121094, -1370.5),
    CFrame.new(-1240, 217.99998474121094, 621.5000610351562),
    CFrame.new(1793.904541015625, 236.99998474121094, 844.4024047851562),
    CFrame.new(88.5, 299.9999694824219, -916),
    CFrame.new(-37.5, 257, -1223.0001220703125),
    CFrame.new(119.5, 248.00001525878906, -1231.0001220703125),
    CFrame.new(1384.9998779296875, 223.99998474121094, -3491.5),
    CFrame.new(1263.0001220703125, 215.99998474121094, -3103.5),
    CFrame.new(1110.5, 223.99998474121094, -3449),
    CFrame.new(2026, 447.9999694824219, -753.5000610351562),
    CFrame.new(2203.29345703125, 215.9994354248047, -630.3720092773438),
    CFrame.new(-5260.00048828125, 302.9999694824219, -7772.5),
    CFrame.new(-1894.000244140625, 224.99998474121094, 3277.499755859375),
    CFrame.new(-1886, 224.99998474121094, 3312.499755859375),
    CFrame.new(-1910.0001220703125, 224.99998474121094, 3295.499755859375),
    CFrame.new(1166, 218.99990844726562, 3316.5),
    CFrame.new(1156, 218.99986267089844, 3316.5),
    CFrame.new(1161, 218.99990844726562, 3316.5),
    CFrame.new(-272.6213684082031, 254.99998474121094, -943.3788452148438),
    CFrame.new(114.5, 219.99998474121094, -247),
    CFrame.new(-246.6298370361328, 275.1282653808594, 349.3229675292969),
    CFrame.new(16.5, 219.99998474121094, 139),
    CFrame.new(-310.5000305175781, 221.99998474121094, -324.9999694824219),
    CFrame.new(108, 223.99998474121094, -36.5),
    CFrame.new(-212.00003051757812, 223.99998474121094, 20.5),
    CFrame.new(-253.59532165527344, 274.8800048828125, 357.8055725097656),
    CFrame.new(948, 215.99998474121094, 1210.5),
    CFrame.new(-4001, 215.99998474121094, -2187.5),
    CFrame.new(1857.457275390625, 217.99998474121094, 835.2762451171875),
    CFrame.new(1864.5281982421875, 217.99998474121094, 842.3472290039062),
    CFrame.new(1861.699462890625, 217.99998474121094, 838.1047973632812),
    CFrame.new(1855.4229736328125, 236.99998474121094, 905.9207763671875),
    CFrame.new(-246.54559326171875, 274.9999694824219, 349.9251708984375),
    CFrame.new(-246.46327209472656, 274.9999694824219, 356.0033874511719),
    CFrame.new(-251.27786254882812, 274.9999694824219, 353.1693115234375),
}

--// Helper: Get HRP safely
local function GetHRP()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
end

--// Force Warp
local function ForceWarp(cf)
    local tries = 0
    while tries < 5 do -- พยายามวาร์ปซ้ำสูงสุด 5 ครั้ง
        local hrp = GetHRP()
        if hrp then
            hrp.CFrame = cf
            return true
        end
        tries += 1
        task.wait(0.2)
    end
    return false
end

--// Warp Loop
local function WarpAll()
    for _, cf in ipairs(Points) do
        ForceWarp(cf)
        task.wait(0.05)
    end
    ServerHop()
end

-- Auto Respawn
local function SetupRespawn()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        Player.CharacterAdded:Wait()
        task.wait(2)
        WarpAll()
        SetupRespawn()
    end)
end

-- Init
SetupRespawn()
WarpAll()
