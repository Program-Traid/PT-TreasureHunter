local QBCore = exports['qb-core']:GetCoreObject()
local activeTournament = false
local chestInformation
local chestLocation
local chestObjects = {}

local function TriggerTournamentParameters()

    -- Select Chest Location
    TriggerEvent("PT-TreasureHunter:server:DeleteChest", 1111)
    chestInformation = Config.TreasureLocations[math.random(#Config.TreasureLocations)]
    chestLocation = chestInformation.spots[math.random(#chestInformation.spots)]
    chestObjects[1111] = { id = 1111, model = chestInformation.model, name = "TournamentChest" }
    TriggerClientEvent("PT-TreasureHunter:client:CreateTournamentChest", -1, { id = 1111, model = chestInformation.model, blipcoords = chestInformation.blip, coords = chestLocation, name = "TournamentChest" } )
    print(chestLocation)
    -- Sync with all players

end
local function TournamentTimer()
    TriggerEvent("PT-TreasureHunter:server:StartTournament")
end

RegisterNetEvent("PT-TreasureHunter:server:StartTournament", function()
    activeTournament = true
    TriggerClientEvent("PT-TreasureHunter:client:NotifyTHCOfTournament", -1)
    TriggerTournamentParameters()
    local sleep = Config.TournamentLength * 60 * 1000
    Wait(sleep)
    if activeTournament then
        TriggerEvent("PT-TreasureHunter:server:DeleteChest", 1111)
        TriggerClientEvent("PT-TreasureHunter:client:NotifyTournamentEnd", -1)
        ResetTournament()
    end
end)

RegisterNetEvent("PT-TreasureHunter:server:DeleteChest", function(chestid)
    chestObjects[chestid] = nil
    TriggerClientEvent("PT-TreasureHunter:client:ReceiveDeleteObject", -1, chestid)
end)

RegisterNetEvent("PT-TreasureHunter:server:GiveTreasureChest", function(isTournmentChest)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if isTournmentChest then
        Player.Functions.AddItem(Config.TournamentChestItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TournamentChestItem], "add")
        TriggerClientEvent("PT-TreasureHunter:client:NotifyTournamentChestFound", -1)
        ResetTournament()
    else
        Player.Functions.AddItem(Config.TreasureHuntingChestItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TreasureHuntingChestItem], "add")
    end
end)

RegisterNetEvent("PT-TreasureHunter:server:GiveTreasureReward", function(isTournmentChest)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if isTournmentChest then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TournamentChestItem], "remove")
        if Player.Functions.RemoveItem(Config.TournamentChestItem) then
            local amountOfItems = Config.TournamentChestLootTable.amountOfItems
            for i = 1, amountOfItems do
                local item
                local chance = math.random(1, 100)
                if chance <= Config.TournamentChestLootTable.rareChance then
                    item = Config.TournamentChestLootTable.rareProperties[math.random(#Config.TournamentChestLootTable.rareProperties)]
                    if Player.Functions.AddItem(item.name, item.amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", item.amount)
                    end
                else
                    item = Config.TournamentChestLootTable.normalProperties[math.random(#Config.TournamentChestLootTable.normalProperties)]
                    if Player.Functions.AddItem(item.name, item.amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", item.amount)
                    end
                end
            end
        else
            TriggerEvent("PT-TreasureHunter:client:notify", "Tournament Chest", "You were unable to crack open the chest!", "error", 4500)
        end
    else
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TreasureHuntingChestItem], "remove")
        if Player.Functions.RemoveItem(Config.TreasureHuntingChestItem) then
            local amountOfItems = Config.TournamentChestLootTable.amountOfItems
            for i = 1, amountOfItems do
                local item
                local chance = math.random(1, 100)
                if chance <= Config.TreasureHuntingChestLootTable.rareChance then
                    item = Config.TreasureHuntingChestLootTable.rareProperties[math.random(#Config.TreasureHuntingChestLootTable.rareProperties)]
                    if Player.Functions.AddItem(item.name, item.amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", item.amount)
                    end
                else
                    item = Config.TreasureHuntingChestLootTable.normalProperties[math.random(#Config.TreasureHuntingChestLootTable.normalProperties)]
                    if Player.Functions.AddItem(item.name, item.amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "add", item.amount)
                    end
                end
            end
        end
    end
end)


QBCore.Functions.CreateUseableItem(Config.TreasureHuntingChestItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('PT-TreasureHunter:client:OpenTreasureHuntingChest', src, item, false)
end)

QBCore.Functions.CreateUseableItem(Config.TournamentChestItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('PT-TreasureHunter:client:OpenTreasureHuntingChest', src, item, true)
end)

function ResetTournament()
    activeTournament = false
    TournamentLoop()
end

function TournamentLoop()
    local sleep = Config.TournamentTimer * 60 * 1000
    Wait(sleep)
    if not activeTournament then
        TournamentTimer()
    end
end

TournamentLoop()