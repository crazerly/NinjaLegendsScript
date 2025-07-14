-- Element perks have not been accounted for, you could add them from https://roblox-ninja-legends.fandom.com/wiki/Elements

totalCoinMultiplier = 70 -- default is 2x, 35x for Blazing Vortex sell area
totalNinjitsuMultiplier = 1
ninjitsuGain = nil -- ninjitsu per click
ninjitsuCapacity = nil

weapons = {}
weaponPrices = {}
belts = {}
beltPrices = {}
ranks = {}
rankPrices = {}

replicatedStorage = game:GetService("ReplicatedStorage")
localPlayer = game:GetService("Players").LocalPlayer
humanoidRootPart = localPlayer.Character.HumanoidRootPart
workspace = game:GetService("Workspace")

local farmingRanks = false
local farmingBoss = false
local farmingKOTH = false
local collectingCurrency = false
local collectingChests = false

local selectedBoss = 1

-- locations for islands
local islands = {
    CFrame.new(24.9437428, 3.42284107, 31.3425255),
    CFrame.new(23.7796173, 766.464355, -114.986168),
    CFrame.new(247.630554, 2014.16418, 347.963135),
    CFrame.new(164.294617, 4047.57397, 13.0581379),
    CFrame.new(198.758118, 5657.17432, 15.046277),
    CFrame.new(199.117706, 9285.17383, 12.7895298),
    CFrame.new(199.846329, 13680.0273, 15.2157841),
    CFrame.new(200.374817, 17686.3223, 14.6949396),
    CFrame.new(199.797852, 24070.0176, 13.5742025),
    CFrame.new(198.773453, 28256.2891, 8.53151321),
    CFrame.new(198.139313, 33206.9766, 8.4654789),
    CFrame.new(197.039246, 39317.5703, 9.65446663),
    CFrame.new(195.257996, 46010.5547, 8.2097511),
    CFrame.new(196.897415, 52607.7617, 9.33547592),
    CFrame.new(196.482971, 59594.6797, 8.77709198),
    CFrame.new(197.037781, 66669.1641, 8.56139851),
    CFrame.new(198.745728, 70271.1484, 7.23453999),
    CFrame.new(195.61586, 74442.8438, 10.963316),
    CFrame.new(196.569519, 79746.9844, 5.63692713),
    CFrame.new(196.813446, 83198.9844, 9.12857151),
    CFrame.new(197.976105, 87051.0703, 8.70048141),
    CFrame.new(196.035889, 91246.0703, 8.3484602)
}

-- GUI for script
local gui = Instance.new("ScreenGui")
gui.Name = "NinjaLegendsScript"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "Ninja Legends Script"
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local exitBtn = Instance.new("TextButton")
exitBtn.Text = "X"
exitBtn.Size = UDim2.new(0, 40, 0, 40)
exitBtn.Position = UDim2.new(1, -40, 0, 0)
exitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.BorderSizePixel = 0
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 20
exitBtn.Parent = mainFrame
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -140, 1, -40)
contentFrame.Position = UDim2.new(0, 140, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local pages = {
    Farming = Instance.new("Frame"),
    Teleports = Instance.new("Frame")
}

for name, page in pairs(pages) do
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.BorderSizePixel = 0
    page.Parent = contentFrame
end

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end
end

local function createSidebarButton(text, yOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = sidebar
    return btn
end

local function createToggle(parent, text, yOffset)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, 20, 0, yOffset)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local toggle = Instance.new("TextButton")
    toggle.Text = "OFF"
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = UDim2.new(1, -80, 0, yOffset)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.Parent = parent

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    end)
    return toggle
end

