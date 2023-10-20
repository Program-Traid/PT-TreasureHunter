local QBCore = exports['qb-core']:GetCoreObject()
local TreasureHunter
local ListingOpted = false
local Targets = {}
local Objects = {}
local Blips = {}


local function SetDefaultTargets()
    lib.requestModel(Config.TreasureHunter.model, 500)
    TreasureHunter = CreatePed(2, Config.TreasureHunter.model, Config.TreasureHunter.coords.x, Config.TreasureHunter.coords.y, Config.TreasureHunter.coords.z-1, Config.TreasureHunter.coords.w, false, false)
    SetPedFleeAttributes(TreasureHunter , 0, 0)
    SetPedDiesWhenInjured(TreasureHunter , false)
    SetPedKeepTask(TreasureHunter , true)
    SetBlockingOfNonTemporaryEvents(TreasureHunter , true)
    SetEntityInvincible(TreasureHunter , true)
    FreezeEntityPosition(TreasureHunter , true)
    TaskStartScenarioInPlace(TreasureHunter , "WORLD_HUMAN_CLIPBOARD", 0, true)

    Targets["TreasureHunter"] = exports.ox_target:addLocalEntity(TreasureHunter, {
        {
            name = 'TreasureHuntingStart',
            event = 'PT-TreasureHunter:client:OpenStarterMenu',
            icon = "fa-solid fa-clipboard",
            label = "Treasure Hunting Options",
        }
    })

    if Config.TreasureHunterBlip then
        Blips["TreasureHunterBlip"] = AddBlipForCoord(Config.TreasureHunter.coords.x, Config.TreasureHunter.coords.y, Config.TreasureHunter.coords.z)
        SetBlipSprite(Blips["TreasureHunterBlip"], Config.TreasureHunterBlipSettings.sprite)
        SetBlipScale(Blips["TreasureHunterBlip"], Config.TreasureHunterBlipSettings.scale)
        BeginTextCommandSetBlipName('STRING')
        SetBlipAsShortRange(Blips["TreasureHunterBlip"], true)
        AddTextComponentString(Config.TreasureHunterBlipSettings.name)
        EndTextCommandSetBlipName(Blips["TreasureHunterBlip"])
    end

end

local function ResetTargets()
    --for _, v in pairs(Peds) do DeletePed(v) end
    for k in pairs(Targets) do exports.ox_target:removeZone(k) end
    for k in pairs(Objects) do
        DeleteObject(Objects[k])
    end
	for i = 1, #Blips do RemoveBlip(Blips[i]) end
end
-----------------------
-- EVENTS/FUNCTIONS --
-----------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SetDefaultTargets()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    ResetTargets()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    SetDefaultTargets()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    ResetTargets()
end)



RegisterNetEvent('PT-TreasureHunter:client:OpenStarterMenu', function()
    local menu = {}
    menu[#menu+1] = {
        title = "Treasure Hunt (Solo)",
        icon = "fa-solid fa-coins",
        iconColor = "yellow",
        description = "Treasure Hunt solo without anyone else interfering!",
        disabled = true,
        event = "PT-TreasureHunter:client:OpenStarterMenu",
    }
    if not ListingOpted then
        menu[#menu+1] = {
            title = "Join Treasure Hunting Club (THC)",
            icon = "fa-solid fa-clipboard",
            iconColor = "green",
            description = "Join the roster to be notified when treasure is hidden!",
            event = "PT-TreasureHunter:client:ListingToggle",
        }
    else
        menu[#menu+1] = {
            title = "Leave Treasure Hunting Club (THC)",
            icon = "fa-solid fa-clipboard",
            iconColor = "red",
            description = "Leave the roster to be notified when treasure is hidden!",
            event = "PT-TreasureHunter:client:ListingToggle",
        }
    end
    lib.registerContext({
        id = "TreasureHunterStarter",
        title = "Treasure Hunter Options",
        onExit = function()
            ClearPedTasks(PlayerPedId())
        end,
        options = menu
    })
    lib.showContext("TreasureHunterStarter")
end)

