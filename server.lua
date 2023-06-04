ESX = nil

local author = "Roby"
local scriptName = "r-z_starterpack"

AddEventHandler('playerConnecting', function()
    local playerName = GetPlayerName(source)

    if author == "Roby" and GetCurrentResourceName() == scriptName then
        TriggerClientEvent('r-z_starterpack:ShowStarterPack', source)
    else
        print("Invalid script author or script name!")
        DropPlayer(source, "Invalid script author or script name!")
    end
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Event triggered when the player collects the starter pack
RegisterServerEvent('r-z_starterpack:Collect')
AddEventHandler('r-z_starterpack:Collect', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Give the player the starter pack items
    xPlayer.addInventoryItem('phone', 1)
    xPlayer.addMoney(500)
    xPlayer.addInventoryItem('lockpick', 1)
end)