local function createDropdown(parent, text, options, yOffset)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, 20, 0, yOffset)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.BorderSizePixel = 0
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local selected = Instance.new("TextButton")
    selected.Text = options[1]
    selected.Size = UDim2.new(0, 200, 0, 30)
    selected.Position = UDim2.new(1, -220, 0, yOffset)
    selected.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    selected.TextColor3 = Color3.fromRGB(255, 255, 255)
    selected.BorderSizePixel = 0
    selected.Font = Enum.Font.Gotham
    selected.TextSize = 14
    selected.Parent = parent

    local dropdownFrame = Instance.new("ScrollingFrame")
    dropdownFrame.Size = UDim2.new(0, 200, 0, 0)
    dropdownFrame.Position = UDim2.new(1, -220, 0, yOffset + 30)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    dropdownFrame.Visible = false
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.ScrollBarThickness = 6
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    dropdownFrame.Parent = parent

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = dropdownFrame

    local expanded = false
    local function toggleDropdown()
        expanded = not expanded
        dropdownFrame.Visible = expanded
        local height = math.min(#options, 5) * 30
        dropdownFrame.Size = expanded and UDim2.new(0, 200, 0, height) or UDim2.new(0, 200, 0, 0)
    end

    selected.MouseButton1Click:Connect(toggleDropdown)

    for i, opt in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        item.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.BorderSizePixel = 0
        item.Font = Enum.Font.Gotham
        item.TextSize = 14
        item.Text = opt
        item.Parent = dropdownFrame

        item.MouseButton1Click:Connect(function()
            selected.Text = opt
            if text == "Teleport to: " then
                local islandCFrame = islands[i]
                humanoidRootPart.CFrame = islandCFrame
            elseif text == "Select boss: " then
                selectedBoss = i
            end
            toggleDropdown()
        end)
    end
    return selected
end

-- farming options
local farmRanksToggle = createToggle(pages.Farming, "Farm Ranks", 20)
farmRanksToggle.MouseButton1Click:Connect(function()
    farmingRanks = not farmingRanks
    if farmingRanks then farmRank() end
end)
local farmKOTHToggle = createToggle(pages.Farming, "Farm KOTH", 60)
farmKOTHToggle.MouseButton1Click:Connect(function()
    farmingKOTH = not farmingKOTH
    if farmingKOTH then farmKOTH() end
end)
createDropdown(pages.Farming, "Select boss: ", {
    "Robot Boss",
    "Eternal Boss",
    "Ancient Magma Boss"
}, 100)
local farmBossToggle = createToggle(pages.Farming, "Farm Boss", 140)
farmBossToggle.MouseButton1Click:Connect(function()
    farmingBoss = not farmingBoss
    if farmingBoss then farmBoss() end
end)
local antiAFKToggle = createToggle(pages.Farming, "Anti-AFK", 180)
antiAFKToggle.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    if antiAFK then
        localPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- teleport options
local collectCurrencyToggle = createToggle(pages.Teleports, "Collect Coins/Chi", 20)
collectCurrencyToggle.MouseButton1Click:Connect(function()
    collectingCurrency = not collectingCurrency
    if collectingCurrency then collectCurrency() end
end)
local collectChestsToggle = createToggle(pages.Teleports, "Collect Chest Rewards", 60)
collectChestsToggle.MouseButton1Click:Connect(function()
    collectingChests = not collectingChests
    if collectingChests then collectChests() end
end)

-- tp to islands
local selectedIsland = createDropdown(pages.Teleports, "Teleport to: ", {
    "Ground",
    "Enchanted Island",
    "Astral Island",
    "Mystical Island",
    "Space Island",
    "Tundra Island",
    "Eternal Island",
    "Sandstorm",
    "Thunderstorm",
    "Ancient Inferno Island",
    "Midnight Shadow Island",
    "Mythical Souls Island",
    "Winter Wonder Island",
    "Golden Master Island",
    "Dragon Legend Island",
    "Cybernetics Legends Island",
    "Skystorm Ultraus Island",
    "Chaos Legends Island",
    "Soul Fusion Island",
    "Dark Elements Island",
    "Inner Peace Island",
    "Blazing Vortex Island"
}, 100)

local farmingBtn = createSidebarButton("Farming", 0)
local teleportBtn = createSidebarButton("Teleports", 40)

farmingBtn.MouseButton1Click:Connect(function()
    showPage("Farming")
end)
teleportBtn.MouseButton1Click:Connect(function()
    showPage("Teleports")
end)

-- show default page
showPage("Farming")

-- sort weapons/belts/ranks by price
for _, island in pairs(replicatedStorage.Weapons:GetChildren()) do
    for _, weapon in pairs(island:GetChildren()) do
        table.insert(weaponPrices, weapon.price.Value)
    end
end
table.sort(weaponPrices)
for _, weaponPrice in pairs(weaponPrices) do
    for _, island in pairs(replicatedStorage.Weapons:GetChildren()) do
        for _, weapon in pairs(island:GetChildren()) do
            if weapon.price.Value == weaponPrice then
                table.insert(weapons, weapon.Name)
            end
        end
    end
end
for _, island in pairs(replicatedStorage.Belts:GetChildren()) do
    for _, belt in pairs(island:GetChildren()) do
        table.insert(beltPrices, belt.price.Value)
    end
end
table.sort(beltPrices)
for _, beltPrice in pairs(beltPrices) do
    for _, island in pairs(replicatedStorage.Belts:GetChildren()) do
        for _, belt in pairs(island:GetChildren()) do
            if belt.price.Value == beltPrice then
                table.insert(belts, belt.Name)
            end
        end
    end
end
for _, rank in pairs(replicatedStorage.Ranks.Ground:GetChildren()) do
    table.insert(rankPrices, rank.price.Value)
end
table.sort(rankPrices)
for _, rankPrice in pairs(rankPrices) do
    for _, rank in pairs(replicatedStorage.Ranks.Ground:GetChildren()) do
        if rank.price.Value == rankPrice then
            table.insert(ranks, rank.Name)
            break
        end
    end
end

function getPlayerWeaponIndex(weapons)
    for i, weapon in pairs(weapons) do
        if tostring(weapon) == tostring(localPlayer.equippedSword.Value) then
            currRankIndex = i
            return i
        end
    end
end

function getPlayerBeltIndex(belts)
    for i, belt in pairs(belts) do
        if tostring(belt) == tostring(localPlayer.equippedBelt.Value) then
            currRankIndex = i
            return i
        end
    end
end

function getPlayerRankIndex(ranks)
    for i, rank in pairs(ranks) do
        if tostring(rank) == tostring(localPlayer.equippedRank.Value) then
            currRankIndex = i
            return i
        end
    end
end

function getNinjitsuGain()
    for _, island in pairs(replicatedStorage.Weapons:GetChildren()) do
        for _, weapon in pairs(island:GetChildren()) do
            if (tostring(weapon) == tostring(localPlayer.equippedSword.Value)) then
                return weapon.ninjitsuGain.Value
            end
        end
    end
    print("Error: Weapon could not be found!")
    return math.huge
end

function getNinjitsuCapacity()
    for _, island in pairs(replicatedStorage.Belts:GetChildren()) do
        for _, belt in pairs(island:GetChildren()) do
            if (tostring(belt) == tostring(localPlayer.equippedBelt.Value)) then
                return belt.capacity.Value
            end
        end
    end
    print("Error: Belt could not be found!")
    return math.huge
end

function getLastBeltName(beltCapacity)
    for _, island in pairs(replicatedStorage.Belts:GetChildren()) do
        for _, belt in pairs(island:GetChildren()) do
            if belt.capacity.Value > beltCapacity then
                return belt.Name
            end
        end
    end
end

function getTotalCoinMultiplier()
    -- get pet multiplier
    totalPetMultiplier = 0
    for _, equippedPet in pairs(localPlayer.equippedPets:GetChildren()) do
        if equippedPet.Value ~= nil then
            for _, island in pairs(localPlayer.petsFolder:GetChildren()) do
                for _, ownedPet in pairs(island:GetChildren()) do
                    if tostring(ownedPet.Name) == tostring(equippedPet.Value) then
                        totalPetMultiplier = totalPetMultiplier + ownedPet.perksFolder.coins.Value
                    end
                end
            end
        end
    end
    totalCoinMultiplier = totalCoinMultiplier * totalPetMultiplier
end

function getTotalNinjitsuMultiplier()  -- not completely accurate
    -- get pet multiplier
    for _, equippedPet in pairs(localPlayer.equippedPets:GetChildren()) do
        if equippedPet.Value ~= nil then
            for _, island in pairs(localPlayer.petsFolder:GetChildren()) do
                for _, ownedPet in pairs(island:GetChildren()) do
                    if tostring(ownedPet.Name) == tostring(equippedPet.Value) then
                        totalNinjitsuMultiplier = totalNinjitsuMultiplier + ownedPet.perksFolder.ninjitsu.Value
                    end
                end
            end
        end
    end
    -- get shuriken multiplier
    for _, shuriken in pairs(replicatedStorage.Shurikens.Ground:GetChildren()) do
        if tostring(shuriken.Name) == tostring(localPlayer.equippedShuriken.Value) then
            totalNinjitsuMultiplier = totalNinjitsuMultiplier + shuriken.ninjitsuMultiplier.Value
            break
        end
    end
    -- get rank multiplier
    for _, rank in pairs(replicatedStorage.Ranks.Ground:GetChildren()) do
        if tostring(rank) == tostring(localPlayer.equippedRank.Value) then
            totalNinjitsuMultiplier = totalNinjitsuMultiplier + rank.multiplier.Value
            break
        end
    end
end

function farmRank()
    local currWeaponIndex = getPlayerWeaponIndex(weapons)
    local currBeltIndex = getPlayerBeltIndex(belts)
    local currRankIndex = getPlayerRankIndex(ranks)
    local ninjitsuCoinValue = 0
    local totalCoinValue = 0
    getTotalCoinMultiplier()
    getTotalNinjitsuMultiplier()
    while true do
        local lastWeaponIndex = 0
        local lastBeltIndex = 0
        for i, weaponPrice in pairs(weaponPrices) do
            if weaponPrice > rankPrices[currRankIndex+1]/2 then
                lastWeaponIndex = i - 1
                break
            end
        end
        for _, island in pairs(replicatedStorage.Weapons:GetChildren()) do
            for _, weapon in pairs(island:GetChildren()) do
                if tostring(weapon.Name) == tostring(weapons[lastWeaponIndex]) then
                    lastWeaponNinjitsuGain = weapon.ninjitsuGain.Value
                end
            end
        end
        -- untested, probably wrong values
        if currRankIndex < 10 then lastBeltName = getLastBeltName(200*lastWeaponNinjitsuGain*totalNinjitsuMultiplier)
        elseif currRankIndex < 20 then lastBeltName = getLastBeltName(500*lastWeaponNinjitsuGain*totalNinjitsuMultiplier)
        elseif currRankIndex < 30 then lastBeltName = getLastBeltName(5000*lastWeaponNinjitsuGain*totalNinjitsuMultiplier)
        elseif currRankIndex < 40 then lastBeltName = getLastBeltName(100000*lastWeaponNinjitsuGain*totalNinjitsuMultiplier)
        elseif currRankIndex < 50 then lastBeltName = getLastBeltName(10000000*lastWeaponNinjitsuGain*totalNinjitsuMultiplier) end
        for i, belt in pairs(belts) do
            if tostring(belt) == tostring(lastBeltName) then
                lastBeltIndex = i
                break
            end
        end
        while localPlayer.Coins.Value < rankPrices[currRankIndex+1] do
            -- update the weapon/belt values
            ninjitsuGain = getNinjitsuGain()
            ninjitsuCapacity = getNinjitsuCapacity()
            -- update weapon/belt index
            currWeaponIndex = getPlayerWeaponIndex(weapons)
            currBeltIndex = getPlayerBeltIndex(belts)
            totalCoinValue = localPlayer.Coins.Value
            -- autoclick until reached max capacity or you can buy a belt/weapon/rank with current ninjitsu + coins
            while localPlayer.leaderstats.Ninjitsu.Value < ninjitsuCapacity and totalCoinValue < (rankPrices[currRankIndex+1]) do
                local args = { "swingKatana" }
                localPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
                wait(math.random(4, 6) / 100)
                ninjitsuCoinValue = localPlayer.leaderstats.Ninjitsu.Value * totalCoinMultiplier -- the coin value of the player's current ninjitsu
                totalCoinValue = ninjitsuCoinValue + localPlayer.Coins.Value
                if not farmingRanks then return end
                if totalCoinValue > weaponPrices[currWeaponIndex+1] and currWeaponIndex < lastWeaponIndex then break end
                if totalCoinValue > beltPrices[currBeltIndex+1] and currBeltIndex < lastBeltIndex then break end
            end
            -- tp away and back to sell area
            humanoidRootPart.CFrame = CFrame.new(70, 50000, 150)
            wait(1)
            humanoidRootPart.CFrame = CFrame.new(82.8908844, 91248.7812, 129.965973)

            -- buy all swords & belts until it is better to just grind for next rank
            if currWeaponIndex < lastWeaponIndex then
                local args = { "buyAllSwords", "Blazing Vortex Island" }
                localPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            end
            if currBeltIndex < lastBeltIndex then
                local args = { "buyAllBelts", "Blazing Vortex Island" }
                localPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            end
            wait(1)
        end
        -- buy the next rank
        local args = { "buyRank", tostring(ranks[currRankIndex+1]) }
        localPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
        currRankIndex = currRankIndex + 1
        wait(2)
    end
    os.exit()
end

function farmBoss()
    while farmingBoss do
        if selectedBoss == 1 then
            humanoidRootPart.CFrame = workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame + Vector3.new(10, 10, 0)
        elseif selectedBoss == 2 then
            humanoidRootPart.CFrame = workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame + Vector3.new(10, 10, 0)
        elseif selectedBoss == 3 then
            humanoidRootPart.CFrame = workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame + Vector3.new(10, 10, 0)
        end
        local args = { "swingKatana" }
        localPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
        wait(math.random(4, 6) / 100)
    end
end


function farmKOTH()
    while farmingKOTH do
        humanoidRootPart.CFrame = CFrame.new(243.54985, 90.0248947, -289.285828, -0.763612151, -5.48724515e-08, 0.645675182, -2.88712663e-08)
        wait(0.2)
    end
end

function collectCurrency()
    while collectingCurrency do
        for _, piece in pairs(workspace.spawnedCoins.Valley:GetChildren()) do
            if not collectingCurrency then break end
            humanoidRootPart.CFrame = piece.CFrame
            wait(0.1)
        end
    end
end

function collectChests()
    localPlayer.Character:WaitForChild("Humanoid").PlatformStand = true
    humanoidRootPart.CFrame = workspace.ultraNinjitsuChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.mythicalChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.goldenChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.enchantedChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.magmaChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.saharaChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.thunderChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.ancientChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.midnightShadowChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.lightKarmaChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.evilKarmaChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.wonderChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.goldenZenChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.skystormMastersChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.chaosLegendsChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.soulFusionChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.eternalChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    wait(3)
    humanoidRootPart.CFrame = workspace.legendsChest.circleInner.CFrame + Vector3.new(0, 3, 0)
    localPlayer.Character:WaitForChild("Humanoid").PlatformStand = false
end