RegisterNetEvent('PT-TreasureHunter:client:ListingToggle', function()
    ListingOpted = not ListingOpted

    if ListingOpted then
        TriggerEvent("PT-TreasureHunter:client:notify", "Treasure Hunting Club", "You've successfully joined the Treasure Hunting Club", "success", 4500)
    else
        TriggerEvent("PT-TreasureHunter:client:notify", "Treasure Hunting Club", "You've successfully left the Treasure Hunting Club", "error", 4500)
    end
    
end)

RegisterNetEvent('PT-TreasureHunter:client:NotifyTHCOfTournament', function()
    if ListingOpted then
        TriggerEvent("PT-TreasureHunter:client:notify", "Treasure Hunting Club", "Treasure has been hidden! Go find it!", "success", 4500)
    end
end)

RegisterNetEvent('PT-TreasureHunter:client:CreateTournamentChest', function(chestInformation)
    if ListingOpted then
        
        lib.requestModel(chestInformation.model)

        Objects[chestInformation.id] = CreateObject(chestInformation.model, chestInformation.coords.x, chestInformation.coords.y, chestInformation.coords.z-1, true, true, false)
        SetEntityHeading(Objects[chestInformation.id], chestInformation.coords.w)
        SetEntityCollision(Objects[chestInformation.id], true, true)
        FreezeEntityPosition(Objects[chestInformation.id], true)

        Targets["TournamentChest"] = exports.ox_target:addLocalEntity(Objects[chestInformation.id], {
            {
                name = 'TournamentChest',
                event = 'PT-TreasureHunter:client:TakeTournamentChest',
                icon = "fa-solid fa-coins",
                label = "Take Chest",
                args = chestInformation,
                distance = 6,
            }
        })

        
        Blips["TournamentBlip"] = AddBlipForCoord(chestInformation.blipcoords.x, chestInformation.blipcoords.y, chestInformation.blipcoords.z)
        SetBlipSprite(Blips["TournamentBlip"], Config.TournamentBlipSettings.sprite)
        SetBlipScale(Blips["TournamentBlip"], Config.TournamentBlipSettings.scale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.TournamentBlipSettings.name)
        EndTextCommandSetBlipName(Blips["TournamentBlip"])
        Blips["TournamentZone"] = AddBlipForRadius(chestInformation.blipcoords.x, chestInformation.blipcoords.y, chestInformation.blipcoords.z, Config.TournamentBlipSettings.radius)
        SetBlipColour(Blips["TournamentZone"], Config.TournamentBlipSettings.color)
        SetBlipAlpha(Blips["TournamentZone"], 40)
    end
end)

RegisterNetEvent("PT-TreasureHunter:client:TakeTournamentChest", function(chestInformation)
    exports.ox_target:removeLocalEntity("TournamentChest")
    TriggerServerEvent("PT-TreasureHunter:server:GiveTreasureChest", true)
    TriggerServerEvent("PT-TreasureHunter:server:DeleteChest", 1111)
end)

RegisterNetEvent("PT-TreasureHunter:client:ReceiveDeleteObject", function(id)
    -- if DoesEntityExist(Objects[id]) then
        for i = 255, 0, -51 do
            Wait(50)
            SetEntityAlpha(Objects[id], i, false)
        end
        DeleteObject(Objects[id])
    -- end
    Objects[id] = nil
    RemoveBlip(Blips["TournamentBlip"])
    RemoveBlip(Blips["TournamentZone"])
end)

RegisterNetEvent('PT-TreasureHunter:client:OpenTreasureHuntingChest', function(isTournamentChest)
    TriggerServerEvent('PT-TreasureHunter:server:GiveTreasureReward', isTournamentChest)
end)

RegisterNetEvent('PT-TreasureHunter:client:NotifyTournamentEnd', function()
    if ListingOpted then
        TriggerEvent("PT-TreasureHunter:client:notify", "Treasure Hunting Chest", "Chest wasn't found in time! Tournament has ended!", "error", 4500)
    end
end)

RegisterNetEvent('PT-TreasureHunter:client:NotifyTournamentChestFound', function()
    if ListingOpted then
        TriggerEvent("PT-TreasureHunter:client:notify", "Treasure Hunting Chest", "Chest was found! Tournament is over. Next one will be in "..Config.TournamentTimer.." minutes!", "error", 4500)
    end
end)

RegisterNetEvent("PT-TreasureHunter:client:notify", function(title, description, type, length)
    lib.notify({
        title = title,
        description = description,
        duration = length,
        type = type
    })
end)

